@PACKAGE_INIT@
find_package(Threads REQUIRED)

set(config_targets_file @config_targets_file@)

include("${CMAKE_CURRENT_LIST_DIR}/${config_targets_file}")

check_required_components(libcron)