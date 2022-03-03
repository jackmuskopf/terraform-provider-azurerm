FROM golang:1.17.7-bullseye

ENV GOPATH=/go
ENV PROVIDER_DIRECTORY=${GOPATH}/src/github.com/hashicorp/terraform-provider-azurerm

WORKDIR ${PROVIDER_DIRECTORY}

RUN mkdir -p ${PROVIDER_DIRECTORY}
COPY . ${PROVIDER_DIRECTORY}

RUN apt-get update -y && apt-get install dos2unix -y
RUN find ./scripts -type f -print0 | xargs -0 dos2unix

RUN make tools fmt build

CMD make acctests SERVICE='eventgrid' TESTARGS='-run=TestAccEventGridSystemTopicEventSubscription_basic' TESTTIMEOUT='60m'