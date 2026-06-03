Rebuilding a Server
===================

Last changed: 2026-06-03

.. contents::

Rebuilding a server means re-creating a virtual machine instance according to its properties. With the current version of OpenStack in NREC, rebuild is performed with the OpenStack CLI. The following use cases are tested and verified working in NREC (please note that a minimum compute API version may be set to acquire successful rebuild):

- Rebuild instance from image. The image can be a snapshot or server backup of the instance or a completely new server image. This can be used to restore an instance. If the instance is stopped, omit --wait since it will hang indefinitely::

     openstack --os-compute-api-version 2.79 server rebuild --image $backup_reupload --wait [server name or uuid]

- Rebuild instance with user data. In the example, user data is used to set the root password of an instance supporting cloud-init::

     openstack --os-compute-api-version 2.57 server rebuild [server name or uuid] --wait --user-data <(cat <<EOF
     #cloud-config
     chpasswd:
       list: |
         root:myrootpassword
       expire: False
     EOF
     )

- Rebuild instance with new public SSH key. The new publc key should be added to ~/.ssh/authorized_keys in the rebuilt instance. Please note that it may not remove the previous and manually added public key(s) in the authorized_keys file::

     openstack --os-compute-api-version 2.54 server rebuild --key-name [name of keypair in OpenStack] --wait [server name or uuid]

