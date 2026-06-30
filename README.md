# phēnix Documentation

[![Deploy Documentation](https://github.com/sandialabs/sceptre-phenix-docs/actions/workflows/deploy.yml/badge.svg)](https://github.com/sandialabs/sceptre-phenix-docs/actions/workflows/deploy.yml)
[![Docs](https://img.shields.io/badge/docs-latest-orange)](https://sandialabs.github.io/sceptre-phenix-docs/)

This repository contains the source code and configuration for the official [phēnix documentation](https://sandialabs.github.io/sceptre-phenix-docs/).

The documentation is built using [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) and versioned with [mike](https://github.com/jimporter/mike).

## Automated Deployment

Documentation is built and deployed automatically using GitHub Actions.

- **`main` branch**: Pushing to `main` will automatically build and deploy the `latest` version of the docs.
- **`dev` branch**: Pushing to `dev` will automatically build and deploy the `dev` version of the docs.

The workflow will build and publish the documentation from each branch. No manual deployment is necessary.

### Previewing Feature Branches

To preview documentation changes from a feature branch before merging:

1. Go to the **Actions** tab in the repository.
2. Select the **Deploy Documentation** workflow.
3. Click **Run workflow**, select your feature branch, and click **Run workflow**.

This will deploy a version named after your branch (e.g., `feat-new-docs`). When the corresponding Pull Request is closed, this preview version is automatically deleted.

> [!IMPORTANT]
> **Note for Forks:** To preview deployments on your own fork, you must enable GitHub Pages:
>
> 1. Go to **Settings** > **Pages**.
> 2. Under **Build and deployment** > **Source**, select **Deploy from a branch**.
> 3. Under **Branch**, select desired branch name and `/ (root)`.
> 4. Click **Save**.
>
> Your site will be available at `https://<username>.github.io/sceptre-phenix-docs/`.

## Build Docs Locally

To build and serve the documentation locally, which includes the versioning selector, run:

```shell
make serve
```

The docs will be served on `localhost:8000` by a Docker container.
Any changes to the Markdown files or `mkdocs.yml` will trigger an
automatic rebuild while the container is running. This alleviates
the need to run the command every time a change is made.

## Linting and Code Quality

This repository uses [prek](https://prek.j178.dev/) (a Rust drop-in alternative to `pre-commit`) to enforce repository-wide checks such as spell-checking (`codespell`), shell linting (`shellcheck`), YAML linting (`yamllint`), conventional commit messages, and general hygiene. The same checks run in CI via the [Lint workflow](.github/workflows/lint.yml).

Install the dev tooling and register the git pre-commit hooks once:

```shell
make install-dev
```

Run all hooks against every file manually:

```shell
make lint
# or, equivalently
prek run --all-files
```

See [CONTRIBUTING.md](.github/CONTRIBUTING.md) for additional contribution guidelines.
