ARG UBUNTU_VERSION=24.04
FROM ubuntu:${UBUNTU_VERSION}

# set environment variables
ARG TERRAFORM_VERSION=1.8.5-1
ARG AWS_CLI_VERSION=2.16.5
ARG TFLINT_VERSION=0.51.1

ARG USERNAME=vscode
ARG USER_UID=1001
ARG USER_GID=$USER_UID

# change WORKDIR to /workspace
ARG WORKSPACE=/terraform_test
WORKDIR ${WORKSPACE}

# change default shell to bash
SHELL ["/bin/bash", "-o" , "pipefail", "-c"]
RUN chsh -s /bin/bash

# increase timeout for apt-get to 5 minutes
RUN echo "Acquire::http::Timeout \"300\";" > /etc/apt/apt.conf.d/99timeout
RUN echo "Acquire::ftp::Timeout \"300\";" >> /etc/apt/apt.conf.d/99timeout

# install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    less \
    curl \
    wget \
    unzip \
    jq \
    vim \
    sudo \
    git \
    gnupg \
    software-properties-common \
    && apt-get clean

# install terraform
RUN wget --quiet -O - https://apt.releases.hashicorp.com/gpg --no-check-certificate | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null 
RUN gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list
RUN apt update && apt-get install -y terraform=${TERRAFORM_VERSION} \
    && apt-get clean

# install aws-cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

# Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# to show Japanese git log
ENV LESSCHARSET=utf-8
