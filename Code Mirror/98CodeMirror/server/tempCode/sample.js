var x = [1, 2, 3];
var y = [4, 5, 6];
var z = y;
y = x;
x = z;

x = [1, 2, 3];
y = x;
x.push(4);
y.push(5);
z = [1, 2, 3, 4, 5];
x.push(6);
y.push(7);

y = 'Hello!'

var foo = function(lst) {
      lst.push('hello');
          bar(lst);
}

var bar = function(lst) {
      console.log(lst);
}

foo(x);
foo(z);