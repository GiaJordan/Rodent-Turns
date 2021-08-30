# Rodent Turns
## Video Tracking analysis for VTE movements


Software to adjust brightness and contrast of behavior task videos recorded in low light. A neural network (DeepLabCut) is used to identify body parts of each rat (Head/Neck/Tail base) to be used in further analysis. Matlab code filters the position data for each body part and calcualtes the angle of the rat's body in each frame. Body angle is used to determine periods of increase looking behavior that will be integrated into other analysis pipelines.

<p>
<code>Rotation_Sessions.xlsx</code> Spreadsheet with rats and sessions to analyze.
</p>

<h1>Python</h1>
<h2>
Position Tracking  
</h2>

<p>
An anaconda environment to use with DeepLabCut for novel video analysis is included in 

    Rodent-Turns\DLC\Anaconda Environment\environment.yml
  
Nvidia CuDnn libraries will need to be added to the enviornment's directories. 
The CNN model is stored in 
  
    Rodent-Turns\DLC\ICR Behavior-Gia-2020-11-23\dlc-models\iteration-1\ICR BehaviorNov23-trainset85shuffle1\train\snapshot-700000.7z.001
  
This file should be unzipped with 7zip and the 
  
    Rodent-Turns\DLC\ICR Behavior-Gia-2020-11-23\config.yml
  
path variable should be updated before use.
</p>

<h2>
Video Editing and Analysis  
</h2>
<p>
<code>sessionIterator.py</code> Is the script to iterate through directories of interest and run the <code>processVideo.py</code> function to adjust brightness and contrast of video and analyze with DeepLabCut. <code>CheckLabels.py</code> generates labeled videos for VT1 videos.
</p>

<h1>Matlab</h1>
<h2>
Scanning Event Detection 
</h2>
<p>
<code>sessionIterator.m</code> Is the script to iterate through directories of interest and run the <code>TurnDetection.m</code> function to filter position coordinates, calculate body angle, and detect scanning events in the video. Can also choose to call <code>CreateTurnsVideo.m</code> to create a labeled video to visualize detected scanning events for a given session.
</p> 
  
