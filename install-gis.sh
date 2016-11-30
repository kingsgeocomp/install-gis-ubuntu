#!/bin/bash

# How to install:
# > git clone https://github.com/kingsgeocomp/install-gis-ubuntu.git
# > install-gis-ubuntu/install-gis.sh

DROPBOX   = "N" # Install Dropbox
UNSTABLE  = "N" # Use unstable UbuntuGIS repos
EXTRAS    = "N" # Useful extras for full env
UPGRADE   = "N" # Upgrade entire system
INSTALLR  = "N" # Install R & R-Studio 
INSTALLJ  = "N" # Install Java & JOSM
INSTALLPY = "Y" # Install Python & Py-GIS tools
MINIMAL   = "Y" # Don't install lots of useful add-ons

printf "Your version of Ubuntu is:\n"
lsb_release -a | grep -P "(Codename|Description)"
printf "\n"

# In case we're not there already
cd install-gis-ubuntu/

# Refresh repos automatically
sudo apt-get update -y 
# We need git right from the start
sudo apt-get install git -y 

# install non-gis specific tools
printf "\n\n*************\n"
printf "* Installing useful non-GIS tools...\n"
sudo apt-get install -y software-properties-common # to ease adding new ppas
sudo apt-get install -y python-software-properties # Seems to help with QGIS

if [ "$DROPBOX" = "Y" ]; then
	printf "\n** Installing Dropbox...\n" # grab dropbox
	cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
	sudo apt-get install dropbox
fi
if [ "$EXTRAS" = "Y" ]; then
	sudo apt-get install guake # guake for retro bash shell dropdown
	sudo apt-get install texlive-extra-utils
fi

# from:  https://medium.com/@ramiroaznar/how-to-install-the-most-common-open-source-gis-applications-on-ubuntu-dbe9d612347b
# add repos
printf "\n\n*************\n"
printf "* Installing GIS-related tools...\n"

if [ "$UNSTABLE" = "Y" ]; then
	printf "** Specifying unstable UbuntuGIS repo to get latest QGIS...\n"
	printf "*** Removing any installed version of QGIS...\n"
	sudo apt-get remove -y qgis python-qgis qgis-plugin-grass
	sudo apt-get autoremove -y
	printf "*** Adding unstable repo...\n"
	sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
	sudo apt-get update
	sudo apt-get install -y qgis python-qgis qgis-plugin-grass
else
	printf "** Sticking to stable install...\n"
	sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
	sudo apt-get update
	sudo apt-get install -y qgis python-qgis qgis-plugin-grass
fi
printf "\n** Installing PostgreSQL...\n"
sudo apt-get install -y postgresql postgresql-contrib

if [ "$INSTALLJ" = "Y" ]; then
	printf "\n** Installing JOSM...\n"
	sudo apt-get install -y openjdk-8-jre 
	printf deb https://josm.openstreetmap.de/apt alldist universe | sudo tee /etc/apt/sources.list.d/josm.list > /dev/null
	wget -q https://josm.openstreetmap.de/josm-apt.key -O- | sudo apt-key add -
	sudo apt-get update
	sudo apt install -y josm
fi 
printf "\n** Installing Lib-Proj and Lib-GEOS...\n"
sudo apt-get install -y libproj-dev libgeos-dev libgeos++-dev libgeos-c1v5

# install gdal
printf "\n** Installing GDAL...\n"
FLAV=$(lsb_release -c | awk 'BEGIN { FS="\t" }; {print $2}') 
if [ $FLAV = "xenial" ]; then
  sudo apt-get install -y gdal-bin libgdal-dev libgdal1-dev 
else
  bash install-gdal.sh
fi

if [ "$UPGRADE" = "Y" ]; then
	printf "\n\n*************\n"
	printf "* Upgrading system...\n"
	sudo apt-get update  -y
	sudo apt-get upgrade  -y
fi
# install R/RStudio - see
# http://stackoverflow.com/questions/29667330
if [ "$MINIMAL" = "N" ]; then
	printf "\n\n*************\n"
	printf "Installing dependencies for workflow...\n"
	sudo apt-get update  -y
	sudo apt-get install libgstreamer0.10-0 -y
	sudo apt-get install libgstreamer-plugins-base0.10-dev -y
	sudo apt-get install libcurl4-openssl-dev -y
	sudo apt-get install libssl-dev -y
	sudo apt-get install libopenblas-base -y
	sudo apt-get install libxml2-dev -y
	sudo apt-get install make -y
	sudo apt-get install gcc -y
	sudo apt-get install pandoc -y
	sudo apt-get install libjpeg62 -y
	sudo apt-get install unzip -y
	sudo apt-get install curl -y
	sudo apt-get install gedit -y
	sudo apt-get install jags -y
	sudo apt-get install imagemagick -y
	sudo apt-get install libv8-dev -y
fi 

############################################
### Python Geographic Data Science Stack ###
############################################
if [ "$INSTALLPY" = "Y" ]; then
	printf "\n** Switching to Python GDS stack...\n"
	git clone https://github.com/darribas/gds_env.git
	cd gds_env
	conda update --yes conda
	conda install --yes psutil yaml pyyaml
	printf "** Installing GDS stack...\n"
	conda-env create -f install_gds_stack.yml
	
	printf 
	printf "\n\n******************\n"
	printf "You may need toa dd the following to your .bashrc file:\n"
	printf "
export DEFAULTPATH=$PATH\n
export CONDAPATH=$HOME/anaconda2/bin:$PATH\n
export QGISPATH=$PATH\n
export PATH=$DEFAULTPATH\n"

else
	printf "** Skipping Python...\n"
fi

# more non GIS but programming stuff - optional, add your own stuff here
# sudo add-apt-repository ppa:neovim-ppa/unstable # nvim: new version of vim
# sudo apt-get update # see https://github.com/neovim/neovim/wiki/Installing-Neovim
# sudo apt-get install neovim
# sudo apt-get install zsh # nice evolution of bash
# sudo apt-get install git-core # from https://www.thinkingmedia.ca/2014/10/how-to-install-oh-my-zsh-on-ubuntu-14/
# Now you can install Oh My Zsh.
# sudo curl -L http://install.ohmyz.sh | sh

# done.
printf "\n\n**************\n"
printf "All done.\n"
printf "Type: 'source activate gds_test' before running Python in the Terminal.\n"
printf "Note that the full Anaconda Python and QGIS may not live together happily without some tweaking of the startup script for QGIS.\n"

