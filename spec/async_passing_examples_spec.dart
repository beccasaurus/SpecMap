class AsyncPassingExamplesSpec extends SpecMap {
  spec() {
    describe("Async Examples", {

      "i am asynchronous": async((done) {
        Expect.equals(true, true);
        print("\tasync #1");
        done();
      }),

      "i am also asynchronous, but I FAIL": async((done) {
        print("\tasync #2");
        Expect.equals(true, false);
        done();
      }),

      "i fail, but in the future!": async((done) {
        new Timer((timer) {
          // need to change this from a function to an object for this to work ...
          // but it gives us a way to try to catch exceptions (?)
          done.after((){
            print("\tasync #3");
            Expect.equals(true, false);
            print("\t ^ after Expect fail");
            timer.cancel();
          });
        }, 100);
      }),

      "i pass in the future!": async((done) {
        new Timer((timer) {
          print("\tasync #4");
          Expect.equals(true, true);
          timer.cancel();
          done();
        }, 100);
      })

    });
  }
}
