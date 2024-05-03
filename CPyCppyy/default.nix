{ lib, python3Packages, fetchPypi, cppyy-cling, cppyy-backend }:

let
  version = "1.12.16";
  pname = "CPyCppyy";
in

python3Packages.buildPythonPackage rec {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
       inherit pname version;
       sha256 = "sha256-CahFZSrBqCd37Emd2oYvVEk8FWDp30yt7NoJ7N6eQgI=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.wheel
    python3Packages.pip
    cppyy-cling
    cppyy-backend
  ];

  propagatedBuildInputs = [ cppyy-cling cppyy-backend];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "CPyCppyy" ];

  meta = with lib; {
    homepage = "https://github.com/wlav/CPyCppyy";
    description = "CPyCppyy: Python-C++ bindings interface based on Cling/LLVM";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthiasdotsh ];
  };
}
