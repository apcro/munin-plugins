CPU-per-core
============

This is a modification of the original Munin plugin `CPU-per-core` written by [Matija Grabnar](http://www.matija.si/system-administration/2014/04/01/a-munin-plugin-to-monitor-each-cpu-core-separately/) to operate without needing JSON (or caching to disk)

Installation
------------
Copy the file `cpu-per-core` to your munin plugins directory (normally `/etc/munin/plugins`) and make executable.

Testing
-------
To make sure the plugin works, run 

```bash
munin-run --servicedir $PWD cpu-per-core
```

This should generate an initial of data.
