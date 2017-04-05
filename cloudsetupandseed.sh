echo "----Setting IP---"
sh setIp.sh
echo "checking if postgresql is up"

sh stopPostgresql.sh

echo "----stopping postgresql----"
echo "sudo service postgresql stop"
sudo service postgresql stop
cd /home/aman/data/cloud/docker
echo "----building and starting docker images using docker-compose-ub.yml file----"
echo "docker-compose -f docker-compose-ub.yml build; docker-compose -f docker-compose-ub.yml up -d"
docker-compose -f docker-compose-ub.yml build
docker-compose -f docker-compose-ub.yml up -d
echo "----building and starting docker images using docker-compose-dev-oneteam.yml file----"
echo "docker-compose -f docker-compose-dev-oneteam.yml build; docker-compose -f docker-compose-dev-oneteam.yml up -d"
docker-compose -f docker-compose-dev-oneteam.yml build
docker-compose -f docker-compose-dev-oneteam.yml up -d
cd /home/aman/data/cloud
echo "----build cloud environment data seeding tar----"
echo "gradle clean build"
gradle clean build
cd distribution/build/distributions
echo "----extracting tar----"
echo "tar -xvf wavity-distribution-1.0.0-SNAPSHOT.tar"
tar -xvf wavity-distribution-1.0.0-SNAPSHOT.tar
cd wavity-distribution-1.0.0-SNAPSHOT
echo "----running development task on cloud deployment----"
echo "gradle --refresh-dependencies -s development"
gradle --refresh-dependencies -s development


echo "restarting scim and cas containers"
echo "docker restart devapps1scim1, docker restart devapps1cas1"
docker restart devapps1scim1
docker restart devapps1cas1
