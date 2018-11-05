{-
			Author: Leonidas Triantafyllou
			Implemented in Fall 2016-2017
-}

------------------------Problem 1-------------------------

--Count how many left every month
left y []     = []
left y (x:xs) = y-x : left y xs

--Count sum of how many left
suml []     = 0
suml (x:xs) = x + suml xs

--Solution
--Add x megabytes of month n+1
myinternet x xs = x + suml (left x xs)

------------------------Problem 2-------------------------

--remove/pop balloon 'lth' element of list
remb _ []     = []
remb l (y:ys) = if (l == 1) then ( remb (l-1) ys )
                else ( y : remb (l-1) ys )

--Returns a list of balloons that did not pop
--When a balloon's height + 1 is equal to x's height then we remove it from list
blist _ lista [] _                = lista
blist x lista (y:ys) l | (x <= y) = blist x lista ys (l+1)
                       | (x > y)  = if (x == y+1) then ( blist (x-1) (remb l lista) ys l )
                                    else ( blist x lista ys (l+1) )

--Count how many arrows are needed
--For every balloon that we pop we search if other balloonss pop too
arrows []     = 0
arrows (x:xs) = 1 + arrows  (blist x xs xs 1)

--Solution
pinkballoons xs = arrows xs

------------------------Problem 3-------------------------

--split list in lists of n elements
divlist _ []  = []
divlist n ls  = if (n <= 0) then []
                else ( take n ls:divlist n (drop n ls) )
 
--quicksort
qsort [] = []
qsort (x:xs) = qsort [y | y <- xs, y <= x] ++ [x] ++ qsort [y | y <- xs, y > x]

--length of list
lengthl []     = 0
lengthl (x:xs) = 1 + length xs

--find divisors of length of list
divisors n = [x | x <- [1..(n-1)], n `rem` x == 0]

--sort all lists created from splitting the first list
sortall [] = []
sortall (x:xs) = [qsort x] ++ sortall xs

--compare list elements
compEl [_] = True
compEl (x:y:xs) | (x == y) = compEl (y:xs)
                | otherwise = False

--Splits list in lists with x elements and sorts these lists
res x ys = sortall ( divlist x ys )

--Finds the minimum possible length of lists which will be created from splitting list user gave 
sol _ [] min = min
sol xs (y:ys) min | (compEl ( res y xs ) == True) = if (y < min) then sol xs ys y else sol xs ys min   
                  | otherwise  = sol xs ys min

--Solution
--Finds the minimum possible length of lists and which will be created from splitting list
--then splits the list user gave and return the first list of the splitting result
stringroot xs = head ( divlist (sol xs (divisors (lengthl xs) ) (lengthl xs))  xs )

------------------------Problem 4-------------------------

appendl [] ys = ys
appendl (x:xs) ys = x:(appendl xs ys)

{-for even N:
because (x(1)+x(2)+..+x(n))/n= Average, x(n) for every row is x(n) = n * x((n/2)+1) - sum
where sum of n-1 first elements of every row
we choose (n/2)+1 in order not to have the same number two times in the matrix
every element from 1 to N-1 is the previous number + K. So, with this way we create  the N-1 rows of matrix.
The first element of every row(2 to n-2) is the first element of previous row + 2 * N
MS is the N/2+1 element of every row and MSV the value of this element. -}

createrow1 m n v sum ms msv | (n > 1) && (n /= ms) = [v] ++ createrow1 m (n-1) (v+1) (sum+v) ms msv
                            | (n > 1) && (n == ms) = [v] ++ createrow1 m (n-1) (v+1) (sum+v) ms v
                            | ( n == 1) = [m*msv-sum] ++ createrow1 m (n-1) v sum ms msv
                            | ( n < 1) = []
row1 n k = createrow1 n n k 0 (n-(quot n 2)) 0

creatematrix1 m n y | (n > 1) =  [row1 m y] ++ creatematrix1 m (n-1) (y+2*m)
                    | (n <= 1) = []

alllinesfirst m n y | (n > 1) = [head(row1 m y)] ++ alllinesfirst m (n-1) (y+2*m)
                    | (n <= 1) = []

{-The first element of last row is found with the above rule for the first column and all the next elements
to element N-1 of row are found from the first element + element_position_of_row * K. The last element
with the above rule -}

find (x:xs) n ms | (n /= ms) = find xs (n-1) ms
                 | (n == ms) = x

lastrowfirst n xs = n * find xs n (n-(quot n 2)) - suml xs

--lastrowfirst
lsf n = lastrowfirst n (alllinesfirst n n 1)

--lastrow n
lastrow n = row1 n (lsf n)

--for odd N
createrow2 n s k | (n <= 0) = []
                 | (n > 0) = [s] ++ createrow2 (n-1) (s+k) k

creatematrix2 m n s k | (n <= 0) = []
                      | (n > 0) = [createrow2 m s k] ++ creatematrix2 m (n-1) (s+m*k) k

--Solution
--Except for values 1 1 in creatematrix2, we can give other positive values to create other matrix
mymatrix n | (n > 2) && (rem n 2 == 1) = creatematrix2 n n 1 1
--for odd N, we can give values to K and S and create a matrix
--K is the step and every number is previous number + K
           | (n > 2) && (rem n 2 /= 1) = appendl (creatematrix1 n n 1) [lastrow n]
           | (n <= 2) = []

------------------------Problem 5-------------------------

--Reverse list
reverselist []     = []
reverselist (x:xs) = appendl (reverse xs) [x]

--Check Last Seat
checklast (x:xs) len = if (x == 'e') then (len-1,1) else (-1,0)

lastans xs = checklast (reverselist xs) (lengthl xs)

--Check First Seat
checkfirst (x:xs) m f | (f /= 1) && (x == 'e') = (0,1)
                      | (f /= 1) && (x /= 'e') = (-1,0)
                      | (f == 1) = (m,1)

firstans xs (x,y) = checkfirst xs x y

--Check for seat starting from left to find two empty seats
--in a row and seat in second one if first and last is taken
checkforgood xs m f | (f /= 1) = if ((findgood xs 0) == -1) then (-1,0) else (findgood xs 0,1)
                    | (f == 1) = (m,1)

findgood [_] _ = -1
findgood (x:y:xs) n | (x == 'e') && (y == 'e') = n+1
                    | (x /= 'e') && (y == 'e') = findgood (y:xs) (n+1)
                    | (x == 'e') && (y /= 'e') = findgood (y:xs) (n+1)
                    | (x /= 'e') && (y /= 'e') = findgood (y:xs) (n+1)

checkleft xs (x,y) = checkforgood xs x y

--Check for best seat starting from right and find the first empty seat.
checkbestright xs len m f | (f /= 1) = if (findbestright xs len == -1) then (-1,0) else (findbestright xs len,1)
                          | (f == 1) = (m,1)

findbestright [] _ = -1
findbestright (x:xs) len | (x == 'e') = len-1
                         | (x /= 'e') = findbestright xs (len-1)

checkright xs (x,y) = checkbestright (reverselist xs) (lengthl xs) x y

--Solution
answer (x,y) = x
myseat xs = answer (checkright xs (checkleft xs (firstans xs (lastans xs))) )
