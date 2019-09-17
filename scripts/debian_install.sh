#!/usr/bin/env bash

set -eu -o pipefail

ID_LIKE=$(awk -F'=' '$1 == "ID_LIKE" { gsub("\"", "", $2); print $2 }' /etc/os-release)
family=$(echo "$ID_LIKE" | tr '[:upper:]' '[:lower:]')
if [[ "$family" != "debian" ]]; then
  echo >&2 "Operation aborted because the current OS is not a Debian-based distribution."
  exit 1
fi

jdk_pkgs=()
# javac is used for syntastic checker for .java file
if ! hash javac 2> /dev/null; then
  jdk_pkgs=(openjdk-8-jdk openjdk-8-jre-headless)
fi

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
#     /bin/sh -c $HOME/.vim/bundle/YouCompleteMe/install.py
# libffi-dev and libssl-dev is required to build ansible-lint

## shellcheck for syntax checking of sh
sudo apt-get update && sudo apt-get install -y --no-install-recommends \
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
  clang-format \
  python-dev \
  python3-dev \
  build-essential \
  cmake \
  libffi-dev \
  libssl-dev \
  shellcheck \
  "${jdk_pkgs[*]:-}" &&
  sudo apt-get clean &&
  sudo rm -rf /var/lib/apt/lists/*

# Get the full directory name of the current script
# See https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install Vundle and Plugins
cp "${SCRIPT_DIR}"/../.vimrc "$HOME"
rm -rf "${HOME}"/.vim/bundle/Vundle.vim &&
  git clone https://github.com/VundleVim/Vundle.vim.git "${HOME}"/.vim/bundle/Vundle.vim &&
  vim +PluginClean! +PluginInstall! +qall &&
  sed -i 's/"#//g' "$HOME"/.vimrc

# make folder to persistent undo used by plugin mbbill/undotree
mkdir -p "$HOME"/.undodir

# Remove the old exported envs first
sed -i '/ljishen\/my-vim/,/#### END ####/d' "$HOME"/.profile

# Delete all trailing blank lines at end of file
#   http://sed.sourceforge.net/sed1line.txt
sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$HOME"/.profile

printf "\\n\\n#### Export Variables for Vim Plugins (https://github.com/ljishen/my-vim) ####\\n\\n" >> "$HOME"/.profile

function export_envs() {
  if [[ -n "$1" ]]; then
    eval "export $1"
    printf "export %s\\n" "$1" >> "$HOME"/.profile
  fi
}

# If TERM is already set by tmux/screen then we do not overwrite the value.
UPDATE_TERM=$(
  cat << 'SCRIPT_EOF'
if [[ -f /usr/share/terminfo/s/screen.xterm-256color ]]; then
  export TERM=screen.xterm-256color
elif [[ -f /usr/share/terminfo/x/xterm-256color ]]; then
  export TERM=xterm-256color
fi
SCRIPT_EOF
)
eval "$UPDATE_TERM"
printf "%s\\n" "$UPDATE_TERM" >> "$HOME"/.profile

# Install js-beautify as the JSON Formatter for plugin google/vim-codefmt
# Install bandit, flake8, pycodestyle and pydocstyle as the syntax checkers
#     for Python3 used in plugin vim-syntastic/syntastic
# Install mypy as the syntax checkers for Python3 used in plugin vim-syntastic/syntastic
# pylint is a code linter for Python used by plugin vim-syntastic/syntastic
# ansible-lint is a best-practices linter for Ansible playbooks used by plugin vim-syntastic/syntastic
pip3 install --upgrade \
  jsbeautifier \
  flake8 \
  mypy \
  bandit \
  pylint \
  pycodestyle \
  pydocstyle \
  ansible-lint

# Compiling YouCompleteMe(YCM) with semantic support for Java and C-family languages (through libclang and clangd)
"$HOME"/.vim/bundle/YouCompleteMe/install.py \
  --clang-completer \
  --clangd-completer \
  --java-completer

# Install various checkers for plugin vim-syntastic/syntastic

SYNTASTIC_HOME="$HOME"/.vim/syntastic
mkdir -p "$SYNTASTIC_HOME"

# Install Checkstyle (for Java)
CHECKSTYLE_VERSION=8.21
CHECKSTYLE_HOME="${SYNTASTIC_HOME}"/checkstyle
mkdir -p "${CHECKSTYLE_HOME}" &&
  curl -fsSL https://github.com/checkstyle/checkstyle/releases/download/checkstyle-"${CHECKSTYLE_VERSION}"/checkstyle-"${CHECKSTYLE_VERSION}"-all.jar -o "${CHECKSTYLE_HOME}"/checkstyle-all.jar
export_envs "CHECKSTYLE_JAR=${CHECKSTYLE_HOME}/checkstyle-all.jar"
curl -fsSL https://raw.githubusercontent.com/checkstyle/checkstyle/master/src/main/resources/google_checks.xml -o "${CHECKSTYLE_HOME}"/google_checks.xml
export_envs "CHECKSTYLE_CONFIG=${CHECKSTYLE_HOME}/google_checks.xml"

# Install Checkpatch
CHECKPATCH_HOME="${SYNTASTIC_HOME}"/checkpatch
mkdir -p "${CHECKPATCH_HOME}" &&
  curl -fsSL https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl -o "${CHECKPATCH_HOME}"/checkpatch.pl
chmod +x "${CHECKPATCH_HOME}"/checkpatch.pl
PATH="${CHECKPATCH_HOME}:$PATH"

# Install google-java-format
GOOGLE_JAVA_FORMAT_VERSION=1.7
GOOGLE_JAVA_FORMAT_HOME="${SYNTASTIC_HOME}"/google-java-format
export_envs "GOOGLE_JAVA_FORMAT_JAR=${GOOGLE_JAVA_FORMAT_HOME}/google-java-format-all-deps.jar"
mkdir -p "${GOOGLE_JAVA_FORMAT_HOME}" &&
  curl -fsSL https://github.com/google/google-java-format/releases/download/google-java-format-"${GOOGLE_JAVA_FORMAT_VERSION}"/google-java-format-"${GOOGLE_JAVA_FORMAT_VERSION}"-all-deps.jar -o "${GOOGLE_JAVA_FORMAT_JAR}"

# Install hadolint (for Dockerfile)
if [[ $(arch) == x86_64 ]]; then
  HADOLINT_VERSION=1.17.1
  HADOLINT_HOME="${SYNTASTIC_HOME}"/hadolint
  mkdir -p "${HADOLINT_HOME}" &&
    curl -fsSL https://github.com/hadolint/hadolint/releases/download/v"${HADOLINT_VERSION}"/hadolint-Linux-x86_64 -o "${HADOLINT_HOME}"/hadolint
  chmod +x "${HADOLINT_HOME}"/hadolint
  PATH="${HADOLINT_HOME}:$PATH"
fi

# Because mypy is installed to the "$HOME"/.local/bin,
#     we need to add it to the PATH if it doesn't already exist
home_local_bin="$HOME"/.local/bin
if [[ :$PATH: != *:"$home_local_bin":* ]]; then
  PATH="${home_local_bin}:$PATH"
fi

# Install Bear to support C-family semantic completion used by YouCompleteMe
BEAR_VERSION=2.4.0
curl -fsSL https://codeload.github.com/rizsotto/Bear/tar.gz/"${BEAR_VERSION}" | tar -xz -C "${SYNTASTIC_HOME}"
BEAR_SRC="${SYNTASTIC_HOME}"/Bear-"${BEAR_VERSION}"

# See how to do an out of source build
#   https://stackoverflow.com/a/20611964
#   https://stackoverflow.com/a/24435795
cmake -B"${BEAR_SRC}" -H"${BEAR_SRC}"
sudo make -C "${BEAR_SRC}" install

rm -rf "${BEAR_SRC}"

# Finally export the PATH with all the updates on this env
export_envs "PATH=$PATH"

printf "\\n#### END ####" >> "$HOME"/.profile

# Config .tmux.conf for Vim running inside tmux
tmux_conf_file="$HOME"/.tmux.conf
if [ ! -f "$tmux_conf_file" ] || ! grep -q "tmux-256color" "$tmux_conf_file"; then
  echo 'set -g default-terminal "tmux-256color"' >> "$tmux_conf_file"
fi

printf "\\nInstallation complete successfully. Please log out and login to apply the environment variable updates.\\n"
