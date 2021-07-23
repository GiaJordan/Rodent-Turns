
dataDir='\\DATA-SERVER\ICR_Behavior\BehaviorPilot';


tbl=readtable('Rotation_Sessions.xlsx');
roi=tbl.Rat;
soi=tbl.File;


addpath(pwd)
cd(dataDir)
rats=dir(pwd);

for rat=3:length(rats)
    fprintf("Analyzing rat: %s\n",rats(rat).name)
    
    
    if any("r"+rats(rat).name+"'"==roi)
    cd(fullfile(dataDir,rats(rat).name))
    sessions=dir(pwd);
    
    ratSOI=soi("r"+rats(rat).name+"'"==roi);
    
    for session=1:length(ratSOI)
%         if ~isfile(sessions(session).name)
            
            fprintf("Analyzing Session: %s\n",ratSOI{session})
            cd(fullfile(dataDir,rats(rat).name,ratSOI{session}(1:end-1)))
            TurnDetection
        %end
    end
    end
end
