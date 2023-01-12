
FROM ghcr.io/h3poteto/elixir-node:1.12.4-node16-slim-buster

USER root

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
