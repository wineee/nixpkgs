{ stdenv
, lib
, fetchFromGitLab
, wrapQtAppsHook
, meson
, pkg-config
, cmake
, qttools
, ninja
, qtbase
, json_c
, wlroots
, wayqt
, wayland
, pixman
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtgreet";
  version = "1.99.3";

  src = fetchFromGitLab {
    owner = "marcusbritanicus";
    repo = "qtgreet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7XsP9/GJPDf9k0qtMn8b1Fc4rL9vftq14fqE91QQKEM=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    qttools
    ninja
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    json_c
    wlroots
    wayqt
    wayland
    pixman
  ];

  mesonFlags = [
    #"-Duse_qt_version=qt6"
  ];

  meta = {
    homepage = "https://gitlab.com/marcusbritanicus/QtGreet";
    description = "Qt based greeter for greetd, to be run under wayfire or similar wlr-based compositors";
    maintainers = with lib.maintainers; [ atemu rewine ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
  };
})
