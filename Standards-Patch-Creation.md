# Patch Creation

When creating patches for cacti, please follow the following guidelines:

* Use `diff -ruBbd`, so that the patch will work with 'patch -p1'.
* Use the following method for creating the patch:

```console
diff -ruBbd cacti/lib/rrd.php cacti-new/lib/rrd.php > filename.patch
```
