# This module defines a NixOS installation CD that contains X11 and
# Deepin.

{ pkgs, ... }:

{
  imports = [ ./installation-cd-graphical-calamares.nix ];

  isoImage.edition = "deepin";

  services.xserver = {
    desktopManager.deepin = {
      enable = true;
    };

    # Automatically login as nixos.
    displayManager = {
      sddm.enable = true;
      autoLogin = {
        enable = true;
        user = "nixos";
      };
    };
  };

  environment.pathsToLink = [
    "/share/calamares"
  ];

  system.activationScripts.installerDesktop = let

    # Comes from documentation.nix when xserver and nixos.enable are true.
    manualDesktopFile = "/run/current-system/sw/share/applications/nixos-manual.desktop";

    homeDir = "/home/nixos/";
    desktopDir = homeDir + "Desktop/";

  in ''
    mkdir -p ${desktopDir}
    chown nixos ${homeDir} ${desktopDir}

    ln -sfT ${manualDesktopFile} ${desktopDir + "nixos-manual.desktop"}
    ln -sfT ${pkgs.gparted}/share/applications/gparted.desktop ${desktopDir + "gparted.desktop"}
    ln -sfT ${pkgs.deepin.deepin-terminal}/share/applications/deepin-terminal.desktop  ${desktopDir + "deepin-terminal.desktop "}
    ln -sfT ${pkgs.calamares-nixos}/share/applications/io.calamares.calamares.desktop ${desktopDir + "io.calamares.calamares.desktop"}
  '';

}
