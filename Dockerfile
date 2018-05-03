# VERSION 1.1

FROM openjdk:8-jdk-slim-stretch
MAINTAINER Jianshen Liu <jliu120@ucsc.edu>

# perl for Checkpatch (syntax checking for C)
# gcc for syntax checking of c
# g++ for syntax checking of c++
# python-pip, python3-pip, python-setuptools, python3-setuptools, python-wheel are used for installing/building python packages (e.g. jsbeautifier, flake8)
# cppcheck for syntax checking of c and c++
# exuberant-ctags for Vim plugin Tagbar (https://github.com/majutsushi/tagbar#dependencies)
# clang-format is used by plugin google/vim-codefmt

# python-dev, cmake and build-essential are used for compiling (YouCompleteMe)YCM with semantic support in the following command:
#   /bin/sh -c /root/.vim/bundle/YouCompleteMe/install.py
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    vim-nox \
    git \
    perl \
    g++ \
    python-pip \
    python3-pip \
    python-setuptools \
    python3-setuptools \
    python-wheel \
    cppcheck \
    exuberant-ctags \
    clang-format \
    python-dev \
    build-essential \
    cmake


WORKDIR /root

# Install Vundle and Plugins
COPY .vimrc .
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
    && vim +PluginInstall +qall \
    && sed -i 's/"#//g' .vimrc

ENV TERM xterm-256color


# Install js-beautify as the JSON Formatter for plugin google/vim-codefmt
# Install bandit and flake8 as the syntax checkers for python used in plugin vim-syntastic/syntastic
RUN pip install jsbeautifier \
                bandit \
                flake8

# We want flake not only works for Python 2.7 but also Python 3.5.
# See the installation requirement http://flake8.pycqa.org/en/latest/#installation
RUN pip3 install flake8

# Compiling YouCompleteMe(YCM) with semantic support for C-family languages
RUN /root/.vim/bundle/YouCompleteMe/install.py --clang-completer


# Install various checkers for plugin vim-syntastic/syntastic

ENV SYNTASTIC_HOME /root/.vim/syntastic
RUN mkdir "$SYNTASTIC_HOME"

# Install Checkstyle (for Java)
ENV CHECKSTYLE_VERSION=8.9 \
    CHECKSTYLE_HOME=${SYNTASTIC_HOME}/checkstyle
COPY checkstyle-${CHECKSTYLE_VERSION}-all.jar ${CHECKSTYLE_HOME}/
ADD https://raw.githubusercontent.com/checkstyle/checkstyle/master/src/main/resources/google_checks.xml ${CHECKSTYLE_HOME}/
ENV CHECKSTYLE_JAR=${CHECKSTYLE_HOME}/checkstyle-${CHECKSTYLE_VERSION}-all.jar \
    CHECKSTYLE_CONFIG=${CHECKSTYLE_HOME}/google_checks.xml

# Install Checkpatch
ENV CHECKPATCH_HOME=${SYNTASTIC_HOME}/checkpatch
ADD https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl ${CHECKPATCH_HOME}/
RUN chmod +x "${CHECKPATCH_HOME}"/checkpatch.pl
ENV PATH=${CHECKPATCH_HOME}:$PATH

# Install google-java-format
ENV GOOGLE_JAVA_FORMAT_VERSION=1.5 \
    GOOGLE_JAVA_FORMAT_HOME=${SYNTASTIC_HOME}/google-java-format
ENV GOOGLE_JAVA_FORMAT_JAR=${GOOGLE_JAVA_FORMAT_HOME}/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}-all-deps.jar
ADD https://github.com/google/google-java-format/releases/download/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}-all-deps.jar ${GOOGLE_JAVA_FORMAT_HOME}/

# Install hadolint (for Dockerfile)
ENV HADOLINT_VERSION=1.6.2 \
    HADOLINT_HOME=${SYNTASTIC_HOME}/hadolint
ADD https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 ${HADOLINT_HOME}/hadolint
RUN chmod +x "${HADOLINT_HOME}"/hadolint
ENV PATH=${HADOLINT_HOME}:$PATH

# Install ShellCheck (for sh)
ENV SHELLCHECK_HOME=${SYNTASTIC_HOME}/shellcheck
RUN mkdir "$SHELLCHECK_HOME" && \
    curl -fsSL https://storage.googleapis.com/shellcheck/shellcheck-latest.linux.x86_64.tar.xz | tar -xJ -C "${SHELLCHECK_HOME}" --strip 1
ENV PATH=${SHELLCHECK_HOME}:$PATH


# Clean Up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


CMD ["vim"]
