FROM elixir:1.6.4
MAINTAINER Saúl Cabrera <saulecabrera@gmail.com>

RUN apt-get update

COPY [".", "/app"]

RUN mix local.hex --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new-1.3.3.ez

WORKDIR /app
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -E
RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN apt-get install -y inotify-tools
RUN mix deps.get

WORKDIR /assets
RUN npm install

WORKDIR ../app
EXPOSE 4000

CMD ["mix", "phx.server"]
