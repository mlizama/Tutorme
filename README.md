# Tutorme
Senior Project, IOS app to facilitate Tutor and Tutee interaction aimed at university students
View Controller Structure

someViewController : UIKit Delegate
{

Class variable
View Delegates (viewWillLoad, viewDidLoad, etc.)
Personal Functions
Class Delegates (textbox, button, mandatory/optional)

}


Function Naming Convention

Function name standard. First word must be in lowercase followed by an uppercase character for the first character of the preceding words.
   Ex.
	-addTwoValues(int value1, int value2);





















TO DO LIST

Remove all commented code.  =>

Create function to return formatted string for desired output. =>
Ex., desired output, 
“name=”+userName+”&password=”+password
“u_id=”+id+”&Date=”+date+”&avaiable=”true/false
NOTES. Use a dictionary to store username, password, and additional parameters then a function can be used to parse through the dictionary to Return the desired formatted output string. Keys would contain the left of the equals sign and Value would contain the right side of the equal sign then the function puts both key value pairs together in a formatted string with “=” and “&” at the correct parts of the string. 

Fix Bridging Header for Swift and Objective-C Class file visibility. =>

Fix storyboard view layouts for easier visualization. =>
