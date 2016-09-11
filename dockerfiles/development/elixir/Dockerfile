FROM elixir:1.3.2-slim

RUN set -x && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  mysql-client \
  nodejs \
  npm \
  inotify-tools \
  git \
  curl && \
  rm -rf /var/lib/apt/lists/* && \
  npm cache clean && \
  npm install n -g && \
  n stable && \
  ln -sf /usr/local/bin/node /usr/bin/node && \
  apt-get purge -y nodejs npm

RUN useradd -m -s /bin/bash elixir
RUN echo 'elixir:password' | chpasswd
RUN mkdir -p /var/opt/app

USER elixir

WORKDIR /var/opt/app

RUN set -x && \
  yes | mix local.hex && \
  yes | mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez

CMD ["/bin/bash"]
