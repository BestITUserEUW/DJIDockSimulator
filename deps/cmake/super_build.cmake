include(ExternalProject)
include(ProcessorCount)

macro(SuperBuildStatus)
    message(STATUS "[SuperBuild] ${ARGN}")
endmacro()

macro(SuperBuildFatal)
    message(FATAL_ERROR "[SuperBuild] ${ARGN}")
endmacro()

macro(SuperBuildStatusArgs)
    set(args "${ARGN}")

    foreach(arg IN LISTS args)
        message(STATUS "-- ${arg}")
    endforeach()
endmacro()

function(CreateCommonArgs RESULT_CMAKE_ARGS CPP_FWD C_FWD)
    set(CMAKE_ARGS "")
    list(APPEND CMAKE_ARGS
        "-DCMAKE_INSTALL_PREFIX=${TARGET_INSTALL_DIR}"
        "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}"
        "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
        "-DCMAKE_LINKER_TYPE=${CMAKE_LINKER_TYPE}"
        "-DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}"
    )

    if(DEFINED CMAKE_TOOLCHAIN_FILE AND NOT CMAKE_TOOLCHAIN_FILE STREQUAL "")
        list(APPEND CMAKE_ARGS "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}")
    endif()

    if(CPP_FWD)
        list(APPEND CMAKE_ARGS
            "-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}"
        )

        if(DEFINED CMAKE_CXX_FLAGS AND NOT CMAKE_CXX_FLAGS STREQUAL "")
            list(APPEND CMAKE_ARGS "-DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}")
        endif()
    endif()

    if(C_FWD)
        list(APPEND CMAKE_ARGS
            "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}"
        )

        if(DEFINED CMAKE_C_FLAGS AND NOT CMAKE_C_FLAGS STREQUAL "")
            list(APPEND CMAKE_ARGS "-DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}")
        endif()
    endif()

    set(${RESULT_CMAKE_ARGS} "${CMAKE_ARGS}" PARENT_SCOPE)
endfunction()

function(SuperBuildTarget)
    set(options CPP_FWD C_FWD CUSTOM_CMAKE_LISTS)
    set(oneValueArgs
        TARGET
        CMAKE_ARGS
    )
    set(multiValueArgs "")

    cmake_parse_arguments(ST_ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    SuperBuildStatus("Building Target: ${ST_ARGS_TARGET}")

    set(TARGET_BINARY_DIR "${DEPS_BUILD_PATH}/${ST_ARGS_TARGET}")
    set(TARGET_SOURCE_DIR "${TARGET_BINARY_DIR}")
    set(TARGET_INSTALL_DIR "${DEPS_INSTALL_PATH}")

    file(MAKE_DIRECTORY ${TARGET_BINARY_DIR})

    CreateCommonArgs(COMMON_CMAKE_ARGS ${ST_ARGS_CPP_FWD} ${ST_ARGS_C_FWD})
    list(APPEND ST_ARGS_CMAKE_ARGS ${COMMON_CMAKE_ARGS})

    if(ST_ARGS_CUSTOM_CMAKE_LISTS)
        set(TARGET_SOURCE_DIR "${PROJECT_SOURCE_DIR}/${ST_ARGS_TARGET}")
        SuperBuildStatus("Using custom cmake lists")
    else()
        SuperBuildStatus("Generating cmake lists")
        configure_file("${PROJECT_SOURCE_DIR}/cmake/External.CMakeLists.in" "${TARGET_SOURCE_DIR}/CMakeLists.txt" @ONLY)
    endif()

    list(APPEND CONFIGURE_ARGS
        "-G${CMAKE_GENERATOR}"
    )

    if(DEFINED CMAKE_GENERATOR_PLATFORM AND NOT "${CMAKE_GENERATOR_PLATFORM}" STREQUAL "")
        list(APPEND CONFIGURE_ARGS "-A${CMAKE_GENERATOR_PLATFORM}")
    endif()

    list(APPEND CONFIGURE_ARGS ${COMMON_CMAKE_ARGS})

    SuperBuildStatus("Configuring with args: ")
    SuperBuildStatusArgs(${CONFIGURE_ARGS})

    execute_process(
        COMMAND ${CMAKE_COMMAND}
        ${CONFIGURE_ARGS}
        "${TARGET_SOURCE_DIR}"
        WORKING_DIRECTORY "${TARGET_BINARY_DIR}"
        RESULT_VARIABLE CONFIGURE_FAILED
    )

    if(${CONFIGURE_FAILED})
        SuperBuildFatal("${TARGET_SOURCE_DIR} failed to configure!")
    endif()

    ProcessorCount(NUM_PROCS)
    set(ENV{MAKEFLAGS} -j${NUM_PROCS})

    if(MSVC)
        execute_process(COMMAND ${CMAKE_COMMAND} --build . --config ${CMAKE_BUILD_TYPE}
            WORKING_DIRECTORY ${TARGET_BINARY_DIR}
            RESULT_VARIABLE BUILD_FAILED
        )
    else()
        execute_process(COMMAND ${CMAKE_COMMAND} --build .
            WORKING_DIRECTORY ${TARGET_BINARY_DIR}
            RESULT_VARIABLE BUILD_FAILED
        )
    endif()

    if(${BUILD_FAILED})
        SuperBuildFatal("${TARGET_BINARY_DIR} failed to build!")
    endif()
endfunction()