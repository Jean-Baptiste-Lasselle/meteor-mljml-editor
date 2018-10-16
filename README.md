
# Utilisation

## Provision et Initialisation du cycle IAAC

Pour exécuter cette recette une première fois : 

```bash
export PROVISIONING_HOME=$HOME/marguerite
mkdir -p $PROVISIONING_HOME
cd $PROVISIONING_HOME
git clone "https://github.com/Jean-Baptiste-Lasselle/meteor-lessons" . 
chmod +x ./operations.sh
./operations.sh
```
_Soit, en une seule ligne_ : 

```bash
export PROVISIONING_HOME=$HOME/marguerite && mkdir -p $PROVISIONING_HOME && cd $PROVISIONING_HOME && git clone "https://github.com/Jean-Baptiste-Lasselle/meteor-lessons" . && chmod +x ./operations.sh && ./operations.sh
```

_IAAC_ : 

```bash
export PROVISIONING_HOME=$HOME/marguerite && cd $PROVISIONING_HOME && docker-compose down --rmi all && cd $HOME && sudo rm -rf  $PROVISIONING_HOME && mkdir -p $PROVISIONING_HOME && cd $PROVISIONING_HOME && git clone "https://github.com/Jean-Baptiste-Lasselle/meteor-lessons" . && chmod +x ./operations.sh && ./operations.sh
```
_Pre-IAAC_ :

```bash
cd .. && sudo rm -rf marguerite/ && sudo docker system prune -f && export PROVISIONING_HOME=$HOME/marguerite && mkdir -p $PROVISIONING_HOME && cd $PROVISIONING_HOME && git clone "https://github.com/Jean-Baptiste-Lasselle/meteor-lessons" . && chmod +x ./operations.sh && ./operations.sh
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
