#!/bin/sh

sudo apt-get update
sudo apt install -y openjdk-8-jre-headless

curl -o /home/apache-jmeter-5.1.1.tgz -J -L http://mirror.navercorp.com/apache/jmeter/binaries/apache-jmeter-5.1.1.tgz
tar -xf /home/apache-jmeter-5.1.1.tgz -C /home/
chmod -R 777 /home/apache-jmeter-5.1.1