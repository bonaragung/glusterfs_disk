#!/bin/bash

# ===============================
# Setup XFS Partition for GlusterFS
# Target Disk: /dev/sdb
# Mount Point: /gluster-storage
# WARNING: This will erase /dev/sdb!
# ===============================

set -e

DISK="/dev/sdb"
PART="${DISK}1"
MOUNT_POINT="/gluster-storage"

echo "[INFO] Starting setup for $DISK"

# Check if disk exists
if [ ! -b "$DISK" ]; then
  echo "[ERROR] Disk $DISK not found!"
  exit 1
fi

# Warn user
read -p "[WARNING] This will erase all data on $DISK. Continue? (y/N): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "[INFO] Aborted."
  exit 0
fi

# Create new partition
echo "[INFO] Creating partition on $DISK..."
echo -e "o\nn\np\n1\n\n\nw" | sudo fdisk $DISK

# Wait for system to recognize the new partition
sleep 2

# Format with XFS
echo "[INFO] Formatting $PART as XFS..."
sudo mkfs.xfs -f $PART

# Create mount point
echo "[INFO] Creating mount point at $MOUNT_POINT..."
sudo mkdir -p $MOUNT_POINT

# Mount the partition
echo "[INFO] Mounting $PART to $MOUNT_POINT..."
sudo mount $PART $MOUNT_POINT

# Add to /etc/fstab
UUID=$(sudo blkid -s UUID -o value $PART)
FSTAB_LINE="UUID=$UUID $MOUNT_POINT xfs defaults 0 0"

echo "[INFO] Adding to /etc/fstab..."
if ! grep -q "$UUID" /etc/fstab; then
  echo "$FSTAB_LINE" | sudo tee -a /etc/fstab > /dev/null
fi

# Create GlusterFS brick directory
echo "[INFO] Creating GlusterFS brick directory..."
sudo mkdir -p $MOUNT_POINT/brick

echo "[SUCCESS] XFS disk setup complete. Mounted at $MOUNT_POINT and ready for GlusterFS."

