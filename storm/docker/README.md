## Usage

### Build image

```
docker build . -t italiangrid/docker-rspec-puppet
```

### Run tests

Move inside storm puppet module directory and run:

```
docker run -ti --rm -v $(pwd):/module:z italiangrid/docker-rspec-puppet:latest
```
