# Python(GUI)

To make the program more user friendly, I have implemented a GUI version of the program.

To make this possible, I have converted the MATLAB code into Python code as Python comes with built-in libraries that make it easier to implement GUI. Also, Python also comes with libraries such as Matplotlib and NumPy that are like MATLAB and helps in plotting graphs and doing complex calculations.

## GUI Implementation

1.  A Graphical interface that includes a dialog box that guides the user to select any two Psychrometric properties and then enter their values along with height from sea level and remarks for that calculation. After entering the properties, when the user clicks on Evaluate, the program calculates all the Psychrometric properties and displays them on the screen. The GUI also helps the user in selecting the Psychrometric properties so that the user does not select any incompatible set of Psychrometric properties. Also, the GUI does not allow the user to click on Evaluate without entering the values of both the Psychrometric properties and height from seal level.
2.  Once the user clicks on Evaluate and all the Psychrometric properties have been calculated, the program automatically enters all the data into a database along with the remarks and System time. Which helps managing the data of our calculations.
3.  Once the user clicks on Evaluate, the Plot Graph button is enabled. Once the user clicks on it, a new dialog-box opens and plots constant property lines of all the calculated Psychrometric properties which also gives an option to save the graph as in image. Also, the GUI does not allow the user to click on Plot Graph button before the user clicks on Evaluate button.
4.  The GUI also provides a button 3D Graph. Once the user clicks on 3D Graph, a new dialog-box opens and asks the user for selecting any Psychrometric property and its value. Once the values is entered, a new dialog-box opens and plots a constant property curve of that Psychrometric property which also gives an option to save the plot as an image.
5.  The GUI also provides a button Full Graph. Once the user clicks on Full Graph, a new dialog-box opens and asks the user for height from sea level. Once the value is entered, a new dialog-box opens and plots the full Psychrometric chart which also gives an option to save the graph as an image.
6.  The GUI also provides a button Show Database Entries. Once the user clicks on Show Database Entries, a new dialog-box opens and fetches all the previous calculations in different rows along with remarks and date.

## Libraries used

- Tkinter
- NumPy
- Matplotlib
- MySQL.connector
- Scipy

## Installation

1. Open terminal in the Python(GUI) folder.
2. Run pip install -r requirements.txt

All the dependencies will be installed.

If you want to use the database features, install MYSQL in your system and configure the connect_to_mysql() function in the psychrometry.py file. Also, run the Psychrometry.sql file in MySQL Workbench.

Now, Run the Python file.