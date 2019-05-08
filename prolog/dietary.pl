%% dietary.pl
%% Kenneth Berry
%% 
%% A database that has facts and rules for food and meals.


%%---------------------- Food Facts & Rules ----------------------%%

% vegatables
vegatable(carrot).
vegatable(corn).
vegatable(beans).
vegatable(cucumber).

% fruits
fruit(apple).
fruit(banana).
fruit(pineapple).
fruit(pear).

% desserts
dessert(cake).
dessert(pie).
dessert(icecream).
dessert(fudge).

% snacks
snack(chips).
snack(popcorn).
snack(fries).
snack(candy).
snack(Food) :- fruit(Food).   % all fruits are snacks
snack(Food) :- dessert(Food). % all desserts are snacks

% proteins
protein(steak).
protein(fish).
protein(chicken).
protein(pork).
protein(bacon).

% starches
starch(corn).
starch(potato).
starch(bread).
starch(rice).

% breakfast food
breakfastfood(pancakes).
breakfastfood(waffles).
breakfastfood(bacon).
breakfastfood(Food) :- fruit(Food).  % fruits are breakfast food

% breakfast drinks
breakfastdrink(juice).
breakfastdrink(coffee).
breakfastdrink(milk).

% drinks
drink(Drink) :- breakfastdrink(Drink). % breakfast drinks are drinks
drink(water).
drink(tea).
drink(coffee).
drink(soda).


%%---------------------- Meal Rules ----------------------%%

% breakfast can consist of a breakfastfood and a breakfastdrink
breakfast(A, B) :- ((breakfastfood(A), breakfastdrink(B)) |
                   (breakfastdrink(A), breakfastfood(B))),
                   (A \= B).

% A meal can consist of a snack and a drink
meal(A, B) :- (snack(A) | snack(B)),
              (drink(A) | drink(B)),
              (A \= B).

% A meal can consist of a protein, veggie, dessert, and drink
meal(A, B, C, D) :- protein(A), vegatable(B), dessert(C), drink(D).

% A meal can consist of a protein, veggie, startch, and drink
meal(A, B, C, D) :- protein(A), vegatable(B), starch(C), drink(D).

% A meal can consist of a protein, veggie, starch, dessert, and drink
meal(A, B, C, D, E) :- protein(A), vegatable(B), starch(C), dessert(D), drink(E).
