#!/bin/bash

# bgp.sh BIRD routing daemon configuration utility.
#
# This utility is to assist in the configuration and management
# of Linux routers running the BIRD daemon. For more information
# about BIRD, check out https://bird.network.cz/
#
# The default editor is nano, but you're free to change it to whatever you want.
#
# Usage: ./bgp.sh [command] {args}

# _EDITOR=nano
_EDITOR=vim


case $1 in

    status|s)
    	echo -n "IPv4 "
    	sudo systemctl status bird | grep "Active: " --color=none | sed "s/^[ \t]*//"

    	echo -n "IPv6 "
    	sudo systemctl status bird6 | grep "Active: " --color=none | sed "s/^[ \t]*//"

    	echo
    	echo "--------------------------IPv4--------------------------"
      sudo birdc show protocols | column -t
    	echo
      echo "--------------------------IPv6--------------------------"
      sudo birdc6 show protocols | column -t
      ;;

    check|c)
      ping -c 2 1.1.1.1
      echo
    	ping -c 2 google.com
    ;;

    edit|e)
      case $2 in
        4|ipv4|v4)
          sudo $_EDITOR /etc/bird/bird.conf
        ;;

        6|ipv6|v6)
            sudo $_EDITOR /etc/bird/bird6.conf
        ;;

        interfaces|interface|iface|ifaces|i)
            sudo $_EDITOR /etc/network/interfaces
        ;;

        *)
            echo "Usage: ./bgp.sh edit [ipv4/ipv6/interfaces]"
        ;;
        esac
    ;;

    reload|r)
    	sudo birdc reload all
    	sudo birdc6 reload all
    ;;

    restart|rst)
      sudo systemctl restart bird
      sudo systemctl restart bird6
    ;;


    *)
      echo "Usage: ./bgp.sh [command] {args}"
    ;;
esac
