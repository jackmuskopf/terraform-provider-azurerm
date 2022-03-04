FROM golang:1.17.7-bullseye

ENV GOPATH=/go
ENV PROVIDER_DIRECTORY=${GOPATH}/src/github.com/hashicorp/terraform-provider-azurerm

WORKDIR ${PROVIDER_DIRECTORY}

RUN mkdir -p ${PROVIDER_DIRECTORY}

RUN apt-get update -y && apt-get install dos2unix -y

COPY . ${PROVIDER_DIRECTORY}
RUN make tools fmt
RUN find ./scripts -type f -print0 | xargs -0 dos2unix

CMD make acctests SERVICE='eventgrid' TESTARGS='-run=TestAccEventGridSystemTopicEventSubscription_deliveryProperties' TESTTIMEOUT='60m'

# docker build -t tfazrm .
# docker run -it --env-file .\.env tfazrm bash
# docker run --rm -v ${PWD}:/go/src/github.com/hashicorp/terraform-provider-azurerm -it --env-file .env golang:1.17.7-bullseye bash