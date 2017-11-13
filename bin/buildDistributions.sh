#!/bin/bash
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

