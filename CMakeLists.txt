cmake_minimum_required(VERSION 3.14)
project(hello_world VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(Threads REQUIRED)

include(FetchContent)
# First, try to find GoogleTest installed on the system
find_package(GTest COMPONENTS gtest gtest_main QUIET)
if(NOT GTest_FOUND)
    message(STATUS "GoogleTest not found; fetching googletest v1.14.0 via FetchContent")
    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG        v1.14.0
    )
    # On MSVC ensure consistent CRT
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    # Use shallow clone to reduce network work
    set(FETCHCONTENT_SOURCE_DIR ${CMAKE_BINARY_DIR}/_deps/googletest-src)
    FetchContent_MakeAvailable(googletest)
    # After FetchContent_MakeAvailable the googletest targets (gtest, gtest_main) should exist
endif()

# Verify GTest targets are available
if(NOT (TARGET GTest::gtest AND TARGET GTest::gtest_main))
    message(FATAL_ERROR "GoogleTest targets (GTest::gtest, GTest::gtest_main) are not available. Ensure git and a working network are available or vendor googletest into the project.")
endif()

include(GoogleTest)

# Static library for math operations
add_library(math_operations STATIC math_operations.cpp)
target_include_directories(math_operations PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

# Executable application using the library
add_executable(test_app main.cpp)
target_link_libraries(test_app PRIVATE math_operations Threads::Threads)

# Unit tests
add_executable(unit_tests tests/unit_tests.cpp)
# link with gtest and gtest_main (gtest_main provides main), and threads
target_link_libraries(unit_tests PRIVATE math_operations GTest::gtest GTest::gtest_main Threads::Threads)

enable_testing()
add_test(NAME unit_tests COMMAND unit_tests)

# Convenience target to build and run tests
add_custom_target(run_tests
    COMMAND ${CMAKE_CTEST_COMMAND} -C $<CONFIG> --output-on-failure
    DEPENDS unit_tests
)
