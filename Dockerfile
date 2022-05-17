FROM python:3.9.12-slim-bullseye

LABEL maintainer="me@nguyenthdat.com"
LABEL version="v0.0.8"
LABEL description="This image for using terrform in CI/CD pipeline"

ENV TERRAFORM_VERSION=1.2.0-rc2
ENV VAULT_VERSION=1.10.3
ENV PACKER_VERSION=1.8.0
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install ansible python3-pip vim curl wget

RUN wget https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_"$TERRAFORM_VERSION"_linux_amd64.zip 
RUN unzip terraform_"$TERRAFORM_VERSION"_linux_amd64.zip && rm terraform_"$TERRAFORM_VERSION"_linux_amd64.zip
RUN mv terraform /usr/bin/terraform

RUN wget https://releases.hashicorp.com/vault/$VAULT_VERSION/vault_"$VAULT_VERSION"_linux_amd64.zip 
RUN unzip vault_"$VAULT_VERSION"_linux_amd64.zip && rm vault_"$VAULT_VERSION"_linux_amd64.zip
RUN mv vault /usr/bin/vault

RUN wget https://releases.hashicorp.com/packer/$PACKER_VERSION/packer_"$PACKER_VERSION"_linux_amd64.zip 
RUN unzip packer_"$PACKER_VERSION"_linux_amd64.zip && rm packer_"$PACKER_VERSION"_linux_amd64.zip
RUN mv packer /usr/bin/packer

RUN pip3 install pyvmomi
RUN ansible-galaxy collection install community.vmware

WORKDIR /root
CMD ["/bin/bash"]