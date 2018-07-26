#!/bin/sh

export SERVICES=$cloudrepo/docker/docker-compose-caslocal.yml
# export SERVICES=$cloudrepo/docker/docker-compose-scimlocal.yml
export LDAP=$cloudrepo/docker/docker-compose-dev-ldap.yml
export REDIS=$cloudrepo/docker/redis.yml
export something;
export LDAP_HOST_IP=${ONETEAM_HOST_IP}
export REDIS_HOST_IP=${ONETEAM_HOST_IP}
export SCIM_HOST_IP=${ONETEAM_HOST_IP}
export CAS_HOST_IP=${ONETEAM_HOST_IP}
echo "OT IP : ${ONETEAM_HOST_IP}"
echo "SCIM IP : ${SCIM_HOST_IP}"
echo "LDAP IP : ${LDAP_HOST_IP}"
echo "REDIS IP : ${REDIS_HOST_IP}"
cd $cloudrepo/docker

ldap () {
      echo 'ldap---------------'
      docker-compose -f $LDAP build
      docker-compose -f $LDAP up -d
      echo "Waiting for UnboundId DS to be available ..."
	c=0
	sleep 12
    ldapsearch -h $LDAP_HOST_IP -p 389 -D 'cn=Directory Manager' -w GCz2Z4Rr92K4 -b dc=wavity,dc=com -s sub "(objectclass=wavityTenant)"
    while [ $? -ne 0 ]; do
        echo "UnboundId not up yet... retrying... ($c/20)"
        sleep 12
 		if [ $c -eq 20 ]; then
 			echo "TROUBLE!!! After [${c}] retries UnboundId is still dead :("
 			exit 2
 		fi
 		c=$((c+1))
    	ldapsearch -h $LDAP_HOST_IP -p 389 -D 'cn=Directory Manager' -w GCz2Z4Rr92K4 -b dc=wavity,dc=com -s sub "(objectclass=wavityTenant)"
    done
}

all () {
     echo 'all----------'
     ldap
     services
     seedDb
}

redisservices () {
     docker-compose -f $REDIS build
     docker-compose -f $REDIS up -d
     sleep 10
     all
}

redisservices1 () {
     docker-compose -f $REDIS build
     docker-compose -f $REDIS up -d
     sleep 10
     services
     seedDb
}

seedservices () {
     echo 'services----------'
     docker-compose -f $SERVICES build
     docker-compose -f $SERVICES up -d
     echo "seeding the DB-----"
     sleep 30
     cd ../distribution
     echo "----build distribution ----"
     echo "gradle clean build"
     gradle clean build
     cd ../distribution/build/distributions
     echo "----extracting tar----"
     echo "tar -xvf wavity-distribution-2.0.0-SNAPSHOT.tar"
     tar -xvf wavity-distribution-2.0.0-SNAPSHOT.tar
     cd wavity-distribution-2.0.0-SNAPSHOT
     echo "----running development task on cloud deployment----"
     echo "gradle --refresh-dependencies -s development"
     #gradle -s development
     gradle  -s development
     #gradle --refresh-dependencies -s development

}


db () {
     echo 'services----------'
     docker-compose -f docker-compose-db.yml build
     docker-compose -f docker-compose-db.yml up -d
     echo "seeding the DB-----"
     sleep 30
     cd ../distribution
     echo "----build distribution ----"
     echo "gradle clean build"
     gradle clean build
     cd ../distribution/build/distributions
     echo "----extracting tar----"
     echo "tar -xvf wavity-distribution-2.0.0-SNAPSHOT.tar"
     tar -xvf wavity-distribution-2.0.0-SNAPSHOT.tar
     cd wavity-distribution-2.0.0-SNAPSHOT
     echo "----running development task on cloud deployment----"
     echo "gradle --refresh-dependencies -s development"
     gradle -s development
     #gradle --refresh-dependencies -s development

}

wavity () {

echo 'infra---'
docker-compose -f services-infra.yml build
docker-compose -f services-infra.yml up -d
sleep 12

    ldapsearch -h $LDAP_HOST_IP -p 389 -D 'cn=Directory Manager' -w GCz2Z4Rr92K4 -b dc=wavity,dc=com -s sub "(objectclass=wavityTenant)"

    while [ $? -ne 0 ]; do
        echo "UnboundId not up yet... retrying... ($c/20)"
        sleep 12

                if [ $c -eq 20 ]; then
                        echo "TROUBLE!!! After [${c}] retries UnboundId is still dead :("
                        exit 2
                fi
                c=$((c+1))

        ldapsearch -h $LDAP_HOST_IP -p 389 -D 'cn=Directory Manager' -w GCz2Z4Rr92K4 -b dc=wavity,dc=com -s sub "(objectclass=wavityTenant)"
    done

docker-compose -f services-oneteam.yml build
docker-compose -f services-oneteam.yml up -d
sleep 10
seedDb
}


services () {
     echo 'services----------'
     docker-compose -f $SERVICES build
     docker-compose -f $SERVICES up -d

}

down () {
    echo 'down-------'
    docker-compose -f $SERVICES down
    docker-compose -f $REDIS down
}

seedDb () {
    echo 'seeding db---'

 sleep 30
     cd ../distribution
     echo "----build distribution ----"
     echo "gradle clean build"
     gradle clean build
     cd ../distribution/build/distributions
     echo "----extracting tar----"
     echo "tar -xvf wavity-distribution-2.0.0-SNAPSHOT.tar"
     tar -xvf wavity-distribution-2.0.0-SNAPSHOT.tar
     cd wavity-distribution-2.0.0-SNAPSHOT
     echo "----running development task on cloud deployment----"
     echo "gradle --refresh-dependencies -s development"
     #gradle -s development
     #gradle  -s development
     gradle --refresh-dependencies -s development

}


bust () {
    gradle bust
}

echo $1
<<COMMENT1
if [ $1 = 'ldap' ]
 then
     ldap
elif [ $1 = 'all' ]
 then
     all
elif [ $1 = 'services' ]
 then
     services
elif [ $1 = 'down' ]
 then
     down
fi
COMMENT1

case "$1" in
 ldap)
   ldap
   ;;
 all)
   all
   ;;
 seedservices)
   seedservices
   ;;
 services)
   services
   ;;
 seedDb)
   seedDb
   ;;
 down)
   down
   ;;
 redis)
   redisservices
   ;;
 redis1)
   redisservices1
   ;;
 wavity)
   wavity
   ;;
 db)
   db
   ;;
 bust)
   echo 'bust case'
   bust
   ;;
*)
   echo "Usage: tomcat {ldap|all|services|seedDb|down|bust | redis| redis1}" >&2
   exit 3
   ;;
esac
#EOF
