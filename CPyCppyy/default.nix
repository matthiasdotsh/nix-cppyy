{ lib, python3Packages, fetchFromGitHub, cppyy-cling, cppyy-backend, cmake }:

let
  version = "1.12.16";
  pname = "CPyCppyy";
in

python3Packages.buildPythonPackage rec {
  inherit pname version;
  pyproject = true;

  # There is no CMakeLists.txt in the fetchPypi output,
  # therefore we take the sources from GitHub
  src = fetchFromGitHub {
       inherit pname version;
       owner = "wlav";
       repo = pname;
       rev = "${pname}-${version}";
       sha256 = "sha256-ROZ8Zcp00+7LTe/bpY0WHLmbvnXylC9S8IcolQtbOK8=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.wheel
    python3Packages.pip
    cmake
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

  # Following:
  # https://cppyy.readthedocs.io/en/latest/repositories.html#building-from-source
  installPhase = ''
    mkdir -p $out
    env PIP_PREFIX=$out pip install . --no-use-pep517 --no-deps
    mkdir -p build
    cmake ../${pname}-${version}
    make
    cp libcppyy.so $out/lib/python3.11/site-packages/
  '';

  # Missing from https://cppyy.readthedocs.io/en/latest/repositories.html#building-from-source
  # "then simply point the PYTHONPATH envar to the build directory above to pick up the local cppyy.so module."

  # Not working
  # pythonImportsCheck = [ "CPyCppyy" ];

  meta = with lib; {
    homepage = "https://github.com/wlav/CPyCppyy";
    description = "CPyCppyy: Python-C++ bindings interface based on Cling/LLVM";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthiasdotsh ];
  };
}
