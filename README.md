# phenix Documentation

We're using [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
for documentation, with the [mike](https://github.com/jimporter/mike) plugin 
for
versioning.

## Deploy Latest Documentation

The `latest` version of the documents, which is the default, should only ever
be
built from the `main` branch, and should always be deployed to the `gh-pages`
branch of the `sandialabs/sceptre-phenix-docs` repository (referenced here as
the `upstream` remote).

```shell
git remote add upstream https://github.com/sandialabs/sceptre-phenix-docs.git

# If the gh-pages branch doesn't exist in your fork, do these two commands
git checkout -b gh-pages upstream/gh-pages
git push origin gh-pages

git checkout main

./mkdocs-helper.sh deploy --branch gh-pages latest

git push upstream gh-pages:gh-pages
```

## Deploy Branch Documentation

The `dev` version of the documents is meant to contain draft documentation for
any phenix or phenix-apps branches currently being worked on. The workflow for
doing so should be as follows:

1. Create a branch in this repo that contains draft documentation. This should
   not be done in the `dev` branch directly so drafts can be iteratively merged
   into the `main` branch.
2. Merge the draft branch into the `dev` branch.
3. From the `dev` branch, run 
   `./mkdocs-helper.sh deploy --branch gh-pages dev`.
4. Deploy the updated development docs by running
   `git push upstream gh-pages:gh-pages`.

It's also possible to create a new version per draft branch if the situation
warrants.

## Build docs locally

To build and host the docs locally, run the following command:
```shell
make serve-docs
```

The docs will be served on `localhost:8000` by a Docker container. 
Any changes to the Markdown files or `mkdocs.yml` will trigger an 
automatic rebuild while the container is running. This alleviates 
the need to run the command every time a change is made.
