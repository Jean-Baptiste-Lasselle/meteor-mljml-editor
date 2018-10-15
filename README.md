# Monter un enviroonnment de développement meteor valide
### Petit listing première installation mteor dans un conteneur

```bash
jibl@pc-alienware-jib:~$ ssh jibl@production-docker-host-1.kytes.io
jibl@production-docker-host-1.kytes.io's password: 
Last login: Mon Oct 15 22:28:13 2018 from pc-alienware-jib.home
[jibl@pc-100 ~]$ ssh jibl@production-docker-host-1.kytes.io
ssh: Could not resolve hostname production-docker-host-1.kytes.io: Name or service not known
[jibl@pc-100 ~]$ docker exec -it sondereseau bash
[root@9f87ef75ced2 /]# sh -c "$(curl -sSL https://install.meteor.com/)"
Downloading Meteor distribution
######################################################################## 100.0%

Meteor 1.8 has been installed in your home directory (~/.meteor).
Writing a launcher script to /usr/local/bin/meteor for your convenience.

To get started fast:

  $ meteor create ~/my_cool_app
  $ cd ~/my_cool_app
  $ meteor

Or see the docs at:

  docs.meteor.com

[root@9f87ef75ced2 /]# meteor create ~/wesh-trop-bon

You are attempting to run Meteor as the 'root' superuser. If you are developing, this is almost certainly *not* what you want to do and will likely result in incorrect file permissions. However, if you are
running this command in a build process (CI, etc.), or you are absolutely sure you know what you are doing, set the METEOR_ALLOW_SUPERUSER environment variable or pass --allow-superuser to proceed.

Even with METEOR_ALLOW_SUPERUSER or --allow-superuser, permissions in your app directory will be incorrect if you ever attempt to perform any Meteor tasks as a normal user. If you need to fix your permissions,
run the following command from the root of your project:

  sudo chown -Rh <username> .meteor/local

[root@9f87ef75ced2 /]# 

```

# Dockerfile

Le listing `./construction/conteneur-ide/Dockerfile`
```yaml
FROM centos:7
# Labels éditeur

# ARG / ENV : ici, on aura que des "ARGS", car on veut fixer les 
# versions de NVM, NODEJS, et METEOR, dans le même conteneur : 
# on ne veut pas pouvoir changer de version de meteor au run, sinon il fautdrait une installation, ou alors pourquoi pas un ENTRYPOINT, les CMD étant topujours ajoutés au ENTRYPOINT...
ARG VERSION_NVM=1.0.0
ENV VERSION_NVM=$VERSION_NVM

ARG VERSION_NODEJS=1.0.0
ENV VERSION_NODEJS=$VERSION_NODEJS

ARG VERSION_METEOR_FRAMEWORK=1.0.0
ENV VERSION_METEOR_FRAMEWORK=$VERSION_METEOR_FRAMEWORK

# Boîte à outils système
RUN yum update -y && yum install -y curl wget net-tools vim 

# Installation de NodeJS / NVM, pour gérer les versions NodeJS
# 

# Installation de Meteor
# curl https://install.meteor.com/ | sh
# sh -c "$(curl -sSL https://install.meteor.com/)"

```
Et le listing `./construction/conteneur-ide/point-d-entree.sh` : 
```bash

```

Pour afficher la liste de toutes les version de release NVM :
```bash
git ls-remote --tags https://github.com/creationix/nvm|awk -F / '{print $3}'|awk -F ^ '{print $1}'
```
Ce qui permet de choisir une release existante, ou tout du moins de toujours avoir la comparaison de la liste des exsitante, avec la version effectivement utilisée dans le conteneur. 
Grâce au entrypont, on pourra donc changer la valeur d'une variable d'environnement, pour changer la version de NVM, en fonctiond e la liste des versions affichées dans le docker logs du conteneur.

Je peux aussi chercher une façon de trier la lsite et déduire automatiquement, quel est la version la plus récente, voire la `N-1`.


### Mieux

```bash
export HORODATAGE_OPS=$(date '+%Y-%m-%dday_%Hh-%Mmin-%Ssec')

# On récupère d'abord la liste exhaustive des versions de NVM, soit les tags du repo ofiicle NVM.
git ls-remote --tags https://github.com/creationix/nvm| grep -v {|awk -F / '{print $3}'|awk -F ^ '{print $1}' >> liste-versions-avec-v.kytes

# On se débarasse des métadonnées pour ne garder par ligne, que le strict numéro de version, préfixé de la lettre "v" (les tags du repo officiel NVM sont ainsi préfixés...) :  
while read iterateur; do   iterateur=${iterateur#"v"} ; echo "$iterateur" >> ./liste-versions-NVM-a-trier-$HORODATAGE_OPS.kytes; done <./liste-versions-avec-v.kytes 

# À ce stade, on a généré un fichier qui contient la liste de toutes les versions de NVM, en syntaxe semver.
# On va donc maintenant trier cette liste, pour en retirer la dernière et l'avant dernière entrée : 
export DERNIRE_VERSION_NVM=$(sort --version-sort ./liste-versions-NVM-a-trier-$HORODATAGE_OPS.kytes | tail -n 1 | head -n 1)
export AVANT_DERNIRE_VERSION_NVM=$(sort --version-sort ./liste-versions-NVM-a-trier-$HORODATAGE_OPS.kytes | tail -n 2 | head -n 1)

# Maintenant, on va installer NVM dans son avant dernière version (petite habitude d'ingénierie, l'avant dernière a tout de même une maturité, la denrière est trop jeune)

curl "https://raw.githubusercontent.com/creationix/nvm/v$AVANT_DERNIRE_VERSION_NVM/install.sh" | bash
```
Un test qui a  fonctionné : 

```bash
jibl@pc-alienware-jib:~$ git ls-remote --tags https://github.com/creationix/nvm| grep -v {|awk -F / '{print $3}'|awk -F ^ '{print $1}' >> liste-versions-avec-v.kytes 
jibl@pc-alienware-jib:~$ rm -f liste-versions-NVM-a-trier-2018-10-16day_01h-19min-19sec.kytes 
jibl@pc-alienware-jib:~$ while read iterateur; do   iterateur=${iterateur#"v"} ; echo "$iterateur" >> ./liste-versions-NVM-a-trier-$(date '+%Y-%m-%dday_%Hh-%Mmin-%Ssec').kytes; done <./liste-versions-avec-v.kytes 
jibl@pc-alienware-jib:~$ sort --version-sort ./liste-versions-NVM-a-trier-2018-10-16day_01h-38min-13sec.kytes | tail -n 2 | head -n 10.33.10
jibl@pc-alienware-jib:~$ sort --version-sort ./liste-versions-NVM-a-trier-2018-10-16day_01h-38min-13sec.kytes | tail -n 1 | head -n 1
0.33.11
jibl@pc-alienware-jib:~$ sort --version-sort ./liste-versions-NVM-a-trier-2018-10-16day_01h-38min-13sec.kytes | tail -n 3 | head -n 1
0.33.9
jibl@pc-alienware-jib:~$ sort --version-sort ./liste-versions-NVM-a-trier-2018-10-16day_01h-38min-13sec.kytes | tail -n 4 | head -n 1
0.33.8
jibl@pc-alienware-jib:~$ sort --version-sort ./liste-versions-NVM-a-trier-2018-10-16day_01h-38min-13sec.kytes | tail -n 4 
0.33.8
0.33.9
0.33.10
0.33.11
jibl@pc-alienware-jib:~$ 
```
