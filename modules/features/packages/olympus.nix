# ==============================================================================
# Módulo do Olympus (Gerenciador de Mods do Celeste / Everest)
# ==============================================================================
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Sobrescreve o Olympus para utilizar o wrapper do steam-run
    # Isso permite baixar, instalar o Everest e rodar o Celeste com mods
    (olympus.override {
      celesteWrapper = "steam-run";
    })

    # Fornece as bibliotecas FHS necessárias para os binários baixados pelo Olympus
    steam-run
  ];
}
