cmake_minimum_required(VERSION 2.6)

project(libmali C)
include(GNUInstallDirs)

set(MALI_VARIANT "" CACHE STRING "variant")
set(MALI_ARCH "arm-linux-gnueabihf" CACHE STRING "arch")

foreach(VARIANT IN LISTS MALI_VARIANT)
    message(STATUS "VARIANT: ${VARIANT}")
    if(VARIANT STREQUAL "400")
        list(APPEND MALI_FILE libmali-utgard-400-r7p0-gbm.so)
    elseif(VARIANT STREQUAL "450")
        list(APPEND MALI_FILE libmali-utgard-450-r7p0-gbm.so)
    elseif(VARIANT STREQUAL "t620")
        list(APPEND MALI_FILE libmali-midgard-t620-r12p0-wayland-gbm.so)
    elseif(VARIANT STREQUAL "t720")
        list(APPEND MALI_FILE libmali-midgard-t720-r18p0-gbm.so)
    elseif(VARIANT STREQUAL "t760")
        list(APPEND MALI_FILE libmali-midgard-t76x-r14p0-r0p0-gbm.so)
        list(APPEND MALI_FILE libmali-midgard-t76x-r14p0-r1p0-gbm.so)
    elseif(VARIANT STREQUAL "t860")
        list(APPEND MALI_FILE libmali-midgard-t86x-r14p0-gbm.so)
    elseif(VARIANT STREQUAL "g31")
        list(APPEND MALI_FILE libmali-bifrost-g31-rxp0-gbm.so)
    elseif(VARIANT STREQUAL "g52")
        list(APPEND MALI_FILE libmali-bifrost-g52-r16p0-wayland-gbm.so)
    endif()
endforeach()

configure_file(pkgconfig/egl.pc.cmake egl.pc @ONLY)
configure_file(pkgconfig/gbm.pc.cmake gbm.pc @ONLY)
configure_file(pkgconfig/glesv1_cm.pc.cmake glesv1_cm.pc @ONLY)
configure_file(pkgconfig/glesv2.pc.cmake glesv2.pc @ONLY)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/egl.pc
              ${CMAKE_CURRENT_BINARY_DIR}/gbm.pc
              ${CMAKE_CURRENT_BINARY_DIR}/glesv1_cm.pc
              ${CMAKE_CURRENT_BINARY_DIR}/glesv2.pc
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)

install(FILES include/gbm.h
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(DIRECTORY include/EGL
                  include/GLES
                  include/GLES2
                  include/GLES3
                  include/KHR
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

macro(install_symlink filepath sympath)
    install(CODE "execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${filepath} \$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${sympath})")
    install(CODE "message(\"-- Created symlink: \$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/${sympath} -> ${filepath}\")")
endmacro(install_symlink)

list(LENGTH MALI_FILE MALI_FILE_LENGTH)

if(MALI_FILE_LENGTH GREATER 0)
    foreach(FILE IN LISTS MALI_FILE)
        message(STATUS "FILE: ${FILE}")
        install(PROGRAMS lib/${MALI_ARCH}/${FILE} DESTINATION ${CMAKE_INSTALL_LIBDIR})
    endforeach()
    list(GET MALI_FILE 0 MALI_FILE_FIRST)
    install_symlink(${MALI_FILE_FIRST} ${CMAKE_INSTALL_LIBDIR}/libmali.so)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libmali.so.0)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libMali.so)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libEGL.so)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libEGL.so.1)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libGLESv1_CM.so)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libGLESv1_CM.so.1)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libGLESv2.so)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libGLESv2.so.2)
    install_symlink(libmali.so ${CMAKE_INSTALL_LIBDIR}/libgbm.so)
endif()
