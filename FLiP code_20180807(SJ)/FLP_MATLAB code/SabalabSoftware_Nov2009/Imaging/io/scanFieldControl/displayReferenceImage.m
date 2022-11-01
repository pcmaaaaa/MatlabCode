function displayReferenceImage(overwrite)
	global state
	
    if nargin<1
        overwrite=0;
    end
    
	if ishandle(state.internal.refFigure)
        if overwrite
            set(state.internal.refFigure, 'CloseRequestFcn', '');
			delete(state.internal.refFigure);
        else
    		updateReferenceImage;
			set(state.internal.refFigure, 'Visible', 'on');
			return
		end
	end
	
	axisPosition = [0 0 1 1];
	aspectRatio = state.internal.imageAspectRatioBias*state.acq.scanAmplitudeY/state.acq.scanAmplitudeX; 
	
	state.internal.refFigure = figure(...
		'Position', state.windowPositions.compositeImage_position, ...
		'doublebuffer', 'on',...
		'Tag',  'ReferenceFigure', ...
		'Name',  'Reference Figure', ...
		'NumberTitle', 'off',  ...
		'CloseRequestFcn', 'set(gcf, ''visible'', ''off'')', ...
		'visible', 'on' ...
		);
		
	state.internal.refAxis = axes(...
		'YDir', 'Reverse',...
		'NextPlot', 'add', ...
		'XLim', [0 state.acq.pixelsPerLine], ...
		'YLim', [0 state.acq.linesPerFrame], ...
		'CLim', [0 1], ...
		'Parent', state.internal.refFigure, ...
		'YTickLabelMode', 'manual', ...
		'XTickLabelMode', 'manual', ...
		'Position', axisPosition,  ...
		'XTickLabel', [], ...
		'YTickLabel', [], ...
		'DataAspectRatioMode', 'manual',  ...
		'DataAspectRatio', [aspectRatio 1 1]...
		);
		
	startImage=	zeros(state.acq.linesPerFrame, state.acq.pixelsPerLine, 3);

	state.internal.refImage = image(...
		startImage, ...
		'Parent', state.internal.refAxis...
		);
    
    set(state.internal.refAxis, 'DataAspectRatioMode', 'auto');
    updateReferenceImage;
