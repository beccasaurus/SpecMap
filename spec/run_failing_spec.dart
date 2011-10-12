#import("../src/specmap.dart");

#source("failing_example_spec.dart");

main() => SpecMap.run(new FailingExampleSpec());
