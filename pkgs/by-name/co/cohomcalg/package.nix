{
  fetchFromGitHub,
  lib,
  stdenv,

  memtailor,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cohomcalg";
  version = "0.32";

  src = fetchFromGitHub {
    owner = "BenjaminJurke";
    repo = "cohomCalg";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-9kKKfb8STiCjaHiWgYEQsERNTnOXlwN8axIBJHg43zk=";
  };

  buildInputs = [
    memtailor
  ];

  __structuredAttrs = true;

  strictDeps = true;

  enableParallelBuilding = true;

  checkTarget = "checkdirs";

  installPhase = ''
    mkdir -p $out
    mv bin $out/bin
  '';

  meta = {
    description = "Software package for computation of sheaf cohomologies for line bundles on toric varieties";
    homepage = "https://github.com/BenjaminJurke/cohomCalg";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ coolcuber ];
  };
})
