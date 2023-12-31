netcdf C192_mosaic {
dimensions:
	ntiles = 6 ;
	ncontact = 12 ;
	str = 255 ;
variables:
	char mosaic(str) ;
		mosaic:standard_name = "grid_mosaic_spec" ;
		mosaic:children = "gridtiles" ;
		mosaic:contact_regions = "contacts" ;
		mosaic:grid_descriptor = "" ;
	char gridlocation(str) ;
		gridlocation:standard_name = "grid_file_location" ;
	char gridfiles(ntiles, str) ;
	char gridtiles(ntiles, str) ;
	char contacts(ncontact, str) ;
		contacts:standard_name = "grid_contact_spec" ;
		contacts:contact_type = "boundary" ;
		contacts:alignment = "true" ;
		contacts:contact_index = "contact_index" ;
		contacts:orientation = "orient" ;
	char contact_index(ncontact, str) ;
		contact_index:standard_name = "starting_ending_point_index_of_contact" ;

// global attributes:
		:grid_version = "0.2" ;
		:code_version = "$Name: fre-nctools-bronx-3 $" ;
		:history = "make_solo_mosaic --num_tiles 6 --dir ./ --mosaic C192_mosaic --tile_file C192_grid.tile1.nc,C192_grid.tile2.nc,C192_grid.tile3.nc,C192_grid.tile4.nc,C192_grid.tile5.nc,C192_grid.tile6.nc" ;
data:

 mosaic = "C192_mosaic" ;

 gridlocation = "./" ;

 gridfiles =
  "C192_grid.tile1.nc",
  "C192_grid.tile2.nc",
  "C192_grid.tile3.nc",
  "C192_grid.tile4.nc",
  "C192_grid.tile5.nc",
  "C192_grid.tile6.nc" ;

 gridtiles =
  "tile1",
  "tile2",
  "tile3",
  "tile4",
  "tile5",
  "tile6" ;

 contacts =
  "C192_mosaic:tile1::C192_mosaic:tile2",
  "C192_mosaic:tile1::C192_mosaic:tile3",
  "C192_mosaic:tile1::C192_mosaic:tile5",
  "C192_mosaic:tile1::C192_mosaic:tile6",
  "C192_mosaic:tile2::C192_mosaic:tile3",
  "C192_mosaic:tile2::C192_mosaic:tile4",
  "C192_mosaic:tile2::C192_mosaic:tile6",
  "C192_mosaic:tile3::C192_mosaic:tile4",
  "C192_mosaic:tile3::C192_mosaic:tile5",
  "C192_mosaic:tile4::C192_mosaic:tile5",
  "C192_mosaic:tile4::C192_mosaic:tile6",
  "C192_mosaic:tile5::C192_mosaic:tile6" ;

 contact_index =
  "384:384,1:384::1:1,1:384",
  "1:384,384:384::1:1,384:1",
  "1:1,1:384::384:1,384:384",
  "1:384,1:1::1:384,384:384",
  "1:384,384:384::1:384,1:1",
  "384:384,1:384::384:1,1:1",
  "1:384,1:1::384:384,384:1",
  "384:384,1:384::1:1,1:384",
  "1:384,384:384::1:1,384:1",
  "1:384,384:384::1:384,1:1",
  "384:384,1:384::384:1,1:1",
  "384:384,1:384::1:1,1:384" ;
}
