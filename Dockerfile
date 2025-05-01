# --- Builder Stage ---
FROM elixir:1.18-otp-27 as builder

# Install build dependencies
RUN apt-get update -y && apt-get install -y build-essential wget git \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Install litestream for SQLite replication
ARG LITESTREAM_VERSION=0.3.13
RUN wget https://github.com/benbjohnson/litestream/releases/download/v${LITESTREAM_VERSION}/litestream-v${LITESTREAM_VERSION}-linux-amd64.deb \
    && dpkg -i litestream-v${LITESTREAM_VERSION}-linux-amd64.deb \
    && rm litestream-v${LITESTREAM_VERSION}-linux-amd64.deb # Clean up downloaded deb

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

ENV MIX_ENV="prod"

# Install mix dependencies first to leverage Docker cache
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY priv priv
COPY lib lib
COPY assets assets

RUN mix assets.deploy

RUN mix compile

COPY config/runtime.exs config/
COPY rel rel
RUN mix release

# --- Runner Stage ---
FROM elixir:1.18-otp-27

# Install runtime dependencies
RUN apt-get update -y && \
  apt-get install -y --no-install-recommends libstdc++6 openssl libncurses5 locales ca-certificates \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"

ENV MIX_ENV="prod"

# Copy only the compiled release from the builder stage
COPY --from=builder /app/_build/${MIX_ENV}/rel/workspacefilter ./

# Copy Litestream binary and configuration from builder stage
COPY --from=builder /usr/bin/litestream /usr/bin/litestream
COPY litestream.sh /app/bin/litestream.sh
COPY config/litestream.yml /etc/litestream.yml

# Entrypoint script handles Litestream setup and starting the server
ENTRYPOINT ["/bin/bash", "/app/bin/litestream.sh"]

# Default command passed to the entrypoint script
CMD ["/app/bin/server"]
