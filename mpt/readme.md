About
=====

This is a apt like package manager for ComputerCraft made by [Magik6k].

This version is modified by [Dummy3k] to work with GitHub.

[Magik6k]:http://www.computercraft.info/forums2/index.php?/topic/16097-mpt-minecraft-packaging-tool/
[Dummy3k]:https://github.com/dummy3k

Install
=======

`
pastebin run U4JRUuCg
`

HowTo Clone this repository
===========================

Clone this repository and change the user name in
the `install.lua` file. 

HowTo Make a New Package
========================

Create a new sub directory with your package name.

Add an `index` file inside the directory:

  - 'd' - dependency, second argument is package name
  - 'f' - file, second argument is file location like '/bin/example'
  - 's' - post-install scripts, second parameter is script location, like '/script'
  - 'u' - file with custom location, second parameter is file location like '/bin/example', third is URL of the file

Example:
```
f;/bin/example
u;/bin/urlexample;http://pastebin.org/raw.php?i=something
s;/postinstall
d;iamdependency
```

Add the package to the `sources` file:
```
p;myNewPackage;1;https://raw.githubusercontent.com/dummy3k/computerCraft/master/
```


