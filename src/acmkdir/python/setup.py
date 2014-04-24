#!/usr/bin/env python

##
## Copyright (C) year your_name <email_address>
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
##
##

from string import split
try:
	from distutils.core import setup, Extension
except ImportError:
	print """You have to install the python distutils package
		 See the python web site:

		 http://www.python.org

		 Thierry MICHEL <thierry@nekhem.com>"""
	from sys import exit
	exit(0)

import sys
from pkg_resources import require
from setuptools.dist import check_package_data, assert_bool
# had been "setupext"; apparently "setuptools" does not work as a 1-for-1
# replacement for that, but at least it exists... (FIXME: get setuptools to
# actually work as a replacement here)
from setuptools import Data_Files, install_Data_Files

extfiles = """
	include README
	include AUTHORS
	include COPYING
	include INSTALL
"""


extf = [
	Data_Files(
		   base_dir = "install_data",
		   copy_to = "",
		   template = split(extfiles,"\n"),
		   preserve_path = 1)
]

setup (# Distribution meta-data
       name = "package_name",
       version = "0.1",
       description = "description of product here",
       author = "your_name",
       author_email = "email_address",
       url = "your site URl",
       licence = "GPL",
       # Description of the modules and packages in the distribution
       cmdclass = {'install_data':install_Data_Files,},
       data_files = extf,
       #packages = [''],
       #package_dir = {'': ''},
       #py_modules = []

       )
