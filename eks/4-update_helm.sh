#!/bin/bash

set -e

helm upgrade --force --debug \
  --recreate-pods --devel singed-sabertooth stable/dask \
  -f dask_config.yml
