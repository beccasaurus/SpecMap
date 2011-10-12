class MorePassingExamplesSpec extends SpecMap {
  spec() {
    var str = "My String";

    describe("More Passing Examples", {

      'This should be OK': () {
        Expect.equals(1, 1);
      },

      'Yet another pending': null,

      "I should have access to my closure's variables": () {
        // Note!  We have the *DIFFERENT* str here, so the value 
        // was updated.  To be safe, use unique variables for each describe!
        Expect.equals("My String - DIFFERENT!", str);
      }

    });

    // change the variable to see how it effects the specs
    str += " - DIFFERENT!";

    // make a new, unique variable
    var new_str = "New string";

    describe("EVEN More Passing Examples!", {

      'This should be OK too': () {
        Expect.equals(1, 1);
      },

      'Yet yet another pending': null,

      "I should also have access to my closure's variables, even if they changed": () {
        Expect.equals("My String - DIFFERENT!", str);
        Expect.equals("New string", new_str);
      }

    });
  }
}
