# Required software packages for macOS before using this script
in the terminal:

1. Command Line Tools

Type the following below command to install command line developer tools package:

> xcode-select --install
 
 
 
2. Homebrew

#### For MacOS Catalina, macOS Mojave, and MacOS Big Sur enter this into terminal:

> /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

#### For macOS High Sierra, Sierra, El Capitan, and earlier enter this into terminal:

> /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
 
 

3. Change default shell from zsh to bash

> chsh -s /bin/bash
 
 

# WRFHYDRO-5.2-install-script
This is a script that installs all the libararies, software, programs, and geostatic data to run the Weather Research Forecast Model Hydro  (WRFHydro-5.2) stand alone.
Script assumes a clean directory with no other WRF configure files in the directory.
**This script does not install NETCDF4 to write compressed NetCDF4 files in parallel**

# Installation 
(Make sure to download folder into your Home Directory): $HOME

> git clone https://github.com/whatheway/WRFHYDRO-Standalone-5.2-install-script-linux-macOS.git

> chmod 775 Install_MAC_WRFHYDRO.sh.sh

> chmod 775 Minicoda3_Install.sh

> ./Install_MAC_WRFHYDRO.sh

# WRF installation with parallel process (dmpar).
Must be installed with GNU compiler, it will not work with other compilers.


# WRF installation with parallel process.

Download and install required library and data files for WRF.

Tested in macOS Big Spur 11.2

Tested with current available libraries on 05/11/2022

If newer libraries exist edit script paths for changes

# Estimated Run Time ~ 30 - 50 Minutes @ 10mbps download speed.
### - Special thanks to  Youtube's meteoadriatic, GitHub user jamal919, University of Manchester's  Doug L, University of Tunis El Manar's Hosni S.

### Sponsorships and donations accepted but NOT required
[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/whatheway)
