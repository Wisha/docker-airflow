#!/usr/bin/env bash
set -e

aws ecs update-service --force-new-deployment --cluster airflow-master --service webserver
aws ecs update-service --force-new-deployment --cluster airflow-scheduler --service scheduler
aws ecs update-service --force-new-deployment --cluster airflow-worker --service worker
aws ecs update-service --force-new-deployment --cluster airflow-master --service flower

aws ecs wait services-stable --cluster airflow-master --service webserver
aws ecs wait services-stable --cluster airflow-scheduler --service scheduler
aws ecs wait services-stable --cluster airflow-worker --service worker
aws ecs wait services-stable --cluster airflow-master --service flower