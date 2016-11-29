#!/bin/bash

# install non-gis specific tools
#sudo apt-get install guake # guake for retro bash shell dropdown
#sudo apt-get install texlive-extra-utils
sudo apt-get install software-properties-common # to ease adding new ppas

# from:  https://medium.com/@ramiroaznar/how-to-install-the-most-common-open-source-gis-applications-on-ubuntu-dbe9d612347b
# add repos
sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib
sudo apt-get install qgis python-qgis qgis-plugin-grass
echo deb https://josm.openstreetmap.de/apt alldist universe | sudo tee /etc/apt/sources.list.d/josm.list > /dev/null
wget -q https://josm.openstreetmap.de/josm-apt.key -O- | sudo apt-key add -
sudo apt-get update
sudo apt install josm
sudo apt-get install -y libproj-dev libgeos++-dev
# install gdal
FLAV=$(eval echo `lsb_release -c` | rev | cut -d ' ' -f1 | rev) 
if [ $FLAV = "xenial" ]; then
  sudo apt-get install -y gdal-bin libgdal-dev libgdal1-dev 
  else
  bash install-gdal.sh
fi


# install R/RStudio - see
# http://stackoverflow.com/questions/29667330
echo "install a few dependancies for our workflow"
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
sudo apt-get install littler -y
sudo apt-get install openjdk-7-* -y
sudo apt-get install gedit -y
sudo apt-get install jags -y
sudo apt-get install imagemagick -y
sudo apt-get install docker-engine -y
sudo apt-get install libv8-dev -y

############################################
### Python Geographic Data Science Stack ###
############################################
git clone https://github.com/darribas/gds_env.git
cd gds_env
#wget https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh
#chmod +x miniconda.sh
#./miniconda.sh -b -p ./miniconda
#export PATH=`pwd`/miniconda/bin:$PATH
conda update --yes conda
conda install --yes psutil yaml pyyaml
conda-env create -f install_gds_stack.yml

# more non GIS but programming stuff - optional, add your own stuff here
# sudo add-apt-repository ppa:neovim-ppa/unstable # nvim: new version of vim
# sudo apt-get update # see https://github.com/neovim/neovim/wiki/Installing-Neovim
# sudo apt-get install neovim
# sudo apt-get install zsh # nice evolution of bash
# sudo apt-get install git-core # from https://www.thinkingmedia.ca/2014/10/how-to-install-oh-my-zsh-on-ubuntu-14/
# Now you can install Oh My Zsh.
# sudo curl -L http://install.ohmyz.sh | sh

# done.
echo "all done"
echo "type 'sudo rstudio' in the terminal to start RStudio"
echo "type source activate gds_test before running Python in bash"

