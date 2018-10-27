#!/bin/sh
#  +-------------------------------------------------------------------------+
#  | Copyright (C) 2004-2018 The Cacti Group                                 |
#  |                                                                         |
#  | This program is free software; you can redistribute it and/or           |
#  | modify it under the terms of the GNU General Public License             |
#  | as published by the Free Software Foundation; either version 2          |
#  | of the License, or (at your option) any later version.                  |
#  |                                                                         |
#  | This program is distributed in the hope that it will be useful,         |
#  | but WITHOUT ANY WARRANTY; without even the implied warranty of          |
#  | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           |
#  | GNU General Public License for more details.                            |
#  +-------------------------------------------------------------------------+
#  | http://www.cacti.net/                                                   |
#  +-------------------------------------------------------------------------+
# 
# Helper shell script to run documentation markdown style validation

# Confirm mdl (markdownlint) is installed
MDL_PATH=`which mdl`
if [ $? -gt 0 ]
then
	echo "ERROR: mdl (markdownlint) not installed"
	echo
	echo "Check out https://github.com/markdownlint/ for installation instructions"
	exit 1
fi

# Determine if running script with out arguments so that path will be relative
if [ -n "${*}" ]
then
	ARGV="${*}"
else
	ARGV="."
fi

# Run mdl with documentation repository configuration
MDL_OUTPUT=`${MDL_PATH} -c .mdlrc ${ARGV}`
MDL_RESULT=$?
echo "${MDL_OUTPUT}" | grep -v "RULES.md"
if [ $MDL_RESULT -gt 0 ]
then
	echo "Cacti's Documentation Standards can be found at:"
	echo "https://github.com/Cacti/documentation/blob/develop/Standards-Documentation.md"
	echo
	exit 1
fi
