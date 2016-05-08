# Dockerisation de libertempo

Ce readme n'a pas pour objectif de vous apprendre ce qu'est docker, la [doc officielle](https://docs.docker.com/) le fait bien mieux.

Par contre, elle va vous permettre, en moins de 10 minutes (lecture comprise, no joke), d'avoir une instance de libertempo dockerisée. Il faut pour cela quelques prérequis :
* Docker installé sur votre poste
* Source de Libertempo sur votre poste
* Votre poste sous Unix
* Source de ce repo sur votre poste

Vous avez tout cela, alors c'est parti !

## Configuration
La première des étapes est la préparation des sources pour créer un docker qui vous soit propre. Nous allons donc dire à docker de faire pointer les sources du site « Libertempo » en dehors de docker (comme un lien symbolique en somme).  
La véritable localisation des sources de Libertempo se trouvera sur votre poste, de tel sorte que vous puissez travailler sans avoir à entrer dans docker en permanence.

Pour cela, copiez `run.sh.example` vers `run.sh` et modifiez la ligne du nouveau fichier `{path/de/libertempo/sur/votre/poste}`

Chez moi, puisque mes sources de libertempo se trouvent dans `/home/Prytoegrian/tardis/libertempo`, la ligne ressemblera donc à 
```bash
    -v /home/Prytoegrian/tardis/libertempo:/var/www/libertempo \
```
## Creation de l'image
Une fois ceci fait, nous pouvons créer l'image de l'application Libertempo dockerisée. Executez donc le fichier d'installation :
```
./build.sh
```
c'est lui qui va initialiser toute l'appli avec ses dépendances.

Il s'agit d'une installation d'un système unix somme toute normale (les lignes ne devraient pas vous surprendre), basée sur les ordres fournis par le fichier `Dockerfile`, un équivalent d'un `makefile`.  
L'installation terminée, vous pouvez vous assurer de la présence de l'image dans la liste via : 
```sh
docker images
```

Elle y est ? Génial ! Passons à l'étape suivante.

## Création du container
Avoir une image c'est bien, mais avoir un container pour travailler, c'est mieux. Pour cela, rien de plus simple, lancez simplement :
```sh
./run.sh
```

Et vous voici dans le docker de libertempo, félicitations ! Faites un `ls` pour vous en assurer, vous avez bien les sources du logiciel.  
Il vous faut maintenant accéder à libertempo depuis un navigateur web. Dans les quelques lignes du terminal, vous devriez avoir un retour comme ceci :
```sh
apache2: Could not reliably determine the server's fully qualified domain name
```

Cette ligne fait apparaître une IP. Copiez-la simplement dans votre navigateur : 
```
IP/libertempo/install
```

Tadaaa ! Une application libertempo pleinement opérationnelle.

### Cycle de vie habituel
Avant toute chose, il est possible que vous souhaitiez sortir de docker. Dans le docker, faites `Ctrl-P Ctrl-Q` et vous voilà dehors. Tout simplement. Docker est toujours lancé, vérifiez votre navigateur, mais vous êtes à présent détaché.

La plupart du temps, vous n'aurez besoin de rien de plus que :
* `docker ps [-a]` : pour lister les containers
* `docker start {monContainer}`
* `docker attach {monContainer}`

Vous n'aurez plus besoin des scripts `./build` et `./run.sh`, il ne servent qu'au lancement.


## Améliorations
Comme il est relativement chiant de copier l'IP à chaque fois, vous pouvez modifier le fichier `/etc/hosts` pour associer l'IP avec un nom à vous.
:warning: Attention cependant : si vous avez d'autres applications dockerisée lancée en parallèle, il se peut que l'IP du serveur de libertempo change. Pensez donc bien à couper les autres (#1 à suivre)

Une fois ceci fait, vous pouvez en plus configurer le vhost de docker pour avoir une URL du type : 
```
libertempo/install
```
