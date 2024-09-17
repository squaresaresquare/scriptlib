#!/usr/bin/env python3
import inspect

class myClass:
  def __init__(self, myVar1):
    self.myVars = myVar1
                   
  def __str__(self):
    return f"{self.myVars}"
    
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
def main():
    c1 = myClass("something")
    c1.myFunc("something new")

    print(str(c1))

if __name__ == "__main__":
        main()



