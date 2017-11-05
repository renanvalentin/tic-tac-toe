FROM elixir:latest

MAINTAINER Renan Valentin <valentin.renan@gmail.com>

RUN mix local.hex --force

WORKDIR /app

COPY mix.exs mix.lock ./
RUN mix deps.get
COPY config ./config
RUN mix deps.compile

COPY . /app

RUN mix escript.build