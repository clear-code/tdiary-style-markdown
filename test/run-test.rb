#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# Copyright (C) 2013  Kouhei Sutou <kou@clear-code.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

$VERBOSE = true

top_dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
lib_dir = File.join(top_dir, "lib")
test_dir = File.dirname(__FILE__)

require "test-unit"

$LOAD_PATH.unshift(lib_dir)

exit Test::Unit::AutoRunner.run(true, test_dir)
