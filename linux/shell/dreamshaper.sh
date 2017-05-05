#!/bin/sh
# Provides aliases to make it easy to manage server, db, etc
# this file should be put in /etc/profile.d

echo_usage() {
  echo "USAGE:
    \ndreamshaper php <start|stop|restart|status>
    \ndreamshaper nginx <start|stop|restart|reload|status>
    \ndreamshaper mysql <start|stop|restart|status>
    \ndreamshaper mongodb <start|stop|restart|status>
  "
}

dreamshaper() {

  SERVICE=$1
  ACTION=$2

  if [ -z $1 ] || [ -z $2 ];
  then
      echo_usage
      exit 0
  fi

  if [ $1 == "php" ];
  then
      sudo service php5.6-fpm $2
      return
  fi

  if [ $1 == "nginx" ];
  then
      if [ $2 == "reload" ];
      then
          sudo nginx -s $2
          return
      else
          sudo service nginx $2
          return
      fi
  fi

  if [ $1 == "mysql" ] || [ $1 == "mongodb" ];
  then
      sudo service $1 $2
      return
  fi
}
