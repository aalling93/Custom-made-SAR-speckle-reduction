function FrostImages = FrostFilter(Im, n,a)
% The following function filters the image with the adaptive Frost filter.
%
% input: Image = the givin image one wish to filter
%           n  = Number of pixels on each side of the center pixel. 
% output:   a  = sensitivity
%
% Example: Frostfilter(img, 4, 2.2); 
%          filters the image 'img' vil a 9x9 kernal and a sensitivity of
%          2.2.
%
%authors: Kristian Sørensen, Eigil Lippert  and Simon Lupemba
%
dim = size(Im); %dimensions of input matrix.
deadpixel = 0;
%% Local values
E = localMean(Im, n);
V = localVariance(Im,E, n);
Speckle_index = V./E.^2; %local spekle index
clear V E % clear up memory

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
FrostImages = Im;
end