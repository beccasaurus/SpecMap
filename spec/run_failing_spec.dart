#import("../lib/specmap.dart");

#source("failing_example_spec.dart");

int main() => SpecMap.run(new ExampleSpec());
