function varargout = RunHH_gui(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RunHH_gui.m
% Written by Joshua H. Goldwyn
% April 22, 2011
% Distributed with:
%   JHG and E-Shea-Brown, "The what and where of channel noise in the Hodgkin-Huxley equations", submitted to PLoS Computational Biology, 2011.

% RUNHH_GUI MATLAB code for RunHH_gui.fig
%      RUNHH_GUI, by itself, creates a new RUNHH_GUI or raises the existing
%      singleton*.
%
%      H = RUNHH_GUI returns the handle to a new RUNHH_GUI or the handle to
%      the existing singleton*.
%
%      RUNHH_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUNHH_GUI.M with the given input arguments.
%
%      RUNHH_GUI('Property','Value',...) creates a new RUNHH_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RunHH_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RunHH_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RunHH_gui

% Last Modified by GUIDE v2.5 21-Apr-2011 22:28:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RunHH_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @RunHH_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before RunHH_gui is made visible.
function RunHH_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RunHH_gui (see VARARGIN)

% Choose default command line output for RunHH_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RunHH_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% % function radiobutton_Callback(hObject,eventdata)
% % if (get(hObject,'Value') == get(hObject,'Max'))
% %  % Radio button is selected-take approriate action
% % else
% %  % Radio button is not selected-take approriate action
% % end

% --- Outputs from this function are returned to the command line.
function varargout = RunHH_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function sigma_Callback(hObject, eventdata, handles)
% hObject    handle to sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigma as text
%        str2double(get(hObject,'String')) returns contents of sigma as a double

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function area_Callback(hObject, eventdata, handles)
% hObject    handle to area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of area as text
%        str2double(get(hObject,'String')) returns contents of area as a double


% --- Executes during object creation, after setting all properties.
function area_CreateFcn(hObject, eventdata, handles)
% hObject    handle to area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_Callback(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time as text
%        str2double(get(hObject,'String')) returns contents of time as a double


% --- Executes during object creation, after setting all properties.
function time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dt_Callback(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dt as text
%        str2double(get(hObject,'String')) returns contents of dt as a double


% --- Executes during object creation, after setting all properties.
function dt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function I_Callback(hObject, eventdata, handles)
% hObject    handle to I (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of I as text
%        str2double(get(hObject,'String')) returns contents of I as a double


% --- Executes during object creation, after setting all properties.
function I_CreateFcn(hObject, eventdata, handles)
% hObject    handle to I (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Determine which model to use
Model = find(get(handles.ChooseSolver,'SelectedObject') == get(handles.ChooseSolver,'Children'));
if (Model==6)  % ODE
    ModelString = 'ODE';
elseif (Model==5) % Current
    ModelString = 'Current';
    sigma = str2num(get(handles.sigma,'String'));
elseif (Model==4) % Subunit
    ModelString = 'Subunit';
    area = str2num(get(handles.area,'String'));
elseif (Model==3) % Conductance (Linaro voltage clamp)
    ModelString = 'VClamp';
    area = str2num(get(handles.area,'String'));
elseif (Model==2) % Conductance (Fox Lu system size)
    ModelString = 'FoxLuSystemSize';
    area = str2num(get(handles.area,'String'));
elseif (Model==1) % Markov Chain
    ModelString = 'MarkovChain';
    area = str2num(get(handles.area,'String'));
end


% Get noise parameters
if (Model==5) % current noise
    if (~isnumeric(sigma) || isempty(sigma))
        set(handles.sigma,'BackgroundColor',[1 .2 0]); 
        ok_sigma = 0;
    else
        set(handles.sigma,'BackgroundColor',[0.701961 0.701961 0.701961]);
        ok_sigma = 1;
    end
else
    set(handles.sigma,'String','N/A');
    ok_sigma = 1;
    set(handles.sigma,'BackgroundColor',[0.701961 0.701961 0.701961]);
    sigma = 0;
    sigma = '[]';
end

if ismember(Model,[1,2,3,4])
    if (~isnumeric(area) || isempty(area))
        set(handles.area,'BackgroundColor',[1 .2 0]);
        ok_area = 0;
    else
        set(handles.area,'BackgroundColor',[0.701961 0.701961 0.701961]);
        ok_area = 1; 
        NNa = round(60*area);
        NK = round(18*area);
    end
else
    set(handles.area,'String','N/A');
    ok_area = 1;
    set(handles.area,'BackgroundColor',[0.701961 0.701961 0.701961]);
    area = '[]';
end

% Get Simulation Parameters
t =str2num(get(handles.time,'String'));
if (~isnumeric(t) || isempty(t))
   set(handles.time,'BackgroundColor',[1 .2 0]);
   ok_t = 0;
else
   set(handles.time,'BackgroundColor',[0.701961 0.701961 0.701961]);
   ok_t = 1; 
end

dt = str2num(get(handles.dt,'String'));
if (~isnumeric(dt) || isempty(dt))
     set(handles.dt,'BackgroundColor',[1 .2 0]);
     ok_dt = 0;
else
    set(handles.dt,'BackgroundColor',[0.701961 0.701961 0.701961]);
    ok_dt =1;
end

Istring = get(handles.I,'String');
if (isempty(Istring))
     set(handles.I,'BackgroundColor',[1 .2 0]);
     ok_I = 0;
else
    set(handles.I,'BackgroundColor',[0.701961 0.701961 0.701961]);
    ok_I =1;
    Ifunc =  @(t) eval(Istring);
end

if (ok_sigma && ok_area && ok_t && ok_dt && ok_I)

% Call function that solves HH equations

tic;
Y = StochasticHH_func([0:dt:t], Ifunc, sigma, area,ModelString);
ComputeTime = toc;

% Matlab command written to gui
CommandString = ['Y = StochasticHH_func([0:',num2str(dt),':',num2str(t),'], @(t)', Istring, ', ',num2str(sigma), ', ', num2str(area), ', ''', ModelString,''');'];%,num2str(eval(dt)),':']
set(handles.MatlabCommand,'String', CommandString);

% Plot results
plot(Y(:,1),Y(:,2),'LineWidth',2)
%hold all, plot(Y(:,1),Ifunc(Y(:,1)));
axis([0 t min([Y(:,2); -20]) max([Y(:,2); 120])]) 
set(gca,'FontSize',14)
xlabel('Time (ms)','FontSize',16)
ylabel('Voltage (mV)','FontSize',16)
text(.8*t,105,['Run Time=',num2str(.01*round(100*ComputeTime)),'s'], 'FontSize',14)
end
