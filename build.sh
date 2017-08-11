rm -rf buildfiles/
docker build build-debs/ -t nagrestconf-build
docker run --name buildfiles -d nagrestconf-build
docker cp buildfiles:/build/nagrestconf/SOURCES/ buildfiles
docker stop buildfiles
docker rm buildfiles
docker build nagrestconf-restarter/ -t nagrestconf-restarter
docker build -t nagrestconf --build-arg DEBIAN_FRONTEND=noninteractive .
