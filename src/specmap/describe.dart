class SpecMapDescribe {

  // The subject of this describe
  String subject;

  // Represents all of the examples in this describe
  List<SpecMapExample> examples;

  // Initializes a SpecMapDescribe given a subject and a 
  // Map<String,Function> representing this describe's examples
  SpecMapDescribe(this.subject, var mapOfExamples) {
    examples = new List<SpecMapExample>();
    mapOfExamples.forEach((exampleName, block) => 
      examples.add(new SpecMapExample(this, exampleName, block)));
  }
}
