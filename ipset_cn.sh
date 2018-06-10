#!/bin/bash
### Block all traffic from AFGHANISTAN (af) , CHINA (CN), RUSSIAN FEDERATION (RU), TURKEY (TR) etc. Use ISO code ###
ISO="af cn ru kr tr pk tw sg hk"

### Set PATH ###
PO_HOMEDIR=/root/bin/
IPT=/sbin/iptables
WGET=/usr/bin/wget
EGREP=/bin/egrep
IPSET=/sbin/ipset

#src/dst country
ZONEROOT="${PO_HOMEDIR}iptables"
DLROOT="http://www.ipdeny.com/ipblocks/data/countries"
SETCIBLE=country_set

$IPSET list $SETCIBLE 2>&1> /dev/null
if [ $? -eq 0 ];then
echo "swap"
SWAP=new_
fi
$IPSET create ${SWAP}$SETCIBLE hash:net

#preparation ipset
if [ ! -d ${ZONEROOT} ];then
mkdir ${ZONEROOT}
fi
for c in $ISO
do
	# local zone file
	tDB=$ZONEROOT/$c.zone

	# get fresh zone file
	$WGET -O $tDB $DLROOT/$c.zone
 
	# get fresh zone file
echo "cat $tDB | xargs -n1 -P2 $IPSET -A ${SWAP}$SETCIBLE"
cat $tDB | xargs -n1 -P2 $IPSET -A ${SWAP}$SETCIBLE
done

#swap
if [ -n "${SWAP}" ];then
$IPSET -W $SETCIBLE ${SWAP}$SETCIBLE
$IPSET -X ${SWAP}$SETCIBLE
fi
${PO_HOMEDIR}iptables_off.sh
$IPT -A INPUT -p tcp -m set --match-set $SETCIBLE src -j DROP
${PO_HOMEDIR}iptables.sh
