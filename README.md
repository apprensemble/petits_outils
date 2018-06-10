# petits_outils
ensemble de petits outils pratiques

* script pour blacklister un pays avec iptables/ipset

** ./ipset_cn.sh ** : reinitialise IPTABLES et blackliste les pays decrit dans l'entete

** ./iptables_off.sh ** : desactive iptables, ne pas le faire trop longtemps, juste le temps d'un debug par exemple(5mn)

** ./config.sh ** : liste des ports {TCP,UDP}_{IN,OUT} ‡ dropper

** ./iptables_country.sh ** : deprecated, je l'ai laissÈ mais je devrais le supprimer, est inutile.

** ./iptables.sh ** : active les regles iptables autres que le drop des pays. C'est ce script qui source config.sh


## utilisation :

```
git clone https://github.com/apprensemble/petits_outils.git
cd petit_outils
# dans le fichier ipset_cn.sh 
# definir PO_HOMEDIR sur le rep du clone exemple : PO_HOMEDIR=/home/user/petits_outils
# definir la liste des pays ‡ blacklister via le code comme fr pour la FRance
./ipset_cn.sh
```

## RAF :

* externaliser les variables du script principal
* offrir la possibilit√ de choisir entre une whitelist et une blacklist ou m√me un mix...
* reorganiser l'arbo afin de pouvoir ajouter d'autres petits outils tel que l'updater de dyndns ovh
