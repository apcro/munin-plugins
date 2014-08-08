CPU-per-core
============

This is a modification of the original Munin plugin `CPU-per-core` written by [Matija Grabnar](http://www.matija.si/system-administration/2014/04/01/a-munin-plugin-to-monitor-each-cpu-core-separately/) to use Storable for caching instead of JSON.

Installation
------------
Copy the file `cpu-per-core` to your munin plugins directory (normally `/etc/munin/plugins`) and make executable.

Testing
-------
To make sure the plugin works, run 

```bash
munin-run cpu-per-core
```

If all goes well, this will display a complete set of data.

Configuration Test
------------------
Run

```bash
munin-run cpu-per-core config
```
to see the Munin configuration data.
