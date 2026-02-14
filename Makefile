.PHONY: build serve install test check-links

build:
	bundle exec jekyll build

serve:
	bundle exec jekyll serve

test: build
	bundle exec htmlproofer ./_site --disable-external --ignore-urls "/^#/" --no-enforce-https

check-links:
	bash scripts/check-external-links.sh

install:
	bundle install

install-all:
	bundle install --with test
