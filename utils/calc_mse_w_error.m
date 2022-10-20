function [mse_min, mse_max, mse] = calc_mse_w_error(jt, med, std_err)

assert(length(jt) == length(med))
N = length(jt); 

mse_ = 0;
mse_min_ = 0; 
mse_max_ = 0; 

for i = 1:N

    df = abs(jt(i) - med(i)); % difference from median 

    df1 = abs(jt(i) + std_err - med(i)); 
    df2 = abs(jt(i) - std_err - med(i)); 

    % True mse
    mse_ = mse_ + df.^2; 

    % Sort df1, df2, df; 
    opts = [df1, df2, df]; 
    [~, ix_sort] = sort(opts); % sorts in ascending order 

    mse_min_ = mse_min_ + opts(ix_sort(1)).^2; 
    mse_max_ = mse_max_ + opts(ix_sort(3)).^2; 
    
    % True mse
    mse_ = mse_ + df;
end

mse = sqrt(mse_ / N); 
mse_min = sqrt(mse_min_ / N); 
mse_max = sqrt(mse_max_ / N); 

assert(mse_min <= mse)
assert(mse <= mse_max)

%% MSE equation 
%sqrt(1/length(trl_s2p).*sum(diff_.^2));