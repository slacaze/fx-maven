# Fx Maven Toolbox

This repository holds a MATLAB Toolbox which uses Maven to help:

- Develop in MATLAB
- Manage dependencies
- Manage lifecycle

## Coordinates

```maven-pom
<groupId>fx.maven</groupId>
<artifactId>maven</artifactId>
<version>1.0.0</version>
```

## Setup

Install the [latest MLTBX](release/latest/).

Make sure that all Maven artifacts are installed by running:

```matlab
>> installMavenPlugin();
```

## Getting started

```matlab
>> mkdir myNewFolder
>> cd myNewFolder
>> mksandbox myapp fx
>> installsandbox()
```

## Help

```matlab
>> help maven
```

## Requirements

- [Maven](https://maven.apache.org/download.cgi)
- [GIT](https://git-scm.com/downloads)

## Workflow

Although it can be used as a standalone, this Toolbox is meant to be used with:

- [MATLAB Maven Plugin](https://github.com/slacaze/matlab-maven-plugin)
- [Maven MATLAB Toolbox Archetype](https://github.com/slacaze/matlab-maven-archetype)
