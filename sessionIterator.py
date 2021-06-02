# -*- coding: utf-8 -*-
"""
Created on Tue Jun  1 10:13:38 2021

@author: Gia.Jordan
"""
import os
from processVideo import lightCorr

os.chdir(r'\\DATA-SERVER\ICR_Behavior\BehaviorPilot')

dataFolder=os.getcwd()

rats=os.listdir()

for rat in rats:
    print(os.path.join(dataFolder,rat))
    
    os.chdir(os.path.join(dataFolder,rat))
    sessions=os.listdir()
    #print(sessions)
    for session in sessions:
        #print(session)
        
        if os.path.isdir(os.path.join(dataFolder,rat,session)):
            os.chdir(os.path.join(dataFolder,rat,session))
            
            print(os.getcwd(),'\n')
            lightCorr()
       
            
        
        
        
       


















