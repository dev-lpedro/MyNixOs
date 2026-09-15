# ==============================================================================
# Módulo do Driver Linuwu-Sense (Acer Hardware Control) & DAMX Environment
# ==============================================================================
{
  config,
  pkgs,
  lib,
  ...
}: let
  linuwu-sense = config.boot.kernelPackages.callPackage ({
    stdenv,
    fetchFromGitHub,
    kernel,
  }:
    stdenv.mkDerivation {
      pname = "linuwu-sense";
      version = "unstable";

      src = fetchFromGitHub {
        owner = "0x7375646F";
        repo = "Linuwu-Sense";
        rev = "main";
        hash = "sha256-4v+xDrJ+lZIyV/wcRsfMbw933u+yS8uP8TEUVXSpdjA=";
      };

      nativeBuildInputs = kernel.moduleBuildDependencies;

      postPatch = ''
        sed -i '1i #include <linux/string.h>' src/linuwu_sense.c
      '';

      buildPhase = ''
        runHook preBuild
        make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd) modules
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
        find . -name '*.ko' -exec cp {} $out/lib/modules/${kernel.modDirVersion}/extra/ \;
        runHook postInstall
      '';
    }) {};

  damx-run = pkgs.buildFHSEnv {
    name = "damx-run";
    targetPkgs = pkgs:
      with pkgs; [
        xorg.libICE
        xorg.libSM
        xorg.libX11
        xorg.libXext
        xorg.libXi
        xorg.libXcursor
        xorg.libXrandr
        xorg.libXrender
        fontconfig
        freetype
        glib
        libGL
        icu
        zlib
        openssl
      ];
    runScript = "bash";
  };
in {
  # Compila e carrega o módulo do kernel necessário para o DAMX
  boot.extraModulePackages = [linuwu-sense];
  boot.kernelModules = ["linuwu_sense"];

  # Utilitários para rodar a GUI e binários do DAMX
  environment.systemPackages = with pkgs; [
    steam-run
    damx-run
  ];
}
