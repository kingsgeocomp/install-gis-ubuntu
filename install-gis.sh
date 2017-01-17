#!/bin/bash

# How to install:
# > sudo apt-get -qq update -y
# > sudo apt-get install git
# > git clone https://github.com/kingsgeocomp/install-gis-ubuntu.git
# > install-gis-ubuntu/install-gis.sh

DROPBOX="N" # Install Dropbox
UNSTABLE="N" # Use unstable UbuntuGIS repos
QGIS="N" # Update QGIS? Overrides Unstable
POSTGRES="N" # Install PostgreSQL
GDAL="Y" # Install GDAL from source
EXTRAS="N" # Useful extras for full env
UPGRADE="N" # Upgrade entire system
INSTALLR="N" # Install R & R-Studio 
INSTALLJ="N" # Install Java & JOSM
INSTALLPY="Y" # Install Python & Py-GIS tools
MINIMAL="N" # Don't install lots of useful add-ons

# From http://stackoverflow.com/questions/1298066/
QGISINSTALLED=$(dpkg-query -W --showformat='${Status}\n' qgis 2>/dev/null | grep -c "ok installed")

printf "****************\n"
printf "Your version of Ubuntu is:\n"
lsb_release -a | grep -P "(Codename|Description)"
printf "****************\n"

# Refresh repos automatically
sudo apt-get -qq update -y 
# We need git right from the start
sudo apt-get install git -y 

# install non-gis specific tools
printf "\n\n*************\n"
printf "* Installing useful non-GIS tools...\n"
sudo apt-get install -y software-properties-common # to ease adding new ppas
sudo apt-get install -y python-software-properties # Seems to help with QGIS

############################################
############# Install Dropbox ##############
############################################
if [ "$DROPBOX" = "Y" ]; then
	printf "\n** Installing Dropbox...\n" # grab dropbox
	cd ~ && rm -rf .dropbox-dist
	cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
	sudo apt-get install dropbox
fi

############################################
############ Install TeX/Guake #############
############################################
if [ "$EXTRAS" = "Y" ]; then
	sudo apt-get install guake # guake for retro bash shell dropdown
	sudo apt-get install texlive-extra-utils
fi

# from:  https://medium.com/@ramiroaznar/how-to-install-the-most-common-open-source-gis-applications-on-ubuntu-dbe9d612347b
# add repos
printf "\n\n*************\n"
printf "* Installing GIS-related tools...\n"

############################################
########### Upgrade/Install QGIS ###########
############################################
if [ "$QGIS" = "Y" ]; then 
	# We remove QGIS if it's already installed 
	# regardless of which repo we're using...
	if [ "$QGISINSTALLED" = 1 ]; then
		printf "** Removing any installed version of QGIS...\n"
		sudo apt-get remove -y qgis python-qgis qgis-plugin-grass
		sudo apt-get autoremove -y
	fi
	# Use the unstable repo?
	if [ "$UNSTABLE" = "Y" ]; then
		printf "** Specifying unstable UbuntuGIS repo to get latest QGIS...\n"
		sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
		sudo apt-get -qq update
		sudo apt-get install -y qgis python-qgis qgis-plugin-grass
	else
		printf "** Sticking to stable install...\n"
		sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-stable
		sudo apt-get -qq update
		sudo apt-get install -y qgis python-qgis qgis-plugin-grass
	fi
fi

if [ "$POSTGRES" = "Y" ]; then 
	printf "\n** Installing PostgreSQL...\n"
	sudo apt-get install -y postgresql postgresql-contrib
else
	printf "\n** Skipping Postgres installation\n"
fi

############################################
########### Install Java & JOSM ############
############################################
if [ "$INSTALLJ" = "Y" ]; then
	# Need a JDK/JRE installed to install JOSM
	printf "\n** Installing JOSM...\n"
	sudo apt-get install -y openjdk-8-jre 
	printf deb https://josm.openstreetmap.de/apt alldist universe | sudo tee /etc/apt/sources.list.d/josm.list > /dev/null
	wget -q https://josm.openstreetmap.de/josm-apt.key -O- | sudo apt-key add -
	sudo apt-get -qq update
	sudo apt install -y josm
fi 

############################################
############### Install GDAL ###############
############################################
PROJ4INSTALLED=$(dpkg-query -W --showformat='${Status}\n' libproj-dev 2>/dev/null | grep -c "ok installed")
GEOSINSTALLED=$(dpkg-query -W --showformat='${Status}\n' libgeos++-dev 2>/dev/null | grep -c "ok installed")
if [ "$PROJ4INSTALLED" = 0 ] && [ "$GEOSINSTALLED" = 0 ]; then 
	printf "\n** Installing Lib-Proj and Lib-GEOS++...\n"
	sudo apt-get install -y libproj-dev libgeos++-dev
fi

# Now for GDAL
if [ "$GDAL" = "Y" ]; then
	printf "\n** Installing GDAL...\n"
	FLAV=$(lsb_release -c | awk 'BEGIN { FS="\t" }; {print $2}') 
	if [ $FLAV = "xenial" ]; then
  	sudo apt-get install -y gdal-bin libgdal-dev libgdal1-dev 
	else
		# In case we're not there already -- 
		# helps with GDAL script below
		cd install-gis-ubuntu/
  	bash install-gdal.sh
	fi
else 
	printf "\n** Skipping GDAL installation...\n"
fi

############################################
################ Upgrade O/S ###############
############################################
if [ "$UPGRADE" = "Y" ]; then
	printf "\n\n*************\n"
	printf "* Upgrading system...\n"
	sudo apt-get -qq update  -y
	sudo apt-get upgrade  -y
else
	printf "Skipping system upgrade...\n"
fi

############################################
########### R & R-Studio Content ###########
############################################
# http://stackoverflow.com/questions/29667330
if [ "$MINIMAL" = "N" ]; then
	printf "\n\n*************\n"
	printf "Installing dependencies for workflow...\n"
	sudo apt-get -qq update  -y
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
else 
	print "\n* Making minimal installation...\n"
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
	conda install --yes basemap
        conda install --yes -c conda-forge pysal=1.13.0
        conda install --yes -c conda-forge folium
        conda install --yes -c conda-forge beautifulsoup4
        conda install --yes html5lib
	conda create --name spats --clone gds_test
else
	printf "** Skipping Python...\n"
fi

# more non GIS but programming stuff - optional, add your own stuff here
# sudo add-apt-repository ppa:neovim-ppa/unstable # nvim: new version of vim
# sudo apt-get -qq update # see https://github.com/neovim/neovim/wiki/Installing-Neovim
# sudo apt-get install neovim
# sudo apt-get install zsh # nice evolution of bash
# sudo apt-get install git-core # from https://www.thinkingmedia.ca/2014/10/how-to-install-oh-my-zsh-on-ubuntu-14/
# Now you can install Oh My Zsh.
# sudo curl -L http://install.ohmyz.sh | sh

# EOF from: http://stackoverflow.com/questions/10969953/
cat <<-EOF
**************
All done.
Type: 'source activate spats' before running Python in the Terminal.
**************
Note that the full Anaconda Python install and QGIS may not live together happily without some tweaking of the startup script for QGIS. That's because Anaconda doesn't have the QGIS libraries installed and QGIS can't see it's own libraries when Anaconda Python is in the path. One way to work around this (as best I can tell) is to add the following to your .bashrc (or .bash_profile) file:

	export DEFAULTPATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
	export CONDAPATH=$HOME/anaconda2/bin:$DEFAULTPATH
	export QGISPATH=$DEFAULTPATH
	export PATH=$CONDAPATH

To launch Anaconda you would need to prepend the command:
	export PATH=$CONDAPATH
	
To launch QGIS you would need to prepend the command:
	export PATH=$QGISPATH

It's probably easiest to leave the path as $CONDAPATH and then just edit the launcher for QGIS so that it launches in the right environment. 
EOF
