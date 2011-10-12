class ExampleSpec extends SpecMap {
  spec() {
    map({

      'This should blow up': () {
        var foo = 5;
        foo.iDontExist();
      },

      'This should fail': (){
        Expect.equals(1, 2);
      },

      'This should fail too': (){
        Expect.equals('foo', 'bar');
      }

    });
  }
}
