FROM ubuntu

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common && \
	DEBIAN_FRONTEND=noninteractive apt-get -y install \
		build-essential \
		fish \
		nodejs \
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
		libuv1-dev && \
	apt-get clean && \
	apt-get auto-remove -y && \
	rm -rf /var/cache/apt/* && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/* && \
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 \
		--slave /usr/bin/g++ g++ /usr/bin/g++-10 \
		--slave /usr/bin/gcov gcov /usr/bin/gcov-10


WORKDIR /devel
RUN git clone https://github.com/xkubov/.home \
	&& cd .home \
	&& make gitc \
	&& make vimc


ENTRYPOINT /bin/bash
