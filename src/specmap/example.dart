// Represents a single example, inside of describe block of a spec.
class SpecMapExample {
  
  // This example's describe
  SpecMapDescribe describe;

  // The name/text given for this example
  String name;

  // The actual Function representing the code for this example
  Function block;

  // Initialized an example given its SpecMapDescribe, name, and block
  SpecMapExample(this.describe, this.name, this.block);

  // The resulting state of this Example once evaluated, eg. "passed" or "failed"
  String result;

  // Stores the Exception that was raised, if any, when this example was evaluated.
  Exception exception;

  bool _evaluated;

  get passed()    => result == "passed";
  get failed()    => result == "failed";
  get error()     => result == "error";
  get pending()   => result == "pending";
  get evaluated() => _evaluated;

  // Evaluates this example (if it hasn't already been evaluated) 
  // setting result and exception (if caught) and returning 
  // true if passed/pending or false if failed/error.
  evaluate() {
    if (_evaluated != true) {
      _evaluated = true;
      _runBlockAndSetResult();
    }
    return (passed || pending);
  }

  _runBlockAndSetResult() {
    if (block != null) {
      try {
        block();
        result = "passed";
      } catch (ExpectException ex) {
        result    = "failed";
        exception = ex;
      } catch (Exception ex) {
        result    = "error";
        exception = ex;
      }
    } else {
      result = "pending";
    }
    if (SpecMap.raiseExceptions == true && exception != null)
      throw exception;
  }
}
