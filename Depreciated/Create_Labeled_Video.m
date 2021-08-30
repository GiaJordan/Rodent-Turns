function [] = Create_Labeled_Video()
%DLC_CREATE_LABELED_VIDEO Summary of this function goes here
%   Detailed explanation goes here

addpath('G:\GitHub\DeepLabCut_CowenLabMods\String_Pulling')
thresh.LH=0.99;
thresh.medi=15;
filterWin=25;

study='sahana';
% rat=315;
% session=31;
% 
% 
% P.rat=rat;
% P.session=session;


% folders=split(pwd,'\');
% P.session=str2double(folders{end});
% P.rat=folders{end-1};
% P.rat=str2double(P.rat(end-2:end));

%add dynamic video names later
switch study
    case 'adam'
        
        vid_path='VT2.mpg';
        out_path='VT2_labeled.mp4';
        
        coords=readmatrix('Bright_VT2DLC_resnet152_ICR BehaviorNov23shuffle1_700000.csv');
        fprintf("Reading from DeepLabCut file Bright_VT2DLC_resnet152_ICR BehaviorNov23shuffle1_700000.csv\n");

    case 'sahana'
        vid_path='Dark_10555_03.mpeg';
        out_path='10555_03_labeled.mp4';
        
        coords=readmatrix('Dark_10555_03DLC_resnet152_W Maze BSOct30shuffle1_1030000.csv');
        fprintf("Reading from DeepLabCut file Dark_10555_03DLC_resnet152_W Maze BSOct30shuffle1_1030000.csv\n");
end
% if ~exist(out_path)
%     mkdir(out_path)
% end


%addpath(vid_path)
video=VideoReader(vid_path);
%coords=load('Filtered_Time_Stamped_Coordinates.mat');
%coords=coords.T2;




pause(2)


%% Populate mody part arrays from DLC csv, initialize angles array
head=coords(:,2:4);
neck=coords(:,5:7);
tail=coords(:,8:10);
%len=length(head);

head=LHcheck(head,thresh.LH);
head=medifilt(head,thresh.medi,filterWin);

neck=LHcheck(neck,thresh.LH);
neck=medifilt(neck,thresh.medi,filterWin);

tail=LHcheck(tail,thresh.LH);
tail=medifilt(tail,thresh.medi,filterWin);

S=size(coords);
clear coords
coords.head_x=head(:,1);
coords.head_y=head(:,2);
coords.neck_x=neck(:,1);
coords.neck_y=neck(:,2);
coords.tail_x=tail(:,1);
coords.tail_y=tail(:,2);


%%
writer=VideoWriter(out_path, 'MPEG-4')
open(writer)
%%
for i=1:S(1)
        if mod(i,5000)==0
            fprintf("Now on frame: %d \n",i)
        end
        frame=gpuArray(readFrame(video));
    
        figure('visible', 'off')
        imagesc(frame);
        truesize
        
        %axis xy
        hold on
        
        if ~isnan(coords.head_x(i))
            scatter(coords.head_x(i),coords.head_y(i),100,'r')
            hold on
        end
        if ~isnan(coords.neck_x(i))
            scatter(coords.neck_x(i),coords.neck_y(i),100,'g')
            hold on
        end
        if ~isnan(coords.tail_x(i))
            scatter(coords.tail_x(i),coords.tail_y(i),100,'b')
        end
        hold off
        
        
        img=getframe(gcf);
        writeVideo(writer,img);
        
        
        close
        
    
end

    %% Save video
%    writer=VideoWriter(fullfile(out_path,[num2str(i) '_Labeled']), 'MPEG-4')
    %writer.FrameRate=15;
%    open(writer)
%     for iF=1:j
%         
%         f=Frames(i,iF);
%         writeVideo(writer,f.data');
%         
%     end
%    writeVideo(writer,Frames.data);

    close(writer)
%    clear Pull



end

