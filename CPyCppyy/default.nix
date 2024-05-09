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

  patchPhase = ''
    # Workaround error, that was described in cppyy-backend/default.nix
    # See: https://github.com/wlav/CPyCppyy/blob/02072bbd818501364b37c133364e02976af4cc10/setup.py
    # For reference line numbers
    sed -i "43s@config_exec_args@#config_exec_args@g" setup.py
    sed -i "44s@config_exec_args@#config_exec_args@g" setup.py
    sed -i "45s@cli_arg@#cli_arg@g" setup.py
    sed -i "46s|return cli_arg.decode(\"utf-8\").strip()|return \"-pthread -std=c++2a -m64\"|" setup.py
  '';
  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "CPyCppyy" ];

  meta = with lib; {
    homepage = "https://github.com/wlav/CPyCppyy";
    description = "CPyCppyy: Python-C++ bindings interface based on Cling/LLVM";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthiasdotsh ];
  };
}
