#docker run -i -t -p 8888:8888 moby
#docker run -i -t -p 8888:8888  --mount  source=jl-vol, target=/home moby
docker run -i -t -p 8888:8888 -v jl-vol:/home moby
