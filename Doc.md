# Step by Step Configuration

## Config Master VM

Use files in [master](./master) folder for configuring setup Master VM.

1. Install RDP and Ansible

    - Once VMs were all created, connect to master VM and install & setup _RDP_ and _Ansible_.

    > See https://docs.microsoft.com/en-us/azure/virtual-machines/linux/use-remote-desktop for configuring RDP.

2. Install plugins manager

    - Install plugins manager
        ```
        curl -o /home/iljoong/apache-jmeter-5.1.1/lib/ext/jmeter-plugins-manager-1.3.jar -J -L http://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.3/jmeter-plugins-manager-1.3.jar
        ```
    - Run `Jmeter` GUI and install plugins manager.

3. Install plugins
    - After install plugin manager, install `Composite Timeline Graph` and `jpgc - Standard Set` plugins (Optons -> Plugins Manager).


4. Config Jmeter for distributed test
    - Create a new rmi-keystore (`rmi_kestore.jks`) file
    - Update rmi-keystore section in `user.properties` file
    - Update `remote_hosts` in `jmeter.properties` file
    
    > You could use in sample files in sample directory but it is recommended to create your own files. `rmi_kestore.jks` and `user.properties` are copied to all agents using .

## Config agents

Agents are configured through [Ansible](https://www.ansible.com/). 

Update `hosts` and `agent.yaml` in [ansible](./master/ansible) in folder and run ansible script to config agents.

```
ansible-playbook -i hosts agent.yaml
```

> You may login at least once before run test command. Otherwise, you will get `"ERROR! Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this.  Please add this host's fingerprint to your known_hosts file to manage this host."` error

For testing connection to agents, run following command.

```
ansible -i hosts all -m ping -u <user> [--ask-pass]
```

## Create a test plan

Use [sample.jmx](./master/sample.jmx) to test with remote servers.

Create your own test plan and test with remote servers.

## References

### Distributed Jmeter Config:

- https://medium.com/@yash3x/how-to-setup-distributed-load-testing-with-jmeter-fba703f41a32
- http://www.softwaretestingclass.com/jmeters-distributed-testing-jmeter-tutorials-series-day-10/

### Plugin:

- https://jmeter-plugins.org/install/Install/
- https://jmeter-plugins.org/wiki/CompositeGraph/
- https://www.blazemeter.com/blog/how-to-use-the-composite-graph-plugin-in-jmeter/

### Test:

- https://www.seleniumeasy.com/jmeter-tutorials/http-request-sampler-example
- https://www.blazemeter.com/blog/what’s-the-max-number-of-users-you-can-test-on-jmeter/