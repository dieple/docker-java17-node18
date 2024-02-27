FROM eclipse-temurin:17-jdk

ARG REFRESHED_AT
ENV REFRESHED_AT $REFRESHED_AT
ARG NODE_MAJOR=18

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN printf 'Package: nodejs\nPin: origin deb.nodesource.com\nPin-Priority: 1001' > /etc/apt/preferences.d/nodesource \
  && mkdir -p /etc/apt/keyrings \
  && apt-get update -qq \
  && apt-get install -qq --no-install-recommends \
    gpg \
    gpg-agent \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq \
  && apt-get install -qq --no-install-recommends \
    nodejs \
    yarn \
    unzip \
  && apt-get upgrade -qq \
  && curl --insecure -OL https://repo1.maven.org/maven2/org/sonarsource/scanner/cli/sonar-scanner-cli/5.0.1.3006/sonar-scanner-cli-5.0.1.3006.zip \
  && unzip sonar-scanner-cli-5.0.1.3006.zip \
  && mv sonar-scanner-5.0.1.3006/bin/sonar-scanner /usr/bin/sonar-scanner \
  && rm -rf  sonar-scanner* \
  && rm -rf /var/lib/apt/lists/*


