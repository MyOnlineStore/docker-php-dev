[![Images Build](https://github.com/MyOnlineStore/docker-php-dev/actions/workflows/build.yml/badge.svg)](https://github.com/MyOnlineStore/docker-php-dev/actions/workflows/build.yml)
# docker-php-dev
This repository contains Docker images used for running php applications owned by development.

## Build
Changes to existing or new images will automatically be build by the Github Action workflow.
The images are pushed to [eu.gcr.io/myonlinestore-dev](https://eu.gcr.io/myonlinestore-dev) and will have the prefix `php-dev-`.

## Pulling images
1. Install the [Google Cloud SDK](https://cloud.google.com/sdk/docs/install).
2. Login with your Google Account:
```shell
gcloud auth login
```
3. Authenticate your local Docker daemon:
```shell
gcloud auth configure-docker
```
4. Pull an image via docker:
```shell
docker pull eu.gcr.io/myonlinestore-dev/php-dev-fpm:8.0-alpine
```