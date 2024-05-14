# natpmpc-netns

natpmpc-netns is a script/systemd service which can be used to permanently request
the port forwarding of an external port from a vpn using natpmpc on a specific netns (network namespace).

It can be used to request a single port (both tcp and udp) for each netns configured.

natpmpc-netns can detect if the provided external port or ip address changed,
can optionally run a provided script if configured,
and will save the public ip and port in the following files:

- `/tmp/netns_[NETNS]_port_[PORT]_public_ip`
- `/tmp/netns_[NETNS]_port_[PORT]_public_port`

## Install

Run `make install` to copy the systemd service in `/etc/systemd/system` and the scripts in `/usr/local/bin`

## Prerequisites

- An active vpn connection, possibly in a configured Linux network namespace.
You can use [openvpn-netns](https://github.com/aleqx/openvpn-netns) or [namespaced-openvpn](https://github.com/slingamn/namespaced-openvpn) for that.

- `natpmpc` should be installed (`sudo apt install natpmpc`).

## Usage

As an example, let's say we want to request an external port on the VPN for the local port 4444 in the existing netns "vpn0"

Run the following commands as root:

```bash
# Make a folder in /etc/natpmpc for each netns to configure
mkdir -p /etc/natpmpc/vpn0

# Add a port file containting the requested port for this netns
echo "4444" > /etc/natpmpc/vpn0/port

# Start a natpmpc-netns service
systemctl start natpmpc@vpn0.service

# Check its status
systemctl status natpmpc@vpn0.service

# Look at the latest logs
journalctl -u natpmpc@vpn0.service -f

# Start the service at boot
systemctl enable natpmpc@vpn0.service
```

Every 45 seconds, the `natpmpc-netns` script will request a renewal of the request for the external port.

The external ip and external port detected will be written in the following files (still assuming netns=vpn0 and port=4444):

- `/tmp/netns_vpn0_port_4444_public_ip`
- `/tmp/netns_vpn0_port_4444_public_port`

## Usage in the default network namespace

It is also possible to request a port on the current vpn without using a network namespace (on the default one).

The usage is the same as above, you just have to set the port in the `/etc/natpmpc/default/port` file and use the `natpmpc@default.service` service.

## Running a script when the external ip or port changed

You probably want to run a command if the external ip or port changed.

Put the script you want to be run in the /etc/natpmpc/vpn0/cmd file.

Example:

```
#!/bin/bash
logger "External ip:port changed for local port 4444: $PUBLIC_IP:$PUBLIC_PORT"
```

You need to set this file as executable with:
```
chmod +x /etc/natpmpc/vpn0/cmd
```
