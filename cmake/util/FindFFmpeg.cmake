# - Try to find ffmpeg libraries (libavcodec, libavformat and libavutil)
# Once done this will define
#
# FFMPEG_FOUND - system has ffmpeg or libav
# FFMPEG_INCLUDE_DIR - the ffmpeg include directory
# FFMPEG_LIBRARIES - Link these to use ffmpeg
# FFMPEG_LIBAVCODEC
# FFMPEG_LIBAVFORMAT
# FFMPEG_LIBAVUTIL
# FFMPEG_LIBAVDEVICE
#
# Copyright (c) 2008 Andreas Schneider <mail@cynapses.org>
# Modified for other libraries by Lasse Kärkkäinen <tronic>
# Modified for Hedgewars by Stepik777
#
# Redistribution and use is allowed according to the terms of the New
# BSD license.
#
set(FFMPEG_DIR "/usr/local/Cellar/ffmpeg/4.3.1_9")
if (FFMPEG_DIR)
  set(FFMPEG_INCLUDE_DIR ${FFMPEG_DIR}/include)
  if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    # Mac OS X specific code
    set(FFMPEG_LIBRARIES
      ${FFMPEG_DIR}/lib/libavformat.dylib
      ${FFMPEG_DIR}/lib/libavfilter.dylib
      ${FFMPEG_DIR}/lib/libavcodec.dylib
      ${FFMPEG_DIR}/lib/libavutil.dylib
      ${FFMPEG_DIR}/lib/libavdevice.dylib
      ${FFMPEG_DIR}/lib/libswresample.dylib
    )
  elseif(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
    set(FFMPEG_LIBRARIES
      ${FFMPEG_DIR}/lib/libavformat.so
      ${FFMPEG_DIR}/lib/libavfilter.so
      ${FFMPEG_DIR}/lib/libavcodec.so
      ${FFMPEG_DIR}/lib/libavutil.so
      ${FFMPEG_DIR}/lib/libavdevice.so
      ${FFMPEG_DIR}/lib/libswresample.so
    )
  else()
    set(FFMPEG_LIBRARIES
      ${FFMPEG_DIR}/lib/libavformat.lib
      ${FFMPEG_DIR}/lib/libavfilter.lib
      ${FFMPEG_DIR}/lib/libavcodec.lib
      ${FFMPEG_DIR}/lib/libavutil.lib
      ${FFMPEG_DIR}/lib/libavdevice.lib
      ${FFMPEG_DIR}/lib/libswresample.lib
    )
  endif()
endif (FFMPEG_DIR)

if (FFMPEG_LIBRARIES AND FFMPEG_INCLUDE_DIR)
# in cache already
set(FFMPEG_FOUND TRUE)
else (FFMPEG_LIBRARIES AND FFMPEG_INCLUDE_DIR)
# use pkg-config to get the directories and then use these values
# in the FIND_PATH() and FIND_LIBRARY() calls
find_package(PkgConfig)
if (PKG_CONFIG_FOUND)
pkg_check_modules(_FFMPEG_AVCODEC libavcodec)
pkg_check_modules(_FFMPEG_AVFORMAT libavformat)
pkg_check_modules(_FFMPEG_AVUTIL libavutil)
pkg_check_modules(_FFMPEG_AVDEVICE libavdevice)

pkg_check_modules(_FFMPEG_AVFILTER libavfilter)
pkg_check_modules(_FFMPEG_SWRESAMPLE libswresample)
endif (PKG_CONFIG_FOUND)

find_path(FFMPEG_AVCODEC_INCLUDE_DIR
NAMES libavcodec/avcodec.h
PATHS ${_FFMPEG_AVCODEC_INCLUDE_DIRS} /usr/include /usr/local/include /opt/local/include /sw/include
PATH_SUFFIXES ffmpeg libav
)

find_library(FFMPEG_LIBAVCODEC
NAMES avcodec
PATHS ${_FFMPEG_AVCODEC_LIBRARY_DIRS} /usr/lib /usr/local/lib /opt/local/lib /sw/lib
)

find_library(FFMPEG_LIBAVFORMAT
NAMES avformat
PATHS ${_FFMPEG_AVFORMAT_LIBRARY_DIRS} /usr/lib /usr/local/lib /opt/local/lib /sw/lib
)

find_library(FFMPEG_LIBAVUTIL
NAMES avutil
PATHS ${_FFMPEG_AVUTIL_LIBRARY_DIRS} /usr/lib /usr/local/lib /opt/local/lib /sw/lib
)

find_library(FFMPEG_LIBAVDEVICE
NAMES avdevice
PATHS ${_FFMPEG_AVDEVICE_LIBRARY_DIRS} /usr/lib /usr/local/lib /opt/local/lib /sw/lib
)

find_library(FFMPEG_LIBAVFILTER
NAMES avfilter
PATHS ${_FFMPEG_AVFILTER_LIBRARY_DIRS} /usr/lib /usr/local/lib /opt/local/lib /sw/lib
)

find_library(FFMPEG_LIBSWRESAMPLE
NAMES libswresample
PATHS ${_FFMPEG_SWRESAMPLE_LIBRARY_DIRS} /usr/lib /usr/local/lib /opt/local/lib /sw/lib
)

if (FFMPEG_LIBAVCODEC AND FFMPEG_LIBAVFORMAT)
set(FFMPEG_FOUND TRUE)
endif()

if (FFMPEG_FOUND)
set(FFMPEG_INCLUDE_DIR ${FFMPEG_AVCODEC_INCLUDE_DIR})

set(FFMPEG_LIBRARIES
  ${FFMPEG_LIBAVFORMAT}
  ${FFMPEG_LIBAVFILTER}
  ${FFMPEG_LIBAVCODEC}
  ${FFMPEG_LIBAVUTIL}
  ${FFMPEG_LIBSWRESAMPLE}
)

if (FFMPEG_LIBAVDEVICE)
  message(STATUS "Found libavdevice, device input will be enabled")
  set(FFMPEG_LIBRARIES ${FFMPEG_LIBRARIES} ${FFMPEG_LIBAVDEVICE})
  add_definitions(-DDECORD_USE_LIBAVDEVICE)
else (FFMPEG_LIBAVDEVICE)
  message(STATUS "Unable to find libavdevice, device input API will not work!")
endif (FFMPEG_LIBAVDEVICE)

endif (FFMPEG_FOUND)

if (FFMPEG_FOUND)
if (NOT FFMPEG_FIND_QUIETLY)
message(STATUS "Found FFMPEG or Libav: ${FFMPEG_LIBRARIES}, ${FFMPEG_INCLUDE_DIR}")
endif (NOT FFMPEG_FIND_QUIETLY)
else (FFMPEG_FOUND)
if (FFMPEG_FIND_REQUIRED)
message(FATAL_ERROR "Could not find libavcodec or libavformat or libavutil")
endif (FFMPEG_FIND_REQUIRED)
endif (FFMPEG_FOUND)

endif (FFMPEG_LIBRARIES AND FFMPEG_INCLUDE_DIR)
