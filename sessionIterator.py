# -*- coding: utf-8 -*-
"""
Created on Tue Jun  1 10:13:38 2021

@author: Gia.Jordan
to be ran in the data server ICR folder to iterate thorugh all rats/sessions
"""
import os
from processVideo import lightCorr

#move to ICR directory
os.chdir(r'\\DATA-SERVER\ICR_Behavior\BehaviorPilot')

#save directory name
dataFolder=os.getcwd()
#get list of rats in directory
rats=os.listdir()

#iterate through rats
for rat in rats:
    #display rat to be analyzed
    print(os.path.join(dataFolder,rat))
    
    #move to rat's directory
    os.chdir(os.path.join(dataFolder,rat))
    #load sessions for that rat
    sessions=os.listdir()
    
    #iterate thorugh sesions and files
    for session in sessions:
        
        """
        Stopped at rat 0140 session ending with 9-34-16
        """
        
        
        #if the 'file' is a valid ICR session, move to directory and process/analyze video
        if os.path.isdir(os.path.join(dataFolder,rat,session)):
            os.chdir(os.path.join(dataFolder,rat,session))
            
            print(os.getcwd(),'\n')
            lightCorr()
       
            
        
        
        
       


















