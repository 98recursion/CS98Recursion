/*
binary_search.js
Solution to CS 1 Short Assignment 8 by HFH.
Performs binary search on a sorted list of random numbers.
*/
/*
Perform binary search for key on the sublist of the_list
starting at index left and going up to and including index right.
If key appears in the_list, return the index where it appears.
Otherwise, return null.
Requires the_list to be sorted.
*/
function binary_search(the_list, key, left, right){
    //If no default parameters, search the entire list.
	if (arguments.length == 2){
		left = 0;
		right = the_list.length;
	}
	
	//If the list is empty, then the key is not found.
	if (left > right) return null;
	else{
		//Find the midpoint of this sublist.
		var midpoint = Math.floor((left + right) / 2);

		//Is it the midpoint?
		if (the_list[midpoint] == key)
			return midpoint;
		else if (the_list[midpoint] > key)
			//Try the left half of the_list.
			return binary_search(the_list, key, left, midpoint - 1);
		else
			//Try the right half of the_list.
			return binary_search(the_list, key, midpoint + 1, right);
	}
}

//Driver code for binary search.
var input = prompt("How many items in the list? ");

//Make a list of n random ints.
var i = 0;
var list = [];
while (i < input){
	list[i] = Math.floor(Math.random()*1001);
	i++;
}

//Binary search wants a sorted list.
list = list.sort(function(a,b){return a - b});
print("The List: " + list);

var number = prompt("What value to search for? ");
var result = binary_search(list, number);

if (result != null) print(number + " found at index " + result);
else print(number + " not found");