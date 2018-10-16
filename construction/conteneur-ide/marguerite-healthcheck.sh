#!/bin/bash
set -eo pipefail

export NOM_HOTE_RESEAU="$(hostname --ip-address || echo '127.0.0.1')"

echo " VERIF NOM HOTE RESEAU : NOM_HOTE_RESEAU=$NOM_HOTE_RESEAU "
curl --fail http://$NOM_HOTE_RESEAU:$MARGUERITE_METEOR_PORT/ || exit 1

# 
# export CODE_DE_RETOUR=$(curl --fail http://$NOM_HOTE_RESEAU:$MARGUERITE_METEOR_PORT/ || echo 1 )
# exit $CODE_DE_RETOUR
# 
# if [ "" == "" ]; then
#      echo "Alors tout va bien, le serveur de BDD mongo est disponible. On peut continuer les vérifications"
# else
#      echo "Le serveur mongoDB n'est pas encore disponible."
#      exit 1
# fi
