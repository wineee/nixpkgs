{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, qt5
, cmake
, ninja
, python3
}:

stdenv.mkDerivation rec {
  pname = "cpeditor";
  version = "6.9.3";

  src = fetchFromGitHub {
    owner = "cpeditor";
    repo = "cpeditor";
    rev = version;
    sha256 = "sha256-yfHiTslKPRmFkSIj1WvaD4ZruL1azqjNAYbag1k2RzU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ninja pkg-config qt5.wrapQtAppsHook ];
  buildInputs = [ qt5.qtbase qt5.qttools python3 ];

  preConfigure = ''
    sed 's,/bin/bash,${stdenv.shell},' -i src/Core/Runner.cpp
  '';

  meta = with lib; {
    description = "An IDE specially designed for competitive programming";
    homepage = "https://cpeditor.org";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
