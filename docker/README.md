## Puppet module images

## How to build images

The build relies on the CNAF SD helper scripts:

https://baltig.infn.it/mw-devel/helper-scripts

1. Enter image directory 
2. type `build-docker-image.sh`

### CI image

Use image for local tests as follow.

1. Move inside storm puppet module directory and run:

```
docker run -ti -v $(pwd):/module:z italiangrid/docker-rspec-puppet:ci /bin/bash
```

2. Run tests as follow:

```
cd /module
rake test
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

Insert your github account when prompted.