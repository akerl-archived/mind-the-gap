mind-the-gap / shopping
==================

The first requirement for an airgapped system is sufficient hardware to run in isolation.

Here's the list of core components I used:

* Raspberry Pi Model A+
    * Selected because it lacks Ethernet/Wifi/Bluetooth, but has builtin full size HDMI/USB ports, unlike the Pi Zero
* DS3231 RTC
* MicroSD card, large enough to be the base system. I'd recommend at least 16GB, because it would be annoying to migrate later
* 7 port powered USB hub
    * Important that you have enough ports, and that you can feed them power, since the Pi's own USB port is relatively weak
    * I actually used a port from the hub to power the Pi itself using a USB -> Micro USB cable
* USB external hard drive
    * Needs to be able to hold an ArchLinux ARM repo (~20GB) plus anything else that needs to move between the airgapped system and other systems
* USB thumb drive
    * This one is gonna get full-disk-encryption and be used to hold secret keys, so it doesn't need to be big but it does need to be separate from the aforementioned external drive
* Yubikey 4 (or 4C, if you have a USB-C device)

And then some ancillary pieces:

* USB keyboard
* HDMI monitor
* Another computer to use to set up the environment
* Enough cables to hook all of this stuff together
* Soldering kit / wires to hook up RTC and RaspberryPi

Other components I bought but that aren't required:

* Pelican 1120 case to put everything in
* Command Strips and Duct Tape to hook everything into the case
* Faraday sheet material to wrap the case in

