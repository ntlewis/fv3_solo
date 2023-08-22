# fv3_solo

Cubed-sphere core from GFDL 

Instructions: 

1) clone with: git clone https://github.com/ntlewis/fv3_solo.git

2) cd into fv3_solo

3) create conda environment with: conda env create -f environment.yml 

4) type: conda activate fv3_solo 

5) Need to compile post processing tools... 

5.1) cd into fv3_solo/FRE-NCtools

5.2) type: mkdir build 

5.3) type: mkdir install 

5.4) cd into build 

5.5) type: ../configure --with-mpi --prefix=**/path/to/**FRE-NCtools/install

5.6) type: make 

5.7) type: make install  

(replace ** font with whatever your path is) 

6) Add the following to your .bashrc: 
export PATH="**/path/to/your/**fv3_solo/FRE-NCtools/install/bin:$PATH"

(replace ** font with whatever your path is) 

7) Need to compile the GCM ... 

7.1) cd into fv3_solo/SHiELD_build/Build

7.2) type: ./COMPILE solo hydro gnu 

8) Make directory to store model data on scratch or similar (mine is called *fv3_solo_work*; see 9.2) 

9) Set the following environemnt variables (add to .bashrc):

9.1) export FV3_BUILDDIR=**/path/to/your/**fv3_solo/SHiELD_build

9.2) export FV3_SCRATCHDIR=**/path/to/your/**fv3_solo_work/

(replace ** font, and also fv3_solo_work, with whatever you've called these things) 

10) Source your .bashrc file so that 6) and 9) take effect: source ~/.bashrc

11) Run the model!

11.1) cd into fv3_solo/exps

11.2) type: ./C48.solo.HS_new 

(this runs a 2deg Held-Suarez like experiment for 30 days, split into 6x5 day runs) 

12) Check output 

12.1) cd to fv3_solo_work (the scratch directory) 

12.2) cd C48.solo.HS_new 

12.3) look at data in history/000*/atmos_daily.nc 