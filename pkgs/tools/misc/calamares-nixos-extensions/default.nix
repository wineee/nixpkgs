{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation rec {
  pname = "calamares-nixos-extensions";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "wineee";
    repo = "calamares-nixos-extensions";
    rev = "50de085488ac6784540b8c90c30480a7feff05f3";
    sha256 = "sha256-zaswgXZXaM4Up14kQoTKZ7Gww5O0pNVDWG8j4Sv8mvo=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{lib,share}/calamares
    cp -r modules $out/lib/calamares/
    cp -r config/* $out/share/calamares/
    cp -r branding $out/share/calamares/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Calamares modules for NixOS";
    homepage = "https://github.com/NixOS/calamares-nixos-extensions";
    license = with licenses; [ gpl3Plus bsd2 cc-by-40 cc-by-sa-40 cc0 ];
    maintainers = with maintainers; [ vlinkz ];
    platforms = platforms.linux;
  };
}
