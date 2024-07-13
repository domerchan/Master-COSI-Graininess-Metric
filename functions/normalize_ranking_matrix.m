function N = normalize_ranking_matrix(D)
% function normalize_ranking_matrix normalizes the raw rating matrix D of
% J observations of n samples
%
% Inputs:   D:  Raw rating matrix
%
% Outputs:  N:  Normalized rating matrix in an interval from 0 to 10
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% By: 
% Doménica Alejandra Merchán García
% 17-06-2024; last modified: 12-07-2024 
%--------------------------------------------------------------------------

M = mean(D,2);
S = std(D,1,2);
A = zeros(size(D));
J = size(D,1);

% Scaled matrix A
for i = 1:J
    A(i,:) = (D(i,:)-M(i))/S(i);
end

% Normalized matrix N
mi = min(A,[],'all');
ma = max(A,[],'all');
N = ((A - mi)/(ma - mi))*10;