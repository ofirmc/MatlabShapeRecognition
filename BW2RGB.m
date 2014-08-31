function [ rgbPic ] = BW2RGB( bwPic )

cmap = [0 0 0; 0 1 0; 0 0 1;  ]; 
colormap(cmap); 
rgbPic = label2rgb(bwPic,'jet',[.7 .7 .7],'shuffle');

end