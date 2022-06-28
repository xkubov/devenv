FROM ubuntu

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common && \
	DEBIAN_FRONTEND=noninteractive apt-get -y install \
		build-essential \
		wget \
		fish \
		autoconf \
		automake \
		libtool \
		m4 \
		zlib1g-dev \
		doxygen \
		graphviz \
		neovim \
		cmake \
		ninja-build \
		git \
		python3 \
		python3-dev \
		python3-pip \
		pybind11-dev \
		locales \
		pkg-config \
		libboost-dev \
		libssl-dev \
		gcc-10 \
		g++-10 \
		libjsoncpp-dev \
		openssl \
		libcurl4-openssl-dev \
		zlib1g-dev \
		libmagic-dev \
		libcapstone-dev \
		liblz4-dev \
		libbz2-dev \
		libzip-dev \
		libxxhash-dev \
		tmux \
		curl \
		sudo \
		ripgrep \
		exa \
		fzf \
		libsasl2-dev \
		libffi-dev \
		libuv1-dev && \
	apt-get clean && \
	apt-get auto-remove -y && \
	rm -rf /var/cache/apt/* && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/* && \
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 \
		--slave /usr/bin/g++ g++ /usr/bin/g++-10 \
		--slave /usr/bin/gcov gcov /usr/bin/gcov-10

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install yarn nodejs


RUN useradd -rm -p `openssl passwd -1 devel` -d /home/devel -s /bin/fish -g root -G sudo -u 1001 devel


WORKDIR /devel
RUN chown -R devel /devel

USER devel
WORKDIR /home/devel

RUN git clone https://github.com/xkubov/.home \
	&& cd .home \
	&& make gitc \
	&& make vimc

RUN curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install -o /tmp/install.fish && fish /tmp/install.fish --noninteractive
RUN fish -c "omf install bobthefish"
RUN fish -c "omf install pyenv"

RUN cd /home/devel/.vim/bundle/coc.nvim && yarn install

RUN vim +'CocInstall -sync coc-pyright' +qal && \
	vim +'CocInstall -sync coc-json' +qal && \
	vim +'CocInstall -sync coc-tsserver' +qal

# Use the pre-selected pyenv directory.
ENV PYENV_ROOT="/home/devel/.pyenv"

ENV PATH="/home/devel/.pyenv/bin:$PATH"

entrypoint ["python3", "-m", "http.server", "80"]
