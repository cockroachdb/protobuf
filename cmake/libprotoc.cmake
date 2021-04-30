set(libprotoc_files
  ${protobuf_source_dir}/src/google/protobuf/compiler/code_generator.cc
  ${protobuf_source_dir}/src/google/protobuf/compiler/command_line_interface.cc
  ${protobuf_source_dir}/src/google/protobuf/compiler/js/js_generator.cc
  ${protobuf_source_dir}/src/google/protobuf/compiler/js/well_known_types_embed.cc
  ${protobuf_source_dir}/src/google/protobuf/compiler/plugin.cc
  ${protobuf_source_dir}/src/google/protobuf/compiler/plugin.pb.cc
  ${protobuf_source_dir}/src/google/protobuf/compiler/subprocess.cc
  ${protobuf_source_dir}/src/google/protobuf/compiler/zip_writer.cc
)

include(${protobuf_SOURCE_DIR}/src/file_lists.cmake)
include(${protobuf_SOURCE_DIR}/cmake/protobuf-configure-target.cmake)

add_library(libprotoc ${protobuf_SHARED_OR_STATIC}
  ${libprotoc_srcs}
  ${libprotoc_hdrs}
  ${protobuf_version_rc_file})
if(protobuf_HAVE_LD_VERSION_SCRIPT)
  if(${CMAKE_VERSION} VERSION_GREATER 3.13 OR ${CMAKE_VERSION} VERSION_EQUAL 3.13)
    target_link_options(libprotoc PRIVATE -Wl,--version-script=${protobuf_SOURCE_DIR}/src/libprotoc.map)
  elseif(protobuf_BUILD_SHARED_LIBS)
    target_link_libraries(libprotoc PRIVATE -Wl,--version-script=${protobuf_SOURCE_DIR}/src/libprotoc.map)
  endif()
  set_target_properties(libprotoc PROPERTIES
    LINK_DEPENDS ${protobuf_SOURCE_DIR}/src/libprotoc.map)
endif()
target_link_libraries(libprotoc PRIVATE libprotobuf)
target_link_libraries(libprotoc PUBLIC ${protobuf_ABSL_USED_TARGETS})
protobuf_configure_target(libprotoc)
if(protobuf_BUILD_SHARED_LIBS)
  target_compile_definitions(libprotoc
    PUBLIC  PROTOBUF_USE_DLLS
    PRIVATE LIBPROTOC_EXPORTS)
endif()
set_target_properties(libprotoc PROPERTIES
    COMPILE_DEFINITIONS LIBPROTOC_EXPORTS
    VERSION ${protobuf_VERSION}
    OUTPUT_NAME ${LIB_PREFIX}protoc
    DEBUG_POSTFIX "${protobuf_DEBUG_POSTFIX}"
    # For -fvisibility=hidden and -fvisibility-inlines-hidden
    C_VISIBILITY_PRESET hidden
    CXX_VISIBILITY_PRESET hidden
    VISIBILITY_INLINES_HIDDEN ON
)
add_library(protobuf::libprotoc ALIAS libprotoc)
