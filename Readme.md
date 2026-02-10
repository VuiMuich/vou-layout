# VOU Layout

A NixOS flake providing the VOU keyboard layout for easy integration into NixOS configurations.

## About VOU

VOU is an ergonomic keyboard layout optimized for German and English typing, created by Max Schillinger (@MaxGyver83). You can read more about the design philosophy and features in his blog posts:

- [VOU Layout Introduction (de)](https://maximilian-schillinger.de/vou-layout.html)
- [Alternative Keyboard Layouts (de)](https://maximilian-schillinger.de/keyboard-layouts-neo-adnw-koy.html)

## What This Repository Provides

This flake packages the VOU layout for use with XKB (X Keyboard Extension) on NixOS systems. It includes:

- **vou**: Standard VOU layout
- **vou-x1gen2**: Special variant with remapped `pos1` and `end` keys for the Lenovo ThinkPad X1 Carbon Gen 2, which has these keys oddly placed where `capslock` normally sits

## Usage

### As a NixOS Module (Recommended)

Add the flake to your system configuration inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    vou-layout.url = "github:VuiMuich/vou-layout";
  };

  outputs = { self, nixpkgs, vou-layout, ... }: {
    nixosConfigurations.yourhost = nixpkgs.lib.nixosSystem {
      modules = [
        vou-layout.nixosModules.default
        {
          xkbCustomLayouts = {
            enable = true;
            variant = "vou"; # or "vou-x1gen2"
          };
          
          services.xserver.xkb.layout = "vou";
        }
      ];
    };
  };
}
```

### Direct Usage

Alternatively, use it directly in your XKB configuration:

```nix
{
  inputs.vou-layout.url = "github:VuiMuich/vou-layout";

  # In your configuration:
  services.xserver.xkb.extraLayouts.vou = {
    description = "VOU layout";
    languages = [ "eng" "de" ];
    symbolsFile = "${vou-layout}/xkb-custom/symbols/vou";
  };
}
```

## Future Plans

- Add configuration files for [xremap](https://github.com/k0kubun/xremap)
- Add configuration files for [kanata](https://github.com/jtroo/kanata)
- Support for additional platforms and remapping tools

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

The VOU keyboard layout itself was created by Max Schillinger. This repository packages the layout for NixOS and provides configuration tooling.
## Contributing

Contributions are welcome! Feel free to open issues or pull requests for additional variants, platform support, or other improvements.
