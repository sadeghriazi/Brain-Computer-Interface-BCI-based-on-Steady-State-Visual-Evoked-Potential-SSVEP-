function [ position ] = PositionSet( nFlashers, rect )


%%  calculate numbers of screen divisions for stimulus presentation
% for example we divide screen to 4 for 3 or 4 stimuli, to 6 for 5 or 6
% stimuli, to 9 for 7,8,9 stimuli, to 12 for 10,11,or 12 stimuli, ...

dim = floor(sqrt(nFlashers)); 
if nFlashers == dim^2
    dim1 = dim;
    dim2 = dim;
    stat = 1; % we later will use the variable stat for removing those positions that we don't need
elseif nFlashers <= dim^2 + dim
    dim1 = dim + 1;
    dim2 = dim;
    stat = 2;
else 
    dim1 = dim + 1;
    dim2 = dim + 1;
    stat = 3;
end

step1 = rect(3) / (1*dim1); % step1&2 determine divisions limits (lengths in each dimension)
step2 = rect(4) / dim2;
offset1 = 0.1 * step1; % by changing offset1&2 we can determine size of stumuli
offset2 = 0.1 * step2;

t = 1;
for j = 1 : dim2
    for i = 1 : dim1
        % this position set is for 4, 6, 9, 12, 16, ... stimulus arrays.
        % later, we eliminate some of this positions according to number of
        % stimuli that we need
        position_full(t,:) = [(i - 1)*step1+offset1 (j - 1)*step2+offset2 i*step1-offset1 j*step2-offset2];
        t = t + 1;
    end
end

switch stat % in this step we remove positions we don't need
    case 1
        position = position_full;
    case 2
        res = (dim^2 + dim) - nFlashers;
        position = position_full(1 : (end - res), :);
    case 3
        res = (dim + 1)^2 - nFlashers;
        position = position_full(1 : (end - res), :);
end


end

        



