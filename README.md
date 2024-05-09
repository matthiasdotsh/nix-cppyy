# nix-cppyy

Current status: WIP (working inside devShell)

## Setup

Build
```shell
nix-build release.nix
```

Test
```shell
nix-shell release.nix -A devShell
python test_cppyy.py
# Output should be 1.3.1
```
