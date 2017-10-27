# This makefile controls the build process and perfoms
# the following steps:
# 1) All .cls, .sty and .bib files in common/ are copied to
# the document directories in examples/ (inserting the current date).
# 2) Sample LaTeX documents in examples/ are built and individually
# ZIPed for use with Overleaf.
# 3) The ctan/ release is assembled by (a) copying all .cls and .sty
# files to ctan/latex/, (b) ...


SHELL=/bin/sh


COMMONDIR=common
BUILDDIR=examples
SUBMKFILE=$(realpath makefile-subdir)

# LATEXJOB refers to the TEX file to compile (used by the sub-makefile)
LATEXJOB=main
export LATEXJOB

CTANDIR=ctan
CTANPKG=hagenberg-thesis

SUBREPOS=subrepos

BUILDS=HgbArticle HgbInternshipReport HgbLabReportDE HgbLabReportEN HgbTermReport HgbThesisDE HgbThesisEN HgbThesisTutorial Manual

DUMMYDATE := 9999\/01\/01
TODAY := $(shell date +"%Y\/%m\/%d")

#all : $(BUILDS) ctan
all : examples ctan setdates subrepos
examples : $(BUILDS)
.PHONY : all examples $(BUILDS) ctan setdates subrepos

# ------------------------------------------------------------

HgbArticle :
	@echo "***** Making $@ *****"
	cp -u $(COMMONDIR)/*.sty $(COMMONDIR)/*.cls $(COMMONDIR)/*.bib $(BUILDDIR)/$@
	make -C $(BUILDDIR)/$@ -f $(SUBMKFILE)
	cp -u -R $(BUILDDIR)/$@ $(SUBREPOS)/$@

HgbInternshipReport :
	@echo "***** Making $@ *****"
	cp -u $(COMMONDIR)/*.sty $(COMMONDIR)/*.cls $(COMMONDIR)/*.bib $(BUILDDIR)/$@
	make -C $(BUILDDIR)/$@ -f $(SUBMKFILE)
	cp -u -R $(BUILDDIR)/$@ $(SUBREPOS)/$@

HgbLabReportDE :
	@echo "***** Making $@ *****"
	cp -u $(COMMONDIR)/*.sty $(COMMONDIR)/*.cls $(COMMONDIR)/*.bib $(BUILDDIR)/$@
	make -C $(BUILDDIR)/$@ -f $(SUBMKFILE)
	cp -u -R $(BUILDDIR)/$@ $(SUBREPOS)/$@

HgbLabReportEN :
	@echo "***** Making $@ *****"
	cp -u $(COMMONDIR)/*.sty $(COMMONDIR)/*.cls $(COMMONDIR)/*.bib $(BUILDDIR)/$@
	make -C $(BUILDDIR)/$@ -f $(SUBMKFILE)
	cp -u -R $(BUILDDIR)/$@ $(SUBREPOS)/$@

HgbTermReport :
	@echo "***** Making $@ *****"
	cp -u $(COMMONDIR)/*.sty $(COMMONDIR)/*.cls $(COMMONDIR)/*.bib $(BUILDDIR)/$@
	make -C $(BUILDDIR)/$@ -f $(SUBMKFILE)
	cp -u -R $(BUILDDIR)/$@ $(SUBREPOS)/$@

HgbThesisDE :
	@echo "***** Making $@ *****"
	cp -u $(COMMONDIR)/*.sty $(COMMONDIR)/*.cls $(COMMONDIR)/*.bib $(BUILDDIR)/$@
	make -C $(BUILDDIR)/$@ -f $(SUBMKFILE)
	cp -u -R $(BUILDDIR)/$@ $(SUBREPOS)/$@

HgbThesisEN :
	@echo "***** Making $@ *****"
	cp -u $(COMMONDIR)/*.sty $(COMMONDIR)/*.cls $(COMMONDIR)/*.bib $(BUILDDIR)/$@
	make -C $(BUILDDIR)/$@ -f $(SUBMKFILE)
	cp -u -R $(BUILDDIR)/$@ $(SUBREPOS)/$@

HgbThesisTutorial :
	@echo "***** Making $@ *****"
	cp -u $(COMMONDIR)/*.sty $(COMMONDIR)/*.cls $(COMMONDIR)/*.bib $(BUILDDIR)/$@
	make -C $(BUILDDIR)/$@ -f $(SUBMKFILE)
	cp -u -R $(BUILDDIR)/$@ $(SUBREPOS)/$@

# ------------------------------------------------------------

Manual :
	@echo "***** Making $@ *****"
	cp -u $(COMMONDIR)/*.sty $(COMMONDIR)/*.cls $(BUILDDIR)/$@
	make -C $(BUILDDIR)/$@ -f $(SUBMKFILE)

# ------------------------------------------------------------
	
ctan :
	@echo "***** Making $@ *****"
	cp -u $(COMMONDIR)/*.sty $(COMMONDIR)/*.cls $(CTANDIR)/$(CTANPKG)/latex
	cp -u $(BUILDDIR)/Manual/main.tex $(CTANDIR)/$(CTANPKG)/doc/$(CTANPKG).tex
	cp -u $(BUILDDIR)/Manual/main.pdf $(CTANDIR)/$(CTANPKG)/doc/$(CTANPKG).pdf
#
	cp -u -R $(BUILDDIR) $(CTANDIR)/$(CTANPKG)
	find $(CTANDIR)/$(CTANPKG)/examples -name "*.sty" -type f -delete
	find $(CTANDIR)/$(CTANPKG)/examples -name "*.cls" -type f -delete
	find $(CTANDIR)/$(CTANPKG)/examples -name "*.aux" -type f -delete
	find $(CTANDIR)/$(CTANPKG)/examples -name "*.bbl" -type f -delete
	find $(CTANDIR)/$(CTANPKG)/examples -name "*.bcf" -type f -delete
	find $(CTANDIR)/$(CTANPKG)/examples -name "*.blg" -type f -delete
	find $(CTANDIR)/$(CTANPKG)/examples -name "*.log" -type f -delete
	find $(CTANDIR)/$(CTANPKG)/examples -name "*.out" -type f -delete
	find $(CTANDIR)/$(CTANPKG)/examples -name "*.run.xml" -type f -delete
	find $(CTANDIR)/$(CTANPKG)/examples -name "*.synctex" -type f -delete
	find $(CTANDIR)/$(CTANPKG)/examples -name "*.toc" -type f -delete
	find $(CTANDIR)/$(CTANPKG)/examples -name "*.tcp" -type f -delete
	find $(CTANDIR)/$(CTANPKG)/examples -name "*.tps" -type f -delete
#
	cd $(CTANDIR); rm -f $(CTANPKG).zip; ./zip -r $(CTANPKG).zip $(CTANPKG)
#	cd $(CTANDIR); rm -f $(hagenberg-thesis).zip; ./zip -r $(hagenberg-thesis).zip $(hagenberg-thesis) -i *.tex *.sty *.cls *.pdf *.md
# http://stahlworks.com/dev/?tool=zipunzip#zipexamp

setdates :
#	$(eval LTXFILES := $(wildcard $(CTANDIR)/$(CTANPKG)/latex/*.cls) $(wildcard $(CTANDIR)/$(CTANPKG)/latex/*.sty))
#	Replace the dummy date '9999/01/01' in all ctan/hagenberg-thesis/latex/*.cls and *.sty files
	$(eval LTXFILES := $(shell find $(CTANDIR)/$(CTANPKG)/latex -name "*.sty" -or -name "*.cls" -type f))
	$(foreach FILE, $(LTXFILES), $(shell sed -i 's/$(DUMMYDATE)/$(TODAY)/' $(FILE)))
#	Replace the dummy date '9999/01/01' in all subrepo *.cls and *.sty files
	$(eval LTXFILES := $(shell find $(SUBREPOS) -name "*.sty" -or -name "*.cls" -type f))
	$(foreach FILE, $(LTXFILES), $(shell sed -i 's/$(DUMMYDATE)/$(TODAY)/' $(FILE)))
#	echo "LTXFILES = "$(LTXFILES)
	
subrepos :
#	for later: copy contents of $(CTANDIR)/$(CTANPKG)/examples/* to $(SUBREPOS)/* (clean)

# ------------------------------------------------------------

#commit :
#	@echo "Performing GIT add/commit"
#	-git add -v $(BUILDDIR)/
#	-git commit -m "LaTeX style and class files updated" -v $(BUILDDIR)/
#	@echo GIT note: Commits need to be pushed to remote!


