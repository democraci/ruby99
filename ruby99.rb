# encoding: UTF-8
#newbie's ruby solution to p99 in https://prof.ti.bfh.ch/hew1/informatik3/prolog/p-99/
#
#author democracyinchina@gmail.com
#

#P01 (*) Find the last element of a list.
#Example:
#?- my_last(X,[a,b,c,d]).
#X = d
def last(list)
	list.last
end

raise "last method error" unless  last([1, 2, 3, 4]) == 4

#P02 (*) Find the last but one element of a list.
#partial or complete needed to be considerated?
def lastButOne(list)
	list[-2]
end

raise "lastButOne method error" unless lastButOne([1,2,3,4]) == 3

#P03 (*) Find the K'th element of a list.
#The first element in the list is number 1.
#Example:
#?- element_at(X,[a,b,c,d,e],3).
#X = c
def kElement(list, k)
	list[k-1]
end

raise "kElement method error" unless kElement([1,2,3,4], 2) == 2

#P04 (*) Find the number of elements of a list.
def myLength(list)
	list.length
  #list.count also works: when Array#count takes no arguments, it works just like Array#length.
  #list.size also works: Array#size is an alias of Array#length.
end

raise "myLength method error" unless myLength([1,2,3,4]) == 4

#P05 (*) Reverse a list.
def myReverse(list)
	#list.reverse
	#list.reverse! also works in a dangerous manner(change itself)
	
	#recursive way
	#if list.length == 0 then
	#	[]
	#else
	#	#puts "enter stack"
	#	myReverse(list.drop(1)).push(list[0])
	#end
	
	#or in an effective and imperative way
	#[1,2,3,4] [4,2,3,1][4,3,2,1]
	#[1,2,3,4,5] [5,2,3,4,1] [5,4,3,2,1]
	i = 0
	while i < list.length/2
		list[i], list[list.length - i - 1] = list[list.length - i - 1], list[i]
		i += 1
	end
	list
end

raise "myReverse method error" unless myReverse([1,2,3,4]) == [4,3,2,1] && myReverse([1,2,3,4,5]) == [5,4,3,2,1]

#P06 (*) Find out whether a list is a palindrome.
#A palindrome can be read forward or backward; e.g. [x,a,m,a,x].
def palindrome? list
	#list == list.reverse
	
	#or in a typical haskell way
	return true if list.nil? || list.length == 1 || list.length == 0
	return true if (list.first == list.last) && palindrome?(list.slice(1, list.length - 2))
end

raise "palindrome? method error" unless palindrome?([1,2,2,1]) && palindrome?([1,2,3,2,1])

#P07 (**) Flatten a nested list structure.
#Transform a list, possibly holding lists as elements into a `flat' list by replacing each list with its elements (recursively).
#Example:
#?- my_flatten([a, [b, [c, d], e]], X).
#X = [a, b, c, d, e]
#Hint: Use the predefined predicates is_list/1 and append/3

def my_flatten list
	#list.flatten cannot meet the requirment, only flatten first level
	if list == nil || list.length == 0
		[]
	else
		if list[0].kind_of?(Array)
			return my_flatten(list[0]).concat(my_flatten(list.drop(1)))
		else
			return my_flatten(list.drop(1)).insert(0, list[0])
		end
  end

  # Array#flatten can take an argument as the level of recursion to flatten.
end

raise "myFlatten method error" unless my_flatten([1,[2,3],[4,[5]]]) == [1,2,3,4,5] 

#P08 (**) Eliminate consecutive duplicates of list elements.
#If a list contains repeated elements they should be replaced with a single copy of the element. The order of the elements should not be changed.
#Example:
#?- compress([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
#X = [a,b,c,a,d,e]

def compress list
	return list if list == nil || list.length == 0 || list.length == 1
	i = 0
	i += 1 while list[i] == list[i+1] && i <= list.length - 1
	compress(list.drop(i + 1)).insert(0, list[i])
end

raise "compress method error" unless compress([1,1,1,2]) == [1,2] && compress([1,1,1,2,2,3,3,4]) == [1,2,3,4]

#P09 (**) Pack consecutive duplicates of list elements into sublists.
#If a list contains repeated elements they should be placed in separate sublists.
#Example:
#?- pack([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
#X = [[a,a,a,a],[b],[c,c],[a,a],[d],[e,e,e,e]]

def pack list
	#imperative way is more straightforward
	return list if list == nil || list.length == 0 || list.length == 1
	rtn = []
	i = 0
	while i <= list.length - 1
		entry = []
		entry.push(list[i])
		#p "add element to entry list"
		#p list[i]
		while list[i] == list[i+1] && i < list.length - 1
			i += 1
			entry.push(list[i]) 	
			#p list[i]
		end
		#p "end of add"
		rtn.push(entry)
		i += 1
	end
	rtn
end

raise "pack method error" unless pack([1,1,2,2,3,3]) == [[1,1],[2,2],[3,3]]


#P10 (*) Run-length encoding of a list.
#Use the result of problem P09 to implement the so-called run-length encoding data compression method. Consecutive duplicates of elements are encoded as terms [N,E] where N is the number of duplicates of the element E.
#Example:
#?- encode([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
#X = [[4,a],[1,b],[2,c],[2,a],[1,d][4,e]]

def length_encode list
	return list if list == nil || list.length == 0
		
	rtn = []
	i = 0
	while i <= list.length - 1
		entry = []
		run_length = 1
		while list[i] == list[i+1] && i < list.length - 1
			i += 1
			run_length += 1
		end
		entry.push(run_length)
		entry.push(list[i])
		rtn.push(entry)
		i += 1
	end
	rtn
end

raise "length_encode method error" unless length_encode([1,1,2,2,3]) == [[2,1],[2,2],[1,3]]


#P11 (*) Modified run-length encoding.
#Modify the result of problem P10 in such a way that if an element has no duplicates it is simply copied into the result list. Only elements with duplicates are transferred as [N,E] terms.
#Example:
#?- encode_modified([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
#X = [[4,a],b,[2,c],[2,a],d,[4,e]]

def modify_length_encode list
	return list if list == nil || list.length == 0
		
	rtn = []
	i = 0 # how to eliminate while loop
	while i <= list.length - 1
		entry = []
		run_length = 1
		while list[i] == list[i+1] && i < list.length - 1
			i += 1
			run_length += 1
		end
		if run_length == 1
			rtn.push(list[i])
		else	
			entry.push(run_length)
			entry.push(list[i])
			rtn.push(entry)
		end
		i += 1
	end
	rtn
end

raise "modify_length_encode method error" unless modify_length_encode([1,1,2,2,3,3,3,4,5]) == [[2,1],[2,2],[3,3],4,5]

#P12 (**) Decode a run-length encoded list.
#Given a run-length code list generated as specified in problem P11. Construct its uncompressed version.

def decode_length_encode list
	return list if list == nil || list.length == 0
	rtn = []
	list.each do |element|
		if element.kind_of? Array
		 raise "parameter error" unless element.length == 2
		 element[0].times { rtn.push(element[1]) }
		else
			rtn.push(element)
		end
	end
	
	rtn
end

raise "decode_length_encode method error" unless decode_length_encode([[2,1],[2,2],[3,3],4,5]) == [1,1,2,2,3,3,3,4,5]


#P13 (**) Run-length encoding of a list (direct solution).
#Implement the so-called run-length encoding data compression method directly. I.e. don't explicitly create the sublists containing the duplicates, as in problem P09, but only count them. As in problem P11, simplify the result list by replacing the singleton terms [1,X] by X.
#Example:
#?- encode_direct([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
#X = [[4,a],b,[2,c],[2,a],d,[4,e]]


#P14 (*) Duplicate the elements of a list.
#Example:
#?- dupli([a,b,c,c,d],X).
#X = [a,a,b,b,c,c,c,c,d,d]

def dupli list
	return list if list == nil || list.length == 0
	rtn = []
	list.each {|n| rtn.push(n).push(n)}
	rtn
end

raise "duplicate method error" unless dupli([1,2]) == [1,1,2,2]

#P15 (**) Duplicate the elements of a list a given number of times.
#Example:
#?- dupli([a,b,c],3,X).
#X = [a,a,a,b,b,b,c,c,c]

def duplicate list,time
	return list if list == nil || list.length == 0
	rtn = []
	list.each{|n| time.times{ rtn.push(n) } }
	rtn
end

raise "duplicate(list, time) method error" unless  duplicate([1,2],3) == [1,1,1,2,2,2]

#P16 (**) Drop every N'th element from a list.
#Example:
#?- drop([a,b,c,d,e,f,g,h,i,k],3,X).
#X = [a,b,d,e,g,h,k]

def delete_nth_element list,n
	return list if list == nil || n > list.length
	cursor = 1
	index = n - 1
	while index <= list.length - 1
		list.delete_at(index)
		index = index + n - cursor
	end
	list
end

raise "delete_nth_element method error" unless delete_nth_element([1,2,3,4,5,6,7,8,9,10],3) == [1,2,4,5,7,8,10]

#P17 (*) Split a list into two parts; the length of the first part is given.
#Do not use any predefined predicates.
#Example:
#?- split([a,b,c,d,e,f,g,h,i,k],3,L1,L2).
#L1 = [a,b,c]
#L2 = [d,e,f,g,h,i,k]

def split list, n
return list if list == nil || n > list.length
	rtn = []
	rtn.push(list.take n)
	rtn.push(list.drop(n))
end

p split([1,2,3,4], 2)

#P31 (**) Determine whether a given integer number is prime.
#Example:
#?- is_prime(7).
#Yes

def is_prime num
  #1 and negative number is not prime number
	return false if num < 2
	return true if num == 2 || num == 3
	return false if num % 2 == 0
  #穷举法，对3和根号num的之内的数，都不能除尽，则是质数
	divider = 3
	while divider <= Math.sqrt(num)
		return false if (num % divider) == 0
		divider += 2
	end
	return true
end

raise "is_prime method error" unless is_prime(2999)

#P32 (**) Determine the greatest common divisor of two positive integer numbers.
#Use Euclid's algorithm.
#Example:
#?- gcd(36, 63, G).
#G = 9
#Define gcd as an arithmetic function; so you can use it like this:
#?- G is gcd(36,63).
#G = 9

def gcd a, b
	#recursive way
	#return a if a == b
	#a, b = b, a if a < b # make sure a > b
	#return b if (a % b) == 0
	#return gcd(b, a % b)
	
	#alternative way to recursive
	#8,4 4,2 2
	#5,3 3,2 2,1 1
	#2999,3 3,2 2,1 1
	a, b = b, a if a < b # make sure a > b
	until (a % b) == 0 
		a, b = b, (a % b)
	end
	b
end

raise "gcd method error" unless gcd(3, 2999) == 1

#P33 (*) Determine whether two positive integer numbers are coprime.
#Two numbers are coprime if their greatest common divisor equals 1.
#Example:
#?- coprime(35, 64).
#Yes
def is_coprime a,b
	return true if gcd(a, b) == 1
	return false
end

raise "is_comprime method error" unless is_coprime 3, 2999

#P34 (**) Calculate Euler's totient function phi(m).
#Euler's so-called totient function phi(m) is defined as the number of positive integers r (1 <= r < m) that are coprime to m.
#Example: m = 10: r = 1,3,7,9; thus phi(m) = 4. Note the special case: phi(1) = 1.
#?- Phi is totient_phi(10).
#Phi = 4
#Find out what the value of phi(m) is if m is a prime number. 
#Euler's totient function plays an important role in one of the most widely used public key cryptography methods (RSA). 
#In this exercise you should use the most primitive method to calculate this function 
#(there are smarter ways that we shall discuss later).

def phi m
	rtn = []
	rtn.push(1)
	return rtn if m == 1 || m == 2
	(2 .. m).each {|n| rtn.push(n) if is_comprime(m, n)}
	rtn.length
end

raise "phi method error" unless phi(10) == 4

#P35 (**) Determine the prime factors of a given positive integer.
#Construct a flat list containing the prime factors in ascending order.
#Example:
#?- prime_factors(315, L).
#L = [3,3,5,7]

def prime_factors n
#recursive way
#	return [1] if n == 1
#	return [2] if n == 2
#	
#	rtn = []
#	a1 = 2
#	while a1 <= n
#		break if (n%a1) == 0
#		a1 += 1
#	end
#	p a1
#	return rtn.push(a1) if a1 == n
#	return rtn.push(a1).concat(prime_factors(n/a1))
	
	#a no-recursive way
	return [1] if n == 1
	return [2] if n == 2
	rtn = []
	a1 = 2
	while a1 <= n
		if (n%a1) == 0
			rtn.push(a1)
			n = n/a1
			a1 = 2
		else
			a1 += 1
		end
	end
	rtn
end

#p prime_factors(6691184563)
#p is_prime 2684923
#p is_prime 2905421

raise "prime_factors method error" unless prime_factors(6000) == [2,2,2,2,3,5,5,5]

#P36 (**) Determine the prime factors of a given positive integer (2).
#Construct a list containing the prime factors and their multiplicity.
#Example:
#?- prime_factors_mult(315, L).
#L = [[3,2],[5,1],[7,1]]
#Hint: The problem is similar to problem P13.

def prime_factors_mult n
	rtn = prime_factors(n)
	return length_encode(rtn)
end

#P37 (**) Calculate Euler's totient function phi(m) (improved).
#See problem P34 for the definition of Euler's totient function. If the list of the prime factors of a number m is known in the form of problem P36 then the function phi(m) can be efficiently calculated as follows: Let [[p1,m1],[p2,m2],[p3,m3],...] be the list of prime factors (and their multiplicities) of a given number m. Then phi(m) can be calculated with the following formula:
#phi(m) = (p1 - 1) * p1**(m1 - 1) * (p2 - 1) * p2**(m2 - 1) * (p3 - 1) * p3**(m3 - 1) * ...
#Note that a**b stands for the b'th power of a.

def phi_improved n
	return 1 if n == 1
	result = prime_factors_mult n
	rtn = 1
	result.each{|list| rtn = rtn * (list[1]-1) * (list[1] **(list[0]-1))}
	rtn
end

raise "phi_improved method error" unless phi_improved(315) == 144

#P38 (*) Compare the two methods of calculating Euler's totient function.
#Use the solutions of problems P34 and P37 to compare the algorithms. Take the number of logical inferences as a measure for efficiency. Try to calculate phi(10090) as an example.

def prime_list min, max
 	rtn = []
 	return rtn if min > max
	return rtn.push(min) if min == max && is_prime(min)
	(min..max).each {|n| rtn.push(n) if is_prime(n)}
	rtn
end

raise "prime_list method error" unless prime_list(1,10) == [2,3,5,7]

#P40 (**) Goldbach's conjecture.
#Goldbach's conjecture says that every positive even number greater than 2 is the sum of two prime numbers. Example: 28 = 5 + 23. It is one of the most famous facts in number theory that has not been proved to be correct in the general case. It has been numerically confirmed up to very large numbers (much larger than we can go with our Prolog system). Write a predicate to find the two prime numbers that sum up to a given even integer.
#Example:
#?- goldbach(28, L).
#L = [5,23]
def goldbach n
	rtn = []
	return [] if n < 3
	k = 2
	while k <= n
		if is_prime(k) && is_prime(n-k)
			rtn.push(k).push(n-k)
			break
		end
		k += 1
	end
	rtn
end

raise "goldbach method error" unless goldbach(30) == [7,23]

#P41 (**) A list of Goldbach compositions.
#Given a range of integers by its lower and upper limit, print a list of all even numbers and their Goldbach composition.
#Example:
#?- goldbach_list(9,20).
#10 = 3 + 7
#12 = 5 + 7
#14 = 3 + 11
#16 = 3 + 13
#18 = 5 + 13
#20 = 3 + 17
#In most cases, if an even number is written as the sum of two prime numbers, one of them is very small. Very rarely, the primes are both bigger than say 50. Try to find out how many such cases there are in the range 2..3000.
#Example (for a print limit of 50):
#?- goldbach_list(1,2000,50).
#992 = 73 + 919
#1382 = 61 + 1321
#1856 = 67 + 1789
#1928 = 61 + 1867

def goldbach_list a,b
	return if a > b
	(a..b).each do |k|
		result = goldbach k
		p "#{k} = #{result[0]} + #{result[1]}"
	end
end

goldbach_list 4, 10

#P46 (**) Truth tables for logical expressions.
#Define predicates and/2, or/2, nand/2, nor/2, xor/2, impl/2 and equ/2 (for logical equivalence) which succeed or fail according to the result of their respective operations; e.g. and(A,B) will succeed, if and only if both A and B succeed. Note that A and B can be Prolog goals (not only the constants true and fail).
#A logical expression in two variables can then be written in prefix notation, as in the following example: and(or(A,B),nand(A,B)).
#Now, write a predicate table/3 which prints the truth table of a given logical expression in two variables.
#Example:
#?- table(A,B,and(A,or(A,B))).
#true true true
#true fail true
#fail true fail
#fail fail fail

#P47 (*) Truth tables for logical expressions (2).
#Continue problem P46 by defining and/2, or/2, etc as being operators. This allows to write the logical expression in the more natural way, as in the example: A and (A or not B). Define operator precedence as usual; i.e. as in Java.
#Example:
#?- table(A,B, A and (A or not B)).
#true true true
#true fail true
#fail true fail
#fail fail fail
#
#P48 (**) Truth tables for logical expressions (3).
#Generalize problem P47 in such a way that the logical expression may contain any number of logical variables. Define table/2 in a way that table(List,Expr) prints the truth table for the expression Expr, which contains the logical variables enumerated in List.
#Example:
#?- table([A,B,C], A and (B or C) equ A and B or A and C).
#true true true true
#true true fail true
#true fail true true
#true fail fail true
#fail true true true
#fail true fail true
#fail fail true true
#fail fail fail true
#
#P49 (**) Gray code.
#An n-bit Gray code is a sequence of n-bit strings constructed according to certain rules. For example,
#n = 1: C(1) = ['0','1'].
#n = 2: C(2) = ['00','01','11','10'].
#n = 3: C(3) = ['000','001','011','010','110','111','101','100']
#

def gray n
	#recursive implement is slow!
	rtn = []
	return rtn if n < 1
	return ["0", "1"] if n == 1
	pre = gray n-1
	pre.each {|entry| rtn.push(entry + "0").push(entry + "1")}
	rtn
end

raise "gray method error" unless gray(3) == ["000", "001", "010", "011", "100", "101", "110", "111"]

#First of all, consult a good book on discrete mathematics or algorithms for a detailed description of Huffman codes!
#
#We suppose a set of symbols with their frequencies, given as a list of fr(S,F) terms. Example: [fr(a,45),fr(b,13),fr(c,12),fr(d,16),fr(e,9),fr(f,5)]. Our objective is to construct a list hc(S,C) terms, where C is the Huffman code word for the symbol S. In our example, the result could be Hs = [hc(a,'0'), hc(b,'101'), hc(c,'100'), hc(d,'111'), hc(e,'1101'), hc(f,'1100')] [hc(a,'01'),...etc.]. The task shall be performed by the predicate huffman/2 defined as follows: 
#
#% huffman(Fs,Hs) :- Hs is the Huffman code table for the frequency table Fs



class Node
	def initialize left, right, frequency, content
		@left = left
		@right = right
		@frequency = frequency
		@content = content
	end
	attr_accessor :left, :right
	attr_reader :frequency, :content
end


def build_huffman_tree tree
	return tree if tree.length == 1
	#find the two node whose frequency is the minimize
	if tree[0].frequency > tree[1].frequency
		min = tree[1]
		minIndex = 1
		hypomin = tree[0]
		hypominIndex = 0
	else
		min = tree[0]
		minIndex = 0
		hypomin = tree[1]
		hypominIndex = 1
	end
	
	i = 2
	while i <= tree.length - 1
		if tree[i].frequency < min.frequency
			hypomin = min
			min = tree[i]
			hypominIndex = minIndex
			minIndex = i		
			i += 1
			next
		end
		if tree[i].frequency < hypomin.frequency
			hypomin = tree[i]
			hypominIndex = i
		end		
		i += 1
	end
	
	root = Node.new(min, hypomin, min.frequency + hypomin.frequency, nil)
	tree[minIndex] = root
	tree.delete_at(hypominIndex)
#	p "#{root.frequency} = #{min.frequency} + #{hypomin.frequency}"
#	p "minIndex #{minIndex} hypominIndex #{hypominIndex}"
#	tree.each {|k| print "#{k.frequency} "}
#	puts "\n"
	return build_huffman_tree tree
end

def huffman_code tree, code
	rtn = []
	left = []
	right = []
	entry = []
	if tree.left == nil && tree.right == nil
		entry.push(tree.content, code)
		return rtn.push(entry)
	end
	
	left = huffman_code(tree.left, code + "0") if tree.left != nil
	right = huffman_code(tree.right, code +"1") if tree.right != nil
	
	return left + right
	
end

def huffman list
	return [] if list == nil || list.length == 0
	#a,45
	rtn = []
	entry = []
	return rtn.push(entry.push(list[0][0]).push("0")) if list.length == 1 
	
	#build huffman tree
	tree = []
	list.each{ |ele| tree.push(Node.new(nil,nil,ele[1], ele[0])) }
	return huffman_code(build_huffman_tree(tree)[0], "")
	
	
	#get huffmancode from huffman tree, infix traverse
  
end

raise "huffman method error" unless huffman([['a',5], ['b',9], ['c',16], ['d',12],
 ['e',13], ['f',45]]) == [["f", "0"], ["d", "100"], ["e", "101"], ["a", "1100"], ["b", "1101"], ["c", "111"]]


#P54 (*) Check whether a given term represents a binary tree
#Write a predicate istree/1 which succeeds if and only if its argument is a Prolog term representing a binary tree.
#Example:
#?- istree(t(a,t(b,nil,nil),nil)).
#Yes
#?- istree(t(a,t(b,nil,nil))).
#No

class Tree
	def initialize left, data, right
		@left = left
		@data = data
		@right = right
	end
	
	attr_accessor :left, :data, :right
end

#P55 (**) Construct completely balanced binary trees
#In a completely balanced binary tree, the following property holds for every node: The number of nodes in its left subtree and the number of nodes in its right subtree are almost equal, which means their difference is not greater than one.
#Write a predicate cbal_tree/2 to construct completely balanced binary trees for a given number of nodes. The predicate should generate all solutions via backtracking. Put the letter 'x' as information into all nodes of the tree.
#Example:
#?- cbal_tree(4,T).
#T = t(x, t(x, nil, nil), t(x, nil, t(x, nil, nil))) ;
#T = t(x, t(x, nil, nil), t(x, t(x, nil, nil), nil)) ;
#etc......No

def cbal_tree tree, number
	
end
 




