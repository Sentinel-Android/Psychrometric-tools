# Python library

To increase the usability of the program, I have made a Python library out of it. It will help use to use the program in our other projects.

## Libraries used

- NumPy
- Matplotlib
- Scipy

## Installation

1. Open terminal in the psychrometry folder
2. Run pip install .
3. Open command prompt
4. Run pip show psychrometry and copy the address of the python libraries folder
5. Copy the psychrometry folder into the folder where where all the python libraries are located

## How to use

1. To perform Psychrometric calculations we have to import psychrometric_calculator() function
from psychrometry import psychrometric_calculator
The function returns all the Psychrometric properties as a dictionary. So, either store this in a variable or print any specific Psychrometric property.
Example-1. value=psychrometric_calculator('DB', 'SH', 0, 27, 0.01)
        2. print(psychrometric_calculator('DB', 'SH', 0, 27, 0.01)['DB'])
The function takes 5 values(and a 6th optional) as parameters:
    1. First Psychrometric property as a string
    2. Second Psychrometric property as a string
    3. Height from sea level
    4. Value of first Psychrometric property
    5. Value of second Psychrometric property

2. To plot 2D graph we have to import graph2D() function
from psychrometry import graph2D
To use this modify the calling of psychrometric_Calculator function.
Example-print(psychrometric_calculator('DB', 'SH', 0, 27, 0.01, graph2D)['DB'])

3. To plot 3D curve we have to import graph3D() function
from psychrometry import graph3D
To use this, directly call the function.
Example-graph3D('ET', 50)
The function takes 2 values as parameters:
    1. Psychrometric property
    2. Value of that Psychrometric property

4. To plot full graph we have to import graph_full() function
from psychrometry import graph_full()
To use this, directly call the function.
Example-graph_full(0)
The function takes 1 values as parameter:
1. Height from sea level