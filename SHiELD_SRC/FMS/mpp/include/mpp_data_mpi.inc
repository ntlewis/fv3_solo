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
!> @file
!> @ingroup mpp_data_mod
!> @brief Holds dummy constants and stack data for @ref mpp_mod and @ref mpp_domains_mod.
!! Accessible through @ref mpp_data_mod

!----------------------------------------------------------------!
! The following data is used in mpp_mod and its components       !
!----------------------------------------------------------------!
integer :: stat(MPI_STATUS_SIZE)
real(r8_kind), allocatable :: mpp_stack(:) !< stack used for general mpp operations

!--- some dummy variables with dummy values that will never be used
integer, parameter :: ptr_stack = -999
integer, parameter :: status=-999, ptr_status = -999
integer, parameter :: remote_data_loc=-999, ptr_remote = -999
integer, parameter :: sync=-999, ptr_sync = -999
integer, parameter :: mpp_from_pe = -999, ptr_from = -999

!-------------------------------------------------------------------!
! The following data is used in mpp_domains_mod and its components  !
!-------------------------------------------------------------------!
real(r8_kind), allocatable :: mpp_domains_stack(:) !< stack used to hold data for domain operations
real(r8_kind), allocatable :: mpp_domains_stack_nonblock(:) !< stack used for non-blocking domain operations
!--- some dummy variables with dummy values that will never be used
integer, parameter :: ptr_domains_stack = -999
integer, parameter :: ptr_domains_stack_nonblock = -999
