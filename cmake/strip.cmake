function(strip_target target installPath)
  set(target_file $<TARGET_FILE:${target}>)
  add_custom_command(
    COMMAND ${CMAKE_OBJCOPY} --only-keep-debug ${target_file} ${CMAKE_BINARY_DIR}/bin/${target}.debug
    COMMAND ${CMAKE_STRIP}   --strip-debug --strip-unneeded ${target_file}
    COMMAND ${CMAKE_OBJCOPY} --add-gnu-debuglink=${CMAKE_BINARY_DIR}/bin/${target}.debug ${target_file}
    OUTPUT  ${CMAKE_BINARY_DIR}/bin/${target}.debug
    COMMENT "stripping ${target}"
  )
  add_custom_target(
    ${target}-stripping ALL
    DEPENDS ${CMAKE_BINARY_DIR}/bin/${target}.debug
  )
  add_dependencies(${target}-stripping ${target})
  install(
    FILES       ${CMAKE_BINARY_DIR}/bin/${target}.debug
    DESTINATION ${installPath}
    COMPONENT   symbols
    EXCLUDE_FROM_ALL
  )
endfunction(strip_target)