SET(Torch_INSTALL_BIN "${Torch_INSTALL_PREFIX}/${Torch_INSTALL_BIN_SUBDIR}")
SET(Torch_INSTALL_MAN "${Torch_INSTALL_PREFIX}/${Torch_INSTALL_MAN_SUBDIR}")
SET(Torch_INSTALL_LIB "${Torch_INSTALL_PREFIX}/${Torch_INSTALL_LIB_SUBDIR}")
SET(Torch_INSTALL_SHARE "${Torch_INSTALL_PREFIX}/${Torch_INSTALL_SHARE_SUBDIR}")
SET(Torch_INSTALL_INCLUDE "${Torch_INSTALL_PREFIX}/${Torch_INSTALL_INCLUDE_SUBDIR}")
SET(Torch_INSTALL_DOK "${Torch_INSTALL_PREFIX}/${Torch_INSTALL_DOK_SUBDIR}")
SET(Torch_INSTALL_HTML "${Torch_INSTALL_PREFIX}/${Torch_INSTALL_HTML_SUBDIR}")
SET(Torch_INSTALL_CMAKE "${Torch_INSTALL_PREFIX}/${Torch_INSTALL_CMAKE_SUBDIR}")
SET(Torch_INSTALL_LUA_PATH "${Torch_INSTALL_PREFIX}/${Torch_INSTALL_LUA_PATH_SUBDIR}")
SET(Torch_INSTALL_LUA_CPATH "${Torch_INSTALL_PREFIX}/${Torch_INSTALL_LUA_CPATH_SUBDIR}")

# reverse relative path to prefix (ridbus is the palindrom of subdir)
FILE(RELATIVE_PATH Torch_INSTALL_BIN_RIDBUS "${Torch_INSTALL_BIN}" "${Torch_INSTALL_PREFIX}/.")
FILE(RELATIVE_PATH Torch_INSTALL_CMAKE_RIDBUS "${Torch_INSTALL_CMAKE}" "${Torch_INSTALL_PREFIX}/.")
GET_FILENAME_COMPONENT(Torch_INSTALL_BIN_RIDBUS "${Torch_INSTALL_BIN_RIDBUS}" PATH)
GET_FILENAME_COMPONENT(Torch_INSTALL_CMAKE_RIDBUS "${Torch_INSTALL_CMAKE_RIDBUS}" PATH)

IF(UNIX)
  SET(CMAKE_SKIP_BUILD_RPATH FALSE)
  SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE) 
  SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
  FILE(RELATIVE_PATH Torch_INSTALL_BIN2LIB 
    "${Torch_INSTALL_BIN}" "${Torch_INSTALL_LIB}")
  FILE(RELATIVE_PATH Torch_INSTALL_BIN2CPATH 
    "${Torch_INSTALL_BIN}" "${Torch_INSTALL_LUA_CPATH}")
  IF(NOT APPLE) 
    OPTION(WITH_DYNAMIC_RPATH 
      "Build libraries with executable relative rpaths (\$ORIGIN)" ON )
  ENDIF(NOT APPLE)
  IF (WITH_DYNAMIC_RPATH OR APPLE)
    SET(CMAKE_INSTALL_RPATH "\$ORIGIN/${Torch_INSTALL_BIN2LIB}")
  ELSE (WITH_DYNAMIC_RPATH OR APPLE)
    SET(CMAKE_INSTALL_RPATH "${Torch_INSTALL_LIB}")
  ENDIF (WITH_DYNAMIC_RPATH OR APPLE)
  SET(CMAKE_INSTALL_NAME_DIR "@executable_path/${Torch_INSTALL_BIN2LIB}")
ENDIF(UNIX)

IF (WIN32)
  SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")
  SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")
ENDIF (WIN32)

# Useful if you need to access sources and you do
# not know if you are in the torch7 build or external package
IF(${CMAKE_PROJECT_NAME} STREQUAL "Torch")
  SET(Torch_SOURCE_PKG "${CMAKE_SOURCE_DIR}/pkg")
  SET(Torch_SOURCE_INCLUDES "${CMAKE_SOURCE_DIR}/lib/luaT" "${CMAKE_SOURCE_DIR}/lib/TH")
  SET(Torch_SOURCE_LUA lua-static)
ELSE()
  SET(Torch_SOURCE_PKG "${Torch_INSTALL_LUA_PATH}")
  SET(Torch_SOURCE_INCLUDES "${Torch_INSTALL_INCLUDE}" "${Torch_INSTALL_INCLUDE}/TH")
  SET(Torch_SOURCE_LUA lua)
ENDIF()
