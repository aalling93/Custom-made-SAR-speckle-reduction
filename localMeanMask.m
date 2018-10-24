function E = localMeanMask(Image, n, Mask)
% The following function calculates the average of a mask. This is used as
% input in the Lee filter. This function should always be used with the
% function maskDetect.m.
%
% input: Image = the givin image one wish to filter
%           n  = Number of pixels on each side of the center pixel. Only 3 and 4 are valid options 
%        Mask = gives the function a mask as computated in function
%        maskDetect.m
% output: E = Mask Mean value.
%
% Example: localMeanMask(img, 4, Mask); 
%          Calcualted the Mean for the image img with n=4, hence no
%          overlapping. The value Mask is calculated from the function
%          maskDetect.m.
%
%authors: Kristian Sørensen, Eigil Lippert  and Simon Lupemba
%% 
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
dimensions = size(Image); %dimensions of input matrix.
E_sum = zeros(dimensions(1),dimensions(2)); %Empty array for mean values. 

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
            x = k+n+1;
            y = i+n+1;
            
            E_sum(Mask==0) = Mask0(y,x)/sum(sum(Mask0))*Ev(Mask==0)+ E_sum(Mask==0);
            E_sum(Mask==1) = Mask1(y,x)/sum(sum(Mask1))*Ev(Mask==1)+ E_sum(Mask==1);
            E_sum(Mask==2) = Mask2(y,x)/sum(sum(Mask2))*Ev(Mask==2)+ E_sum(Mask==2);
            E_sum(Mask==3) = Mask3(y,x)/sum(sum(Mask3))*Ev(Mask==3)+ E_sum(Mask==3);
            E_sum(Mask==4) = Mask4(y,x)/sum(sum(Mask4))*Ev(Mask==4)+ E_sum(Mask==4);
            E_sum(Mask==5) = Mask5(y,x)/sum(sum(Mask5))*Ev(Mask==5)+ E_sum(Mask==5);
            E_sum(Mask==6) = Mask6(y,x)/sum(sum(Mask6))*Ev(Mask==6)+ E_sum(Mask==6);
            E_sum(Mask==7) = Mask7(y,x)/sum(sum(Mask7))*Ev(Mask==7)+ E_sum(Mask==7);
            
            % If area is under threshold
            E_sum(Mask==-1)= 1/(2*n+1)^2 *Ev(Mask==-1)+ E_sum(Mask==-1);
        end
end


E = E_sum;