#!/bin/bash

#We need nodejs for this
#sudo apt-get install nodejs

#As we allready have a copy of termkit this is not needed
#git clone https://github.com/callesg/termkit.git
#cd termkit

#Install js modules
#the master branch of blessed has some horible bugs so we use git directly to get a fork with out those bugs. When resolved use: npm install phantom blessed
npm install phantom wcwidth
NpmResult=$?
if [ "${NpmResult}" != "0" ] 
then
	echo "npm failed. Do you have npm installed? Are our nodejs version to old? termkit is developed on latest stable nodejs"
	echo "A posible solution may be: sudo apt-get install nodejs npm"
	exit
fi

cd node_modules
git clone https://github.com/callesg/blessed
cd ..


#Then get a copy of phantom js
cd ..
git clone https://github.com/ariya/phantomjs.git
cd phantomjs
#Development is on some stable version of phantomjs
git checkout 1.9.7
#Apply patch to phantomjs and webkit
git apply ../termkit/renderTreeDump.patch
#build phantomjs get it a bit more silent and speed up the compiling by running in paralel 32 threds is fine as the build is IO bound not cpu
./build.sh --confirm --jobs 64

#Move the binary in to place
mv bin/phantomjs ../termkit/patched_phantomjs

