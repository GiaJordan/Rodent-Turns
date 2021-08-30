function [OUT]= TurnDetection(useTail)
%% Script to detect head turns from Circular track videos


%%%Inputs/Config%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
thresh.angle=70;    %body angle threshold to consider for scanning
thresh.speed=10;    %velocity in angle/sec, used to detect stopps
thresh.minDur=1;    %minimum duration for stops to last seconds to count as scan
thresh.LH=0.50;     %min likelihood to keep for position coords
thresh.medi=30;     %moving median pixel threshold
filterWin=75;       %moving median pixel window
generateVideo = false;  %bool flag to generate video or not
%%%Inputs/Config%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


frameRate=30;
centerPos=[370,250]; %center position of track
OUT=[];


dataPath='\\DATA-SERVER\ICR_Behavior\BehaviorPilot';

DLCpaths=dir('Bright*filtered.csv');
%DLCpaths=dir('Bright*.csv');
DLCfile=DLCpaths(end).name;

vidPaths=dir('Bright*.mpg');
%vidPaths=dir('Bright*labeled.mp4');
INvideo=vidPaths(end).name;

OUTvideo=[INvideo(8:10) '_OUT.mpg'];

video=VideoReader(INvideo);
frameRate=video.FrameRate;



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

%calc body position in radial coordinates
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


end