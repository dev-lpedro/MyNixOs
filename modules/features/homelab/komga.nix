{
  config,
  pkgs,
  ...
}: let
  user = "leonardo";
  mangasDir = "/home/${user}/Mangas";
in {
  # 1. Leitor de Mangás (Komga)
  services.komga = {
    enable = true;
    settings.server.port = 8080;
    settings.server.address = "0.0.0.0";
  };

  systemd.services.komga.serviceConfig = {
    BindPaths = ["${mangasDir}:/data/mangas"];
  };

  # 2. Rede VPN Zero-Config (ZeroTier) no lugar do Tailscale
  services.zerotierone.enable = true;

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [8080];
  networking.firewall.checkReversePath = "loose"; # Mantém para evitar bloqueios do kernel
}
