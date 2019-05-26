#!/bin/bash

set -e

helm install stable/dask -f dask_config.yaml
