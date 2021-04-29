all: test ex-dl

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/man
SHAREDIR ?= $(PREFIX)/share
PYTHON ?= /usr/bin/env python

install: ex-dl
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 ex-dl $(DESTDIR)$(BINDIR)

codetest:
	flake8 .

test:
	nosetests --verbose test
	$(MAKE) codetest

tar: ex-dl.tar.gz

ex-dl: youtube_dl/*.py youtube_dl/*/*.py
	mkdir -p zip
	for d in youtube_dl youtube_dl/downloader youtube_dl/extractor youtube_dl/postprocessor ; do \
	  mkdir -p zip/$$d ;\
	  cp -pPR $$d/*.py zip/$$d/ ;\
	done
	touch -t 200001010101 zip/youtube_dl/*.py zip/youtube_dl/*/*.py
	mv zip/youtube_dl/__main__.py zip/
	cd zip ; zip -q ../ex-dl youtube_dl/*.py youtube_dl/*/*.py __main__.py
	rm -rf zip
	echo '#!$(PYTHON)' > ex-dl
	cat ex-dl.zip >> ex-dl
	chmod a+x ex-dl
