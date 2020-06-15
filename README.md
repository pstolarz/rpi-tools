## `build_kernel`
Cross compile RPi Linux kernel. The script automates the building process
described [here](https://www.raspberrypi.org/documentation/linux/kernel/building.md)

### Usage

Before building the kernel `ARCH`, `CROSS_COMPILE` and `KERNEL_SRC` environment
variables need to be set. `setenv` contains sample configuration of these variables.
Update the script and source it:

```sh
. ./setenv
```

Then run the `build_kernel` script:

```sh
./build_kernel
```

Choose required target platform for RPi 1, 2, 3 or 4 from menu. The result is
*tar.gz* archive containing 32-bit ARM kernel build. Appropriate prefix is added
to the archive name to distinguish the target as follows:

* `kernel-x.y.z+.tar.gz` for RPi 1
* `kernel-x.y.z-v7+.tar.gz` for RPi 2/3
* `kernel-x.y.z-v7l+.tar.gz` for RPi 4

The archive content may be directly extracted on the platform root filesystem.
**Make kernel image backup if needed!**
