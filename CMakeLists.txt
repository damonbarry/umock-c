#Copyright (c) Microsoft. All rights reserved.
#Licensed under the MIT license. See LICENSE file in the project root for full license information.

cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)

# Use @rpath in a target’s install name
if(POLICY CMP0042)
  cmake_policy(SET CMP0042 NEW)
endif()

# Specify a VERSION in the project() command
if(POLICY CMP0048)
  cmake_policy(SET CMP0048 NEW)
endif()

option(ENABLE_UNIT_TESTS "Build unit tests" OFF)
option(ENABLE_INT_TESTS "Build unit tests" OFF)
option(USE_CPPUNITTEST "Use CppUnitTest on Windows" OFF)
option(BUILD_SHARED_LIBS "Build shared libraries rather than static" ON)

project(umock_c VERSION 1.1.19)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# Use solution folders in Visual Studio
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Build

set(c_files
    src/umock_c.c
    src/umock_c_negative_tests.c
    src/umockalloc.c
    src/umockcall.c
    src/umockcallrecorder.c
    src/umocktypename.c
    src/umocktypes.c
    src/umocktypes_bool.c
    src/umocktypes_c.c
    src/umocktypes_stdint.c
    src/umocktypes_charptr.c
    src/umockcallpairs.c
    src/umockstring.c
    src/umockautoignoreargs.c
    src/umock_log.c)

set(h_files
    inc/umock_c.h
    inc/umock_c_internal.h
    inc/umock_c_negative_tests.h
    inc/umock_c_prod.h
    inc/umockalloc.h
    inc/umockcall.h
    inc/umockcallrecorder.h
    inc/umocktypename.h
    inc/umocktypes.h
    inc/umocktypes_bool.h
    inc/umocktypes_c.h
    inc/umocktypes_stdint.h
    inc/umocktypes_charptr.h
    inc/umockcallpairs.h
    inc/umockstring.h
    inc/umockautoignoreargs.h
    inc/umock_log.h)

include_directories(inc)

include(CompilerFlags)

add_library(umock_c ${c_files})

set_target_properties(umock_c PROPERTIES FOLDER "test_tools")

# Test

if(ENABLE_UNIT_TESTS OR ENABLE_INT_TESTS)
    enable_testing()

    find_package(ctest REQUIRED CONFIG)

    include(CheckIncludeFiles)
    check_include_files("stdint.h;stdbool.h" HAS_C99_TYPES)
    if(NOT HAS_C99_TYPES)
        include_directories(${CTEST_INCLUDES}/aux_inc)
    endif()    

    find_package(testrunnerswitcher REQUIRED CONFIG)
    include("configs/umock_cFunctions.cmake")
    add_subdirectory(tests)
endif()

# Install
include(GNUInstallDirs) # Set CMAKE_INSTALL_<dir>

if(NOT DEFINED CMAKE_INSTALL_LIBDIR)
    set(CMAKE_INSTALL_LIBDIR "lib")
endif()

configure_file("configs/${PROJECT_NAME}Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}Config.cmake"
    COPYONLY)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}ConfigVersion.cmake"
    COMPATIBILITY SameMajorVersion)

install(TARGETS umock_c EXPORT umock_cTargets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}/static
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})    
install(FILES ${h_files}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
install(EXPORT umock_cTargets
    FILE "${PROJECT_NAME}Targets.cmake"
    DESTINATION cmake)
install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}/${PROJECT_NAME}ConfigVersion.cmake"
    DESTINATION cmake)
