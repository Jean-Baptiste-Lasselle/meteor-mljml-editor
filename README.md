# Monter un enviroonnment de développement meteor valide

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

