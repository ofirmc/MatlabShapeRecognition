function varargout = FinaleProject(varargin)
% FINALEPROJECT MATLAB code for FinaleProject.fig
%      FINALEPROJECT, by itself, creates a new FINALEPROJECT or raises the existing
%      singleton*.
%
%      H = FINALEPROJECT returns the handle to a new FINALEPROJECT or the handle to
%      the existing singleton*.
%
%      FINALEPROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINALEPROJECT.M with the given input arguments.
%
%      FINALEPROJECT('Property','Value',...) creates a new FINALEPROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FinaleProject_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FinaleProject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FinaleProject

% Last Modified by GUIDE v2.5 05-Jan-2014 23:10:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FinaleProject_OpeningFcn, ...
                   'gui_OutputFcn',  @FinaleProject_OutputFcn, ...
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


% --- Executes just before FinaleProject is made visible.
function FinaleProject_OpeningFcn(hObject, eventdata, handles, varargin)

handles.Image=im2double(imread('PicDa.jpg'));

handles.OriginalImage=handles.Image;
handles.BWI=ImageToDouble(handles.Image);
imshow (handles.Image,'Parent', handles.axes1);

[handles.boundaries, handles.labelMatrix] = FindBoundaries(handles.BWI);	% Find the Boundaries
handles.Props = regionprops(handles.labelMatrix, 'all');	%Information About The Shapes.
handles.GrayPic=0.2989*(handles.Image(:,:,1))+0.587*(handles.Image(:,:,2))+0.114*(handles.Image(:,:,3));    %The RGB2GrayScale Equation.

% Choose default command line output for FinaleProject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

function varargout = FinaleProject_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Circle.
function Circle_Callback(hObject, eventdata, handles)
cla
ImGray(:,:,1)=handles.GrayPic;
ImGray(:,:,2)=handles.GrayPic;
ImGray(:,:,3)=handles.GrayPic;

for i = 1:length(handles.boundaries) %For Each Shape.
    
    Roundness = 4*pi*handles.Props(i).Area/ handles.Props(i).Perimeter^2; % compute the roundness metric
    CArea = (pi*(handles.Props(i).EquivDiameter^2))/4;  %Compute The Circle Area As pi*R^2.


    if Roundness>0.9 && Roundness<1.0 && (abs(CArea-handles.Props(i).Area))<=10 %Circle Shape.
        ImGray=ColoringChosenShapes(handles.labelMatrix,ImGray, handles.Image, i);
     end
end
imshow(ImGray);

% --- Executes on button press in Square.
function Square_Callback(hObject, eventdata, handles)
cla
ImGray(:,:,1)=handles.GrayPic;
ImGray(:,:,2)=handles.GrayPic;
ImGray(:,:,3)=handles.GrayPic;

for i = 1:length(handles.boundaries) %For Each Shape.
    
    BBPerimeter = 2*(handles.Props(i).BoundingBox(1,3)+handles.Props(i).BoundingBox(1,4)); %Saving BoundingBox Perimeter For Square.
    
    if handles.Props(i).Eccentricity<=0.3 && (abs(BBPerimeter-handles.Props(i).Perimeter))<=10 %Square Shape.
        ImGray=ColoringChosenShapes(handles.labelMatrix,ImGray, handles.Image, i);
     end
end
imshow(ImGray);

% --- Executes on button press in Rectangle.
function Rectangle_Callback(hObject, eventdata, handles)
cla
ImGray(:,:,1)=handles.GrayPic;
ImGray(:,:,2)=handles.GrayPic;
ImGray(:,:,3)=handles.GrayPic;

for i = 1:length(handles.boundaries) %For Each Shape.
    
    BBPerimeter = 2*(handles.Props(i).BoundingBox(1,3)+handles.Props(i).BoundingBox(1,4)); %Saving BoundingBox Perimeter For Rectangle.
    NumOfCorners=handles.Props(i).Extrema; %Extrema Saving.
    RectCord=[NumOfCorners(2,:);NumOfCorners(4,:);NumOfCorners(6,:);NumOfCorners(8,:)]; %For Rectangle.
    DecDist=0;
    for k=1:4       %Compute Distance Between The Corners And The Centroid In Rectangel.
        Dist=sqrt((RectCord(k,1)-handles.Props(i).Centroid(1,1))^2+(RectCord(k,2)-handles.Props(i).Centroid(1,2))^2);
        DecDist=abs(Dist-DecDist);
    end
    
    if handles.Props(i).Eccentricity>0.3
        if (Clusterring(NumOfCorners)==4 && DecDist<5) || (abs(BBPerimeter-handles.Props(i).Perimeter))<=15
        ImGray=ColoringChosenShapes(handles.labelMatrix,ImGray, handles.Image, i);
        end
     end
end
imshow(ImGray);

% --- Executes on button press in Triangle.
function Triangle_Callback(hObject, eventdata, handles)
cla
ImGray(:,:,1)=handles.GrayPic;
ImGray(:,:,2)=handles.GrayPic;
ImGray(:,:,3)=handles.GrayPic;

for i = 1:length(handles.boundaries) %For Each Shape.

    ShapeEdge = edge(handles.BWI, 'canny');       %Create Shape Boundery With 'canny' Algorithm.
    ShapeProps = regionprops(ShapeEdge,'all');    
    CutShape = imcrop(ShapeEdge,ShapeProps(i).BoundingBox); %Cut The Shape Region (useing BoundingBox) To Analays.
    [HoughMatrix,~,~]=hough(CutShape);          %Preform Hough Transformation.
    NumOfCorners=houghpeaks(HoughMatrix, 4);    %Find The Peaks From Hough Matrix (Peaks=Num Of Lines). 
    [Num,~]=size(NumOfCorners);                 
    imshow(CutShape);
    
    if Num==3   %Triangle Shape.
        ImGray=ColoringChosenShapes(handles.labelMatrix,ImGray, handles.Image, i);
     end
end
imshow(ImGray);

% --- Executes on button press in Ellipse.
function Ellipse_Callback(hObject, eventdata, handles)
cla
[n,m]=size(handles.labelMatrix);
ImGray(:,:,1)=handles.GrayPic;
ImGray(:,:,2)=handles.GrayPic;
ImGray(:,:,3)=handles.GrayPic;

for i = 1:length(handles.boundaries) %For Each Shape.
    
    EllipseA = handles.Props(i).MajorAxisLength/2;
    EllipseB = handles.Props(i).MinorAxisLength/2; 
    EllipseArea=EllipseA*EllipseB*pi;
    
    if (handles.Props(i).Eccentricity>=0.3 && (EllipseArea-handles.Props(i).Area<=10)) %Ellipse Shape.
        ImGray=ColoringChosenShapes(handles.labelMatrix,ImGray, handles.Image, i);
    end
end
imshow(ImGray);

% --- Executes on button press in AllShapes.
function AllShapes_Callback(hObject, eventdata, handles)
cla
ClassifyShapes(handles.labelMatrix ,handles.BWI);

% --- Executes on button press in NoneOfTheAbove.
function NoneOfTheAbove_Callback(hObject, eventdata, handles)   %Color all shapes in GrayScale.
cla
imshow (handles.GrayPic,'Parent', handles.axes1);

% --- Executes on button press in ReStart.
function ReStart_Callback(hObject, eventdata, handles)
cla
handles.Image=handles.OriginalImage;
handles.BWI=ImageToDouble(handles.Image);

[handles.boundaries, handles.labelMatrix] = FindBoundaries(handles.BWI);	% Find the Boundaries
handles.Props = regionprops(handles.labelMatrix, 'all');	%Information About The Shapes.
handles.GrayPic=0.2989*(handles.Image(:,:,1))+0.587*(handles.Image(:,:,2))+0.114*(handles.Image(:,:,3));    %The RGB2GrayScale

imshow (handles.Image,'Parent', handles.axes1);
guidata(hObject, handles);

% --- Executes on button press in Dilation.
function Dilation_Callback(hObject, eventdata, handles)
contents  = get(handles.CleaningSquareSize,'String');
contentsValue = contents{get(handles.CleaningSquareSize,'Value')};

  switch contentsValue
          case '2'         
         %Create structuring element
          se=strel('square', 2);
          case '5'         
         %Create structuring element
          se=strel('square', 5);
          case '10'         
         %Create structuring element
          se=strel('square', 10);
          case '15'         
         %Create structuring element
          se=strel('square', 15);
          case '20'         
         %Create structuring element
          se=strel('square', 20);
          case '25'         
         %Create structuring element
          se=strel('square', 25);
          case '30'         
         %Create structuring element
          se=strel('square', 30);
  end
%Dilation
handles.BWI=imdilate(handles.BWI,se);       
handles.imgCleaned = handles.BWI;
imshow (handles.imgCleaned,'Parent', handles.axes1);
guidata(hObject, handles);

% --- Executes on button press in Erosion.
function Erosion_Callback(hObject, eventdata, handles)
contents  = get(handles.CleaningSquareSize,'String');
contentsValue = contents{get(handles.CleaningSquareSize,'Value')};

  switch contentsValue
          case '2'         
         %Create structuring element
          se=strel('square', 2);
          case '5'         
         %Create structuring element
          se=strel('square', 5);
          case '10'         
         %Create structuring element
          se=strel('square', 10);
          case '15'         
         %Create structuring element
          se=strel('square', 15);
          case '20'         
         %Create structuring element
          se=strel('square', 20);
          case '25'         
         %Create structuring element
          se=strel('square', 25);
          case '30'         
         %Create structuring element
          se=strel('square', 30); 
  end
 %Erosion
handles.BWI=imerode(handles.BWI,se);         
handles.imgCleaned = handles.BWI;
imshow (handles.imgCleaned,'Parent', handles.axes1);
guidata(hObject, handles);

% --- Executes on button press in Closing.
function Closing_Callback(hObject, eventdata, handles)
contents  = get(handles.CleaningSquareSize,'String');
contentsValue = contents{get(handles.CleaningSquareSize,'Value')};

  switch contentsValue
          case '2'         
         %Create structuring element
          se=strel('square', 2);
          case '5'         
         %Create structuring element
          se=strel('square', 5);
          case '10'         
         %Create structuring element
          se=strel('square', 10);
          case '15'         
         %Create structuring element
          se=strel('square', 15);
          case '20'         
         %Create structuring element
          se=strel('square', 20);
          case '25'         
         %Create structuring element
          se=strel('square', 25);
          case '30'         
         %Create structuring element
          se=strel('square', 30); 
  end

handles.BWI=imclose(handles.BWI,se);       
handles.imgCleaned = handles.BWI;
imshow (handles.imgCleaned,'Parent', handles.axes1);
guidata(hObject, handles);

% --- Executes on button press in Opening.
function Opening_Callback(hObject, eventdata, handles)
contents  = get(handles.CleaningSquareSize,'String');
contentsValue = contents{get(handles.CleaningSquareSize,'Value')};

  switch contentsValue
          case '2'         
         %Create structuring element
          se=strel('square', 2);
          case '5'         
         %Create structuring element
          se=strel('square', 5);
          case '10'         
         %Create structuring element
          se=strel('square', 10);
          case '15'         
         %Create structuring element
          se=strel('square', 15);
          case '20'         
         %Create structuring element
          se=strel('square', 20);
          case '25'         
         %Create structuring element
          se=strel('square', 25);
          case '30'         
         %Create structuring element
          se=strel('square', 30);
  end
 
handles.BWI=imopen(handles.BWI,se); 
handles.imgCleaned = handles.BWI;
imshow (handles.imgCleaned,'Parent', handles.axes1);
guidata(hObject, handles);

% --- Executes on button press in JustCleanIt.
function JustCleanIt_Callback(hObject, eventdata, handles)
contents  = get(handles.CleaningSquareSize,'String');
contentsValue = contents{get(handles.CleaningSquareSize,'Value')};

  switch contentsValue
          case '2'         
          for k=1:6 %Create structuring element
            se=strel('square', 2);
            handles.BW_opend=imopen(handles.BWI,se);
            handles.BW_close=imclose(handles.BW_opend,se); 
            handles.imgCleaned = handles.BW_close;
            imshow (handles.imgCleaned,'Parent', handles.axes1);
%             guidata(hObject, handles);            
          end
          case '5'         
         %Create structuring element
          se=strel('square', 5);
          case '10'         
         %Create structuring element
          se=strel('square', 10);
          case '15'         
         %Create structuring element
          se=strel('square', 15);
          case '20'         
         %Create structuring element
          se=strel('square', 20);
          case '25'         
         %Create structuring element
          se=strel('square', 25);
          case '30'         
         %Create structuring element
          se=strel('square', 30); 
  end
  
%Clean the image
handles.BWI=imopen(handles.BWI,se);
handles.BWI=imclose(handles.BWI,se); 
handles.imgCleaned = handles.BWI;
imshow (handles.imgCleaned,'Parent', handles.axes1);
guidata(hObject, handles);

% --- Executes on selection change in CleaningSquareSize.
function CleaningSquareSize_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function CleaningSquareSize_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function TextCSS_Callback(hObject, eventdata, handles)

% Hints: get(hObject,'String') returns contents of TextCSS as text
%        str2double(get(hObject,'String')) returns contents of TextCSS as a double


% --- Executes during object creation, after setting all properties.
function TextCSS_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StartIdentifyingShapes.
function StartIdentifyingShapes_Callback(hObject, eventdata, handles)
[handles.boundaries, handles.labelMatrix] = FindBoundaries(handles.imgCleaned);	% Find the Boundaries
handles.Props = regionprops(handles.labelMatrix, 'all');	%Information About The Shapes.

handles.rgbCleanedIMG = BW2RGB(handles.labelMatrix);
handles.GrayPic=0.2989*(handles.rgbCleanedIMG(:,:,1))+0.587*(handles.rgbCleanedIMG(:,:,2))+0.114*(handles.rgbCleanedIMG(:,:,3));    %The RGB2GrayScale Equation.

handles.Image=handles.rgbCleanedIMG;
guidata(hObject, handles);

