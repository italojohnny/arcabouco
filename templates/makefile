MAIN := main.tex

all: pdf

pdf:
	latexmk -pdf $(MAIN)

watch:
	latexmk -pdf -pvc $(MAIN)

clean:
	latexmk -C $(MAIN)
	rm -f main.nav main.snm main.vrb

.PHONY: all pdf watch clean

