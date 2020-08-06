SpecMap
=======

SpecMap is a micro testing library for Dart.

SpecMap is *intentionally* very limited and I don't intend on adding many, if any, features to it.

![SpecMap Example Screenshot](https://github.com/remi/SpecMap/raw/master/pkg/screenshot.png)

Installing
----------

Download the [latest version of SpecMap.dart](https://raw.github.com/remi/SpecMap/master/pkg/specmap.dart)

Usage
-----

```actionscript
#import("specmap.dart");
#import("dog.dart");

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
#import("specmap.dart");
#import("dog.dart"); // <--- assuming your Dog class comes from this library

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
    describe("Dog", {

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

To run the "specs": `./script/run_specs`

That's it - just eyeball the output and make sure it looks correct.

SpecMap doesn't have any of its own unit tests, hence why it's staying TINY on purpose!

License
-------

SpecMap is released under the MIT license.
