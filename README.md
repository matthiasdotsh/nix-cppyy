# Important Notice

While developing this project, I discovered [cppyy-nix](https://github.com/m-bdf/cppyy-nix), which may serve as a better alternative for users seeking cppyy packaging solutions. 
Instead of building everything from source, this project utilizes multilinux wheels from PyPI, making the process significantly easier.


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
