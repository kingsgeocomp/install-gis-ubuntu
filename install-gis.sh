#!/bin/bash

# How to install:
# > git clone https://github.com/kingsgeocomp/install-gis-ubuntu.git
# > install-gis-ubuntu/install-gis.sh

STABLE    = "Y" # Use unstable UbuntuGIS repos
EXTRAS    = "Y" # Useful extras for full env
UPGRADE   = "N" # Upgrade entire system
INSTALLR  = "N" # Install R & R-Studio
INSTALLPY = "Y" # Install Python & Py-GIS tools

# Refresh repos automatically
sudo apt-get update -y 

# install non-gis specific tools
echo "*************"
echo "* Installing useful non-GIS tools..."
sudo apt-get install software-properties-common # to ease adding new ppas

echo "** Installing Dropbox..." # grab dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
sudo apt-get install dropbox
if [ "$EXTRAS" = "Y" ]; then
	sudo apt-get install guake # guake for retro bash shell dropdown
	sudo apt-get install texlive-extra-utils
fi

# from:  https://medium.com/@ramiroaznar/how-to-install-the-most-common-open-source-gis-applications-on-ubuntu-dbe9d612347b
# add repos
echo "*************"
echo "* Installing GIS-related tools..."

if [ "$STABLE" = "N" ]; then
	echo "** Specifying unstable UbuntuGIS repo to get latest QGIS..."
	echo " "
	echo "** Removing any installed version of QGIS..."
	sudo apt-get -y remove qgis
	sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
	sudo apt-get update
else
	echo "** Sticking to stable UbuntuGIS repo..."
fi
echo "** Installing PostgreSQL..."
sudo apt-get install -y postgresql postgresql-contrib
echo "** Installing QGIS..."
sudo apt-get install -y qgis python-qgis qgis-plugin-grass
echo "** Installing JOSM..."
echo deb https://josm.openstreetmap.de/apt alldist universe | sudo tee /etc/apt/sources.list.d/josm.list > /dev/null
wget -q https://josm.openstreetmap.de/josm-apt.key -O- | sudo apt-key add -
sudo apt-get update
sudo apt install -y josm
echo "** Installing Lib-Proj and Lib-GEOS..."
sudo apt-get install -y libproj-dev libgeos++-dev
# install gdal
echo "** Installing GDAL..."
FLAV=$(eval echo `lsb_release -c` | rev | cut -d ' ' -f1 | rev) 
if [ $FLAV = "xenial" ]; then
  sudo apt-get install -y gdal-bin libgdal-dev libgdal1-dev 
  else
  bash install-gdal.sh
fi

echo "*************"
echo "* Upgrading system..."
if [ "$UPGRADE" = "Y" ]; then
	sudo apt-get update  -y
	sudo apt-get upgrade  -y
fi
# install R/RStudio - see
# http://stackoverflow.com/questions/29667330
echo "*************"
echo "Installing dependencies for workflow..."
sudo apt-get update  -y
# sudo apt-get upgrade  -y
sudo apt-get install libgstreamer0.10-0 -y
sudo apt-get install libgstreamer-plugins-base0.10-dev -y
sudo apt-get install libcurl4-openssl-dev -y
sudo apt-get install libssl-dev -y
sudo apt-get install libopenblas-base -y
sudo apt-get install libxml2-dev -y
sudo apt-get install make -y
sudo apt-get install gcc -y
sudo apt-get install git -y
sudo apt-get install pandoc -y
sudo apt-get install libjpeg62 -y
sudo apt-get install unzip -y
sudo apt-get install curl -y
sudo apt-get install gedit -y
sudo apt-get install jags -y
sudo apt-get install imagemagick -y
sudo apt-get install libv8-dev -y

############################################
### Python Geographic Data Science Stack ###
############################################
if [ "$INSTALLPY" = "Y" ]; then
	echo "** Switching to Python GDS stack..."
	git clone https://github.com/darribas/gds_env.git
	cd gds_env
	conda update --yes conda
	conda install --yes psutil yaml pyyaml
	echo "** Installing GDS stack..."
	conda-env create -f install_gds_stack.yml
else
	echo "** Skipping Python..."
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
echo "All done."
echo "Type: 'source activate gds_test' before running Python in bash"

