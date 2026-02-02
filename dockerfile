FROM debian:bookworm-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install prerequisites
RUN apt-get update && apt-get install -y \
    curl ca-certificates gnupg2 lsb-release apt-transport-https build-essential git \
    && curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# 2. Install PHP 8.5 and extensions
# Note: Ensure PHP 8.5 is fully released in the repository; otherwise, this pulls the latest 8.x
RUN apt-get update && apt-get install -y \
    php8.5 php8.5-cli php8.5-common php8.5-gd php8.5-mysql php8.5-mbstring php8.5-xml php8.5-curl php8.5-zip \
    && apt-get clean

# 3. Install Node.js v24.13.0
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs=24.13.0-1nodesource1 \
    && npm install -g npm@latest

# 4. Pterodactyl Setup (User & Workdir)
RUN useradd -d /home/container -m container
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

# 5. Entrypoint
COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]