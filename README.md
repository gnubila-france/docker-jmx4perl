docker-jmx4perl
==============

A docker container with [jmx4perl](http://search.cpan.org/~roland/jmx4perl/) based on alpine linux.


# Status

[![Docker Pulls](https://img.shields.io/docker/pulls/bodsch/docker-jmx4perl.svg?branch)][hub]
[![Image Size](https://images.microbadger.com/badges/image/bodsch/docker-jmx4perl.svg?branch)][microbadger]
[![Build Status](https://travis-ci.org/bodsch/docker-jmx4perl.svg?branch)][travis]

[hub]: https://hub.docker.com/r/bodsch/docker-jmx4perl/
[microbadger]: https://microbadger.com/images/bodsch/docker-jmx4perl
[travis]: https://travis-ci.org/bodsch/docker-jmx4perl

# available tools

 - [j4psh](http://search.cpan.org/~roland/jmx4perl/scripts/j4psh)
 - [check_jmx4perl](http://search.cpan.org/~roland/jmx4perl/scripts/check_jmx4perl)
 - [jmx4perl](http://search.cpan.org/~roland/jmx4perl/scripts/jmx4perl)


# example

You need an running `jolokia` Service:

    docker run --rm -ti --name jolokia-default bodsch/docker-jolokia

Then you can run the jmx4perl Tools:


## jmx4perl (or use `make jmx4perl`)

```
docker run \
        --rm \
        --name jmx4perl-default \
        --interactive \
        --tty \
        --link jolokia-default:jolokia \
        bodsch/docker-jmx4perl:latest \
        jmx4perl --product tomcat http://jolokia:8080/jolokia
Name:      Apache Tomcat
Vendor:    Apache
Version:   8.5.15
--------------------------------------------------------------------------------
Memory:
   Heap-Memory used    : 221 MB
   Heap-Memory alloc   : 962 MB
   Heap-Memory max     : 14272 MB
   NonHeap-Memory max  : 0 MB
Classes:
   Classes loaded      : 3031
   Classes total       : 3031
Threads:
   Threads current     : 37
   Threads peak        : 39
OS:
   CPU Arch            : amd64
   CPU OS              : Linux 4.12.2-gentoo
   Memory total        : 51034 MB
   Memory free         : 51034 MB
   Swap total          : 0 MB
   Swap free           : 0 MB
   FileDesc Open       : 78
   FileDesc Max        : 1048576
Runtime:
   Name                : 7@cb4e61b5d6dd
   JVM                 : 25.131-b11 OpenJDK 64-Bit Server VM Oracle Corporation
   Uptime              : 1 h, 13 m, 54 s
   Starttime           : Tue Aug  8 11:14:38 2017
```

## j4psh (or use `make j4psh`)

```
docker run \
        --rm \
        --name jmx4perl-default \
        --interactive \
        --tty \
        --link jolokia-default:jolokia \
        bodsch/docker-jmx4perl:latest \
        j4psh http://jolokia:8080/jolokia
[jolokia:8080] : ls java.lang
java.lang:
    name=Code Cache,type=MemoryPool
    name=CodeCacheManager,type=MemoryManager
    name=Compressed Class Space,type=MemoryPool
    name=Metaspace Manager,type=MemoryManager
    name=Metaspace,type=MemoryPool
    name=PS Eden Space,type=MemoryPool
    name=PS MarkSweep,type=GarbageCollector
    name=PS Old Gen,type=MemoryPool
    name=PS Scavenge,type=GarbageCollector
    name=PS Survivor Space,type=MemoryPool
    type=ClassLoading
    type=Compilation
    type=Memory
    type=OperatingSystem
    type=Runtime
    type=Threading

[jolokia:8080 java.lang] : cd type=Memory
[jolokia:8080 java.lang:type=Memory] : ls
java.lang:type=Memory

Attributes:
  HeapMemoryUsage                 CompositeData      HeapMemoryUsage
  Verbose                         boolean            Verbose
  NonHeapMemoryUsage              CompositeData      NonHeapMemoryUsage
  ObjectName                      ObjectName         ObjectName
  ObjectPendingFinalizationCount  int                ObjectPendingFinalizationCount

Operations:
  void gc()                                          gc
[jolokia:8080 java.lang:type=Memory] : cat HeapMemoryUsage
    {
      committed => 1009254400,
      init => 1052770304,
      max => '14965276672',
      used => 137158680
    }
[jolokia:8080 java.lang:type=Memory]

```
(for more examples, view Roland Huß' excellent [YouTube Tutorial](https://www.youtube.com/watch?v=y9TuGzxD2To)!)

## check_jmx4perl (or use `make nagios`)

```
docker run \
        --rm \
        --name jmx4perl-default \
        --interactive \
        --tty \
        --link jolokia-default:jolokia \
        bodsch/docker-jmx4perl:latest \
        check_jmx4perl --url http://jolokia:8080/jolokia \
        --mbean java.lang:type=Memory    \
        --attribute HeapMemoryUsage      \
        --path used                      \
        --base java.lang:type=Memory/HeapMemoryUsage/max \
        --warning 80                     \
        --critical 90
OK - [java.lang:type=Memory,HeapMemoryUsage,used] : In range 0.88% (131884848 / 14965276672) | [java.lang:type#Memory,HeapMemoryUsage,used]=131884848;11972221337.6;13468749004.8;0;14965276672
```

(for more examples, see the `jmx4perl` [documentation](http://search.cpan.org/~roland/jmx4perl-1.12/scripts/check_jmx4perl))
