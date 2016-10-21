FROM h3poteto/phoenix:latest

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

RUN npm install \
  && npm run compile \
  && rm -rf node_modules

RUN mix phoenix.digest
RUN mix release

CMD rel/seiyu_watch/bin/seiyu_watch foreground
