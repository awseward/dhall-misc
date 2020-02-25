FROM debian:stretch

ARG dhall_haskell_ver=1.30.0

RUN apt-get update \
 && apt-get install -y \
      bzip2 \
      git \
      wget

ENV BIN_ZIP_NAME dhall-${dhall_haskell_ver}-x86_64-linux.tar.bz2
RUN wget https://github.com/dhall-lang/dhall-haskell/releases/download/${dhall_haskell_ver}/${BIN_ZIP_NAME} \
 && tar -xjvf ./${BIN_ZIP_NAME} \
 && rm -rf ./${BIN_ZIP_NAME}

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
