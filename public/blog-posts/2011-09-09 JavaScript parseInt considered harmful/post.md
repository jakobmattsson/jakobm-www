Some devs use JavaScript’s parseInt in order to convert floats to ints. It works perfectly fine most of the time, but happens to result in an excellent gotcha in a certain edge-case. So shame on you guys!

I wrote a highly upvoted answer at stackoverflow on this. Read the whole thing [here](http://stackoverflow.com/questions/7353592/math-random-returns-value-greater-than-one/7353714#7353714) or just gist of it below:

    var test = 9.546056389808655e-8;
    
    console.log(test); // prints 9.546056389808655e-8
    console.log(parseInt(test)); // prints 9 - oh noes!
    console.log(Math.floor(test)) // prints 0 - this is better
