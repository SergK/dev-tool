#!/bin/bash

DATADIR=/var/lib/mysql

#
# On first run initialize database
#
if [[ ! -d "${DATADIR}/mysql" ]]; then
    echo "No database, initializing"

    if [[ -z "${MYSQL_ROOT_PASSWORD}" ]]; then
        echo "[ERROR] No root password set, please set MYSQL_ROOT_PASSWORD environment with new password"
        exit 1
    fi

    echo "Initialize clean database"
    mysql_install_db --datadir="${DATADIR}" --rpm --user=mysql --disable-log-bin

    echo "Start temporary mysqld server"
    mysqld_safe --skip-networking &

    MYSQLCLI=( mysql --protocol=socket -uroot )

    echo "Wait for mysql start"
    i=0
    while ! echo 'SELECT 1' | "${MYSQLCLI[@]}" &> /dev/null; do
        echo 'Waiting for mysqld...'
        sleep 1
        if [[ "${i}" -gt 10 ]]; then
            echo "[ERROR] mysqld process not stared in time"
            exit 1
        fi
        i=$((i+1))
    done

    echo "Clean database and create new root user"
    "${MYSQLCLI[@]}" <<-EOF
SET @@SESSION.SQL_LOG_BIN=0;
DELETE FROM mysql.user;
CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF

    echo "Stop temporary database"
    mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
fi

echo "Start mysql server"
mysqld_safe
