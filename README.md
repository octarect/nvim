# Neovim configuration

[![CI](https://github.com/octarect/nvim/actions/workflows/ci.yml/badge.svg)](https://github.com/octarect/nvim/actions/workflows/ci.yml)

## Getting Started

### Install

To enable this config, run the following command. It makes symbolc link to the current directory in `$XDG_CONFIG_HOME`.
Make sure that another config doesn't exist in `$XDG_CONFIG_HOME`.

```bash
make install
```

## Development

### Running neovim inside a docker container

To try your config, enter to a docker container and run `nvim`:

```bash
make run
```
