#!/usr/bin/env python3
"""
Module documentation.
"""
import sys, os
import splunklib.client as client

# Global variables

# Class declarations

# Function declarations

def main():
  #authentication

  HOST = "box-prod.splunkcloud.com"
  PORT = 8089
  USERNAME = "sbobadilla"
  PASSWORD = "Its 4 dangerous business Frodo going out your door. You step onto the road and if you dont keep your feet theres no knowing where you might be swept off to."

  # Create a Service instance and log in 
  service = client.connect(
    host=HOST,
    port=PORT,
    username=USERNAME,
    password=PASSWORD)
  # Print installed apps to the console to verify login
  for app in service.apps:
    print(app.name)


#query



# Main body
if __name__ == '__main__':
    main()
