FROM ubuntu:20.04
ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV DEBIAN_FRONTEND=noninteractive

# Setting timezone
RUN ln -fs /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

# installing some base packages
RUN apt update && \
    apt upgrade -y && \
    apt install --no-install-recommends -y \
    wget \
    locales \
    gnupg2 \
    gpg-agent \
    ca-certificates



# adding llvm sources list
RUN echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal main\n" \
    "deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal main" \
    > /etc/apt/sources.list.d/llvm.list && \
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

# setting up locale
RUN locale-gen en_US en_US.UTF-8 && \
    dpkg-reconfigure locales

# adding deadsnakes python ppa (required by some dep in com_github_grpc_grc for python generation)
# (doing this without add-apt-repository cuz installing that ends up installing gstreamer and 
# I don't want that)
RUN echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu focal main\n"\
    "# deb-src http://ppa.launchpad.net/deadsnakes/ppa/ubuntu focal main\n"\
    > /etc/apt/sources.list.d/deadsnakes-ubuntu-ppa-focal.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F23C5A6CF475977595C89F51BA6932366A755776 && \
    apt update

# installing deps
RUN apt install -y --no-install-recommends \
    ca-certificates \
    gnupg2 \
    sudo \
    git \
    curl \
    unzip \
    clang-format \
    clang-17 \
    file \
    patch \
    python3.10 \
    && \
    # install cross compilation deps if host system is x86_64
    if [ "$(arch)" = "x86_64" ]; then \
    apt install -y --no-install-recommends \
    # this installs files required for cross compiling
    g++-aarch64-linux-gnu; \
    fi

# setting up python3
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2 && \
    update-alternatives --set python3 /usr/bin/python3.10

# installing bazel
RUN if [ "$(arch)" = "x86_64" ]; then \
    wget https://github.com/bazelbuild/bazelisk/releases/download/v1.16.0/bazelisk-linux-amd64 -O /usr/local/bin/bazel; \
    else \
    wget https://github.com/bazelbuild/bazelisk/releases/download/v1.16.0/bazelisk-linux-arm64 -O /usr/local/bin/bazel; \
    fi && \
    chmod +x /usr/local/bin/bazel;

# installing hasura cli
RUN curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash
ENV PG_DATABASE_URL=postgres://postgres:postgrespassword@postgres:5432/postgres

# adding dev user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -ms /bin/bash $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER developer

# installing node for get-graphql-schema
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install --lts && \
    npm install -g get-graphql-schema

# installing rust for vscode support (linting and type checking) only. 
# compilation happens through bazel
# installing rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-update-default-toolchain && \
    . $HOME/.cargo/env && rustup install 1.68.1
