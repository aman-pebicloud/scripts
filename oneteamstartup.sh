#!/bin/bash

cd $cloudrepo/docker
setup(){
  echo "--copy java-cas-client.properties--"
  sudo cp bin/ot-cas-client.properties /etc/java-cas-client.properties
}

stopPostgresql(){
  echo "----stopping postgresql----"
  sudo service postgresql stop
}

buildDockerImages(){
  gradle bust
  echo "---building and starting docker images ---"
  echo "docker-compose -f docker-compose-ub.yml build"
  docker-compose -f docker-compose-ub.yml build
  echo "docker-compose -f docker-compose-dev-oneteam.yml build"
  docker-compose -f docker-compose-dev-oneteam.yml build
  startDockerImages
}

startDockerImages(){
  echo "----starting docker images file----"
  echo "docker-compose -f docker-compose-ub.yml up -d"
  docker-compose -f docker-compose-ub.yml up -d
  sleep 20
  echo "docker-compose -f redis.yml up -d"
  docker-compose -f redis.yml up -d
  sleep 20
  echo "docker-compose -f docker-compose-dev-oneteam.yml up -d"
  docker-compose -f docker-compose-dev-oneteam.yml up -d
}

buildDistributions(){
  cd $cloudrepo
  echo "----build cloud environment data seeding tar----"
  echo "gradle clean build"
  gradle clean build
  cd distribution/build/distributions
  echo "----extracting tar----"
  echo "tar -xvf wavity-distribution-2.0.0-SNAPSHOT.tar"
  tar -xvf wavity-distribution-2.0.0-SNAPSHOT.tar
  cd wavity-distribution-2.0.0-SNAPSHOT
  echo "----running development task on cloud deployment----"
  echo "gradle --refresh-dependencies -s development"
  gradle --refresh-dependencies -s development
}

restartscimcas(){
  echo "restarting scim and cas containers"
  sleep 5
  echo "docker restart devapps1scim1; docker restart devapps1cas1"
  docker restart devapps1scim1 && docker restart devapps1cas1
}

  shutdown(){
    docker-compose -f docker-compose-dev-oneteam.yml down
    docker-compose -f docker-compose-ub.yml down
    docker-compose -f redis.yml down --remove-orphans
  }

  copyTenantInfo(){
    echo "copied tenant to clip board"
    echo "---tenant information---"
    cat bin/myTenant
    echo "go to self.wavity.net/doc"
    xdg-open https://self.wavity.net/scim/doc &
  }

case "$1" in
  all)
    setup
    #stopPostgresql
    buildDockerImages
    startDockerImages
    buildDistributions
    restartscimcas
    copyTenantInfo
    ;;
  down)
    shutdown
    ;;
  startDockerImages)
    startDockerImages
    ;;
  copyTenant)
    copyTenantInfo
    ;;
  *)
  echo "usage { all | buildContainers | startContainers | down }"
  ;;
esac
