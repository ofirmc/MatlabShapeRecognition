function[]=TestMe()

I=imread('BadPicDa.jpg');
Image=ImageToDouble(I);
figure,
subplot(1,4,1);
imshow(Image),title('image');

for i=2:4
Image=imclose(Image,strel('square',3));
Image=imopen(Image,strel('square',3));  
Image=imclose(Image,strel('square',3));   

subplot(1,4,i);
imshow(Image),title('Final image');
end

