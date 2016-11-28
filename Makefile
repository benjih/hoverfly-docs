build:
	hugo
	git add .
	git commit -m "Updating site"
	git push origin master
	git subtree push --prefix=public git@github.com:benjih/hoverfly-docs.git gh-pages

test:
	hugo
	open public/index.html
