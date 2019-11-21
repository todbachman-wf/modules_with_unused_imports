It appears unused imports can cause unnecessary dependencies between DDC modules. This project demonstrates the issue.

## 1. Generating the Module Structure w/o Unused Imports

On the master branch of the repo there are no unused imports. The following steps compile the unit tests to produce a baseline set of DDC modules.

```bash
$ pub get
$ pub run build_runner build
```

Run the `find` command to identify the DDC modules created by the build:

```bash
$ find .dart_tool/build/generated/modules_with_unused_imports/lib -name *.ddc.module
```

The find command will print the following output:

```bash
.dart_tool/build/generated/modules_with_unused_imports/lib/entrypoint_b.ddc.module
.dart_tool/build/generated/modules_with_unused_imports/lib/entrypoint_a.ddc.module
```

Let's take a look at the `entrypoint_b` module:

```json
{
  "p":["modules_with_unused_imports","lib/entrypoint_b.dart"],
  "s":[
    ["modules_with_unused_imports","lib/entrypoint_b.dart"],
    ["modules_with_unused_imports","lib/src/class_b.dart"]],
  "d":[],
  "m":false,"is":true,"pf":"ddc"
}
```

This module does not depend on any other module. If you were to look at the `entrypoint_a` module you would find it doesn't have any dependencies either.

## 2. Generating the Module Structure With an Unused Import

Let's edit [class_b.dart](lib/src/class_b.dart) and uncomment the import at the top of the file. This will be an unused import.

Now, recompile the tests to update the module structure:

```bash
$ pub run build_runner build
```

Again use the `find` command to identify the modules created:


```bash
$ find .dart_tool/build/generated/modules_with_unused_imports/lib -name *.ddc.module
```

This time the module files found are:

```bash
.dart_tool/build/generated/modules_with_unused_imports/lib/entrypoint_b.ddc.module
.dart_tool/build/generated/modules_with_unused_imports/lib/entrypoint_a.ddc.module
.dart_tool/build/generated/modules_with_unused_imports/lib/src/class_a.ddc.module
```

Interesting. This time there are 3 modules rather than the 2 we saw previously. Now, if you inspect the contents of `.dart_tool/build/generated/modules_with_unused_imports/lib/entrypoint_b.ddc.module` you'll find:

```json
{
  "p":["modules_with_unused_imports","lib/entrypoint_b.dart"],
  "s":[
    ["modules_with_unused_imports","lib/entrypoint_b.dart"],
    ["modules_with_unused_imports","lib/src/class_b.dart"]],
  "d":[["modules_with_unused_imports","lib/src/class_a.dart"]],
  "m":false,"is":true,"pf":"ddc"
}
```

In this case, you can see the `entrypoint_b` module now has a dependency on the `class_a` module that it didn't have before. The result of this is if you make a change to the `class_a` module now the `class_b` module will be rebuild too.
