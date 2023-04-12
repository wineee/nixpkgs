{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, pkg-config
, eudev
, mesa
, libinput
, libxkbcommon
, seatd
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-comp";
  version = "unstable-2023-04-11";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = pname;
    rev = "8f6ad6201752a8f40607473977c96f058524cb6f";
    sha256 = "sha256-vdmwTzXt3sj2SRlg3GyzUtGSNCf18w4tqkyTfsalFiQ";
  };

  # Cargo.lock is outdated
  #cargoPatches = [ ./update-cargo-lock.diff ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "cosmic-protocols-0.1.0" = "sha256-cfbk3cAfHrk+C1yPEKxRbkJiKFDE50sB28j13BoR6Bc=";
      "cosmic-text-0.7.0" = "sha256-OjPg658VCkHdt5/bLXtruyAF7nimfekunDBnZwD5VXs=";
      "cosmic-theme-0.1.0" = "sha256-tXjiMcmHZExY4QxFL0ZenU+6V7vB7LIKkeEsZvYrmp8=";
      "directories-4.0.1" = "sha256-4M8WstNq5I7UduIUZI9q1R9oazp7MDBRBRBHZv6iGWI=";
      "iced-0.6.0" = "sha256-oxmjlXliPDf1M2mWYTeHVtL7l7+PguD9ZkR+y4ZjODY=";
      "smithay-0.3.0" = "sha256-vcCPAP/KIUsfVfnpouudfjrGvDx0UG5MxZRPH6p4vtc=";
      "smithay-egui-0.1.0" = "sha256-l80U4/b8tU2NHdaFDAhZGrLiZc5ge2Gd11/qV4Qbdok=";
      "softbuffer-0.2.0" = "sha256-VD2GmxC58z7Qfu/L+sfENE+T8L40mvUKKSfgLmCTmjY=";
    };
  };

  #CARGO_PROFILE_RELEASE_LTO = "false";

  nativeBuildInputs = [ pkg-config  ];
  buildInputs = [
    eudev
    mesa
    libinput
    libxkbcommon
    seatd
    xorg.libxcb
  ];

  #buildNoDefaultFeatures = true;
  #buildFeatures = lib.optional gitSupport "git";

  #outputs = [ "out" "man" ];

  # Some tests fail, but Travis ensures a proper build
  doCheck = false;

  meta = with lib; {
    description = "Pure Rust multi-line text handling";
    longDescription = ''
      
    '';
    homepage = "https://pop-os.github.io/cosmic-text/cosmic_text";
    license = licenses.mit;
    maintainers = with maintainers; [ rewine ];
  };
}

