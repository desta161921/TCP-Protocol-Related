#!/bin/bash

# Disable TCP segmentation offloading (rc.local)

# for interface enp0s8
sudo ethtool -K enp0s8 tso off
sudo ethtool -K enp0s8 gso off
sudo ethtool -K enp0s8 gro off
sudo ethtool -K enp0s8 sg off #turn off the generic receiver offload
sudo ethtool --offload  enp0s8  rx off  tx off


# for interface enp0s3
sudo ethtool -K enp0s3 tso off
sudo ethtool -K enp0s3 gso off
sudo ethtool -K enp0s3 gro off
sudo ethtool -K enp0s3 sg off #turn off the generic receiver offload
sudo ethtool --offload  enp0s3  rx off  tx off



# for interface lo
sudo ethtool -K lo tso off
sudo ethtool -K lo gso off  
sudo ethtool -K lo gro off 
sudo ethtool -K lo sg off #turn off the generic receiver offload
sudo ethtool --offload  lo  rx off  tx off
