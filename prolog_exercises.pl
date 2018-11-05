/********************************************************************************************************************
			Author: Leonidas Triantafyllou
			Implemented in Fall 2016-2017
********************************************************************************************************************/

%------------------------------------------Exercise 1----------------------------------------------------------------

% Exercise 1: pokemon evolutions

%calculate evolutions for one pokemon
evolutions(P,S,N):-S<P,
				   N is 0.
evolutions(P,S,N):-S>=P,
				   W is S-P+2, evolutions(P,W,NN),
				   N is NN+1.

%calculate evolutions for every pokemon and creating a list of all pokemon names and their number of evolutions
allevs([],[]).
allevs([(Z,X,Y)|L],[(Z,N)|T]):-evolutions(X,Y,N),
							   allevs(L,T).

%calculate total of evolutions
totalevs([],0).
totalevs([(_,Y)|T],N):-totalevs(T,N2),
					   N is N2 + Y.

%sort the list created to find the pokemon with most evolutions
insert((X,Y),[],[(X,Y)]).
insert((X,Y),[(H1,H2)|T],[(H1,H2)|W]):-Y<H2,
									   insert((X,Y),T,W).
insert((X,Y),[(H1,H2)|T],[(X,Y)|W]):-Y>=H2,
									 insert((H1,H2),T,W).

sortl([],[]).
sortl([(X,Y)|T],Z):-sortl(T,W),
					insert((X,Y),W,Z).

takefirst([(X,_)|_],X).

%solution
pokemon(L,N,S):-allevs(L,R),
				totalevs(R,N),
				sortl(R,Z),
				takefirst(Z,S).

%------------------------------------------Exercise 2-----------------------------------------------------------------------

% Exercise 2: plane food problem

%time for flight attendant to serve every seat
seat(Y,T2):-Y = a, T2 is 4.
seat(Y,T2):-Y = b, T2 is 5.
seat(Y,T2):-Y = c, T2 is 6.
seat(Y,T2):-Y = d, T2 is 3.
seat(Y,T2):-Y = e, T2 is 2.
seat(Y,T2):-Y = f, T2 is 1.

%if mitsos sits in second line of flight attendant's lines then we add the time for first line too (7sec = 6 sec for line and 1 to go to next)
mylunch(1,Y,T):- seat(Y,T2),
				 T is T2.
mylunch(2,Y,T):- seat(Y,T2),
				 T is 7+T2.
mylunch(3,Y,T):- seat(Y,T2),
				 T is T2.
mylunch(4,Y,T):- seat(Y,T2),
				 T is 7+T2.

%for every two lines which flight attendant servers we add 16 seconds which is the time needed
%for flight attendant to server her two lines and walk to her next line 
mylunch(R,S,T):- (R-1)//4 > 0,
				 Z is R-4, mylunch(Z,S,W),
				 T is W + 16.

%------------------------------------------Exercise 3-----------------------------------------------------------------------

% Exercise 3: palindromic list

%reverse list
reverselist([],[]).
reverselist([X|Xs],Ys):-reverselist(Xs,Rs),
						append(Rs,[X],Ys).

/*we compare the starting list with the reversed and when numbers are same we move to the next number
of every list. if a number is greater than the other, we move to next number and the number that is less
than the other we add it to its next and we continue till lists are same*/
function(L,L,N):-N is 0.
function([X1,Y1|T1],[X1,Y2|T2],N):-function([Y1|T1],[Y2|T2],N).
function([X1],[X2,Y2],N):-X1>X2,
						  H is X2+Y2,
						  function([X1],[H],N1),
						  N is N1+1.
function([X1,Y1],[X2],N):-X1<X2,
						  H is X1+Y1,
						  function([H],[X2],N1),
						  N is N1+1.
function([X1,Y1|T1],[X2,Y2|T2],N):-X1<X2,
								   H is X1+Y1,
								   function([H|T1],[X2,Y2|T2],N1),
								   N is N1+1.
function([X1,Y1|T1],[X2,Y2|T2],N):-X1>X2,
								   H is X2+Y2,
								   function([X1,Y1|T1],[H|T2],N1),
								   N is N1+1.

%we divide the result by two because we have double additions
palindromic(L,N):-reverselist(L,R), function(L,R,N1), N is N1/2.

%------------------------------------------Exercise 4-----------------------------------------------------------------------

% Exercise4: mymatrix

/*for even N:
because (x(1)+x(2)+..+x(n))/n= Average, x(n) for every row is x(n) = n * x((n/2)+1) - sum
where sum of n-1 first elements of every row
we choose (n/2)+1 in order not to have the same number two times in the matrix
every element from 1 to N-1 is the previous number + K. So, with this way we create  the N-1 rows of matrix.
The first element of every row(2 to n-2) is the first element of previous row + 2 * N
MS is the N/2+1 element of every row and MSV the value of this element. */

createrow1(_,N,_,_,_,_,[]):-N=<0.
createrow1(M,N,V,Sum,MS,MSV,[X|T]):-N>1,N =\= MS,
									NN is N - 1, 
									X is V, 
									NV is V+1, 
									NSum is Sum+X, 
									createrow1(M,NN,NV,NSum,MS,MSV,T).
createrow1(M,N,V,Sum,MS,_,[X|T]):-N>1,
								  N =:= MS,
								  NN is N - 1,
								  X is V,
								  NV is V+1,
								  NMSV is X,
								  NSum is Sum+X,
								  createrow1(M,NN,NV,NSum,MS,NMSV,T).

createrow1(M,N,_,Sum,MS,MSV,[X|T]):-N=:=1,
									NN is N - 1,
									X is M*MSV-Sum,
									createrow1(M,NN,_,Sum,MS,MSV,T).

row1(N,K,X):-MSV is 0,
			 MS is N-(N//2),
			 Sum is 0,
			 createrow1(N,N,K,Sum,MS,MSV,X).

head([X|_],X).

creatematrix1(_, N, _, [],[]):-N=<1.
creatematrix1(M, N, Y, [X1|T1],[X2|T2]):-N>1,
										 row1(M,Y,X1),
										 head(X1,X2),
										 NN is N-1,
										 NY is Y+2*M,
										 creatematrix1(M, NN, NY, T1,T2).
 
sum([],0).
sum([X|T],Sum):-sum(T,Nsum),
			    Sum is Nsum+X.

/* The first element of last row is found with the above rule for the first column and all the next elements
to element N-1 of row are found from the first element + element_position_of_row * K. The last element
with the above rule */

find([_|T],N,MS,R):- N =\= MS,
					 N1 is N - 1, find(T,N1,MS,R).
find([X|_],N,MS,R):- N =:= MS,
					 R is X.

lastrowfirst(N,Y,R):-sum(Y,Sum),
					 MS is N-(N//2),
					 find(Y,N,MS,MSV),
					 R is N*MSV-Sum.

%-----------------------
%for odd N:
createrow2(N,_,_,[]):-N=<0.
createrow2(N,S,K,[X|T]):-N>0, NN is N - 1, X is S, NS is S+K, createrow2(NN,NS,K,T).

creatematrix2(_, N, _, _, []):-N=<0.
creatematrix2(M, N, S, K, [X|T]):-N>0, createrow2(M,S,K,X), NN is N-1, NS is S+M*K, creatematrix2(M, NN, NS, K, T).

%-----------------------
%solution
mymatrix(N,_):-N=<2.
%for even N, we create N-1 rows(A) and then the last row(B). in the end we append A and B
mymatrix(N,M):-N>2,N mod 2 =:= 0, K is 1, creatematrix1(N,N,K,A,Y), lastrowfirst(N,Y,Z), row1(N,Z,B), append(A,[B],M).
%for odd N, we can give values to K and S and create a matrix
%K is the step and every number is previous number + K
mymatrix(N,M):-N>2,N mod 2 =:= 1, K is 3, S is 1, creatematrix2(N,N,S,K,M).

%-------------------------------------------------Exercise 5----------------------------------------------------------------

% Exercise 5: myseat

/*Mitsos checks if we can sit in the last seat. Then checks if he can sit in the first seat. If he does not sit in the first one or in the last one,
then because all passengers think the same way, mitsos will choose the first "good" seat(the front seat is empty) from the left, in order to maximize the
time. If there is not any "good" seat, then Mitsos sits in the first "bad" seat from the right*/

findlength( [], L,L ).
findlength( [_|T] , N , L ) :-N1 is N+1,
							  findlength(T,N1,L).

%Check for last seat
checklast([X|_],F,L,M):-X = e,
						F is 1,
						M is L-1.
checklast([X|_],F,_,M):-X \= e,
						F is 0,
						M is -1.

%check for first seat if last is taken
checkfirst([X|_], F, NF, _, M):- F =\= 1,
								 X = e,
								 NF is 1,
								 M is 0.
checkfirst([X|_], F, NF, _, M):- F =\= 1,
								 X \= e,
								 NF is 0,
								 M is -1.
checkfirst([_|_], F, NF, PM, M):- F =:= 1,
								  NF is 1,
								  M is PM.

%Check starting from left to find two empty seats in a row and seat in second one if first and last is taken 
checkforgood(X,NF,NNF,_,M):-NF=\=1,
							N is 0,
							findgood(X,N,NNF,M).
checkforgood(_,NF,NNF,PM,M):-NF=:=1,
							 NNF is 1,
							 M is PM.

findgood([_],_,NNF,M):-M is -1,
					   NNF is 0.
findgood([X,Y|_],N,NNF,M):-X = e, Y = e,
						   NN is N+1,
						   M is NN,
						   NNF is 1.
findgood([X,Y|T],N,NNF,M):-X \= e, Y = e,
						   NN is N+1,
						   findgood([Y|T],NN,NNF,M).
findgood([X,Y|T],N,NNF,M):-X = e, Y \= e,
						   NN is N+1,
						   findgood([Y|T],NN,NNF,M).
findgood([X,Y|T],N,NNF,M):-X \= e, Y \= e,
						   NN is N+1,
						   findgood([Y|T],NN,NNF,M).

%Check starting from right and find an empty seat.
checkbestright(X,NNF,L,_,M):-NNF=\=1,
							 N is L,
							 findbestright(X,N,M).
checkbestright(_,NNF,_,PM,M):-NNF=:=1,
							  M is PM.

findbestright([],_,M):-M is -1.
findbestright([X|_],N,M):-X = e,
						  NN is N-1,
						  M is NN.
findbestright([X|T],N,M):-X \= e,
						  NN is N-1,
						  findbestright(T,NN,M).

%Be careful! When there is no empty seat M is -1
myseat(L,M):- findlength(L,0,Len),
		      reverselist(L,Y),
			  checklast(Y,F,Len,PPPM),
	          checkfirst(L, F, NF,PPPM, PPM), 
			  checkforgood(L,NF,NNF,PPM,PM),
			  checkbestright(Y,NNF,Len,PM,M).
