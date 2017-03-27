function [dense, inst] = density (c, cluster, window, type, r, group)
% density.m
% returns spike density arrays
%
% Syntax 1: [DENSE, INSTANCES] = DENSITY (COBJ, CLUSTER, WINDOW, TYPE, ROBJ, [GROUP])
% Syntax 2: [DENSE, INSTANCES] = DENSITY (SPMAT, WINDOW, TYPE)
% Syntax 3: [DENSE, INSTANCES] = DENSITY (FRATES, WINDOW, TYPE);
%
% where
% DENSE:     array of spike density values;
% INSTANCES: number of spike arrays retrieved from COBJ by the RULES criteria
%            i.e., the number of values included in the sum;
% COBJ:      the @cortex object;
% CLUSTER:   the spike number, as encoded in the CORTEX data file;
% SPMAT:     a spike matrix as returned by @cortex/spikematrix.m;
% FRATES:    a 1D vector of values to smooth;
% WINDOW:    window size in ms;
% TYPE:      either 'gauss' or 'boxcar';
% ROBJ:      one rule from a @rules object 
%            or the entire object, if GROUP is specified;
% GROUP:     the group to be analyzed (optional).
%
% The core code for this function is borrowed from Wael's smooth.m (thanks!)
% Last modified: 22 May 00

% 13 jun 99: can pass FRATES as argument
% 22 feb 00: last line of code fixed according to Andrew's suggestion
% 22 may 00: fixed a small bug: sparr = double (spmat);

switch nargin
case 6
   spmat = spikematrix (c, cluster, r, group);
case 5
   if sum(r.size)>1
      error ('multi-rule object passed using single-rule syntax');
   end
   spmat = spikematrix (c, cluster, r);
case 3
   spmat = c;
   type = window;
   window = cluster;
   if ndims(spmat)>2 | prod (size(window))>1 | ~isstr(type)
      error ('bad argument list');
   end
otherwise
   error ('wrong number of arguments');
end

% make sure the window is of even size
if rem (window, 2)
   window = window + 1;
end

halfwin = window/2;
[inst, spl] = size (spmat);

switch inst
case 0 % no instances: end here
   dense=[];
   return
case 1 % already averaged values assumed
   sparr = double (spmat);
otherwise % compute mean firing rates
   sparr = sum (spmat, 1)/inst*1000;
end

if strcmp (type, 'gauss')
   x = -halfwin:halfwin;
   kernel = exp(-x.^2/halfwin^2);
elseif strcmp (type, 'boxcar')
   kernel = ones(window, 1);
else
   error ('type must be either ''gauss'' or ''boxcar''');
end
kernel = kernel/sum(kernel);

padded (halfwin+1 : spl+halfwin) = sparr;
padded (1:halfwin) = ones(halfwin, 1) * mean (sparr(1:halfwin));
padded (length(padded)+1:length(padded)+halfwin) = ones(halfwin, 1) * mean (sparr(spl-halfwin:spl));

dense = conv(padded, kernel);
gap = halfwin + (length(kernel)-1)/2;
dense = dense(gap+1:length(dense)-gap);