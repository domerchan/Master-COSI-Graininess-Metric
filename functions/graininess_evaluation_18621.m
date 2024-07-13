function dE00_RMS = graininess_evaluation_18621(file, cols, rows, pt1, pt2)
% reimplementation of the function my_graininess_evaluation.m by Andreas
% Kraushaar (2004-07-23)to evaluate graininess according to ISO/TS 18621-22
%
% Function Inputs:
%           file:   Path to the CIELab image at 600 spi
%           cols:   Number of columns in the color patches
%           rows:   Number of rows in the color patches 
%           pt1:    coordinates [x,y] of upper left patch
%           pt2:    coordinates [x,y] of bottom right patch
%
% Dialog Inputs:   
%           x_tol:  tolerance for x-values
%           y_tol:  tolerance for y-values
%           is_random:  eigther o or 1 depending wheather you want to
%           speciy a rectangle or individual points
%
% Outputs:  dE00_RMS: average of DeltaE of each patch
%
% Examples:
%   dE00_RMS = graininess_evaluation_24790()
%   dE00_RMS = graininess_evaluation_24790(file,1,7,[],[])
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% By: 
% Doménica Alejandra Merchán García
% 09-04-2024; last modified: 12-07-2024 
%--------------------------------------------------------------------------
if nargin < 4
    [filename pathname]  = uigetfile({'*.tif'},'CIELAB-Bild eingeben');
    bild_raw = imread([pathname,filename]);
    
    image_ref_info     = imfinfo(fullfile(pathname, filename));
    image_x_resol      = image_ref_info.XResolution;
    image_y_resol      = image_ref_info.YResolution;
    wi = image_ref_info.Width;
    he = image_ref_info.Height;
    
    def       = {'40','600','29','29','30','7.5','0'};
    
    prompt    = {'Enter viewing distance in cm','Enter resolution of scanned image in dpi',...
        'horizontal pixel tolerance','horizontal vertical tolerance','Spatial filterung CIEL* (cy/deg)','Spatial filterung CIEab* (cy/deg)','Random (1) or rectangular grid (0)?'};
    dlg_title = 'Graininess Evaluation';
    answer    = inputdlg(prompt,dlg_title,1,def);
    viewing_dist = str2double(char(answer(1)));
    resolution   = str2double(char(answer(2)));
    x_tol        = str2double(char(answer(3)));
    y_tol        = str2double(char(answer(4)));
    CIEL_cy_deg  = str2double(char(answer(5)));
    CIEab_cy_deg = str2double(char(answer(6)));
    is_random    = str2double(char(answer(7)));
    
    if resolution ~= image_x_resol
        errordlg('Image resolution doesnt match with the encoded file information.');
        return
    end
    
    if ~strcmp(image_ref_info.PhotometricInterpretation,'CIELab')
        errordlg('Only CIELAB images allowed - right now');
        return
    end

else
    bild_raw = imread(file);
    image_ref_info     = imfinfo(file);
    wi = image_ref_info.Width;
    he = image_ref_info.Height;

    viewing_dist = 40;
    resolution   = 600;
    x_tol        = 29;
    y_tol        = 29;
    CIEL_cy_deg  = 30;
    CIEab_cy_deg = 7.5;
    is_random = 0;
end

% Filtering CIEL channel with 1 degree and 3 for CIEa*b*
bild_L    = my_Spatial_Filter(bild_raw,resolution,viewing_dist,[1],30/CIEL_cy_deg,0); % 1° correspond to 30 cycles / degree
bild_ab   = my_Spatial_Filter(bild_raw,resolution,viewing_dist,[2 3],30/CIEab_cy_deg,0);
bild(:,:,1)   = bild_L(:,:,1);
bild(:,:,2:3) = bild_ab(:,:,2:3);

if  is_random == 1
    [x,y,~] = impixel(applycform(bild,makecform('lab2srgb')));
    dE00_RMS = zeros(1,length(x));
    for i = 1:length(x)
        L(i) = std2(bild(y(i)-y_tol:y(i)+y_tol,x(i)-x_tol:x(i)+x_tol,1));
        a(i) = std2(bild(y(i)-y_tol:y(i)+y_tol,x(i)-x_tol:x(i)+x_tol,2));
        b(i) = std2(bild(y(i)-y_tol:y(i)+y_tol,x(i)-x_tol:x(i)+x_tol,3));
        
        % Evaluation
        current_area   = bild(y(i)-y_tol:y(i)+y_tol,x(i)-x_tol:x(i)+x_tol,:);
        [m,n,~] = size(current_area);
        CIELAB_mean    = [mean2(current_area(:,:,1)) mean2(current_area(:,:,2)) mean2(current_area(:,:,3))];
        dE00           = my_DeltaE_00(repmat(CIELAB_mean,[m*n 1]),reshape(current_area,[m*n 3]));
        dE00_RMS(i)  = sqrt(1/length(dE00) * sum(dE00.^2));
        % next line for debugging only
        bild(y(i)-y_tol:y(i)+y_tol,x(i)-x_tol:x(i)+x_tol,1) = 100;
    end
else
    if nargin < 4
        prompt    = {'Anzahl Felder//Columns X: ', 'Anzahl Felder/Rows Y: '};
        def       = {'49','33'};
        dlg_title = 'Please type in target patches';
        answer    = inputdlg(prompt,dlg_title,1,def);
        x_feld    = str2num(char(answer(1)));
        y_feld    = str2num(char(answer(2)));
        close all

        [x,y,~] = impixel(applycform(bild,makecform('lab2srgb')));
        close;
    
        xul=x(1); yul=y(1); % upper left
        xbr=x(2); ybr=y(2); % button rigth
    else
        x_feld    = cols;
        y_feld    = rows;
        xul=pt1(1); yul=pt1(2); % upper left
        xbr=pt2(1); ybr=pt2(2); % button rigth
    end

    if x_feld==1;hor_step=0;else;hor_step=(xbr - xul)/(x_feld -1);end
    if y_feld==1;ver_step=0;else;ver_step=(ybr - yul)/(y_feld -1);end
    
    % Check for matrix exceeding
    if  or(xul < x_tol,yul < y_tol)
        errordlg('Pixeltolerance are out of image matrix. Check central values and choose smaller pixel tol.');
        return
    elseif or((xbr + x_tol) > wi,(ybr + y_tol) > he)
        errordlg('Pixeltolerance are out of image matrix. Check central values and choose smaller pixel tol.');
        return
    end
    
    count = 1;
    for zeile = 1:y_feld
        for patch = 1:x_feld
            x_coord = round(xul + (patch-1)*hor_step);
            y_coord = round(yul + (zeile - 1)*ver_step);
            current_area = bild(y_coord-y_tol:y_coord+y_tol,x_coord-x_tol:x_coord+x_tol,:);
            [m,n,~] = size(current_area);
            CIELAB_mean(count,:)    = [mean2(current_area(:,:,1)) mean2(current_area(:,:,2)) mean2(current_area(:,:,3))];
            dE00           = my_DeltaE_00(repmat(CIELAB_mean(count,:),[m*n 1]),reshape(current_area,[m*n 3]));
            dE00_RMS(count)  = sqrt(1/length(dE00) * sum(dE00.^2));
            bild(y_coord-y_tol:y_coord+y_tol,x_coord-x_tol:x_coord+x_tol,1:3) = 100;
            count = count +1;
        end
    end
end
%close all;
%figure
%imshow(applycform(bild,makecform('lab2srgb')));