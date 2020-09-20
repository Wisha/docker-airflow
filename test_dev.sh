#!/usr/bin/env bash

AIRFLOW_VERSION=$(airflow version)

echo "Airflow Version: $AIRFLOW_VERSION"

airflow upgradedb
airflow variables -i variables/dev.json

python test.py