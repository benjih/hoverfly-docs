build:
	hugo
	git add .
	git commit -m "Updating site"
	git push origin master
	git subtree push --prefix=public git@github.com:SpectoLabs/hoverfly-docs.git gh-pages
