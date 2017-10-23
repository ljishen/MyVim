# VERSION 1.0

FROM openjdk:jre-alpine
MAINTAINER Jianshen Liu <jliu120@ucsc.edu>

RUN apk --no-cache add \
    vim \
    git

WORKDIR /root

# Install Vundle and Plugins
COPY .vimrc .
RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim \
    && vim +PluginInstall +qall \
    && sed -i 's/"#//g' .vimrc

ENV TERM=xterm-256color

# Install Checkstyle (for Java)
ENV CHECKSTYLE_VERSION=8.3
ENV CHECKSTYLE_HOME=/root/checkstyle
COPY checkstyle-${CHECKSTYLE_VERSION}-all.jar ${CHECKSTYLE_HOME}/
ADD https://raw.githubusercontent.com/checkstyle/checkstyle/master/src/main/resources/google_checks.xml ${CHECKSTYLE_HOME}/

## Create ENV variables for the use in .vimrc
ENV CHECKSTYLE_JAR=${CHECKSTYLE_HOME}/checkstyle-${CHECKSTYLE_VERSION}-all.jar
ENV CHECKSTYLE_CONFIG=${CHECKSTYLE_HOME}/google_checks.xml

CMD ["vim"]
