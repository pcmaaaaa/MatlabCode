function varargout = ratios(varargin)
% RATIOS M-file for ratios.fig
%      RATIOS, by itself, creates a new RATIOS or raises the existing
%      singleton*.
%
%      H = RATIOS returns the handle to a new RATIOS or the handle to
%      the existing singleton*.
%
%      RATIOS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RATIOS.M with the given input arguments.
%
%      RATIOS('Property','Value',...) creates a new RATIOS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ratios_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ratios_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ratios

% Last Modified by GUIDE v2.5 05-Mar-2003 15:38:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ratios_OpeningFcn, ...
                   'gui_OutputFcn',  @ratios_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ratios is made visible.
function ratios_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ratios (see VARARGIN)

% Choose default command line output for ratios
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ratios wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ratios_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in select.
function select_Callback(h, eventdata, handles)
% hObject    handle to select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	global state
	
	set(h, 'Enable', 'off');	
	try
		setStatusString('Drag over ROI');
	
		siSelectionChannelToFront
		k = waitforbuttonpress;
	
		if isempty(findobj(gcf, 'Type', 'axes'))
			disp('*** NO axes***');
			set(h, 'Enable', 'on');	
			return
		end
			
			
		point1 = get(gca,'CurrentPoint');    % button down detected
		finalRect = rbbox;                   % return figure units
		setStatusString('');
	
		point2 = get(gca,'CurrentPoint');    % button up detected
		point1 = point1(1,1:2);              % extract x and y
		point2 = point2(1,1:2);
		p1 = min(point1,point2);             % calculate locations
		offset = abs(point1-point2);         % and dimensions
		x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
		y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
		x=round(x);
		y=round(y);
		hold on;
		axis manual;
	
		state.ratios.currentStartX=x(1);
		state.ratios.currentStartY=y(1);
		state.ratios.currentEndX=x(2);
		state.ratios.currentEndY=y(3);
		calcMeans
	catch
		beep;
		disp('ERROR');
		set(h, 'Enable', 'on');	
		error(lasterr);
	end
	set(h, 'Enable', 'on');	


% --- Executes on button press in calc.
function calc_Callback(hObject, eventdata, handles)
% hObject    handle to calc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
	calcMeans
	
	
function calcMeans
	global state imageData

	state.ratios.green=mean2(...
		imageData{1}(...
		state.ratios.currentStartY:state.ratios.currentEndY,...
		state.ratios.currentStartX:state.ratios.currentEndX));
	state.ratios.red=mean2(...
		imageData{2}(...
		state.ratios.currentStartY:state.ratios.currentEndY,...
		state.ratios.currentStartX:state.ratios.currentEndX));
	state.ratios.ratio = 	state.ratios.green/state.ratios.red;
	disp(['green = ' num2str(state.ratios.green) ' red = ' num2str(state.ratios.red) ' ratio = ' num2str(state.ratios.ratio)]);
	updateGUIByGlobal('state.ratios.green');
	updateGUIByGlobal('state.ratios.red');
	updateGUIByGlobal('state.ratios.ratio');
	
		
