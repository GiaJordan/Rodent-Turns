function [] = CreateTurnsVideo(video,OUTvideo,turns)
%Generates video of identified turns
%   Detailed explanation goes here
% Inputs:
% video: video reader object
% OUTvideo: path of video output
% turns: logical array of identified turns by frames
%% Video Generator

writer=VideoWriter(OUTvideo);
open(writer);


for i=1:length(turns)
    
    if(mod(i,1000)==0)
        disp(i)
    end
    
    if (turns(i))
        frame=read(video,[i i]);
        writeVideo(writer,frame);
    end

end

close(writer)


end

