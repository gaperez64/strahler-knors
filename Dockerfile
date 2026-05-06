# strahler-knor docker image.
#
# This image ships SOURCES only. The user compiles knor inside the container
# with -march=native (via scripts/compile.sh) so the binary is tuned to the
# host hardware on which it will run — important because --strpm-simd benefits
# significantly from architecture-specific vector instructions.
#
# The base image extends syntcomp_tgcc's docker_min spirit (debian:bookworm
# with the tools the SYNTCOMP harness expects) but also carries gcc and the
# few build dependencies knor needs, since compilation happens inside the
# container. After running scripts/compile.sh, scripts/knor-strpm-simd.sh
# wraps `knor --strpm-simd` and reads HOA from stdin or a local file.
FROM gcc:14.2-bookworm

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        cmake \
        make \
        flex \
        bison \
        libboost-all-dev \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/strahler-knors

# CI checks out submodules with `submodules: recursive`, so the COPY brings in
# libs/{lace,sylvan,oink,abc} as full source trees rather than empty
# submodule directories.
COPY . .

RUN chmod +x scripts/compile.sh scripts/knor-strpm-simd.sh

ENTRYPOINT ["/bin/bash"]
