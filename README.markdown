SpecMap
=======

SpecMap is a micro testing library for Dart.

SpecMap is *intentionally* very limited and I don't intend on adding many, 
if any, features to it.

Actually, the reason why I made SpecMap was so I could use it as a testing 
library to test-drive the creation of another testing libary for Dart, 
[Spec.dart][]

I wanted [Spec.dart][] to have a very extensive, yet easy to read, test suite. 
I looked at the testing patterns used in the Dart source code and I didn't think 
they would result in a test suite that I would like, so I wrote SpecMap.

Installing
----------

    wget https://raw.github.com/remi/SpecMap/master/src/specmap.dart

Usage
-----

```actionscript
#import(specmap.dart);
#import(dog.dart);

class DogSpec extends SpecMap {
  spec() {
    describe("Dog", {

      "it should bark": (){
        var dog = new Dog(name: "Rover");
        Expect.equals("Woof!  My name is Rover!", dog.bark());
      },

      "it should do something I haven't written yet": null,

      "it should blow up with an error!": (){
        5.methodThatDoesntExist();
      }

    });

    describe("More dog stuff", {
      "it should do more stuff": null
    });
  }
}

main() => SpecMap.run(new DogSpec());
```

Okay so ... wait, what?

Here's the annotated version:

```actionscript
#import(specmap.dart);
#import(library_containing_dog.dart);

// Define your spec, extending SpecMap
class DogSpec extends SpecMap {

  // Override the SpecMap.spec method.
  // This is what we call to get all of your spec's examples.
  spec() {

    // In your definition of the SpecMap.spec method, make a 
    // call to SpecMap.describe, which accepts a String describing 
    // what you're speccing and a Map<String,Function> 
    // where the String is a description of your example and 
    // the Function is an anonymous function containing the 
    // code for the test.
    describe({

      // "description": () { anonymous function }
      "it should bark": (){
        var dog = new Dog(name: "Rover");

        // For your assertions, you can use Dart's built-in `Expect` 
        // class (or anything that throws an `ExceptException`).  
        Expect.equals("Woof!  My name is Rover!", dog.bark());
      },

      // If you want to create a "pending" example (with just 
      // a description but no implementation), you can pass 
      // null as the value and we'll note that the example has 
      // not been implemented and print it out in the test summary.
      "it should do something I haven't written yet": null,

      // If an Exception is raised (besides an ExceptException), 
      // we note that the test had an Error and print out the 
      // error's stacktrace in the test summary.
      "it should blow up with an error!": (){
        5.methodThatDoesntExist();
      }

    });

    // You can call describe multiple times
    describe("More dog stuff", {
      "it should do more stuff": null
    });
  }
}

// SpecMap.run accepts 1 spec or an array of specs 
// and will run and output the results of your suite.
//
// SpecMap.run also returns an int (0 for success, 1 for failure) 
// so its return value can be used for your main() method to report 
// test suite success/failure to processes that run your suite.
main() => SpecMap.run(new DogSpec());
```

That's really all there is to it!

Contributing
------------

To run the "specs":

    # This should result in happy output 
    # and the exit code should be 0
    dart_bin spec/run_passing_spec.dart

    # This should result in sad panda output 
    # and the exit code should be 1
    dart_bin spec/run_failing_spec.dart

That's it - just eyeball it.  SpecMap doesn't have any of its own tests!

License
-------

SpecMap is released under the MIT license.

[Spec.dart]: https://github.com/remi/spec.dart
