FROM debian:9.12-slim AS base

ARG kmachine_url=git@github.com:enochlam/kmachine.git

RUN passwd -d root
RUN useradd -s /bin/bash -U -m kmachine

ENV QHOME=/opt/kmachine/q
ENV QPORT=3000

EXPOSE ${QPORT}

RUN apt-get update \
        && apt-get install --no-install-recommends --no-install-suggests -y ca-certificates ssh git \
        && update-ca-certificates \
        && mkdir -p $QHOME

WORKDIR ${QHOME}

COPY q/ .

RUN git clone https://github.com/KxSystems/kdb-tick.git \
  && chown -R kmachine:kmachine $QHOME

WORKDIR ${QHOME}/kdb-tick

COPY src/q/sym.q tick/

USER kmachine
CMD $QHOME/l64/q tick.q sym /var/tmp -p $QPORT
