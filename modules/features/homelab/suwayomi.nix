{
  config,
  pkgs,
  ...
}: let
  user = "leonardo";
  mangasDir = "/home/${user}/Mangas";
  suwaDir = "/home/${user}/SuwayomiData";
in {
  virtualisation.oci-containers.containers.suwayomi = {
    image = "ghcr.io/suwayomi/suwayomi-server:latest";
    ports = ["4567:4567"];
    environment = {
      PUID = "1000";
      PGID = "1000";
      "BIND_IP" = "0.0.0.0";

      # Pré-configurações automáticas que você pediu:
      "DOWNLOAD_AS_CBZ" = "true";
      "AUTO_DOWNLOAD_CHAPTERS" = "true";

      # Já adiciona o repositório de extensões automaticamente
      "EXTENSION_STORES" = ''["https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"]'';
    };
    volumes = [
      # O caminho correto! Agora NUNCA MAIS vai desconfigurar ou apagar:
      "${suwaDir}:/home/suwayomi/.local/share/Tachidesk"
      "${mangasDir}:/home/suwayomi/.local/share/Tachidesk/downloads"
    ];
  };

  # Libera a porta do Suwayomi no firewall do NixOS
  networking.firewall.allowedTCPPorts = [4567];
}
