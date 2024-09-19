{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wayland,
  kwayland,
  qtbase,
  qttools,
  qtx11extras,
  wrapQtAppsHook,
  extra-cmake-modules,
  gsettings-qt,
  libepoxy,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kiconthemes,
  kglobalaccel,
  kidletime,
  knotifications,
  kpackage,
  plasma-framework,
  kcmutils,
  knewstuff,
  kdecoration,
  kscreenlocker,
  breeze-qt5,
  libinput,
  mesa,
  lcms2,
  xorg,
  python3,
  wayland-protocols,
}:

stdenv.mkDerivation rec {
  pname = "deepin-kwin";
  version = "5.27.2.203";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-tLA0fzmzuUXwOeEYDDekkFb0biVctzcL1NfHkwjjqSc=";
  };

  patches = [
    ./fix-build.patch
  ];

  postPatch = ''
    substituteInPlace src/effects/multitaskview/multitaskview.cpp \
      --replace-fail "/usr/share/wallpapers" "/run/current-system/sw/share"
    substituteInPlace configures/CMakeLists.txt \
      --replace-fail "/usr" "$out"

    patchShebangs src/effects/strip-effect-metadata.py
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    extra-cmake-modules
    wrapQtAppsHook
    python3
    #file # strip-effect-metadata.py
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    wayland
    kwayland
    wayland-protocols
    deepin-wayland-protocols
    libepoxy
    gsettings-qt

    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    kiconthemes

    kglobalaccel
    kidletime
    knotifications
    kpackage
    plasma-framework
    kcmutils
    knewstuff
    kdecoration
    kscreenlocker

    #breeze-qt5
    libinput
    mesa
    lcms2

    xorg.libxcb
    xorg.libXdmcp
    xorg.libXcursor
    xorg.xcbutilcursor
    xorg.libXtst
    xorg.libXScrnSaver
    xorg.libxcvt
  ];

  cmakeFlags = [ "-DKWIN_BUILD_RUNNERS=OFF" ];

  outputs = [
    "out"
    "dev"
  ];

  meta = with lib; {
    description = "Fork of kwin, an easy to use, but flexible, composited Window Manager";
    homepage = "https://github.com/linuxdeepin/deepin-kwin";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
