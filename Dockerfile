FROM debian:bookworm-slim
ARG NVIM_VERSION=0.10.2
ARG FZF_VERSION=0.56.3
# COPY --from=denoland/deno:bin-2.0.6 /deno /usr/local/bin/deno
RUN apt-get update \
 && apt-get -y install build-essential git curl

# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux64.tar.gz \
 && tar -C /opt -zxf nvim-linux64.tar.gz
ENV PATH="/opt/nvim-linux64/bin:${PATH}"

# Install fzf
RUN curl -L -o fzf.tar.gz https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz \
 && tar -C /usr/local/bin -zxf fzf.tar.gz

# LSP
## Tools
RUN apt-get -y install unzip
## go
# RUN apt-get -y install golang-go
ENV GO_VERSION=1.23.3
RUN curl -L -o go.tar.gz https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
 && tar -C /opt -zxf go.tar.gz
ENV PATH="/opt/go/bin:${PATH}"
## npm
RUN apt-get -y install nodejs npm
