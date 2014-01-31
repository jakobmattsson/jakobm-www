A lot of folks seem to misunderstand [semver](http://semver.org) and/or how to do versioning in [npm](http://npmjs.org). In particular `~` and `^`, which many believe to be kind of the same thing. This is my take on explaining the difference and why to use one over the other.

Let's say I depend on underscore. My `package.json` then contains the following:

    "dependencies": {
      "underscore": "*"
    }

But the star is bad, because it requires **any** version of underscore, which is probably not what I want. I want to explicitly require a version where all the things I use are included. So then I do this for example:

    "dependencies": {
      "underscore": "1.4.2"
    }

Now I get version `1.4.2` and nothing else. I get all the juciy things from this particular version that I'm using. Sweet. NOT. Why? Because if there's a bug in this version, I won't get fixes automatically.

Enter [semver](http://semver.org). I recommend you click the link and read the whole thing. Carefully.

But you didn't, did you? Ok, so the tl;dr version would be to say that there's a reason why we have three separate numbers in our versions and not just one single number that keeps incrementing. Very simply summarized:

- The first number (the "major") increases when we introduce breaking changes.
- The second number (the "minor") increases when we add new features.
- The third number (the "patch") increases when we fix bugs.

So then I should require underscore like this I guess:

    "dependencies": {
      "underscore": "1.4.x"
    }

That will get any version of underscore that starts with `1.4` and just get any patch - which will allow new patches to be installed when the package is installed.

But what if we know there's a critical bug in `1.4.0` and `1.4.1`? Then we could do something like this:

    "dependencies": {
      "underscore": ">= 1.4.2 < 1.5.0"
    }

Now we will only get versions that start with `1.4` and that have a patch number equal to or larger than 2. Perfect! Almost...

In practice, people patch the latest version when they find bugs and not all the old ones as well. So if underscore `1.5.0` gets released and then `1.6.0` and then they find a bug, that bug will be fixed in `1.6.1`. There won't be a `1.4.3`.

So, since `1.6.1` is also supposed to work if `1.4.2` worked (if you don't understand why, read the semver spec more carefully - only increases in the first number, the major, can introduce breaking changes) then we can just as well accept any minor version and not just any patch version:

    "dependencies": {
      "underscore": ">= 1.4.2 < 2"
    }

Now, this is good! We don't allow the major version to be increased (because that could introduce breaking changes) but the minor and patch (which will never break our code) are allowed to be updated.

Of course all of this assumes that people follow semver. But most people who know what they're doing are. Or are at least attempting to.

Now, what does `^` and `~` have to do with this? Well, the `~` operator works like this:

 - ~1 means >= 1.0.0 and < 2.0.0 (or "Any version starting with 1")
 - ~1.4 means >= 1.4.0 and < 1.5.0 (or "Any version starting with 1.4")
    
That is clearly not optimal according to semver, as outlined above. The operator `^` on the other hand works like this:

 - ^1 means >= 1.0.0 and < 2.0.0 (or "Any version compatible with 1")
 - ^1.4 means >= 1.4.0 and < 2.0.0 (or "Any version compatible with 1.4")
 - ^1.4.2 means >= 1.4.2 and < 2.0.0 (or "Any version compatible with 1.4.2")
    
So using `^1.4.2` is the same as `>= 1.4.2 < 2`, which is the optimal way of specifying a dependencies if semver is being followed. Using `^` is just shorter and sweeter.

These definitions are available right in the [node-semver readme](https://github.com/isaacs/node-semver), which is used to resolved dependencies in npm. 

I use `^` and believe everyone else should too. Just note that you need npm `1.3` or later (introduced in node `0.10.13`) to install a module that uses this operator.
