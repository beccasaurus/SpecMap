/** 
 * Base class that you can (optionally) use to 
 * implement a custom formatter for SpecMap.
 * 
 * Using SpecMap.run() to run your specs will output to 
 * the console using whatever SpecMapFormatter instance 
 * that SpecMap.formatter is set to.
 */
class SpecMapFormatter {

  /** Called before running any specs. */
  header(){}

  /** Called once for each describe. */
  describe(SpecMapDescribe describe){}

  /** 
   * Called once for each example.
   *
   * At this point, the example has not been run yet 
   * because it's the formatter's responsibility to actually 
   * run each example by calling example.evaluate() when 
   * you're ready to actually run the example.
   */
  example(SpecMapExample example){}

  /** Run before exiting. */
  footer(){}
}
