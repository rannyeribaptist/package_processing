
# Bakery Challenge 🥧 👨‍💻
**Ruby version:** 2.7.1

## Run the project :gear:

### Setup the APP :rocket:
In the root directory of the app, run the following commands:

1. `bundle install`
2. `cd db && ruby seeds.rb`

After that, just type `cd ..` to go back to the root directory, and run the app by typing `ruby package_processing.rb` in the terminal.

## How it works :thinking:

When you pass a quantity of unities to the script, it will first try to do the most logical thing in order to try to save shipping space, wich is prepare the order from the biggest pack available to the smaller one.

If the order doesn't return a perfect matching number (no packages missing or surpassing) with the requested quantity, it will pick the result of the first try and will decompose it, by removing units from the biggest package, and attributing these units to the following biggest package.

So let's say you asked for **11 MB11s**, and the outcome was `8x1, 5x0, 2x2` (total is 12).

The algorithm will remove the one unit of the 8 units package, and will attribute this unit to the 5 units package. After that, it will calculate how many units are missing to complete the total requested (in this case, 5 + 2x2 is 9, so there's just 2 left) and will try to fulfill the order with the packages available (adding one pack of 2 units in this case).


To see the rules of the test, just read the ![rules](rules.md) readme in the project's root directory

## Testing :construction:

In this application we use rspec for tests. To test the application just type the following in the project's root path:

 `rspec spec/*`
