## Usage

### Build image

```
sh build-image.sh
```

### Run image for local tests

Move inside storm puppet module directory and run:

```
docker run -ti --rm -v $(pwd):/module:z italiangrid/docker-rspec-puppet:ci
```

### Run tests

Run tests as follow:

```
bundle exec rake test
```

### Generate documentation

Generate REFERENCE.md file as follow:

```
puppet strings generate --format markdown
```

Update gh-pages branch as follow:

```
bundle exec rake strings:gh_pages:update
```