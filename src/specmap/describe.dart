/** Represents a named set of [SpecMapExample] examples */
class SpecMapDescribe {

  /** The subject of this describe. */
  String subject;

  /** Represents all of the examples in this describe. */
  List<SpecMapExample> examples;

  /** 
   * Initializes a SpecMapDescribe given a subject and a 
   * Map<String,Function> representing this describe's examples. */
  SpecMapDescribe(this.subject, var mapOfExamples) {
    examples = new List<SpecMapExample>();
    mapOfExamples.forEach((exampleName, value) {
      if (value is SpecMapAsyncFunction)
        examples.add(new SpecMapExample(this, exampleName, value.block, true));
      else
        examples.add(new SpecMapExample(this, exampleName, value, false));
    });
  }
}
