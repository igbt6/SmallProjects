


function varargout = test(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
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




% --- Executes just before test is made visible.

function test_OpeningFcn(hObject, ~, handles, varargin)   % na pocz�tku po otwarciu wyzeryje wszystko
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)
% Choose default command line output for test

%definicje wszystkich zmiennych
handles.output = hObject;

num = 0;
handles.Sn1 = num;
handles.Up1 = num;
handles.Uw1=num;
handles.deltaUz1=num;
handles.deltaPcu1=num;
handles.deltaPfe1=num;
handles.Io1=num;
handles.Sn2 = num;
handles.Uw1 = num;
handles.Uw2=num;
handles.deltaUz2=num;
handles.deltaPcu2=num;
handles.deltaPfe2=num;
handles.Io2=num;
handles.L=num;
handles.s=num;
handles.b=num;
handles.R0=num;
handles.afl=num;
handles.cu_al=num;
handles.FAZ1=num;
handles.FAZ3=num;
%Update handles structure
guidata(hObject, handles);
% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, ~, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 format short e
 %clc;
 
 if handles.afl==0&&handles.cu_al==0&&handles.FAZ1==0&&handles.FAZ3==0              %je�li  nie wybrano materia�u na przewody
      errordlg('PODAJ MATERIA� Z KT�REGO ZBUDOWANE S� PRZEWODY I UK�AD ROZMIESZCZENIA LINII!!!', 'Error')
      return
 elseif  handles.FAZ1==0&&handles.FAZ3==0
      errordlg('PODAJ UK�AD ROZMIESZCZENIA LINII!!!', 'Error')
      return
 elseif handles.afl==0&&handles.cu_al==0
    errordlg('PODAJ MATERIA� Z KT�REGO ZBUDOWANE S� PRZEWODY!!!', 'Error')
    return

 end
  
 

%OBLICZANIE PARAMETR�W TRANSFORMATOR�W :
%TRAFO 1:
Rt1= ((handles.deltaPcu1*10^-3)*(handles.Uw1^2))/(handles.Sn1^2);     %rezystancja transformatora
Zt1=((handles.deltaUz1*(handles.Uw1^2))/(100*handles.Sn1));
if handles.Sn1>2.5
  Xt1=Zt1;
else Xt1=sqrt(Zt1^2-Rt1^2);
end
%b�d� sprawdza� napi�cie wt�rne TRAFO 1 i napiecie pierwotne TRAFO 2 je�li
%Uw1<=30kV to bior� czw�rnik dla U<=30kV i tak samo dla Uw1
if handles.Uw1<=30
   Zzt1= Rt1+Xt1*1i;                         %impedancja zast�pcza transformatora
   A=[1, Zzt1; 0, 1];                         % macierz �a�cuchowa dla trafo 1
 set(handles.A1, 'String',num2str(A(1,1)));
     set(handles.A2, 'String',num2str(A(1,2)));
     set(handles.A3, 'String',num2str(A(2,1)));
     set(handles.A4, 'String',num2str(A(2,2)));
else 
    Gt1=((handles.deltaPfe1*10^-3)/(handles.Uw1^2));          %konduktancja trafo 1
    Bt1= -((handles.Io1*handles.Sn1)/(100*(handles.Uw1^2)));          %susceptancja
    
   Zzt1= Rt1+Xt1*1i;                         %impedancja zast�pcza trafo 1
   Yzt1=Gt1+Bt1*1i;                          %impedancja zast�pcza trafo 1
    
  A=[1+Zzt1*Yzt1, Zzt1; Yzt1, 1];           % macierz �a�cuchowa dla trafo 1

%set(handles.A1, 'String',A(1));%str2double(A) );
 set(handles.A1, 'String',num2str(A(1,1)));
     set(handles.A2, 'String',num2str(A(1,2)));
     set(handles.A3, 'String',num2str(A(2,1)));
     set(handles.A4, 'String',num2str(A(2,2)));
end

 
%TRAFO 2:
Rt2= ((handles.deltaPcu2*10^-3)*(handles.Uw1^2))/(handles.Sn2^2);     %rezystancja transformatora
Zt2=((handles.deltaUz2*(handles.Uw1^2))/(100*handles.Sn2));           %impedancja trafo 2
if handles.Sn2>2.5                                    %je�li moc znamionowa wi�ksza ni� 2.5 MVA 
 Xt2=Zt2;
else Xt2=sqrt(Zt2^2-Rt2^2);
end
%b�d� sprawdza� napi�cie wt�rne TRAFO 1 i napiecie pierwotne TRAFO 2 je�li
%Uw1<=30kV to bior� czw�rnik dla U<=30kV i tak samo dla Uw1
if handles.Uw1<=30
    Zzt2= Rt2+Xt2*1i;                         %impedancja zast�pcza transformatora
   C=[1, Zzt2; 0, 1];                         % macierz �a�cuchowa dla trafo 2
    set(handles.C1, 'String',num2str(C(1,1)));
     set(handles.C2, 'String',num2str(C(1,2)));
     set(handles.C3, 'String',num2str(C(2,1)));
     set(handles.C4, 'String',num2str(C(2,2)));
else 
    Gt2=((handles.deltaPfe2*10^-3)/(handles.Uw1^2));          %konduktancja trafo 2
    Bt2= -((handles.Io2*handles.Sn2)/(100*(handles.Uw1^2)));          %susceptancja trafo 2
    
    Zzt2= Rt2+Xt2*1i;                         %impedancja zast�pcza trafo 2
    Yzt2=Gt2+Bt2*1i;                          %impedancja zast�pcza trafo 2
    
    C=[1, Zzt2; Yzt2,1+Zzt2*Yzt2];           % macierz �a�cuchowa dla trafo 2
 set(handles.C1, 'String',num2str(C(1,1)));
     set(handles.C2, 'String',num2str(C(1,2)));
     set(handles.C3, 'String',num2str(C(2,1)));
     set(handles.C4, 'String',num2str(C(2,2)));
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%OBLICZANIE PARAMETR�W LINII NAPOWIETRZNEJ :
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rln=handles.R0*handles.L;                                     %Rezystancja linii 3 faz
if handles.FAZ3==1                                 %je�li mam linie tr�jfazow� p�ask� 
bsr=(((handles.b^2)*2*handles.b)^(1/3))*1000;      %�redni odst�p mi�dzy przewodami dla linii tr�jfazowych , 
else  
    bsr=handles.b*1000;% je�li jedno fazowa   % mo�na jeszcze doda�  3 uk�ad ale to jest narazie wersja testowa
%else bsr=0;
end                                                %jednotorowych  o niesymetrycznym uk�adzie przewod�w *1000 bo zamienia
r=sqrt(handles.s/pi);                             %promie� przewod�w  

if handles.afl==1                               %czyli materia� AFL
L0=(4.6*log10(bsr/r)+0.5)*10^-4; 
elseif handles.cu_al==1                         % materia� CU lub AL
 L0=(4.6*log10(bsr/0.78*r))*10^-4;
else L0=0;
end%indukcyjno�� robocza jednej fazy w [H/km] /dla AFL
%ZMIENNE POMOCNICZE 

f=50;           %[Hz]                             %cz�stotliwo�� napi�cia zasilaj�cego
omega=2*pi*f;   %[1/s]                            %pulsacja 
X0=omega*L0;                                      %reaktancja jednostkowa linii [?/km] 
Xln=X0*handles.L;                                 %Reaktancja linii napowietrznej

if handles.Uw1<=30 
    Zzl=Rln+Xln*1j;                                %impedancja zast�pcza linii                    
    B=[1,Zzl;0,1];
else % Uw1>30&Uw1<400
    Zzl=Rln+Xln*1j;                                %impedancja zast�pcza linii  
    B0=omega*(0.02415/(log10(bsr/r)))*10^-6;       %susceptancja jednostkowa[S/km]
    Bln=B0*handles.L;
    Yzl=(Bln/2)*1j;
    B=[1+(Zzl*Yzl),Zzl;2*Yzl+Yzl*Yzl*Zzl,1+(Zzl*Yzl)];
     set(handles.B1, 'String',num2str(B(1,1)));
     set(handles.B2, 'String',num2str(B(1,2)));
     set(handles.B3, 'String',num2str(B(2,1)));
     set(handles.B4, 'String',num2str(B(2,2)));
% tutaj m�g�bym doda� warunek powy�ej 400kV ale nie znam start mocy delta Po
 %   Zzl=Rln+Xln*1j;                           %impedancja zast�pcza linii  
 %   B0=omega*(0.02415/(log10(bsr/r)))*10^-6;    %susceptancja jednostkowa[S/km]
 %   Bln=B0*L;
 %   G0=                                        %konduktancja jednostkowa
 %   Yzl=(Bln/2)*1j;
end

D=A*B*C;
 set(handles.D1, 'String',num2str(D(1,1)));
     set(handles.D2, 'String',num2str(D(1,2)));
     set(handles.D3, 'String',num2str(D(2,1)));
     set(handles.D4, 'String',num2str(D(2,2)));


%funkcje opisuj�ce elementy struktury handles , (funkcje poszczeg�lnych
%element�w)

function Sn1_Callback(hObject, ~, handles)
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.Sn1 = num;
 guidata(hObject,handles)
 
 
% --- Executes during object creation, after setting all properties.
function Sn1_CreateFcn(hObject, ~, ~)
% hObject    handle to Sn1 (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','blue');
end



function Up1_Callback(hObject, ~, handles)

num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.Up1 = num;
 guidata(hObject,handles) 

% --- Executes during object creation, after setting all properties.
function Up1_CreateFcn(hObject, ~,~ )
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Uw1_Callback(hObject, ~, handles)

handles.Uw1=get(hObject,'String');
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolon� warto�� to wyrzucam error 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.Uw1 = num;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function Uw1_CreateFcn(hObject, ~, handles)
% hObject    handle to Uw1 (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltaUz1_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j' %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.deltaUz1 = num;
 guidata(hObject,handles) 


function deltaUz1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltaPcu1_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.deltaPcu1 = num;
 guidata(hObject,handles) 




function deltaPcu1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltaPfe1_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.deltaPfe1 = num;
 guidata(hObject,handles) 



function deltaPfe1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Io1_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.Io1 = num;
 guidata(hObject,handles) 



function Io1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Sn2_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.Sn2 = num;
 guidata(hObject,handles) 



function Sn2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Up2_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.Uw1 = num;
 guidata(hObject,handles) 



function Up2_CreateFcn(hObject, ~, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Uw2_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.Uw2 = num;
 guidata(hObject,handles) 



function Uw2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltaUz2_Callback(hObject, ~, handles)
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.deltaUz2 = num;
 guidata(hObject,handles) 


function deltaUz2_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltaPcu2_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
  if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.deltaPcu2 = num;
 guidata(hObject,handles) 



function deltaPcu2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltaPfe2_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.deltaPfe2 = num;
 guidata(hObject,handles) 



function deltaPfe2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Io2_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.Io2 = num;
 guidata(hObject,handles) 



function Io2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function L_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.L = num;
 guidata(hObject,handles) 


function L_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function s_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.s = num;
 guidata(hObject,handles) 


function s_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function b_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.b = num;
 guidata(hObject,handles) 


function b_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function R0_Callback(hObject, eventdata, handles)
num = str2double(get(hObject,'String'));
str=(get(hObject,'String'));
 if isnan(num)|str=='i'|str=='j'  %je�li podam litere, lub znak lub zespolona wart to wyrzuci b��d 
     num = 0;
     set(hObject,'String',num);
     errordlg('B��DNE DANE! WPROWAD� PONOWNIE', 'Error')
 end
 handles.R0 = num;
 guidata(hObject,handles) 

% --- Executes during object creation, after setting all properties.
function R0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R0 (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a1 double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a1 double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a1 white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a1 double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text62_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text62 (see GCBO)
% eventdata  reserved - to be defined in a1 future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function figure1_ResizeFcn(hObject, eventdata, handles)

% --- Executes on button press in Cu_Al.
function Cu_Al_Callback(hObject, ~, handles)
if (get(hObject,'Value') == 1)
	% Radio button is selected-take appropriate action
   set(handles.AFL,'Value',0);
   handles.cu_al=1;
    handles.afl=0;
else
   handles.cu_al=0;
    
end
 guidata(hObject,handles);

% --- Executes on button press in AFL.
function AFL_Callback(hObject, ~, handles)
% hObject    handle to AFL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (get(hObject,'Value') == 1)
  set(handles.Cu_Al,'Value',0);
   handles.afl=1;
   handles.cu_al=0;
else
     handles.afl=0;
end

 guidata(hObject,handles);

function AFL_CreateFcn(~, ~, ~)
function Cu_Al_CreateFcn(~, ~, ~)


% --- Executes on button press in faz1.
function faz1_Callback(hObject, ~, handles)
if (get(hObject,'Value') == 1)
   set(handles.faz3,'Value',0);
   handles.FAZ1=1;
   handles.FAZ3=0;
else
     handles.FAZ1=0;
end
 guidata(hObject,handles);


% --- Executes on button press in faz3.
function faz3_Callback(hObject, ~, handles)
if (get(hObject,'Value') == 1)
   set(handles.faz1,'Value',0);
   handles.FAZ3=1;
   handles.FAZ1=0;
else
     handles.FAZ3=0;
end
 guidata(hObject,handles);
