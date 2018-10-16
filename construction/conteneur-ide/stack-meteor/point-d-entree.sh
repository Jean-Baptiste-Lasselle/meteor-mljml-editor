#!/bin/bash

# Les deux lignes ci-dessous DEVRONT, être présentes dans le mode CMD du conteneur
echo "  " 
echo " Verifcation conteneur \$HOME = $HOME "
echo "  " 
ls -all $HOME
echo "  " 
echo "  " 
echo "  " 
touch $HOME/bash_profile
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
