
// load the text from a particular file into a variable and return it
function loadText(filename) {
	// returns the text as a string

	  var xmlhttp, text;
	  xmlhttp = new XMLHttpRequest();
	  xmlhttp.overrideMimeType("text/plain; charset=x-user-defined");
	  xmlhttp.open('GET', filename, false);
	  xmlhttp.send();
	  text = xmlhttp.responseText;
	  return text;
}



function createEditor(textAreaID, filename, editorParameters) {
	// returns the editor object created by CodeMirror

	  // set some default editor parameters
	  editorParameters = typeof editorParameters !== 'undefined' ? editorParameters : {      lineNumbers: true,
	  	mode: "text/javascript",
	  	matchBrackets: true
	  };

	  var text = loadText(filename);

	  document.getElementById(textAreaID).value = text;

	  return CodeMirror.fromTextArea(document.getElementById(textAreaID), editorParameters);
}
