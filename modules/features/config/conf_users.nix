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

  # Declaração do usuário principal
  users.users.leonardo = {
    isNormalUser = true;
    description = "Leonardo";
    initialPassword = "123"; #Senha temporaria, mude com passwd

    # Grupos de permissões no hardware
    extraGroups = [
      "wheel" # Acesso ao sudo
      "networkmanager" # Permissão para gerenciar conexões Wi-Fi/Rede
      "video" # Controle da GPU e brilho da tela (brightnessctl)
      "audio" # Controle do servidor de áudio Pipewire e volume
      "input" # Acesso a touchpads, mouses e controles de jogos
      "gamemode" # Permissão para acionar otimizações em jogos
    ];

    # Define o Fish como o shell padrão do usuário
    shell = pkgs.fish;
  };

  # Configurações do perfil do usuário gerenciadas pelo Home Manager
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

    #Preferir tema escuro em apps qt
    qt = {
      enable = true;
      platformTheme.name = "kde";
      style.name = "breeze";
    };
  };
}
