function [g, roi, Y] = graininess_evaluation_24790(file,x,y)
% function graininess_evaluation_24790 implements the graininess metric 
% defined in ISO/IEC 24790 (2017) based on a colored print scanned at 1200 
% dpi.
%
% Function Inputs:
%           file:    Path to the RGB image at 1200 dpi
%           x:       Center of the ROI x coordinate 
%           y:       Center of the ROI y coordinate
%
% Dialog Inputs:
%           roi_he:  Height in pixels of the region of interest (600px min)
%           roi_wi:  Width in pixels of the region of interest (600px min)
%           h_tiles: Number of tiles in columns (9 tiles min)
%           v_tiles: Number of tiles in rows (9 tiles min)
%           tile_he: Height in pixels of the tiles (60px min)
%           tile_wi: Width in pixels of the tiles (60px min)
%
% Outputs:  g:      graininess score for the selected image 
%           roi:    region of interest being evaluated 
%           Y:      ROI converted to CIE Y
%
% Examples:
%   [g, roi, Y] = graininess_evaluation_24790()
%   [g, roi, Y] = graininess_evaluation_24790(file,3500,500)
%   [g, roi, Y] = graininess_evaluation_24790(file,3500,1300) 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% By: 
% Doménica Alejandra Merchán García
% 09-04-2024; last modified: 12-07-2024 
%--------------------------------------------------------------------------
if nargin < 3

    [filename pathname]  = uigetfile({'*.tif'},'Select RGB Image at 1200 dpi');
    raw = imread([pathname,filename]);
    
    image_ref_info     = imfinfo(fullfile(pathname, filename));
    image_x_resol      = image_ref_info.XResolution;
    wi = image_ref_info.Width;
    he = image_ref_info.Height;
    
    if 1200 ~= image_x_resol
        errordlg(['Resolution needed is 1200 ppi. Selected image resolution' ...
            ' does not match the requirement.']);
        return
    end

    ok = 'OK';  
    while strcmp(ok,'OK')
        def       = {'600','600','9','9','60','60'};
        prompt    = {'Enter ROI height in pixels (600 minimum)',...
            'Enter ROI width in pixels (600 minimum)',...
            'Enter number of horizontal tiles (9 minimum)',...
            'Enter number of vertical tiles (9 minimum)',...
            'Enter tile height in pixels (60 minimum)',...
            'Enter tile width in pixels (60 minimum)'};
        dlg_title = '24790 Graininess Evaluation';
        answer    = inputdlg(prompt,dlg_title,1,def);
        roi_he    = str2double(char(answer(1)));
        roi_wi    = str2double(char(answer(2)));
        h_tiles   = str2double(char(answer(3)));
        v_tiles   = str2double(char(answer(4)));
        tile_he   = str2double(char(answer(5)));
        tile_wi   = str2double(char(answer(6)));
        
        if and(roi_he-60==v_tiles*tile_he,roi_wi-60==h_tiles*tile_wi)
            ok = '';
        else
            ok = questdlg(['ROI size does not match with the number of tiles' ...
                ' and tile size selected. Please re enter values. Consider' ...
                ' 30px margin for the ROI size.'],'ROI error','OK');
        end
    end

    h = 0;
    w = 0;
    if (-1)^roi_he > 0, h=1;end
    if (-1)^roi_wi > 0, w=1;end
    
    tol_he = floor(roi_he/2);
    tol_wi = floor(roi_wi/2);
    ok = 'OK';   
    while or(strcmp(ok,'OK'),strcmp(ok,'NO, reselect'))
        [x y fool] = impixel(raw);
        close;
        x=x(1); y=y(1);
        
        if or((x+tol_wi)>wi,(y+tol_he)>he)
            ok = questdlg(['Selected ROI out of image matrix. Select new' ...
                ' center'],'ROI error','OK');
        elseif or(x<tol_wi,y<tol_he)
            ok = questdlg(['Selected ROI out of image matrix. Select new' ...
                ' center'],'ROI error','OK');
        else
            roi = raw;
            roi(y-tol_he+h:y+tol_he,x-tol_wi+w:x+tol_wi,:) = 100;
            
            figure();
            imshow(roi);
            ok = questdlg('Is ROI selection OK?','ROI selection','YES', ...
                'NO, reselect','NO');
            close;
        end
    end
else
    raw = imread(file);
    tol_he = 300; tol_wi = 300;
    h_tiles = 9; v_tiles = 9;
    tile_he = 60; tile_wi = 60;
    h = 1; w = 1;
end
%% Metric Implementation

% b) Get 600px ROI from file
roi = raw(y-tol_he+h:y+tol_he,x-tol_wi+w:x+tol_wi,:);

% c) Convert to CIE Y(x,y)
Y = 0.2126 * roi(:,:,1) + 0.7152 * roi(:,:,2) + 0.0722 * roi(:,:,3);

% d) Apply wavelet transform (Daubechies wavelets of order 16) with 6
% wavelet levels
n = 6;
[c,s] = wavedec2(Y, n, 'db16');

% e) Zero detail components to wavelet scale levels 2,3,4, and 5
lvl5  = s(1,1)*s(1,2)+1;
lvl2_ = sum(s(2:5,1).*s(2:5,2)*3)+s(1,1)*s(1,2);
c(lvl5:lvl2_) = 0;

% f) Zero the the level 0
lvl0  = sum(s(2:6,1).*s(2:6,2)*3)+s(1,1)*s(1,2)+1;
lvl0_ = sum(s(2:7,1).*s(2:7,2)*3)+s(1,1)*s(1,2);
c(lvl0:lvl0_) = 0;

% g) Apply the inverse wavelet transform to get the filtered image
Y = waverec2(c,s,'db16');

% h) Crop the filtered image, removing 30 pixels from each side
Y = Y(31:end-30,31:end-30);

% i) Divide the image into non-overlapped tiles of uniform size.
% j) compute the reflectance variance v_i_j of each tile
count = 1;
v = zeros(1,h_tiles*v_tiles);
for i = 0:v_tiles-1
    for j = 0:h_tiles-1
        patch = Y(i*tile_he+1:i*tile_he+tile_he,j*tile_wi+w:j*tile_wi+tile_wi);
        [m,n] = size(patch);
        patch_mean = mean2(patch);
        v(count) = sum((patch-patch_mean).^2,'all')/(n*m-1);
        count = count +1;
    end
end

%k) Compute the graininess metric as the square root of the average of all
%tiles' variances 
g = sqrt(sum(v)/length(v));