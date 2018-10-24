function edge = gammaEdge(Image, deadpixel)
% The gammaEdge function takes af image as input in order to detect
% itsedges. This is done with a kernel.
%
% input: Image = the givin image one wish to perform the gamme operator on
%   deadpixel  = giving the values on the edges on the original image a
%   value
% output:   edge = gamme operated iamge.
%
% Example: gammaEdge(img, 'on'); 
%          performs gamme on img. 'on' gives the operator a deadpixel value of 0. 
%%authors: Kristian S�rensen, Eigil Lippert  and Simon Lupemba
%
%% 
%
% Handling variable input 'deadpixel'. If no input, it's interpreted as
% 'off' and set to zero (since assigning to 'off' doesn't work)
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
        Eh = padarray(Image(:, 1:dimensions(2)-abs(k)),[0 abs(k)], 'pre');
        end
        
        %moves element to the right, adds zeros on the right
        if k>0
        Eh = padarray(Image(:, 1+k:dimensions(2)),[0 k], 'post');
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
                    Ev = Eh;
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

Yleft(Yleft<0.01)=0.01; % The low values are set to 0.01 så we don't divde by zero or anything near.
Yright(Yright<0.01)=0.01;
edgeY = Yleft./Yright;
edgeY(edgeY<1) = 1./edgeY(edgeY<1) ;
edgeY = edgeY -1; % set so noEdge=0
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
            Eh = Image;
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
                Ev = padarray(Eh(1+i:dimensions(1),:),[i 0], 'post');
                Xbottom = Ev + Xbottom;
            end
        end
end
Xtop(Xtop<0.01) = 0.01;% The low values are set to 0.01 så we don't divde by zero or anything near.
Xbottom(Xbottom<0.01) = 0.01;
edgeX = Xtop./Xbottom;
edgeX(edgeX<1) = 1./edgeX(edgeX<1) ;
edgeX = edgeX -1; % set so noEdge=0
clear Xtop Xbottom Ev Eh

%% Finalization of edges:

edgetotal = sqrt((edgeY).^2 + (edgeX).^2);

if deadpixel == 'on';
    edgetotal(dimensions(1)-5+1:dimensions(1),:) = 0;
    edgetotal(1:5,:) = 0;
    edgetotal(:,dimensions(2)-5+1:dimensions(2)) = 0;
    edgetotal(:,1:5) = 0;
end

edge = edgetotal;