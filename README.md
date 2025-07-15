# GlusterFS XFS Storage Setup

This guide describes how to prepare a dedicated disk (`/dev/sdb`) with an XFS filesystem and mount it to `/gluster-storage` for use with GlusterFS bricks.

## 📦 Prerequisites

- A clean, unused disk (e.g., `/dev/sdb`)
- Root or sudo access
- Linux system (Debian, Ubuntu, CentOS, etc.)
- GlusterFS installed (see [GlusterFS installation](https://docs.gluster.org/en/latest/Install-Guide/Community-Install-Guide/))

---

## 🛠️ Steps

### 1. List Available Disks

```bash
lsblk
Ensure /dev/sdb is available and does not contain important data.

```
### 2. Partition the Disk

sudo fdisk /dev/sdb

In fdisk, follow these steps:

n – new partition

p – primary

1 – partition number

Press Enter to accept default first and last sectors

w – write changes and exit

### 3. Format the Partition as XFS

sudo mkfs.xfs /dev/sdb1

### 4. Create the Mount Point

sudo mkdir -p /gluster-storage

### 5. Mount the Partition

sudo mount /dev/sdb1 /gluster-storage

### 6. Make the Mount Persistent

Find the UUID:

sudo blkid /dev/sdb1

Example output:

/dev/sdb1: UUID="5be343de-5d27-4257-b758-df54356174b3" TYPE="xfs"

Add to /etc/fstab:

echo 'UUID=5be343de-5d27-4257-b758-df54356174b3 /gluster-storage xfs defaults 0 0' | sudo tee -a /etc/fstab










