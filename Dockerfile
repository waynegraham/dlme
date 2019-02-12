# This image's actual base image
FROM starefossen/ruby-node:2-10

LABEL maintainer="Aaron Collier <aaron.collier@stanford.edu>"

# Set default RAILS environment
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true

# Create and set the working directory as /opt
WORKDIR /opt

# Copy the Gemfile and Gemfile.lock, and run bundle install prior to copying all source files
# This is an optimization that will prevent the need to re-run bundle install when only source
# code is changed and not dependencies.
COPY Gemfile /opt
COPY Gemfile.lock /opt

RUN bundle install

COPY . .
# Start the server by default, listening for all connections
CMD puma -C config/puma.rb