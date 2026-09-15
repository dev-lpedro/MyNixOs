{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Importa o módulo oficial fornecido pelo Flake do Umbriel
    inputs.umbriel.nixosModules.default
  ];

  # Habilita o programa usando as opções do módulo dele
  programs.umbriel.enable = true;

  # (Opcional) Caso você queira APENAS o pacote instalado sem o módulo do NixOS:
  # environment.systemPackages = [
  #   inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default
  # ];
}
