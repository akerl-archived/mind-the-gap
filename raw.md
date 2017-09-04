Raw notes
=========

Raw notes I took during the process of doing this pre-automation

## Notes

* Had to buy sketchy usb-c -> usb-a adapter. It worked, but only in one orientation, and I'd definitely not wire power to it
* Made an ArchlinuxARM SD, has to be made from a super recent version of bsdtar
* Didn't think about having to have a package mirror. Probably some snazzy way to sync just what I need, but couldn't find any blogs about airgapped stuff that mentioned a good way (most of them just plugged their airgapped comp into the network to install updates!), so I rsynced from the only archlinuxarm mirror that supports rsync (thanks @jaredledvina for the find)
* Read a collection of GPG / airgap guides. [drduh has the best I found](https://github.com/drduh/YubiKey-Guide)
* Considered ECC master key, but yubikeys don't support it and apparently GPG 1.x is still popular for some reason
* ArchlinuxARM ships with haveged, which is bleh and not necessary since the RPi has a HW RNG
* The RPi *doesn't* ship with an RTC, so I need to get one if I want the clock to survive reboots
* Mounted a tmpfs at /opt/gnupg to keep myself honest about backups
* Mounted the repo / share space with noexec,nosuid at /opt/share
* Originally didn't make a FAT space, which was a pain for sharing pubkeys and such
* Original SD was 2GB, which is a pain, had to remove some package cruft so I didn't run out of space
* Making faraday cages is hard; needs to have a contact seal at all edges, you can't just cut it up and mostly cover the sides. I ended up making a bag instead of lining the case.
* Set up LUKS on the thumb drive that would hold the secrets
* Basically every mount gets nosuid,noexec,etc, so it can't get sneaky
* Had to call gpg with --expert --full-gen-key for the good stuff
* Certify-only keys seem to be unloved
* default pinentry is gtk2, which seems extra strength ignorant given archlinux doesn't install a gui by default
* wanted 2 revocation certs, 1 for compromise, 1 for other
* Can't use certify key from yubikey
* If you don't set GPG_TTY, pinentry freaks out
* yubikey has puk/pin/mgmt/reset/other_pin, very confusing
* pcscd needs to be running for yubikey-manager
