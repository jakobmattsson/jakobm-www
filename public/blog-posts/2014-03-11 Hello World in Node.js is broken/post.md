I just realized there's a minor fallacy in the typical Node.js Hello World-program.
The same program is found in countless tutorials as well on [nodejs.org](http://nodejs.org) itself. And it's broken.

This is the code I'm talking about:

    var http = require('http');
    http.createServer(function (req, res) {
      res.writeHead(200, {'Content-Type': 'text/plain'});
      res.end('Hello World\n');
    }).listen(1337, '127.0.0.1');
    console.log('Server running at http://127.0.0.1:1337/');

Super-simple! It's a web server in a few lines. Wow.

Now, what's the error?

Node.js is highly asynchronous. Just because you called a function and that function has returned doesn't mean that the function has completed its task. If you've ever written anything in JavaScript or Node.js you've been exposed to this and you know that you should pass callbacks to solve this. The return value of a function is usually less useful than the invokation of the callback. You probably already know why this is powerful (async without threads etc). Oftentimes, that is. Or sometimes. Or so. You also know it's still hard to get it right. Actually, it's so hard that even this tiny program got it wrong.

Here's a slightly enhanced version that got it right:

    var http = require('http');
    http.createServer(function (req, res) {
      res.writeHead(200, {'Content-Type': 'text/plain'});
      res.end('Hello World\n');
    }).listen(1337, '127.0.0.1', function() {
      console.log('Server is *actually* running now');
    });
    console.log('Server is not really running yet');
    console.log('Syncronous access here would fail.')

As you can see from the log-statements, there's a difference between having called
`createServer`/`listen` and actually having a server that listen to requests. As
per usual, things are not finished until the callback is invoked. You **cannot** go
ahead just because your function call has returned. You are failing at async.

I'm sorry Hello World. You are so young and small and innocent, but you just proved a very important point.

Async is hard.

### Disclaimer

* I love JavaScript and Node.js. This post is just some rough love.
* I know that you would never synchronously send requests to a web server in Node.js. For all practical purposes, the original code example is fine.
* I want to point out that async is hard. It's easy to miss things. Easier than you think.
* I also want to point out that tutorials often over-simplify. I'm sure this tiny adjustment was intentional in the name of simplicity.
* There are other example in the Node.js HTTP docs where things are done the right way, like [this](http://nodejs.org/api/http.html#http_event_connect_1) for example.

### Bonus

If you like using promises to simplify the async-challenges check out my library for making using them easier: [Z](https://github.com/jakobmattsson/z-core)

If you haven't really grokked the point of promises yet, or find the cure as bad as the disease, then check out this presentation: [How to actually use promises](https://speakerdeck.com/jakobmattsson/how-to-star-actually-star-use-promises-in-javascript)
