FROM debian:bookworm-slim
ARG NVIM_VERSION=nightly
ARG NVIM_RELEASE_ASSET=nvim-linux-x86_64.tar.gz
ARG FZF_VERSION=0.65.1
# COPY --from=denoland/deno:bin-2.0.6 /deno /usr/local/bin/deno
RUN apt-get update \
 && apt-get -y install build-essential git curl

# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${NVIM_RELEASE_ASSET} \
 && tar -C /opt -zxf ${NVIM_RELEASE_ASSET}
ENV PATH="/opt/nvim-linux-x86_64/bin:${PATH}"

# Install fzf
RUN curl -L -o fzf.tar.gz https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz \
 && tar -C /usr/local/bin -zxf fzf.tar.gz \
 && rm fzf.tar.gz

# LSP
## Tools
RUN apt-get -y install unzip
## go
# RUN apt-get -y install golang-go
ENV GO_VERSION=1.24.6
RUN curl -L -o go.tar.gz https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
 && tar -C /opt -zxf go.tar.gz
ENV PATH="/opt/go/bin:${PATH}"
## npm
RUN apt-get -y install nodejs npm

CMD ["/bin/bash"]
