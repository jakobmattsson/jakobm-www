I’ve been writing a lot of JavaScript the past year, but I never ran into this stupid gotcha before. Can’t understand how I’ve avoided it for so long. The correct syntax hurts my brain.

    var str = "foobar";
    var firstChar1 = str[0]; // doesn't work in IE < 9
    var firstChar2 = str.chatAt(0); // works everywhere
