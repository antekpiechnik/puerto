all: planning-game-01.pdf

planning-game-01.pdf: planning-game-01.tex
	texi2pdf -c -q $<
	open $@

clean:
	rm -rf *.aux *.log *.out *.toc
