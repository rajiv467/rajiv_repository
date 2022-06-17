FROM ubuntu:xenial-20210804

RUN apt update \
&& apt install -y \
    apt-transport-https ca-certificates gnupg software-properties-common curl wget \
    unzip groff less git jq

# Install kubectl
#https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg \
&& echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" \
    | tee /etc/apt/sources.list.d/kubernetes.list \
&& apt update \
&& apt install -y kubectl

# Install kfctl
RUN curl --silent --location  "https://github.com/kubeflow/kfctl/releases/download/v1.2.0/kfctl_v1.2.0-0-gbc038f9_linux.tar.gz" \
 | tar xz -C /usr/bin

# Install terraform
#https://learn.hashicorp.com/tutorials/terraform/install-cli
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
&& apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
&& apt update && apt install terraform

# Install HELM
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Install AWS CLI
# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /root/awscliv2.zip \
&& unzip /root/awscliv2.zip -d /root \
&& /root/aws/install -i /usr/local/aws-cli -b /usr/local/bin \
&& aws --version

# Install aws aim auth tool
RUN curl -o /usr/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator \
&& chmod +x /usr/bin/aws-iam-authenticator

# Install eksctl
#https://github.com/weaveworks/eksctl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
 | tar xz -C /tmp \
&& mv /tmp/eksctl /usr/local/bin

WORKDIR /root