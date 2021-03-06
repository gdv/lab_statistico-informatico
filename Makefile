TARGETS=lucidi_SAS_stampa.pdf lucidi_SAS_video.pdf esercizi_progettazione.pdf
LATEXMK = latexmk -recorder -use-make

pdf: $(TARGETS)

release:	vc.tex pdf
	rsync -avz *.pdf ~/Documenti/Didattica/Lab.\ Stat-Inf/Lucidi/
	rsync -avz Esercizi ~/Documenti/Didattica/Lab.\ Stat-Inf/

vc.tex:	.git/logs/HEAD
	bash vc

lucidi%.pdf : lucidi%.tex vc.tex lucidi_SAS_testo.tex
	$(LATEXMK) -pdf $<

%.pdf : %.tex vc.tex
	$(LATEXMK) -pdf $<

