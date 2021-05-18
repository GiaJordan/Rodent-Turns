%% Script to detect head turns from W-maze or Circular track videos
% Inputs: 
% thresh:           int,    threshold, angles less than this are considered a head turn
% generateVideo:    bool,   generate video or don't
% DLCfile:          str,    path to DeepLabCut coordinate csv file
% INvideo:          str,    path of video to analyze
% OUTvideo:         str,    path to output generated video to
%   NTS, automate readmatrix and video selection with recursive dir
%   https://www.mathworks.com/matlabcentral/answers/429891-how-to-recursively-go-through-all-directories-and-sub-directories-and-process-files
%% Inputs
thresh.angle=135;
thresh.LH=0.95;
thresh.medi=30;
filterWin=25;
generateVideo = 1;
%DLCfile='G:\DATA\Sahana_W_Maze\Ephys\vt2DLC_resnet101_Head TrackingOct23shuffle1_700000_filtered.csv'
%DLCfile='G:\DATA\Sahana_W_Maze\Behavior\10555_03DLC_resnet101_W Maze BSOct30shuffle1_700000.csv';
DLCfile='G:\DATA\Adam_ICR_Behavior\0741\2020-03-02_12-42-10\DeepLabCut\Bright_VT2DLC_resnet101_ICR BehaviorNov23shuffle1_700000.csv';
%INvideo='G:\DATA\Sahana_W_Maze\vt2DLC_resnet101_Head TrackingOct23shuffle1_700000_labeled.mp4';
%INvideo='G:\DATA\Sahana_W_Maze\Ephys\vt2.mpg';
%INvideo='G:\DATA\Sahana_W_Maze\Behavior\10555_03DLC_resnet101_W Maze BSOct30shuffle1_700000_labeled.mp4';
INvideo='G:\DATA\Adam_ICR_Behavior\0741\2020-03-02_12-42-10\Bright_VT2.mpg'

%OUTvideo='G:\DATA\Sahana_W_Maze\Ephys\Verify.mp4';
%OUTvideo='G:\DATA\Sahana_W_Maze\Behavior\10555_03Verify_Labeled.mpeg';
OUTvideo='G:\DATA\Adam_ICR_Behavior\0741\2020-03-02_12-42-10\DeepLabCut\Verify.mpg'
addpath(genpath('..\DeepLabCut_CowenLabMods\'))

%%
coords=readmatrix(DLCfile);
fprintf("Reading from DeepLabCut file %s\n",DLCfile);
fprintf("Using angle threshold of %d° to detect turns\n",thresh.angle);
if generateVideo
    fprintf("Creating video based off of %s and outputting to %s\n",INvideo,OUTvideo);
end
pause(2)


%% Populate mody part arrays from DLC csv, initialize angles array
head=coords(:,2:4);
neck=coords(:,5:7);
tail=coords(:,8:10);
rows=length(head);
angles=zeros(rows,3);

head=LHcheck(head,thresh.LH);
head=medifilt(head,thresh.medi,filterWin);

neck=LHcheck(neck,thresh.LH);
neck=medifilt(neck,thresh.medi,filterWin);

tail=LHcheck(tail,thresh.LH);
tail=medifilt(tail,thresh.medi,filterWin);



%% Triangle Math - SSS method
%Triange point coordinates - duplicate variables used for ease of reading/debugging
x1=head(:,1);
y1=head(:,2);
x2=neck(:,1);
y2=neck(:,2);
x3=tail(:,1);
y3=tail(:,2);

%initialize arrays for length of triangle sides
A=zeros(size(x1));
B=zeros(size(x1));
C=zeros(size(x1));

%Calculate triangle side lengths from coordinates
A=sqrt(abs(((x2-x1).^2)+(y2-y1).^2));
B=sqrt(abs(((x2-x3).^2)+(y2-y3).^2));
C=sqrt(abs(((x3-x1).^2)+(y3-y1).^2));

%Calculate two smaller cosines of angles with rule of cosines
angles(:,1)=(B.^2 + C.^2 - A.^2)./(2.*B.*C);
angles(:,2)=(C.^2 + A.^2 - B.^2)./(2.*C.*A);

%Calculate acutal angle values by taking inverse cosine of each
angles(:,1:2) = acos(angles(:,1:2));
%Convert angle from radians to degrees
angles=rad2deg(angles);
%Calculate largest angle from the values of the other two
angles(:,3)=180-angles(:,2)-angles(:,1);

%% Identifying times when rat is turned

%Identifies frames where rat is turned based on 3rd angle value
turns=angles(:,3)<thresh.angle;

%Create videoreader object
video=VideoReader(INvideo);
%Generate timestamps for each frame
TS=(0:1/video.FrameRate:video.FrameRate*video.Duration)';
%Create list of timestamps where rat is turned
turnTS=TS(turns);

%Generate Video from frames where rat is turned
if generateVideo
    CreateTurnsVideo(video,OUTvideo,turns)
end


