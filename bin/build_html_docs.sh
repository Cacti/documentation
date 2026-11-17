#!/bin/bash
#  +-------------------------------------------------------------------------+
#  | Copyright (C) 2004-2026 The Cacti Group                                 |
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
# Build all manual content with the locked Markdown renderer.
set -eu
DOC_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
exec mise exec python@3.12 uv@0.12.23 -- uv run --locked --python python \
  --script "$DOC_ROOT/bin/build_html_docs.py" "$@"
