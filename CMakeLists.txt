cmake_minimum_required(VERSION 3.6)

project(libcron)

# Deactivate Iterator-Debugging on Windows
option(LIBCRON_DEACTIVATE_ITERATOR_DEBUGGING "Build with iterator-debugging (MSVC only)." OFF)
option(LIBCRON_BUILD_TESTS "Build Cron Tests" OFF)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Release build type" FORCE)
endif()

if(NOT CMAKE_CXX_STANDARD)
    set(CMAKE_CXX_STANDARD 17)
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
endif()

if(MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")

    if(LIBCRON_DEACTIVATE_ITERATOR_DEBUGGING)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_HAS_ITERATOR_DEBUGGING=0")
    endif()
else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic")
endif()

set(BUILD_TZ_LIB ON CACHE BOOL "Build the tz library" FORCE)
add_subdirectory(libcron/externals/date)

add_library(${PROJECT_NAME}
    libcron/src/CronClock.cpp
    libcron/src/CronData.cpp
    libcron/src/CronRandomization.cpp
    libcron/src/CronSchedule.cpp
    libcron/src/Task.cpp
)

add_library(cron::libcron ALIAS ${PROJECT_NAME})

target_include_directories(${PROJECT_NAME} PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/libcron/include>"
    "$<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>"
)

target_link_libraries(${PROJECT_NAME} PUBLIC
    date-tz
)

target_link_libraries(${PROJECT_NAME} INTERFACE date)

if(NOT MSVC)
    # Assume a modern compiler (gcc 9.3)
    target_compile_definitions(${PROJECT_NAME} PRIVATE -DHAS_UNCAUGHT_EXCEPTIONS)
endif()

if(LIBCRON_BUILD_TESTS)
    add_subdirectory(test)
    add_dependencies(cron_test libcron)
endif()

# Install
set(project_config_in "${CMAKE_CURRENT_LIST_DIR}/cmake/libcronConfig.cmake.in")
set(project_config_out "${CMAKE_CURRENT_BINARY_DIR}/libcronConfig.cmake")
set(config_targets_file "libcronConfigTargets.cmake")
set(export_dest_dir "${CMAKE_INSTALL_LIBDIR}/cmake/libcron")

# Include Files
install(DIRECTORY libcron/include libcron/externals/date/include/date DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")
install(
    TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

# Cmake Files
install(EXPORT libcron DESTINATION ${export_dest_dir} NAMESPACE cron:: FILE ${config_targets_file})