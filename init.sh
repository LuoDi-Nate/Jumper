#!/bin/bash

#将jump.sh写入环境变量
JUMPER_HOME=`pwd`
export JUMPER_HOME

#写入bash
echo "export JUMPER_HOME=$JUMPER_HOME" >> ~/.bash_profile
echo "alias jump=$JUMPER_HOME/jumper.sh" >> ~/.bash_profile

#zsh
echo "export JUMPER_HOME=$JUMPER_HOME" >> ~/.zshrc
echo "alias jump=$JUMPER_HOME/jumper.sh" >> ~/.zshrc

