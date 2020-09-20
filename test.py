"""
Test integrity of DAGs
"""

import importlib
import logging
import os
import pytest

from airflow import models as af_models


def main():
    dag_path = os.path.join(os.path.dirname(__file__), 'dags')
    print(dag_path)

    dag_files = [f for f in os.listdir(dag_path) if f.endswith('.py')]

    def test_dag_integrity(dag_file):
        module_name, _ = os.path.splitext(dag_file)
        module_path = os.path.join(dag_path, dag_file)
        mod_spec = importlib.util.spec_from_file_location(module_name, module_path)
        module = importlib.util.module_from_spec(mod_spec)
        mod_spec.loader.exec_module(module)

        dag_objects = [var for var in vars(module).values() if isinstance(var, af_models.DAG)]
        logging.info('asserting dag_objects')
        assert dag_objects

        for dag in dag_objects:
            logging.info('testing dag: ' + str(dag))
            dag.test_cycle()

    for dag_file in dag_files:
        test_dag_integrity(dag_file)


if __name__ == '__main__':
    main()
