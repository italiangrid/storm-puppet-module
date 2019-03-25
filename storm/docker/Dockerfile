FROM ruby:2.6

# Add Gemfile
ADD Gemfile /

# Configure to ever install a ruby gem docs then
# Install the relevant gems and cleanup after
RUN printf "gem: --no-rdoc --no-ri" >> /etc/gemrc && \
    gem install bundler

# Enable Unicode
ENV LANG C.UTF-8

# Now do the bundle install. I Split this off to minimize differences between 3 and 4
RUN bundler install --clean --system --gemfile /Gemfile

#Don't like that is sets clean in global config
RUN bundle config --delete clean

VOLUME /module

WORKDIR /module

# Our default command
CMD rm -rf Gemfile.lock && \
    rspec spec/classes/init_spec.rb --format html --out rspec_report.html && \
    rspec spec/classes/init_spec.rb --format RspecJunitFormatter --out rspec_report.xml
