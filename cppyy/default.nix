{ lib, python3Packages, fetchFromGitHub, cppyy-cling, cppyy-backend, CPyCppyy }:

python3Packages.buildPythonPackage rec {
  pname = "cppyy";
  version = "3.1.2";
  pyproject = true;

  src = fetchFromGitHub {
       owner = "wlav";
       repo = "cppyy";
       rev = "82f74538bceff6f5f66d4a5ed5c8fb23e0edd456";
       sha256 = "sha256-4XOZAcx2Bg3LpQnM4kswrV/kFpKGk5TPDEbpFSHCKnE=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.wheel
    python3Packages.pip
    cppyy-cling
    cppyy-backend
    CPyCppyy
  ];

  propagatedBuildInputs = [ cppyy-cling cppyy-backend CPyCppyy];

  dontUseCmakeConfigure = true;

  pythonImportCheck = [ "cppyy" ];

  meta = with lib; {
    homepage = "https://github.com/wlav/cppyy";
    description = "cppyy: Python-C++ bindings interface based on Cling/LLVM";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthiasdotsh ];
  };
}
