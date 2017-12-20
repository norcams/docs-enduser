.. |date| date::

Create and manage a snapshot
============================

Last changed: |date|

.. contents::

You can create a snapshot and use it as the base for your new instances.


Create a snapshot
-----------------
In the dashboard, select *Instances* in the *Compute* tab:

.. image:: images/create-snapshot-01.png
   :align: center
   :alt: Dashboard - Compute -> Instances

Click on ``Create Snapshot``, and the following window appears:

.. image:: images/create-snapshot-02.png
   :align: center
   :alt: Dashboard - Create Snapshot

Fill in the **Snapshot Name** and click on ``Create Snapshot``. The snapshot
will be created and located under *Images* in the *Compute* tab:

.. image:: images/create-snapshot-03.png
   :align: center
   :alt: Dashboard - Snapshot Name

Once the snapshot is created, you can start up a new instance using this image.

.. image:: images/create-snapshot-04.png
   :align: center
   :alt: Dashboard - Snapshot Created

Launch a snapshot
-----------------
Select *Images* in the *Compute* tab:

.. image:: images/create-snapshot-05.png
   :align: center
   :alt: Dashboard - Launch Snapshot


Choose the snapshot, and click on ``Launch``, and further steps are described here_ :ref:`create-virtual-machine`.

The new instance contains now the expected customizations made earlier in your previous instance. 



