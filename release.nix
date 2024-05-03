let
  sources = import ./nix/sources.nix { };
  pkgs = import sources.nixpkgs { overlays = [ (import ./overlay.nix) ]; };
in {
  inherit (pkgs) cppyy-cling cppyy-backend CPyCppyy cppyy;

  devShell = pkgs.mkShell {
    nativeBuildInputs = [ pkgs.niv ];
  };

}
