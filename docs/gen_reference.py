#!/usr/bin/env python

#
#  This file is part of Bakefile (http://www.bakefile.org)
#
#  Copyright (C) 2008-2009 Vaclav Slavik
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to
#  deal in the Software without restriction, including without limitation the
#  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
#  sell copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
#  IN THE SOFTWARE.
#

"""
This tool generates reference documentation for Bakefile plugins and puts
it in ref/ directory.
"""

import sys, os, os.path
import shutil
import sphinx.util.docstrings

docs_path = os.path.dirname(sys.argv[0])
bkl_path = os.path.normpath(os.path.join(docs_path, "..", "src"))
sys.path = [bkl_path] + sys.path

import bakefile
import bakefile.api

OUT_DIR = os.path.join(docs_path, "ref")
shutil.rmtree(OUT_DIR, ignore_errors=True)
os.makedirs(OUT_DIR)


DOC_TEMPLATE = """
.. This file was generated by gen_reference.py, don't edit manually!

%(name)s
===

%(docstring)s
"""

def write_docs(kind, extension):
    """
    Writes out documentation for extension of given kind.
    """
    name = extension.name
    print("documenting %s %s...\n" % (kind, name))
    docstring = "\n".join(
            sphinx.util.docstrings.prepare_docstring(extension.__doc__))

    f = open("%s/%s_%s.rst" % (OUT_DIR, kind, name), "wt")
    f.write(DOC_TEMPLATE % locals())




# write docs for all targets:
for t in bakefile.api.TargetType.implementations.values():
    write_docs("target", t)

# write docs for all toolsets:
for t in bakefile.api.Toolset.implementations.values():
    write_docs("toolset", t)
