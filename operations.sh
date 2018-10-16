#!/bin/bash
# -------------------------------------------------------------------------------------------------------------------
# - ["./.env"] :
# -------------------------------------------------------------------------------------------------------------------
# IN_CONTAINER_WORKSPACE_IDE=/marguerite/ide
# MARGUERITE_METEOR_PORT=6000
# MARGUERITE_METEOR_NODE_OPTIONS="--debug --debug-brk"
# NOM_CONTENEUR_IDE_MARGUERITE=ide_meteor_marguerite
# MARGUERITE_USER_NAME=jbl-devops
# MARGUERITE_USER_PWD=marguerite
# NOM_DU_RESEAU_MARGUERITE_DOCKER=marguerite-netdevops
# -------------------------------------------------------------------------------------------------------------------
# - ENV 
# -------------------------------------------------------------------------------------------------------------------
export NOM_CONTENEUR_IDE_MARGUERITE=ide-marguerite

export MARGUERITE_USER_NAME=jbl-devops
export MARGUERITE_USER_PWD=marguerite

export ALIAS_INFRA=marguerite

# -------------------------------------------------------------------------------------------------------------------
# - Fonctions
# -------------------------------------------------------------------------------------------------------------------
# 
# Cette fonction permet d'attendre que le conteneur soit dans l'état healthy
# Cette fonction prend un argument, nécessaire sinon une erreur est générée (TODO: à implémenter avec exit code)
checkHealth () {
	export ETATCOURANTCONTENEUR=starting
	export ETATCONTENEURPRET=healthy
	export NOM_DU_CONTENEUR_INSPECTE=$1
	
	while  $(echo "+provision+$ALIAS_INFRA+ $NOM_DU_CONTENEUR_INSPECTE - HEALTHCHECK: [$ETATCOURANTCONTENEUR]" >> ./check-health.coquelicot); do
	
	ETATCOURANTCONTENEUR=$(sudo docker inspect -f '{{json .State.Health.Status}}' $NOM_DU_CONTENEUR_INSPECTE)
	if [ $ETATCOURANTCONTENEUR == "\"healthy\"" ]
	then
		echo "+provision+$ALIAS_INFRA+ $NOM_DU_CONTENEUR_INSPECTE est prêt - HEALTHCHECK: [$ETATCOURANTCONTENEUR]"
		break;
	else
		echo "+provision+$ALIAS_INFRA+ $NOM_DU_CONTENEUR_INSPECTE n'est pas prêt - HEALTHCHECK: [$ETATCOURANTCONTENEUR] - attente d'une seconde avant prochain HealthCheck - "
		sleep 1s
	fi
	done
	rm -f ./check-health.coquelicot
	# DEBUG LOGS
	echo " provision-$ALIAS_INFRA-  ------------------------------------------------------------------------------ " 
	echo " provision-$ALIAS_INFRA-  ------------------------------------------------------------------------------ " 
}

# - OPS 

# 1. Il faut construire lm'image de base du STACK MARGUERITE / METEOR
# !! => Il y a un match avec les valeurs des mêmes variables d'envrionnement, dans le ficheir "./.env"
export CONTEXTE_DOCKER_BUILD_STACK_MARGUERITE_METEOR=./construction/conteneur-ide/stack-meteor/
# export IMAGE_MARGUERITE_STACK_METEOR_COMPANY_NAME=marguerite/
export IMAGES_MARGUERITE_COMPANY_NAME=marguerite/

# L'image du conteneur définie dans './construction/conteneur-ide/stack-meteor/Dockerfile', mère
# de l'image du runtime meteor de l'ide marguerite 
export IMAGE_MARGUERITE_STACK_METEOR_PRODUCT_NAME=meteor-stack
# L'image du conteneur définie dans './construction/conteneur-ide/Dockerfile', fille 
# de l'image définie dans './construction/conteneur-ide/stack-meteor/Dockerfile'
export IMAGE_MARGUERITE_IDE_METEOR_PRODUCT_NAME=meteor-ide
export VERSION_IMAGE_MARGUERITE_IDE_METEOR=1.0.0
export VERSION_IMAGE_MARGUERITE_STACK_METEOR=1.0.0



# export UTILISATEUR_HUBOT_ROCKETCHAT_USERNAME=$(cat ./docker-compose.yml|grep ROCKETCHAT_USER | awk -F = '{print $2}')
# export UTILISATEUR_HUBOT_ROCKETCHAT_PWD=$(cat ./docker-compose.yml|grep ROCKETCHAT_PASSWORD | awk -F = '{print $2}')

# Depuis l'utiliation du fichier de variables globales [.env]
export MARGUERITE_USER_NAME=$(cat ./.env|grep MARGUERITE_USER_NAME | awk -F = '{print $2}')
export MARGUERITE_USER_PWD=$(cat ./.env|grep MARGUERITE_USER_PWD | awk -F = '{print $2}')


export NOM_CONTENEUR_IDE_MARGUERITE=$(cat ./.env|grep NOM_CONTENEUR_IDE_MARGUERITE | awk -F = '{print $2}')
export CONTEXTE_DOCKER_BUILD_STACK_MARGUERITE_METEOR=$(cat ./.env|grep CONTEXTE_DOCKER_BUILD_STACK_MARGUERITE_METEOR | awk -F = '{print $2}')
export IMAGES_MARGUERITE_COMPANY_NAME=$(cat ./.env|grep IMAGES_MARGUERITE_COMPANY_NAME | awk -F = '{print $2}')
export IMAGE_MARGUERITE_STACK_METEOR_PRODUCT_NAME=$(cat ./.env|grep IMAGE_MARGUERITE_STACK_METEOR_PRODUCT_NAME | awk -F = '{print $2}')
export VERSION_IMAGE_MARGUERITE_STACK_METEOR=$(cat ./.env|grep VERSION_IMAGE_MARGUERITE_STACK_METEOR | awk -F = '{print $2}')
export IMAGE_MARGUERITE_IDE_METEOR_PRODUCT_NAME=$(cat ./.env|grep IMAGE_MARGUERITE_IDE_METEOR_PRODUCT_NAME | awk -F = '{print $2}')
export VERSION_IMAGE_MARGUERITE_IDE_METEOR=$(cat ./.env|grep VERSION_IMAGE_MARGUERITE_IDE_METEOR | awk -F = '{print $2}')


# Sauf celles-ci, qui sont calculées dans le flot de l'exécution shell
export ID_IMAGE_MARGUERITE_STACK_METEOR=$IMAGES_MARGUERITE_COMPANY_NAME/$IMAGE_MARGUERITE_STACK_METEOR_PRODUCT_NAME:$VERSION_IMAGE_MARGUERITE_STACK_METEOR
export ID_IMAGE_MARGUERITE_IDE_METEOR=$IMAGE_MARGUERITE_IDE_METEOR_PRODUCT_NAME/$IMAGE_MARGUERITE_STACK_METEOR_PRODUCT_NAME:$VERSION_IMAGE_MARGUERITE_IDE_METEOR

echo "  "
echo " ---------------------------------------------------------------------- "
echo "  AVANT DOCKER BUILD STACK METEOR : "
echo " ---------------------------------------------------------------------- "
echo "  "
echo "    MARGUERITE_USER_NAME=$MARGUERITE_USER_NAME"
echo "  "
echo "    MARGUERITE_USER_PWD=$MARGUERITE_USER_PWD"
echo "  "
echo "    CONTEXTE_DOCKER_BUILD_STACK_MARGUERITE_METEOR=$CONTEXTE_DOCKER_BUILD_STACK_MARGUERITE_METEOR"
echo "  "
echo "    IMAGES_MARGUERITE_COMPANY_NAME=$IMAGES_MARGUERITE_COMPANY_NAME"
echo "  "
echo "    IMAGE_MARGUERITE_STACK_METEOR_PRODUCT_NAME=$IMAGE_MARGUERITE_STACK_METEOR_PRODUCT_NAME"
echo "  "
echo "    VERSION_IMAGE_MARGUERITE_STACK_METEOR=$VERSION_IMAGE_MARGUERITE_STACK_METEOR"
echo "  "
echo "    ID_IMAGE_MARGUERITE_STACK_METEOR=$ID_IMAGE_MARGUERITE_STACK_METEOR"
echo "  "
echo "    docker impages  : "
echo "  "
docker images
echo "  "
echo " ---------------------------------------------------------------------- "
echo "  "
read DEBUGJBL1
echo "  "
echo "  "
echo "  "
docker rmi --force $ID_IMAGE_MARGUERITE_STACK_METEOR
docker rmi --force $ID_IMAGE_MARGUERITE_IDE_METEOR

marguerite/meteor-ide                  1.0.0               c1738e033440        11 minutes ago      1.9GB
marguerite/meteor-stac
echo "  "
echo " ---------------------------------------------------------------------- "
echo "  "
read DEBUGJBLRMI
docker build -t $ID_IMAGE_MARGUERITE_STACK_METEOR -f $CONTEXTE_DOCKER_BUILD_STACK_MARGUERITE_METEOR/Dockerfile $CONTEXTE_DOCKER_BUILD_STACK_MARGUERITE_METEOR
# - Je récupère, dans le fichier 'docker-compose.yml', les valeurs de configuration pour le username et le password
echo "  "
echo " ---------------------------------------------------------------------- "
echo "  APRES DOCKER BUILD STACK METEOR : "
echo " ---------------------------------------------------------------------- "
echo "  "
echo "    ID_IMAGE_MARGUERITE_STACK_METEOR=$ID_IMAGE_MARGUERITE_STACK_METEOR"
echo "  "
echo "    docker impages  : "
echo "  "
docker images
echo "  "
echo " ---------------------------------------------------------------------- "
echo "  "
read DEBUGJBL2
echo "  "
echo "  "
echo "  "

# - Je rends exécutables les scripts invoqués dans la présente recette
chmod +x ./initialisation-iaac-cible-deploiement.sh
# J'initialise tout de suite la cible de déploiement
./initialisation-iaac-cible-deploiement.sh



echo "  "
echo " ---------------------------------------------------------------------- "
echo "  INIITALISATION IAAC TERMINEE : "
echo " ---------------------------------------------------------------------- "
echo "  "
docker images
echo "  "
echo " ---------------------------------------------------------------------- "
echo "  Mettez éventuellement à jour votre ./initialisation-iaac-cible-deploiement.sh"
echo "  Puis pressez la touche entrée pour poursuivre les opérations.  "
echo " ---------------------------------------------------------------------- "
echo "  "
read DEBUGJBL3
clear

# - Je rends exéutable les fichiers de script utilisés dans les builds d'images Docker qui doivent l'être : 
chmod +x ./*.sh
# chmod +x ./construction/mongodb/*

# chmod +x ./hubot-init-rocketcha/construction/* 
# - Je créée "tout"
# docker-compose down --rmi all && docker system prune -f && docker-compose build && docker-compose up -d 
# - Non: il y a un volume trop grand d'image téléchargées
docker-compose down && docker system prune -f && docker-compose up -d --build --force-recreate

# - 1 - Je dois relancer le conteneur qui créée et initialise le replicaSet mongoDB, dès que mongoDB est disponible :
# checkHealth $NOM_CONTENEUR_BDD_ROCKETCHAT
# docker start $NOM_CONTENEUR_INIT_REPLICASET_BDD_ROCKETCHAT

# - 2 - Maintenant que le replicaSet Existe, je peux re-démarrer le conteneur rocketchat : 
#       cela se fait tout seul, parce que rocketchat est en restart=always dans le dokcer-compose.yml
# docker-compose up -d $NOM_CONTENEUR_ROCKETCHAT
# sleep 3 && docker ps -a
# docker logs $NOM_CONTENEUR_ROCKETCHAT
# -->> À terme, je voudrais, au lieu de re-démarrer de force le service rocketchat, le laisser re-démarrer, et vérifier que
#      Rocket Chat est dans un état "Healthy", avant de créer manuellement le USER utilisé par le service HUBOT ensuite :
#           pour cela, il faudra donc faire un HEALTHCHECK rocketchat, et invoquer la focntion [checkHealth] de ce script : 
# 
#    checkHealth $NOM_CONTENEUR_ROCKETCHAT
# 
# 
# - 3 - Il faut manuellement créer l'utilisateur RocketChat mentionné dans la configuration du service 'hubot' dans le fichier docker-compose.yml : 


# - 4 - Maintenant que l'utilisateur dont le hubot a besoin existe, on re-démarre le hubot :

clear
echo "  "
echo " ---------------------------------------------------------------------- "
echo "  "
checkHealth $NOM_CONTENEUR_IDE_MARGUERITE
echo "  "
echo " ---------------------------------------------------------------------- "
echo "  "
echo " ---------------------------------------------------------------------- "
echo "   FIN de la provision $ALIAS_INFRA  : "
echo " ---------------------------------------------------------------------- "
# echo "    - \"UTILISATEUR_HUBOT_ROCKETCHAT_USERNAME=$UTILISATEUR_HUBOT_ROCKETCHAT_USERNAME\" "
echo "  "
docker ps -a
echo "  "
docker images
echo "  "
echo "   Pressez la touche entrée pour terminer la provision. "
echo " ---------------------------------------------------------------------- "
echo "  "
read ATTENTE_INTERACTIVE

# - Maintenant, examinons les logs du conteneur ide :

docker logs $NOM_CONTENEUR_IDE_MARGUERITE -f 
