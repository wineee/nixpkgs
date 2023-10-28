{ stdenv
, lib
, fetchFromGitLab
, meson
, pkg-config
, qttools
, ninja
, qtbase
, wlroots
, wayland
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayqt";
  version = "0.1.99";

  src = fetchFromGitLab {
    owner = "desktop-frameworks";
    repo = "wayqt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MaA6qXSZ1h4G8DY2G7+7J2Xntm8ekId19t1oYz0yYW8=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    qttools
    ninja
  ];

  buildInputs = [
    qtbase
    wlroots
    wayland
  ];

  mesonFlags = [
    "-Duse_qt_version=qt6"
  ];

  dontWrapQtApps = true;

  outputs = [ "out" "dev" ];

  meta = {
    homepage = "https://gitlab.com/desktop-frameworks/wayqt";
    description = "Qt-based library to handle Wayland and Wlroots protocols to be used with any Qt project";
    maintainers = with lib.maintainers; [ atemu rewine ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
  };
})
