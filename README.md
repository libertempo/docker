# Dockerisation des applications Libertempo

[![BCH compliance](https://bettercodehub.com/edge/badge/libertempo/docker?branch=php71)](https://bettercodehub.com/)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/aada840da70941398538a1ec70950e16)](https://www.codacy.com/app/libertempo/docker)

*Cette branche est dédiée à la mise en place des applications libertempo sous PHP 7.1. Pour d'autres versions, consultez les [autres branches](https://github.com/libertempo/docker/branches)*.

Ce readme n'a pas pour objectif de vous apprendre ce qu'est docker, la [doc officielle](https://docs.docker.com/) le fait bien mieux.

Par contre, il va vous permettre, en moins de 10 minutes (lecture comprise, no joke), d'avoir une instance de libertempo dockerisée. Il faut pour cela quelques prérequis :

* Docker et docker-compose installés sur votre poste
* Source de [Libertempo](https://github.com/libertempo/web) sur votre poste
* Source de ce repo sur votre poste
* Dans certains cas `apparmor` et `cgroup-lite` ([voir ticket](https://github.com/Prytoegrian/libertempo-docker/issues/5))

Vous avez tout cela, alors c'est parti !

## Configuration

La première des étapes est d'associer une IP à votre application dans le fichier hosts :

```bash
# /etc/hosts
localhost libertempo
```

Ensuite, vous devez préparer les sources pour créer un docker qui vous soit propre. Nous allons donc dire à docker de faire pointer les sources du site « Libertempo » en dehors de docker (comme un lien symbolique en somme).
La véritable localisation des sources de Libertempo se trouvera sur votre poste, de telle sorte que vous puissiez travailler sans avoir à entrer dans docker en permanence.

Pour cela, modifiez le fichier `.env.dist`. Vous devez ici exécuter la commande `id` pour l'utilisateur de votre choix et mettre les valeurs retournées à la place. Puis, changez les patchs web et api.

## Installation de l'application

Une fois ceci fait, nous pouvons créer l'image de l'application Libertempo dockerisée. Exécutez donc le fichier d'installation :

```bash
make set-env
make build
```

c'est lui qui va initialiser tout le serveur avec ses dépendances.

Il s'agit d'une installation d'un système unix somme toute normale (les lignes ne devraient pas vous surprendre), basée sur les ordres fournis par le fichier `Dockerfile`, un équivalent d'un `makefile`.

**NOTE**: Si le build échoue à cause d'une résolution DNS, pensez à adapter la règle 'FORWARD' de votre pare-feu.

Enfin, la dernière étape :

```bash
make install
```

(*Le serveur MySQL est un peu capricieux à démarrer. Si l'opération échoue, recommencez*)

Tadaaa ! Une application libertempo pleinement opérationnelle. Vous pouvez vous en assurer en vous rendant sur `http://libertempo/`.

## Coupure et démarrage de l'application

Une fois l'application installée, son cycle de vie normal se résume en

```bash
make start
```

et

```bash
make stop
```

## Maintenance

Bien que non nécessaire à la vie de l'application, vous pourriez vouloir entrer dans le système dockerisé. Pour ce faire, saisissez :

```bash
make attach
```

Pour sortir du système dockerisé, faites `Ctrl-P Ctrl-Q` et vous voilà dehors. Tout simplement. Docker est toujours lancé, vérifiez votre navigateur, mais vous êtes à présent détaché.

## LDAP

LDAP tourne automatiquement sur le docker et l'utilisateur `admin:admin` seulement peut se connecter au serveur. Les utilisateurs disponibles dans le serveur sont listés dans [le fichier dédié](https://github.com/libertempo/docker/blob/master/containers/base/content.ldif).

Au besoin, pour lister les utilisateurs, faites :

```bash
ldapsearch -x -w admin -D cn=admin,dc=libertempo -b "ou=People,dc=libertempo"
```
