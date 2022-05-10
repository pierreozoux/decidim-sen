FROM ruby:2.6.5

ENV RAILS_ENV=production
ENV SECRET_KEY_BASE=dummy

# Install NodeJS
RUN curl https://deb.nodesource.com/setup_15.x | bash && \
     apt install -y nodejs && \
     curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
     echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
     apt update && \
     apt install -y yarn && \
     apt install -y libicu-dev postgresql-client && \
     npm install -g npm@6.3.0 && \
     gem install bundler:2.2.17

COPY Gemfile* .
RUN bundle install

ADD . /app
WORKDIR /app

RUN bundle exec rails assets:precompile

# Configure endpoint.
COPY ./entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
