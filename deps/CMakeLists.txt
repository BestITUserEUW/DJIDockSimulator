project(Dependencies NONE)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
list(APPEND CMAKE_PREFIX_PATH "${DEPS_INSTALL_PATH}")
set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} PARENT_SCOPE)

include(super_build)

SuperBuildTarget(
    GIT_REPOSITORY https://github.com/getml/reflect-cpp.git
    GIT_TAG main
    GIT_SUBMODULES ""
    TARGET reflectcpp
    CMAKE_ARGS "-DREFLECTCPP_BUILD_SHARED=OFF"
    CPP_FWD
)

SuperBuildTarget(
    GIT_REPOSITORY https://github.com/doctest/doctest.git
    GIT_TAG master
    TARGET doctest
    CMAKE_ARGS "-DDOCTEST_WITH_TESTS=OFF"
)