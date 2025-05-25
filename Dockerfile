FROM ghcr.io/h3poteto/elixir-node:1.18.4-node22-slim as builder

USER root

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git imagemagick \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

COPY . ${APP_DIR}

RUN chown -R elixir:elixir ${APP_DIR}

USER elixir

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"

# install mix dependencies
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# compile assets
RUN cd assets \
  && npm install \
  && npm run compile \
  && rm -rf node_modules

RUN mix phx.digest


# Compile the release
RUN mix do compile, release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM debian:bookworm-slim

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales imagemagick \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# set runner ENV
ENV MIX_ENV="prod"

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /var/opt/app/_build/${MIX_ENV}/rel/seiyu_watch ./

USER nobody

CMD ["/app/bin/server"]
