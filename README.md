xen-blk* multi-queue benchmark scripts
======================================

This benchmark suite is being developed as part of [GNOME's OPW](https://gnome.org/opw/)
Summer 2014 program for the [Xen Project](http://www.xenproject.org/). It will
be used to test the [port](http://goo.gl/bcvHMh) of Xen's paravirtualized block
I/O driver for Linux to the [multiqueue API](http://lwn.net/Articles/552904/)
recently introduced in the Linux kernel.

Currently, this benchmark only supports simple scenarios to test the port's
correct functioning. Such "stress tests" are also useful to reproduce failures.

Functionality tests
-------------------

(placeholder)

Performance tests
-----------------

Not implemented yet.

Contacts
--------

This benchmark is being developed by Arianna Avanzini (<avanzini.arianna@gmail.com>)
following Xen Project mentor [Konrad Rzeszutek Wilk](http://blog.xen.org/index.php/author/konrad.wilk/)'s
suggestions and directives.
