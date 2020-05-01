# docker-build-action

Builds the docker image and uploads it to a repository.

## Usage

      - uses: ./.github/actions/docker-build
        with:
          repository_url:      # Any docker protocol repo like dockerhub.com or quay.io
          repository_name:     # project name in the repo
          repository_user:     # bot/user name for the repository
          repository_password: # bot / user password for the repository
          docker_tag:          # tag for the image
          docker_cache_tag:    # generic tag used for caching images (branch or similar, see example)
          docker_args:         # additional options to pass to docker (see example)

## Example

This example uses the [github-private-action](https://github.com/WPMedia/github-private-action) to download the [git-version-action](https://github.com/WPMedia/git-version-action), which provides the version based on commit and the branch name. Neither is necessary for using this action, but is useful for illustrating how one might use `docker_tag` and `docker_cache_tag`.

      - name: Checkout
        uses: actions/checkout@v1
      - name: Checkout Git-Version
        uses: ./.github/actions/github-private-action
        with:
          package: >-
            @wpmedia/git-version-action@0.1.9
            @wpmedia/docker-build@0.1.0
          token: ${{ secrets.GITHUB_PACKAGE_TOKEN }}
      - id: git_metadata
        name: Get Git Metadata
        uses: ./.gh-private-actions/@wpmedia/git-version-action
      - name: Docker Build
        uses: ./.gh-private-actions/@wpmedia/docker-build-action
        env:
          branch: ${{steps.git_metadata.outputs.git_branch}}
          version: ${{steps.git_metadata.outputs.git_version}}
        with:
          repository_url: quay.io
          repository_name: my-project-name
          repository_user: org+bot-user
          repository_password: ${{ secrets.QUAY_AUTH }}
          docker_tag: ${{ env.version }}
          docker_cache_tag: ${{ env.branch }}
          docker_args: >-
            --build-arg VERSION=${{ env.version }}
