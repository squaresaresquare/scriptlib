#!/usr/bin/env python3
from google.protobuf.message import Message
from google.protobuf.descriptor import FieldDescriptor
import os

for project in os.listdir(path='/Users/sbobadilla/cos-cis-reports'):
  for cluster in os.listdir(path='/Users/sbobadilla/cos-cis-reports/' + project):
    for node in os.listdir(path='/Users/sbobadilla/cos-cis-reports/' + project + '/' + cluster):
      print(node)
      with open('/Users/sbobadilla/cos-cis-reports/' + project + '/' + cluster + "/" + node, 'r') as reader:
        txt = reader.read()
        pb = Message()
        pb.ParseFromString(txt) 
