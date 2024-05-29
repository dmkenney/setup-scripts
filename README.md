# New Linux OS Setup & Configuration Instructions

## Steps to install Arch Linux

1. Setup wifi

   1. `iwctl`
   2. `device list`
   3. `station wlan0 scan` replace `wlan0` with the proper device name
   4. `station wlan0 get-networks`
   5. `station wlan0 connect SSID`
   6. `exit`
   7. `ping archlinux.com`

2. `archinstall`
   1. Mirrors
   2. Disk configuration
      a. Use a best-effort default partition layout
      - btrfs
      - yes
      - Use compression
   3. Disk encryption
      1. Encryption type `Luks`
      2. Select the partition
   4. Bootloader -> select `Grub`
   5. Hostname -> set it
   6. Root password -> set
   7. User account -> set
   8. Profile
      a. Type -> `Desktop`
      b. Desktop environment -> `i3-wm`
      c. Graphics driver -> `Nvidia (proprietary)`
   9. Audio -> `Pipewire`
   10. Kernels -> `Linux`
   11. Additional packages:
       - alacritty
       - firefox
       - iwd
       - vim
       - tmux
       - git
       - unzip
   12. Network configuration -> `Use NetworkManager`
   13. Timezone -> set it

## Steps after Arch Installed

1. Clone this repository `https://github.com/dmkenney/setup-scripts.git`
1. Run `./setup-arch.sh`
