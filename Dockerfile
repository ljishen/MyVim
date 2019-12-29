FROM openjdk:8-jdk-slim-stretch
LABEL maintainer="Jianshen Liu <jliu120@ucsc.edu>"

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="ljishen/MyVim" \
      org.label-schema.description="Personalized all-in-one development environment in VIM!" \
      org.label-schema.url="https://github.com/ljishen/MyVim" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/ljishen/MyVim" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"


# perl for Checkpatch (syntax checking for C)
# gcc for syntax checking of c
# g++ for syntax checking of c++
# python3-pip, python3-setuptools and python3-wheel
#    are used for installing/building python packages (e.g. jsbeautifier, flake8)
# cppcheck for syntax checking of c and c++
# exuberant-ctags for Vim plugin Tagbar (https://github.com/majutsushi/tagbar#dependencies)
# clang is for plugin Vim plugin YCM-Generator (https://github.com/rdnetto/YCM-Generator)
# clang-format is used by plugin google/vim-codefmt
# python3-dev is required to build typed-ast, which is required by jsbeautifier
# python-dev, cmake and build-essential are used for compiling YouCompleteMe(YCM)
#     with semantic support in the following command:
#     /bin/sh -c /root/.vim/bundle/YouCompleteMe/install.py
# libffi-dev and libssl-dev is required to build ansible-lint
# shellcheck for syntax checking of sh

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        tar \
        vim-nox \
        git \
        perl \
        g++ \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        cppcheck \
        exuberant-ctags \
        clang \
        clang-format \
        python-dev \
        python3-dev \
        build-essential \
        cmake \
        libffi-dev \
        libssl-dev \
        shellcheck \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /root

# Install Vundle and Plugins
COPY .vimrc .
# hadolint ignore=DL3001
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
    && vim +PluginClean! +PluginInstall! +qall \
    && sed -i 's/"#//g' .vimrc

# Make folder to persistent undo used by plugin mbbill/undotree.
# For this to work you need to mount a host dir into "$HOME"/.undodir in the container.
# https://docs.docker.com/engine/reference/run/#volume-shared-filesystems
RUN mkdir -p "$HOME"/.undodir

ENV TERM tmux-256color


# Install js-beautify as the JSON Formatter for plugin google/vim-codefmt
# Install bandit, flake8, pycodestyle and pydocstyle as the syntax checkers
#     for Python3 used in plugin vim-syntastic/syntastic
# Install mypy as the syntax checkers for Python3 used in plugin vim-syntastic/syntastic
# pylint is a code linter for Python used by plugin vim-syntastic/syntastic
# ansible-lint is a best-practices linter for Ansible playbooks used by plugin vim-syntastic/syntastic

# hadolint ignore=DL3013
RUN pip3 install --upgrade \
        jsbeautifier \
        flake8 \
        mypy \
        bandit \
        pylint \
        pycodestyle \
        pydocstyle \
        ansible-lint

# Compiling YouCompleteMe(YCM) with semantic support for Jave and C-family languages (through libclang and clangd)
RUN /root/.vim/bundle/YouCompleteMe/install.py \
        --clang-completer \
        --clangd-completer \
        --java-completer


# Install various checkers for plugin vim-syntastic/syntastic

ARG SYNTASTIC_HOME=/root/.vim/syntastic
RUN mkdir "${SYNTASTIC_HOME}"

# Install Checkstyle (for Java)
ARG CHECKSTYLE_VERSION=8.27
ARG CHECKSTYLE_HOME=${SYNTASTIC_HOME}/checkstyle
ADD https://github.com/checkstyle/checkstyle/releases/download/checkstyle-"${CHECKSTYLE_VERSION}"/checkstyle-"${CHECKSTYLE_VERSION}"-all.jar ${CHECKSTYLE_HOME}/checkstyle-all.jar
ADD https://raw.githubusercontent.com/checkstyle/checkstyle/master/src/main/resources/google_checks.xml ${CHECKSTYLE_HOME}/
ENV CHECKSTYLE_JAR=${CHECKSTYLE_HOME}/checkstyle-all.jar \
    CHECKSTYLE_CONFIG=${CHECKSTYLE_HOME}/google_checks.xml

# Install Checkpatch
ARG CHECKPATCH_HOME=${SYNTASTIC_HOME}/checkpatch
ADD https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl ${CHECKPATCH_HOME}/
RUN chmod +x "${CHECKPATCH_HOME}"/checkpatch.pl
ENV PATH=${CHECKPATCH_HOME}:$PATH

# Install google-java-format
ARG GOOGLE_JAVA_FORMAT_VERSION=1.7
ARG GOOGLE_JAVA_FORMAT_HOME=${SYNTASTIC_HOME}/google-java-format
ENV GOOGLE_JAVA_FORMAT_JAR=${GOOGLE_JAVA_FORMAT_HOME}/google-java-format-all-deps.jar
ADD https://github.com/google/google-java-format/releases/download/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}-all-deps.jar ${GOOGLE_JAVA_FORMAT_JAR}

# Install hadolint (for Dockerfile)
ARG HADOLINT_VERSION=1.17.3
ARG HADOLINT_HOME=${SYNTASTIC_HOME}/hadolint
ADD https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 ${HADOLINT_HOME}/hadolint
RUN chmod +x "${HADOLINT_HOME}"/hadolint
ENV PATH=${HADOLINT_HOME}:$PATH

# Install Bear to support C-family semantic completion used by YouCompleteMe
ARG BEAR_VERSION=2.4.2
ARG BEAR_SRC=${SYNTASTIC_HOME}/Bear-${BEAR_VERSION}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# See how to do an out of source build
#   https://stackoverflow.com/a/20611964
#   https://stackoverflow.com/a/24435795
RUN curl -fsSL https://codeload.github.com/rizsotto/Bear/tar.gz/"${BEAR_VERSION}" | tar -xz -C "${SYNTASTIC_HOME}" \
    && cmake -B"${BEAR_SRC}" -H"${BEAR_SRC}" \
    && make -C "${BEAR_SRC}" install \
    && rm -rf "${BEAR_SRC}"

# Clean Up
RUN rm -rf /tmp/* /var/tmp/*


CMD ["vim"]
