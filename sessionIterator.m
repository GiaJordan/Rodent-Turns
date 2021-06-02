
dataDir='\\DATA-SERVER\ICR_Behavior\BehaviorPilot';
addpath(pwd)
cd(dataDir)
rats=dir(pwd);

for rat=3:length(rats)
    fprintf("Analyzing rat: %s\n",rats(rat).name)
    cd(fullfile(dataDir,rats(rat).name))
    sessions=dir(pwd);
    
    for session=3:length(sessions)
        if ~isfile(sessions(session).name)
            fprintf("Analyzing rat: %s\n",sessions(session).name)
            cd(fullfile(dataDir,rats(rat).name,sessions(session).name))
            TurnDetection
        end
    end
end
