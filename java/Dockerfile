# VERSION 1.0

FROM openjdk:alpine
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

CMD ["vim"]
