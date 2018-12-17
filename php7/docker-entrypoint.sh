#!/bin/bash
set -e
shopt -s nullglob

if [ "$1" = 'apache2-foreground' ]; then
    # initializing web
    for f in /docker-entrypoint-init.d/*; do
        case "$f" in
            *.sh)                   echo "$0: running $f"; . "$f" ;;
            */*virtual-host_*.conf) echo "$0: virtual host ${f##*_}"; envsubst < "$f" | sudo tee /etc/apache2/sites-available/${f##*_} ;;
            *)                      echo "$0: ignoring $f" ;;
        esac
        echo
    done

    # stop handler
    stop_handler() {
        echo 'stop_handler running'
        if [ $pid -ne 0 ]; then
            sudo kill -SIGTERM "$pid"
            wait "$pid"
            # initializing web
            for f in /docker-entrypoint-clean.d/*; do
                case "$f" in
                    *.sh) echo "$0: running $f"; . "$f" ;;
                    *)    echo "$0: ignoring $f" ;;
                esac
                echo
            done
        fi

        exit 143; # 128 + 15 -- SIGTERM
    }

    # trap the sigterm to unset some stuff if jenkins build
    if [ "$CLEAN_ON_STOP" == "true" ]; then
        trap stop_handler SIGTERM
    fi
fi

sudo -E "$@" &
pid="$!"

wait