{
  config,
  pkgs,
  ...
}: let
  user = "leonardo";
  homelabDir = "/home/${user}/homelab";
  mediaDir = "/home/${user}/Media";
  downloadsDir = "/home/${user}/Downloads/Torrents";
in {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  virtualisation.oci-containers.backend = "podman";

  virtualisation.oci-containers.containers = {
    # 1. CAMADA DE REDE E INDEXADORES BR
    flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      ports = ["8191:8191"];
      environment = {
        LOG_LEVEL = "info";
        TZ = "America/Sao_Paulo";
      };
    };

    redis-indexer = {
      image = "docker.io/library/redis:alpine";
    };

    torrent-indexer = {
      image = "ghcr.io/felipemarinho97/torrent-indexer:latest";
      ports = ["7006:7006"];
      environment = {
        PORT = "7006";
        REDIS_HOST = "redis-indexer";
        FLARESOLVERR_ADDRESS = "http://flaresolverr:8191";
        FLARESOLVERR_TIMEOUT_SECONDS = "60";
      };
      dependsOn = ["redis-indexer" "flaresolverr"];
    };

    # 2. CLIENTE DE DOWNLOAD
    qbittorrent = {
      image = "linuxserver/qbittorrent:latest";
      ports = ["8081:8081" "6881:6881" "6881:6881/udp"];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/Sao_Paulo";
        WEBUI_PORT = "8081";
      };
      volumes = [
        "${homelabDir}/qbittorrent:/config"
        "${downloadsDir}:/downloads"
      ];
    };

    # 3. GERENCIADORES DE MÍDIA
    prowlarr = {
      image = "linuxserver/prowlarr:latest";
      ports = ["9696:9696"];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/Sao_Paulo";
      };
      volumes = ["${homelabDir}/prowlarr:/config"];
    };

    jackett = {
      image = "linuxserver/jackett:latest";
      ports = ["9117:9117"];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/Sao_Paulo";
      };
      volumes = ["${homelabDir}/jackett:/config"];
    };

    sonarr = {
      image = "linuxserver/sonarr:latest";
      ports = ["8989:8989"];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/Sao_Paulo";
      };
      volumes = [
        "${homelabDir}/sonarr:/config"
        "${mediaDir}:/data/media"
        "${downloadsDir}:/downloads"
      ];
    };

    radarr = {
      image = "linuxserver/radarr:latest";
      ports = ["7878:7878"];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/Sao_Paulo";
      };
      volumes = [
        "${homelabDir}/radarr:/config"
        "${mediaDir}:/data/media"
        "${downloadsDir}:/downloads"
      ];
    };

    bazarr = {
      image = "linuxserver/bazarr:latest";
      ports = ["6767:6767"];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/Sao_Paulo";
      };
      volumes = [
        "${homelabDir}/bazarr:/config"
        "${mediaDir}:/data/media"
      ];
    };

    # 4. STREAMING E PEDIDOS
    #jellyfin = {
    #  image = "linuxserver/jellyfin:latest";
    #  ports = [ "8096:8096" ];
    #  environment = { PUID = "1000"; PGID = "1000"; TZ = "America/Sao_Paulo"; };
    #  volumes = [
    #    "${homelabDir}/jellyfin:/config"
    #    "${mediaDir}:/data/media"
    #  ];
    #};

    jellyseerr = {
      image = "fallenbagel/jellyseerr:latest";
      ports = ["5055:5055"];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "America/Sao_Paulo";
      };
      volumes = ["${homelabDir}/jellyseerr:/config"];
    };
  };

  networking.firewall.allowedTCPPorts = [
    8081
    8989
    7878
    9696
    9117
    6767
    8096
    5055
    8191
    7006
  ];
}
