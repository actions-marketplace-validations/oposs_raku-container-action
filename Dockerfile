FROM yobasystems/alpine-postgres:latest
LABEL version="1.0" maintainer="Fritz Zaucker <fritz.zaucker@oetiker.ch>"

# based on JJ Merolo's raku-container

# Environment
ENV PATH="/root/.rakudobrew/bin/../versions/moar-2019.11/install/bin:/root/.rakudobrew/bin/../versions/moar-2019.11/install/share/perl6/site/bin:/root/.rakudobrew/bin:${PATH}" \
    PKGS="curl git perl build-base openssl-dev" \
    PKGS_TMP="curl-dev linux-headers musl-dev wget" \
    ENV="/root/.profile" \
    VER="2019.11"

# Basic setup, programs and init
RUN apk update && apk upgrade \
    && apk add --no-cache $PKGS $PKGS_TMP \
    && git clone https://github.com/tadzik/rakudobrew ~/.rakudobrew \
    && echo 'eval "$(~/.rakudobrew/bin/rakudobrew init Sh)"' >> ~/.profile \
    && eval "$(~/.rakudobrew/bin/rakudobrew init Sh)"\
    && rakudobrew build moar $VER \
    && rakudobrew global moar-$VER \
    && rakudobrew build-zef\
    && zef install Linenoise App::Prove6\
    && apk del $PKGS_TMP \
    && RAKUDO_VERSION=`sed "s/\n//" /root/.rakudobrew/CURRENT` \
       rm -rf /root/.rakudobrew/${RAKUDO_VERSION}/src /root/zef \
       /root/.rakudobrew/git_reference

# Runtime
# WORKDIR /root
# ENTRYPOINT ["perl6"]

RUN mkdir /test
VOLUME /test
WORKDIR /test

# Will run this
ENTRYPOINT raku -v && zef install --deps-only --force-test . && zef test .
