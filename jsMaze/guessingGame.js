
function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function GuessingGame(minLegal, maxLegal)
{
	this.minLegal = minLegal;
	this.maxLegal = maxLegal;


	this.input = function() {
		guess = document.getElementById("guessingGameInput").value;

		document.getElementById("guessingGameInput").value = "";

		if(guess > this.number) {
			this.output(guess + " is higher than the number I am thinking of.");
		}
		else if(guess < this.number) {
			this.output(guess + " is lower than the number I am thinking of.");


		}
		else if(guess == this.number) {
			this.output("You got it!  " + guess + " is the number!");
		}

	}

	this.output = function(text) {
		document.getElementById("guessingGameOutput").value = text;
		//console.log(text);

	}

	this.reset = function() {
		this.number = getRandomInt(this.minLegal, this.maxLegal);

		this.output("I'm ready with a new number.");

		//this.output("Ok, make a guess between " + this.minLegal + " and " + this.maxLegal +".");
		console.log("guessing game reset:  value " + this.number);

	}

	this.reset();


}

