xen-blk* multi-queue benchmark
==============================

This benchmark suite is being developed as part of [GNOME's OPW](https://gnome.org/opw/)
Summer 2014 program for the [Xen Project](http://www.xenproject.org/). It will
be used to test the [port](http://goo.gl/bcvHMh) of Xen's paravirtualized block
I/O driver for Linux to the [multiqueue API](http://lwn.net/Articles/552904/)
recently introduced in the Linux kernel.

Currently, this benchmark only supports simple scenarios to test the port's
correct functioning. Such "stress tests" are also useful to reproduce failures.

Functionality tests
-------------------

The only available script as of now is the affinity test. It starts a number of fio
processes with a configurable workload type, and changes their affinity while they
are issuing I/O.

A C program is also included in the suite; it can be used to test the correctness
of the behavior of the fake_mq block I/O driver. After the driver has been initialized,
(e.g., if it has been compiled as a module, by issuing: sudo modprobe fake_mq_blk)
the executable compiled from the included C source can be started as:
```
sudo ./test_fake_mq
``` 
and it will display the number of the CPU core it is running it. Otherwise, the
CPU core(s) the executable will be running on can be forced as follows: 
```
sudo taskset -c $NUM ./test_fake_mq
```
where $NUM is a comma-separated list of CPU core numbers (e.g., to have the
executable running only on CPU core 1, issue: sudo taskset -c 1 ./test_fake_mq;
while running, the program will always display "1").

Performance tests
-----------------

The only performance test which is, as of now, available in the suite, is the
iometer_test.sh script. Such a script can be run as a non-privileged user, and
will create a large file in the current directory to perform I/O on. Load heaviness
can be specified as command-line parameter in an user-friendly fashion (linear,
lighter, light, moderate, heavy). The script also allows to specify the size of the
I/O to be performed. The defaults are the ones in the original IOmeter jobfile
provided with the examples of the flexible I/O tester (moderate load, with queue
depth of 64, and 4GB of I/Os).

The script can be used with the following syntax:
```
./iometer_test.sh [load_heaviness] [I/O_size]
```

Contacts
--------

This benchmark is being developed by Arianna Avanzini (<avanzini.arianna@gmail.com>)
following Xen Project mentor [Konrad Rzeszutek Wilk](http://blog.xen.org/index.php/author/konrad.wilk/)'s
suggestions and directives.
