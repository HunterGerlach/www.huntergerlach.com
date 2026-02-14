.PHONY: build serve install test check-links a11y

build:
	bundle exec jekyll build

serve:
	bundle exec jekyll serve

test: build
	bundle exec htmlproofer ./_site --disable-external --ignore-urls "/^#/" --no-enforce-https

check-links:
	bash scripts/check-external-links.sh

a11y: build
	npx serve ./_site -l 5000 & sleep 3 && \
	pa11y-ci $$(find ./_site -name '*.html' -not -path './_site/404.html' \
		| sed 's|^./_site|http://localhost:5000|' \
		| sed 's|/index\.html$$|/|'); \
	kill %1 2>/dev/null || true

install:
	bundle install

install-all:
	bundle install --with test
