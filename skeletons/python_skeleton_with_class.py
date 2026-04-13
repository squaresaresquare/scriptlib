#!/usr/bin/env python3
import inspect
import logging
import signal
import sys
import functools

class myClass:
    def __init__(self, myVar1):
        self.myVars = myVar1
        self.logger = logging.getLogger(__name__)

  #Some built in functions you can implement
  def __str__(self):
        return f"{self.myVars}"
  def __repr__(self):
        return f'Verbose {self.__name__}'
  def __dir__(self):
        return ['myVars']
    
  #class functions
  def myFunc(self, newVal):
      try:
          # do something
          if len(newVal) > 1:
              self.myVars = newVal
          else:
              raise Exception("Something bad happened")        
        except Exception as e:
            print("error message ",e)
            print("at: ",inspect.stack()[0][3]+"("+newVal+")")

  # for iterable objects
  def __iter__(self):
      if isinstance(myVars, list):
          return self
      else:
          raise TypeError(255,'object is not a list') from error
    
  def __next__(self, MyVars):
      if isinstance(self.myVars, list):
          for elem in self.myVars:
              yield elem
          raise StopIteration
      else:
          raise TypeError(255,'object is not a list') from error
      
def signal_handler(sig, frame):
    print('You pressed Ctrl+C!')
    sys.exit(0)  
  
def main():
    #handle SIGINT (ctrl c)
    signal.signal(signal.SIGINT, signal_handler)
  
    c1 = myClass([1,2,3,5,8,13,21,34])
    c1.myFunc("something new")
    for element in c1:
        print(element)
    print(str(c1))
    print(dir(c1))
    print(repr(c1))

    """"
    " Python Examples "
    """


    #optparse
    """
        import optparse
        parser = optparse.OptionParser()
        parser.add_option('-o', '--output')
        parser.add_option('-v', dest='verbose', action='store_true')
        opts, args = parser.parse_args()
        try:
            process(args, output=opts.output, verbose=opts.verbose)
        except optparse.OptionConflictError as e:
            print("conflicting options are added to an OptionParser.", e)
        except optparse.OptionValueError as e:
            print("invalid option value is encountered on the command line.", e)
        except optparse.BadOptionError as e:
            print("invalid option is passed on the command line.", e)
        except optparse.AmbiguousOptionError as e:
            print(e)
    """
    
      #json example
    """
    import json
    json_string = '{"name":"John"}'
    #load to dictionsy
    try: 
        my_dict = json.loads(json_string)
    except JSONDecodeError as e:
        print(e)
        
    # dump dict to json string
    try:
        my_json = json.dumps(my_dict)
    except TypeError:
        print("Unable to serialize the object")
    except AttributeError:
        print("Invalid key in JSON data.")
    """
    
      #re example
    """
    #numbers divided by letters
    import re
    test="hell0w0rld"
    #return matches in an iterable
    #    re.finditer(pattern, string)
    #memory efficient length of iterable
    #   length = sum(1 for _ in iterable)
    try:
        ret_value = round(sum(1 for _ in re.finditer('[^0-9]',test)) / sum(1 for _ in re.finditer('[0-9]',test) + .0000001))
    except re.error as e:
        print("Error occurred:", e.msg)
        print("Pattern:", e.pattern)
        print("Position:", e.pos)
        print(ret_value)
    """

    
    #urllib example
    """
    # post
    import urllib.request
    import json

    body = {'ids': [12, 14, 50]}
    myurl = "http://www.testmycode.example"

    req = urllib.request.Request(myurl)
    req.add_header('Content-Type', 'application/json; charset=utf-8')
    jsondata = json.dumps(body)
    jsondataasbytes = jsondata.encode('utf-8')   # needs to be bytes
    req.add_header('Content-Length', len(jsondataasbytes))
    try:
        response = urllib.request.urlopen(req, jsondataasbytes).read()
    except urllib.error.URLError as e:
        print(e.reason)
    """"
    
    #get with API token
    """"
    import urllib.request
    import json
    token = "your_token"
    req = urllib.request.Request('http://www.pretend_server.org')
    req.add_header('Content-Type', 'application/json; charset=utf-8')
    req.add_header('Authorization', f"Bearer {token}")
    try: response_json = urllib.request.urlopen(req).read()
        response_dict = json.loads(response_json)
    except urllib.error.URLError as e:
        print(e.reason)
    """
    
    #list comprehension example
    """"
    fruits = ["apple", "banana", "cherry", "kiwi", "mango"]
    newlist = []

    for x in fruits:
      if "a" in x:
        newlist.append(x)

    print(newlist)

    #same as
    fruits = ["apple", "banana", "cherry", "kiwi", "mango"]
    newlist = [x for x in fruits if "a" in x]
    print(newlist)
    """"

    #flatten cartesian sum
    """
     │ 1 │ 2 │ 3 │ 4 │
    ─┼───┼───┼───┼───┤    ┌──┬──┬──┬──┐
    5│1+5│2+5│3+5│4+5│    │ 6│ 7│ 8│ 9│
    ─┼───┼───┼───┼───┤    ├──┼──┼──┼──┤
    6│1+6│2+6│3+6│4+6│    │ 7│ 8│ 9│10│
    ─┼───┼───┼───┼───┤    ├──┼──┼──┼──┤
    7│1+7│2+7│3+7│4+7│    │ 8│ 9│10│11│
    ─┼───┼───┼───┼───┤    ├──┼──┼──┼──┤
    8│1+8│2+8│3+8│4+8│    │ 9│10│11│12│
    ─┴───┴───┴───┴───┘    └──┴──┴──┴──┘
    # example to flatten this loop
    #cartesian sum
    c1 = [1,2,3,4]
    c2 = [5,6,7,8]
    test1 = []
    for i in c1:
        for j in c2:
             test1.append(i+j)

    test2 = [ x + y for x, y in itertools.product(c1, c2) ]
    
    if test1 == test2:
       print("success")
    else:
       print("failed")
    """

    """
rads = [8,10.7,17.1,11.2,13.5,9.9,14.9,9.4,3.1,12.7]
#points where the number >= 5 from previous and next
#return count points
print(rads)
for i in range(1, len(rads[1:]), 1):
    print("test " + str(rads[i]))
    #print(str(rads[i-1]) + " " + str(rads[i]) + " " + str(rads[i-1]))
    print(str(rads[i-1]) + " >= " + str(rads[i]+5) + " and " + str(rads[i+1]) + " >= " + str(rads[i]+5))
    if rads[i-1] >= rads[i]+5 and rads[i+1] >= rads[i]+5:
        print("yes " + str(rads[i]))
    else:
        print("no")
    print("OR: " + str(rads[i-1]) + " <= " + str(rads[i]-5) + " and " + str(rads[i+1]) + " <= " + str(rads[i]-5))
    if rads[i-1] <= rads[i]-5 and rads[i+1] <= rads[i]-5:
        print("yes " + str(rads[i]))
    else:
        print("no")

# list comprehension
result = [b for a,b,c in zip(rads, rads[1:], rads[2:]) if ( a >= b+5 and c >= b+5 ) or ( a <= b-5 and c <= b-5 )]
print(len(result))

    """

#distances
"""
#distances
import math
coords = [[1,2], [5,3], [-1,7], [-1,1]]
distances = list(map(lambda a: math.sqrt((abs(a[0])**2) + abs(a[1]**2)), coords))
index_of_min = distances.index(min(distances))
print(coords[index_of_min])
"""
#robots
"""
from itertools import groupby
from operator import add
import re
lines = ["User-agent: googlebot", "Disallow: /shoes/" , "Disallow: /socks/", "User-agent: *", "Disallow: /admin/", "Disallow: /anomymous/", "Disallow: /misc/", "User-agent: junk", "Disallow: /junk/", "User-agent: DoeBot", "Disallow: /truth/", "Disallow: /justice/", "Disallow: /democracy/"]
groups = [ list(v) for k,v in groupby(lines, lambda x: 'User-agent' in x) ]
subs = [ add( *groups[i:i+2] ) for i in range(0,len(groups),2) ]
mine = sum([ x for x in subs if f'*' in x[0] or f'DoeBot' in x[0] ], [])
user_agents = [x.split(': ')[1] for x in mine if "Disallow" in x]
print(user_agents)
"""

if __name__ == "__main__":
        main()



