#!/bin/bash
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
# Helper script to build HTML documentation from markdown source

# define script variables
UTILS="pandoc"
ODIR="html"

# check if for required utilities
ERROR=""
for UTIL in ${UTILS}
do
	which ${UTIL} 1>/dev/null 2>&1
	if [ ${?} -gt 0 ]
	then
		ERROR="${ERROR} - ${UTIL}\n"
	fi
done

if [ -n "${ERROR}" ]
then
	echo "ERROR: Required utilities not found"
	echo
	echo "Please install the following utilities:"
	echo "${ERROR}"
	exit 1
fi

# make sure pandoc has lua support
pandoc --help | grep 'lua-filter' 1>/dev/null 2>&1
if [ ${?} -gt 0 ]
then
	echo "ERROR: Required LUA Filter support not found in Pandoc utility"
	echo "       Make sure you have version 2.3.1 or higher installed"
	exit 1
fi

# determine base path of the repository
BASE_PATH="$( cd "$(dirname "$0")" ; pwd -P | sed 's/\/bin//')"

# create output directory if needed
if [ ! -d ${BASE_PATH}/${ODIR}/images ]
then
	mkdir -p ${BASE_PATH}/${ODIR}/images
	if [ ${?} -gt 0 ]
	then
		echo "ERROR: Unable to create output directory: ${ODIR}"
		exit 1
	fi
fi

# copy image resources
echo "Copying images..."
cp -r ${BASE_PATH}/images/* ${BASE_PATH}/${ODIR}/images/
if [ ${?} -gt 0 ]
then
	echo "ERROR: Failed to copy images"
	exit 1
fi

# copy css resourse
echo "Copying css..."
cp -r ${BASE_PATH}/resources/css/* ${BASE_PATH}/${ODIR}/
if [ ${?} -gt 0 ]
then
	echo "ERROR: Failed to copy images"
	exit 1
fi

# process markdown files into html
echo "Converting files..."
for FILE in `find ${BASE_PATH} -name "*.md"`
do
	IFILE=${FILE//$BASE_PATH\/}
	OFILE=${ODIR}/${IFILE//.md/.html}
	TITLE=$(grep "^# " $FILE | head -1 | sed 's/# //')

	# handle special case for table of contents
	if [ "${IFILE}" = "README.md" ]
	then
		OFILE="${ODIR}/Table-of-Contents.html"
	fi
	echo "  '${IFILE}' => '${OFILE}'"

	pandoc --from=gfm --to=html5 ${IFILE} \
	        --standalone \
		--output=${BASE_PATH}/${OFILE} \
		--lua-filter=${BASE_PATH}/resources/build/pandoc_links_to_html.lua \
		--css=Cacti-Github.css \
		--metadata=pagetitle:"$TITLE" \
		-T "Cacti"
done

# done
exit 0
