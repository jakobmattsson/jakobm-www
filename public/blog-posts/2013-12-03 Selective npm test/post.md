When writing programs using node.js `npm test` is typically how you run your tests. Although when I'm coding, I typically want to run just the test(s) that I'm working on and not ALL of them. Sure, if the entire suite can run in less than a second I don't mind, but that is usually not the case. There are two ways in which I've typically dealt with this.

The first one is indicating which tests I want to run with code - and it sucks! Using `mocha` for example (a testing framework I use quite a lot) you can do this by adding `.only` to your test, like this:

    describe('someFunction', function() {
      it.only('always returns 4', function() {
        someFunction().should.eql(4);
      });
    });

No matter how many other tests you have, only this one will run. Now the problem is that sometimes you forget removing `.only` and then you commit. Your continous integration (and maybe even deployment) system will run **this one test** and conclude that the entire project still works. Thanks `.only`. Now I've deployed a version of my system where my new feature works, but potentiallt nothing else. Note that I'm not blaming `mocha` in particular here (expect for the fact that the framework implements such a retarded concept). It's the pattern, that's found in lots of other testing tools as well, that is the real problem.

The second way is a lot better. You tell the actual runner of your tests which tests you'd like to run. Once again, using mocha, that would be done by passing it the argument `--grep` on the command line. So for the example test above, I'd do:

    mocha --grep someFunction

Now that's fine, except for the fact that I typically have other parameters that I'm passing to mocha as well. In reality, it'd probably look more like this:

    mocha tests --timeout 500 --compilers coffee:coffee-script --recursive --grep someFunction

Needless to say, I don't want to write that entire thing everytime I run a test. One, because I'm lazy, and two, because it's error prone. Maybe I forget one argument. Different projects have different test setups and I work on a lot of small projects. That's exactly the reason why we have `npm test`! We want to abstract away the configuration of the test and just be able to run the damn thing.

So finally, here's what I usually do; I put the following into my package.json (with any combination of arguments and setup that I need):

    "scripts": {
      "test": "mocha tests --timeout 500 --compilers coffee:coffee-script --recursive --grep \"$TESTS\""
    }

With the help of this environment variable I can now run selective tests like this:

    TESTS=someFunction npm test

If I just run `npm test`, all tests will run as usual.

The reason I have ended up calling the variable `TESTS` rather than `GREP` or something is that I want to keep if framework agnostic. All projects doesn't use mocha and then the argument would no longer be called grep.

I hope this helps some people out there, who have been doing `.only` too many times or are just tired of typing long error prone commands. And if you have another way of dealing with this, please share it! I'm very curious!
