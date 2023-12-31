! -*-f90-*-
!***********************************************************************
!*                   GNU Lesser General Public License
!*
!* This file is part of the GFDL Flexible Modeling System (FMS).
!*
!* FMS is free software: you can redistribute it and/or modify it under
!* the terms of the GNU Lesser General Public License as published by
!* the Free Software Foundation, either version 3 of the License, or (at
!* your option) any later version.
!*
!* FMS is distributed in the hope that it will be useful, but WITHOUT
!* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
!* FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
!* for more details.
!*
!* You should have received a copy of the GNU Lesser General Public
!* License along with FMS.  If not, see <http://www.gnu.org/licenses/>.
!***********************************************************************


   if((size(data,1)== ied-isd+1).and.(size(data,2)==jed-jsd+1)) then
     no_halo = .false.
   elseif ((size(data,1)== ie-is+1).and.(size(data,2)==je-js+1))  then
     no_halo = .true.
   else
     call mpp_error(FATAL,'fms_io read_data_2d, data must be either data or compute domain')
   endif


   if (.not.module_is_initialized) call fms_io_init ( )

   if (.not.associated(Current_domain)) call mpp_error &
        (FATAL,'set_domain not called')

   if (present(end)) end = .false.

   if (do_read()) read (unit,end=10) gdata
   if (.not.read_all_pe) then
      ! did not read on all PEs need to broadcast data
      len = size(gdata,1)*size(gdata,2)
!           call mpp_transmit ( gdata, len, ALL_PES, &
!                               gdata, len, 0        )
      call mpp_broadcast ( gdata, len, mpp_root_pe() )
   endif
   if(.not. no_halo) then
! data dimensioned on data domain
      data(is:ie,js:je) = gdata(is:ie,js:je)
   else
! data defined on compute domain
      data(:,:) = gdata(is:ie,js:je)
   endif
   return

10 call read_eof (end)
