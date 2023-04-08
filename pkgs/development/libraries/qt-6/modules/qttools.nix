{ qtModule
, stdenv
, lib
, qtbase
, qtdeclarative
, llvmPackages
, cups
, substituteAll
}:

qtModule {
  pname = "qttools";
  buildInputs = [
    llvmPackages.libclang
    llvmPackages.llvm
  ];
  qtInputs = [ qtbase qtdeclarative ];
  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ cups ];
  patches = [
    ../patches/qttools-paths.patch
  ];
  env.NIX_CFLAGS_COMPILE = toString [
    "-DNIX_OUTPUT_DEV=\"${placeholder "dev"}\""
  ];

  devTools = [
    "bin/qcollectiongenerator"
    "bin/linguist"
    "bin/assistant"
    "bin/qdoc"
    "bin/lconvert"
    "bin/designer"
    "bin/lrelease"
    "bin/pixeltool"
    "bin/lupdate"
    "bin/qtdiag"
    "bin/qtplugininfo"
    "bin/qthelpconverter"
    "bin/qdistancefieldgenerator"
    "libexec/lprodump"
    "libexec/lrelease-pro"
    "libexec/lupdate-pro"
    "libexec/qhelpgenerator"
    "libexec/qtattributionsscanner"
  ] ++ lib.optionals stdenv.isDarwin [
    "bin/macdeployqt"
  ];

}
