echo "intel environment" 

export FC="mpiifort -diag-disable=10448"
export CC=mpiicx
export CXX=mpiicpx
export LD="mpiifort -diag-disable=10448"
export TEMPLATE=site/intel.mk 
export LAUNCHER=mpirun

export AVX_LEVEL=-march=native 

export PREFIX=/home/links/ntl203/utils
export LIBRARY_PATH="${PREFIX}/lib"
export NETCDF_DIR=${PREFIX}
export FMS_CPPDEFS=""
