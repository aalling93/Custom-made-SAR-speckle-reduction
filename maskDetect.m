function Mask = maskDetect(Image, n, functionMode)
% mastDetect is a function wich compute a mask for pixels. This maks is
% used as input for the Lee filter.
%
% input: Image = the givin image one wish to filter
%           n  = Number of pixels on each side of the center pixel. Only 3 and 4 are valid options 
%        functionmode = type can be 'd' for difference or 'r' for ratio 
% 
% output:Mask = a interger value from 0 to 7. This is used as input in
% order to detect the type of edge on an image. 
%
% Example: maskDetect(img,4,'r');
%          
%
%authors: Kristian Sørensen, Eigil Lippert  and Simon Lupemba
%
% 
%% 
dimensions = size(Image);
[M11,M12,M13,M21,M22,M23, M31,M32,M33]= deal(0);
for k = -n:n
         %Horizontal displacements:
        %moves element to the left, adds zeros on the left, if k is on the
        %left of the center array (-n).
        if k < 0
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
            
            % assing the pixels to the corret box; The boxex are as
            % defiened by Lee in article
            if k <= -n+2
                if i <= -n+2
                    M11 = M11+Ev;
                end
                if  abs(i) <= 1
                    M21 = M21+Ev;
                end
                if i >= n-2
                    M31 = M31 +Ev;
                end
            end
                
            if abs(k) <= 1
                if i <= -n+2
                    M12 = M12+Ev;
                end
                if  abs(i) <= 1
                    M22 = M22+Ev;
                end
                if i >= n-2
                    M32 = M32 +Ev;
                end
            end
                
            if k >= n-2
                if i <= -n+2
                    M13 = M13+Ev;
                end
                if  abs(i) <= 1
                    M23 = M23+Ev;
                end
                if i >= n-2
                    M33 = M33 +Ev;
                end
            end
        end
end
clear Ev Eh

% Create array for masks
Mask = -ones(dimensions(1),dimensions(2));
%% Creates the matrix for the masks. Mask types are as in Lee's article

if functionMode == 'd' % difference
   % Assing mask based to each pixel based on wich direction has the maksimal differense
   Mask(abs(M23-M21) >= abs(M13-M31) & abs(M23-M21) >= abs(M12-M32) & abs(M23-M21) >= abs(M11-M33)) = 0;
   Mask(Mask==0 & abs(M23-M22) > abs(M21-M22)) = 4;
   Mask(abs(M13-M31) >= abs(M23-M21) & abs(M13-M31) >= abs(M12-M32) & abs(M13-M31) >= abs(M11-M33)) = 1;
   Mask(Mask==1 & abs(M13-M22) > abs(M31-M22)) = 5;
   Mask(abs(M12-M32) >= abs(M23-M21) & abs(M12-M32) >= abs(M13-M31) & abs(M12-M32) >= abs(M11-M33)) = 2;
   Mask(Mask==2 & abs(M12-M22)> abs(M32-M22)) = 6;
   Mask(abs(M11-M33) >= abs(M23-M21) & abs(M11-M33) >= abs(M13-M31) & abs(M11-M33) >= abs(M12-M32)) = 3;
   Mask(Mask==3 & abs(M11-M22)> abs(M33-M22)) = 7;
end  
if functionMode == 'r'
    % Makes sure i don't divide by zero
    M11(M11==0)=-1; M12(M12==0)=-1; M31(M13==0)=-1; 
    M21(M21==0)=-1; M22(M22==0)=-1; M23(M23==0)=-1;
    M31(M31==0)=-1; M32(M32==0)=-1; M33(M33==0)=-1;
    % Assing mask based to each pixel based on wich direction has the
    % maksimal ratio
    Mask(max(M23,M21)./min(M23,M21) >= max(M13,M31)./min(M13,M31) & max(M23,M21)./min(M23,M21) >= max(M12,M32)./min(M12,M32) & max(M23,M21)./min(M23,M21) >= max(M11,M33)./min(M11,M33) )  = 0;
    Mask(Mask==0 & max(M23,M22)./min(M23,M22) > max(M21,M22)./min(M21,M22)) = 4;
    Mask(max(M13,M31)./min(M13,M31) >= max(M23,M21)./min(M23,M21) & max(M13,M31)./min(M13,M31) >= max(M12,M32)./min(M12,M32) & max(M13,M31)./min(M13,M31) >= max(M11,M33)./min(M11,M33) )  = 1;
    Mask(Mask==1 & max(M13,M22)./min(M13,M22) > max(M31,M22)./min(M31,M22)) = 5;
    Mask(max(M12,M32)./min(M12,M32) >= max(M23,M21)./min(M23,M21) & max(M12,M32)./min(M12,M32) >= max(M13,M31)./min(M13,M31) & max(M12,M32)./min(M12,M32) >= max(M11,M33)./min(M11,M33) )  = 2;
    Mask(Mask==2 & max(M12,M22)./min(M12,M22) > max(M32,M22)./min(M32,M22)) = 6;
    Mask(max(M11,M33)./min(M11,M33) >= max(M23,M21)./min(M23,M21) & max(M11,M33)./min(M11,M33) >= max(M13,M31)./min(M13,M31) & max(M11,M33)./min(M11,M33) >= max(M12,M32)./min(M12,M32) )  = 3;
    Mask(Mask==3 & max(M11,M22)./min(M11,M22) > max(M33,M22)./min(M33,M22)) = 7;
end

end
