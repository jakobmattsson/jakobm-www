> Unix is simple. It just takes a genius to understand its simplicity.
>
> ###### Dennis Ritchie

This proves to be true over and over again. Not just for UNIX, but for a lot of of things. The concept of a Grand Unified Theory in physics is probably the best example. Now, I don’t work with the fabric and forces of the universe itself, but with the fabric of programs and the forces of people developing and using these programs. The goal is still the same though; as simple as possible, but not simpler.

When it comes to JavaScript, the ubiquitous language of the web, I find that there are two de facto standard functions that perfectly embodies this concept; `Function.bind` and `Object.create` (sometimes called `Object.beget`). They are not part of the standard library (a major mistake of course) but ridiculously simple to implement, yet they require a deep understanding of what’s going on behind the scenes. Actually, my own personal criteria for determining if someone is a JavaScript ninja or not is to ask them to explain the what, why and how of these two functions.

Arguably, `Object.create` is the most complicated one. Apart from the semantics of JavaScript itself, it teaches quite a bit of philosophy. I could ramble about the details of it all day, but it all boils down to a single great argument: it simplifies the language by encapsulating three related but none the less difficult concepts.

- Functions as constructors
- The prototype property
- The new-operator

`Object.create` captures these one by one, in exactly one simple line each, and renders them obsolete:

    Object.create = function(o) {
      function F() {}
      F.prototype = o;
      return new F();
    };

By using this function, none of these three concepts will ever have to be used directly again. I know that there are a lot of people who calls themselves JavaScript-programmers, but still doesn’t understand how/why this is the case. It sure takes a genius to understand the simplicity. Douglas Crockford is one of those. When he is talking about the evil of the new-operator and that it should be avoided, this is what he is referring to. Behind his sometimes strange sounding recommendations there is a philosophy that has to be grasped first; if everything is an object and dynamicity is the goal, then it should be possible to use anything as the base for inheritance (not just “classes”).

I won’t explain how the function works (that has already been done a million times, just google it), but I want you to think about the beauty of it. Three concepts unified in the most generic and straight-forward way imaginable, to create a single abstraction that supersedes the individual ones. It’s like the Maxwell equations of JavaScript.

I’m sure Brendan Eich knew this, but implemented the three-headed hydra instead of something pure and simple due to popular demand. Just like many other features in the language, it was shaped to suit the classical inheritance crowd of C++ and Java. Classical inheritance has its uses, but so does the prototype-model. Someone has to tell JavaScript: “Man, just be yourself. No need to emulate the other languages. You’ve got your own thing going.” Force the mob to learn something new once in a while and maybe they’ll realize just how simple it is.