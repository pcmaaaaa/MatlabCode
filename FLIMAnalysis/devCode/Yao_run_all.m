% Run this function to find dendrite shift and to perform nucleus search
%
% Standard Operating Procedure
%
%   If you just opened matlab, your matlab search path not be correct
%       In the Command Window, use:
%           matlabpath(pathdef)
%       The Current Folder will need to be set to where ever pathdef.m is
%
%   Load spc_main by entering in the Command Window
%       spc_drawInit
%
%   Find a good starting image, with spc_main, for each cycle
%
%   Edit this file to say which cycle is
%       Dendrite = 0
%       Nucleus search = 1
%   For dendrite shift,
%       Manually select ROI
%   For nucleus search,
%       Edit this file to specify which channel is to be inverted
%
%   Now you can run this function



%% Cycle Identification and Nucleus Color Input
% Specify current image number, then 0 for dendrite or COLOR for nucleus
% where COLOR is the color of the nucleus
%   Use format:
%       CycleIdentification = {numImg1 type; numImg2 type; numImg3 type};
%
%   example:
%       CycleIdentification = {63 0; 65 0; 62 'red'}
%
%           Image #63 is dendrite
%           Image #65 is dendrite
%           Image #62 is nucleus, nucleus color is red



CycleIdentification = {155 'blue'}; % Set 533



% Is this a new set?
isNewSet = 1;

% Do you need to reload the images?
getImages = 1; % 0 = no, 1 = yes






%% Before Initialization, Prepare Some Variables



% Photon value threshold
valPhoton_threshold = 200000; %200,000 is a reasonable value for 20 frames; it gives a stdev of 0.0035ns, 2.8X0.01ns.

% function links
funcLink = [];

funcLink.findDendriteShift =...
    'Yao_findDendriteShift_v7';
funcLink.findNucleus =...
    'Yao_findNucleus_v17';

funcLink.findNucleus_func_List = char(...
    'None','User Input','Mask',...
    'Yao_findNucleus_func_v4b',...
    'Yao_findNucleus_func_v5b',...
    'Yao_findNucleus_func_v6b' );
funcLink.findNucleus_func_default =...
    'Yao_findNucleus_func_v4b';

funcLink.findNucleusMask =...
    'Yao_findNucleusMask_v9b';

funcLink.getZones =...
    'Yao_generic_zoneID_v3';



funcLink.loadImage =...
    'Yao_generic_loadImage_v3';





dendriteOpt = [];
nucleusOpt = [];

dendriteOpt.rotation = 0; % 0 = off, 1 = on
% dendriteOpt.isolateBeforeShift = 0; % 0 = off, 1 = on

nucleusOpt.borderThreshold = 10;
% Occurs during findCell
%   Will get a list of all Cell IDs. From this list, it will go through
%   each image and collect the centroid position of each cell. For a given
%   Cell ID, it will find the centroid furthest from the border. If that
%   distance is less than borderThreshold, that Cell ID will be marked for
%   deletion. All cells with that Cell ID will be removed.

nucleusOpt.valleyDetection = [0]; % 0 = off, 1 = on
% Occurs duing cell isolation
%   Try to identify valleys in isolated cells which may indicate a split
%   between two adjacent cells

nucleusOpt.checkAppendages = [0]; % 0 = off, 1 = on
% Occurs after cell isolation and indexing
%   Iterative process to remove appendages

nucleusOpt.erodeCell_calc = 2;
% Description



% Color codes
colorList = char('r','y','g','c','b');
%   Cell 1 will be red
%   Cell 2 will be yellow
%   Cell 3 will be green
%   etc



% Pixel Count threshold
%   threshold = f( zoomFactor )
%       400 = f( 10 )
%       200 = f(  5 )
% % % temp = [10 400;5 200];
temp = [10 400;5 200];
%
%           ( y2 - y1 )
%       m = ------------
%           ( x2 - x1 )
%
%       b = y1 - m*x1
%
temp_m = zeros( size(temp,1)-1 ,1);
for i = 1:size(temp,1)-1
    temp_m(i) = (temp(i+1,2)-temp(i,2))/(temp(i+1,1)-temp(i,1));
end
temp_m = mean(temp_m);
temp_b = zeros( size(temp,1) ,1);
for i = 1:size(temp,1)
    temp_b(i) = temp(i,2)-temp_m*temp(i,1);
end
temp_b = mean(temp_b);
cellPixelCount_threshold_b = temp_b;
cellPixelCount_threshold_m = temp_m;
clear temp temp_b temp_m



%% Things to be aware of
%   Cell indexing assumes that if there are predominately two cells, every
%   image that has only 2 cells will have the SAME 2 cells
%
%   Assumes that second imageShift detection (Yao_findCells_VERSION) is
%   accurate
%
%   Determination of nCell_true has a tipping point of 1/4
%       Used in:
%           Yao_findCells_VERSION
%           Yao_identify_cellIndex_VERSION
%
%       In function:
%           Yao_findCells_calc__nCell_true
%
%   Threshold difference for origin distance set at 20 pixels
%   (Yao_identify_cellIndex_VERSION)



%% Begin initialization
global stateYao



stateYao.StartSettings.CycleIdentification = CycleIdentification;
stateYao.StartSettings.valPhoton_threshold = valPhoton_threshold;
stateYao.StartSettings.dendriteOpt = dendriteOpt;
stateYao.StartSettings.nucleusOpt = nucleusOpt;
stateYao.StartSettings.colorList = colorList;
stateYao.StartSettings.cellPixelCount_threshold_b = cellPixelCount_threshold_b;
stateYao.StartSettings.cellPixelCount_threshold_m = cellPixelCount_threshold_m;

stateYao.StartSettings.funcLink = funcLink;

clear CycleIdentification
clear valPhoton_threshold
clear dendriteOpt nucleusOpt
clear colorList
clear cellPixelCount_threshold_b cellPixelCount_threshold_m

clear funcLink



[continueRun] = Yao_initialize__run_all(isNewSet);



%% Do we need to re-grab images?
if isNewSet || getImages
    Yao_initialize__getImages
end



%% Do we need to get initial shift?
if isNewSet || getImages
    Yao_initialize__getShift_initial
end



%% Run - Dendrites
for iCycle = 1:size( stateYao.curRun ,1)
    numCycle = stateYao.curRun(iCycle);
    
    if any( numCycle == stateYao.CycleDendrite )
        % Dendrite -> Search for shift
        %   Mask was found during initialization
        
        
        hdlProgDendrite = waitbar(0,...
            sprintf('Getting Dendrite Shift for Cycle %d',numCycle) );
        
        
        for iImg = 1:size( stateYao.CyclePositions ,1)
            if stateYao.CyclePositions(iImg,numCycle) ~= 0
            if stateYao.ignoreImage(iImg,numCycle) == 0
                
                
                if ishandle(hdlProgDendrite)
                waitbar(...
                    iImg/size(stateYao.CyclePositions,1),...
                    hdlProgDendrite)
                drawnow
                end
                
                
                eval( sprintf('%s(numCycle,iImg)',...
                    stateYao.funcLink.findDendriteShift) )

            end
            end
        end
        
        if ishandle(hdlProgDendrite)
        close(hdlProgDendrite)
        drawnow
        end
        
    end
    
end





%% Run - Nuclei
for iCycle = 1:size( stateYao.curRun ,1)
    numCycle = stateYao.curRun(iCycle);
    
    if any( numCycle == stateYao.CycleNucleus )
        % Find cells first
        Yao_findCells(numCycle)
    end
end

for iCycle = 1:size( stateYao.curRun ,1)
    numCycle = stateYao.curRun(iCycle);
    
    if any( numCycle == stateYao.CycleNucleus )
        % Get nucleus
        
        str = sprintf('Finding Nuclei for Cycle %d...',numCycle);
        hdlProgFindNucleus = waitbar(0,str);
        
        for iImg = 1:size( stateYao.CyclePositions ,1)
            if stateYao.CyclePositions(iImg,numCycle) ~= 0
                if stateYao.ignoreImage(iImg,numCycle) == 0
                    
                    if ishandle(hdlProgFindNucleus)
                        waitbar(...
                            iImg/size( stateYao.CyclePositions ,1),...
                            hdlProgFindNucleus)
                        drawnow
                    end
                    
                    eval( sprintf('%s(numCycle,iImg)',...
                        stateYao.funcLink.findNucleus) )
                    
                end
            end
        end
        
        if ishandle(hdlProgFindNucleus)
        close(hdlProgFindNucleus)
        drawnow
        end
        
    end
end

for iCycle = 1:size( stateYao.curRun ,1)
    numCycle = stateYao.curRun(iCycle);
    
    if any( numCycle == stateYao.CycleNucleus )
        % Do we need to create masks?
        eval(sprintf('%s(%s)',...
            stateYao.funcLink.findNucleusMask,...
            sprintf('%s',...
            'numCycle') ))
    end
end



%%
Yao_launchGui