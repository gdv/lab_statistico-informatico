NAME=lucidi_SAS_stampa lucidi_SAS_video
USE_PDFLATEX=1

TEXSRCS=lucidi_SAS_testo.tex vc.tex
#lucidi_SAS_stampa_TEXSRCS=${BASE}stampa.tex
#lucidi_SAS_video_TEXSRCS=${BASE}video.tex


sync:	vc.tex pdf
	rsync -avz *.pdf Elearning Esami dellavedova@aspic.bio.disco.unimib.it:public_html/didattica/lab_statistico-informatico/

vc.tex:	.git/logs/HEAD
	bash vc


include /usr/share/latex-mk/latex.gmk

