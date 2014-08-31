function [ rgbPic ] = BW2RGB( bwPic )

cmap = [0 0 0; 0 1 0; 0 0 1;  ]; %black then each color 

colormap(cmap); 
rgbPic = label2rgb(bwPic,'jet',[.7 .7 .7],'shuffle');

end