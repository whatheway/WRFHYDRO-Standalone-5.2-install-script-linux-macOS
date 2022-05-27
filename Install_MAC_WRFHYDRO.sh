#!/usr/bin/env bash

## WRF installation with parallel process.
# Download and install required library and data files for WRF.
# Tested in macOS Catalina 10.15.7
# Tested in 32-bit
# Tested with current available libraries on 05/11/2022
# If newer libraries exist edit script paths for changes
#Estimated Run Time ~ 90 - 150 Minutes with 10mb/s downloadspeed.
#Special thanks to  Youtube's meteoadriatic and GitHub user jamal919

#############################basic package managment############################


brew install gcc libtool automake autoconf make m4 java ksh git wget mpich grads ksh tcsh python@3.9 cmake xorgproto xorgrgb xauth 

##############################Directory Listing############################

export HOME=`cd;pwd`
export DIR=$HOME/WRFHYDRO/Libs
mkdir $HOME/WRF
cd $HOME/WRFHYDRO
mkdir Downloads
mkdir Libs
mkdir Libs/grib2
mkdir Libs/NETCDF


##############################Downloading Libraries############################

cd Downloads
wget -c https://github.com/madler/zlib/archive/refs/tags/v1.2.12.tar.gz
wget -c https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_12_2.tar.gz
wget -c https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.8.1.tar.gz
wget -c https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz
wget -c https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip




#############################Compilers############################


export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran

#############################zlib############################
#Uncalling compilers due to comfigure issue with zlib1.2.12
#With CC & CXX definied ./configure uses different compiler Flags

cd $HOME/WRF/Downloads
tar -xvzf v1.2.12.tar.gz
cd zlib-1.2.12/
CC= CXX= ./configure --prefix=$DIR/grib2
make
make install
make check

#############################libpng############################
cd $HOME/WRF/Downloads
export LDFLAGS=-L$DIR/grib2/lib
export CPPFLAGS=-I$DIR/grib2/include
tar -xvzf libpng-1.6.37.tar.gz
cd libpng-1.6.37/
./configure --prefix=$DIR/grib2
make
make install
make check

#############################JasPer############################

cd $HOME/WRF/Downloads
unzip jasper-1.900.1.zip
cd jasper-1.900.1/
autoreconf -i
./configure --prefix=$DIR/grib2
make
make install
export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include


#############################hdf5 library for netcdf4 functionality############################

cd $HOME/WRF/Downloads
tar -xvzf hdf5-1_12_2.tar.gz
cd hdf5-hdf5-1_12_2
./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran
make 
make install
make check

export HDF5=$DIR/grib2
export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH

##############################Install NETCDF C Library############################
cd $HOME/WRF/Downloads
tar -xzvf v4.8.1.tar.gz
cd netcdf-c-4.8.1/
export CPPFLAGS=-I$DIR/grib2/include 
export LDFLAGS=-L$DIR/grib2/lib
./configure --prefix=$DIR/NETCDF --disable-dap
make 
make install
make check

export PATH=$DIR/NETCDF/bin:$PATH
export NETCDF=$DIR/NETCDF

##############################NetCDF fortran library############################

cd $HOME/WRF/Downloads
tar -xvzf v4.5.4.tar.gz
cd netcdf-fortran-4.5.4/
export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
export CPPFLAGS=-I$DIR/NETCDF/include 
export LDFLAGS=-L$DIR/NETCDF/lib
./configure --prefix=$DIR/NETCDF --disable-shared
make 
make install
make check




############################# WRF HYDRO V5.2.0 #################################
# Version 5.2.0
# Standalone mode
################################################################################

cd $HOME/WRFHYDRO/Downloads
wget -c https://github.com/NCAR/wrf_hydro_nwm_public/archive/refs/tags/v5.2.0.tar.gz -O WRFHYDRO.5.2.tar.gz
tar -xvzf WRFHYDRO.5.2.tar.gz -C $HOME/WRFHYDRO


#Modifying WRF-HYDRO Environment
#Echo commands use due to lack of knowledge
cd $HOME/WRFHYDRO/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS/template

sed -i 's/SPATIAL_SOIL=0/SPATIAL_SOIL=1/g' setEnvar.sh
echo " " >> setEnvar.sh
echo "# Large netcdf file support: 0=Off, 1=On." >> setEnvar.sh
echo "export WRFIO_NCD_LARGE_FILE_SUPPORT=1" >> setEnvar.sh
ln setEnvar.sh $HOME/WRFHYDRO/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS

#Configure & Compile WRF HYDRO in Standalone Mode
#Compile WRF-Hydro offline with the NoahMP
cd $HOME/WRFHYDRO/wrf_hydro_nwm_public-5.2.0/trunk/NDHMS

./configure     # Option 2
./compile_offline_NoahMP.sh setEnvar.sh

ls -lah RUN/*.exe  #Test to see if .exe files have compiled



######################### Testing WRF HYDRO Compliation #########################
cd $HOME/WRFHYDRO
mkdir -p $HOME/WRFHYDRO/domain/NWM

#Copy the *.TBL files to the NWM directory.
cp wrf_hydro_nwm_public*/trunk/NDHMS/Run/*.TBL domain/NWM
#Copy the wrf_hydro.exe file to the NWM directory.
cp wrf_hydro_nwm_public*/trunk/NDHMS/Run/wrf_hydro.exe domain/NWM

#Download test case for WRF HYDRO and move to NWM
cd $HOME/WRFHYDRO/Downloads
wget -c https://github.com/NCAR/wrf_hydro_nwm_public/releases/download/v5.2.0/croton_NY_training_example_v5.2.tar.gz
tar -xzvf croton_NY_training_example_v5.2.tar.gz 

cp -r example_case/FORCING $HOME/WRFHYDRO/domain/NWM
cp -r example_case/NWM/DOMAIN $HOME/WRFHYDRO/domain/NWM
cp -r example_case/NWM/RESTART $HOME/WRFHYDRO/domain/NWM
cp -r example_case/NWM/nudgingTimeSliceObs $HOME/WRFHYDRO/domain/NWM
cp -r example_case/NWM/referenceSim $HOME/WRFHYDRO/domain/NWM
cp example_case/NWM/namelist.hrldas $HOME/WRFHYDRO/domain/NWM
cp example_case/NWM/hydro.namelist $HOME/WRFHYDRO/domain/NWM

#Run Croton NY Test Case
cd $HOME/WRFHYDRO/domain/NWM
mpirun -np 6 ./wrf_hydro.exe
ls -lah HYDRO_RST*
echo "IF HYDRO_RST files exist and have data then wrf_hydro.exe sucessful"

##########################  Export PATH and LD_LIBRARY_PATH ################################
cd $HOME

echo "export PATH=$DIR/bin:$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH" >> ~/.bashrc



########################### Test script for output data  ###################################

#Installing Miniconda3 to WRF directory and updating libraries
source $HOME/WRFHYDRO-Standalone-5.2-install.script-linux-64bit/Miniconda3_Install.sh

##################### WRF Python           ##################
########### WRf-Python compiled via Conda  ##################
########### This is the preferred method by NCAR      ##################
##### https://wrf-python.readthedocs.io/en/latest/installation.html  ##################
source $Miniconda_Install_DIR/etc/profile.d/conda.sh
conda init bash
conda activate base
conda create -n wrf-python -c conda-forge wrf-python
conda activate wrf-python
conda update -n wrf-python --all
conda activate wrf-python
conda install -c conda-forge matplotlib
conda install -c conda-forge NETCDF4

cp  $HOME/WRFHYDRO-Standalone-5.2-install.script-linux-64bit/SurfaceRunoff.py $HOME/WRFHYDRO/domain/NWM


cd $HOME/WRFHYDRO/domain/NWM

python3 SurfaceRunoff.py

okular SurfaceRunoff.pdf



#####################################BASH Script Finished##############################
echo "WRF HYDRO Standalone sucessfully configured and compiled"
echo "Congratulations! You've successfully installed all required files to run the Weather Research Forecast Model HYDRO verison 5.2."
echo "Thank you for using this script" 

