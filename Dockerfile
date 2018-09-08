# VERSION 1.2

FROM openjdk:8-jdk-slim-stretch
LABEL maintainer="Jianshen Liu <jliu120@ucsc.edu>"

# perl for Checkpatch (syntax checking for C)
# gcc for syntax checking of c
# g++ for syntax checking of c++
# python3-pip, python3-setuptools and python3-wheel
#    are used for installing/building python packages (e.g. jsbeautifier, flake8)
# cppcheck for syntax checking of c and c++
# exuberant-ctags for Vim plugin Tagbar (https://github.com/majutsushi/tagbar#dependencies)
# clang-format is used by plugin google/vim-codefmt
# python3-dev is required to build typed-ast, which is required by jsbeautifier
# python-dev, cmake and build-essential are used for compiling YouCompleteMe(YCM)
#     with semantic support in the following command:
#     /bin/sh -c /root/.vim/bundle/YouCompleteMe/install.py

## shellcheck for syntax checking of sh
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        vim-nox \
        git \
        perl \
        g++ \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        cppcheck \
        exuberant-ctags \
        clang-format \
        python-dev \
        python3-dev \
        build-essential \
        cmake \
        shellcheck \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /root

# Install Vundle and Plugins
COPY .vimrc .
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
    && vim +PluginInstall +qall \
    && sed -i 's/"#//g' .vimrc

ENV TERM xterm-256color


# Install js-beautify as the JSON Formatter for plugin google/vim-codefmt
# Install bandit, flake8, pycodestyle and pydocstyle as the syntax checkers
#     for Python3 used in plugin vim-syntastic/syntastic
# Install mypy as the syntax checkers for Python3 used in plugin vim-syntastic/syntastic
# pylint is a code linter for Python used by plugin vim-syntastic/syntastic
RUN pip3 install jsbeautifier \
                 flake8 \
                 mypy \
                 bandit \
                 pylint \
                 pycodestyle \
                 pydocstyle \
                 yamllint

# Compiling YouCompleteMe(YCM) with semantic support for Jave and C-family languages
RUN /root/.vim/bundle/YouCompleteMe/install.py --clang-completer --java-completer


# Install various checkers for plugin vim-syntastic/syntastic

ENV SYNTASTIC_HOME /root/.vim/syntastic
RUN mkdir "$SYNTASTIC_HOME"

# Install Checkstyle (for Java)
ENV CHECKSTYLE_VERSION=8.12 \
    CHECKSTYLE_HOME=${SYNTASTIC_HOME}/checkstyle
ADD https://github.com/checkstyle/checkstyle/releases/download/checkstyle-"${CHECKSTYLE_VERSION}"/checkstyle-"${CHECKSTYLE_VERSION}"-all.jar ${CHECKSTYLE_HOME}/
ADD https://raw.githubusercontent.com/checkstyle/checkstyle/master/src/main/resources/google_checks.xml ${CHECKSTYLE_HOME}/
ENV CHECKSTYLE_JAR=${CHECKSTYLE_HOME}/checkstyle-${CHECKSTYLE_VERSION}-all.jar \
    CHECKSTYLE_CONFIG=${CHECKSTYLE_HOME}/google_checks.xml

# Install Checkpatch
ENV CHECKPATCH_HOME=${SYNTASTIC_HOME}/checkpatch
ADD https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl ${CHECKPATCH_HOME}/
RUN chmod +x "${CHECKPATCH_HOME}"/checkpatch.pl
ENV PATH=${CHECKPATCH_HOME}:$PATH

# Install google-java-format
ENV GOOGLE_JAVA_FORMAT_VERSION=1.6 \
    GOOGLE_JAVA_FORMAT_HOME=${SYNTASTIC_HOME}/google-java-format
ENV GOOGLE_JAVA_FORMAT_JAR=${GOOGLE_JAVA_FORMAT_HOME}/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}-all-deps.jar
ADD https://github.com/google/google-java-format/releases/download/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}-all-deps.jar ${GOOGLE_JAVA_FORMAT_HOME}/

# Install hadolint (for Dockerfile)
ENV HADOLINT_VERSION=1.12.0 \
    HADOLINT_HOME=${SYNTASTIC_HOME}/hadolint
ADD https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 ${HADOLINT_HOME}/hadolint
RUN chmod +x "${HADOLINT_HOME}"/hadolint
ENV PATH=${HADOLINT_HOME}:$PATH


# Clean Up
RUN rm -rf /tmp/* /var/tmp/*


CMD ["vim"]
