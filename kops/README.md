# Setting up Pangeo on AWS using KOPS

This folder contains notes, config files and scripts from deploying Pangeo on AWS using KOPS.

I used instructions from:
* [Step Zero: Kubernetes on Amazon Web Services (AWS)](https://zero-to-jupyterhub.readthedocs.io/en/latest/amazon/step-zero-aws.html)
* [Spin up AWS Kubernetes cluster for workshop](https://github.com/jmunroe/pangeo-tutorial-c3dis-2019/issues/1)

Stopped at:

```bash
helm install jupyterhub/binderhub --version=0.2.0-7b2c4f8  \
             --name=c3dis --namespace=c3dis \
             -f secret.yaml -f config.yaml
``` 

Not sure of the right values for those config files.
