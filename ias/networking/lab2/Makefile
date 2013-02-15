LATEX=pdflatex
ROOT=lab2

all: $(ROOT)

$(ROOT): $(ROOT).tex
	$(LATEX) $(ROOT).tex
	$(LATEX) $(ROOT).tex
clean:
	rm -f *.toc *.aux *.nav *.log *.snm *.out *~ *.bbl *.blg

cleanall: clean
	rm -f *.pdf *.dvi
