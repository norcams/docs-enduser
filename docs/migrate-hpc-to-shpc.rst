Migrating HPC instance to shared HPC
====================================

Overall, this is what you should do:

#. Take a snapshot of the HPC instance
#. Create an sHPC instance, using the snapshot as image

Detailed procedure:

#. If you have attached volumes to the HPC instance, make sure that
   they are not in `/etc/fstab`. Comment out the volumes by editing
   the file

#. Shut off the instance, either by logging in to it and giving the
   command `poweroff`, or by selecting «Shut Off instance» in the GUI

#. Take a snapshot of the instance while it is powered off (confirmed
   by the instance status being «Shut Down), by selecting «Create
   Snapshot» in the GUI. Give it a name that you will recognize. It
   will take some time before the snapshot is ready

#. Create a new sHPC instance, either by selecting «Launch» from the image
   list, or by selecting «Launch Instance» and selecting the snapshot
   after changing the boot source from «Image» to «Instance Snapshot».

#. Verify that you can log in on the new sHPC instance, and that is
   works as expected

#. If you have volumes attached to the old HPC instance, detach the
   volumes from it and attach to the new sHPC instance. If you
   commented out lines in `/etc/fstab` prior to taking the snapshot,
   comment the lines in again

#. After you have verified that everything works with the new
   instance, and you are certain that the old instance is no longer
   needed, delete it

