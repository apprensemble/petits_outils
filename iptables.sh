#test
#iptables --flush
#iptables -A INPUT -i eth0 -p tcp -m multiport --dports 22,80,443,587,25,143,993,465 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o eth0 -p tcp -m multiport --sports 22,80,443,587,25,143,993,465 -m state --state ESTABLISHED -j ACCEPT
#iptables -A INPUT -s 127.0.0.1 -j ACCEPT
#iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT

##reel

#iptables -A INPUT -j REJECT
#iptables -A FORWARD -j REJECT
#iptables --flush
#iptables -P INPUT DROP
#iptables -P FORWARD DROP
#iptables -P OUTPUT DROP
##autorisation ping 

iptables -A INPUT -s 127.0.0.1 -j ACCEPT
iptables -t filter -A INPUT -p icmp -j ACCEPT

##protection scanne

iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT

##protect syn flood

iptables -A FORWARD -p tcp --syn -m limit --limit 1/second -j ACCEPT
iptables -A FORWARD -p udp -m limit --limit 1/second -j ACCEPT
iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit 1/second -j ACCEPT
iptables -A INPUT -i eth0 -p tcp -m multiport --dports 22,25,80,443,587,143,993,465 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp -m multiport --sports 22,25,80,443,587,143,993,465 -m state --state ESTABLISHED -j ACCEPT

iptables -A INPUT -i eth0 -p udp -m multiport --dports 1194 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p udp -m multiport --sports 1194 -m state --state ESTABLISHED -j ACCEPT

iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT


#openvpn
iptables -A FORWARD -i tun0 -o eth0 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#iptables -A FORWARD -i eth0 -o tun0 -m state --state ESTABLISHED,RELATED -j ACCEPT
#iptables -A FORWARD -s 10.8.0.0/24 -o eth0 -j ACCEPT
#iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

#inutile

#iptables -A OUTPUT -o eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A INPUT -i eth0 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o eth0 -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A INPUT -i eth0 -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A INPUT -i eth0 -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT
#iptables -A INPUT -i eth0 -p tcp --dport 25 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o eth0 -p tcp --sport 25 -m state --state ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -p tcp --sport 587 -j ACCEPT
#iptables -A INPUT -i eth0 -p tcp --dport 587 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A INPUT -i eth0 -p tcp --dport 143 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o eth0 -p tcp --sport 143 -m state --state ESTABLISHED -j ACCEPT
#iptables -A INPUT -i eth0 -p tcp --dport 993 -m state --state NEW,ESTABLISHED -j ACCEPT
#iptables -A OUTPUT -o eth0 -p tcp --sport 993 -m state --state ESTABLISHED -j ACCEPT
#

#port 80 flood
iptables -A INPUT -p tcp --dport 80 -m limit --limit 50/minute --limit-burst 200 -j ACCEPT
#
##log
iptables -N LOGGING
iptables -A INPUT -j LOGGING
iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables Packet Dropped: " --log-level 7
iptables -A LOGGING -j DROP

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP
