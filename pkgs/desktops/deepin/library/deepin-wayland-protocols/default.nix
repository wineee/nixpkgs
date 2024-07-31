{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
}:

stdenv.mkDerivation rec {
  pname = "deepin-wayland-protocols";
  version = "1.10.0.28";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-JL3UN8/DcZerI2s4Kk+QbweRwFdarSNBPZ6z6E1qGqg=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  meta = with lib; {
    description = "XML files of the non-standard wayland protocols use in deepin";
    homepage = "https://github.com/linuxdeepin/deepin-wayland-protocols";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
