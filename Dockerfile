FROM ghcr.io/h3poteto/elixir-node:1.14.5-node18-slim

USER root

RUN apt-get update && \
    apt-get install -y imagemagick

COPY . ${APP_DIR}

RUN chown -R elixir:elixir ${APP_DIR}

USER elixir

ENV MIX_ENV=prod

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN mix deps.compile
RUN mix compile

RUN cd assets \
  && npm install \
  && npm run compile \
  && rm -rf node_modules

RUN mix phx.digest

EXPOSE 8080:8080

ENTRYPOINT ["./entrypoint.sh"]

CMD mix phx.server
