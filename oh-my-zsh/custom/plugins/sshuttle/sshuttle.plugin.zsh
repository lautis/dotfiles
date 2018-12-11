host2ip() {
  if which dscacheutil > /dev/null 2>&1; then # MacOS
    for host in $@; do
      dscacheutil -q host -a name $host | grep "address:" |awk {'print $2'}
    done
  else # Linux
    getent ahosts $* | awk {'print $1'}
  fi
}

# Tunnel only defined hosts
tunnel-hosts() {
  sshuttle -vr ${TUNNEL_HOST:-"tunnel"} `host2ip $*`;
}

# Tunnel all but defined hosts
tunnel-but() {
  sshuttle --dns -vr ${TUNNEL_HOST:-"tunnel"} `host2ip $* | sed "s/^/-x/"` 0/0;
}

# vpn to a ssh server
ssh-vpn() {
  sshuttle -HNvr $1;
}

compdef _hosts tunnel-hosts
compdef _hosts tunnel-bug
compdef _ssh_hosts ssh-vpn
