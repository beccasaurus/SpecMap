class FailingExampleSpec extends SpecMap {
  spec() {
    describe("Failing Example", {

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

    describe("Some passing stuff is here too", {
      "green!": () {},
      "yellow!": null
    });
  }
}
