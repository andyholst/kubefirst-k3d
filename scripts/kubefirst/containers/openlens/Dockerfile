FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    libgtk-3-0 \
    libx11-xcb1 \
    libxtst6 \
    libnss3 \
    libasound2 \
    libxss1 \
    libgbm1 \
    libnspr4 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://downloads.k8slens.dev/keys/gpg | gpg --dearmor | tee /usr/share/keyrings/lens-archive-keyring.gpg > /dev/null

RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/lens-archive-keyring.gpg] https://downloads.k8slens.dev/apt/debian stable main" | tee /etc/apt/sources.list.d/lens.list > /dev/null

RUN apt-get update && apt-get install -y lens \
    && rm -rf /var/lib/apt/lists/*

    ENTRYPOINT ["lens-desktop"]
