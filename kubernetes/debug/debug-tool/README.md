# build debug docker image
docker build -t ekambaram/debug-tool:1125 .

docker push ekambaram/debug-tool:1125

docker pull docker.io/ekambaram/debug-tool:1125
