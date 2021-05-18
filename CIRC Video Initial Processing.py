"""
DeepLabCut video analysis
Gia Jordan 2020

Run in Anaconda GPU Environment
C:\Program Files\DeepLabCut-master\conda-environments


"""
#activate dlc-windowsGPU
import cv2
import numpy as np
#import deeplabcut as dlc
import os
from PIL import ImageEnhance as ie
from PIL import Image as image


study='adam'

if study=='adam':
    a=2
    b=12
elif study=='sahana':
    a=1
    b=100
else:
        print('Invalid Study\n')
    


# left off with a=2 b=200 for adams vids
# sahana vids - a=1 b=200
VideoDirectory=(r'G:\DATA\Adam_ICR_Behavior\0741\2020-03-04_12-19-17')
#VideoDirectory=(r'G:\DATA\Sahana_W_Maze')

for folder, subfolder, videos in os.walk(VideoDirectory):
    print(folder)
    print(subfolder)
    print(videos)
    if len(videos) !=0:
        for video in videos:
            
            if str(video).endswith('VT2.mpg'):
                #OUTvideo=os.path.join(folder+'\\Vertical'+video)
                OUTvideo=os.path.join(folder+'\\Bright_'+video)
               
                video=os.path.join(folder+'\\'+video)
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
                
                #codec=cv2.VideoWriter.fourcc(*'XVID')
                codec=cv2.VideoWriter.fourcc(*'MPEG')
                #OUTvideo=os.path.join(folder+'\\Vertical'+video)
                #print(os.path.abspath(OUTvideo))
                video_writer=cv2.VideoWriter(OUTvideo,codec,fps,(fwidth,fheight))
                
                capture=cv2.VideoCapture(video)
                
                
                for i in range(length-11):#had length -11 for some reason?
                    _, img = capture.read()
                    
                    newImg=a*img+b
                    
                    video_writer.write(newImg)
                    if i % 5000==0:
                        print(str(i) + " of " + str(length) + " frames\n")
                    
                    del img
                    del newImg
                
                video_writer.release()
        else:
            continue


#
#dlc.analyze_videos(config,[INvideo],save_as_csv=True)
#dlc.filterpredictions(config,[INvideo],filtertype='arima',p_bound=.01,ARdegree=3,MAdegree=1)
#
#if Label_video==True:
#    dlc.create_labeled_video(config,[INvideo],trailpoints='5',save_frames=True,filtered=True)
#    
#    
#    
