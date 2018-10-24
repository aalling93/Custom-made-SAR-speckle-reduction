function LeeImages = LeeFilter(Im, n,ENL,functionMode)
%LeeFilter. 
%The LeeFilter function filtes an image with the Lee filter. 
%
% input: Im = the givin image one wish to filter
%        n  =  Number of pixels on each side of the center pixel. use 3 or 4. 
%       ENL = A mean value of ENL from the homogenous regions.  
%      functionmode = How on wish to filter, use 'r' for ratio or 'd' for
%      difference.
%   
% output:   LeeImages = Lee fitlered image.
%
% Example:  LeeFilter(img, 4, 4.5, 'r')
%           takes the image img, uses a 9x9 kernel and a ENL of 4.5 to
%           ratio filter the image. Giving a filted image. 
%
%authors: Kristian Sørensen, Eigil Lippert  and Simon Lupemba
%
%%
% functionMode can be 'd' for difference or 'r' for ratio 
%% 
% threshold between 0 and 1
dim = size(Im); %dimensions of input matrix.
deadpixel = 0;
sigma_v = sqrt(1/ENL);
%% Local values with out mask
E_norm = localMean(Im, n);
Var_y_norm = localVariance(Im,E_norm, n);
Var_x_norm = (Var_y_norm - E_norm.^2*sigma_v^2)./(1+sigma_v^2);
k_norm = Var_x_norm./Var_y_norm ;
k_norm(k_norm<0)=0;
CFAR_lee = CFAR(k_norm);
threshold = mean(CFAR_lee);
%% Local values with mask
Mask = maskDetect(Im, n, functionMode);
Mask(k_norm<threshold) = -1;  % sets k value under threshold to have no mask % visualiser masker efter dette
E = localMeanMask(Im, n, Mask);
Var_y = localVarianceMask(Im,E, n,Mask);
%% Weight 
Var_x = (Var_y - E.^2*sigma_v^2)./(1+sigma_v^2);
k = Var_x./Var_y ;
k(k<0)=0;
%% Creates the new picture
Im = E + k.*(Im-E);
%assing dead pixels 
Im (dim(1)-n+1:dim(1),:) = deadpixel;
Im (1:n,:) = deadpixel;
Im (:,dim(2)-n+1:dim(2)) = deadpixel;
Im (:,1:n) = deadpixel;
%% Return Filtered images
LeeImages = Im;
