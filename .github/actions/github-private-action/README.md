# Github Private Action

The Github Private Action allows a repo to checkout actions from a private Github Packages repo from within a workflow. This solves current limitation with Github Actions that only gives actions access to it's own git-repo/package-repo and no access at an organization level.

## Setup

In order to use this action, it will need to be checked into the repo that will run the action. Download the [latest release](https://github.com/WPMedia/github-private-action/releases/latest) from this repo and unzip it in `.github/action/github-private-action` of your repo.

```bash
mkdir -p .github/actions/github-private-action
cd .github/actions/github-private-action
unzip /path/to/download/github-private-action-v1.1.7.zip
```

Create a Personal Access Token with read-only access to Github Packages.

In the `Settings -> Secrets` of your repo add the personal access token with a name like `GITHUB_PACKAGE_TOKEN`.

## Usage

```yaml
- uses: ./.github/actions/github-private-action
  with:
    token: ${{ secrets.GITHUB_PACKAGE_TOKEN }}
    packages: # space or newline delimited list of packages
    directory: # (Optional) Directory to install actions, default '.gh-private-actions'
    owner:  (Optional) NPM owner needed for authentication, default 'wpmedia'
    repository: (Optional) NPM repository to authenticate, default 'npm.pkg.github.com'
```

This action will checkout the `packages` listed and copy them to the `directory`. The `token` is needed for read access to the Github Packages repo. After this action runs, these packages can be as local actions.

_NOTE:_ This action currently uses the token for the `@wpmedia` owner. A future update to this action could make that configurable.

## Example

```yaml
  - uses: ./.github/actions/github-private-action
    with:
      token: ${{ secrets.GITHUB_PACKAGE_TOKEN }}
      packages: |-
        @wpmedia/git-version-action@0.1.9
        @wpmedia/slack-action@0.1.11
  - uses: ./.gh-private-actions/@wpmedia/git-version-action
```
