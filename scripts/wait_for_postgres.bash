#!/bin/bash
set -e

#echo 'Waiting for container `postgres`.'
#dockerize -timeout=20s -wait ${POSTGRES_PORT}
#echo 'Container `postgres` up.'

echo 'Waiting for container `postgres`.'
sleep 20
IS_OPENED=$((echo > /dev/tcp/postgres/${POSTGRES_PORT//\"/}) >/dev/null 2>&1 && echo "1" || echo "0")

if [ "$IS_OPENED" == "1" ]; then
    echo 'Waiting for Postgres service.'
    # TODO: There must be a way to confirm Postgres is serving without the resulting "incomplete startup packet" warning in the logs.
    KOBO_POSTGRES_DB_NAME=${KOBO_POSTGRES_DB_NAME:-"kobotoolbox"}
    KOBO_POSTGRES_USER=${KOBO_POSTGRES_USER:-"kobo"}
    until pg_isready -d "${KOBO_POSTGRES_DB_NAME}" -h postgres -U "${KOBO_POSTGRES_USER}"; do
        sleep 1
    done
    echo 'Postgres service ready.'
else
    echo 'Container `postgres` down.'
fi