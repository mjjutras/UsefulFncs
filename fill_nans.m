function A = fill_nans(A)
% Replaces the nans in each column with previous non-nan values.

for ii = find(~isnan(A(1,:)))
    I = A(:,ii);
    subind = ii+1:find(~isnan(A(1,ii+1:end)),1,'first')+ii-1;
    A(:,subind) = repmat(I,1,length(subind));
end

end