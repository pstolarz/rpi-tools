## `build_kernel.sh`
Cross compile RPi Linux kernel. The script automates the building process
described [here](https://www.raspberrypi.org/documentation/linux/kernel/building.md)

### Usage
Before building the kernel `TOOLCHAIN32/64` and `KERNEL_SRC` environment
variables need to be set. [`setenv.sh`](setenv.sh) contains sample configuration
of these variables. Update the script accordingly and source it:

```sh
. ./setenv.sh
```

Then run the `build_kernel.sh` script:

```sh
./build_kernel.sh
```

Choose required target platform from menu. The result is *tar.gz* archive
containing the kernel build. Appropriate prefix is added to the archive name
to distinguish targets as follows:

* `kernel-x.y.z+.tar.gz` for Pi 1/Zero/Zero W, CM [32-bit]
* `kernel-x.y.z-v7+.tar.gz` for Pi 2/3/3+, CM 3 [32-bit]
* `kernel-x.y.z-v7l+.tar.gz` for Pi 4 [32-bit]
* `kernel-x.y.z-v8+.tar.gz` for Pi 3/3+, CM 3 [64-bit]
* `kernel-x.y.z-v8l+.tar.gz` for Pi 4 [64-bit]

The archive content may be directly extracted on the platform root filesystem.
**Make the kernel image backup if needed!**

## `search_kernel_commit.sh`
Look for specific kernel version (or family of kernel versions) commit(s) on
official RPi GutHub [firmware](https://github.com/raspberrypi/firmware)
and [kernel](https://github.com/raspberrypi/linux) repositories.

### Usage
Example of usage:

```
$ ./search_kernel_commit.sh 5.10.14
1 result(s) for kernel 5.10.14 [max. 100]
  raspberrypi/linux: e7d4a958d4662a95574ef166adba161a1edf4319 raspberrypi/firmware: f11bc1321a2747b00be83ca7169af0bfe601d376 [kernel: Bump to 5.10.14]
```
```
$ ./search_kernel_commit.sh 5.10.
13 result(s) for kernel 5.10. [max. 100]
  raspberrypi/linux: ab9e2a6a6d0a3e67185f6ef8e33f4646e8b3c13b raspberrypi/firmware: dc4840bb0746c9bb695f534cb3c3d47d2804b0c2 [kernel: Bump to 5.10.6 (correction)]
  raspberrypi/linux: ab9e2a6a6d0a3e67185f6ef8e33f4646e8b3c13b raspberrypi/firmware: e934b564762a1f9b11ed3753e5878a680e38a70e [kernel: Bump to 5.10.5]
  raspberrypi/linux: 31fbc18058672e9e3c5ab3532064d690374152da raspberrypi/firmware: 7ecd699b3f54f4985032d774fdab55f98d44ebf6 [kernel: Bump to 5.10.3]
  raspberrypi/linux: 16d8dbed61ca60df412cb63ab24c6221394500d7 raspberrypi/firmware: 8a5549c137dbce0e082ecf21607dc5e3feac1160 [kernel: Bump to 5.10.0]
  raspberrypi/linux: b1f47573c1fc640d360349f767568ff3a84e778d raspberrypi/firmware: 0fb9a0dce50c3f4683254f57c3a5c20289a4de8a [kernel: Bump to 5.10.2]
  raspberrypi/linux: 98a26692449ad74be15a25c05bb5be5396aaea4f raspberrypi/firmware: 7d91570f20378afc9414107dccdad70705a8a342 [kernel: Bump to 5.10.13]
  raspberrypi/linux: c5f51df7d0c457c330d0daecba491f61b979f048 raspberrypi/firmware: 496e65477e06172ea20602e365d3790632c3cc06 [kernel: Bump to 5.10.11]
  raspberrypi/linux: 17cf96be41468bd9881eb3f0afb95ebe984c0c4b raspberrypi/firmware: 051e5e1be85fa7119aebf20adf8e61b9fe37c459 [kernel: Bump to 5.10.9]
  raspberrypi/linux: e9505f4612646533f53813aabef5ca040b0ea49d raspberrypi/firmware: c78f3ef45229ab722ec6b858f39b078535d88bee [kernel: Bump to 5.10.7]
  raspberrypi/linux: a7eebc039b08185dfe72c2bbe8275e930b37b575 raspberrypi/firmware: 0ee1d9f2fc852b20e247bb832a3b8d0a13b6ada6 [kernel: Bump to 5.10.5]
  raspberrypi/linux: 684bc6681ac06b318b1ac02fbf7c8b0a61ee72e7 raspberrypi/firmware: d06d94e8f171362214edc7aef6e74329ab6cb588 [kernel: Bump to 5.10.4]
  raspberrypi/linux: 967d45b29ca2902f031b867809d72e3b3d623e7a raspberrypi/firmware: d016a6eb01c8c7326a89cb42809fed2a21525de5 [kernel: Bump to 5.10.1]
  raspberrypi/linux: e7d4a958d4662a95574ef166adba161a1edf4319 raspberrypi/firmware: f11bc1321a2747b00be83ca7169af0bfe601d376 [kernel: Bump to 5.10.14]
```
