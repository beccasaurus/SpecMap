#library("specmap");

class SpecMap {
  final VERSION = '0.1.0';

  static run(specs) {
    if (specs is SpecMap)
      specs = [specs];

    specs.forEach((spec) {
      spec._runSpecs();
    });

    specs.forEach((spec) {
      if (spec.anyExamplesFailed)
        return 1;
    });

    return 0;
  }

  var _specs;
  var _stats;

  spec(){}

  map(var mapOfSpecs) {
    if (_specs == null)
      _specs = {};

    mapOfSpecs.forEach((exampleName, block) {
      _specs[exampleName] = block;
    });
  }

  _runSpecs() {
    _printHeader();
    spec();
    _runAllExamples();
    _printSummary();
  }

  _runAllExamples() {
    _stats = { "passed": 0, "pending": [], "failed": [], "error": [] };
    _specs.forEach((exampleName, block) {
      if (block != null) {
        print(exampleName);
        try {
          block();
          ++_stats["passed"];
        } catch (ExpectException ex) {
          _stats["failed"].add(ex);
        } catch (Exception ex) {
          _stats["error"].add(ex);
        }
      } else {
        print("[PENDING] $exampleName");
        _stats["pending"].add(exampleName);
      }
    });
  }

  get passed()  => _stats['passed'];
  get pending() => _stats['pending'];
  get failed()  => _stats['failed'];
  get error()   => _stats['error'];

  get anyExamplesFailed() => failed.length > 0 || error.length > 0;

  _printHeader() {
    print("~ SpecMap $VERSION ~\n");
  }

  _printSummary() {
    print('\n--- SUMMARY ---');
    _printPendings();
    _printExceptions('Failed', failed);
    _printExceptions('Error',  error);
    print('\n$passed PASSED, ${failed.length} FAILED, ${error.length} ERROR');
  }

  _printPendings() {
    if (pending.length > 0) {
      print('\n${pending.length} Pending\n');
      pending.forEach((pending) {
        print(' * $pending');
      });
    }
  }

  _printExceptions(var heading, var exceptions) {
    if (exceptions.length > 0) {
      print('\n${exceptions.length} $heading');
      exceptions.forEach((exception) {
        print('\n${exception.message}');
      });
      print('\n');
    }
  }
}
