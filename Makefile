.PHONY: build serve install test

build:
	bundle exec jekyll build

serve:
	bundle exec jekyll serve

test: build
	bundle exec htmlproofer ./_site --disable-external --ignore-urls "/^#/" --no-enforce-https

install:
	bundle install

install-all:
	bundle install --with test
