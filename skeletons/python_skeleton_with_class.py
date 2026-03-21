#!/usr/bin/env python3
import inspect
import logging
import signal
import sys

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
  
    c1 = myClass("something")
    c1.myFunc("something new")
    for element in c1:
        print(element)
    print(str(c1))
    print(dir(c1))
    print(repr(c1))
    print(
          

if __name__ == "__main__":
        main()



