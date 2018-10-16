#!/bin/bash

# VERSION_IMAGE_CENTOS=centos:7
export ID_IMAGE_CENTOS=$(cat ./.env|grep VERSION_IMAGE_CENTOS | awk -F = '{print $2}')

# VERSION_IMAGE_GITLAB_CE=gitlab/gitlab-ce:latest
# export ID_IMAGE_GITLAB_CE=$(cat ./.env|grep VERSION_IMAGE_GITLAB_CE | awk -F = '{print $2}')
# export CETTE_GITLAB_CE_VERSION=$(cat ./.env|grep GITLAB_CE_VERSION | awk -F = '{print $2}')
# export ID_IMAGE_GITLAB_CE="gitlab/gitlab-ce:$CETTE_GITLAB_CE_VERSION"

# VERSION_IMAGE_MONGO=mongo:latest
export ID_IMAGE_MONGO=$(cat ./.env|grep VERSION_IMAGE_MONGO | awk -F = '{print $2}')

# VERSION_IMAGE_NGINX=nginx:latest
export ID_IMAGE_NGINX=$(cat ./.env|grep VERSION_IMAGE_NGINX | awk -F = '{print $2}')


echo "   "
echo "   "
echo "  -------------------------------------------  "
echo "  +  initialisation-iaac-cible-deploiement.sh "
echo "  -------------------------------------------  "
echo "    ID_IMAGE_CENTOS=$ID_IMAGE_CENTOS "
echo "  -------------------------------------------  "
echo "    ID_IMAGE_MONGO=$ID_IMAGE_MONGO "
echo "  -------------------------------------------  "
echo "    ID_IMAGE_NGINX=$ID_IMAGE_NGINX "
echo "  -------------------------------------------  "
echo "   "
echo "   "


docker system prune -f
# + Permet d'initialiser le contexte de déploimeent, la cible de déploiement, pour un cycle IAAC
docker pull "$ID_IMAGE_CENTOS"
docker pull "$ID_IMAGE_MONGO"
docker pull "$ID_IMAGE_NGINX"

echo " --------------------------------------------- "
echo " Ok initialisation IAAC Marguerite Meteor IDE "
echo " --------------------------------------------- "
