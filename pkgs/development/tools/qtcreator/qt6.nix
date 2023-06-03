{ stdenv
, lib
, fetchurl
, fetchpatch
, cmake
, pkg-config
, python3
, qtbase
, qt5compat
, qtdeclarative
, qtdoc
, qtquick3d
, qtquicktimeline
, qtserialport
, qtsvg
, qttools
, qtwebengine
, qtshadertools
, wrapQtAppsHook
, yaml-cpp
, litehtml
, gumbo
, llvmPackages
, rustc-demangle
, elfutils
, perf
}:

stdenv.mkDerivation rec {
  pname = "qtcreator";
  version = "10.0.1";

  src = fetchurl {
    url = "https://download.qt.io/official_releases/${pname}/${lib.versions.majorMinor version}/${version}/qt-creator-opensource-src-${version}.tar.xz";
    sha256 = "sha256-QWGwfc7A/I8xUpx9thC3FzFBKNoAei76haqbwzCXoWM=";
  };

  patches = [
    # fix build with Qt 6.5.1
    # FIXME: remove for next release
    (fetchpatch {
      url = "https://github.com/qt-creator/qt-creator/commit/9817df63fb9eae342d5bf6f28f526aa09b17e8de.diff";
      hash = "sha256-HIQuKroWUhJBWhVG3fyoBIFvezktCyQAuaZz/lvg7uk=";
    })
  ];

  # avoid fix-qt-builtin-paths hook substitute QT_INSTALL_DOCS to qtdoc's path
  postPatch = ''
    for file in $(grep -rl '$QT_INSTALL_DOCS'); do
      substituteInPlace $file \
          --replace '$QT_INSTALL_DOCS' "${qtbase}/share/doc"
    done
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
    python3
  ];

  buildInputs = [
    qtbase
    qtdoc
    qtsvg
    qtquick3d
    qtwebengine
    qtserialport
    qtshadertools
    qt5compat
    qtdeclarative
    qtquicktimeline
    yaml-cpp
    litehtml
    gumbo
    llvmPackages.libclang
    llvmPackages.llvm
    rustc-demangle
    elfutils
  ];

  cmakeFlags = [
    # workaround for missing CMAKE_INSTALL_DATAROOTDIR
    # in pkgs/development/tools/build-managers/cmake/setup-hook.sh
    "-DCMAKE_INSTALL_DATAROOTDIR=${placeholder "out"}/share"
    # qtdeclarative in nixpkgs does not provide qmlsc
    # fix can't find Qt6QmlCompilerPlusPrivate
    "-DQT_NO_FIND_QMLSC=TRUE"
    "-DWITH_DOCS=ON"
    "-DBUILD_DEVELOPER_DOCS=ON"
    "-DBUILD_QBS=OFF"
    "-DQTC_CLANG_BUILDMODE_MATCH=ON"
    "-DCLANGTOOLING_LINK_CLANG_DYLIB=ON"
  ];

  buildFlags = [ "all" "docs" ];

  qtWrapperArgs = [
    "--set-default PERFPROFILER_PARSER_FILEPATH ${lib.getBin perf}/bin"
  ];

  postInstall = ''
    cp -r share/doc $out/share

    substituteInPlace $out/share/applications/org.qt-project.qtcreator.desktop \
      --replace "Exec=qtcreator" "Exec=$out/bin/qtcreator"
  '';

  meta = with lib; {
    description = "Cross-platform IDE tailored to the needs of Qt developers";
    longDescription = ''
      Qt Creator is a cross-platform IDE (integrated development environment)
      tailored to the needs of Qt developers. It includes features such as an
      advanced code editor, a visual debugger and a GUI designer.
    '';
    homepage = "https://wiki.qt.io/Qt_Creator";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.rewine ];
    platforms = platforms.linux;
  };
}
