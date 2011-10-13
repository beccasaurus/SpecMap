#library("specmap");
class SpecMap {
  static final VERSION = "0.2.1";
  static var formatter;
  static bool raiseExceptions;
  static int run(var specs) {
    if (formatter == null)
      formatter = new SpecMap_SpecDocFormatter();
    if (specs is SpecMap)
      specs = [specs];
    formatter.header();
    specs.forEach((spec) => spec._runSpec());
    formatter.footer();
    if (_anyExamplesFailed(specs))
      throw new Exception("SPECS FAILED!");
    return _anyExamplesFailed(specs) ? 1 : 0;
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
  List<SpecMapDescribe> get describes() {
    if (_describes == null) initializeSpec();
    return _describes;
  }
  initializeSpec() {
    spec();
    specs();
  }
  spec(){}
  specs(){}
  describe(String subject, var mapOfExamples) {
    if (_describes == null) _describes = [];
    _describes.add(new SpecMapDescribe(subject, mapOfExamples));
  }
  _runSpec() {
    describes.forEach((describe) {
      formatter.describe(describe);
      describe.examples.forEach((example) {
        formatter.example(example);
      });
    });
  }
}
class SpecMapDescribe {
  String subject;
  List<SpecMapExample> examples;
  SpecMapDescribe(this.subject, var mapOfExamples) {
    examples = new List<SpecMapExample>();
    mapOfExamples.forEach((exampleName, block) => 
      examples.add(new SpecMapExample(this, exampleName, block)));
  }
}
class SpecMapExample {
  SpecMapDescribe describe;
  String name;
  Function block;
  SpecMapExample(this.describe, this.name, this.block);
  String result;
  Exception exception;
  bool _evaluated;
  get passed()    => result == "passed";
  get failed()    => result == "failed";
  get error()     => result == "error";
  get pending()   => result == "pending";
  get evaluated() => _evaluated;
  evaluate() {
    if (! _evaluated) {
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
        if (SpecMap.raiseExceptions)
          throw exception;
      }
    } else {
      result = "pending";
    }
  }
}
class SpecMap_DotsFormatter extends SpecMap_SpecDocFormatter {
  describe(describe){}
  example(example) {
    example.evaluate();
    examplesByResult[example.result].add(example);
    if (example.failed)
      printRed("F");
    else if (example.error)
      printRed("E");
    else if (example.pending)
      printYellow("P");
    else
      printGreen(".");
  }
}
class SpecMap_SpecDocFormatter extends SpecMapFormatter {
  final String whiteColorEscapeSequence = "\x1b\x5b;0;37m";
  bool useColor;
  Map<String, List<SpecMapExample>> examplesByResult;
  SpecMap_SpecDocFormatter([useColor = true]) {
    this.useColor         = useColor;
    this.examplesByResult = <String, List<SpecMapExample>>{
      "passed": [], "pending": [], "failed": [], "error": []
    };
  }
  header() {
    var color = useColor ? whiteColorEscapeSequence : '';
    print("${color}~ SpecMap ${SpecMap.VERSION} ~");
  }
  describe(describe) {
    print("\n" + describe.subject);
  }
  example(example) {
    example.evaluate();
    examplesByResult[example.result].add(example);
    if (example.failed)
      printRed("${indent()}${example.name}");
    else if (example.error)
      printRed("${indent()}${example.name}");
    else if (example.pending)
      printYellow("${indent()}[PENDING] ${example.name}");
    else
      printGreen(indent() + example.name);
  }
  footer() {
    print("\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    printPending();
    printFailures();
    printErrors();
    printSummary();
  }
  printSummary() {
    var text = "\n${getCount('passed')} Passed, ${getCount('failed')} Failed, ${getCount('error')} Errors, ${getCount('pending')} Pending\n";
    if (anyFailed || anyErrors)
      printRed(text);
    else if (anyPending)
      printYellow(text);
    else
      printGreen(text);
  }
  get anyFailed()  => examplesByResult["failed"].length > 0;
  get anyErrors()  => examplesByResult["error"].length > 0;
  get anyPending() => examplesByResult["pending"].length > 0;
  get anyPassed()  => examplesByResult["passed"].length > 0;
  getCount(String result) => examplesByResult[result].length;
  printFailures() {
    if (examplesByResult["failed"].length > 0) {
      print("\nFailures:");
      examplesByResult["failed"].forEach((example) {
        printRed("\n${indent()}${example.describe.subject} ${example.name}");
        print("${indent(2)}Exception: ${example.exception}");
      });
    }
  }
  printErrors() {
    if (examplesByResult["error"].length > 0) {
      print("\nErrors:");
      examplesByResult["error"].forEach((example) {
        printRed("\n${indent()}${example.describe.subject} ${example.name}");
        print("${indent(2)}Exception: ${example.exception}");
      });
    }
  }
  printPending() {
    if (examplesByResult["pending"].length > 0) {
      print("\nPending:");
      examplesByResult["pending"].forEach((example) {
        printYellow("${indent()}${example.describe.subject} ${example.name}");
      });
    }
  }
  printRed(String text)    => printWithColor(text, 31);
  printGreen(String text)  => printWithColor(text, 32);
  printYellow(String text) => printWithColor(text, 33);
  printWithColor(String text, int colorCode) {
    if (useColor)
      print("\x1b\x5b;0;${colorCode}m${text}${whiteColorEscapeSequence}");
    else
      print(text);
  }
  indent([int numberOfTimes = 1, String textToIndentWith = "  "]) {
    var str = "";
    for (var i = 0; i < numberOfTimes; i++)
      str += textToIndentWith;
    return str;
  }
}
class SpecMapFormatter {
  header(){}
  describe(SpecMapDescribe describe){}
  example(SpecMapExample example){}
  footer(){}
}
