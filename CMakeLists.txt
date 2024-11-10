cmake_minimum_required(VERSION 3.24)

project(docksim-cpp LANGUAGES CXX VERSION 0.0.0)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(BUILD_SHARED_LIBS OFF)
set(DEPS_BUILD_PATH "${PROJECT_BINARY_DIR}/deps" CACHE PATH "Install path for the dependencies")
set(DEPS_INSTALL_PATH "${DEPS_BUILD_PATH}/install" CACHE PATH "Install path for the dependencies")

option(ST_ENABLE_TESTS "Enable Tests" ON)

file(GLOB_RECURSE SOURCES "${CMAKE_SOURCE_DIR}/src/*.cpp")
list(FILTER SOURCES EXCLUDE REGEX ".*/main.cpp$")

add_executable(${PROJECT_NAME} src/main.cpp ${SOURCES})

add_subdirectory(deps)

find_package(Threads REQUIRED)
find_package(reflectcpp REQUIRED)
find_package(doctest REQUIRED)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Threads::Threads
    reflectcpp::reflectcpp
    doctest::doctest
)

target_compile_definitions(${PROJECT_NAME} PRIVATE
    DOCTEST_CONFIG_DISABLE
)

if(ST_ENABLE_TESTS)
    add_executable(${PROJECT_NAME}_tests test/main.cpp ${SOURCES})
    target_link_libraries(${PROJECT_NAME}_tests PRIVATE
        reflectcpp::reflectcpp
        doctest::doctest
    )
endif()