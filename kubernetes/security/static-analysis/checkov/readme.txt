###############
#  checkov
###############
Checkov from Bridgecrew is an open-source static analysis tool for infrastructure as code.
Static analysis means analysis of code without running it. It is useful because you don't need to wait for a build to finish or pay for cloud computing resources to analyse the working of the code. 
With Checkov you can analyse Kubernetes objects such as deployments. It can also be used to audit other infrastructure-as-code files such as Terraform scripts. 
This makes it a powerful tool to add to your continuous integration/continuous deployment (CI/CD) pipeline.

# Install
# Certain environments may require you to install Checkov in a virtual environment
# Create and activate a virtual environment
apt install python3.12-venv
python3 -m venv ./venv/checkov
cd ./venv/checkov
source ./bin/activate

# Install Checkov with pip
pip install checkov

# Optional: Create a symlink for easy access
ln -s $HOME/venv/checkov/bin/checkov /usr/local/bin/checkov

# Alternative install
apt install pipenv -y
pipenv run pip install checkov
pipenv run checkov -v
pipenv run checkov -f deployment.yaml
##


# to scan an individual file
checkov -f ./deployment.yaml

# to scan a directory
checkov --directory /path/to/iac/code

# 
# do not report any results for the kube-system namespace:
checkov -d . --skip-check kube-system

# allow only the two specified checks to run:
checkov --directory . --check CKV_AWS_20,CKV_AWS_57

# run all checks except the one specified:
checkov -d . --skip-check CKV_AWS_20

# run all checks except checks with specified patterns:
checkov -d . --skip-check CKV_AWS*

# terraform scripts
terraform init
terraform plan -out tf.plan
terraform show -json tf.plan  > tf.json
checkov -f tf.json


# Checkov can be deployed in Kubernetes as a Job to get immediate feedback on the state of resources in your cluster.
# https://github.com/bridgecrewio/checkov/tree/main/kubernetes


kubectl apply -f https://raw.githubusercontent.com/bridgecrewio/checkov/main/kubernetes/checkov-job.yaml
namespace/checkov created
serviceaccount/checkov created
clusterrole.rbac.authorization.k8s.io/checkov-view created
clusterrolebinding.rbac.authorization.k8s.io/checkov created
job.batch/checkov created

# to check job status
kubectl get jobs -n checkov

# to get a full log output of the cluster scan
kubectl logs job/checkov -n checkov

# To remove the job and logs, you can run:
kubectl delete clusterrolebinding checkov
kubectl delete clusterrole checkov-view
kubectl delete namespace checkov
OR
kubectl delete -f https://raw.githubusercontent.com/bridgecrewio/checkov/main/kubernetes/checkov-job.yaml
