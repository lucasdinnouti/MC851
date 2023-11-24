FROM debian:bullseye-slim as riscv-gnu-toolchain

RUN apt update
RUN apt install -y git
RUN apt install -y autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev ninja-build

RUN git clone https://github.com/riscv/riscv-gnu-toolchain
WORKDIR riscv-gnu-toolchain
RUN ./configure --prefix=/opt/riscv --with-arch=rv32imac --with-abi=ilp32
RUN make

ENV PATH="$PATH:/opt/riscv/bin"