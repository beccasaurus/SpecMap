/** 
 * Custom SpecMapFormatter that outputs a dot for every 
 * passing spec, an F for every failure, an E for every error, 
 * and a P for every pending example.
 * 
 * Other than this output per spec, this formatter is identical 
 * to the default SpecMap_SpecDocFormatter (including color support);
 *
 * NOTE: print() currently always prints newlines, making this formatter icky.
 */
class SpecMap_DotsFormatter extends SpecMap_SpecDocFormatter {
  SpecMap_DotsFormatter([useColor = null]) : super(useColor);

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
