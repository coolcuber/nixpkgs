{
  lib,
  fetchFromGitHub,
  stdenv,

  autoconf,
  automake,
  libtool,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "memtailor";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "Macaulay2";
    repo = "memtailor";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-x6z/BzU78od21l72ZAnX37UHHdyMHfJ6cjwJwNYOIcY=";
  };

  configureFlags = [
    "--without-gtest"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  __structuredAttrs = true;

  strictDeps = true;

  preConfigure = "./autogen.sh";

  enableParallelBuilding = true;

  meta = {
    description = "C++ library of special purpose memory allocators";
    longDescription = ''
      Memtailor is a C++ library of special purpose memory allocators. It
      currently offers an arena allocator and a memory pool.

      The main motivation to use a memtailor allocator is better and more
      predictable performance than you get with new/delete. Sometimes a
      memtailor allocator can also be more convenient due to the ability to
      free many allocations at one time.
    '';
    homepage = "https://github.com/Macaulay2/memtailor";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ coolcuber ];
  };
})
