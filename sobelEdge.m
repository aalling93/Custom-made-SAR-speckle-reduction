%% Sobel Edges detector
function edge = sobelEdge(Image, deadpixel)
%% Initialization
% Handling variable input 'deadpixel'. If no input, it's interpreted as
% 'off' and set to zero (since assigning to 'off' doesn't work)
%authors: Kristian Sørensen, Eigil Lippert  and Simon Lupemba
if nargin == 1
    deadpixel = 0;
end

n=1; %size of kernel
dimensions = size(Image); %dimensions of input matrix.
edgeY = 0; %Empty array for mean values. 
Yright = 0;
Yleft = 0;

edgeX = 0;
Xtop = 0;
Xbottom = 0;
%% Determins edges in Y-direction
for k = -n:n
        %Horizontal displacements:
        %moves element to the left, adds zeros on the left, if k is on the
        %left of the center array (-n).
        if k<0
        Eh = pada0rray(Image(:, 1:dimensions(2)-abs(k)),[0 abs(k)], 'pre');
        end
        
        %moves element to the right, adds zeros on the right
        if k>0
        Eh = -padarray(Image(:, 1+k:dimensions(2)),[0 k], 'post');
        end
        
        %when reaching the center element - do nothing.
        if k ~= 0
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
                    Ev = 2 * Eh;
                end
                
                if k < 0
                    Yleft = Ev + Yleft;
                end
                if k > 0
                    Yright = Ev + Yright;
                end
            end
        end
end

edgeY = Yleft./Yright;
edgeY(abs(Yleft)<0.01 | abs(Yright)<0.01) = 1; %Skal det sættes til 0.1 istedet?
edgeY(edgeY<1) = 1./edgeY(edgeY<1) ;

clear Yleft Yright Ev Eh

%% Determines edges in X-direction
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
            Eh = 2 * Image;
        end
        
        for i = -n:n
            %Vertical displacements:
            %moves elements up, adds zeros above. Then adds to top
            %variable
            if i < 0
                Ev = padarray(Eh(1:dimensions(1)-abs(i),:),[abs(i) 0], 'pre');
                Xtop = Ev + Xtop;
            end
            
            %moves elements down, adds zeros below. Then adds to bottom
            %variable
            if i > 0
                Ev = -padarray(Eh(1+i:dimensions(1),:),[i 0], 'post');
                Xbottom = Ev + Xbottom;
            end
        end
end

edgeX = Xtop./Xbottom;
edgeX(abs(Xtop)<0.01 | abs(Xbottom)<0.01) = 1; %sættes til 0.1?
edgeX(edgeX<1) = 1./edgeX(edgeX<1) ;

clear Xtop Xbottom Ev Eh

%% Finalization of edges:

edgetotal = sqrt((edgeY-1).^2 + (edgeX-1).^2)./25;

if deadpixel == 'on';
    edgetotal(dimensions(1)-n+1:dimensions(1),:) = 0;
    edgetotal(1:n,:) = 0;
    edgetotal(:,dimensions(2)-n+1:dimensions(2)) = 0;
    edgetotal(:,1:n) = 0;
end

edge = edgetotal;