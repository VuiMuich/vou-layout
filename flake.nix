{
  description = "Custom XKB layouts (VOU)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          vou = pkgs.runCommand "xkb-layout-vou" { } ''
            mkdir -p $out/share/X11/xkb/symbols
            cp ${./xkb-custom/symbols/vou} $out/share/X11/xkb/symbols/vou
          '';

          vou-x1gen2 = pkgs.runCommand "xkb-layout-vou-x1gen2" { } ''
            mkdir -p $out/share/X11/xkb/symbols
            cp ${./xkb-custom/symbols/vou-for-x1gen2} $out/share/X11/xkb/symbols/vou
          '';

          vou-console = pkgs.runCommand "vou-console-keymap" { } ''
            mkdir -p $out/share/keymaps
            cp ${./console/vou.map} $out/share/keymaps/vou.map
          '';
        }
      );

      nixosModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          options.xkbCustomLayouts = {
            enable = lib.mkEnableOption "custom XKB layouts";
            variant = lib.mkOption {
              type = lib.types.enum [
                "vou"
                "vou-x1gen2"
              ];
              default = "vou";
              description = ''
                Which VOU variant to use. `vou-x1gen2` provides special remaps of `pos1` 
                and `end` keys as `mod3` since the Lenovo Carbon X1 Gen 2 has oddly placed 
                those in the place of the `capslock` key.
              '';
            };
            enableConsole = lib.mkEnableOption "VOU console keymap for TTY" // {
              default = false;
            };
          };

          config = lib.mkMerge [
            (lib.mkIf config.xkbCustomLayouts.enable {
              services.xserver.xkb.extraLayouts.vou = {
                description = "VOU layout";
                languages = [
                  "eng"
                  "de"
                ];
                symbolsFile =
                  if config.xkbCustomLayouts.variant == "vou-x1gen2" then
                    "${self}/xkb-custom/symbols/vou-for-x1gen2"
                  else
                    "${self}/xkb-custom/symbols/vou";
              };
            })

            (lib.mkIf config.xkbCustomLayouts.enableConsole {
              console.keyMap = "${self.packages.${pkgs.system}.vou-console}/share/keymaps/vou.map";
            })
          ];
        };
    };
}
