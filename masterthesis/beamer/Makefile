LATEX=pdflatex
INPUT_FILE=master-slides
OUTPUT_FILE=Slides\ -\ Simon\ Pena.pdf
AUX_FILES=*.aux *.log *.nav \
	*.out *.snm *.toc \
	*~

$(OUTPUT_FILE): $(INPUT_FILE).tex
	cp -r images/ tmp/
	cd tmp/ && $(LATEX) ../$<
	cd tmp/ && $(LATEX) ../$<
	cd tmp/ && $(LATEX) ../$<
	mv tmp/$(INPUT_FILE).pdf "$@"

clean:
	cd tmp/ && rm -f $(AUX_FILES)

cleanall: clean
	rm -f *.pdf *.dvi
