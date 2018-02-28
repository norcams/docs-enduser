=========
Changelog
=========

All major changes to UH-IaaS will be listed on this page.


2018-02-28
==========

Updated Horizon dashboard login page
------------------------------------

We have updated the Horizon dashboard with links to UH-IaaS documentation and first time login page.

2018-02-26
==========

Updated flavors for instances
-----------------------------

Flavors that define the RAM, CPU and disk capacity of instances have now been updated.

More details can be found in this documentation: http://iaas.readthedocs.io/en/latest/customer/flavors.html


2018-01-24
==========

Updated storage for instances
-----------------------------

The default storage used for instances (the disk where the operating system is
running, short OS-disk) has been updated to use a centralized storage.

This change allows us to do live migrations of instances, which means that we no
longer need to reboot instances when doing maintenance work. New instances in
the availability zone (AZ) <region>-default-1 will now use centralized storage.

We have manually moved all existing instances to a new availability zone (AZ)
called `<region>-legacy-1`. This AZ will still be an available option when
starting new instances. All instances in this AZ will continue to have scheduled
maintenance.

2017-12-01
==========

Changed
-------

Debian 9 (Stretch) and Fedora 27 are now available again with support for IPv6.

2017-10-12
==========

Changed
-------

The networks in UH-IaaS (both regions) that was named "public" are now named "dualStack" - network IDs are the same.