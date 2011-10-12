class MorePassingExamplesSpec extends SpecMap {
  spec() {
    map({

      'This should be OK': (){
        Expect.equals(1, 1);
      },

      'Yet another pending': null

    });
  }
}
