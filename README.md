# Dockerisation de libertempo

[![BCH compliance](https://bettercodehub.com/edge/badge/Libertempo/libertempo-docker?branch=master)](https://bettercodehub.com/)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/ae69b553f18f48cfb7e56f79f686ce50)](https://www.codacy.com/app/Libertempo/libertempo-docker?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Libertempo/libertempo-docker&amp;utm_campaign=Badge_Grade)

Ce readme n'a pas pour objectif de vous apprendre ce qu'est docker, la [doc officielle](https://docs.docker.com/) le fait bien mieux.

Par contre, il va vous permettre, en moins de 10 minutes (lecture comprise, no joke), d'avoir une instance de libertempo dockerisée. Il faut pour cela quelques prérequis :
* Docker installé sur votre poste
* Source de [Libertempo](https://github.com/wouldsmina/Libertempo) sur votre poste
* Votre poste sous Unix
* Source de ce repo sur votre poste
* Dans certains cas `apparmor` et `cgroup-lite` ([voir ticket](https://github.com/Prytoegrian/libertempo-docker/issues/5))

Vous avez tout cela, alors c'est parti !

## Configuration
La première des étapes est la préparation des sources pour créer un docker qui vous soit propre. Nous allons donc dire à docker de faire pointer les sources du site « Libertempo » en dehors de docker (comme un lien symbolique en somme).
La véritable localisation des sources de Libertempo se trouvera sur votre poste, de tel sorte que vous puissez travailler sans avoir à entrer dans docker en permanence.

Pour cela, copiez `run.sh.example` vers `run.sh` et modifiez la ligne du nouveau fichier `{path/de/libertempo/sur/votre/poste}`.

Chez moi, puisque mes sources de libertempo se trouvent dans `/home/Prytoegrian/tardis/libertempo`, la ligne ressemblera donc à
```bash
    -v /home/Prytoegrian/tardis/libertempo:/var/www/web \
```
De plus, pour bien paramétrer votre système, vous aurez aussi à bien positionner les droits utilisateurs. Pour ce faire, copiez `bootstrap.sh.example` vers `bootstrap.sh` et mettez votre identifiant unix à la place de « {whoami} ».

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

Voilà, vous venez de créer le container, votre application est fonctionnelle ; pour vous en assurer, tapez :
```sh
docker inspect --format '{{ .NetworkSettings.IPAddress }}' libertempo
```

Cette IP vous donne l'IP à laquelle répond le docker de l'application. Copiez-la cette IP dans le fichier `/etc/hosts` comme suit :

```
{IP} libertempo

```

Et rendez vous dans :
```
libertempo/install
```

Tadaaa ! Une application libertempo pleinement opérationnelle.

Bien que non nécessaire à la vie de l'application, vous pourriez vouloir entrer dans le système dockerisé. Pour ce faire, saisissez :
```
docker attach libertempo
```

Et vous voici dans le docker de libertempo, félicitations ! Faites un `ls` pour vous en assurer, vous avez bien les sources du logiciel.

## Cycle de vie habituel
Pour sortir du système dockerisé, faites `Ctrl-P Ctrl-Q` et vous voilà dehors. Tout simplement. Docker est toujours lancé, vérifiez votre navigateur, mais vous êtes à présent détaché.

La plupart du temps, vous n'aurez besoin de rien de plus que :
* `docker ps [-a]` : pour lister les containers
* `docker start {monContainer}`
* `docker attach {monContainer}`
* `docker stop {monContainer}`

Vous n'aurez plus besoin des scripts `./build` et `./run.sh`, il ne servent qu'à initier la machinerie de départ.

## LDAP
LDAP tourne automatiquement sur le docker, mais ne possède rien de plus que l'utilisateur `admin:admin`. Pour ajouter d'autres utilisateurs, lancez `/opt/run/add_users_ldap.sh`

## Améliorations
:warning: Attention : si vous avez d'autres applications dockerisées lancées en parallèle, il se peut que l'IP du serveur de libertempo change. Pensez donc bien à couper les autres (suivre [cette issue](https://github.com/Prytoegrian/libertempo-docker/issues/1)), de toute façon vu que libertempo mappe les ports vous aurez un message d'erreur.
