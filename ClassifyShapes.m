function [] = ClassifyShapes(Image,ImageBW)

%Threshold the Image
threshold = graythresh(Image);
imshow(Image)

%Remove the Noise
% remove all object containing fewer than 30 pixels
Image = bwareaopen(Image, 30);

% fill any holes, so that regionprops can be used to estimate the area enclosed by each of the boundaries
Image = imfill(Image, 'holes');
imshow(Image)

[boundaries, labelMatrix] = FindBoundaries(Image); % Find the Boundaries

stats = regionprops(labelMatrix, 'all'); %Information About The Shapes.

for i = 1:length(boundaries) %For Each Shape.
  
	boundary = boundaries{i}; % obtain (X,Y) boundary coordinates corresponding to label 'i'
    Roundness = 4*pi*stats(i).Area/ stats(i).Perimeter^2; % compute the roundness metric
    CArea = (pi*(stats(i).EquivDiameter^2))/4;  %Compute The Circle Area As pi*R^2.
    NumOfCorners=stats(i).Extrema; %Extrema Saving (For Square & Rectangel).
    RectCord=[NumOfCorners(2,:);NumOfCorners(4,:);NumOfCorners(6,:);NumOfCorners(8,:)]; %For Rectangle.
    BBPerimeter = 2*(stats(i).BoundingBox(1,3)+stats(i).BoundingBox(1,4)); %Saving BoundingBox Perimeter For Square & Rectangel.
    aXisDist = abs(stats(i).BoundingBox(1,3)-stats(i).BoundingBox(1,4)); %Compute Distance Between aXis.
    DecDist=0;
    for k=1:4
        Dist=sqrt((RectCord(k,1)-stats(i).Centroid(1,1))^2+(RectCord(k,2)-stats(i).Centroid(1,2))^2);
        DecDist=abs(Dist-DecDist);        
    end
    
    ShapeEdge = edge(ImageBW, 'canny');
    ShapeProps = regionprops(ShapeEdge,'all');
    CutShape = imcrop(ShapeEdge,ShapeProps(i).BoundingBox);
    [HoughMatrix,~,~]=hough(CutShape);
    ShapeNumOfCorners=houghpeaks(HoughMatrix, 4);
    [Num,~]=size(ShapeNumOfCorners);
    EllipseA = stats(i).MajorAxisLength/2;
    EllipseB = stats(i).MinorAxisLength/2; 
    EllipseArea=EllipseA*EllipseB*pi;
    
    % mark objects above the threshold with a black circle
%     if (metric > threshold)
%     centroid = stats(i).Centroid;
%     plot(centroid(1), centroid(2), 'o'); % o = is telling plot to draw a circle
%     end
    
    if (Roundness>0.85 && Roundness<1.0) && ((abs(CArea-stats(i).Area))<=10) %Circle Shape.
        Roundness_string = sprintf('Circle'); 
        text( boundary(1,2)-35, boundary(1,1)+13, Roundness_string, 'Color','black', 'FontSize',12,'FontWeight','bold');
    
    elseif (stats(i).Eccentricity<=0.3 && (abs(BBPerimeter-stats(i).Perimeter))<=10)  %Square Shape.
            metric_string = sprintf('Square');
            text( boundary(1,2)-35, boundary(1,1)+13, metric_string, 'Color','black', 'FontSize',12,'FontWeight','bold');
            
    elseif (Clusterring(NumOfCorners)==4 && DecDist<5) || (abs(BBPerimeter-stats(i).Perimeter))<=15 %Rectangle Shape.
            metric_string = sprintf('Rectangle');
            text( boundary(1,2)-35, boundary(1,1)+13, metric_string, 'Color','black', 'FontSize',12,'FontWeight','bold');

    elseif (Num==3) %Triangle Shape.
        metric_string = sprintf('Triangle');
        text( boundary(1,2)-35, boundary(1,1)+13, metric_string, 'Color','black', 'FontSize',12,'FontWeight','bold');
        
    elseif(stats(i).Eccentricity>=0.3 && (EllipseArea-stats(i).Area<=10)) %Ellipse Shape.
        metric_string = sprintf('Ellipse');
        text( boundary(1,2)-35, boundary(1,1)+13, metric_string, 'Color','black', 'FontSize',12,'FontWeight','bold');
                
    else
        metric_string = sprintf('UnIdentify'); % sprintf = format data to string
        text( boundary(1,2)-35, boundary(1,1)+13, metric_string, 'Color','black', 'FontSize',12,'FontWeight','bold');
        
    end
        
end





