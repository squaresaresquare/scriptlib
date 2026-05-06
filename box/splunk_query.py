#!/usr/bin/env python3
"""
Module documentation.
WIP
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
  USERNAME = os.environ['USER']
  PASSWORD = sys.argv[1]

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
