#!/usr/bin/make -f

LATEX=pdflatex
PATTERN=ChantsCC
BOOKS=$(shell ls | sed -n 's/^\($(PATTERN).*\)\.tex$$/\1/p') 
DIRS=. songs

all: pdf

pdf: $(addsuffix .pdf,$(BOOKS))

%.pdf: %.tex songlist_gchords.tex songlist.tex convert-stamp
	$(LATEX) $<

songlist.tex:
	for i in $(shell ls $(CURDIR)/songs | grep ".tex$$"); do \
	   echo "\input{songs/$${i%%.tex}}" >> $@ ; \
	done 

songlist_gchords.tex:
	for i in $(shell ls $(CURDIR)/songs_gchords | grep ".tex$$"); do \
	   echo "\input{songs_gchords/$${i%%.tex}}" >> $@ ; \
	done 

convert-stamp:
	./convert_gchords.pl
	touch $@

clean: $(addprefix clean-,$(DIRS))
	rm -f songlist.tex songlist_gchords.tex

clean-%:
	cd $(CURDIR)/$(subst clean-,,$@) && rm -f *.aux *.log *.aIdx *.kIdx *.tIdx *.toc *~ convert-stamp

distclean:
	rm -f *.pdf


