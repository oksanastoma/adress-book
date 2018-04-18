var node = document.getElementById('view');
var app = Elm.User.embed(node);

app.ports.jsSave.subscribe(function (model) {
    var s = JSON.stringify(model);
    // var request = {
    //     body: s,
    //     headers: {
    //         'content-type': 'application/json'
    //     }
    // }
    // var callback = function () {
    //     alert('Saved!');
    // }
    // window.fetch("http://localhost:3000/address-book/", request, callback);

     window.localStorage.setItem('book', s);
});

app.ports.jsLoad.subscribe(function () {
    var model = JSON.parse(localStorage.getItem('book'));
    app.ports.load.send(model);
});
