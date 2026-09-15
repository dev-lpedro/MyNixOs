{
  config,
  pkgs,
  ...
}: let
  user = "leonardo";
  mediaDir = "/home/${user}/Media";
in {
  # 1. Servidor de Mídia (Jellyfin)
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # Permite que o usuário do jellyfin acesse a pasta de mídia
  systemd.services.jellyfin.serviceConfig = {
    BindPaths = ["${mediaDir}:/data/media"];
  };

  # Garante que o firewall aceite conexões do ZeroTier (ou da rede local)
  networking.firewall.allowedTCPPorts = [8096];
  networking.firewall.trustedInterfaces = ["zt+"]; # Libera qualquer interface do ZeroTier automaticamente
}
