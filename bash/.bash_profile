export PATH="/usr/local/sbin:$PATH"

export CHANGELOG_GITHUB_TOKEN=7c894d3f9db2dd9c53e147fa632e9fe6a4aaa4f8

alias ll='ls -lG'
alias sf='php app/console'

function ssh() {
  SERVER=`cut -d "@" -f 2 <<< $1`
  if [ $SERVER = "dreamshaper.com" ]
  then
    echo -e "\033]50;SetProfile=PROD\a";
    command ssh $@;
    echo -e "\033]50;SetProfile=Default\a"
  else
    command ssh $@;
  fi
}

alias nginx-start='sudo launchctl load /usr/local/opt/nginx-full/homebrew.mxcl.nginx-full.plist'
alias nginx-stop='sudo launchctl unload /usr/local/opt/nginx-full/homebrew.mxcl.nginx-full.plist'
alias nginx-restart='nginx-stop; nginx-start;'
alias nginx-debug="sudo nginx -c /usr/local/etc/nginx/nginx.conf -g 'daemon off;'"
alias nginx-log='echo -e "\x1B[7mTailing nginx/error.log\x1B[0m"; tail -f /usr/local/var/log/nginx/error.log'

alias fpm-start='launchctl load /usr/local/opt/php55/homebrew.mxcl.php55.plist'
alias fpm-stop='launchctl unload /usr/local/opt/php55/homebrew.mxcl.php55.plist'
alias fpm-restart='fpm-stop; fpm-start'
alias fpm-debug='php-fpm --fpm-config /usr/local/etc/php/5.5/php-fpm.conf'

alias dnsmasq-start='sudo launchctl load /usr/local/opt/dnsmasq/homebrew.mxcl.dnsmasq.plist'
alias dnsmasq-stop='sudo launchctl unload /usr/local/opt/dnsmasq/homebrew.mxcl.dnsmasq.plist'
alias dnsmasq-restart='dnsmasq-stop; dnsmasq-start'
alias dnsmasq-debug='sudo /usr/local/opt/dnsmasq/sbin/dnsmasq --no-daemon'

alias mysql-start='sudo mysql.server start'
alias mysql-stop='sudo mysql.server stop'
alias mysql-restart='mysql-stop; mysql-start'
alias mysql-debug='mysqld'
alias mysql-log='echo -e "\x1B[7mTailing mysql_general.log\x1B[0m"; tail -f /usr/local/var/log/mysql_general.log'
alias mysql-err='echo -e "\x1B[7mTailing err\x1B[0m"; tail -f /usr/local/var/mysql/Andres-MBP-2.lan.err'

alias mongo-start='sudo launchctl load /usr/local/opt/mongodb/homebrew.mxcl.mongodb.plist'
alias mongo-stop='sudo launchctl unload /usr/local/opt/mongodb/homebrew.mxcl.mongodb.plist'
alias mongo-restart='mongo-stop; mongo-start'
alias mongo-debug='mongod'
alias mongo-log='echo -e "\x1B[7mTailing mongodb/output.log\x1B[0m"; tail -f /usr/local/var/log/mongodb/output.log'

alias start-all='mysql-start; echo "Starting Mongo"; mongo-start; echo "Starting Nginx"; nginx-start; echo "Starting PHP"; fpm-start'
alias stop-all='mysql-stop; echo "Stopping Mongo"; mongo-stop; echo "Stopping Nginx"; nginx-stop; echo "Stopping PHP"; fpm-stop'
