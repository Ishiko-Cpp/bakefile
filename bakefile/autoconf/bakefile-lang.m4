dnl ---------------------------------------------------------------------------
dnl Compiler detection macros by David Elliott
dnl ---------------------------------------------------------------------------


dnl ===========================================================================
dnl Macros to detect non-GNU compilers (MetroWerks, XLC)
dnl ===========================================================================

dnl Based on autoconf _AC_LANG_COMPILER_GNU
AC_DEFUN([_AC_BAKEFILE_LANG_COMPILER_MWERKS],
[AC_CACHE_CHECK([whether we are using the Metrowerks _AC_LANG compiler],
    [bakefile_cv_[]_AC_LANG_ABBREV[]_compiler_mwerks],
    [AC_TRY_COMPILE([],[#ifndef __MWERKS__
       choke me
#endif
],
        [bakefile_compiler_mwerks=yes],
        [bakefile_compiler_mwerks=no])
    bakefile_cv_[]_AC_LANG_ABBREV[]_compiler_mwerks=$bakefile_compiler_mwerks
    ])
])

dnl Loosely based on autoconf AC_PROG_CC
dnl TODO: Maybe this should wrap the call to AC_PROG_CC and be used instead.
AC_DEFUN([AC_BAKEFILE_PROG_MWCC],
[AC_LANG_PUSH(C)
_AC_BAKEFILE_LANG_COMPILER_MWERKS
MWCC=`test $bakefile_cv_c_compiler_mwerks = yes && echo yes`
AC_LANG_POP(C)
])

dnl Loosely based on autoconf AC_PROG_CXX
dnl TODO: Maybe this should wrap the call to AC_PROG_CXX and be used instead.
AC_DEFUN([AC_BAKEFILE_PROG_MWCXX],
[AC_LANG_PUSH(C++)
_AC_BAKEFILE_LANG_COMPILER_MWERKS
MWCXX=`test $bakefile_cv_cxx_compiler_mwerks = yes && echo yes`
AC_LANG_POP(C++)
])

dnl Based on autoconf _AC_LANG_COMPILER_GNU
AC_DEFUN([_AC_BAKEFILE_LANG_COMPILER_XLC],
[AC_CACHE_CHECK([whether we are using the IBM xlC _AC_LANG compiler],
    [wx_cv_[]_AC_LANG_ABBREV[]_compiler_xlc],
    [AC_TRY_COMPILE([],[#ifndef __xlC__
       choke me
#endif
],
        [wx_compiler_xlc=yes],
        [wx_compiler_xlc=no])
    wx_cv_[]_AC_LANG_ABBREV[]_compiler_xlc=$wx_compiler_xlc
    ])
])

dnl Loosely based on autoconf AC_PROG_CC
AC_DEFUN([AC_BAKEFILE_PROG_XLCC],
[AC_LANG_PUSH(C)
_AC_BAKEFILE_LANG_COMPILER_XLC
XLCC=`test $wx_cv_c_compiler_xlc = yes && echo yes`
AC_LANG_POP(C)
])

dnl Loosely based on autoconf AC_PROG_CXX
AC_DEFUN([AC_BAKEFILE_PROG_XLCXX],
[AC_LANG_PUSH(C++)
_AC_BAKEFILE_LANG_COMPILER_XLC
XLCXX=`test $wx_cv_cxx_compiler_xlc = yes && echo yes`
AC_LANG_POP(C++)
])


dnl ===========================================================================
dnl macros to detect specialty compiler options
dnl ===========================================================================

dnl Figure out if we need to pass -ext o to compiler (MetroWerks)
AC_DEFUN([AC_BAKEFILE_METROWERKS_EXTO],
[AC_CACHE_CHECK([if the _AC_LANG compiler requires -ext o], wx_cv_[]_AC_LANG_ABBREV[]_exto,
dnl First create an empty conf test
[AC_LANG_CONFTEST([AC_LANG_PROGRAM()])
dnl Now remove .o and .c.o or .cc.o
rm -f conftest.$ac_objext conftest.$ac_ext.o
dnl Now compile the test
AS_IF([AC_TRY_EVAL(ac_compile)],
dnl If the test succeeded look for conftest.c.o or conftest.cc.o
[for ac_file in `(ls conftest.* 2>/dev/null)`; do
    case $ac_file in
        conftest.$ac_ext.o)
            wx_cv_[]_AC_LANG_ABBREV[]_exto="-ext o"
            ;;
        *)
            ;;
    esac
done],
[AC_MSG_FAILURE([cannot figure out if compiler needs -ext o: cannot compile])
]) dnl AS_IF

rm -f conftest.$ac_ext.o conftest.$ac_objext conftest.$ac_ext
]) dnl AC_CACHE_CHECK

if test "x$wx_cv_[]_AC_LANG_ABBREV[]_exto" '!=' "x"; then
    if test "[]_AC_LANG_ABBREV[]" = "c"; then
        CFLAGS="$wx_cv_[]_AC_LANG_ABBREV[]_exto $CFLAGS"
    fi
    if test "[]_AC_LANG_ABBREV[]" = "cxx"; then
        CXXFLAGS="$wx_cv_[]_AC_LANG_ABBREV[]_exto $CXXFLAGS"
    fi
fi
]) dnl AC_DEFUN


dnl ===========================================================================
dnl Macros to do all of the compiler detections as one macro
dnl ===========================================================================
AC_DEFUN([AC_BAKEFILE_PROG_CC],
[
    AC_PROG_CC
    AC_BAKEFILE_METROWERKS_EXTO
    dnl By the time we find out that we need -ext o some tests have failed.
    if test "x$wx_cv_c_exto" '!=' "x"; then
        unset ac_cv_prog_cc_g
        _AC_PROG_CC_G
    fi
    AC_BAKEFILE_PROG_MWCC
    AC_BAKEFILE_PROG_XLCC
])

AC_DEFUN([AC_BAKEFILE_PROG_CXX],
[
    AC_PROG_CXX
    AC_BAKEFILE_METROWERKS_EXTO
    dnl By the time we find out that we need -ext o some tests have failed.
    if test "x$wx_cv_cxx_exto" '!=' "x"; then
        unset ac_cv_prog_cxx_g
        _AC_PROG_CXX_G
    fi
    AC_BAKEFILE_PROG_MWCXX
    AC_BAKEFILE_PROG_XLCXX
])
