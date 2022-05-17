FROM alpine:latest

LABEL maintainer="me@nguyenthdat.com"
LABEL version="v0.0.6"
LABEL description="This image for using terrform in CI/CD pipeline"

ENV TERRAFORM_VERSION=1.2.0-rc2
ENV VAULT_VERSION=1.10.3
ENV PACKER_VERSION=1.8.0

RUN apk update

RUN apk --update --no-cache add \
        bash \
        ca-certificates \
        git \
        openssh-client \
        openssl \
        python3\
        py3-pip \
        py3-cryptography \
        rsync \
        sshpass

RUN apk --update add --virtual \
        .build-deps \
        python3-dev \
        libffi-dev \
        openssl-dev \
        build-base \
        curl 

RUN wget https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_"$TERRAFORM_VERSION"_linux_amd64.zip 
RUN unzip terraform_"$TERRAFORM_VERSION"_linux_amd64.zip && rm terraform_"$TERRAFORM_VERSION"_linux_amd64.zip
RUN mv terraform /usr/bin/terraform

RUN wget https://releases.hashicorp.com/vault/$VAULT_VERSION/vault_"$VAULT_VERSION"_linux_amd64.zip 
RUN unzip vault_"$VAULT_VERSION"_linux_amd64.zip && rm vault_"$VAULT_VERSION"_linux_amd64.zip
RUN mv vault /usr/bin/vault

RUN wget https://releases.hashicorp.com/packer/$PACKER_VERSION/packer_"$PACKER_VERSION"_linux_amd64.zip 
RUN unzip packer_"$PACKER_VERSION"_linux_amd64.zip && rm packer_"$PACKER_VERSION"_linux_amd64.zip
RUN mv packer /usr/bin/packer

RUN pip3 install --upgrade \
        pip \
        cffi \
 && pip3 install \
        ansible \
        ansible-lint \
 && apk del \
        .build-deps \
 && rm -rf /var/cache/apk/*

RUN pip3 install pyvmomi
RUN ansible-galaxy collection install community.vmware
RUN mkdir -p /etc/ansible
RUN echo \
'[defaults]\n\
command_warnings = false\n\
display_skipped_hosts = false\n\
ansible_python_interpreter = /usr/bin/python3\n\
host_key_checking = False\n\
remote_user = ansible\n\
private_key_file = ~/.ssh/ansible\n\
vault_password_file = ansible/vault-pass.sh\n\
inventory = ansible/inventory-vmware.yml\n\
[inventory]\n\
enable_plugins = community.vmware.vmware_vm_inventory\n'\
>> /etc/ansible/ansible.cfg

WORKDIR /root
CMD ["/bin/bash"]