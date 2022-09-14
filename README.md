# Repository for Collection Plugins
>
## Table of Contents
[Structure of directory](#structure-of-directory)  
[Structure of manifest.rakuon file](#structure-of-manifestrakuon-file)  
[Naming](#naming)  

----
These are the released versions of Collection Plugins.

# Structure of directory
```
- manifest.rakuon
    (A Raku Object Notation file containing a list of all released plugins)
- README.md
    (This file)
- README.rakudoc
    (Source for this file)
- plugins/
    - html/
        <sub-directory for each plugin>
- bin/
    - syncronise
    (Raku program to rewrite manifest.rakuon from plugins data)
```
# Structure of manifest.rakuon file
`manifest.rakuon` evaluates to a Hash.

The keys of the Hash match the directory structure until the plugin names. Then there is a full version number. For example,

```
%( plugins => %(
    html => %(
        camelia_V0_auth_collection => %(
            version => '0.1.0'
        ),
    ),
)
```
# Naming
Given a plugin used by a Collection Mode that renders into html

*  called 'my-plugin'

*  with a config key `version` of _1.2.3_

*  with a config key `auth` of _collection_

then the released plugin will be

```
my-plugin_v1_auth_collection
```






----
Rendered from README at 2022-09-14T19:33:39Z