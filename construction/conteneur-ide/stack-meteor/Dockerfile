FROM centos:7
# Labels éditeur

# ARG / ENV : ici, on aura que des "ARGS", car on veut fixer les 
# versions de NVM, NODEJS, et METEOR, dans le même conteneur : 
# on ne veut pas pouvoir changer de version de meteor au run, sinon il fautdrait une installation, ou alors pourquoi pas un ENTRYPOINT, les CMD étant topujours ajoutés au ENTRYPOINT...
ARG VERSION_NVM=1.0.0
ENV VERSION_NVM=$VERSION_NVM

ARG DERNIRE_VERSION_NVM=0.33.10
ENV DERNIRE_VERSION_NVM=DERNIRE_VERSION_NVM

ARG AVANT_DERNIRE_VERSION_NVM=0.33.11
ENV AVANT_DERNIRE_VERSION_NVM=$AVANT_DERNIRE_VERSION_NVM

ARG VERSION_NODEJS=1.0.0
ENV VERSION_NODEJS=$VERSION_NODEJS

ARG VERSION_METEOR_FRAMEWORK=1.0.0
ENV VERSION_METEOR_FRAMEWORK=$VERSION_METEOR_FRAMEWORK


# --- MARGUERITE --- #

# -->> Le développeur, l'architecte, le devops ... devra correspondre à son user linux dans l'hote Docker?
ARG MARGUERITE_USER_NAME=jbl-devops
ENV MARGUERITE_USER_NAME=$MARGUERITE_USER_NAME

ARG MARGUERITE_USER_PWD=marguerite
ENV MARGUERITE_USER_PWD=$MARGUERITE_USER_PWD

ARG WORKSPACE_IDE=/home/$MARGUERITE_USER_NAME/marguerite/ide/esp-travail/
ENV WORKSPACE_IDE=$WORKSPACE_IDE

ARG NOM_PROJET_MARGUERITE_METEOR=$MARGUERITE_USER_NAME-projet-meteor
ENV NOM_PROJET_MARGUERITE_METEOR=$NOM_PROJET_MARGUERITE_METEOR

ARG CHEMIN_PROJET_MARGUERITE_METEOR=$WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR
ENV CHEMIN_PROJET_MARGUERITE_METEOR=$CHEMIN_PROJET_MARGUERITE_METEOR

# ---- MARGUERITE / METEOR CONF ---- #
# > You can use the application by pointing your web browser at localhost:3000. No Internet connection is required.
# > This is the default command. Simply running meteor is the same as meteor run.
# > To pass additional options to Node.js use the NODE_OPTIONS environment variable. For example: NODE_OPTIONS='--debug' or NODE_OPTIONS='--debug-brk'
# > To specify a port to listen on (instead of the default 3000), use --port [PORT]. (The development server also uses port N+1 for the default MongoDB instance)
# > For example: meteor run --port 4000 will run the development server on http://localhost:4000 and the development MongoDB instance on mongodb://localhost:4001.
# > Run meteor help run to see the full list of options.

ARG MARGUERITE_METEOR_PORT=4000
ENV MARGUERITE_METEOR_PORT=$MARGUERITE_METEOR_PORT

# NODE_OPTIONS='--debug --debug-brk'
# ARG MARGUERITE_METEOR_NODE_OPTIONS='--debug --debug-brk'
ARG MARGUERITE_METEOR_NODE_OPTIONS="--debug --debug-brk"
ENV MARGUERITE_METEOR_NODE_OPTIONS=$MARGUERITE_METEOR_NODE_OPTIONS
# Ainsi la variable d'envrionnement existera àau lancement du cotneneur, et définira la valeur de NODE_OPTIONS, à l'exécution meteor run
ENV NODE_OPTIONS=$MARGUERITE_METEOR_NODE_OPTIONS

# ---- MARGUERITE MONGO CONF ---- # 
# cf. dans le fichier ["./.env"], la valeur de la variable [NOM_DU_REPLICASET_MONGO]
ARG NOM_DU_REPLICASET_MONGO=val_defaut_dans_conteneur_rs0
ENV NOM_DU_REPLICASET_MONGO=$NOM_DU_REPLICASET_MONGO

# ---- OPS ---- #
USER root
RUN echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
RUN echo "# + BUILD IMAGE MARGUERITE METEOR STACK                          + #"
RUN echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
# Boîte à outils système
RUN yum update -y && yum install -y curl wget net-tools vim git

RUN echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
RUN echo "# + Création de l'utilisateur Linux Marguerite                   + #"
RUN echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

# quietly add a user without password
# RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/newuser --gecos "User" $MARGUERITE_USER_NAME
# Step 37/125 : RUN adduser --quiet --disabled-password --shell /bin/sh --home /home/$MARGUERITE_USER_NAME --gecos "User" $MARGUERITE_USER_NAME
#  ---> Running in 6c1abdc30079
# useradd: unrecognized option '--quiet'
# useradd: unrecognized option '--disabled-password'
# useradd: unrecognized option '--gecos'
# RUN adduser --quiet --disabled-password --shell /bin/sh --home /home/$MARGUERITE_USER_NAME --gecos "User" $MARGUERITE_USER_NAME
RUN useradd --shell /bin/sh --home /home/$MARGUERITE_USER_NAME $MARGUERITE_USER_NAME

# set password
RUN echo "$MARGUERITE_USER_NAME:$MARGUERITE_USER_PWD" | chpasswd
# Et on fait de l'utilisateur $MARGUERITE_USER_NAME, un administrateur (aura le droit d'utiliser sudo?...).
# Pour CentOS le groupe "sudo"  n'existe pas, mais c'est le groupe "wheel" qui existe, et qu'il faut utiliser
ARG SUODERS_SYSTEM_GROUP=wheel
ENV SUODERS_SYSTEM_GROUP=wheel


RUN usermod -aG $SUODERS_SYSTEM_GROUP $MARGUERITE_USER_NAME
# Pour Debian / Ubuntu le groupe "wheel"  n'existe pas, mais c'est le groupe "sudo" qui existe, et qu'il faut utiliser
# RUN usermod -aG sudo $MARGUERITE_USER_NAME

USER $MARGUERITE_USER_NAME

RUN echo " "
RUN echo " Vérif existence répertoire home du user"
RUN echo " "
RUN echo " Qui suis-je ? $(whoami)"
RUN echo " Ma maison est : [$HOME]"
RUN ls -all $HOME
RUN echo " "

# On doit reprende le user root pour le reste du build de l'image du conteneur, le USER marguerite sera repris pour le RUN
USER root
# eh ben non, je vais essayer de continuer avec le user marguerite.... Quoi que ...


RUN echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
RUN echo "# + Création du workspace IDE Marguerite                         + #"
RUN echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
RUN mkdir -p $WORKSPACE_IDE
# Le workspace doit appartenir au user marguerite.
RUN chown -R $MARGUERITE_USER_NAME:$SUODERS_SYSTEM_GROUP $WORKSPACE_IDE

RUN echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
RUN echo "# + Installation de NodeJS / NVM, pour gérer les versions NodeJS + #"
RUN echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"

# 1. On récupère les dernières versions de NVM
RUN export HORODATAGE_OPS=$(date '+%Y-%m-%dday_%Hh-%Mmin-%Ssec')
# On récupère d'abord la liste exhaustive des versions de NVM, soit les tags du repo ofiicle NVM.
RUN git ls-remote --tags https://github.com/creationix/nvm| grep -v {|awk -F / '{print $3}'|awk -F ^ '{print $1}' >> liste-versions-avec-v.kytes

# On se débarasse des métadonnées pour ne garder par ligne, que le strict numéro de version, préfixé de la lettre "v" (les tags du repo officiel NVM sont ainsi préfixés...) :  
RUN while read iterateur; do   iterateur=${iterateur#"v"} ; echo "$iterateur" >> ./liste-versions-NVM-a-trier-$HORODATAGE_OPS.kytes; done <./liste-versions-avec-v.kytes 
# À ce stade, on a généré un fichier qui contient la liste de toutes les versions de NVM, en syntaxe semver.
# On va donc maintenant trier cette liste, pour en retirer la dernière et l'avant dernière entrée : 
RUN export DERNIRE_VERSION_NVM=$(sort --version-sort ./liste-versions-NVM-a-trier-$HORODATAGE_OPS.kytes | tail -n 1 | head -n 1) && echo "La dernière version de NVM est : [$DERNIRE_VERSION_NVM] "
RUN export AVANT_DERNIRE_VERSION_NVM=$(sort --version-sort ./liste-versions-NVM-a-trier-$HORODATAGE_OPS.kytes | tail -n 2 | head -n 1) && echo "La dernière version de NVM est : [$AVANT_DERNIRE_VERSION_NVM] "
RUN echo " ----------------------------------------------------------------------------------------------------------- "
RUN echo "Les 5 dernières dernières versions de NVM sont : "
RUN echo " ----------------------------------------------------------------------------------------------------------- "
RUN sort --version-sort ./liste-versions-NVM-a-trier-$HORODATAGE_OPS.kytes | tail -n 5
RUN echo " ----------------------------------------------------------------------------------------------------------- "
# Maintenant, on va installer NVM dans son avant dernière version (petite habitude d'ingénierie, l'avant dernière a tout de même une maturité, la denrière est trop jeune)
# curl "https://raw.githubusercontent.com/creationix/nvm/v$AVANT_DERNIRE_VERSION_NVM/install.sh" | bash
# + sécurisé : 
RUN echo " ----------------------------------------------------------------------------------------------------------- "
RUN echo " Installation de NVM ... "
RUN echo " ----------------------------------------------------------------------------------------------------------- "
RUN touch ~/.bash_profile
# un fichier "~/.bash_profile" doit exister dans le $HOME du user marguerite
RUN sh -c "$(curl -sSL https://raw.githubusercontent.com/creationix/nvm/v$AVANT_DERNIRE_VERSION_NVM/install.sh)"
RUN echo " ----------------------------------------------------------------------------------------------------------- "
#  ----------------------------------------------------------------------------------------------------------- 
# Removing intermediate container 38600010f680
#  ---> 19193a808cbe
# Step 72/125 : RUN sh -c "$(curl -sSL https://raw.githubusercontent.com/creationix/nvm/v$AVANT_DERNIRE_VERSION_NVM/install.sh)"
#  ---> Running in dc885e661322
# => Downloading nvm from git to '/root/.nvm'
# => Cloning into '/root/.nvm'...
# => Compressing and cleaning up git repository
# 
# => Appending nvm source string to /root/.bashrc
# => Appending bash_completion source string to /root/.bashrc
# => Close and reopen your terminal to start using nvm or run the following to use it now:
# 
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# 
# ++ Bon, eh ben on s'exécute : 
# RUN export NVM_DIR="$HOME/.nvm"
# ARG NVM_DIR="/home/$MARGUERITE_USER_NAME/.nvm"
ARG NVM_DIR=/root/.nvm
ENV NVM_DIR=/root/.nvm
RUN echo " ----------------------------------------------------------------------------------------------------------- "
RUN echo " Verif \$HOME/.nvm=[$HOME/.nvm] "
RUN echo " ----------------------------------------------------------------------------------------------------------- "
RUN echo " Verif NVM_DIR=[$NVM_DIR] "
RUN ls -all $NVM_DIR
RUN echo " ----------------------------------------------------------------------------------------------------------- "

# Configuration du profil NVM par défaut de tous les users 
RUN echo "  " 
RUN echo " Verifcation conteneur \$HOME = $HOME "
RUN echo "  " 
RUN ls -all $HOME
RUN echo "  " 
RUN echo "  " 
RUN echo "  " 
RUN touch /etc/profile
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
RUN echo " " >> /etc/profile
RUN echo "# +++++++++++++++++++++++++++++++++++++++++ #" >> /etc/profile
RUN echo "# ++ Configuration Marguerite Meteor IDE ++ #" >> /etc/profile
RUN echo "# +++++++++++++++++++++++++++++++++++++++++ #" >> /etc/profile
RUN echo "[ -s \"$NVM_DIR/nvm.sh\" ] && \\. \"$NVM_DIR/nvm.sh\" # This loads nvm" >> /etc/profile
RUN echo "[ -s \"$NVM_DIR/bash_completion\" ] && \\. \"$NVM_DIR/bash_completion\" # This loads nvm bash_completion"  >> /etc/profile
RUN echo "# Chargement de NVM, pour l'exécution du build de l'image docker"
RUN [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
RUN [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
RUN [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


RUN echo " ----------------------------------------------------------------------------------------------------------- "
RUN echo "Version de NVM installée : "
RUN echo " ----------------------------------------------------------------------------------------------------------- "
RUN $NVM_DIR/nvm --version
RUN echo " ----------------------------------------------------------------------------------------------------------- "

RUN echo " ----------------------------------------------------------------------------------------------------------- "
RUN echo " Installation de NodeJS, en dernière version LTS ... "
RUN echo " - NodeJS est par défaut installé dans sa version LTS la plus récente.  "
RUN echo " - Puis, si la variable d'environnement \$VERSION_NODEJS : "
RUN echo "       => est définie,  "
RUN echo "       => d'une valeur valide, c-a-d églae à l'une des valeurs de la liste des versions NodeJS existante, ou parmi { 'lts', 'latest' } "
RUN echo "       => et que sa valeur est différente de 'lts' "
# 
RUN echo "   Alors, la version spécififée par Puis, si la variable d'environnement \$VERSION_NODEJS : est définie, d'une valeur valide, et différente de \"lts\" "
RUN echo " Ce comportement n'est pas encore implémenté, pour l'instant c'est toujours la dernière version LTS qui est installée. "
RUN echo " ----------------------------------------------------------------------------------------------------------- "
#     Install the latest version with 'nvm install node'
#     Use the latest version with 'nvm use node'
#     Install the latest LTS version with 'nvm install --lts'
#     Use the latest LTS verison with 'nvm use --lts'
RUN nvm install --lts
RUN nvm use --lts
RUN echo "Version de NodeJS en vigueur : "
RUN echo " ----------------------------------------------------------------------------------------------------------- "
RUN node --version
RUN echo " ----------------------------------------------------------------------------------------------------------- "
RUN echo "  "

# ++ Vérification valeurs variables d'environnement : 

RUN echo " ----------------------------------------------------------------------------------------------------------- "
RUN echo " Vérification valeurs variables d'environnement :  "
RUN echo " ----------------------------------------------------------------------------------------------------------- "
RUN echo " MARGUERITE_USER_NAME=$MARGUERITE_USER_NAME "
RUN echo "  "
RUN echo " WORKSPACE_IDE=$WORKSPACE_IDE "
RUN echo "  "
RUN echo " NOM_PROJET_MARGUERITE_METEOR=$NOM_PROJET_MARGUERITE_METEOR "
RUN echo "  "
RUN echo " MARGUERITE_METEOR_PORT=$MARGUERITE_METEOR_PORT "
RUN echo "  "
RUN echo " MARGUERITE_METEOR_NODE_OPTIONS=$MARGUERITE_METEOR_NODE_OPTIONS "
RUN echo "  "
RUN echo " \$WORKSPACE_IDE/\$NOM_PROJET_MARGUERITE_METEOR=$WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR "
RUN echo " ----------------------------------------------------------------------------------------------------------- "
USER $MARGUERITE_USER_NAME
RUN echo " Qui suis-je ? $(whoami)"
RUN echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
RUN echo "# + Installation du Meteor Framework, version [$VERSION_METEOR_FRAMEWORK] + #"
RUN echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# + Installation de Meteor + #
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# 
# 
# curl https://install.meteor.com/ | sh
RUN sh -c "$(curl -sSL https://install.meteor.com/)"
RUN meteor --version
RUN echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
RUN echo "# + Création du projet Meteor Marguerite                         + #"
RUN echo "# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #"
WORKDIR $WORKSPACE_IDE
RUN meteor create $NOM_PROJET_MARGUERITE_METEOR
WORKDIR $WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR

EXPOSE $MARGUERITE_METEOR_PORT/tcp
# ---- EXECUTION ---- #
# ++ PRINCIPE : 
# => NIVEAU IMAGE DE CONTENEUR STACK-METEOR :: On installe NVM, NODEJS, et METEOR, et donc il suffit de changer les variables d'environnement, au docker build, pour changer les versions du stack meteor
# => NIVEAU IMAGE DE CONTENEUR fille :: On créé les projets suivants dans le workspace : on créé le projet meteor , au niveau du ENTRYPOINT aussi
# => NIVEAU ENTRYPOPINT :  on fait le meteor run --port 
# => NIVEAU CMD :  CMD ["/bin/bash"] , aisni l'ide pourra exécuter n'importe quelle commande, en taznt que user linux $MARGUERITE_USER_NAME 

# Le [./point-d-entree.sh] sera toujours exécuté avant la 'CMD', et seule la CMD est surchargée par l'invocation [docker exec ... /chemin/dans/conteneur/vers/executable]
ADD point-d-entree.sh $WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR/point-d-entree.sh
ENTRYPOINT ["$WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR/point-d-entree.sh"] 
# ENTRYPOINT ["meteor", "run", "--port", "$MARGUERITE_METEOR_PORT"]
# CMD ["meteor", "run", "--port", "$MARGUERITE_METEOR_PORT"]
CMD ["/bin/bash"]
