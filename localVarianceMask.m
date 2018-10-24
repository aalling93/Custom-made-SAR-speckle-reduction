function V = localVarianceMask(Im,localMeanMask, n,Mask)
% The following function calculates the variance of a mask. This is used as
% input in the Lee filter. This function should always be used with the
% functions localMeanMask.m and maskDetect.m
%
% input: Image = the givin image one wish to filter
%       localMeanMask  = Input from function. 
%        Mask = gives the function a mask as computated in function
%        maskDetect.m
% output: n = number of pixels on each side. use only 3 or 4.
%
% Example: localMeanMask(img, 4, Mask); 
%          Calcualted the Mean for the image img with n=4, hence no
%          overlapping. The value Mask is calculated from the function
%          maskDetect.m.
%
%authors: Kristian Sørensen, Eigil Lippert  and Simon Lupemba
%% 
% The variance will be given locally for each pixel in a matrix of dimensions 
% "dim" based on the input image. 
% difine masks as in lee article
Mask0 = [zeros(n*2+1,n),ones(n*2+1,n+1)];
Mask1 = ones(2*n+1,2*n+1);
for r= [2:2*n+1]
    Mask1(r,:) = [zeros(1,r-1),ones(1,2*n+2-r)];
end
Mask2 = [ones(n+1,n*2+1);zeros(n,n*2+1)];
Mask3 = fliplr(Mask1);
Mask4 = fliplr(Mask0);
Mask5 = flipud(Mask3);
Mask6 = flipud(Mask2);
Mask7 = fliplr(Mask5);

% intial values
dim = size(Im); %dimensions of input matrix.
V_sum = zeros(dim(1),dim(2)); %Empty array for mean values. 


for k = -n:n
        %Horizontal displacements:
        %moves element to the left, adds zeros on the left, if k is on the
        %left of the center array (-n).
        if k<0
        Vh = padarray(Im(:, 1:dim(2)-abs(k)),[0 abs(k)], 'pre');
        end
        
        %moves element to the right, adds zeros on the right
        if k>0
        Vh = padarray(Im(:, 1+k:dim(2)),[0 k], 'post');
        end
        
        %when reaching the center element - do nothing.
        if k == 0
            Vh = Im;
        end
        
        for i = -n:n
            %Vertical displacements:
            %moves elements up, adds zeros above
            if i < 0
            Vv = padarray(Vh(1:dim(1)-abs(i),:),[abs(i) 0], 'pre');
            end
            
            %moves elements down, adds zeros below
            if i > 0
            Vv = padarray(Vh(1+i:dim(1),:),[i 0], 'post');
            end
            
            %when reaching the center element - do nothing.
            if i == 0
                Vv = Vh;
            end
            %For each step, the variance is calculated for each pixel,
            % based on the current value, and the mean of that pixel.
            
            x = k+n+1;
            y = i+n+1;
            
            V_sum(Mask==0) = Mask0(y,x)/sum(sum(Mask0)) *(Vv(Mask==0)-localMeanMask(Mask==0)).^2 + V_sum(Mask==0);
            V_sum(Mask==1) = Mask1(y,x)/sum(sum(Mask1)) *(Vv(Mask==1)-localMeanMask(Mask==1)).^2 + V_sum(Mask==1);
            V_sum(Mask==2) = Mask2(y,x)/sum(sum(Mask2)) *(Vv(Mask==2)-localMeanMask(Mask==2)).^2 + V_sum(Mask==2);
            V_sum(Mask==3) = Mask3(y,x)/sum(sum(Mask3)) *(Vv(Mask==3)-localMeanMask(Mask==3)).^2 + V_sum(Mask==3);
            V_sum(Mask==4) = Mask4(y,x)/sum(sum(Mask4)) *(Vv(Mask==4)-localMeanMask(Mask==4)).^2 + V_sum(Mask==4);
            V_sum(Mask==5) = Mask5(y,x)/sum(sum(Mask5)) *(Vv(Mask==5)-localMeanMask(Mask==5)).^2 + V_sum(Mask==5);
            V_sum(Mask==6) = Mask6(y,x)/sum(sum(Mask6)) *(Vv(Mask==6)-localMeanMask(Mask==6)).^2 + V_sum(Mask==6);
            V_sum(Mask==7) = Mask7(y,x)/sum(sum(Mask7)) *(Vv(Mask==7)-localMeanMask(Mask==7)).^2 + V_sum(Mask==7);
            
            % If area is under threshold
            V_sum(Mask==-1)= 1/(2*n+1)^2 *(Vv(Mask==-1)-localMeanMask(Mask==-1)).^2 + V_sum(Mask==-1);
        end
end
V= V_sum;

