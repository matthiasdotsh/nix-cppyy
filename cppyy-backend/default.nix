{ lib, python3Packages, fetchPypi, cppyy-cling, cmake, setuptools, pip}:

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

  nativeBuildInputs = [ setuptools cmake cppyy-cling pip ];
  propagatedBuildInputs = [ cppyy-cling ];

  patchPhase = ''
    # There is an error
    # When `python setup.py bdist_wheel` is called in the build phase,
    # `sys.executable, '-m', 'cppyy_backend._cling_config'` [1] gets executed.
    # However, cppyy_backend._cling_config is code that is not in this module
    # but in the cppyy-cling package.
    # In `_cling_config.py` there is a call to `root-config` [2].
    # After building `cppyy-cling` `root-config` is located at
    # `${cppyy-cling}/lib/python3. 11/site-packages/cppyy_backend/bin/root-config`
    # However it's not available from the cppyy-backend buildPhase.
    # When trying to call it, I get a
    # `FileNotFoundError: [Errno 2] No such file or directory: '/nix/store/...-python3.11-cppyy-cling-6.30.0/lib/python3.11/site-packages/cppyy_backend/bin/root-config'` error.
    # For now I don't know how to fix this, so I picked out the paths as a
    # workaround and hard patched them to `setup.py`
    # [1] https://github.com/wlav/cppyy-backend/blob/1a5daca5d02c99d80497df3846c7fe1c9006ee5d/clingwrapper/setup.py#L58
    # [2] https://github.com/wlav/cppyy-backend/blob/1a5daca5d02c99d80497df3846c7fe1c9006ee5d/cling/python/cppyy_backend/_cling_config.py#L20

    # See: https://github.com/wlav/cppyy-backend/blob/1a5daca5d02c99d80497df3846c7fe1c9006ee5d/clingwrapper/setup.py
    # For reference line numbers
    # patch get_include_path() function to return correct cppyy-cling dir
    sed -i "56s@config_exec_args@#config_exec_args@g" setup.py
    sed -i "57s@config_exec_args@#config_exec_args@g" setup.py
    sed -i "58s@cli_arg@#cli_arg@g" setup.py
    sed -i "59s|return cli_arg.decode(\"utf-8\").strip()|return '\${cppyy-cling}/lib/python3.11/site-packages/cppyy_backend/include'|" setup.py

    # patch get_cflags() function to return correct flags
    sed -i "62s@config_exec_args@#config_exec_args@g" setup.py
    sed -i "63s@config_exec_args@#config_exec_args@g" setup.py
    sed -i "64s@cli_arg@#cli_arg@g" setup.py
    sed -i "65s|return cli_arg.decode(\"utf-8\").strip()|return \"-pthread -std=c++2a -m64\"|" setup.py
  '';

  dontUseCmakeConfigure = true;

  # I added this custom installPhase to workarround the following error:
  # FileExistsError: File already exists: /nix/store/ksf8ml68y659fni6pixv488dqm48ppqv-python3.11-cppyy-backend-1.15.2/lib/python3.11/site-packages/cppyy_backend/lib/libcppyy_backend.so
  installPhase = ''
    mkdir -p $out
    env PIP_PREFIX=$out pip install dist/*.whl --no-use-pep517 --no-deps
  '';


  pythonImportsCheck = [ "cppyy_backend" ];

  meta = with lib; {
    homepage = "https://github.com/wlav/cppyy-backend/tree/master/clingwrapper";
    description = "Automatic, dynamic Python-C++ bindings (backend)";
    license = licenses.bsd3;
    maintainers = with maintainers; [ matthiasdotsh ];
  };
}
