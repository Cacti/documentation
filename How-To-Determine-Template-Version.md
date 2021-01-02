# How to determine a Cacti template version

Users are often bewildered when they are unable to import templates found on
the forum and presented with the error, **Error: XML: Hash version does not
exist**.  Cacti prevents templates that have been exported on new versions back
to older versions for compatibility. Quickly looking inside a XML template,
it's not very clear how to determine what version it was created on.  There IS
a reason to the madness -- the hash!

Take the following example: `<hash_04**0018**258d1c9487a6c58dd804f4a012007664>`
The first 2 digits are the type of the template.
The next 4 digits are the Cacti version it was created on.
The next 32 digits are a random number.

## List of Versions

```php
"0.8.4"  => "0000",
"0.8.5"  => "0001",
"0.8.5a" => "0002",
"0.8.6"  => "0003",
"0.8.6a" => "0004",
"0.8.6b" => "0005",
"0.8.6c" => "0006",
"0.8.6d" => "0007",
"0.8.6e" => "0008",
"0.8.6f" => "0009",
"0.8.6g" => "0010",
"0.8.6h" => "0011",
"0.8.6i" => "0012",
"0.8.6j" => "0013",
"0.8.7"  => "0014",
"0.8.7a" => "0015",
"0.8.7b" => "0016",
"0.8.7c" => "0017",
"0.8.7d" => "0018",
"0.8.7e" => "0019",
"0.8.7f" => "0020",
"0.8.7g" => "0021",
"0.8.7h" => "0022",
"0.8.7i" => "0023",
"0.8.8"  => "0024",
"0.8.8a" => "0024"
```

For the example above, this template was exported with Cacti 0.8.7d.

---
Copyright (c) 2004-2021 The Cacti Group
