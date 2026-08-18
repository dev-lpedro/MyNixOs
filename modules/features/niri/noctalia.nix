{
  pkgs,
  config,
  inputs,
  ...
}: {
  # ==========================================
  # CONFIGURAÇÕES DA NOCTALIA SHELL (v4 + v5) VIA HOME MANAGER
  # ==========================================
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs;};

    users.leonardo = {config, ...}: {
      home.stateVersion = "24.11";

      # Mapeia a pasta de configurações para ~/.config/noctalia
      # (Onde v4 lê os arquivos .json e v5 lê os arquivos .toml sem conflito)
      xdg.configFile."noctalia" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/leonardo/MyNixOs/modules/features/niri/cfg_noctalia";
        force = true;
      };

      # Flags do Equibop para Wayland nativo
      xdg.configFile."equibop-flags.conf".text = ''
        --ozone-platform=wayland
        --enable-features=WaylandWindowDecorations
      '';

      # Instala os executáveis de ambas as versões no $PATH do usuário
      home.packages = [
        # Noctalia v4 oficial do Nixpkgs (Comando: 'noctalia-shell')
        pkgs.noctalia-shell

        # Noctalia v5 oficial vinda do Flake (Comando: 'noctalia')
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default

        # Ferramentas auxiliares de temas e CSS
        pkgs.dart-sass
        pkgs.matugen
      ];
    };
  };
}
