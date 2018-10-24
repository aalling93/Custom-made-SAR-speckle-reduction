function V = localVariance(Im,localMean, n);
% The variance will be given locally for each pixel in a matrix of dimensions 
% "dim" based on the input image. 
%
% input: Image = the givin image one wish to filter
%           n  = Number of pixels on each side of the center pixel. 
%    localMean = input from the function localMean.m 
% output: V = matrix with local variance values for each pixel
%
% Example: localVariance(img, localMean, 4); 
%          
%authors: Kristian Sørensen, Eigil Lippert  and Simon Lupemba
%
%%

dim = size(Im); %dimensions of input matrix.
N = (2*n+1)^2; %Number of pixels
V_sum = 0; %Empty array for variance values.

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
            V_sum = 1/N.*(Vv-localMean).^2+V_sum;
            
        end
end
V= V_sum;

