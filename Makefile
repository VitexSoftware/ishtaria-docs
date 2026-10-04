SPHINXOPTS ?= -W
SOURCEDIR  = source
BUILDDIR   = build

.PHONY: html clean gettext
html:
	sphinx-build $(SPHINXOPTS) -b html $(SOURCEDIR) $(BUILDDIR)/html

gettext:
	sphinx-build -b gettext $(SOURCEDIR) $(BUILDDIR)/gettext

clean:
	rm -rf $(BUILDDIR)
