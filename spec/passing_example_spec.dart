class PassingExampleSpec extends SpecMap {
  spec() {
    describe("Passing Examples", {

      'This should print Hello': (){
        print('  -> Hello');
      },

      'This should print Foo': (){
        print('  -> Foo');
      },

      'This should be pending': null

    });
  }
}
