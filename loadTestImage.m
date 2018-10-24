function img = loadTestImage(path)
%This function is desined for loading our image in matlab. 
%Here, de different information is found in the .hdr file from our origial
%image from sentinalHub. 
%
%authors: Kristian Sørensen, Eigil Lippert  and Simon Lupemba

%%                      Binary file input                     
filNavn = path;
% 'r' is read, `w` is write ect..
filID  = fopen(filNavn,'r');            
%%                   function [mean_Array,variance_Array,ENL_Array,edgevalue_Array] = evalTestImage(TestImages);   Load the picture                      
%This info is found in the giving .hdr header.
precision = 'float32';
dim = [ 11137 6787];  
img = fread(filID,dim,precision,'b');
dim1 = [6787 11137 ];  
img1 = imrotate(img,90);

%Croping the original picture and saving it as a new one.
koor = 1.0e+03 *[0.80    2.3    0.900    0.900];
img = imcrop(img1,koor);
end


