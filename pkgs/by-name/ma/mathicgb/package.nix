{
  fetchFromGitHub,
  lib,
  stdenv,

  autoconf,
  automake,
  libtool,
  mathic,
  memtailor,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mathicgb";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "Macaulay2";
    repo = "mathicgb";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-Q5eic2O9V+Nc6KlpjAoQU2uUcKA3C4yh0y5SFCn3pxU=";
  };

  buildInputs = [
    mathic
    memtailor
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config # clears up bad behavior of autoconf
  ];

  __structuredAttrs = true;

  strictDeps = true;

  preConfigure = "./autogen.sh";

  configureFlags = [
    # not running checks
    "--without-gtest"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Program for computing Groebner basis and signature Grobner bases";
    longDescription = ''
      Mathicgb is a program for computing Groebner basis and signature Grobner
      bases. Mathicgb is based on the fast data structures from mathic.
    '';
    homepage = "https://github.com/Macaulay2/mathicgb";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ coolcuber ];
  };
})
