## Usage

### Images

- dev: mounts local directory as a volume and runs tests
- ci: clones remote github repo and launches tests

### Build images

```
sh build-images.sh
```

### Run dev image

Move inside storm puppet module directory and run:

```
docker run -ti --rm -v $(pwd):/module:z italiangrid/docker-rspec-puppet:dev
```

