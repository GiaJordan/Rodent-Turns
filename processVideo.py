"""
DeepLabCut video analysis
Gia Jordan 2020

Run in Anaconda GPU Environment
C:\Program Files\DeepLabCut-master\conda-environments
"""


           
def lightCorr():
    import cv2
    import numpy as np
    import deeplabcut as dlc
    import os
    from PIL import ImageEnhance as ie
    from PIL import Image as image
    
    #os.chdir(r'\\DATA-SERVER\ICR_Behavior\BehaviorPilot\0708\2019-07-16_14-14-18')
    
    #inputs#######################
    
    #bool, create a video with DLC labels
    Label_video=False
    
    #researcher for task of interest - sets image processing parameters
    study='adam'
     
    ##############################
    
    #image processing parameters
    if study=='adam':
        a=2
        b=12
        config=r'G:\Head Movement Analysis\ICR Behavior-Gia-2020-11-23\config.yaml'
        #config=r'G:\GitHub\Rodent-Turns\DLC\ICR Behavior-Gia-2020-11-23\config.yaml'
    elif study=='sahana':
        a=1
        b=100
    else:
            print('Invalid Study\n')
    
    #save current working directory
    
    
    cwd=os.getcwd()
    
    #git list of directory contents
    videos=os.listdir()
    
    
    
    #for repeated runs - delets old DeepLabCut files so new ones can be created
    for video in videos:
        if 'DLC_resnet152_ICR BehaviorNov23shuffle1_700000_filtered' in video:
            ##############################
            print("Skipping Directory: "+cwd)
            #del cwd
            return ######For running again to continue only
            ##############################
            os.remove(video)
            
    if os.path.exists(cwd.replace("ICR_Behavior",r"ICR-Behavior-2",1)):
    
        outputs=os.listdir(cwd.replace("ICR_Behavior",r"ICR-Behavior-2",1))
                
        for video in outputs:
            if 'DLC_resnet152_ICR BehaviorNov23shuffle1_700000_filtered' in video:
                ##############################
                print("Skipping Directory: "+cwd)
                #del cwd
                return ######For running again to continue only
                ##############################
                os.remove(video)
        
    
    #iterates thorugh directory files/subdirectories
    for video in videos:
                    
        #Identify VT behavior videos
        if str(video).startswith('VT') & str(video).endswith('.mpg'):
            
    
            #Display identified video name/paths, set names for new video and display       
            print('Processing video: ' + video)
            OUTvideo='Bright_'+video
            OUTvideo=os.path.join(cwd,OUTvideo)
            OUTvideo=OUTvideo.replace("ICR_Behavior",r"ICR-Behavior-2",1)
            print('Input:',os.path.abspath(video))
            print('Output:',OUTvideo)
            
            
            folders=[]
            path=OUTvideo
            while 1:
                path, folder = os.path.split(path)
                
                if folder!= "":
                    folders.append(folder)
                elif path!= "":
                    folders.append(path)
                    
                    break
            folders.reverse()
            
            buildAPath="";
            for folder in folders[:-1]:
                buildAPath=os.path.join(buildAPath,folder)
                if not os.path.exists(buildAPath):
                    os.mkdir(buildAPath)

            
            #Get input video details
            input=cv2.VideoCapture(os.path.abspath(video))
            fps=int(input.get(cv2.CAP_PROP_FPS))
            fwidth=int(input.get(cv2.CAP_PROP_FRAME_WIDTH))
            fheight=int(input.get(cv2.CAP_PROP_FRAME_HEIGHT))
            length=int(input.get(cv2.CAP_PROP_FRAME_COUNT))
    
            #Frame number counter
            #count=1
            
            ##Set Codec
            #codec=cv2.VideoWriter.fourcc(*'XVID')
            codec=cv2.VideoWriter.fourcc(*'MPEG')
    
            #Create video writer object
            video_writer=cv2.VideoWriter(OUTvideo,codec,fps,(fwidth,fheight))
            
            #Create capture of input video
            capture=cv2.VideoCapture(video)
            
            #iterage through video frames, adjust brightness/contrast and write to new video
            for i in range(length):
                _, img = capture.read()
                
                try:
                    newImg=a*img+b
                except TypeError:
                    print("Exception Caught")
                    break
                    
                video_writer.write(newImg)
                
                #counter to display progress
                if i % 5000==0:
                    print(str(i) + " of " + str(length) + " frames\n")
                
                del img
                del newImg
            
            #release video writer object
            video_writer.release()
            
            #analyze video with deeplabcut and filter coordinates with ARIMA filter in DLC
            dlc.analyze_videos(config,[OUTvideo],save_as_csv=True,gputouse=0)
            dlc.filterpredictions(config,[OUTvideo],filtertype='arima',p_bound=.01,ARdegree=3,MAdegree=1)
            
            #create DLC labeled video if necessary
            if Label_video==True:
                dlc.create_labeled_video(config,[OUTvideo],trailpoints='5',save_frames=True,filtered=True)




    

        
        
