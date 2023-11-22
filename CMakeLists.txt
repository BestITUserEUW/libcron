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

if( MSVC )
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")
	
	if (LIBCRON_DEACTIVATE_ITERATOR_DEBUGGING)
		set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_HAS_ITERATOR_DEBUGGING=0")
	endif()
else()
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wpedantic")
endif()

set(BUILD_TZ_LIB ON CACHE BOOL "Build the tz library" FORCE)
add_subdirectory(libcron/externals/date)

add_library(${PROJECT_NAME}
    libcron/include/libcron/Cron.h
    libcron/include/libcron/CronClock.h
    libcron/include/libcron/CronData.h
    libcron/include/libcron/CronRandomization.h
    libcron/include/libcron/CronSchedule.h
    libcron/include/libcron/DateTime.h
    libcron/include/libcron/Task.h
    libcron/include/libcron/TimeTypes.h
    libcron/src/CronClock.cpp
    libcron/src/CronData.cpp
    libcron/src/CronRandomization.cpp
    libcron/src/CronSchedule.cpp
    libcron/src/Task.cpp
)

target_include_directories(${PROJECT_NAME} PUBLIC
    libcron/include
)

target_link_libraries(${PROJECT_NAME} PUBLIC
    date
    date-tz
)

if(NOT MSVC)
	# Assume a modern compiler (gcc 9.3)
	target_compile_definitions (${PROJECT_NAME} PRIVATE -DHAS_UNCAUGHT_EXCEPTIONS)
endif()

set_target_properties(${PROJECT_NAME} PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/out/${CMAKE_BUILD_TYPE}"
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/out/${CMAKE_BUILD_TYPE}"
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/out/${CMAKE_BUILD_TYPE}")

if(LIBCRON_BUILD_TESTS)
    add_subdirectory(test)
    add_dependencies(cron_test libcron)
endif()

install(TARGETS libcron DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(DIRECTORY libcron/include/libcron DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
install(DIRECTORY libcron/externals/date/include/date DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
