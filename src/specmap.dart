#library("specmap");

#source("specmap/describe.dart");
#source("specmap/example.dart");
#source("specmap/formatter.dart");
#source("specmap/specdoc_formatter.dart");
#source("specmap/dots_formatter.dart");

/** ... TODO ... */
class SpecMapAsyncFunction {
  Function block;
  SpecMapAsyncFunction(this.block);
}


/** Represents a "Spec." */
class SpecMap {

  /** Returns the vurrent version of SpecMap. */
  static final VERSION = "0.2.3";

  /** Gets/sets the current SpecMapFormatter. */
  static var formatter;

  static int _numberOfAsyncTestsStillRunning = 0;

  /** 
   * If set to true, we don't catch any runtime exceptions 
   * (that aren't ExpectException), so you can see the 
   * exception's full stacktrace. */
  static bool raiseExceptions;

  /** Runs the given SpecMap instance (or Array of SpecMap instances). */
  static void run(var specs) {
    if (formatter == null)
      formatter = new SpecMap_SpecDocFormatter();

    if (specs is SpecMap)
      specs = [specs];

    formatter.header();

    specs.forEach((spec) => spec._runSpec());
    print("ran all specs, async still running: ${_numberOfAsyncTestsStillRunning}");

    var finish = (){
      print("FINISHED!");
      formatter.footer();
    
      // Hack to get a non-0 exit code // TODO we have exit(int) now, plus this might have been fixed.
      //if (_anyExamplesFailed(specs))
      //  throw new Exception("SPECS FAILED!");

      // This is the ideal implementation, but returning a 
      // non-zero exit code from a Dart's main() function 
      // doesn't seem to be supported yet.
      //return _anyExamplesFailed(specs) ? 1 : 0; // <--- need to be passed a callback to return this to
    };

    if (_numberOfAsyncTestsStillRunning == 0) {
      finish();
    } else {
      print("need to wait");
      new Timer.repeating((timer) {
        print("TICK");
        if (_numberOfAsyncTestsStillRunning == 0) {
          t.cancel();
          finish();
        }
      }, 100);
      print("I made the timer");
    }
  }

  static bool _anyExamplesFailed(List<SpecMap> specs) {
    var anyFailed = false;
    specs.forEach((spec) {
      spec.describes.forEach((describe) {
        describe.examples.forEach((example) {
          if (example.failed || example.error)
            anyFailed = true;
        });
      });
    });
    return anyFailed;
  }

  List<SpecMapDescribe> _describes;

  /** All of this spec's describes (as defined in spec()). */
  List<SpecMapDescribe> get describes() {
    if (_describes == null) initializeSpec();
    return _describes;
  }

  /**
   *  Initializes this spec's describes by calling 
   * all of the aliases that you're allowed to use 
   * when defining your describes. */
  initializeSpec() {
    spec();
    specs();
  }

  /** Can be overriden to initialize describes/examples. */
  spec(){}

  /** Can be overriden to initialize describes/examples. */
  specs(){}

  /** 
    * If your function uses asynchronous calls, you need to tell SpecMap when you're done with your tests.
    * Normally, we assume that your example is complete as soon as we finish calling your provided function.  
    * If your function is wrapped with async() ...
    * 
    */
  async(Function fn) {
    ++_numberOfAsyncTestsStillRunning;
    return new SpecMapAsyncFunction(fn);
  }

  /** Called to add a set of examples to your SpecMap. */
  describe(String subject, var mapOfExamples) {
    if (_describes == null) _describes = [];
    _describes.add(new SpecMapDescribe(subject, mapOfExamples));
  }

  // Runs this SpecMap instance's specs.
  // Called for each spec when SpecMap.run() is called.
  _runSpec() {
    describes.forEach((describe) {
      formatter.describe(describe);
      describe.examples.forEach((example) {
        formatter.example(example);
      });
    });
  }
}
