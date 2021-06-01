"""
DeepLabCut video analysis
Gia Jordan 2020

Run in Anaconda GPU Environment
C:\Program Files\DeepLabCut-master\conda-environments


"""
#activate dlc-windowsGPU
import cv2
import numpy as np
import deeplabcut as dlc
import os
from PIL import ImageEnhance as ie
from PIL import Image as image

def lightCorr():

    #os.chdir(r'\\DATA-SERVER\ICR_Behavior\BehaviorPilot\0501\2018-01-22_14-36-54')
    #os.chdir(r'G:\DATA\Adam_ICR_Behavior\0741\2020-05-18_13-01-25')
    
    cwd=os.getcwd()
    study='adam'
    
    if study=='adam':
        a=2
        b=12
        config=r'G:\Head Movement Analysis\ICR Behavior-Gia-2020-11-23\config.yaml'
    elif study=='sahana':
        a=1
        b=100
    else:
            print('Invalid Study\n')
        
    Label_video=False
    
    # # left off with a=2 b=200 for adams vids
    # # sahana vids - a=1 b=200
    # #VideoDirectory=(r'G:\DATA\Adam_ICR_Behavior\0741\2020-03-04_12-19-17')
    # VideoDirectory=(r'\\DATA-SERVER\ICR_Behavior\BehaviorPilot')
    # #VideoDirectory=(r'G:\DATA\Sahana_W_Maze')
    
    # for folder, subfolder, videos in os.walk(VideoDirectory,topdown=True):
    #     #print(folder)
    #     #print(subfolder)
    #     print(videos)
        
    
            
        # if len(videos) !=0:
        #     for video in videos:
    videos=os.listdir()
    
    for video in videos:
                    
        # if str(video).endswith('VT2.mpg') | str(video).endswith('01.mpg'):
        if str(video).startswith('VT') & str(video).endswith('.mpg'):
            
            #os.getcwd()
           
            print('Processing video: ' + video)
            OUTvideo='Bright_'+video
            OUTvideo=os.path.join(cwd,OUTvideo)
           
            #video=os.path.join(os.getcwd(),'\\'+video)
            #video=str(video)
            print('Input:',os.path.abspath(video))
            print('Output:',OUTvideo)
            input=cv2.VideoCapture(os.path.abspath(video))
            fps=int(input.get(cv2.CAP_PROP_FPS))
            fwidth=int(input.get(cv2.CAP_PROP_FRAME_WIDTH))
            fheight=int(input.get(cv2.CAP_PROP_FRAME_HEIGHT))
            length=int(input.get(cv2.CAP_PROP_FRAME_COUNT))
            #print(length)
            #print("Frames\n")
            #print(input)
            #print(fwidth)
            count=1
            
            codec=cv2.VideoWriter.fourcc(*'XVID')
            #codec=cv2.VideoWriter.fourcc(*'MPEG')
            #OUTvideo=os.path.join(folder+'\\Vertical'+video)
            #print(os.path.abspath(OUTvideo))
            video_writer=cv2.VideoWriter(OUTvideo,codec,fps,(fwidth,fheight))
            
            capture=cv2.VideoCapture(video)
            
            
            for i in range(length-30):#had length -11 for some reason?
                _, img = capture.read()
                
                newImg=a*img+b
                
                video_writer.write(newImg)
                if i % 1500==0:
                    print(str(i) + " of " + str(length) + " frames\n")
                
                del img
                del newImg
            
            video_writer.release()
            
            # dlc.analyze_videos(config,[OUTvideo],save_as_csv=True)
            # dlc.filterpredictions(config,[OUTvideo],filtertype='arima',p_bound=.01,ARdegree=3,MAdegree=1)
            
            # if Label_video==True:
            #     dlc.create_labeled_video(config,[OUTvideo],trailpoints='5',save_frames=True,filtered=True)
        # else:
        #     continue
    
    
    
    
            
        
        
        
