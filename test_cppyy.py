def test_cppyy_try_out_example():
    # https://cppyy.readthedocs.io/en/latest/starting.html
    import cppyy
    cppyy.include('zlib.h')  # bring in C++ definitions
    cppyy.load_library('libz')  # load linker symbols
    version = cppyy.gbl.zlibVersion()  # use a zlib API
    print(version)
    #assert version == '1.2.11'
    assert version == '1.3.1'
test_cppyy_try_out_example()
