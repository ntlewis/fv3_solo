echo " conda environment "


export FC=mpifort
export CC=mpicc
export CXX=mpicxx
export LD=mpifort
export TEMPLATE=site/gnu.mk
export LAUNCHER=mpirun

export AVX_LEVEL=-march=native
#export AVX_LEVEL=-march=cascadelake      