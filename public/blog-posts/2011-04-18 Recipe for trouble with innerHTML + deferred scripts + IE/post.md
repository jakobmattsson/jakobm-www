Do you have a JavaScript-program that:

- Sets element.innerHTML (because it's a very performant way to manipulate the DOM)
- Has deferred scripts contained in strings (because you manipulate 3rd party string out of your control)
- Requires IE-support (because the world is a sad place)

Then my friend, you might have a serious problem (apart from point 2 and 3, which are quite serious on their own).

You can summon the beast with this simple example, creating a div-tag dynamically and inserting a line break and a defered script into it:


    var e = document.createElement('div');
    e.innerHTML = '<br /><script defer type="text/javascript">alert("Damnit IE!")</' + 'script>';

Now, the div-tag is not even a part of the DOM, yet IE insist on actually running the JavaScript!

**It runs a script that is not even part of the DOM!**

It’s like an eval in disguise! I discovered this by breaking a site (imagine what would happen if you replaced the call to alert with `document.write` for example) and would like to save future generations some tears.

So, remember: A very performant and useful property meets two evils and an even greater evil is produced.
