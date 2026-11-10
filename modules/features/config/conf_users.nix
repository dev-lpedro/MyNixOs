# ==============================================================================
# Configuração de Usuários do Sistema e Permissões de Grupos
# ==============================================================================
{
  pkgs,
  lib,
  ...
}: {
  # Habilita o shell Fish no nível do sistema operacional
  programs.fish.enable = true;

  # ============================================================================
  # USUÁRIO PRINCIPAL: leonardo
  # ============================================================================
  users.users.leonardo = {
    isNormalUser = true;
    description = "Leonardo";
    initialPassword = "123"; # Senha temporaria, mude com passwd

    extraGroups = [
      "wheel" # Acesso ao sudo
      "networkmanager" # Permissão para gerenciar conexões Wi-Fi/Rede
      "video" # Controle da GPU e brilho da tela (brightnessctl)
      "audio" # Controle do servidor de áudio Pipewire e volume
      "input" # Acesso a touchpads, mouses e controles de jogos
      "gamemode" # Permissão para acionar otimizações em jogos
      "dialout"
      "tty"
      "render"
    ];

    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];

    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];

    shell = pkgs.fish;
  };

  # ============================================================================
  # USUÁRIO COMUM: vinicius (sem senha, sem root, usa Plasma)
  # ============================================================================
  users.users.vinicius = {
    isNormalUser = true;
    description = "Vinicius";
    hashedPassword = ""; # sem senha (se o login recusar, troque por: password = "";)
    extraGroups = [
      "networkmanager" # trocar de Wi-Fi sem pedir senha de admin
      # "video" # só descomente se brilho/câmera não funcionarem
      # "audio" # só descomente se algum dispositivo de áudio não funcionar
    ];
    shell = pkgs.bashInteractive; # bash: muito mais fácil achar tutoriais
  };

  # Senha vazia aceita SÓ no login gráfico (GDM) e na tela de bloqueio do Plasma.
  # TTY, su, sudo e SSH continuam recusando.
  security.pam.services.gdm-password.allowNullPassword = true;
  security.pam.services.kde.allowNullPassword = true;

  # Endurecimento
  nix.settings.allowed-users = ["@wheel" "vinicius"]; # só o grupo wheel usa o nix daemon
  security.sudo.execWheelOnly = true; # sudo só executável por quem é wheel

  # ============================================================================
  # HOME MANAGER: leonardo
  # ============================================================================
  home-manager.users.leonardo = {
    config,
    pkgs,
    ...
  }: {
    # Cria as pastas padrão (~/Downloads, ~/Documentos, etc.)
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables =
        if lib.versionAtLeast config.home.stateVersion "26.05"
        then false
        else true;
    };

    # Preferir tema escuro nos portais XDG e GTK4
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
      };
    };

    xdg.configFile."gtk-3.0/gtk.css".enable = lib.mkForce false;
    xdg.configFile."gtk-4.0/gtk.css".enable = lib.mkForce false;

    # Preferir tema escuro em apps GTK
    gtk = {
      enable = true;
      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };

      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.theme =
        if lib.versionAtLeast config.home.stateVersion "26.05"
        then null
        else config.gtk.theme;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    };

    # Preferir tema escuro em apps qt
    qt = {
      enable = true;
      platformTheme.name = "kde";
      style.name = "breeze";
    };
  };

  # ============================================================================
  # HOME MANAGER: vinicius (Plasma padrão, foco em simplicidade)
  # ============================================================================
  home-manager.users.vinicius = {
    config,
    pkgs,
    ...
  }: {
    home.stateVersion = "24.11"; # mesmo do leonardo e do sistema

    # Pastas em português
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Área de Trabalho";
      documents = "${config.home.homeDirectory}/Documentos";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Música";
      pictures = "${config.home.homeDirectory}/Imagens";
      videos = "${config.home.homeDirectory}/Vídeos";
    };

    # Programas do dia a dia
    home.packages = with pkgs; [
      firefox
      libreoffice-qt
      vlc
    ];
  };
}
