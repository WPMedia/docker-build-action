# docker-build-action

Builds the docker image and uploads it to a repository.

## Usage

      - uses: ./.github/actions/docker-build
        with:
          context:                 # (OPTIONAL) Directory context for building (default: .)
          repository_server:       # Any docker registry like dockerhub.com or quay.io
          repository_name:         # project name in the repo
          repository_username:     # bot/user name for the repository
          repository_password:     # bot / user password for the repository
          docker_tag:              # tag for the image
          docker_cache_tag:        # generic tag used for caching images (branch or similar, see example)
          dockerfile:              # (OPTIONAL) Location of the dockerfile (default is ${context}/Dockerfile)
          docker_args:             # (OPTIONAL) additional options to pass to docker (see example)

## Example

An example for a simple repository that only has one `Dockerfile` at the root of the repo. For more complicated setups you may need to add the `context` and `dockerfile`.

This example uses the [git-version-action](https://github.com/WPMedia/git-version-action), which provides the version based on commit and the branch name. Neither is necessary for using this action, but is useful for illustrating how one might use `docker_tag` and `docker_cache_tag`.

      - name: Checkout
        uses: actions/checkout@v1
      - id: git_metadata
        name: Get Git Metadata
        uses: WPMedia/git-version-action@v1
      - name: Docker Build
        uses: WPMedia/docker-build-action@v1
        env:
          branch: ${{steps.git_metadata.outputs.git_branch}}
          version: ${{steps.git_metadata.outputs.git_version}}
        with:
          repository_server: quay.io
          repository_name: my-project-name
          repository_username: org+bot-user
          repository_password: ${{ secrets.QUAY_AUTH }}
          docker_tag: ${{ env.version }}
          docker_cache_tag: ${{ env.branch }}
          docker_args: >-
            --build-arg VERSION=${{ env.version }}
