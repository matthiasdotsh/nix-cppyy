{ lib
, fetchurl
, fetchFromGitHub
, python3Packages
, cmake
, git
, setuptools
}:

let
  pname = "cppyy-cling";
  version = "6.30.0";
in
python3Packages.buildPythonPackage rec {
  inherit pname version;
  pyproject = true;

  srcs = [
    (fetchFromGitHub {
      inherit version;
      owner = "wlav";
      repo = "cppyy-backend";
      rev = "1a5daca5d02c99d80497df3846c7fe1c9006ee5d";
      sha256 = "sha256-IdZVwx7N7a2rf3+a4lkJd1E8BrNB6QL5xR31nQ4Jxfg=";
    })

    # cppyy-backend/cling depends on root
    (fetchurl {
      url = "https://root.cern.ch/download/root_v${version}0.source.tar.gz";
      hash = "sha256-BZLAZpVM/tQjEpV8nLJRZURWBk/i2Nq9y4gm8cAJnXE=";
    })
  ];
  sourceRoot =".";

 nativeBuildInputs = [
   cmake
   git
 ];

  propagatedBuildInputs = [
    setuptools
 ];

  patchPhase = ''
    # otherwise compiledata.h was not generated
    patchShebangs source/cling/src/build/unix/compiledata.sh

    # Copy root tarball to desired location
    # because we can't download it on-the-fly inside the sandbox
    # https://github.com/wlav/cppyy-backend/blob/master/cling/create_src_directory.py#L39
    mkdir -p source/cling/releases
    tar czf root_v${version}0.source.tar.gz root-${version}0
    cp root_v${version}0.source.tar.gz source/cling/releases/
    cd source/cling
    python setup.py egg_info
    python create_src_directory.py
  '';

  dontUseCmakeConfigure = true;

  # the import check also does not work if you install it on non-nix systems with pip
  # pythonImportsCheck = [ "cppyy_cling" ];

  meta = with lib; {
    homepage = "https://github.com/wlav/cppyy-backend/tree/master/cling";
    description = "Automatic, dynamic Python-C++ bindings (backend)";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthiasdotsh ];
  };
}

