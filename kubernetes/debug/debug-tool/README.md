# build debug docker image
docker build -t ekambaram/debug-tool .

docker push ekambaram/debug-tool

docker pull docker.io/ekambaram/debug-tool:latest
