function filteredIm=my_Spatial_Filter(inputIm,resolutionDPI, viewingDistance_cm, channels, vis_angle, is_view)
% my_Spatial_Filter - functions computes the 2D Gausian filter based on a
% lecture from Prof. Hersch (EPFL)
%
% Syntax:  filteredIm = my_Spatial_Filter(inputIm,resolutionDPI, viewingDistance_cm, channels, is_view)
%
% Inputs:
%   inputIm             - string containing the link to the input image
%   resolutionDPI       - resolution of the input image
%   viewingDistance_cm  - viewing distance
%   channels            - channels to be filtered (e.g. only the CIEL*)
%   vis_angle           - visual angle (different for lightness and chroma)
%   is_view             - boolean value for addition imshow
%
% Outputs:
%    filteredIm - the filtered image
%
% Example:
%    filteredIm = my_Spatial_Filter('bild.tif',300,40,[1 2 3],1)
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also:

% Author: Andreas Kraushaar
% Fogra
% email: kraushaar@fogra.org
% Website: http://www.fogra.org
% June 2011; Last revision: 23-June-2011

%------------- BEGIN CODE --------------

%% Check consistency of inputs
if nargin == 3
    channels = 1;
    is_view  = 0;
end

if nargin == 4
    is_view  = 0;
end

if ischar(inputIm)
    bild_info = imfinfo(inputIm);
    nb_planes = bild_info.SamplesPerPixel;
    colortyp  = bild_info.ColorType;
    if bild_info.XResolution == resolutionDPI
        bild = imread(inputIm);
        if strmatch(bild_info.ColorType,'CIELab')
            bild = lab2double(bild);
        else
            bild = double(bild)./255;
        end
        
    else
        errordlg('Input resolution doesnt match the image encoded information :-( ');
        return
    end
else
    [a b c] = size(inputIm);
    if c ~= 3
        errordlg('Please provide a 3 channel image');
    end
    bild = lab2double(inputIm);
    [m n nb_planes] = size(bild);
    colortyp  = 'CIELab';
end



%% Initialize
filteredIm = zeros(size(bild));

%%  computes the convolution kernel derived from the human vision modulation
% approximates human transfer function by Gaussian Exp(-pi q^2)
% with cut-off frequency of 30 cycles per degrees unity corresponds to 30 cycles per degree

% number of pixels per 1/30 degree angle
% start blurring as of 40 cm
number_PixelsPer1over30degree = viewingDistance_cm/2.54*2*pi*(1/360)*(vis_angle/30)*resolutionDPI;

% 2D Gaussian with volume normalisation
sigm=1/sqrt(2*pi); % = 0.3989

% Produce a combination mesh and contour plot of the surface:
% Surface size ranges from -2 to + 2, i.e. -5 sigma to 5 sigma;
[X,Y] = meshgrid(-2:1/number_PixelsPer1over30degree:2); % each increment corresponds to one pixel
% normalize by surface, unity is given in nb of pixels example: 8.72*8.72
unitSurfacePixels = number_PixelsPer1over30degree^2; %for example 8.72*8.72;
Z = HVSconv(X,Y,sigm)/unitSurfacePixels;

%% Apply filter for the selected planes
for chan = 1:nb_planes 
    if ismember(chan,channels)
        filteredIm(:,:,chan) = conv2((bild(:,:,chan)),Z,'same');
        %filteredIm(:,:,chan) = filteredIm(:,:,chan).*255;
    else
        filteredIm(:,:,chan) = bild(:,:,chan);
    end
end

%% Show images
if is_view == 1
    surf(Z);
    if strcmp(colortyp,'CIELab')
        c = makecform('lab2srgb');
        figure
        imshow(applycform(bild,c)); title('Unfiltered');
        figure
        imshow(applycform(filteredIm,c)); title('Filtered');
    elseif strcmp(colortyp,'truecolor')
        imshow(bild);
        figure
        imshow(filteredIm);
    end
end



function z=HVSconv(x, y,sigma)
% defines standard Gaussian convolution kernel
z=(1/(sigma^2*2*pi))*exp(-(1/(2*sigma^2))*(x.^2+y.^2));
