#install RDP
sudo apt -y install xfce4 xrdp
sudo systemctl enable xrdp
echo xfce4-session >~/.xsession
sudo service xrdp restart

# sudo netstat -plnt | grep rdp

#install ansible
sudo apt install -y ansible sshpass

#insatll additional Jmeter
sudo curl -o /home/apache-jmeter-5.1.1/lib/ext/jmeter-plugins-manager-1.3.jar -J -L http://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.3/jmeter-plugins-manager-1.3.jar

echo "export PATH=\"/home/apache-jmeter-5.1.1/bin/:\$PATH\"" >> .bashrc