ARG GO_VERSION=1.17
ARG PROTOC_GEN_VALIDATE_VERSION=v0.6.7
ARG PROTOBUF_GO_VERSION=v1.27.1

FROM golang:$GO_VERSION as builder
ARG PROTOC_GEN_VALIDATE_VERSION
ARG PROTOBUF_GO_VERSION

ENV GOOS=linux GOARCH=amd64 CGO_ENABLED=0

RUN go install "github.com/envoyproxy/protoc-gen-validate@${PROTOC_GEN_VALIDATE_VERSION}"

FROM scratch
ARG PROTOC_GEN_VALIDATE_VERSION
ARG PROTOBUF_GO_VERSION

# Runtime dependencies
LABEL "build.buf.plugins.runtime_library_versions.0.name"="github.com/envoyproxy/protoc-gen-validate"
LABEL "build.buf.plugins.runtime_library_versions.0.version"="$PROTOC_GEN_VALIDATE_VERSION"
LABEL "build.buf.plugins.runtime_library_versions.1.name"="google.golang.org/protobuf"
LABEL "build.buf.plugins.runtime_library_versions.1.version"="$PROTOBUF_GO_VERSION"

COPY --from=builder /go/bin /

ENTRYPOINT ["/protoc-gen-validate"]
