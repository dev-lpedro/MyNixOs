{
  pkgs,
  config,
  inputs,
  ...
}: let
  system = pkgs.system;
  exts = inputs.nix-vscode-extensions.extensions.${system};
in {
  environment.systemPackages = [
    pkgs.vscodium.fhs
    pkgs.ripgrep
    pkgs.ripgrep-all
    pkgs.nixd
    pkgs.alejandra
  ];

  programs.nix-ld.enable = true;

  # Mapeia as configurações do VS Code e VSCodium via Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs;};

    users.leonardo = {config, ...}: {
      home.stateVersion = "24.11";

      xdg.configFile."VSCodium/User/settings.json" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/leonardo/MyNixOs/modules/features/editor/cfg_vscode/settings.json";
        force = true;
      };

      xdg.configFile."Code/User/settings.json" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/leonardo/MyNixOs/modules/features/editor/cfg_vscode/settings.json";
        force = true;
      };
    };
  };
}
