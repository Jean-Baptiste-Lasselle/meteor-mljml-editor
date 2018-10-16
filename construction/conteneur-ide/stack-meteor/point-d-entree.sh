#!/bin/sh

export NODE_OPTIONS=$MARGUERITE_NODE_OPTIONS
export PATH=$PATH:$HOME/.meteor
meteor run --port $MARGUERITE_METEOR_PORT
