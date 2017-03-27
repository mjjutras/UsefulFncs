function y = timebox(x, nhold);
%TIMEBOX - Given an input sequence, returns a binary output where runs of
%ones are regions of signal s.t. sgn(x) >0, and the length of the
%continuous samples for this criteria are greater than nhold.
%
%   Written:  09 May 06 / Otis Smart
%   Modified: 10 May 06 / Otis Smart
%
%--------------------------------------------------------------------------
%USAGE
%--------------------------------------------------------------------------
%       y = timebox(x, nhold);
%
%       y       -   output indicator signal (binary)
%       x       -   input vector
%       nhold   -   number of consecutive samples with sgn(x) > 0 for on
%
%--------------------------------------------------------------------------
%NOTES
%--------------------------------------------------------------------------
%1. Appropriate time-boxing considers that a "run" of ones (sgn(x) > 0) can
%occur in a number "nhold" of sample points before and after a time
%reference point.
%

%--------------------------------------------------------------------------
%PERFROM TIME-BOXING (TIME-THRESHOLDING)
%--------------------------------------------------------------------------
%initialize the time-boxed signal
y = zeros(size(x));
%pad the input
z = [zeros(nhold-1,1);x(:);zeros(nhold-1,1)];
%initialize starting (reference) point for the data to time-box
nn = nhold;
%initialize starting point for the result of the time-boxing
ii = 1;
%time-box the padded input
while ii<=length(y)
    if sum(z(nn:nn+nhold-1))==nhold;
        %updated the time-boxed signal: forward check success
        y(ii:ii+nhold-1) = 1;
        %update the reference point for the result of the time-boxing
        ii = ii+nhold;
        %update starting (reference) point for the data to time-box
        nn = nn+nhold;
    elseif sum(z(nn-nhold+1:nn))==nhold
        %updated the time-boxed signal: backward check success
        y(ii) = 1;
        %update the reference point for the result of the time-boxing
        ii = ii+1;
        %update starting (reference) point for the data to time-box
        nn = nn+1;
    else
        y(ii) = 0;
        %update the reference point for the result of the time-boxing
        ii = ii+1;
        %update starting (reference) point for the data to time-box
        nn = nn+1;
    end
end