external-ceph-2.0.1
============

Overview
--------
This plugin allowes to use external Ceph cluster for storage of Volumes, Images, Objects and Ephemeral drives.


Requirements
------------
Currently compatible only with Mirantis OpenStack 9.0.


Prerequisites
-------------
- Operational Ceph cluster deployed elsewhere
- Network connectivity between OpenStack nodes and Ceph cluster

The user should also consider using high-bandwidth links for communication with Ceph cluster.


Limitations
-----------
- As of 9.0 this plugin is indended to support configuring all storage to use external Ceph (Volumes, Images, Objects, Ephemeral). Other combinations of storage backends may have not been tested.
- User must configure RadosGW to use OpenStack environment's Keystone for authentication before using Object Storage.


Installing the plugin
---------------------
- Copy the plugin to the Fuel node:
	scp external-ceph.rpm root@10.20.0.2:~
- Install the plugin:
	fuel plugins --install external-ceph.rpm


Configuring the plugin
----------------------
- Create a new OpenStack environment
- (Important) skip the Storage tab of creation wizard
- Check "External Ceph" on Additional Services tab
- On Settings tab, in Storage group, fill in all the plugin's fields
- Add controller, compute etc nodes to the environment


Usage
-----
From OpenStack POV there is no difference as if Ceph has been deployed locally in the OpenStack cluster.


Verification
------------
- Image is uploaded during deployment process
- Create a volume
- Spawn an instance with Ephemeral storage
- Attach the volume to the instance
- Upload something into the object storage


Troubleshooting
---------------
Check following logs:
- /var/log/cinder/cinder-volume.log (controller)
- /var/log/glance/glance-api.log (controller)
- /var/log/nova/nova-compute.log (compute)

In case of issues with RadosGW, check radosgw logs on the Ceph cluster nodes.

