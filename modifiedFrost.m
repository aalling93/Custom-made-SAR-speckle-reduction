function modFrostImages = modifiedFrost(Im, n, a)
%modifiedFrost(Im,n,a) 
%The modifiedFrost function filtes an image with the modified Frost filter.
%It works much like the frost filter, but uses the CFAR from the function
%CFAR in order to filter the image.
%
% input: Im = the givin image one wish to filter
%        n  =  Number of pixels on each side of the center pixel. use 3 or 4. 
%        a = sensitivity
%   
% output:   modFrostImages = Modified Frost fitlered image.
%
% Example:  modifiedFrost(img, 4, 5)
%         
%
%authors: Kristian Sørensen, Eigil Lippert  and Simon Lupemba

%%
dim = size(Im); %dimensions of input matrix.
deadpixel = 0;
%% Local values
E = localMean(Im, n);
V = localVariance(Im,E, n);
VMR = V./E.^2;
CFAR_mfrost = CFAR(VMR);
threshold = 1/mean(CFAR_mfrost);
clear E V
%% Modified speckle index
Speckle_index = VMR -1/threshold ; %spekle index
Speckle_index(Speckle_index<0) = 0;
clear VMR
%% Frost filter code
A_sum = 0;
weight = 0;
for k = -n:n
        %Horizontal displacements:
        %moves element to the left, adds zeros on the left, if k is on the
        %left of the center array (-n).
        if k<0
        Ah = padarray(Im(:, 1:dim(2)-abs(k)),[0 abs(k)], 'pre');
        end
        
        %moves element to the right, adds zeros on the right
        if k>0
        Ah = padarray(Im(:, 1+k:dim(2)),[0 k], 'post');
        end
        
        %when reaching the center element - do nothing.
        if k == 0
            Ah = Im;
        end
        
        for i = -n:n
            %Vertical displacements:
            %moves elements up, adds zeros above
            if i < 0
            Av = padarray(Ah(1:dim(1)-abs(i),:),[abs(i) 0], 'pre');
            end
            
            %moves elements down, adds zeros below
            if i > 0
            Av = padarray(Ah(1+i:dim(1),:),[i 0], 'post');
            end
            
            %when reaching the center element - do nothing.
            if i == 0
                Av = Ah;
            end
            %For each step, the variance is calculated for each pixel,
            % based on the current value, and the mean of that pixel.
            A_sum = Av.*exp(-Speckle_index.*a.*sqrt(k^2+i^2)) + A_sum;
            weight = weight + exp(-Speckle_index.*a.*sqrt(k^2+i^2));
            
        end
end
clear Speckle_index Av Ah % clear up memory
%% Creates the new picture
Im = A_sum./weight;
clear A_sum weight % clear up memory
%assing dead pixels 
Im (dim(1)-n+1:dim(1),:) = deadpixel;
Im (1:n,:) = deadpixel;
Im (:,dim(2)-n+1:dim(2)) = deadpixel;
Im (:,1:n) = deadpixel;
%% Return Filtered images
modFrostImages = Im;