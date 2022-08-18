function(add_kernel_module ModuleName)
    add_custom_command(
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${ModuleName}.ko
        COMMAND $(MAKE) -C ${LINUX_KERNEL_BUILD_DIRECTORY} M=${CMAKE_CURRENT_BINARY_DIR} src=${CMAKE_CURRENT_SOURCE_DIR} ${LINUX_KERNEL_ARCH} ${LINUX_KERNEL_CROSS_COMPILE} V=1 modules
        DEPENDS "${ARGV}"
    )
    add_custom_target(${ModuleName}
        ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${ModuleName}.ko
    )
endfunction()