# Makefile to process the LaTeX beamer document class.
# see http://latex-beamer.sourceforge.net/ for information about beamer.
# Copyright (C) 2004  Jeremy D. Frens <jdfrens@calvin.edu>

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

# ***********************************************************************
# Usage
# ***********************************************************************
# 1. Change the program variables at the beginning of this file as necessary.
# 2. Use one of the following targets:
#     slides     - for the display version
#     handout    - for the handout version
#     handout2up - for the handout version with 2 slides per page
#     handout4up - for the handout version with 4 slides per page
#     read       - create and display the display version
#                  set READ to something else (on the command line) to read
#                  something different

# program to open a PDF file (current setting works on Mac OS X)
OPENPDF = acroread 
LATEX = pdflatex -interaction=nonstopmode
BIBTEX = bibtex
L2H = latex2html
PS2PDF = ps2pdf

# You shouldn't have to change anything below this (except for the Dia stuff
# at the very end)

.SUFFIXES:
.SUFFIXES: .dia .dvi .pdf .tex .ps

RERUN = "(There were undefined references|Rerun to get (cross-references|the bars) right)"
RERUNBIB = "No file.*\.bbl|Citation.*undefined"
COPY = if test -r $*.toc; then cp $*.toc $*.toc.bak; fi
%.pdf: %.tex
	$(COPY); $(LATEX) $<
	egrep -c $(RERUNBIB) $*.log && ($(BIBTEX) $*;$(COPY);$(LATEX) $<) ; true
	egrep $(RERUN) $*.log && ($(COPY);$(LATEX) $<) ; true
	egrep $(RERUN) $*.log && ($(COPY);$(LATEX) $<) ; true
	if cmp -s $*.toc $*.toc.bak; then echo ;else $(LATEX) $< ; fi
	$(RM) $*.toc.bak
	egrep -i "(Reference|Citation).*undefined" $*.log ; true


.SECONDARY:

HANDOUT = ${TITLE:.tex=-handout.tex}
HANDOUT4UP = ${TITLE:.tex=-handout-4x.tex}
HANDOUT2UP = ${TITLE:.tex=-handout-2x.tex}
SLIDES = ${TITLE:.tex=.pdf}
READ = $(SLIDES)

# targets
all: slides handout

read: $(READ)
	$(OPENPDF) $(READ)

slides: $(SLIDES)

handout: $(HANDOUT).pdf

4up: handout4up
2up: handout2up
handout4up: $(HANDOUT4UP).pdf
handout2up: $(HANDOUT2UP).pdf

$(HANDOUT):
	beamerhandout < $(TITLE).tex > $(HANDOUT).tex

$(HANDOUT4UP):
	pdf4up $(HANDOUT) > $(HANDOUT4UP).tex
$(HANDOUT2UP):
	pdf2up $(HANDOUT) > $(HANDOUT2UP).tex

clean:
	$(RM) *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg  \
	*.inx *.ps *.dvi *.pdf *.toc *.out *.nav *.snm *.bak *~

clobber: clean
	$(RM) *-display.* *handout*

# this is my own peculiarity, perhaps
# if you don't ever use Dia for drawing pictures, you can delete these safely
%.eps: %.dia
	dia -e $@ $<
%.png: %.dia
	dia -e $@ $<
$(SLIDES): $($(wildcard *.dia):.dia=.eps)
$(TEMPHANDOUT).pdf: $($(wildcard *.dia):.dia=.eps)
$(HANDOUT).pdf: $($(wildcard *.dia):.dia=.eps)

