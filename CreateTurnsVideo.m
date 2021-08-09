function [] = CreateTurnsVideo(video,OUTvideo,scans,pos)
%Generates video of identified turns
%   Detailed explanation goes here
% Inputs:
% video: video reader object
% OUTvideo: path of video output
% turns: logical array of identified turns by frames
%% Video Generator

writer=VideoWriter(OUTvideo);
open(writer);


for i=1:size(scans,1)
    
%     if(mod(i,1000)==0)
%         disp(i)
%     end
%     
%     
%     
%     if (scans(i))
%         frame=read(video,[i i]);
%         writeVideo(writer,frame);
%     end

    for j=scans(i,1):scans(i,2)
        
        
        
        
        
        frame=read(video,j);
        writeVideo(writer,frame);
%         imagesc(flipud(frame))
%         axis xy
%         hold on
%         scatter(pos.cart.Head(j,1)+370,pos.cart.Head(j,2),'r')
%         hold on
%         scatter(pos.cart.Tail(j,1)+370,pos.cart.Tail(j,2),'b')
%         hold on
%         scatter(370,250)
%         hold off
%         close
    end
    
    
    
end

close(writer)


end

