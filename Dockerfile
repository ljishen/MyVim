# VERSION 1.0

FROM openjdk:jre-alpine
MAINTAINER Jianshen Liu <jliu120@ucsc.edu>

# perl for Checkpatch (syntax checking for C)
# gcc for syntax checking of c
# g++ for syntax checking of c++
# cppcheck for syntax checking of c++
RUN apk --no-cache add \
    vim \
    git \
    perl \
    g++ \
    py-pip \
    cppcheck

WORKDIR /root

# Install Vundle and Plugins
COPY .vimrc .
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
    && vim +PluginInstall +qall \
    && sed -i 's/"#//g' .vimrc

ENV TERM xterm-256color


# Install js-beautify as the JSON Formatter for plugin google/vim-codefmt
RUN pip install jsbeautifier


ENV SYNTASTIC_HOME /root/.syntastic
RUN mkdir $SYNTASTIC_HOME

# Install Checkstyle (for Java)
ENV CHECKSTYLE_VERSION 8.3
ENV CHECKSTYLE_HOME ${SYNTASTIC_HOME}/checkstyle
COPY checkstyle-${CHECKSTYLE_VERSION}-all.jar ${CHECKSTYLE_HOME}/
ADD https://raw.githubusercontent.com/checkstyle/checkstyle/master/src/main/resources/google_checks.xml ${CHECKSTYLE_HOME}/

## Create ENV variables for the use in .vimrc
ENV CHECKSTYLE_JAR ${CHECKSTYLE_HOME}/checkstyle-${CHECKSTYLE_VERSION}-all.jar
ENV CHECKSTYLE_CONFIG ${CHECKSTYLE_HOME}/google_checks.xml

# Install Checkpatch
ENV CHECKPATCH_HOME ${SYNTASTIC_HOME}/checkpatch
ADD https://raw.githubusercontent.com/torvalds/linux/master/scripts/checkpatch.pl ${CHECKPATCH_HOME}/
RUN chmod +x ${CHECKPATCH_HOME}/checkpatch.pl
ENV PATH ${CHECKPATCH_HOME}:$PATH


CMD ["vim"]
