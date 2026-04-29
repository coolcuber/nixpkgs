{
  fetchFromGitHub,
  fetchurl,
  lib,
  makeWrapper,
  stdenv,

  _4ti2,
  autoconf,
  automake,
  bison,
  boehmgc,
  boost,
  cddlib,
  cohomcalg,
  coinmp,
  coin-utils,
  csdp,
  eigen,
  fflas-ffpack,
  flex,
  flint,
  frobby,
  gdbm,
  gfortran,
  gfan,
  givaro,
  glpk,
  gtest,
  icu,
  jansson,
  libtool,
  libxml2,
  libz,
  lrs,
  mathic,
  mathicgb,
  memtailor,
  mpfi,
  mpfr,
  msolve,
  mpsolve,
  nauty,
  ncurses,
  normaliz,
  ntl,
  onetbb,
  openblasCompat,
  openssl,
  pkg-config,
  python3,
  readline,
  singular,
  texinfo,
  time,
  topcom,
  which,
  xz,

  downloadDocs ? true,
}:
let
in
stdenv.mkDerivation (finalAttrs: {
  pname = "macaulay2";
  version = "1.25.11";

  src = fetchFromGitHub {
    owner = "Macaulay2";
    repo = "M2";
    rev = "refs/tags/release-${finalAttrs.version}";
    hash = "sha256-MX3PRBIXbzaGJYbPRBdLE9/D7WbhVQGpmZuo45wJjcs=";
    fetchSubmodules = true;
  };

  docs = fetchurl {
    url = "https://macaulay2.com/Downloads/OtherSourceCode/Macaulay2-docs-${finalAttrs.version}.tar.gz";
    hash = "sha256-E7MqcJN8K+QiDpmyid+6sch6A3E9wbmrlKe9G0xPMlQ=";
  };

  buildInputs = [
    _4ti2
    boehmgc
    boost
    cddlib
    coinmp
    coin-utils
    cohomcalg
    csdp
    eigen
    fflas-ffpack
    flint
    frobby
    gdbm
    gfan
    gfortran
    givaro
    glpk
    gtest
    icu
    jansson
    libxml2
    libz
    lrs
    mathic
    mathicgb
    memtailor
    mpfi
    mpfr
    mpsolve
    msolve
    nauty
    ncurses
    ntl
    normaliz
    openblasCompat
    openssl
    onetbb
    python3
    readline
    singular
    texinfo
    time
    topcom
    xz
  ];

  nativeBuildInputs = [
    _4ti2
    autoconf
    automake
    bison
    cohomcalg
    csdp
    flex
    gdbm
    gfan
    gfortran
    gtest
    libtool
    lrs
    makeWrapper
    msolve
    nauty
    normaliz
    pkg-config
    python3
    texinfo
    topcom
    which
  ];

  __structuredAttrs = true;

  strictDeps = true;

  postPatch = ''
    substituteInPlace M2/configure.ac \
      --replace-warn \
        "AC_SUBST([DOWNLOAD], [yes])" \
        "AC_SUBST([DOWNLOAD], [no])"
  '';

  patches = [
    # fixes /bin/PROGRAM references (should be removed in next release)
    ./programs.patch
    # remove packages that don't work with Nix (any package tied to ForeignFunctions.m2)
    ./packages.patch
  ];

  preConfigure = ''
    cd M2/BUILD/build
    export WGET=yes
    ../../autogen.sh
  '';

  configureScript = "../../configure";

  configureFlags = [
    "--enable-shared"
    "--with-issue=nixos"
    "--with-boost-libdir=${boost}/lib"
    "--with-system-libs"
    "--without-libffi" # the ForeignFunction interface isn't reproducible
  ]
  ++ (lib.optionals downloadDocs [
    "--enable-download"
    "--enable-documentation=download"
  ]);

  NIX_CFLAGS_COMPILE = "-I${cddlib}/include/cddlib";

  enableParallelBuilding = true;

  preBuild = lib.optionalString downloadDocs "cp ${finalAttrs.docs} ../tarfiles/${finalAttrs.docs.name}";

  postBuild = ''
    rm -r usr-dist/common/share/doc/Macaulay2/ForeignFunctions
    rm -r usr-dist/common/share/doc/Macaulay2/RInterface
  '';

  postInstall = ''
    wrapProgram "$out/bin/M2" \
      --prefix PATH : ${
        lib.makeBinPath [
          _4ti2
          cohomcalg
          csdp
          gfan
          lrs
          mathicgb
          msolve
          nauty
          normaliz
          openssl
          singular
          topcom
        ]
      }
  '';

  meta = {
    description = "System for computing in commutative algebra, algebraic geometry and related fields";
    mainProgram = "M2";
    longDescription = ''
      Macaulay2 is a software system devoted to supporting research in
      algebraic geometry and commutative algebra, whose creation has been
      funded by the National Science Foundation since 1992.

      Macaulay2 includes core algorithms for computing Gröbner bases and graded
      or multi-graded free resolutions of modules over quotient rings of graded
      or multi-graded polynomial rings with a monomial ordering. The core
      algorithms are accessible through a versatile high level interpreted user
      language with a powerful debugger supporting the creation of new classes
      of mathematical objects and the installation of methods for computing
      specifically with them. Macaulay2 can compute Betti numbers, Ext,
      cohomology of coherent sheaves on projective varieties, primary
      decomposition of ideals, integral closure of rings, and more.
    '';
    homepage = "https://macaulay2.com/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ coolcuber ];
  };
})
