class PassingExampleSpec extends SpecMap {
  spec() {
    map({

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
