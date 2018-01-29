#!/usr/bin/env bash

set -eu

ID=$( grep -oP '^ID=\K\w+' /etc/os-release 2> /dev/null )
os=$( echo "$ID" | tr '[:upper:]' '[:lower:]' )
if [ "$os" != "ubuntu" ] && [ "$os" != "debian" ]; then
    echo "Operation aborted because the current OS is not a Debian-based distribution."
    exit 0
fi

install_jdk=false
# javac is used for syntastic checker for .java file
if hash javac 2>/dev/null; then
    install_jdk=true
fi

# perl for Checkpatch (syntax checking for C)
# gcc for syntax checking of c
# g++ for syntax checking of c++
# python-pip, python-setuptools, python-wheel are used for installing/building python packages (e.g. jsbeautifier)
# cppcheck for syntax checking of c and c++
# exuberant-ctags for Vim plugin Tagbar (https://github.com/majutsushi/tagbar#dependencies)
# clang-format is used by plugin google/vim-codefmt

# python-dev, cmake and build-essential are used for compiling (YouCompleteMe)YCM with semantic support in the following command:
#   /bin/sh -c $HOME/.vim/bundle/YouCompleteMe/install.py
sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    curl \
    vim-nox \
    git \
    perl \
    g++ \
    python-pip \
    python-setuptools \
    python-wheel \
    cppcheck \
    exuberant-ctags \
    clang-format \
    python-dev \
    build-essential \
    cmake \
    $( if [ "$install_jdk" = true ]; then echo "openjdk-8-jdk"; fi )

sudo apt-get clean


# Get the full directory name of the current script
# See https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Install Vundle and Plugins
cp "${SCRIPT_DIR}"/../.vimrc "$HOME"
rm -rf "${HOME}"/.vim/bundle/Vundle.vim && \
    git clone https://github.com/VundleVim/Vundle.vim.git "${HOME}"/.vim/bundle/Vundle.vim && \
    vim +PluginInstall +qall && \
    sed -i 's/"#//g' "$HOME"/.vimrc

function export_envs {
    export $1
    echo "export $1" >> $HOME/.profile
}

export_envs "TERM=xterm-256color"


# Install js-beautify as the JSON Formatter for plugin google/vim-codefmt
# Install bandit and flake8 as the syntax checkers for python used in plugin vim-syntastic/syntastic
pip install jsbeautifier \
            bandit \
            flake8


# Compiling YouCompleteMe(YCM) with semantic support for C-family languages
"$HOME"/.vim/bundle/YouCompleteMe/install.py --clang-completer


# Install various checkers for plugin vim-syntastic/syntastic

export_envs "SYNTASTIC_HOME=$HOME/.vim/syntastic"
mkdir -p "$SYNTASTIC_HOME"

# Install Checkstyle (for Java)
export_envs "CHECKSTYLE_VERSION=8.7 \
             CHECKSTYLE_HOME=${SYNTASTIC_HOME}/checkstyle"
mkdir -p "${CHECKSTYLE_HOME}" && cp "${SCRIPT_DIR}"/../checkstyle-${CHECKSTYLE_VERSION}-all.jar "${CHECKSTYLE_HOME}"/
curl -fsSL https://raw.githubusercontent.com/checkstyle/checkstyle/master/src/main/resources/google_checks.xml -o "${CHECKSTYLE_HOME}"/google_checks.xml
export_envs "CHECKSTYLE_JAR=${CHECKSTYLE_HOME}/checkstyle-${CHECKSTYLE_VERSION}-all.jar \
             CHECKSTYLE_CONFIG=${CHECKSTYLE_HOME}/google_checks.xml"

# Install Checkpatch
export_envs "CHECKPATCH_HOME=${SYNTASTIC_HOME}/checkpatch"
mkdir -p "${CHECKPATCH_HOME}" && \
    curl -fsSL https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl -o "${CHECKPATCH_HOME}"/checkpatch.pl
chmod +x "${CHECKPATCH_HOME}"/checkpatch.pl
export_envs "PATH=${CHECKPATCH_HOME}:$PATH"

# Install google-java-format
export_envs "GOOGLE_JAVA_FORMAT_VERSION=1.5 \
             GOOGLE_JAVA_FORMAT_HOME=${SYNTASTIC_HOME}/google-java-format"
export_envs "GOOGLE_JAVA_FORMAT_JAR=${GOOGLE_JAVA_FORMAT_HOME}/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}-all-deps.jar"
mkdir -p "${GOOGLE_JAVA_FORMAT_HOME}" && \
    curl -fsSL https://github.com/google/google-java-format/releases/download/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}/google-java-format-${GOOGLE_JAVA_FORMAT_VERSION}-all-deps.jar -o "${GOOGLE_JAVA_FORMAT_JAR}"

# Install hadolint (for Dockerfile)
export_envs "HADOLINT_VERSION=1.3.0 \
             HADOLINT_HOME=${SYNTASTIC_HOME}/hadolint"
mkdir -p "${HADOLINT_HOME}" && \
    curl -fsSL https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 -o "${HADOLINT_HOME}"/hadolint
chmod +x "${HADOLINT_HOME}"/hadolint
export_envs "PATH=${HADOLINT_HOME}:$PATH"

# Install ShellCheck (for sh)
export_envs "SHELLCHECK_HOME=${SYNTASTIC_HOME}/shellcheck"
mkdir -p "${SHELLCHECK_HOME}" && \
    curl -fsSL https://storage.googleapis.com/shellcheck/shellcheck-latest.linux.x86_64.tar.xz | tar -xJ -C "${SHELLCHECK_HOME}" --strip 1
export_envs "PATH=${SHELLCHECK_HOME}:$PATH"

printf "\\nInstallation completed successfully.\\n"
