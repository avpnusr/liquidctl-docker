FROM debian:stable-slim

COPY run.sh /run.sh

RUN apt update \
 && apt install -y python3 python3-dev python3-pip python3-setuptools python3-pkg-resources python3-hidapi python3-usb i2c-tools python3-smbus libusb-1.0.0 gcc make udev libudev-dev --no-install-recommends \
 && python3 -m pip install -U liquidctl \
 && apt remove --purge -y make gcc python3-dev libudev-dev python3-pip \
 && apt autoremove -y \
 && chmod 0700 /run.sh \
 && rm -rf /var/lib/apt/lists/*

CMD ["/run.sh"]
