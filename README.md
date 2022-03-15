![Logo](https://github.com/avpnusr/liquidctl-docker/blob/master/img/LiquidCTL-icon.png?raw=true)

**liquidctl in container with multiarch support**
===

Image is automatically updated and maintained.
Supported architectures are amd64, arm64, arm.

All kudos for [liquidctl](https://github.com/liquidctl/liquidctl) to the developers / contributors.

You can find the weekly docker build in this **[container](https://hub.docker.com/r/avpnusr/liquidctl)**

The container is intended for use with UnRAID, as this is my usecase. But it should work fine in any other environment.
I'm maintaining this repository and doing my best to add features and wishes from you.

Prerequisites
----

I highly recommend to use the following plugin for UnRAID from the [Community Applications](https://forums.unraid.net/topic/38582-plug-in-community-applications/):
- [Libvirt Hotplug USB](https://forums.unraid.net/topic/70001-libvirt-hot-plugin-usb-usb-hot-plugin-for-vms/?tab=comments#comment-640678)

Determine your USB-serial and "bus port"
---

I use this for easy detection of the serial of the USB-device, as which the AIO-cooler will be detected.
As there is no guarantee, the AIO-cooler will be mapped to the container alone, the serial explicitly addresses this device.

Also you need the "port" from the usb bus, so you can map the device to the container.

In my example this would be /sys/bus/usb/devices/**3-6.3**

![Serial Example](https://github.com/avpnusr/liquidctl-docker/blob/master/img/usb_serial.png?raw=true)

Choose fan- and pumpspeeds
---

**IMPORTANT:** in my configuration, the only temperature the container can read is the one, reported by the AIO-Cooler (NZXT Z63), which is the liquid-temperature. So all the temperature values are meant for liquid-temperature. In your configuration this can be different, so you need to check, what temperature liquidctl reads out.

As mentioned in the README from [liquidctl](https://github.com/liquidctl/liquidctl#automation-and-running-at-boot) you can choose to set a fixed fan- or pump-speed, or make it dependent on the temperature.

You set these values for the container with the variables FANSPEED and PUMPSPEED.

````
FANSPEED=75    -> will set the fanspeed fixed to 75% independently of temperature
PUMPSPEED=85    -> will set the pumpspeed fixed to 85% independently of temperature


FANSPEED=20 50 30 60 35 70 40 100   -> will set the fanspeed at 20°C to 50% | at 30°C to 60% | at 35°C 70% | at 40°C to 100%
PUMPSPEED=20 60 30 70 35 80 40 100   -> will set the pumpspeed at 20°C to 60% | at 30°C to 70% | at 35°C 80% | at 40°C to 100%
````

The speed between temperatures will be mapped linear i.e. if you set "FANSPEED=20 50 40 100" the fanspeed at 30°C will be 75%

The container logs useful information in the beginning and continues to output temperatures and fan- / pump-speeds as it runs. So consider to limit the logfile-size for the container e.g. "--log-opt max-size=5m --log-opt max-file=1"

![Docker Logs](https://github.com/avpnusr/liquidctl-docker/blob/master/img/docker_logs.png?raw=true)

Choose colors for supprted RGB hardware
---

liquidctl is able to set colors for supported hardware-types find the syntax and supported types at the [liquidctl project](https://github.com/liquidctl/liquidctl).

To keep it simple and flexible for users of the container, there is the **COLORSPEC** variable.
You can specify what color setting you wish on what device, in fact it's a wildcard that lets you define a custom liquidctl setting.

````
COLORSPEC=--match gigabyte set sync color fixed ffffff
````

In my case this sets the color for the RGB-LEDs on my motherboard to white.
You can customise the variable to your needs, so it controls the color of the devices you wish.

Start your container
-----

You can add the container via the "Docker" tab in your UnRAID:

![Add Docker UnRAID](https://github.com/avpnusr/liquidctl-docker/blob/master/img/add_container_unraid.PNG?raw=true)

Or via command-line:

````
docker run -d \
  --device /sys/bus/usb/devices/<your-device-id> \
  --privileged \
  -e MATCH=<aio-vendor or aio-name e.g. corsair / nzxt>
  -e PUMPSPEED=<your-pumpspeed>
  -e FANSPEED=<your-fanspeed>
  -e COLORSPEC=<color-settings>
  --restart=unless-stopped avpnusr/liquidctl
