# install-gis-ubuntu

This script builds on work undertaken by [Robin Lovelace](http://robinlovelace.net) to provide a single installation script that would download and install all of the libraries needed to build a GIS/GISci-capable Ubuntu machine. His work was, in turn inspired by a post on [installing commonly needed GIS software on Ubuntu](https://medium.com/@ramiroaznar/how-to-install-the-most-common-open-source-gis-applications-on-ubuntu-dbe9d612347b) and having recently got a new computer (well, a second hand [Lenovo laptop](http://www.ebay.co.uk/sch/PC-Laptops-Netbooks/177/i.html?_from=R40&_nkw=lenovo&_dcat=177&rt=nc&_mPrRngCbx=1&_udlo=0&_udhi=200)) with Ubuntu freshly installed, I decided to make the process of installing GIS software on it as reproducible as possible. This is not intended to replace Robin's script, or the [OSGeo Live distro](https://live.osgeo.org/en/index.html)... It's mainly been developed for managing our [GeoCUP VMs](https://kingsgeocomputation.org/2016/08/30/geocup-year1/) that we use for teaching. 

Core programs that can be installed are:

- **QGIS**, probably the most popular GUI-driven GIS in the world
- Recent versions of **GDAL** and **GEOS** C/C++ libraries
- A fully-fledged Python stack for Geographic Data Science, fully tested over at
  [`gds_env`](https://github.com/darribas/gds_env).

All this can be a pain to install manually, this script is designed to make your life easier.

## Prerequisites

A working installation of Ubuntu.

## Installation

First, make sure you have git installed:
```bash
sudo apt-get install git
```

Next, fire up a terminal, e.g. with `Ctl-Alt-T`, then enter the following:

```bash
git clone https://github.com/kingsgeocomp/install-gis-ubuntu.git
./install-gis-ubuntu/install-gis.sh
```

## Getting Started

For Python, you have two choices:

1. If you want to run Python from the command line then you will need to activate the Python virtual environment before using it. I have created a clone of Dani's original env under `spats` (Spatial Analysis) for which you type:

```bash
source activate spats
python
>>>
```

from there you will be in the Python shell. Test if the geographic packages work, e.g. with:

```python
import geopandas
```

2. You can also use the IPython notebook, as described in [Python's documentation](http://jupyter-notebook-beginner-guide.readthedocs.io/en/latest/execute.html) by changing the Kernel listed to `spats` from `Python [Root]`. 

For more, check out up-to-date tutorials, such as this one on [GeoPandas](http://geopandas.org/).

