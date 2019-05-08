% Facts


% Rules
even(X) :- 0 is mod(X, 2).
odd(X) :- 1 is mod(X, 2).
sumofdigits(X, X) :- X<10.
sumofdigits(X, Y) :- X>=10, X1 is X // 10, X2 is X mod 10, sumofdigits(X1, Y1), Y is Y1 + X2.
denver_born(AGE) :- odd(AGE), sumofdigits(AGE) is < 8. 

