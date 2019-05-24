FROM chef/chefdk:latest

# Install APT Packages
RUN apt-get update \
 && apt-get install -y \
      docker.io \
      git \
      git-crypt \
      gpg \
      gpg-agent \
      jq \
      python-pip \
      unzip \
 && rm -rf /var/lib/apt/lists/*

# Install Python Packages
RUN pip install \
      awscli \
 && rm -rf /root/.cache

# Install Ruby Gems
RUN gem install \
      awspec \
      kitchen-verifier-awspec \
      kitchen-terraform

# Install other binaries

ARG AWS_IAM_AUTHENTICATOR_VERSION=1.12.7/2019-03-27
RUN wget -q "https://amazon-eks.s3-us-west-2.amazonaws.com/${AWS_IAM_AUTHENTICATOR_VERSION}/bin/linux/amd64/aws-iam-authenticator" \
 && chmod +x aws-iam-authenticator \
 && mv aws-iam-authenticator /usr/local/bin/

ARG HELM_VERSION=2.14.0
RUN wget -q "https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
 && tar -xzf "helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
 && mv linux-amd64/helm /usr/local/bin/ \
 && rm -rf "helm-v${HELM_VERSION}-linux-amd64.tar.gz" linux-amd64 \
 && helm init -c

ARG KUBECTL_VERSION=1.14.0
RUN wget -q "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
 && chmod +x kubectl \
 && mv kubectl /usr/local/bin/

ARG TERRAFORM_VERSION=0.12.0
RUN wget -q "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
 && unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/local/bin/ \
 && rm -f "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

ARG TFLINT_VERSION=0.7.6
RUN wget -q "https://github.com/wata727/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip" \
 && unzip tflint_linux_amd64.zip -d /usr/local/bin/ \
 && rm -f tflint_linux_amd64.zip

ARG GOMPLATE_VERSION=3.4.1
RUN wget -q "https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64" \
 && chmod +x gomplate_linux-amd64 \
 && mv gomplate_linux-amd64 /usr/local/bin/gomplate
