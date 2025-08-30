FROM debian:latest


ARG JELLYFIN_FFMPEG_VERSION=7.1.1-7

RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && arch="$(dpkg --print-architecture)" \
    && case "$arch" in \
    amd64) jf_arch="linux64" ;; \
    arm64) jf_arch="linuxarm64" ;; \
    *) echo "Unsupported architecture: $arch" >&2; exit 1 ;; \
    esac \
    && url="https://github.com/jellyfin/jellyfin-ffmpeg/releases/download/v${JELLYFIN_FFMPEG_VERSION}/jellyfin-ffmpeg_${JELLYFIN_FFMPEG_VERSION}_portable_${jf_arch}-gpl.tar.xz" \
    && echo "Downloading $url" \
    && curl -fsSL "$url" -o /tmp/jf-ffmpeg.tar.xz && mkdir -p /tmp/jf-ffmpeg\
    && tar -xJf /tmp/jf-ffmpeg.tar.xz -C /tmp/jf-ffmpeg \
    && ls -la /tmp/jf-ffmpeg \
    && install -m 0755 /tmp/jf-ffmpeg/ffmpeg /usr/bin/ffmpeg \
    && install -m 0755 /tmp/jf-ffmpeg/ffprobe /usr/bin/ffprobe \
    && /usr/bin/ffmpeg -version >/dev/null \
    && /usr/bin/ffprobe -version >/dev/null \
    && rm -rf /tmp/*

ENTRYPOINT ["/usr/bin/ffmpeg"]
