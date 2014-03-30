/*
palindrome_checker.js
CS 1 example by HFH.
Checks the text to see if it is a palindrome.
*/

/*

*/
function palindrome_checker(text){
  
  	// The index of the last character in the passed text
  	var lastCharIndex = text.length - 1;
  
  	// If there is only one character or less left in the passed text.
    if (lastCharIndex <= 0) return true;

  	// If the the first and last characters of the passed text
  	// are the same, test the remaining text.
	else if (text[0] == text[lastCharIndex])
      return palindrome_checker(text.substring(1, lastCharIndex));
        
  	// Otherwise the text can't be a palindrome.
	else return false;
}

//Driver code
text = prompt("Enter some text");
if (palindrome_checker(text))
  print(text + " is a palindrome");
else
  print(text + " is not a palindrome")