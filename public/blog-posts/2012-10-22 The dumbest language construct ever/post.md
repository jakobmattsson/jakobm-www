I answered a question on stackoverflow yesterday that made me realize something almost insane. That’s the good part about having to explain things to other people by the way; you really starting thinking about all the whys.

Anyway, what I realized was that the `void`-keyword in JavaScript is so trivial to implement that it’s embarrassing. Language constructs should provide orthogonal building blocks for constructing programs. Abstractions that can be built from those should be put in a standard library or 3rd party ones; not in the language itself. The `void`-keyword is such a perfect example of the opposite, since it can be implemented in one line. It’s equivalent to the empty function! 

Implementation for you:

    function myVoid() {}

Now these are the same, except for the quite useless syntactic sugar allowing us to leave out the parentheses:

    var res1 = void 1 + 2;
    var res2 = void any(expression(goes(here)));

    var res1 = myVoid(1 + 2);
    var res2 = myVoid(any(expression(goes(here))));

If sugar is really important to you, then you are probably already using [CoffeeScript](http://coffeescript.org/) and can skip the parentheses as usual.
