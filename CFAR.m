function threshold = CFAR(img,procent)
%This function determines the constant false alarm rate (CFAR) threshold. Here it is set to 1%
%in order to get a meaningful amount of pixel above the threshold (the
%images considered are small). Since index are only whole numbered, the
%final CFA will be given as 1% +- uncertainty (due to rounding off).
%The function sums the intensities from the homogenous regions, and uses
%the higest number of pixel intensities as defiend from procent.
%
% input: img = the givin image one wish to use a CFAR for. 
%        Procent = the procentage one would use. 
%
% output: Threshold = CFAR threshold
%
% Example: CFAR(img,1)
%         calcualtes the CFAR.
%     
%authors: Kristian Sørensen, Eigil Lippert  and Simon Lupemba
%
if nargin == 1
    procent=1;
end
r1 = [10.5100  114.5100  115.9800  117.9800]; % vand 
r2 = [359.5100  677.5100   37.9800   38.9800];% lys mark
r3 = [500.5100  743.5100   67.9800   75.9800];% mÃ¸rk mark

data = [reshape(imcrop(img,r1), 1,[]) , reshape(imcrop(img,r2), 1,[]),reshape(imcrop(img,r3), 1,[])];
sortedVector = sort(data);
len = length(sortedVector);
index = round(len-len/100*procent);
%threshold
threshold = sortedVector(index);
%creates sorted vector based on all array elements
