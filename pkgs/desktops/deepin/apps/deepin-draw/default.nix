{ stdenv
, lib
, fetchFromGitHub
, cmake
, qttools
, pkg-config
, wrapQtAppsHook
, qtbase
, qtsvg
, dtkwidget
, qt5integration
, qt5platform-plugins
}:

stdenv.mkDerivation rec {
  pname = "deepin-draw";
  version = "6.0.6";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-4mZcK+9w6q3tbdPvR3kD4qVsTYkQqdBIvGxF0fKmT48=";
  };

  postPatch = ''
    substituteInPlace com.deepin.Draw.service \
      --replace "/usr/bin/deepin-draw" "$out/bin/deepin-draw"
  '';

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qt5integration
    qtsvg
    dtkwidget
    qt5platform-plugins
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

  strictDeps = true;

  meta = with lib; {
    description = "Lightweight drawing tool for users to freely draw and simply edit images";
    homepage = "https://github.com/linuxdeepin/deepin-draw";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
