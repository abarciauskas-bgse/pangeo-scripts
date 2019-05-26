helm install pangeo/pangeo --version=pangeo-19.03.05 --namespace=pangeo \
  -f values.yml -f secret_config.yml

kubectl create -f dask-kubernetes-serviceaccount.yml

kubectl create clusterrolebinding serviceaccounts-admin \
  --clusterrole=cluster-admin \
  --user=admin \
  --user=kubelet \
  --group=system:serviceaccounts \
  --namespace=pangeo

helm upgrade prodding-platypus pangeo/pangeo -f values.yml -f secret_config.yml

helm install stable/dask --name=dask --namespace=pangeo -f dask_config.yml