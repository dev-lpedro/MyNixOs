{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.inir.nixosModules.inir
  ];

  programs.inir = {
    enable = true;
    service.compositor = null;
    extraPackages = [
      config.programs.niri.package
      pkgs.uv
      pkgs.python3
    ];
  };

  services.displayManager.sessionPackages = [
    ((pkgs.writeTextDir "share/wayland-sessions/niri-inir.desktop" ''
      [Desktop Entry]
      Name=iNiR (Niri isolado)
      Comment=Niri com config isolada rodando o shell iNiR (Quickshell)
      Exec=niri --config /home/leonardo/MyNixOs/modules/features/inir/cfg_inir/config.kdl
      Type=Application
      DesktopNames=niri
    '').overrideAttrs (_: {passthru.providedSessions = ["niri-inir"];}))
  ];
}
