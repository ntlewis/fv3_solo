#################################################################################################
# Copyright (c) 2010, Lawrence Livermore National Security, LLC.
# Produced at the Lawrence Livermore National Laboratory
# Written by Todd Gamblin, tgamblin@llnl.gov.
# LLNL-CODE-417602
# All rights reserved.
#
# This file is part of Libra. For details, see http://github.com/tgamblin/libra.
# Please also read the LICENSE file for further information.
#
# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice, this list of
#    conditions and the disclaimer below.
#  * Redistributions in binary form must reproduce the above copyright notice, this list of
#    conditions and the disclaimer (as noted below) in the documentation and/or other materials
#    provided with the distribution.
#  * Neither the name of the LLNS/LLNL nor the names of its contributors may be used to endorse
#    or promote products derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
# LAWRENCE LIVERMORE NATIONAL SECURITY, LLC, THE U.S. DEPARTMENT OF ENERGY OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#################################################################################################

#
# LX_FIND_MPI()
#  ------------------------------------------------------------------------
# This macro finds an MPI compiler and extracts includes and libraries from
# it for use in automake projects.  The script exports the following variables:
#
# AC_DEFINE variables:
#     HAVE_MPI         AC_DEFINE'd to 1 if we found MPI
#
# AC_SUBST variables:
#     MPICC            Name of MPI compiler
#     MPI_CFLAGS       Includes and defines for MPI C compilation
#     MPI_CLDFLAGS     Libraries and library paths for linking MPI C programs
#
#     MPICXX           Name of MPI C++ compiler
#     MPI_CXXFLAGS     Includes and defines for MPI C++ compilation
#     MPI_CXXLDFLAGS   Libraries and library paths for linking MPI C++ programs
#
#     MPIF77           Name of MPI Fortran 77 compiler
#     MPI_F77FLAGS     Includes and defines for MPI Fortran 77 compilation
#     MPI_F77LDFLAGS   Libraries and library paths for linking MPI Fortran 77 programs
#
#     MPIFC            Name of MPI Fortran compiler
#     MPI_FFLAGS       Includes and defines for MPI Fortran compilation
#     MPI_FLDFLAGS     Libraries and library paths for linking MPI Fortran programs
#
# Shell variables output by this macro:
#     have_C_mpi       'yes' if we found MPI for C, 'no' otherwise
#     have_CXX_mpi     'yes' if we found MPI for C++, 'no' otherwise
#     have_F77_mpi     'yes' if we found MPI for F77, 'no' otherwise
#     have_F_mpi       'yes' if we found MPI for Fortran, 'no' otherwise
#
AC_DEFUN([LX_FIND_MPI], [

AC_REQUIRE([AC_PROG_GREP])
AC_REQUIRE([AC_PROG_SED])

AC_ARG_WITH([mpi],
   [AS_HELP_STRING(
      [--with-mpi=[yes/no/PATH]],
      [Use MPI compilers.  (PATH=path to MPI install location) (Default=no)])],
   [if test "x${withval}" = "xno"; then
      with_mpi=no
    elif test "x${withval}" = "xyes"; then
       with_mpi=yes
       MPI_PREFIX_BIN=${PATH}
    else
      with_mpi=yes
      MPI_PREFIX_BIN="${withval}/bin"
    fi],
   [with_mpi=no])

AS_IF([test x"$with_mpi" = x"yes"], [
   AC_LANG_CASE(
   [C], [
      AC_REQUIRE([AC_PROG_CC])
      AS_IF([test ! -z "$MPICC"],
         [_LX_QUERY_MPI_COMPILER(MPICC, [$MPICC], C, [$MPI_PREFIX_BIN])],
         [_LX_QUERY_MPI_COMPILER(MPICC, [mpicc mpiicc mpixlc mpipgcc cc $CC], C, [$MPI_PREFIX_BIN])])
   ],
   [C++], [
      AC_REQUIRE([AC_PROG_CXX])
      AS_IF([test ! -z "$MPICXX"],
         [_LX_QUERY_MPI_COMPILER(MPICXX, [$MPICXX], CXX, [$MPI_PREFIX_BIN])],
         [_LX_QUERY_MPI_COMPILER(MPICXX, [mpicxx mpiCC mpic++ mpig++ mpiicpc mpipgCC mpixlC CC $CXX], CXX, [$MPI_PREFIX_BIN])])
   ],
   [F77], [
      AC_REQUIRE([AC_PROG_F77])
      AS_IF([test ! -z "$MPIF77" ],
         [_LX_QUERY_MPI_COMPILER(MPIF77, [$MPIF77], F77, [$MPI_PREFIX_BIN])],
         [_LX_QUERY_MPI_COMPILER(MPIF77, [mpif77 mpiifort mpixlf77 mpixlf77_r ftn $F77], F77, [$MPI_PREFIX_BIN])])
   ],
   [Fortran], [
      AC_REQUIRE([AC_PROG_FC])
      AS_IF([test ! -z "$MPIFC" ],
         [_LX_QUERY_MPI_COMPILER(MPIFC, [$MPIFC], F, [$MPI_PREFIX_BIN])],
         [mpi_default_fc="mpif95 mpif90 mpigfortran mpif2003"
          mpi_intel_fc="mpiifort"
          mpi_xl_fc="mpixlf95 mpixlf95_r mpixlf90 mpixlf90_r mpixlf2003 mpixlf2003_r"
          mpi_pg_fc="mpipgf95 mpipgf90"
          _LX_QUERY_MPI_COMPILER(MPIFC, [$mpi_default_fc $mpi_intel_fc $mpi_xl_fc $mpi_pg_fc ftn $FC], F, [$MPI_PREFIX_BIN])])
   ])
])
])


#
# LX_QUERY_MPI_COMPILER([compiler-var-name], [compiler-names], [output-var-prefix], [path])
#  ------------------------------------------------------------------------
# AC_SUBST variables:
#     MPI_<prefix>FLAGS       Includes and defines for MPI compilation
#     MPI_<prefix>LDFLAGS     Libraries and library paths for linking MPI C programs
#
# Shell variables output by this macro:
#     found_mpi_flags         'yes' if we were able to get flags, 'no' otherwise
#
AC_DEFUN([_LX_QUERY_MPI_COMPILER],[
# Try to find a working MPI compiler from the supplied names
AC_PATH_PROGS($1, [$2], [not-found], [$4])

# Figure out what the compiler responds to to get it to show us the compile
# and link lines.  After this part of the macro, we'll have a valid
# lx_mpi_command_line
mpi_prog_options="
   -showme:compile
   -showme
   -compile-info
   -show
   -craype-verbose"
for mpiopttest in ${mpi_prog_options}; do
   AC_MSG_CHECKING([whether $$1 responds to '$mpiopttest'])
   case $mpiopttest in
   -showme:compile)
      lx_mpi_compile_line=$($$1 -showme:compile 2>/dev/null)
      AS_IF([test "$?" -eq 0],
         [AC_MSG_RESULT([yes])
          lx_mpi_link_line=$($$1 -showme:link 2>/dev/null)
          break],
         [AC_MSG_RESULT([no])])
      ;;
   -showme)
      lx_mpi_compile_line=$($$1 -showme 2>/dev/null)
      AS_IF([test "$?" -eq 0],
         [AC_MSG_RESULT([yes])
          break],
         [AC_MSG_RESULT([no])])
      ;;
   -compile-info)
      lx_mpi_compile_line=$($$1 -compile-info 2>/dev/null)
      AS_IF([test "$?" -eq 0],
         [AC_MSG_RESULT([yes])
          lx_mpi_link_line=$($$1 -link-info 2>/dev/null)
          break],
         [AC_MSG_RESULT([no])])
      ;;
   -show)
      lx_mpi_compile_line=$($$1 -show 2>/dev/null)
      AS_IF([test "$?" -eq 0],
         [AC_MSG_RESULT([yes])
          break],
         [AC_MSG_RESULT([no])])
      ;;
   -craype-verbose)
      lx_mpi_compile_line=$($$1 -craype-verbose 2>/dev/null)
      # The Cray wrappers require a source, thus will always exit non-zero.
      # the check is only to see if lx_mpi_compile_line is empty
      AS_IF([test ! -z "$lx_mpi_compile_line"],
         [AC_MSG_RESULT([yes])
          break],
         [AC_MSG_RESULT([no])])
      ;;
   esac
done

if test ! -z "$lx_mpi_compile_line" -o ! -z "$lx_mpi_link_line"; then
   lx_mpi_command_line="$lx_mpi_compile_line $lx_mpi_link_line"
fi

AS_IF([test ! -z "$lx_mpi_command_line"],
   [# Now extract the different parts of the MPI command line.  Do these separately in case we need to
    # parse them all out in future versions of this macro.
    lx_mpi_defines=$(echo "$lx_mpi_command_line" | $GREP -o -- '\(^\| \)-D\([[^\"[:space:]]]\+\|\"[[^\"[:space:]]]\+\"\)')
    lx_mpi_includes=$(echo "$lx_mpi_command_line" | $GREP -o -- '\(^\| \)-I\([[^\"[:space:]]]\+\|\"[[^\"[:space:]]]\+\"\)')
    lx_mpi_link_paths=$(echo "$lx_mpi_command_line" | $GREP -o -- '\(^\| \)-L\([[^\"[:space:]]]\+\|\"[[^\"[:space:]]]\+\"\)')
    lx_mpi_libs=$(echo "$lx_mpi_command_line" | $GREP -o -- '\(^\| \)-l\([[^\"[:space:]]]\+\|\"[[^\"[:space:]]]\+\"\)')
    lx_mpi_link_args=$(echo "$lx_mpi_command_line" | $GREP -o -- '\(^\| \)-Wl,\([[^\"[:space:]]]\+\|\"[[^\"[:space:]]]\+\"\)')

    # Create variables and clean up newlines and multiple spaces
    MPI_$3FLAGS="$lx_mpi_defines $lx_mpi_includes"
    MPI_$3LDFLAGS="$lx_mpi_link_paths $lx_mpi_libs $lx_mpi_link_args"
    MPI_$3FLAGS=$(echo "$MPI_$3FLAGS"   | tr '\n' ' ' | $SED 's/^[[ \t]]*//;s/[[ \t]]*$//' | $SED 's/  +/ /g')
    MPI_$3LDFLAGS=$(echo "$MPI_$3LDFLAGS" | tr '\n' ' ' | $SED 's/^[[ \t]]*//;s/[[ \t]]*$//' | $SED 's/  +/ /g')

    lx_find_mpi_save_CPPFLAGS=$CPPFLAGS
    lx_find_mpi_save_LIBS=$LIBS

    CPPFLAGS=$MPI_$3FLAGS
    LIBS=$MPI_$3LDFLAGS

    AC_LINK_IFELSE(
      [AC_LANG_PROGRAM([#include <mpi.h>],
      [int rank, size;
       MPI_Comm_rank(MPI_COMM_WORLD, &rank);
       MPI_Comm_size(MPI_COMM_WORLD, &size);])],
      [# Add a define for testing at compile time.
       AC_DEFINE([HAVE_MPI], [1], [Define to 1 if you have MPI libs and headers.])
      have_$3_mpi='yes'],
      [# zero out mpi flags so we don't link against the faulty library.
       MPI_$3FLAGS=""
       MPI_$3LDFLAGS=""
       have_$3_mpi='no'])

    # AC_SUBST everything.
    AC_SUBST($1)
    AC_SUBST(MPI_$3FLAGS)
    AC_SUBST(MPI_$3LDFLAGS)

    LIBS=$lx_find_mpi_save_LIBS
    CPPFLAGS=$lx_find_mpi_save_CPPFLAGS],
   [echo Unable to find suitable MPI Compiler. Try setting $1.
    have_$3_mpi='no'])
])
