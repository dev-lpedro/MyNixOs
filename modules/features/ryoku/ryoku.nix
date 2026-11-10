{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.ryoku.nixosModules.default
  ];

  programs.ryoku.enable = true;

  virtualisation.docker.enable = lib.mkForce false;

  nixpkgs.overlays = [
    (final: prev: {
      electron_41 = prev.electron;
    })
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-41.10.6"
  ];
}
