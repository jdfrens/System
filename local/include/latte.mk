.DELETE_ON_ERROR:

.SUFFIXES:
.SUFFIXES: .gif .jpg .latte .lgen .html .pdf .ps

HTML = ${LATTE:.latte=.html} ${LGEN:.lgen=.html}

POSTSCRIPT = ${HTML:.html=.ps}

PUBLISH = $(HTML) $(OTHERS)

process: lattedependencies.mk
	make html

publish: process $(PUBLISH)
	chmod 644 $(PUBLISH)
	selectscp $(SCP) publish $(DEST) $(PUBLISH)
	touch publish

html: $(HTML)

postscript: $(POSTSCRIPT)

.html.ps:
	html2ps -o $@ $<

.latte.html:
	nolatte-html $< > $@ 

.lgen.html:
	nolatte-html $< > $@ 

view: publish
	firefox $(URL)$(VIEW)

viewlocal: process
	firefox $(VIEW)

LATTE_DEPEND = sldepend
LATTE_DEPEND_FLAGS = 

lattedependencies.mk: depend

depend:
	$(LATTE_DEPEND) $(LATTE_DEPEND_FLAGS) $(LATTE) $(LGEN)

clobber:
	rm -f $(HTML) $(POSTSCRIPT) $(LGEN) loaddefs.linc lattedependencies.mk
