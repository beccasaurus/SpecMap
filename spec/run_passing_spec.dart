#import("../src/specmap.dart");

#source("passing_example_spec.dart");
#source("more_passing_examples_spec.dart");

int main() => SpecMap.run([
  new PassingExampleSpec(), new MorePassingExamplesSpec()
]);
