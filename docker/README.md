## nomad via docker

### Get the image

Build the image with:

```
docker build --rm --tag reconhub/nomad -f docker/Dockerfile .
```

Or pull from dockerhub:

```
docker pull reconhub/nomad
```

### Run the image

with `$DEST` holding the path to your configuration, run:


```
docker run --rm --user $(id -u) -v $(realpath $DEST):/build reconhub/nomad
```

* the `--rm` argument removes the container on exit
* the `--user $(id -u)` argument means that the permissions of the created files will match your user permission (usually what you want, unless you're using a named volume)
* The `-v $(realpath $DEST):/build` argument maps the `$DEST` directory to `/build` in the container (which is nomad's default place to look).  Docker requires the absolute path, which we get with `realpath`

A runnable minimal example:

```
DEST=mynomad
mkdir $DEST

cat <<EOF > $DEST/nomad.yml
git: false
r: false
rstudio: false
rtools: false
EOF

echo "ape" > $DEST/package_list.txt

docker run --rm --user `id -u` -v `realpath $DEST`:/build reconhub/nomad
```
