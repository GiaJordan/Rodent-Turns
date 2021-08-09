# -*- coding: utf-8 -*-
"""
Created on Mon Aug  2 14:22:58 2021

@author: Sam.Jordan
"""

import os
import deeplabcut as dlc
from shutil import copy as cpy

config=r'G:\Head Movement Analysis\ICR Behavior-Gia-2020-11-23\config.yaml'

videos=[
r'\\data-server\icr_behavior\BehaviorPilot\0203\2016-11-10_14-48-53\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0203\2016-12-20_09-18-59\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0203\2016-12-21_09-18-05\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0203\2017-11-03_16-18-42\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0203\2017-11-06_15-54-29\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0204\2016-11-10_20-26-50\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0204\2016-12-18_16-03-46\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0204\2016-12-19_09-43-14\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0204\2016-12-20_10-29-08\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0204\2017-11-03_16-51-53\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0204\2017-11-06_16-43-36\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0204\2017-11-09_16-40-50\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0244\2016-11-10_18-31-18\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0244\2016-12-18_14-14-39\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0244\2016-12-19_10-51-50\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0244\2016-12-21_10-16-46\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0245\2016-11-10_17-27-56\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0245\2016-12-18_14-37-51\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0245\2016-12-19_12-09-23\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0245\2016-12-21_10-59-20\Bright_VT1.mpg',
r'\\data-server\icr_behavior\BehaviorPilot\0247\2016-11-10_16-18-27\Bright_VT1.mpg']



for video in videos:
    
    if not os.path.isdir(video.replace('icr_behavior','icr-behavior-2')[:-35]):
        os.mkdir(video.replace('icr_behavior','icr-behavior-2')[:-35])
    if not os.path.isdir(video.replace('icr_behavior','icr-behavior-2')[:-15]):    
        os.mkdir(video.replace('icr_behavior','icr-behavior-2')[:-15])
        oldDir=video[:-15]
        
        print("Copying: " + oldDir +" \nto: " + video.replace('icr_behavior','icr-behavior-2')[:-15])
        
                   
        cpy(video,video.replace('icr_behavior','icr-behavior-2'))
        cpy( oldDir+'\\Bright_VT1DLC_resnet152_ICR BehaviorNov23shuffle1_700000.csv', oldDir.replace('icr_behavior','icr-behavior-2')+'\\Bright_VT1DLC_resnet152_ICR BehaviorNov23shuffle1_700000.csv')
        cpy( oldDir+'\\Bright_VT1DLC_resnet152_ICR BehaviorNov23shuffle1_700000_filtered.csv', oldDir.replace('icr_behavior','icr-behavior-2')+'\\Bright_VT1DLC_resnet152_ICR BehaviorNov23shuffle1_700000_filtered.csv')
        cpy( oldDir+'\\Bright_VT1DLC_resnet152_ICR BehaviorNov23shuffle1_700000.h5', oldDir.replace('icr_behavior','icr-behavior-2')+'\\Bright_VT1DLC_resnet152_ICR BehaviorNov23shuffle1_700000.h5')
        cpy( oldDir+'\\Bright_VT1DLC_resnet152_ICR BehaviorNov23shuffle1_700000_filtered.h5', oldDir.replace('icr_behavior','icr-behavior-2')+'\\Bright_VT1DLC_resnet152_ICR BehaviorNov23shuffle1_700000_filtered.h5')
        cpy( oldDir+'\\Bright_VT1DLC_resnet152_ICR BehaviorNov23shuffle1_700000_meta.pickle', oldDir.replace('icr_behavior','icr-behavior-2')+'\\Bright_VT1DLC_resnet152_ICR BehaviorNov23shuffle1_700000_meta.pickle')

            
        
for i,video in enumerate(videos): 
    
    videos[i]= video.replace('icr_behavior','icr-behavior-2')
    
    
dlc.create_labeled_video(config,videos,save_frames=False,filtered=True,draw_skeleton=True)
    
    
# print("Analyzing: " + video.replace('icr_behavior','icr-behavior-2')[:-15])
# dlc.create_labeled_video(config,[video.replace('icr_behavior','icr-behavior-2')],save_frames=False,filtered=True,draw_skeleton=True)
