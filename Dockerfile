FROM ruby:3.0

# Set the working directory
WORKDIR /app

RUN apt-get update && apt-get install -y net-tools

RUN gem install bundler

# Copy the Gemfile and Gemfile.lock into the image
COPY Gemfile Gemfile.lock ./

# Install the gems
RUN bundle install

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /rustup.sh \
    && chmod +x /rustup.sh \
    && /rustup.sh -y --default-toolchain nightly --no-modify-path \
    && rm /rustup.sh
RUN echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> /root/.bashrc

# 一回ビルドしておく
WORKDIR /app/rust
COPY ./rust/ .
RUN /root/.cargo/bin/cargo run --release
RUN /root/.cargo/bin/cargo run --release
WORKDIR /app

# entrypoint
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 9292
