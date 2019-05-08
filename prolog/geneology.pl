% Facts
man(adam).
man(peter).
man(paul).
woman(marry).
woman(eve).

likes(alice, bob).
likes(bob, carol).
likes(james, mary).
likes(mary, james).

parent(adam, peter).
parent(eve, peter).
parent(adam, paul).
parent(marry, paul).

% Rules
father(F, C) :- man(F), parent(F, C).
mother(M, C) :- woman(M), parent(M, C).

is_father(F) :- father(F, _).
is_mother(F) :- mother(M, _).

love_compatible(X, Y) :- likes(X, Y), likes(Y, X).