clear
dataDir='\\DATA-SERVER\ICR_Behavior\BehaviorPilot';


tbl=readtable('Rotation_Sessions.xlsx');
roi=tbl.Rat;
soi=tbl.File;


addpath(pwd)
cd(dataDir)
rats=dir(pwd);

VT1=0;
VT2=0;

v1R=[,];
v2R=[,];
dirs=[];

MAST=table();

badSess={'0203','2016-12-20_09-18-59',...
    '0203','2016-12-21_09-18-05',...
    '0203','2017-11-06_15-54-29',...
    '0204','2017-11-06_16-43-36'...
    };

for rat=3:length(rats)
    
    
    
    if any("r"+rats(rat).name+"'"==roi)
        fprintf("Analyzing rat: %s\n",rats(rat).name)
        cd(fullfile(dataDir,rats(rat).name))
        sessions=dir(pwd);
        
        ratSOI=soi("r"+rats(rat).name+"'"==roi);
        
        
        
        for session=1:length(ratSOI)
            %         if ~isfile(sessions(session).name)
            
            fprintf("Analyzing Session: %s\n",ratSOI{session})
            cd(fullfile(dataDir,rats(rat).name,ratSOI{session}(1:end-1)))
            
            
            
            if isfile('VT1.mpg') && ~isfile('VT2.mpg')
                %cd(strrep(fullfile(dataDir,rats(rat).name,ratSOI{session}(1:end-1)),'ICR_Behavior','icr-behavior-2'))
                VT1=VT1+1;
                v1R=[v1R;rats(rat).name,ratSOI{session}(1:end-1)];
                dirs=[dirs;[pwd,'\VT1.mpg']];
                %MAST{end,4}=0;
                vType=0;
            elseif isfile('VT2.mpg') && ~isfile('VT1.mpg')
                VT2=VT2+1;
                v2R=[v2R;rats(rat).name,ratSOI{session}(1:end-1)];
                %MAST{end,4}=1;
                vType=1;
            end
            
            if any(strcmp(rats(rat).name,badSess)) && any(strcmp(ratSOI{session}(1:end-1),badSess))
            else
                try
                    MAST=[MAST;rats(rat).name,ratSOI{session}(1:end-1),{TurnDetection(vType)},vType];
                    %MAST=[MAST;rats(rat).name,ratSOI{session}(1:end-1),{nan},nan];
                catch
                    cd(strrep(fullfile(dataDir,rats(rat).name,ratSOI{session}(1:end-1)),'ICR_Behavior','icr-behavior-2'))
                    MAST=[MAST;rats(rat).name,ratSOI{session}(1:end-1),{TurnDetection(vType)},vType];
                    %MAST=[MAST;rats(rat).name,ratSOI{session}(1:end-1),{nan},nan];
                    
                end
            end
            
            %end
        end
    end
end

MAST.Properties.VariableNames={'Rat','Session','Scans','Green'};
%save("G:\GitHub\AgingManuscript\IOfiles\Data\Scans.mat",'MAST')
