FROM postgis/postgis:15-3.3


RUN apt-get update && \
    apt-get install -y bison clang curl flex gcc git zlib1g zlib1g-dev \
    pkg-config make libssl-dev libreadline-dev postgresql-server-dev-15
RUN apt-get update && \
    apt-get install -y osm2pgsql


RUN curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN cargo install cargo-pgrx
RUN cargo pgrx init --pg15=/usr/lib/postgresql/15/bin/pg_config
# Загрузка ZomboDB
RUN git clone https://github.com/zombodb/zombodb.git
RUN cd zombodb && cargo pgrx install --release
# Загрузка ZomboDB

COPY ./init /docker-entrypoint-initdb.d/