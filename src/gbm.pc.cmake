prefix=/usr
exec_prefix=${prefix}
libdir=${prefix}/@CMAKE_INSTALL_LIBDIR@
includedir=${prefix}/@CMAKE_INSTALL_INCLUDEDIR@

Name: gbm
Description: Mali gbm library
Version: 17.3.0
Libs: -L${libdir} -lmali -lgbm
Libs.private: -lm -lpthread
Cflags: -I${includedir}
