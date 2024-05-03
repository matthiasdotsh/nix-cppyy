{ lib, python3Packages, fetchPypi, cppyy-cling, cmake}:

let
  pname = "cppyy-backend";
  version = "1.15.2";
in

python3Packages.buildPythonPackage rec {
  inherit pname version;
  pyproject = true;
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jQ7BafbqQNJpmaYbJ0zirIgAgujRaqzmoHApM9PYNfw=";
  };

  nativeBuildInputs = [ cmake cppyy-cling ];
  propagatedBuildInputs = [ cppyy-cling ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "cppyy_backend" ];

  meta = with lib; {
    homepage = "https://github.com/wlav/cppyy-backend/tree/master/clingwrapper";
    description = "Automatic, dynamic Python-C++ bindings (backend)";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthiasdotsh ];
  };
}
