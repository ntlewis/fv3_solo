!***********************************************************************
!*                   GNU Lesser General Public License
!*
!* This file is part of the GFDL FRE NetCDF tools package (FRE-NCTools).
!*
!* FRE-NCTools is free software: you can redistribute it and/or modify it under
!* the terms of the GNU Lesser General Public License as published by
!* the Free Software Foundation, either version 3 of the License, or (at
!* your option) any later version.
!*
!* FRE-NCTools is distributed in the hope that it will be useful, but WITHOUT
!* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
!* FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
!* for more details.
!*
!* You should have received a copy of the GNU Lesser General Public
!* License along with FRE-NCTools..  If not, see
!* <http://www.gnu.org/licenses/>.
!***********************************************************************
!-----------------------------------------------------------------------
! Copyright (C) 2011 NOAA Geophysical Fluid Dynamics Lab, Princeton, NJ
!
! This program lists the variables in a netcdf filei
!
!-----------------------------------------------------------------------

program list_ncvars

use  netcdf
implicit none

character(len=NF90_MAX_NAME) :: filename
logical :: list_nonstatic = .true.
logical :: list_static = .false.
logical :: var4d  = .false.
logical :: var3d  = .false.
logical :: var2d  = .false.
logical :: var1d  = .false.
logical :: var0d  = .false.
namelist /input/ filename, list_nonstatic, list_static, var4d, var3d, var2d, var1d, var0d

integer :: istat, ncid, numdim, numvar, numatt, recdim, &
           varid, ndim, dimids(NF90_MAX_VAR_DIMS), dimid, &
           nc, xtype
logical :: static
character(len=NF90_MAX_NAME) :: name

   filename(1:1) = ' '
   read  (*,input,end=1,err=1)
1  continue

   if (filename(1:1) == ' ') then
       stop
   endif


  !--- opening input file ---
   istat = NF90_OPEN (trim(filename), NF90_NOWRITE, ncid)
   if (istat /= NF90_NOERR) call error_handler (istat)

  !--- get global info for this file ---
   istat = NF90_INQUIRE (ncid, numdim, numvar, numatt, recdim) 
   if (istat /= NF90_NOERR) call error_handler (istat)

  !--- loop over variables ---
   do varid = 1, numvar

      istat = NF90_INQUIRE_VARIABLE (ncid, varid, name=name, ndims=ndim, dimids=dimids, xtype=xtype)
      if (istat /= NF90_NOERR) call error_handler (istat)
     
     !--- skip if character fields ---           
      if (xtype == NF90_CHAR) cycle

     !--- skip dimensions ---
      istat = NF90_INQ_DIMID (ncid, trim(name), dimid)
      if (istat == NF90_NOERR) cycle
 
     !--- skip names ending in _T1, _T2, _DT  ---
      nc = len_trim(name)
      if (name(nc-2:nc) == '_T1' .or. name(nc-2:nc) == '_T2' .or. &
          name(nc-2:nc) == '_DT' .or. name(nc-6:nc) == '_NITEMS') cycle

     !--- is there a record dimension ---
      static = .true.
      if (dimids(ndim) == recdim) then
          static = .false.
          ndim = ndim-1
      endif

      if (.not.list_nonstatic .and. .not.static) cycle
      if (.not.list_static    .and.      static) cycle
      if (.not.var4d .and. ndim == 4) cycle
      if (.not.var3d .and. ndim == 3) cycle
      if (.not.var2d .and. ndim == 2) cycle
      if (.not.var1d .and. ndim == 1) cycle
      if (.not.var0d .and. ndim == 0) cycle
      write (*,*) trim(name)
   enddo

contains

subroutine error_handler (ncode, string)
integer         , intent(in), optional :: ncode
character(len=*), intent(in), optional :: string
character(len=80) :: errstrg
   print *, 'ERROR in program list_ncvars'
   if (present(string)) print *, trim(string)
   if (present(ncode))  then
       errstrg = NF90_STRERROR (ncode) 
       print *, trim(errstrg)
   endif   
   stop 111
 end subroutine error_handler

end program list_ncvars

