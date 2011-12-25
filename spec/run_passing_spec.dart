#import("../src/specmap.dart");

#source("passing_example_spec.dart");
#source("more_passing_examples_spec.dart");
#source("async_passing_examples_spec.dart");

main() {
  SpecMap.run([
    new PassingExampleSpec(), new MorePassingExamplesSpec(), new AsyncPassingExamplesSpec()
  ]);
  print("run() complete");
}
