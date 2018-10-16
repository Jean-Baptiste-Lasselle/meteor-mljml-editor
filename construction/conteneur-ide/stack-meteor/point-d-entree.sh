#!/bin/sh

export NODE_OPTIONS=$MARGUERITE_NODE_OPTIONS
export PATH=$PATH:$HOME/.meteor


echo " -------------------------------------------------------------- "
echo " VERIFICATIONS POINT D'ENTREE : "
echo " -------------------------------------------------------------- "
echo "  PATH=$PATH  "
echo "  NODE_OPTIONS=$NODE_OPTIONS  "
echo "  NOM_PROJET_MARGUERITE_METEOR=$NOM_PROJET_MARGUERITE_METEOR  "
echo "  Environnement METEOR : "
env |grep meteor
echo " -------------------------------------------------------------- "

cd $NOM_PROJET_MARGUERITE_METEOR
meteor run --port $MARGUERITE_METEOR_PORT
