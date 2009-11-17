#!/usr/bin/python

import sys
import time
import threading
import string

from subprocess import Popen,PIPE

proc = Popen('gdb', shell=True, stdin=PIPE,)

def print_help():
  print "usage : loadmod module IP"

def loadmod(arg):
  if len(arg) < 2 :
     print_help()
  else :
      try:
        print arg[1] + "\n"
        module = Popen(["/tmp/loadmod.sh", arg[1]] ,)
     
        module.wait()
      except :
        print "could not execute /tmp/loadmod.sh"

while 1:
    try:
      keyboardInput = sys.stdin.readline()
      command = keyboardInput.split()
      try:
         if command[0] == "loadmod":
            print "sendload"
            loadmod(command)
            print "\r(gdb) ", 
         else :
             print "sendgdb"
             proc.stdin.write(keyboardInput)
      except:
        print "except" 
        proc.stdin.write(keyboardInput)
    except:
     sys.exit()
     
