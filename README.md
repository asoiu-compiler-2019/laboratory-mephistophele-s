# Chef programming language translator

This translator executes simple statements in Chef language by translating it in Swift.

"Hello World" program in Chef:

"""
Lobsters with Fruit and Nuts.

Ingredients.
72 g hazelnuts
101 g eggs
108 g lobsters
111 ml orange
32 g sugar
87 ml water
114 g rice
100 g durian

Method.
Put durian into the mixing bowl
Put lobsters into the mixing bowl
Put rice into the mixing bowl
Put orange into the mixing bowl
Put water into the mixing bowl
Put sugar into the mixing bowl
Put orange into the mixing bowl
Put lobsters into the mixing bowl
Put lobsters into the mixing bowl
Put eggs into the mixing bowl
Put hazelnuts into the mixing bowl
Liquefy contents of the mixing bowl
Serve 1
"""

# How to use Chef

There are 2 types of variables: liquid and solid. Liquid have char as there value, solid - integer. To declare solid variable you should state int value, measure - "g", and then name. The same for liquid, but with "ml" measure. The value of liquid variable is the first letter of its name. 

You can turn solid vars liquid by using Liquefy command.

Put command puts var in stack. 
Serve command prints content of stack.

Title of programm is vital and can be any string.
Titles "Ingredients" and "Method" are reserved words and also vital.

# How translator works

Lexer splits programm into tokens.
Syntax analyzer creates syntax tree of commands and variables and finds syntax errors.
Translator then goes through tree executing commands and finds semantic errors.

