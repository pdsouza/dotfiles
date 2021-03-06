FROM debian:latest

# platform
RUN apt-get update && apt-get install -y \
    sudo

# core dev tools
RUN apt-get install -y \
    vim \
    git \
    tree

# build dependencies
RUN apt-get install -y \
    automake \
    build-essential \
    pkg-config \
    python \
    unzip \
    wget \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# create default user
ARG user=pre
ARG group=pre
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group} \
    && useradd -u ${uid} -g ${gid} -m -s /bin/bash ${user} \
    && echo "${user} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-passwordless-sudo

# copy over settings
COPY dotfiles/* /home/${user}/

# make sure user owns everything in $HOME
RUN chown -R ${user}:${user} /home/${user}

# drop root privileges
USER ${user}

ARG WORKSPACE=/home/${user}
WORKDIR $WORKSPACE
