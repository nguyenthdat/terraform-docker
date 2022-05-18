#FROM ubuntu:focal
FROM alpine:latest

LABEL maintainer="me@nguyenthdat.com"
LABEL version="v0.1.1"
LABEL description="This image for using terrform in CI/CD pipeline"

ENV TERRAFORM_VERSION=1.2.0-rc2
ENV VAULT_VERSION=1.10.3
ENV PACKER_VERSION=1.8.0
ENV DEBIAN_FRONTEND=noninteractive

# Install base packages
# RUN apt-get update && \
#    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
#        build-essential python3 python3-dev python3-pip wget unzip git

RUN wget https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_"$TERRAFORM_VERSION"_linux_amd64.zip 
RUN unzip terraform_"$TERRAFORM_VERSION"_linux_amd64.zip && rm terraform_"$TERRAFORM_VERSION"_linux_amd64.zip
RUN mv terraform /usr/bin/terraform

RUN wget https://releases.hashicorp.com/vault/$VAULT_VERSION/vault_"$VAULT_VERSION"_linux_amd64.zip 
RUN unzip vault_"$VAULT_VERSION"_linux_amd64.zip && rm vault_"$VAULT_VERSION"_linux_amd64.zip
RUN mv vault /usr/bin/vault

RUN wget https://releases.hashicorp.com/packer/$PACKER_VERSION/packer_"$PACKER_VERSION"_linux_amd64.zip 
RUN unzip packer_"$PACKER_VERSION"_linux_amd64.zip && rm packer_"$PACKER_VERSION"_linux_amd64.zip
RUN mv packer /usr/bin/packer

RUN apk update && apk upgrade
RUN apk add curl python3 python3-dev py3-pip wget git libffi-dev

RUN pip3 install --upgrade pip setuptools
RUN pip3 install --upgrade virtualenv
RUN pip3 install --upgrade git+https://github.com/vmware/vsphere-automation-sdk-python.git

RUN pip3 install requests[security]
RUN pip3 install pyopenssl ndg-httpsclient pyasn1

RUN pip3 install pyvmomi
#RUN pip3 install ansible==2.9.6
RUN pip3 install --upgrade ansible-core ansible

RUN mkdir -p /etc/ansible
RUN echo "[defaults]" > /etc/ansible/ansible.cfg \
&& echo "display_skipped_hosts = False" >> /etc/ansible/ansible.cfg \
&& echo "ansible_python_interpreter = /usr/bin/python3" >> /etc/ansible/ansible.cfg \
&& echo "host_key_checking = False" >> /etc/ansible/ansible.cfg \
&& echo "remote_user = ansible" >> /etc/ansible/ansible.cfg \
&& echo "[inventory]" >> /etc/ansible/ansible.cfg \
&& echo "enable_plugins = community.vmware.vmware_vm_inventory" >> /etc/ansible/ansible.cfg 

RUN ansible-galaxy collection install community.vmware

# RUN pip3 install fabric
# RUN pip3 uninstall -y cryptography # uninstall 37.0.0
# RUN pip3 install cryptography==36.0.2

WORKDIR /root
CMD ["/bin/bash"]