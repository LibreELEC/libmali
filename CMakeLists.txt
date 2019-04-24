cmake_minimum_required(VERSION 2.6)

project(libmali C)
include(GNUInstallDirs)

set(MALI_VARIANT "" CACHE STRING "variant")
set(MALI_REVISION "" CACHE STRING "revision")
set(MALI_ARCH "arm-linux-gnueabihf" CACHE STRING "arch")

if(MALI_VARIANT STREQUAL "400")
    set(MALI_FILE libmali-utgard-400-r7p0-gbm.so)
elseif(MALI_VARIANT STREQUAL "450")
    set(MALI_FILE libmali-utgard-450-r7p0-gbm.so)
elseif(MALI_VARIANT STREQUAL "t620")
    set(MALI_FILE libmali-midgard-t620-r12p0-wayland-gbm.so)
    set(MALI_GLES3 ON)
elseif(MALI_VARIANT STREQUAL "t720")
    set(MALI_FILE libmali-midgard-t720-r18p0-gbm.so)
    set(MALI_GLES3 ON)
elseif(MALI_VARIANT STREQUAL "t760" AND MALI_REVISION STREQUAL "r1p0")
    set(MALI_FILE libmali-midgard-t76x-r14p0-r1p0-gbm.so)
    set(MALI_GLES3 ON)
elseif(MALI_VARIANT STREQUAL "t760")
    set(MALI_FILE libmali-midgard-t76x-r14p0-r0p0-gbm.so)
    set(MALI_GLES3 ON)
elseif(MALI_VARIANT STREQUAL "t860")
    set(MALI_FILE libmali-midgard-t86x-r14p0-gbm.so)
    set(MALI_GLES3 ON)
elseif(MALI_VARIANT STREQUAL "g31")
    set(MALI_FILE libmali-bifrost-g31-rxp0-gbm.so)
    set(MALI_GLES3 ON)
elseif(MALI_VARIANT STREQUAL "g52")
    set(MALI_FILE libmali-bifrost-g52-r16p0-wayland-gbm.so)
    set(MALI_GLES3 ON)
endif()

configure_file(pkgconfig/egl.pc.cmake egl.pc @ONLY)
configure_file(pkgconfig/gbm.pc.cmake gbm.pc @ONLY)
configure_file(pkgconfig/glesv2.pc.cmake glesv2.pc @ONLY)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/egl.pc
              ${CMAKE_CURRENT_BINARY_DIR}/gbm.pc
              ${CMAKE_CURRENT_BINARY_DIR}/glesv2.pc
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)

install(FILES include/gbm.h
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(DIRECTORY include/EGL
                  include/GLES
                  include/GLES2
                  include/KHR
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

if(DEFINED MALI_GLES3)
    install(DIRECTORY include/GLES3 DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
endif()

macro(install_symlink filepath sympath)
    install(CODE "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${filepath} \$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${sympath})")
    install(CODE "message(\"-- Created symlink: \$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${sympath} -> ${filepath}\")")
endmacro(install_symlink)

if(DEFINED MALI_FILE)
    install(FILES lib/${MALI_ARCH}/${MALI_FILE} DESTINATION ${CMAKE_INSTALL_LIBDIR})
    install_symlink(${MALI_FILE} ${CMAKE_INSTALL_LIBDIR}/libmali.so)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libmali.so.0)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libMali.so)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libEGL.so)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libEGL.so.1)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libGLES_CM.so.1)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libGLESv1_CM.so.1)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libGLESv2.so)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libGLESv2.so.2)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libgbm.so)
endif()
