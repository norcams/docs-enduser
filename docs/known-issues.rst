.. |date| date::

Known Issues
============

Last changed: |date|

.. contents::

OSL and BGO location
--------------------
There are now one UH-Iaas cloud with two regions: BGO and OSL. Provision is
done once at https://access.uh-iaas.no. In the dashboard you will have access
to both regions. For API access remember to set REGION_NAME to region name
in lowercase in rc-file.

API access
----------

All new users will get a pass phrase to use with API when they provision
a personal project (see :doc:`enduser/login`). Existing users
please contact us. We will provide a pass phrase for you to use with the API.

See :doc:`enduser/api` for more information about use of API.

Only personal projects
----------------------

We currently have a limitation on projects, in which only personal
projects are supported.

Console limitation
------------------

There is a limitation which requires the environment (e.x. X) to run
in one of the EN locales to get a correct key mapping (whatever the
locale active inside the instance)!


Getting help
============

We have a public chat room at https://uhps.slack.com

Reporting issues
================

Issues should be reported via the GitHub project norcams/iaas:
https://github.com/norcams/iaas/issues
