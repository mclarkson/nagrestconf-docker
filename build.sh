# clean
rm -rf buildfiles/

# Build the nagrestconf debs
docker build build-debs/ -t nagrestconf-build

# Spin up the build container
docker run --name buildfiles -d nagrestconf-build

# Copy from the build container to buildfiles/ dir
docker cp buildfiles:/build/nagrestconf/SOURCES/ buildfiles

# Stop and delete the build container
docker stop buildfiles
docker rm buildfiles

# Now we can...
# Build nagrestconf-restarter
docker build nagrestconf-restarter/ -t mclarkson/nagrestconf-restarter
# Build nagrestconf
docker build -t mclarkson/nagrestconf --build-arg DEBIAN_FRONTEND=noninteractive .
