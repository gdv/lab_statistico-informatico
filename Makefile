TARGETS=lucidi_SAS_stampa.pdf lucidi_SAS_video.pdf
LATEXMK = latexmk -recorder -use-make

pdf: $(TARGETS)

sync:	vc.tex pdf
	rsync -avz *.pdf Elearning Esami dellavedova@aspic.bio.disco.unimib.it:public_html/didattica/lab_statistico-informatico/

vc.tex:	.git/logs/HEAD
	bash vc


%.pdf : %.tex vc.tex lucidi_SAS_testo.tex
	$(LATEXMK) -pdf $<
