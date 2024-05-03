final: prev:
{
  cppyy-cling = final.python3Packages.callPackage ./cppyy-cling {};
  cppyy-backend = final.python3Packages.callPackage ./cppyy-backend {};
  CPyCppyy = final.python3Packages.callPackage ./CPyCppyy {};
  cppyy = final.python3Packages.callPackage ./cppyy {};
}
