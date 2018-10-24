function E = localMean(Image, n, deadpixel);
% The following function calculates the local average.
%
% input: Image = the givin image one wish to filter
%           n  = Number of pixels on each side of the center pixel. 
%    deadpixel = gives the image deadpixels
% output: E = matrix with local mean values for each pixel
%
% Example: localMean(img, 4, 'on'); 
%          filters the image 'img' vil a 9x9 kernal
%authors: Kristian Sørensen, Eigil Lippert  and Simon Lupemba
%

if nargin == 2
    deadpixel = 0;
end

dimensions = size(Image); %dimensions of input matrix.
N = (2*n+1)^2; %Number of pixels
deadpixel = 0; % Variable for removing edge pixels.
E_sum = 0; %Empty array for mean values. 

%For each iteration the array is moved one step in the given direction. For
%each iteration all the current mean are calculated, and added to E_sum.
%Iterations works its way from left to right in the array. 

for k = -n:n
        %Horizontal displacements:
        %moves element to the left, adds zeros on the left, if k is on the
        %left of the center array (-n).
        if k<0
        Eh = padarray(Image(:, 1:dimensions(2)-abs(k)),[0 abs(k)], 'pre');
        end
        
        %moves element to the right, adds zeros on the right
        if k>0
        Eh = padarray(Image(:, 1+k:dimensions(2)),[0 k], 'post');
        end
        
        %when reaching the center element - do nothing.
        if k == 0
            Eh = Image;
        end
        
        for i = -n:n
            %Vertical displacements:
            %moves elements up, adds zeros above
            if i < 0
            Ev = padarray(Eh(1:dimensions(1)-abs(i),:),[abs(i) 0], 'pre');
            end
            
            %moves elements down, adds zeros below
            if i > 0
            Ev = padarray(Eh(1+i:dimensions(1),:),[i 0], 'post');
            end
            
            %when reaching the center element - do nothing.
            if i == 0
                Ev = Eh;
            end
            %adds weights to E_sum
            E_sum = 1/N.*Ev+E_sum;
            
        end
end

if deadpixel == 'on';
    Image(dimensions(1)-n+1:dimensions(1),:) = 0;
    Image(1:n,:) = 0;
    Image(:,dimensions(2)-n+1:dimensions(2)) = 0;
    Image(:,1:n) = 0;
end

E = E_sum;