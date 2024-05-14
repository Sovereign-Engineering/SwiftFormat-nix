{ stdenv, swift, swiftpm, swiftpm2nix, fetchFromGitHub }:

let
  # Pass the generated files to the helper.
  generated = swiftpm2nix.helpers ./nix;
  binName = "swiftformat";
in

stdenv.mkDerivation rec {
  pname = "SwiftFormat";
  version = "0.53.9";

  src = fetchFromGitHub {
    owner = "nicklockwood";
    repo = pname;
    rev = version;
    hash = "sha256-bXv7s9CXud94ZDTuf1NNY1S3qZDthpxmpoXkolFeliQ=";
  };

  # Including SwiftPM as a nativeBuildInput provides a buildPhase for you.
  # This by default performs a release build using SwiftPM, essentially:
  #   swift build -c release
  nativeBuildInputs = [ swift swiftpm ];

  # The helper provides a configure snippet that will prepare all dependencies
  # in the correct place, where SwiftPM expects them.
  configurePhase = generated.configure;

  installPhase = ''
    # This is a special function that invokes swiftpm to find the location
    # of the binaries it produced.
    binPath="$(swiftpmBinPath)"
    # Now perform any installation steps.
    mkdir -p $out/bin
    cp $binPath/${binName} $out/bin/
  '';
}
