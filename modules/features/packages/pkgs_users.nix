# ==============================================================================
# Unificador de Pacotes de Usuário
# ==============================================================================
{pkgs, ...}: {
  imports = [
    ./pkgs_dev.nix
    ./pkgs_internet.nix
    ./pkgs_media.nix
    ./pkgs_gaming.nix
  ];

  environment.systemPackages = with pkgs; [
    # ==========================================
    # LABORATÓRIO (Pacotes novos/em teste)
    # ==========================================
    fastfetch
    # Adicione novos apps aqui antes de categorizá-los

    starship

    neovim

    gearlever

    clonehero

    dusklight

    olympus

    kdePackages.filelight

    bottles

    kdePackages.kdeconnect-kde

    localsend

    #cloudflare-cli

    godot-mono

    libresprite

    dotnetCorePackages.sdk_8_0

    kdePackages.plasma-nm

    networkmanagerapplet

    melonDS

    proton-vpn

    vopono

    wireguard-tools

    wireproxy

    moonlight-qt
  ];

  services.tailscale.enable = true;
  services.sunshine.enable = true;
}
