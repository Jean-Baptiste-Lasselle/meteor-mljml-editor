# +++++ ANSIBLE templates +++++
# - 
# La directive 'FROM' doit être templatisée avec Ansible, pour mapper les valeurs des 
# variables d'environnement du fichier ["./.env"] suivantes : 
# - 
#    IMAGE_MARGUERITE_STACK_METEOR_COMPANY_NAME=marguerite/
#    IMAGE_MARGUERITE_STACK_METEOR_PRODUCT_NAME=stack-meteor
#    # Marguerite vous impose la compatibilité semver
#    VERSION_IMAGE_MARGUERITE_STACK_METEOR=1.0.0
# - 
# Et le templating à effectuer est le suivant : 
# - 
#    FROM $IMAGE_MARGUERITE_STACK_METEOR_COMPANY_NAME/$IMAGE_MARGUERITE_STACK_METEOR_PRODUCT_NAME:$VERSION_IMAGE_MARGUERITE_STACK_METEOR
# - 
FROM marguerite/meteor-stack:1.0.0

# Labels éditeur/distributeur


WORKDIR $WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR

EXPOSE $MARGUERITE_METEOR_PORT/tcp
# ---- EXECUTION ---- #
# ++ PRINCIPE : 
# => NIVEAU IMAGE DE CONTENEUR STACK-METEOR :: On installe NVM, NODEJS, et METEOR, et donc il suffit de changer les variables d'environnement, au docker build, pour changer les versions du stack meteor
# => NIVEAU IMAGE DE CONTENEUR fille :: On créé les projets suivants dans le workspace : on créé le projet meteor , au niveau du ENTRYPOINT aussi
# => NIVEAU ENTRYPOPINT :  on fait le meteor run --port 
# => NIVEAU CMD :  CMD ["/bin/bash"] , aisni l'ide pourra exécuter n'importe quelle commande, en taznt que user linux $MARGUERITE_USER_NAME 

# Le [./point-d-entree.sh] sera toujours exécuté avant la 'CMD', et seule la CMD est surchargée par l'invocation [docker exec ... /chemin/dans/conteneur/vers/executable]
ADD maguerite-healthcheck.sh $WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR/
RUN chmod +x $WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR/marguerite-healthcheck.sh
HEALTHCHECK CMD $WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR/marguerite-healthcheck.sh
# ENTRYPOINT ["$WORKSPACE_IDE/$NOM_PROJET_MARGUERITE_METEOR/point-d-entree.sh"] 
# CMD ["meteor", "run", "--port", "$MARGUERITE_METEOR_PORT"]
CMD ["/bin/bash"]
