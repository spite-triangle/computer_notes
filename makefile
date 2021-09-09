build:
	npm install gitbook-plugin-expandable-chapters-small
	npm install gitbook-plugin-ancre-navigation
	npm install gitbook-plugin-hide-element
	npm install gitbook-plugin-code
	npm install gitbook-plugin-search-pro-fixed
	npm install gitbook-plugin-insert-logo-link-website
	npm install gitbook-plugin-sharing-plus
	npm install gitbook-plugin-prism
	npm install gitbook-plugin-flexible-alerts 
	npm install gitbook-plugin-lightbox
	npm install gitbook-plugin-katex-pro
	npm install gitbook-plugin-auto-scroll-table
	npm install gitbook-plugin-splitter
	npm install gitbook-plugin-pageview-count
	npm install gitbook-plugin-favicon-absolute
	npm install gitbook-plugin-sectionx
	npm install gitbook-plugin-terminull-light

num:
	rm ./cpp/chapter/*_withNum.md
	find ./cpp/chapter/ -type f -exec python3 ./AutoNum.py {} \;
	rm ./linux/chapter/*_withNum.md
	find ./linux/chapter/ -type f -exec python3 ./AutoNum.py {} \;
	rm ./MySQL/chapter/*_withNum.md
	find ./MySQL/chapter/ -type f -exec python3 ./AutoNum.py {} \;

