// Custom SpecMapFormatter that outputs the names of all 
// describes with indented examples under each.
//
// Once everything has finished running, a summary of 
// the total passed/failed/etc examples is printed.
//
// NOTE: This is the default SpecMap formatter.
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
