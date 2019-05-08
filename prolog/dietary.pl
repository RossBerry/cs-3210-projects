%%---------------------- Food Facts & Rules ----------------------%%

% vegatables
vegatable(carrot).
vegatable(corn).
vegatable(rice).
vegatable(beans).

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
snack(A) :- fruit(A).
snack(A) :- dessert(A).

% proteins
protein(steak).
protein(fish).
protein(chicken).
protein(beans).

% starches
starch(corn).
starch(potato).

% breakfast drinks
breakfastdrink(juice).
breakfastdrink(coffee).
breakfastdrink(milk).

% drinks
drink(_) :- breakfastdrink(_).
drink(water).
drink(tea).
drink(coffee).
drink(soda).

%%---------------------- Meal Rules ----------------------%%


meal(A, B) :- (snack(A) | snack(B)),
              (drink(A) | drink(B)),
              (A \= B).

meal(A, B, C, D) :- protein(A), vegatable(B), dessert(C), drink(D).

meal(A, B, C, D) :- protein(A), vegatable(B), starch(C), drink(D).
meal(A, B, C, D, E) :- protein(A), vegatable(B), starch(C), dessert(D), drink(E).

