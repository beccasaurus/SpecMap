#library("specmap");

class SpecMap {
  static final VERSION = '0.1.0';
  static var _stats;

  static run(specs) {
    if (specs is SpecMap) specs = [specs];

    _printHeader();

    _stats = { "passed": 0, "pending": [], "failed": [], "error": [] };
    specs.forEach((spec) {
      spec._run();
    });

    _printSummary();

    if (_anyExamplesFailed)
      return 1;
    else
      return 0;
  }

  static _printHeader() {
    print("~ SpecMap $VERSION ~\n");
  }

  static get _passed()            => _stats['passed'];
  static get _pending()           => _stats['pending'];
  static get _failed()            => _stats['failed'];
  static get _error()             => _stats['error'];
  static get _anyExamplesFailed() => _failed.length > 0 || _error.length > 0;

  static _printSummary() {
    print('\n--- SUMMARY ---');
    _printPendings();
    _printExceptions('Failed', _failed);
    _printExceptions('Error',  _error);
    print('\n$_passed PASSED, ${_failed.length} FAILED, ${_error.length} ERROR');
  }

  static _printPendings() {
    if (_pending.length > 0) {
      print('\n${_pending.length} Pending\n');
      _pending.forEach((pending) {
        print(' * $pending');
      });
    }
  }

  static _printExceptions(var heading, var exceptions) {
    if (exceptions.length > 0) {
      print('\n${exceptions.length} $heading');
      exceptions.forEach((exception) {
        print('\n${exception.message}');
      });
      print('\n');
    }
  }

  var _specs;

  spec(){}

  map(var mapOfSpecs) {
    if (_specs == null)
      _specs = {};

    mapOfSpecs.forEach((exampleName, block) {
      _specs[exampleName] = block;
    });
  }

  _run() {
    spec();
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
}
