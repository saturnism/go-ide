# Copyright 2015 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang

ENV EDITOR vim
ENV SHELL zsh

RUN apt-get -q update && \
  apt-get install --no-install-recommends -y --force-yes -q \
    ca-certificates \
    zsh \
    tmux \
    curl \
    git \
    vim-nox \
    rubygems \
    build-essential \
    cmake \
    python-dev \
    && \
  apt-get clean && \
  rm /var/lib/apt/lists/*_*

RUN gem install tmuxinator

RUN go get github.com/nsf/gocode \
           golang.org/x/tools/cmd/goimports \
           github.com/rogpeppe/godef \
           golang.org/x/tools/cmd/guru \
           golang.org/x/tools/cmd/gorename \
           github.com/golang/lint/golint \
           github.com/kisielk/errcheck \
           github.com/jstemmer/gotags \
           github.com/garyburd/go-explorer/src/getool

RUN mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim && \
    git clone git://github.com/tpope/vim-sensible.git ~/.vim/bundle/vim-sensible && \
    git clone https://github.com/Valloric/YouCompleteMe ~/.vim/bundle/YouCompleteMe && \
    git clone https://github.com/garyburd/go-explorer.git ~/.vim/bundle/go-explorer && \
    git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree && \
    git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go

RUN cd ~/.vim/bundle/YouCompleteMe && git submodule update --init --recursive && ./install.sh
RUN curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | /bin/zsh || true

ADD vimrc /root/.vimrc
ADD tmuxinator /root/.tmuxinator
ADD tmux.conf /etc/tmux.conf
ADD zshrc /root/.zshrc

VOLUME ["/go/src"]

CMD ["/usr/local/bin/tmuxinator", "start", "default"]
