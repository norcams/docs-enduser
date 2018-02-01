=========
Changelog
=========

All major changes to UH-IaaS will be listen on this page.

2018-01-24
==========

Updated storage for instances
-----------------------------

The default storage used for instances (the disk where the operating system are
running, short OS-disk) have been updated to use a centralized storage. This will
enable us to do live migration of instances so the scheduled maintenance with
reboot of instances are not needed. New instances in the availability zone (AZ)
`<region>-default-1` will now use this new storage.

We have manually moved all existing instances to a new availability zone (AZ)
called `<region>-legacy-1`. This AZ will still be an available option when
starting new instances. All instances in this AZ will continue to have scheduled
maintenance.

2017-12-01
==========

Changed
-------

- Debian 9 (Stretch) and Fedora 27 are now available again with support for IPv6.

2017-10-12
==========

Changed
-------

- The networks in UH-IaaS (both regions) that was named "public" are now named "dualStack" - network IDs are the same.
