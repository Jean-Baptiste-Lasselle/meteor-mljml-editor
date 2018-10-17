# Objet de ce repo (purpose)

This repo brings you a provisioning recipe, for a container embedding a [Meteor Framework](https://www.meteor.com/) runtime.
It has been tested on a CentOS 7 system, with Docker and Docker compose installed on it.

You may install Docker and Docker compose with [one](https://github.com/Jean-Baptiste-Lasselle/provision-hote-docker-sur-centos)  of my personal recipes, on a bare CentOS 7 minimal installation.

If you snapshot/restore Virtual Machines all over, you might also have problems travelling back to the future, in which case I may let you use [my doloreane](https://github.com/Jean-Baptiste-Lasselle/mise-a-l-heure).

The very point of that recipe, is that is has parameters, which allow you to change (`./.env`), at runtime : 


| Variable | What it changes | Example value | 
| -------- | --------------- | ------------- |
| `NOM_PROJET_MARGUERITE_METEOR` | The meteor project name, like when you `meteor create my-super-project-say-rocketchat` | `bernard-projet-meteor` |
| `IN_CONTAINER_WORKSPACE_IDE` | The directory, in the container, in which the Meteor project will be created.  | `/marguerite/ide/workspace` |
| `REPERTOIRE_HOTE_DOCKER_MARGUERITE_IDE` | The directory, on the docker host, to which `$IN_CONTAINER_WORKSPACE_IDE` will be mapped.  | `./marguerite/ide/workspace` |
| `MARGUERITE_METEOR_PORT` | The port number, inside the docker container, that the meteor app will use on the server side.  | `2000` |
| `MARGUERITE_METEOR_NODE_OPTIONS` | The value you give to that variable, will be the exact value set for the `NODE_OPTIONS` environement variable, in use at runtime by the **Meteor Framework**.  | `--debug` |
| `MARGUERITE_METEOR_VERSION` | Sets and forces to set, the **Meteor Framework**'s version. Has to be semver, prefixes will be infered by provisioning automation.  | `1.8.0` |
| `MARGUERITE_NVM_VERSION` | Sets and forces to set, **NVM**'s version. Has to be semver, prefixes will be infered by provisioning automation. | `0.33.10` |
| `MARGUERITE_NODEJS_VERSION` | Sets and forces to set, the **NodeJS**' version. Has to be semver, prefixes will be infered by provisioning automation. | `8.12.0` |
| `MARGUERITE_NPM_VERSION` | Sets and forces to set, the **NPM**'s version. Has to be semver, prefixes will be infered by provisioning automation.  | `6.4.1` |


> `./.env`
```yaml
NOM_PROJET_MARGUERITE_METEOR=jbl-projet-meteor
# WORKSPACE_IDE=/marguerite/ide/esp-travail/
IN_CONTAINER_WORKSPACE_IDE=/marguerite/ide/esp-travail/
REPERTOIRE_HOTE_DOCKER_MARGUERITE_IDE=./marguerite/ide/workspace

MARGUERITE_METEOR_PORT=6000
MARGUERITE_METEOR_NODE_OPTIONS=""
# Faire en sorte que la version de meteor soit effectivement forcée par cette variable d'environnement
MARGUERITE_METEOR_VERSION=1.8.0
# Faire en sorte que la version de NVM soit effectivement forcée par cette variable d'environnement
MARGUERITE_NVM_VERSION=0.33.10
# Faire en sorte que la version de NODEJS soit effectivement forcée par cette variable d'environnement
# j'ai vu des préfixes de la forme "v8.12.0", dans la sortie std du build
MARGUERITE_NODEJS_VERSION=8.12.0
# OPTIONNEL: Faire en sorte que la version de NPM soit effectivement forcée par cette variable d'environnement
MARGUERITE_NPM_VERSION=6.4.1
```

# lnl

```bash
Step 17/26 : RUN echo " METEOR - IDE ==>> contenu du répertoire WORKSPACE_IDE, s'il existe  : "
 ---> Running in 688ccecb0759
 METEOR - IDE ==>> contenu du répertoire WORKSPACE_IDE, s'il existe  : 
Removing intermediate container 688ccecb0759
 ---> e37fad7820cc
Step 18/26 : RUN ls -all $WORKSPACE_IDE
 ---> Running in 1b06627dadc3
total 4
drwxr-xr-x. 1 jbl-devops wheel  88 Oct 17 02:00 .
drwxr-xr-x. 1 jbl-devops wheel  25 Oct 17 01:56 ..
drwxr-xr-x. 1 jbl-devops wheel 145 Oct 17 01:59 jbl-devops-projet-meteor
drwxr-xr-x. 1 jbl-devops wheel  39 Oct 17 02:00 jbl-projet-meteor
-rwxrwxr-x. 1 jbl-devops wheel 687 Oct 17 01:55 point-d-entree.sh
Removing intermediate container 1b06627dadc3
 ---> 06c5353c9df5
Step 19/26 : RUN echo " ----------------------------------- "
 ---> Running in 866274a2f420
 ----------------------------------- 
Removing intermediate container 866274a2f420
 ---> 04766f28733e
Step 20/26 : RUN echo " METEOR - IDE ==>> contenu du répertoire NOM_PROJET_MARGUERITE_METEOR, s'il existe  : "
 ---> Running in b85534754d99
 METEOR - IDE ==>> contenu du répertoire NOM_PROJET_MARGUERITE_METEOR, s'il existe  : 
Removing intermediate container b85534754d99
 ---> 63ea17de1710
Step 21/26 : RUN ls -all $WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR/
 ---> Running in 84255389b136
total 4
drwxr-xr-x. 1 jbl-devops wheel  39 Oct 17 02:00 .
drwxr-xr-x. 1 jbl-devops wheel  88 Oct 17 02:00 ..
-rwxrwxr-x. 1 jbl-devops wheel 590 Oct 17 01:55 marguerite-healthcheck.sh
Removing intermediate container 84255389b136
 ---> 0fc25a76b7dc

```
# Utilisation (How to use)

## Provision et Initialisation du cycle IAAC (Let's rock with you)

Pour exécuter cette recette une première fois (How to execute this recipe for the first time) : 

```bash
export PROVISIONING_HOME=$HOME/marguerite
mkdir -p $PROVISIONING_HOME
cd $PROVISIONING_HOME
git clone "https://github.com/Jean-Baptiste-Lasselle/meteor-lessons" . 
chmod +x ./operations.sh
./operations.sh
```
_Soit, en une seule ligne (How to execute this recipe for the first time "all-in-one-line")_ : 

```bash
export PROVISIONING_HOME=$HOME/marguerite && mkdir -p $PROVISIONING_HOME && cd $PROVISIONING_HOME && git clone "https://github.com/Jean-Baptiste-Lasselle/meteor-lessons" . && chmod +x ./operations.sh && ./operations.sh
```

_IAAC (After you have sucessfully executed this recipe for the first time, you may go back to initial state with) _ : 

```bash
export PROVISIONING_HOME=$HOME/marguerite && cd $PROVISIONING_HOME && docker-compose down --rmi all && cd $HOME && sudo rm -rf  $PROVISIONING_HOME && mkdir -p $PROVISIONING_HOME && cd $PROVISIONING_HOME && git clone "https://github.com/Jean-Baptiste-Lasselle/meteor-lessons" . && chmod +x ./operations.sh && ./operations.sh
```
_Pre-IAAC (And in case execution never sucessfully reached a first execution of 'docker-compose up' ...) _ :

```bash
export PROVISIONING_HOME=$HOME/marguerite && cd $HOME && sudo rm -rf $PROVISIONING_HOME && sudo docker system prune -f &&  && mkdir -p $PROVISIONING_HOME && cd $PROVISIONING_HOME && git clone "https://github.com/Jean-Baptiste-Lasselle/meteor-lessons" . && chmod +x ./operations.sh && ./operations.sh
```

# Monter un environnment de développement meteor valide
### Petit listing première installation `Meteor` dans un conteneur

![Première installation](https://github.com/Jean-Baptiste-Lasselle/meteor-lessons/raw/master/premiere-installation-meteor-dans-conteneur-docker.png)
Soit, en résultat (et déjà quelques indications pour la suite de la conception de l'environnement de développement) : 
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

Sur la structure qui permet la paramétrisation du stack sous l'IDE : 

```bash
# ---- EXECUTION ---- #
# ++ PRINCIPE : 
# => NIVEAU IMAGE DE CONTENEUR :: On installe NVM, NODEJS, et METEOR, et donc il suffit de changer les variables d'environnement, au docker build, pour changer les versions du stack meteor
# => NIVEAU IMAGE DE CONTENEUR fille :: On créé les projets suivants dans le workspace : on créé le projet meteor , au niveau du ENTRYPOINT aussi
# => NIVEAU ENTRYPOPINT :  on fait le meteor run --port 
# => NIVEAU CMD :  CMD ["/bin/bash"] , aisni l'ide pourra exécuter n'importe quelle commande, en taznt que user linux $MARGUERITE_USER_NAME 

# Le [./point-d-entree.sh] sera toujours exécuté avant la 'CMD', et seule la CMD est surchargée par l'invocation [docker exec ... /chemin/dans/conteneur/vers/executable]
# ADD ./point-d-entree.sh $WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR/point-d-entree.sh
# ENTRYPOINT ["$WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR/point-d-entree.sh"] 
ENTRYPOINT ["meteor", "run", "--port", "$MARGUERITE_METEOR_PORT"]
# CMD ["meteor", "run", "--port", "$MARGUERITE_METEOR_PORT"]
CMD ["/bin/bash"]
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

# Tests à faire pour collègues

## dans un commentaire sur une vidéo tuto youtube

https://www.youtube.com/watch?v=rQX-9WqzchQ&list=PLLnpHn493BHECNl9I8gwos-hEfFrer7TV&index=8


```bash
@LevelUpTuts Hi Scott, just a word with a thank you for your work, which allowed to dive in very quickly into meteor.
When you explain about the "checkboxes", here one thing you may confuse your everyday developer audience : 
I am gonna test it to confirm, but I think that just adding a new "double-brackets variable", with identifier 'checked', in the resolution template definition, in './resolution.html', involved modifying you database logic scheme. Meaning its just as if you had added a new column to an old school SQL-table : when Resolutions.update() is called, it causes a classic persistence transaction, updating in the database, every object in the Resolutions Javascript Collection, by Id, bulk inserting all  "columns" (if there can be columns concept in mongodb collection based storage...) defined in each entry of the Javascript colection.
One question I will find the answer to (with tests), is: say you check 3 of 7 items in the list, and the remaining 4 where inserted without a 'checked' "column". Will then those 4 then have a 'checked' property, with a 'null' value?


Put in other words, Meteor infers Object Relational Mapping Persistence from templates definitions.


Something you have to mention, so that old school developers can match notions between their development world, and Meteor development world.  


I'll be back on those questions, mirroring on github.

```

# ANNEXE : NVM

## Info 1 : de la dépendance au compilateur C++, de l'arrivée des binaires dans les releases NodeJS >= `0.8.6`

source : https://nodesource.com/blog/installing-node-js-tutorial-using-nvm-on-mac-os-x-and-ubuntu/

> 
> Step 1 (Optional): Ensure your system has the appropriate C++ compiler
> 
> In some cases, like when installing Node.js releases from their source or installing versions of Node.js before 0.8.6 (when the project started shipping binaries), you'll need to ensure that your system has the appropriate C++ build tools.
> 
> For LTS and modern releases, you will not need this step. That said, it's a nice to have to ensure that the majority of requirements are met in any scenario.
> 
> On macOS, you've got two options for a C++ compiler: the full XCode application or the stand-alone Command Line Tools portion of Xcode.
> 
> To get these on macOS, you can follow these steps:
> 
>     Open your terminal of choice
>     Run xcode-select --install as a command
>         A popup will appear
>         Select Install
>     Allow the download to run to completion
>     If the installation went uninterrupted, you should have the necessary tools to use nvm!
> 
> On Linux, the C++ compiler will vary from distribution to distribution. For example, on Debian and Ubuntu, you'll need to install build-tools and libssl-dev, but this may be different on your given Linux distribution.
> 
> To get build-tools and libssl-dev on Debuan and Ubuntu distributions, you can run these commands:
> 
> > sudo apt-get install build-essential # Install the build-essential package - let this run to completion
> 
> > sudo apt-get install libssl-dev # Install the libssl-dev package - also let this one run to completion
> 

# ANNEXE : premier build reussit de l'ide

Ci-dessous, ma sortie console pour la construction réussie d'une image docker avec dedans un stack nvm nodejs meteor entièrement paramétrabel en terme de versions, le nom du projet meteor peut-être changé via la variable d'envrionnement `NOM_PROJET_MARGUERITE_METEOR` du service `ide_marguerite` définit dans le `./docker-compose.yml` : 

```bash
# + Installation du Meteor Framework  + #
Removing intermediate container 126bfaedd1c8
 ---> 7c4dc51b58b6
Step 140/176 : RUN echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
 ---> Running in 4c54c364fc9c
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
Removing intermediate container 4c54c364fc9c
 ---> 9cf4b9083c76
Step 141/176 : RUN sh -c "$(curl -sSL https://install.meteor.com/)"
 ---> Running in f18ec4ad2ebe
Downloading Meteor distribution

Meteor 1.8 has been installed in your home directory (~/.meteor).

Now you need to do one of the following:

  (1) Add "$HOME/.meteor" to your path, or
  (2) Run this command as root:
        cp "/home/jbl-devops/.meteor/packages/meteor-tool/1.8.0/mt-os.linux.x86_64/scripts/admin/launch-meteor" /usr/bin/meteor

Then to get started, take a look at 'meteor --help' or see the docs at
docs.meteor.com.
Removing intermediate container f18ec4ad2ebe
 ---> d772f2c7b665
Step 142/176 : USER root
 ---> Running in 794ed080d28e
Removing intermediate container 794ed080d28e
 ---> 19caff125ab2
Step 143/176 : RUN echo "export PATH=\$PATH:\$HOME/.meteor" >> /etc/profile
 ---> Running in 758863d57d64
Removing intermediate container 758863d57d64
 ---> 91a5747f225f
Step 144/176 : USER $MARGUERITE_USER_NAME
 ---> Running in 9e8756e707d8
Removing intermediate container 9e8756e707d8
 ---> 8e60babdd2c3
Step 145/176 : RUN echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
 ---> Running in 5254f3331191
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
Removing intermediate container 5254f3331191
 ---> ff1cc1497dd2
Step 146/176 : RUN echo "# + Création du projet Meteor de l'utilisateur Marguerite        + #"
 ---> Running in 9a03f74125de
# + Création du projet Meteor de l'utilisateur Marguerite        + #
Removing intermediate container 9a03f74125de
 ---> ddf84041eacc
Step 147/176 : RUN echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
 ---> Running in f4341e86d304
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
Removing intermediate container f4341e86d304
 ---> 584922827611
Step 148/176 : RUN echo " Qui suis-je ? $(whoami)"
 ---> Running in 994dc6326cd1
 Qui suis-je ? jbl-devops
Removing intermediate container 994dc6326cd1
 ---> 4b5cf9e0f766
Step 149/176 : RUN echo " ----------------------------------------------------------------------------------------------------------- "
 ---> Running in 3eb22b03ad48
 ----------------------------------------------------------------------------------------------------------- 
Removing intermediate container 3eb22b03ad48
 ---> 1df178da0434
Step 150/176 : RUN echo " Vérification valeurs variables d'environnement :  "
 ---> Running in 34141075acf8
 Vérification valeurs variables d'environnement :  
Removing intermediate container 34141075acf8
 ---> c22a3765b025
Step 151/176 : RUN echo " ----------------------------------------------------------------------------------------------------------- "
 ---> Running in 5bd2bb6e9d54
 ----------------------------------------------------------------------------------------------------------- 
Removing intermediate container 5bd2bb6e9d54
 ---> 7259749174a1
Step 152/176 : RUN echo " MARGUERITE_USER_NAME=$MARGUERITE_USER_NAME "
 ---> Running in 1557b8d4e401
 MARGUERITE_USER_NAME=jbl-devops 
Removing intermediate container 1557b8d4e401
 ---> 666ccd4fcafc
Step 153/176 : RUN echo "  "
 ---> Running in 1148ced35835
  
Removing intermediate container 1148ced35835
 ---> 692adb988d50
Step 154/176 : RUN echo " WORKSPACE_IDE=$WORKSPACE_IDE "
 ---> Running in 6020f1a132e0
 WORKSPACE_IDE=/marguerite/ide/esp-travail/ 
Removing intermediate container 6020f1a132e0
 ---> 2348bfab21b5
Step 155/176 : RUN echo "  "
 ---> Running in 36b056fb325b
  
Removing intermediate container 36b056fb325b
 ---> c5b9e2b0e762
Step 156/176 : RUN echo " NOM_PROJET_MARGUERITE_METEOR=$NOM_PROJET_MARGUERITE_METEOR "
 ---> Running in 48ac91d3e273
 NOM_PROJET_MARGUERITE_METEOR=jbl-devops-projet-meteor 
Removing intermediate container 48ac91d3e273
 ---> ec494fff6232
Step 157/176 : RUN echo "  "
 ---> Running in 8ecc04d595c1
  
Removing intermediate container 8ecc04d595c1
 ---> 5b266f919940
Step 158/176 : RUN echo " MARGUERITE_METEOR_PORT=$MARGUERITE_METEOR_PORT "
 ---> Running in 3d8319491b7f
 MARGUERITE_METEOR_PORT=4000 
Removing intermediate container 3d8319491b7f
 ---> 6bb921b31129
Step 159/176 : RUN echo "  "
 ---> Running in 9fee2ed2b2c5
  
Removing intermediate container 9fee2ed2b2c5
 ---> 9e5899c5fbdb
Step 160/176 : RUN echo " MARGUERITE_METEOR_NODE_OPTIONS=$MARGUERITE_METEOR_NODE_OPTIONS "
 ---> Running in 10f18aa522fa
 MARGUERITE_METEOR_NODE_OPTIONS= 
Removing intermediate container 10f18aa522fa
 ---> 64675e0926ba
Step 161/176 : RUN echo "  "
 ---> Running in b384504b106d
  
Removing intermediate container b384504b106d
 ---> 15239268067b
Step 162/176 : RUN echo " \$WORKSPACE_IDE/\$NOM_PROJET_MARGUERITE_METEOR=$WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR "
 ---> Running in e2c21eb4b7b6
 $WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR=/marguerite/ide/esp-travail//jbl-devops-projet-meteor 
Removing intermediate container e2c21eb4b7b6
 ---> 7d933c3987cf
Step 163/176 : RUN echo " ----------------------------------------------------------------------------------------------------------- "
 ---> Running in 0e3dc704bbcd
 ----------------------------------------------------------------------------------------------------------- 
Removing intermediate container 0e3dc704bbcd
 ---> ebe9516d07db
Step 164/176 : WORKDIR $WORKSPACE_IDE
 ---> Running in 99dcb9b3991d
Removing intermediate container 99dcb9b3991d
 ---> f70b61179358
Step 165/176 : RUN echo " ----------------------------------------------------------------------------------------------------------- "
 ---> Running in 3ca65b7f2364
 ----------------------------------------------------------------------------------------------------------- 
Removing intermediate container 3ca65b7f2364
 ---> 2745e139c73d
Step 166/176 : RUN echo " Vérification version Framework Meteor :  "
 ---> Running in fa7c8553478a
 Vérification version Framework Meteor :  
Removing intermediate container fa7c8553478a
 ---> fc73103de51b
Step 167/176 : RUN echo " ----------------------------------------------------------------------------------------------------------- "
 ---> Running in f092bd0a6c48
 ----------------------------------------------------------------------------------------------------------- 
Removing intermediate container f092bd0a6c48
 ---> 683db9304928
Step 168/176 : RUN export PATH=$PATH:$HOME/.meteor && meteor --version
 ---> Running in 3f27f8baef2c
Meteor 1.8
Removing intermediate container 3f27f8baef2c
 ---> 8e6e13c565b3
Step 169/176 : RUN echo " ----------------------------------------------------------------------------------------------------------- "
 ---> Running in fc7bb5c11ad3
 ----------------------------------------------------------------------------------------------------------- 
Removing intermediate container fc7bb5c11ad3
 ---> a17c9b9dcc91
Step 170/176 : RUN echo " Création du projet Meteor [$NOM_PROJET_MARGUERITE_METEOR] :  "
 ---> Running in aa10eeb1bf14
 Création du projet Meteor [jbl-devops-projet-meteor] :  
Removing intermediate container aa10eeb1bf14
 ---> 997b405d45a4
Step 171/176 : RUN echo " ----------------------------------------------------------------------------------------------------------- "
 ---> Running in 735546ae422f
 ----------------------------------------------------------------------------------------------------------- 
Removing intermediate container 735546ae422f
 ---> d255e0e811e1
Step 172/176 : RUN export PATH="$PATH:$HOME/.meteor" && echo " VERIF PATH=[$PATH] " && meteor create $NOM_PROJET_MARGUERITE_METEOR
 ---> Running in 3e95e4efe8cb
 VERIF PATH=[/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/jbl-devops/.meteor] 
Created a new Meteor app in 'jbl-devops-projet-meteor'.

To run your new app:
  cd jbl-devops-projet-meteor
  meteor

If you are new to Meteor, try some of the learning resources here:
  https://www.meteor.com/tutorials

To start with a different app template, try one of the following:

  meteor create --bare    # to create an empty app

  meteor create --minimal # to create an app with as few Meteor packages as possible
  meteor create --full    # to create a more complete scaffolded app
  meteor create --react   # to create a basic React-based app

Removing intermediate container 3e95e4efe8cb
 ---> 1b5c0cda3690
Step 173/176 : WORKDIR $WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR
 ---> Running in 61e353955f46
Removing intermediate container 61e353955f46
 ---> c598e968e7b2
Step 174/176 : EXPOSE $MARGUERITE_METEOR_PORT/tcp
 ---> Running in faadf03008bf
Removing intermediate container faadf03008bf
 ---> 150dbf6844a4
Step 175/176 : ENTRYPOINT ["$WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR/point-d-entree.sh"]
 ---> Running in 64606b125709
Removing intermediate container 64606b125709
 ---> ca59b482338a
Step 176/176 : CMD ["/bin/bash"]
 ---> Running in c3bd8c9f6259
Removing intermediate container c3bd8c9f6259
 ---> 4c3147ec29a9
Successfully built 4c3147ec29a9
Successfully tagged marguerite/stack-meteor:1.0.0

```
