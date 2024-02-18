cmake_minimum_required(VERSION 3.6)

project(cron_test)

find_package(Threads REQUIRED)

add_executable(
        ${PROJECT_NAME}
        CronDataTest.cpp
        CronRandomizationTest.cpp
        CronScheduleTest.cpp
        CronTest.cpp)

target_include_directories(${PROJECT_NAME} PRIVATE
        ${CMAKE_CURRENT_LIST_DIR}/externals/Catch2/single_include/catch2
)

target_link_libraries(${PROJECT_NAME} PRIVATE
        Threads::Threads
        libcron::libcron
)


if(NOT MSVC)
        target_compile_definitions(${PROJECT_NAME} PRIVATE -DHAS_UNCAUGHT_EXCEPTIONS)
endif()

set_target_properties(${PROJECT_NAME} PROPERTIES
        ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/out"
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/out"
        RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/out")
