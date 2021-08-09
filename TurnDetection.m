function [OUT]= TurnDetection(useTail)
%% Script to detect head turns from W-maze or Circular track videos
% Inputs:
% thresh:           int,    threshold, angles less than this are considered a head turn
% generateVideo:    bool,   generate video or don't
% DLCfile:          str,    path to DeepLabCut coordinate csv file
% INvideo:          str,    path of video to analyze
% OUTvideo:         str,    path to output generated video to
%% Inputs

thresh.angle=70;
thresh.speed=10;%angle/sec
thresh.minDur=1;%seconds
thresh.LH=0.50;
thresh.medi=30;
filterWin=75;
generateVideo = false;

frameRate=30;

centerPos=[370,250];

OUT=[];

%addpath(genpath('..\DeepLabCut_CowenLabMods\'))
% DLCfile='Bright_VT2_0001DLC_resnet152_ICR BehaviorNov23shuffle1_700000_filtered.csv';

dataPath='\\DATA-SERVER\ICR_Behavior\BehaviorPilot';

%cd 'G:\DATA\Adam_ICR_Behavior\0741\2020-03-02_12-42-10'
% % %DLCfile='G:\DATA\Sahana_W_Maze\Ephys\vt2DLC_resnet101_Head TrackingOct23shuffle1_700000_filtered.csv'
% % %DLCfile='G:\DATA\Sahana_W_Maze\Behavior\10555_03DLC_resnet101_W Maze BSOct30shuffle1_700000.csv';
% % DLCfile='G:\DATA\Adam_ICR_Behavior\0741\2020-03-02_12-42-10\DeepLabCut\Bright_VT2DLC_resnet101_ICR BehaviorNov23shuffle1_700000.csv';
% % %INvideo='G:\DATA\Sahana_W_Maze\vt2DLC_resnet101_Head TrackingOct23shuffle1_700000_labeled.mp4';
% % %INvideo='G:\DATA\Sahana_W_Maze\Ephys\vt2.mpg';
% % %INvideo='G:\DATA\Sahana_W_Maze\Behavior\10555_03DLC_resnet101_W Maze BSOct30shuffle1_700000_labeled.mp4';
% % INvideo='G:\DATA\Adam_ICR_Behavior\0741\2020-03-02_12-42-10\Bright_VT2.mpg'
% %
% % %OUTvideo='G:\DATA\Sahana_W_Maze\Ephys\Verify.mp4';
% % %OUTvideo='G:\DATA\Sahana_W_Maze\Behavior\10555_03Verify_Labeled.mpeg';
% % OUTvideo='G:\DATA\Adam_ICR_Behavior\0741\2020-03-02_12-42-10\DeepLabCut\Verify.mpg'
%
% % DLCfile='.\DeepLabCut\Bright_VT2DLC_resnet101_ICR BehaviorNov23shuffle1_700000.csv';
% % INvideo='.\Bright_VT2.mpg'
% % OUTvideo='.\DeepLabCut\Verify.mpg'

%cd('\\DATA-SERVER\ICR-Behavior-2\BehaviorPilot\0722\2019-11-18_13-08-52')


DLCpaths=dir('Bright*filtered.csv');
%DLCpaths=dir('Bright*.csv');
DLCfile=DLCpaths(end).name;

vidPaths=dir('Bright*.mpg');
%vidPaths=dir('Bright*labeled.mp4');
INvideo=vidPaths(end).name;

OUTvideo=[INvideo(8:10) '_OUT.mpg'];

video=VideoReader(INvideo);
frameRate=video.FrameRate;
%TS=(0:1/frameRate:video.Duration)';


bodyParts={'Head' 'Neck' 'Tail'};
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

TS=(0:length(head)-1)';
TS=TS*(1/frameRate);


head=LHcheck(head,thresh.LH);
head=medifilt(head,thresh.medi,filterWin);
%figure;scatter((1:length(head))',head(:,1));hold on
head=DeepLabCut_Interpol(array2table([(1:length(head))',(head(:,1:2)),(TS)]));
head=head{:,2:3};
%x=(1:length(head))';
%scatter(x(nans),head(nans,1),'r');hold off

neck=LHcheck(neck,thresh.LH);
neck=medifilt(neck,thresh.medi,filterWin);
neck=DeepLabCut_Interpol(array2table([(1:length(head))',(neck(:,1:2)),(TS)]));
neck=neck{:,2:3};

tail=LHcheck(tail,thresh.LH);
tail=medifilt(tail,thresh.medi,filterWin);
tail=DeepLabCut_Interpol(array2table([(1:length(head))',(tail(:,1:2)),(TS)]));
tail=tail{:,2:3};


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
% A=sqrt(abs(((x2-x1).^2)+(y2-y1).^2));
% B=sqrt(abs(((x2-x3).^2)+(y2-y3).^2));
% C=sqrt(abs(((x3-x1).^2)+(y3-y1).^2));

if useTail
    A=sqrt(abs(((x3-x1).^2)+(y3-y1).^2));
    B=sqrt(abs(((x3-centerPos(1)).^2)+(y3-centerPos(2)).^2));
    C=sqrt(abs(((x1-centerPos(1)).^2)+(y1-centerPos(2)).^2));
else
    %use neck point when tail tracking is off
    A=sqrt(abs(((x2-x1).^2)+(y2-y1).^2));
    B=sqrt(abs(((x2-centerPos(1)).^2)+(y2-centerPos(2)).^2));
    C=sqrt(abs(((x1-centerPos(1)).^2)+(y1-centerPos(2)).^2));
end



%Calculate two smaller cosines of angles with rule of cosines
angles(:,1)=(B.^2 + C.^2 - A.^2)./(2.*B.*C);
angles(:,2)=(C.^2 + A.^2 - B.^2)./(2.*C.*A);

%Calculate acutal angle values by taking inverse cosine of each
angles(:,1:2) = acos(angles(:,1:2));
%Convert angle from radians to degrees
angles=rad2deg(angles);
%Calculate largest angle from the values of the other two
angles(:,3)=180-angles(:,2)-angles(:,1);


pos.cart=table(head(:,1:2),neck(:,1:2),tail(:,1:2));
pos.cart.Properties.VariableNames=bodyParts;

pos.rad=table(head(:,1:2),neck(:,1:2),tail(:,1:2));
pos.rad.Properties.VariableNames=bodyParts;


for i=1:length(bodyParts)
    pos.rad.(bodyParts{i})(:,:)=nan;
    
    
    
    pos.cart.(bodyParts{i})(:,1)=pos.cart.(bodyParts{i})(:,1)-centerPos(1);
    pos.cart.(bodyParts{i})(:,2)=pos.cart.(bodyParts{i})(:,2)-centerPos(2);
    
    
    
    Q2=pos.cart.(bodyParts{i})(:,1)<0&pos.cart.(bodyParts{i})(:,2)>0;
    Q3=pos.cart.(bodyParts{i})(:,1)<0&pos.cart.(bodyParts{i})(:,2)<0;
    
    
    
    pos.rad.(bodyParts{i})(:,1)=sqrt((pos.cart.(bodyParts{i})(:,1).^2)+...
        pos.cart.(bodyParts{i})(:,2).^2);
    
    
    
    pos.rad.(bodyParts{i})(:,2)=atan(pos.cart.(bodyParts{i})(:,2)./...
        pos.cart.(bodyParts{i})(:,1))...
        *(180/pi);
    
    
    pos.rad.(bodyParts{i})(Q2,2)=pos.rad.(bodyParts{i})(Q2,2)+180;
    pos.rad.(bodyParts{i})(Q3,2)=pos.rad.(bodyParts{i})(Q3,2)-180;
    
    % x1=x1-centerPos(1);
    % x2=x2-centerPos(1);
    % x3=x3-centerPos(1);
    %
    % y1=y1-centerPos(2);
    % y2=y2-centerPos(2);
    % y3=y3-centerPos(2);
    %
    % Q2=x1<0&y1>0;
    % Q3=x1<0&y1<0;
    %
    %
    % r1=sqrt(x1.*x1+y1.*y1);
    % theta1=nan(length(x1),1);
    % theta1=atan(y1./x1)*(180/pi);
    % theta1(Q2)=theta1(Q2)+180;
    % theta1(Q3)=theta1(Q3)-180;
    
    
end




%% Identifying times when rat is turned

angVel=[0;diff(pos.rad.Neck(:,2))];
angVel=angVel./(1/frameRate);


%Identifies frames where rat is turned based on 3rd angle value
stops=angVel<thresh.speed;
turns=angles(:,3)<thresh.angle;

scans=stops&turns;

scStart=find([0;diff(scans)]==1);
scEnd=find([0;diff(scans)]==-1);

if scStart(1)>scEnd(1)
    scStart=[1;scStart];
    %scEnd=[scEnd;length(scans)];
elseif length(scEnd)==length(scStart)-1
    scEnd=[scEnd;length(head)];
end


rng=scEnd-scStart;
tooShort=rng*(1/frameRate)<thresh.minDur;

scStart(tooShort)=nan;
scEnd(tooShort)=nan;

scStart=scStart(~isnan(scStart));
scEnd=scEnd(~isnan(scEnd));

OUT.scanFrames=[scStart,scEnd];
OUT.noScans=length(scStart)


%Create videoreader object
%video=VideoReader(INvideo);
%Generate timestamps for each frame
%TS=(0:1/frameRate:video.Duration)';
%Create list of timestamps where rat is turned
% turnTS=TS(turns);
% frames=1:length(coords);
% turnFrames=frames(turns);

OUT.scanStarts=table(scStart,TS(scStart));
OUT.scanStarts.Properties.VariableNames={'Frame','TimeStamp'};
%%

%Generate Video from frames where rat is turned
if generateVideo
    CreateTurnsVideo(video,OUTvideo,OUT.scanFrames,pos)
end

% OUT=table(turnFrames,turnTS,angles(turns,3));
% OUT.Properties.VariableNames={'Turn_Frame_Numbers' 'Turn_Time_Stamps' 'Angle(degrees)'}
% writetable(OUT,'turnTS.csv')

end