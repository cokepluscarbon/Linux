#!/bin/sh
# https://hostadvice.com/how-to/how-to-install-and-configure-zen-cart-on-an-ubuntu-18-04-vps-or-dedicated-server/
echo -n "ZenCart installation, please enter your hostname:"
read hostname
sudo apt-get update -y
sudo apt-get upgrade -y
