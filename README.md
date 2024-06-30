# postgres-backup
Provides daily DB backup service to AWS S3


## Build the Docker image:
```sh
docker build -t postgres-backup .
```

## Run the Docker container:
```sh
docker run -d \
    -e DB_HOST=yourdbhost \
    -e DB_NAME=yourdbname \
    -e DB_USER=yourdbuser \
    -e DB_PASSWORD=yourdbpassword \
    -e AWS_ACCESS_KEY_ID=yourawsaccesskeyid \
    -e AWS_SECRET_ACCESS_KEY=yourawssecretaccesskey \
    -e AWS_DEFAULT_REGION=yourawsregion \
    --name postgres-backup-container \
    postgres-backup

```

## Push image:
```sh
# Build the Docker image
docker build -t postgres-backup .

# Log in to Docker Hub
docker login

# Get the Git commit SHA and version tag
GIT_COMMIT_SHA=$(git rev-parse --short HEAD)
VERSION_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "latest")

# Tag the image with the commit SHA
docker tag postgres-backup mydockerhubuser/postgres-backup:$GIT_COMMIT_SHA

# Tag the image with the version tag (or 'latest' if no version tag is found)
docker tag postgres-backup mydockerhubuser/postgres-backup:$VERSION_TAG

# Push the images
docker push mydockerhubuser/postgres-backup:$GIT_COMMIT_SHA
docker push mydockerhubuser/postgres-backup:$VERSION_TAG

```

