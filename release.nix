let
  sources = import ./nix/sources.nix { };
  pkgs = import sources.nixpkgs { overlays = [ (import ./overlay.nix) ]; };
in {
  inherit (pkgs) cppyy-cling cppyy-backend CPyCppyy cppyy;

  # nix-shell release.nix -A devShell
  devShell = pkgs.mkShell {
    nativeBuildInputs = [
      pkgs.zlib
      pkgs.niv
      pkgs.cppyy-cling
      pkgs.cppyy-backend
      pkgs.CPyCppyy
      pkgs.cppyy
    ];
    shellHook = ''
      export LD_LIBRARY_PATH=${
        pkgs.lib.makeLibraryPath [ pkgs.zlib ]
      }:$LD_LIBRARY_PATH

      # create one folder with .so from cppyy-cling and cppyy-backend
      # Without this hack the import of cppyy fails.
      #
      # This is because the libcppyy_backend.so is located in the folder of
      # cppyy-cling. However, it is not in this folder but in the cppyy-backend
      # folder.
      # Simply setting CPPYY_BACKEND_LIBRARY is not sufficient, as the
      # dependencies (libCling.so libCoreLegacy.so libRIOLegacy.so and
      # libThreadLegacy.so) that are actually located in the cppyy-cling folder
      # are then no longer found (presumably because it is assumed that the
      # libs are located directly next to libcppyy_backend.so). (At least this
      # is the case if you install cppyy with pip in a virtualenvironment, then
      # all libs are right next to each other and there is no read-only folder
      # for each program).
      rm -rf .my_cppyy-backend
      mkdir -p .my_cppyy-backend
      cp -r ${pkgs.cppyy-cling}/* .my_cppyy-backend
      chmod -R 777 .my_cppyy-backend
      cp ${pkgs.cppyy-backend}/lib/python3.11/site-packages/cppyy_backend/lib/libcppyy_backend.so .my_cppyy-backend/lib/python3.11/site-packages/cppyy_backend/lib/
      export CPPYY_BACKEND_LIBRARY=$PWD/.my_cppyy-backend/lib/python3.11/site-packages/cppyy_backend/lib/libcppyy_backend.so
    '';
  };

}
