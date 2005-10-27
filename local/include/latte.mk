.DELETE_ON_ERROR:

.SUFFIXES:
.SUFFIXES: .gif .jpg .latte .lgen .html .pdf .php .ps

HTML = ${LATTE:.latte=.html} ${LGEN:.lgen=.html}
PHP  = ${LATTE_PHP:.latte=.php} ${LGEN_PHP:.lgen=.php}

POSTSCRIPT = ${HTML:.html=.ps}

PUBLISH = $(HTML) $(PHP) $(OTHERS)

process:
	make depend
	make html
	make php

publish: process $(PUBLISH)
	chmod 644 $(PUBLISH)
	selectscp $(SCP) publish $(DEST) $(PUBLISH)
	touch publish

html: $(HTML)

php: $(PHP)

postscript: $(POSTSCRIPT)

.html.ps:
	html2ps -o $@ $<

.latte.html:
	nolatte-html $< > $@ 

.latte.php:
	nolatte-php $< > $@ 

.lgen.html:
	nolatte-html $< > $@ 

.lgen.php:
	nolatte-php $< > $@ 

view: publish
	firefox $(URL)$(VIEW)

viewlocal: process
	firefox $(VIEW)
	
depend:
	sldepend $(LATTE) $(LGEN) $(LATTE_PHP) $(LGEN_PHP)

clobber:
	rm -f $(HTML) $(PHP) $(POSTSCRIPT) $(LGEN) $(LGEN_PHP) loaddefs.linc lattedependencies.mk

