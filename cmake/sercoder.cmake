
# ************************************************************************
# For function documentation please refer public function definition below
# ************************************************************************
#


#
# *****************************************************
# Internal function definition
# *****************************************************
#

cmake_minimum_required(VERSION 3.5)

if(NOT SERCODER_BIN_DIR)
    message(FATAL_ERROR "SERCODER_BIN_DIR isn't set!")
endif()
if(NOT LIBSERIALIZE_INC_DIR)
    message(FATAL_ERROR "LIBSERIALIZE_INC_DIR isn't set!")
endif()

set(MTA_CODEGEN_SCRIPTS ${CMAKE_CURRENT_LIST_DIR}/)

function(sercoder_compile_dwarf TARGET_PREFIX SOURCE_FILES DEPENDENCIES)
    # Create target library to be later processed by sercoder
    add_library(${TARGET_PREFIX}_SERCODER_IN SHARED
        ${SOURCE_FILES}
    )

    foreach(param ${DEPENDENCIES})
        if(TARGET ${param})
            list(APPEND link_libraries ${param})
        else()
            get_filename_component(ABS_PATH ${param} ABSOLUTE)
            if(NOT IS_DIRECTORY ${ABS_PATH})
                message(WARNING "Sercoder warning: ${param} is neither a target nor a directory. Treating as directory")
            endif()
            list(APPEND include_dirs ${param})
        endif()
    endforeach()

    target_include_directories(${TARGET_PREFIX}_SERCODER_IN PRIVATE
        ${include_dirs}
    )
    target_link_libraries(${TARGET_PREFIX}_SERCODER_IN ${link_libraries})

    target_compile_options(${TARGET_PREFIX}_SERCODER_IN PRIVATE -gdwarf)
    target_compile_definitions(${TARGET_PREFIX}_SERCODER_IN PRIVATE MTA_BUILD)

endfunction(sercoder_compile_dwarf)

function(sercoder_run TARGET_PREFIX MTA_CLS_HASH_HPP MTA_CLS_INFO_CPP MTA_CLS_INFO_CLS)

    add_custom_command(
        COMMAND
            ${SERCODER_BIN_DIR}/sercoder
            -i $<TARGET_FILE:${TARGET_PREFIX}_SERCODER_IN>
            -o ${MTA_CLS_INFO_CPP}
            -c ${MTA_CLS_INFO_CLS}
            --mtahash ${MTA_CLS_HASH_HPP}
            --no-sub-class
            --no-copy-include
        WORKING_DIRECTORY
            ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS
            ${TARGET_PREFIX}_SERCODER_IN
        OUTPUT
            ${CMAKE_CURRENT_BINARY_DIR}/${MTA_CLS_HASH_HPP}
            ${CMAKE_CURRENT_BINARY_DIR}/${MTA_CLS_INFO_CPP}
            ${CMAKE_CURRENT_BINARY_DIR}/${MTA_CLS_INFO_CLS}
    )

    # Layer of indirection (target depending on target depending on files)
    # is needed to avoid double execution of custom command, which generates the files
    # Putting custom_command in custom_target would remove dependency on files and thus
    # lead to unnecessary compilation when nothing has changed
    add_custom_target(sercoder_out_${TARGET_PREFIX})
    add_dependencies(sercoder_out_${TARGET_PREFIX} sercoder_out_${TARGET_PREFIX}_FILES)
    add_custom_target(
        sercoder_out_${TARGET_PREFIX}_FILES
    DEPENDS
        ${CMAKE_CURRENT_BINARY_DIR}/${MTA_CLS_HASH_HPP}
        ${CMAKE_CURRENT_BINARY_DIR}/${MTA_CLS_INFO_CPP}
        ${CMAKE_CURRENT_BINARY_DIR}/${MTA_CLS_INFO_CLS}
    )

endfunction(sercoder_run)


function(sercoder_classinfo_to_objectfile TARGET_PREFIX MTA_CLS_INFO_CLS)

    if(${ARGC} GREATER 2)
        set(UNIQUE_PREFIX ${ARGV2})
    endif()

    add_custom_command(
     COMMAND
        ${CMAKE_LINKER} -r -b binary -o ${UNIQUE_PREFIX}mta_publisher_classinfo_cls.o ${MTA_CLS_INFO_CLS}
     WORKING_DIRECTORY
        ${CMAKE_CURRENT_BINARY_DIR}
     DEPENDS
        ${CMAKE_CURRENT_BINARY_DIR}/${MTA_CLS_INFO_CLS} sercoder_out_${TARGET_PREFIX}
     OUTPUT
        ${CMAKE_CURRENT_BINARY_DIR}/${UNIQUE_PREFIX}mta_publisher_classinfo_cls.o
    )

    add_custom_target(
        sercoder_object_file_${TARGET_PREFIX}
     DEPENDS
        ${CMAKE_CURRENT_BINARY_DIR}/${UNIQUE_PREFIX}mta_publisher_classinfo_cls.o
    )

endfunction(sercoder_classinfo_to_objectfile)


function(sercoder_classinfo_to_size_header TARGET_PREFIX MTA_CLS_INFO_CLS)

    if(${ARGC} GREATER 2)
        set(UNIQUE_PREFIX ${ARGV2})
    endif()

    add_custom_command(
        COMMAND
            ${MTA_CODEGEN_SCRIPTS}/sercoder_gen_class_info_max_size.sh ${MTA_CLS_INFO_CLS} class_info_max_size/ ${UNIQUE_PREFIX}
     WORKING_DIRECTORY
         ${CMAKE_CURRENT_BINARY_DIR}
     DEPENDS
         ${CMAKE_CURRENT_BINARY_DIR}/${MTA_CLS_INFO_CLS} sercoder_out_${TARGET_PREFIX}
     OUTPUT
         ${CMAKE_CURRENT_BINARY_DIR}/class_info_max_size/${UNIQUE_PREFIX}class_info_max_size.hpp
    )

    add_custom_target(
        class_info_max_size_${TARGET_PREFIX}
     DEPENDS
        ${CMAKE_CURRENT_BINARY_DIR}/class_info_max_size/${UNIQUE_PREFIX}class_info_max_size.hpp
    )

endfunction(sercoder_classinfo_to_size_header)


function(sercoder_mtahash_target TARGET_PREFIX)

    add_library(${TARGET_PREFIX}_mtahashes INTERFACE)
    target_include_directories(${TARGET_PREFIX}_mtahashes INTERFACE ${CMAKE_CURRENT_BINARY_DIR} ${SER_INCLUDE_DIRS})
    add_dependencies(${TARGET_PREFIX}_mtahashes sercoder_out_${TARGET_PREFIX})

endfunction(sercoder_mtahash_target)


function(sercoder_clsmaxsize_target TARGET_PREFIX)

    add_library(${TARGET_PREFIX}_clsmaxsize INTERFACE)
    target_include_directories(${TARGET_PREFIX}_clsmaxsize INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/class_info_max_size)
    add_dependencies(${TARGET_PREFIX}_clsmaxsize class_info_max_size_${TARGET_PREFIX})

endfunction(sercoder_clsmaxsize_target)

#
# *****************************************************
# End of Internal function definition
# *****************************************************
#


#
# *****************************************************
# Public function definition
# *****************************************************
#

function(add_sercoder_library TARGET SOURCE_FILES)
    sercoderbuild(${TARGET}
        "${SOURCE_FILES}"
        ""
        ${TARGET}
    )
    target_include_directories(${TARGET}_SERCODER_IN PUBLIC
        ${LIBSERIALIZE_INC_DIR}
    )
    target_link_libraries(${TARGET}_SERCODER_IN aos::carma)
endfunction(add_sercoder_library)

function(target_link_sercoder_library TARGET SERCODER_TARGET)
    sercoderdepend_mtahash(${TARGET}
        ${SERCODER_TARGET}
    )
    sercoderlink(${TARGET}
        ${SERCODER_TARGET}
        ${SERCODER_TARGET}
    )
    sercoderdepend_clsmaxsize(${TARGET}
        ${SERCODER_TARGET}
    )
    target_include_directories(${TARGET} PUBLIC
        ${LIBSERIALIZE_INC_DIR}
        ${LIBSERIALIZE_INC_DIR}
        # for linking sercoder in shared libraries
        ${CMAKE_CURRENT_BINARY_DIR}
        ${CMAKE_CURRENT_BINARY_DIR}/class_info_max_size
    )
endfunction(target_link_sercoder_library)

# Sercoder functions define several targets and adds dependencies to your target(s).
# For a correct dependency graph CMake needs unique targets.
# Therefore the TARGET_PREFIX variable exists. Usually you can set this variable to
# your project name. TARGET however is always the target that you wish to add the
# dependencies to.

#
# Custom target for sercoder execution. This function defines all required targets
# and is usually always required for your project.
#
# Parameter Description
# TARGET_PREFIX Unique Identifier Prefix. Should be the name of the parent target
#
# SOURCE_FILES  Single file or list of source files to be composited
#
# DEPENDENCIES  Single item or list of either directories and/or cmake targets required for compilation
#
# [UNIQUE_PREFIX] An optional fourth parameter. If given it will cause the files generated by sercoder to
#                 have the prefix '${UNIQUE_PREFIX}_'
#
function(sercoderbuild TARGET_PREFIX SOURCE_FILES DEPENDENCIES)

    if(${ARGC} GREATER 3)
        set(UNIQUE_PREFIX ${ARGV3}_)
    endif()
    set(MTA_CLS_HASH_HPP ${UNIQUE_PREFIX}mta_hashes.hpp)
    set(MTA_CLS_INFO_CPP ${UNIQUE_PREFIX}mta_hashes.cpp)
    set(MTA_CLS_INFO_CLS ${UNIQUE_PREFIX}mta_publisher_classinfo.cls)

    # Compile source to shared object, analyzeable by sercoder
    sercoder_compile_dwarf(${TARGET_PREFIX} "${SOURCE_FILES}" "${DEPENDENCIES}")

    # Run the sercoder
    sercoder_run(${TARGET_PREFIX} ${MTA_CLS_HASH_HPP} ${MTA_CLS_INFO_CPP} ${MTA_CLS_INFO_CLS})

    # Provide object file derived from class info
    sercoder_classinfo_to_objectfile(${TARGET_PREFIX} ${MTA_CLS_INFO_CLS} ${UNIQUE_PREFIX})

    # Provide header file with size information of class info
    sercoder_classinfo_to_size_header(${TARGET_PREFIX} ${MTA_CLS_INFO_CLS} ${UNIQUE_PREFIX})

    # Provide include path so that sercoder generated hpp can be used
    sercoder_mtahash_target(${TARGET_PREFIX})

    # Provide include path so that generated max class info size hpp can be used
    sercoder_clsmaxsize_target(${TARGET_PREFIX})

endfunction(sercoderbuild)

#
# Link sercoder generated class info content directly into a target
#
# Can be accessed in the target like this:
# extern const char _binary_mta_publisher_classinfo_cls_start;
# extern const char _binary_mta_publisher_classinfo_cls_end;
#
# Or like this, if the optional third parameter is passed:
# extern const char _binary_${UNIQUE_PREFIX}_mta_publisher_classinfo_cls_start;
# extern const char _binary_${UNIQUE_PREFIX}_mta_publisher_classinfo_cls_end;
#
# access through:
# &_binary_<${UNIQUE_PREFIX}_>mta_publisher_classinfo_cls_start and &_binary_<${UNIQUE_PREFIX}_>mta_publisher_classinfo_cls_end
#
# Parameter Description
# TARGET Target that links against the generated classinfo
#
# TARGET_PREFIX Unique Identifier Prefix. Should be the name of the parent target
#
# [UNIQUE_PREFIX] An optional third parameter. If given will change the name of the generated
#                 classinfo symbols as described above. It must be the same used in the sercoderbuild() call
#
#
function(sercoderlink TARGET TARGET_PREFIX)

    if(${ARGC} GREATER 2)
        set(UNIQUE_PREFIX ${ARGV2}_)
    endif()
    target_link_libraries(${TARGET} PRIVATE ${CMAKE_CURRENT_BINARY_DIR}/${UNIQUE_PREFIX}mta_publisher_classinfo_cls.o)
    add_dependencies(${TARGET} sercoder_object_file_${TARGET_PREFIX})

endfunction(sercoderlink)

#
# Adds the sercoder output directory as dependency.
# This adds the ability to include source code generated by sercoder
# directly into your project. (e.g. you can just do a #include "<${UNIQUE_PREFIX}_>mta_hashes.hpp" in your source)
# where UNIQUE_PREFIX is the optional 4th parameter used in the sercoderbuild() call.
#
function(sercoderdepend_mtahash TARGET TARGET_PREFIX)
    get_property(target_type TARGET ${TARGET} PROPERTY TYPE)
    if (target_type STREQUAL "INTERFACE_LIBRARY")
        target_link_libraries(${TARGET} INTERFACE ${TARGET_PREFIX}_mtahashes)
    else()
        target_link_libraries(${TARGET} PRIVATE ${TARGET_PREFIX}_mtahashes)
    endif()
endfunction(sercoderdepend_mtahash)

#
# Generates a <${UNIQUE_PREFIX}_>class_info_max_size.hpp file (where UNIQUE_PREFIX is the optional 4th parameter
# used in the sercoderbuild() call) that can be included in your project that defines the size of the
# class infos during compile time, not only at link time as sercoderlink does
#
function(sercoderdepend_clsmaxsize TARGET TARGET_PREFIX)
    get_property(target_type TARGET ${TARGET} PROPERTY TYPE)
    if (target_type STREQUAL "INTERFACE_LIBRARY")
        target_link_libraries(${TARGET} INTERFACE ${TARGET_PREFIX}_clsmaxsize)
    else()
        target_link_libraries(${TARGET} PUBLIC ${TARGET_PREFIX}_clsmaxsize)
    endif()
endfunction(sercoderdepend_clsmaxsize)

#
# *****************************************************
# Public function definition
# *****************************************************
#
