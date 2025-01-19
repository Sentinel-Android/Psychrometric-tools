# Matlab program

The  will enable one to calculate a complete set of psychrometric properties conditioned by three fundamental inputs: height above sea level, in order to make possible the definition of total atmospheric pressure, and two others like temperature, humidity ratio, or relative humidity.

In addition to its ability to return numerical results, the program offers powerful graphical capabilities. It can plot constant property curves on a psychrometric chart that will be used to understand how the various air parameters interact at different conditions. The program also allows plotting of 3D curves based on one psychrometric property to intuitively recognize any trends or correlations. Features such as these are most beneficial in emulating varied environmental conditions to optimize the design and operational efficiency of the AWG.

There are two programs:
- psychrometry.m(Uses ASHRAE functions to find Saturation Pressure(Psat) when Temperature(T) is given)
- psychrometry1.m(Uses ASHRAE tables to Saturation Pressure(Psat) when Temperature(T) is given)

### Psychrometric calculator

When three Psychrometric properties are given, it calculates all other Psychrometric properties. The given properties include H(which calculates PT) and two other properties which are not mutually dependent.

### 2D graph

A 2D graph of constant Psychrometric properties is plotted when a Psychrometric calculation is done. All the final psychrometric properties are considered as constants and a curve is plotted between SH and DB.
DB is taken as a vector and an equation between SH and DB is used to plot the curve.

### 3D surface

A 3D surface is plotted between SH, DB and PT where DB and PT are vectors. It is used when a psychrometric property is given and we want to find variations in SH over a range of values of DB and PT.

### Full graph

A full Psychrometric chart is plotted taking DB as vector.

## How the program works

The program consists of many functions that does their required tasks.
1.	psychrometry(): This is the main function of the program and provides an interactive environment for the user and asks them what they want to do. It runs in an infinite loop until it receives ‘n’ as input to choice for if the user wants to perform another calculation. It calls other functions for their operations.
2.	psychrometric_calculator(): This function is called by psychrometry() function and it calls other functions as per the choice of the user.
3.	PP1_PP2(): There are 28 such functions. These functions are called by psychrometric_calculator() function and they find all the other psychrometric properties. They call graph2D() function and gives all the Psychrometric properties as arguments.
4.	graph2D(): This function takes all the Psychrometric properties as arguments and plots a 2D graph between SH and DB taking all the Psychrometric properties as constants.
5.	graph3D(): This function plots a 3D surface and is called by psychrometry() function. It takes a Psychrometric property as input and plots a constant property surface between SH, DB and PT.
6.	 graph_full(): This function is called by psychrometry() function and plots a full Psychrometric Chart.

## How to use

Just run the program in Matlab.

While plotting a curve, finish all the instructions in the program before interacting with the curve.