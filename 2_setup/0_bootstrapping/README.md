mind-the-gap / setup / bootstrapping
================

You need to manually mount the share drive so that you can access the configuration scripts.

Run `lsblk` and find the device and partition. It'll generally be /dev/sda1. Then run the following:

```
mount THAT_PARTITION /opt/share
```

