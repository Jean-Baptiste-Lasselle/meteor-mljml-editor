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


# Boîte à outils système
RUN yum update -y && yum install -y curl wget net-tools vim git

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# + Installation de NodeJS / NVM, pour gérer les versions NodeJS + #
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# 

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
RUN echo "Les 5 dernières dernières versions de NVM sont : "
RUN sort --version-sort ./liste-versions-NVM-a-trier-$HORODATAGE_OPS.kytes | tail -n 5

# Maintenant, on va installer NVM dans son avant dernière version (petite habitude d'ingénierie, l'avant dernière a tout de même une maturité, la denrière est trop jeune)
# curl "https://raw.githubusercontent.com/creationix/nvm/v$AVANT_DERNIRE_VERSION_NVM/install.sh" | bash
# + sécurisé : 
sh -c "$(curl -sSL https://raw.githubusercontent.com/creationix/nvm/v$AVANT_DERNIRE_VERSION_NVM/install.sh)"


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# + Installation de Meteor + #
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# 
# 
# curl https://install.meteor.com/ | sh
sh -c "$(curl -sSL https://install.meteor.com/)"
