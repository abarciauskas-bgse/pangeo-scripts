# Setting up Dask Kubernetes using AWS EKS

This folder contains notes, config files and scripts from deploying dask kubernetes on AWS EKS.

To do this, I followed instructions from [Zero to Jupyterhub: Step Zero: Kubernetes on Amazon Web Services (AWS) with Elastic Container with Kubernetes (EKS)](https://zero-to-jupyterhub.readthedocs.io/en/latest/amazon/step-zero-aws-eks.html) which largely refers back to [AWS Documentation: Getting Started with EKS](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html).

## Notes from using these instructions

* I did not see a way to add `AmazonEC2ContainerRegistryReadOnly`, assume it is unnecessary or a part of the other 2 policies.
* For Step 2: EKS Cluster: Originally, did this manually through the console, but assume something went wrong because I couldn't get node status. Switched to using https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html instructions, which use an Amazon S3 template URL for cloudformation.
* I manually scaled up and down number of instances and instance using launch configurations and editing the autoscaling group's desired instances. Everything went up and down fine, but notebooks are lost (assuming this goes along with EBS).
* Helm Setup: When runninng `./3_deploy_helm.sh` got the error:
  ```bash
  Error: priorityclasses.scheduling.k8s.io "pangeohub-default-priority" is forbidden: User "system:serviceaccount:kube-system:default" cannot delete priorityclasses.scheduling.k8s.io at the cluster scope
  ```
  I googled the error and [ran these commands](https://stackoverflow.com/a/46688254) and it s
  seems to have resolved itself. I can now run `./3_deploy_helm.sh` without error.
* When running kubectl commands, often need to add `--namespace` to get expected results

## Notes from running MUR SST NetCDF4

I ran into 2 issues getting scripts to work (summary here does not accurately reflect the time wasted :sweat_smile:)

1. Package versions - conda version mismatch between different pods can cause errors. These errors can be hard to track down at first because the jupyter notebook will be silently retrying and not print the errors as the workers are experiencing them. This was resolved by having the same command run for `EXTRA_CONDA_PACKAGES`.
2. Workers and notebook don't share a filesystem (duh). So you have to configure a shared filesystem. I used S3 in which case you need to configure workers with proper credentials to access the S3 FS. This was straightforward once I figured out this was the problem.

Both of these errors were obscured by this zarr error:

```bash
ValueError: array not found at path 'analysed_sst'
```

Using `kubectl logs $podname` was necessary to track down the underlying error being experienced by the workers.

Solutions to both of these issues are summarized in `dask_config.yml`.

## References

* [MUR SST to Zarr Gist](https://gist.github.com/cgentemann/54fb76b0a39b4b8f26a963dd6b840a89)
* [MUR SST OpenDAP](https://podaac-opendap.jpl.nasa.gov/opendap/allData/ghrsst/data/GDS2/L4/GLOB/JPL/MUR/v4.1/)
* [MUR SST HTTPS](https://data.nodc.noaa.gov/ghrsst/GDS2/L4/GLOB/JPL/MUR/v4.1/)
* On using opendap for MUR SST: https://climate-cms.org/2019/01/18/using-opendap.html
* [dask_kubernetes](https://kubernetes.dask.org/en/latest/)
* [Spin up AWS Kubernetes cluster for workshop](https://github.com/jmunroe/pangeo-tutorial-c3dis-2019/issues/1)
* [Setting up ACCESS Pangeo on AWS #26](https://github.com/ESIPFed/esiphub-dev/issues/26)
* [AWS Deployment](https://github.com/pangeo-data/pangeo/issues/71)

## IMPORTANT NOTES

* EKS costs $0.20 / hour PLUS ec2 costs PLUS when I shut down EKS cluster via console it _did not_ terminate my instances, so this must be done in a separate step.``
