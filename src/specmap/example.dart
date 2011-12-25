/** Represents a single example, inside of describe block of a spec. */
class SpecMapExample {
  
  /** This example's describe. */
  SpecMapDescribe describe;

  /** The name/text given for this example. */
  String name;

  /** Whether or not this example is Asynchronous. */
  bool isAsync;

  /** The actual Function representing the code for this example. */
  Function block;

  /** Initialized an example given its SpecMapDescribe, name, and block. */
  SpecMapExample(this.describe, this.name, this.block, this.isAsync);

  /** The resulting state of this Example once evaluated, eg. "passed" or "failed." */
  String result;

  /** Stores the Exception that was raised, if any, when this example was evaluated. */
  Exception exception;

  /** Stores the StackTrace object that can be caught along with exceptions via catch(). */
  var stackTrace;

  bool _evaluated;

  get passed()    => result == "passed";
  get failed()    => result == "failed";
  get error()     => result == "error";
  get pending()   => result == "pending";
  get evaluated() => _evaluated;

  /** 
   * Evaluates this example (if it hasn't already been evaluated) 
   * setting result and exception (if caught) and returning 
   * true if passed/pending or false if failed/error. */
  void evaluate(Function onEvaluated) {
    if (_evaluated != true) {
      _evaluated = true;
      _runBlockAndSetResult(onEvaluated);
    }
  }

  _runBlockAndSetResult(Function onEvaluated) {
    if (block != null) {
      try {
        if (isAsync == true) {
          var example = this;
          block((){
            example.result = "passed";
            onEvaluated(example);
          });
        } else {
          block();
          result = "passed";
          onEvaluated(this);
        }
      } catch (ExpectException ex, var trace) {
        print("! EXPECT $ex");
        result     = "failed";
        exception  = ex;
        stackTrace = trace;
        if (isAsync) onEvaluated(this);
      } catch (Exception ex, var trace) {
        print("! RUNTIME ERROR $ex\n$trace");
        result     = "error";
        exception  = ex;
        stackTrace = trace;
        if (isAsync) onEvaluated(this);
      }
    } else {
      result = "pending";
    }
    if (SpecMap.raiseExceptions == true && exception != null) {
      print("raiseExceptions is set, so we're blowing up!");
      throw exception;
    }
  }
}
