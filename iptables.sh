##autorisation ping 
source config.sh

iptables -A INPUT -s 127.0.0.1 -j ACCEPT
iptables -t filter -A INPUT -p icmp -j ACCEPT

##protection scanne

iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT

##protect syn flood

iptables -A FORWARD -p tcp --syn -m limit --limit 1/second -j ACCEPT
iptables -A FORWARD -p udp -m limit --limit 1/second -j ACCEPT
iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit 1/second -j ACCEPT

# ouverture de port I/O

iptables -A INPUT -i eth0 -p tcp -m multiport --dports ${TCP_PORT_ENTREE} -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp -m multiport --sports ${TCP_PORT_SORTIE} -m state --state ESTABLISHED -j ACCEPT

iptables -A INPUT -i eth0 -p udp -m multiport --dports ${UDP_PORT_ENTREE} -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p udp -m multiport --sports ${UDP_PORT_SORTIE} -m state --state ESTABLISHED -j ACCEPT

iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT


#openvpn
iptables -A FORWARD -i tun0 -o eth0 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

#port 80 flood
iptables -A INPUT -p tcp --dport 80 -m limit --limit 50/minute --limit-burst 200 -j ACCEPT

##log
iptables -N LOGGING
iptables -A INPUT -j LOGGING
iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables Packet Dropped: " --log-level 7
iptables -A LOGGING -j DROP

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP
