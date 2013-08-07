VERSION=$$(grep "^;; Version: " org-trello.el | cut -f3 -d' ')
PACKAGE_FOLDER=org-trello-$(VERSION)
ARCHIVE=$(PACKAGE_FOLDER).tar

test:
	cask exec emacs -q -batch \
			-l ert \
			-l ./org-trello-tests.el \
			-f ert-run-tests-batch-and-exit

pkg-el:
	cask package

clean:
	rm -rf *.tar $(PACKAGE_FOLDER)

prepare:
	mkdir -p $(PACKAGE_FOLDER)
	cp -r org-trello.el org-trello-pkg.el $(PACKAGE_FOLDER)

package: clean pkg-el prepare
	tar cvf $(ARCHIVE) $(PACKAGE_FOLDER)
	rm -rf $(PACKAGE_FOLDER)

info:
	cask info

untar:
	tar xvf $(ARCHIVE)

test-install-package-file: package untar
	cd ./$(PACKAGE_FOLDER)
	emacs-install-clean.el org-trello.el .

build-package:
	emacs --batch -l ./build.el -- org-trello.el

tangle:
	cask exec emacs -q -batch \
			-l org \
			./org-trello.org \
			-e org-babel-tangle

ttest: tangle test
