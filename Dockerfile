FROM h3poteto/phoenix-node:1.7.3-10.15.0

USER root

COPY . ${APP_DIR}

RUN chown -R elixir:elixir ${APP_DIR}
RUN set -x \
  && curl -fsSL https://github.com/minamijoyo/myaws/releases/download/v0.3.0/myaws_v0.3.0_linux_amd64.tar.gz \
  | tar -xzC /usr/local/bin && chmod +x /usr/local/bin/myaws

USER elixir

ENV MIX_ENV=prod

ENV PATH=$PATH:~/.mix/escripts

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN mix deps.compile
RUN mix compile

RUN mix escript.install github h3poteto/ecs_erlang_cluster --force

RUN cd assets \
  && npm install \
  && npm run compile \
  && rm -rf node_modules

RUN mix phx.digest

EXPOSE 8080:8080

ENTRYPOINT ["./entrypoint.sh"]

# CMD iex --name $ONESELF --erl "-config sys.config" -S mix phx.server
CMD mix phx.server
