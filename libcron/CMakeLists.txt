cmake_minimum_required(VERSION 3.6)

project(libcron)

add_subdirectory(externals/date)

add_library(${PROJECT_NAME}
		include/libcron/Cron.h
		include/libcron/CronClock.h
		include/libcron/CronData.h
		include/libcron/CronRandomization.h
		include/libcron/CronSchedule.h
		include/libcron/DateTime.h
		include/libcron/Task.h
		include/libcron/TimeTypes.h
		src/CronClock.cpp
		src/CronData.cpp
		src/CronRandomization.cpp
		src/CronSchedule.cpp
		src/Task.cpp
)

add_library(libcron::libcron ALIAS ${PROJECT_NAME})

target_link_libraries(${PROJECT_NAME} PUBLIC date)

target_include_directories(${PROJECT_NAME} PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

if(NOT MSVC)
	# Assume a modern compiler (gcc 9.3)
	target_compile_definitions (${PROJECT_NAME} PRIVATE -DHAS_UNCAUGHT_EXCEPTIONS)
endif()

# Install
set(project_config_in "${CMAKE_CURRENT_LIST_DIR}/../cmake/libcronConfig.cmake.in")
set(project_config_out "${CMAKE_CURRENT_BINARY_DIR}/libcronConfig.cmake")
set(config_targets_file "libcronConfigTargets.cmake")
set(export_dest_dir "${CMAKE_INSTALL_LIBDIR}/cmake/libcron")

# Include Files
install(DIRECTORY libcron/include/ DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")
install(
    TARGETS ${PROJECT_NAME}
    EXPORT ${PROJECT_NAME}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

# Cmake Files
export(TARGETS libcron NAMESPACE libcron::
    FILE "${CMAKE_CURRENT_BINARY_DIR}/${config_targets_file}")
install(EXPORT libcron DESTINATION ${export_dest_dir} NAMESPACE libcron:: FILE ${config_targets_file})
include(CMakePackageConfigHelpers)
configure_package_config_file("${project_config_in}" "${project_config_out}" INSTALL_DESTINATION ${export_dest_dir})
install(FILES "${project_config_out}" DESTINATION "${export_dest_dir}")
