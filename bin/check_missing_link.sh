#!/bin/bash
#  +-------------------------------------------------------------------------+
#  | Copyright (C) 2004-2024 The Cacti Group                                 |
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
# Helper shell script to all documentation is linked from index

# Determine if running script with out arguments so that path will be relative
if [ -n "${*}" ]
then

	FILENAME=$(basename "$1")
	LINES=$(grep -c "${FILENAME}" README.md)
	if [[ ${LINES} -gt 0 ]]; then
		if [ -n "${CHECK_SHOW_LINKED}" ]; then
			echo "Linked....: ${FILENAME}";
		fi
	else
		echo "Not Linked: ${FILENAME}"
	fi
	exit "${LINES}";
else
	LINES=$(find . -not \( -path ./.github/\* \) -name \*.md ! -name README.md -exec "$0" "{}" \;)
	COUNT=$(echo "${LINES}" | grep -c "Not Linked:")

	if [[ -n "${CHECK_SHOW_LINKED}" || ${COUNT} -gt 0 ]]; then
		if [[ -n "$LINES" ]]; then
			echo "${LINES}";
			echo "";
		fi;
		echo "$COUNT unlinked files";
	fi
	exit "$COUNT";
fi
