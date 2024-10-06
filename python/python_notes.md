## open and read a file
```
file1 = open("MyFile.txt", "r") 
line_3 = file1.readline([2])
whole_file = file1.readlines()
file1.close() 
```
or
```
with open("myfile.txt", "r") as file1:
    line_3 = file1.readline([2])
    whole_file = file1.readlines()
```

## regular expressions
```
import re
#The search() function returns a Match object:
txt = "The rain in Spain"
x = re.search("ai", txt)
#The findall() returns a list of matches
y = re.findall("ai", txt)
print(x)
print(y)
#------------
<re.Match object; span=(5, 7), match='ai'>
['ai', 'ai']
```
## REST request 
```
import requests
import json
api_url = "https://..."
headers =  {"Content-Type":"application/json",'Authorization': 'access_token myToken'}
response = requests.get(api_url, headers=headers)
data_dict = json.loads(response)
# to post
response = requests.post(api_url, data=json.dumps(data_dict), headers=headers)

```
## python set intersection with tradeoff examples

```

# initializing lists

test_list1 = [ [1, 2], [3, 4], [5, 6] ]

test_list2 = [ [3, 4], [5, 7], [1, 2] ]

```

### nested loop (most maintainable)

time O(n^2)

memory O(n)

```

res_list = []

for i in test_list1:

    if i in test_list2:

        res_list.append(i)

```

### list comprehension

time O(n^2)

memory O(n)

```

res_list = [i for i in test_list1 if i in test_list2]

```

### map reduce (highest performance)

time O(n)

memory O(n)

```

res_set = set(map(tuple, test_list1)) & set(map(tuple, test_list2))

res_list = list(map(list, res_set))

```

### filter and lambda (lowest memory usage)

time O(n^2)

memory O(k) where k is the size of the intersection

```

set1 = set(map(tuple, test_list1))

set2 = set(map(tuple, test_list2))

intersection_list = list(filter(lambda x: tuple(x) in set2, test_list1))

```



## String functions

capitalize()	Converts the first character to upper case



casefold()	Converts string into lower case



center()	Returns a centered string



count()	Returns the number of times a specified value occurs in a string

encode()	Returns an encoded version of the string

endswith()	Returns true if the string ends with the specified value

expandtabs()	Sets the tab size of the string

find()	Searches the string for a specified value and returns the position of where it was found

format()	Formats specified values in a string

format_map()	Formats specified values in a string

index()	Searches the string for a specified value and returns the position of where it was found

isalnum()	Returns True if all characters in the string are alphanumeric

isalpha()	Returns True if all characters in the string are in the alphabet

isascii()	Returns True if all characters in the string are ascii characters

isdecimal()	Returns True if all characters in the string are decimals

isdigit()	Returns True if all characters in the string are digits

isidentifier()	Returns True if the string is an identifier

islower()	Returns True if all characters in the string are lower case

isnumeric()	Returns True if all characters in the string are numeric

isprintable()	Returns True if all characters in the string are printable

isspace()	Returns True if all characters in the string are whitespaces

istitle()	Returns True if the string follows the rules of a title

isupper()	Returns True if all characters in the string are upper case

join()	Converts the elements of an iterable into a string

ljust()	Returns a left justified version of the string

lower()	Converts a string into lower case

lstrip()	Returns a left trim version of the string

maketrans()	Returns a translation table to be used in translations

partition()	Returns a tuple where the string is parted into three parts

replace()	Returns a string where a specified value is replaced with a specified value

rfind()	Searches the string for a specified value and returns the last position of where it was found

rindex()	Searches the string for a specified value and returns the last position of where it was found

rjust()	Returns a right justified version of the string

rpartition()	Returns a tuple where the string is parted into three parts

rsplit()	Splits the string at the specified separator, and returns a list

rstrip()	Returns a right trim version of the string

split()	Splits the string at the specified separator, and returns a list

splitlines()	Splits the string at line breaks and returns a list

startswith()	Returns true if the string starts with the specified value

strip()	Returns a trimmed version of the string

swapcase()	Swaps cases, lower case becomes upper case and vice versa

title()	Converts the first character of each word to upper case

translate()	Returns a translated string

upper()	Converts a string into upper case

zfill()	Fills the string with a specified number of 0 values at the beginning





## list methods

append()	Adds an element at the end of the list

clear()	Removes all the elements from the list

copy()	Returns a copy of the list

count()	Returns the number of elements with the specified value

extend()	Add the elements of a list (or any iterable), to the end of the current list

index()	Returns the index of the first element with the specified value

insert()	Adds an element at the specified position

pop()	Removes the element at the specified position

remove()	Removes the first item with the specified value

reverse()	Reverses the order of the list

sort()	Sorts the list



## Dictionary methods

clear()	Removes all the elements from the dictionary

copy()	Returns a copy of the dictionary

fromkeys()	Returns a dictionary with the specified keys and value

get()	Returns the value of the specified key

items()	Returns a list containing a tuple for each key value pair

keys()	Returns a list containing the dictionary's keys

pop()	Removes the element with the specified key

popitem()	Removes the last inserted key-value pair

setdefault()	Returns the value of the specified key. If the key does not exist: insert the key, with the specified value

update()	Updates the dictionary with the specified key-value pairs

values()	Returns a list of all the values in the dictionary



## Set methods

add()	 	Adds an element to the set

clear()	 	Removes all the elements from the set

copy()	 	Returns a copy of the set

difference()	-	Returns a set containing the difference between two or more sets

difference_update()	-=	Removes the items in this set that are also included in another, specified set

discard()	 	Remove the specified item

intersection()	&	Returns a set, that is the intersection of two other sets

intersection_update()	&=	Removes the items in this set that are not present in other, specified set(s)

isdisjoint()	 	Returns whether two sets have a intersection or not

issubset()	<=	Returns whether another set contains this set or not

 	<	Returns whether all items in this set is present in other, specified set(s)

issuperset()	>=	Returns whether this set contains another set or not

 	>	Returns whether all items in other, specified set(s) is present in this set

pop()	 	Removes an element from the set

remove()	 	Removes the specified element

symmetric_difference()	^	Returns a set with the symmetric differences of two sets

symmetric_difference_update()	^=	Inserts the symmetric differences from this set and another

union()	|	Return a set containing the union of sets

update()	|=	Update the set with the union of this set and others

## multithreading
```
import threading
def print_square(num):
    print("Square: {}" .format(num * num))

t1 = threading.Thread(target=print_square, args=(10,))

t1.start()

t1.join()
```
or start a bunch
```
import threading
def print_square(num):
    print("Square: {}" .format(num * num))
    
for num in range(5, 11):
    t[num] = threading.Thread(target=print_square, args=(num,))
    t[num].start()

#wait for them to finish    
for num in range(5, 11):
    t[num].join()




