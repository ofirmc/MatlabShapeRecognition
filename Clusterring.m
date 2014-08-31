function [NumOfCorners] = Clusterring(C)

Gr=strel('disk',5); %Area - Radios Of 5 Pixels (Create morphological structuring element).

Temp(:,1)=C(:,1)-min(C(:,1))+1;
Temp(:,2)=C(:,2)-min(C(:,2))+1;

Mask=zeros(max(Temp(:,1)),max(Temp(:,2)));

for i=1:8
    Mask(Temp(i,1),Temp(i,2))=1;
end

Mask2=imdilate(Mask,Gr); %Dilation Of The Dotes (Corners).

[~,NumOfCorners] = bwlabel(Mask2, 8);
end