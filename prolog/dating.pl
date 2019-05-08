%% dating.pl
%% Kenneth Berry
%% 
%% A dating database that can be used to match people for dates.
%% The database includes facts about 5 men and 5 women and things
%% they like.  Matches are made based on conditions in rules for each
%% fact/like and a perfect match is when two people match for all 
%% the categories.


%%---------------------- Facts ----------------------%%

% person's sex
man(john).
man(andy).
man(mike).
man(bob).
man(bill).
woman(anne).
woman(jessica).
woman(kimberly).
woman(jill).
woman(sophie).

% person likes pets
likespets(john).
likespets(mike).
likespets(anne).
likespets(jill).
likespets(sophie).

% person likes dancing
likesdancing(john).
likesdancing(mike).
likesdancing(anne).
likesdancing(sophie).

% person likes books
likesbooks(mike).
likesbooks(bob).
likesbooks(jessica).
likesbooks(jill).
likesbooks(anne).

% person likes movies
likesmovies(andy).
likesmovies(mike).
likesmovies(bob).
likesmovies(bill).
likesmovies(anne).
likesmovies(kimberly).
likesmovies(sophie).

% person enjoys outdoors
likesoutdoors(john).
likesoutdoors(andy).
likesoutdoors(bill).
likesoutdoors(kimberly).
likesoutdoors(sophie).


%%---------------------- Rules ----------------------%%

% match if people are different sexes
matchsex(X, Y) :- ((man(X) , woman(Y)) |
                  (woman(X), man(Y))),
                  (X \= Y).

% match if both people like or dislike pets
matchpets(X, Y) :- ((likespets(X) , likespets(Y)) |
                   (not(likespets(X)) , not(likespets(Y)))),
                   matchsex(X, Y),
                   (X \= Y).

% match if both people like or dislike dancing
matchdancing(X, Y) :- ((likesdancing(X) , likesdancing(Y)) |
                      (not(likesdancing(X)) , not(likesdancing(Y)))),
                      matchsex(X, Y),
                      (X \= Y).

% match if both people like or dislike books
matchbooks(X, Y) :- ((likesbooks(X) , likesbooks(Y)) |
                    (not(likesbooks(X)) , not(likesbooks(Y)))),
                    matchsex(X, Y),
                    (X \= Y).

% match if both people like or dislike movies
matchmovies(X, Y) :- ((likesmovies(X) , likesmovies(Y)) |
                     (not(likesmovies(X)) , not(likesmovies(Y)))),
                     matchsex(X, Y),
                     (X \= Y).

% match if both people like or dislike the outdoors
matchoutdoors(X, Y) :- ((likesoutdoors(X) , likesoutdoors(Y)) |
                       (not(likesoutdoors(X)) , not(likesoutdoors(Y)))),
                       matchsex(X, Y),
                       (X \= Y).

% perfect match if both people like or dislike all the same things
perfectmatch(X, Y) :-  matchsex(X, Y),
                    matchpets(X, Y),
                    matchdancing(X, Y),
                    matchbooks(X, Y),
                    matchmovies(X, Y),
                    matchoutdoors(X, Y).
