#import("../pkg/specmap.dart");

#source("failing_example_spec.dart");

main() {
  SpecMap.raiseExceptions = true;
  SpecMap.run(new FailingExampleSpec());
}
