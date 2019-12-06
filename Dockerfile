FROM jjmerelo/alpine-perl6:latest
LABEL version="1.0" maintainer="Fritz Zaucker <fritz.zaucker@oetiker.ch>"

RUN apk add build-base openssl-dev
# Set up dirs

ENV PATH="/root/.rakudobrew/versions/moar-2019.11/install/bin:/root/.rakudobrew/versions/moar-2019.11/install/share/perl6/site/bin:/root/.rakudobrew/bin:${PATH}"
RUN mkdir /test
VOLUME /test
WORKDIR /test


# Will run this
ENTRYPOINT raku -v && zef install --deps-only . && zef test .
