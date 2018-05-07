This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

# umock_c

umock_c is a C mocking library.

## Build

```
git clone https://github.com/Azure/umock-c.git
cd umock-c
mkdir build
cd build
cmake ..
cmake --build .
```

## Run umock_c's unit and integration tests (optional)

```
cmake -DENABLE_UNIT_TESTS=ON -DENABLE_INT_TESTS=ON ..
cmake --build .
ctest -C Debug # <- CMake's 'ctest' tool, which invokes our test binaries
```

## Install and Use
To take a dependency on umock_c in your project, install it in your developer environment:

```
cmake --build . --target install
```

If your project uses CMake, refer to umock_c in your CMakeLists.txt file as follows:

```
find_package(umock_c REQUIRED CONFIG)
# ...
target_link_library(yourlib umock_c)
```

## Example

Ever wanted to write something like this in C as a test?

```c
TEST_FUNCTION(my_first_test)
{
    // arrange
    STRICT_EXPECTED_CALL(test_dependency_1_arg(42))
        .SetReturn(44)
        .IgnoreAllArguments();

    // act
    int result = function_under_test();

    // assert
    ASSERT_ARE_EQUAL(int, 44, result);
    ASSERT_ARE_EQUAL(char_ptr, umock_c_get_expected_calls(), umock_c_get_actual_calls());
}
```

umock_c has way more features than this simple example!

## Dependencies

- umock_c uses ctest as test runner (https://github.com/Azure/azure-ctest.git). ctest is a C test runner that can be run on many platforms as it does not make use of compiler/platform specific code and thus it is easily portable.
- umock_c uses cmake (https://cmake.org/) to generate build files.
- umock_c uses testrunnerswitcher to allow switching between ctest and CppUnitTest for Windows. 

## Documentation

Complete documentation is available [here](doc/umock_c.md).
