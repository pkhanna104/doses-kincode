function [mse_min, mse_max, mse_true] = calc_mse_w_error_randsamp(jt, med, std_err)

% Jt -- trial of as single joint 
% med -- median 
% std_err -- std of normally distributed errors to add 

assert(length(jt) == length(med))
N = length(jt); 
 
% Original MSE 
mse_true = sqrt(1/N.*sum((jt - med).^2)); 
mse_rand = []; 
for i = 1:1000
    % Add randomly sampled noise to the joint angle 
    jt_rand = jt + (std_err*randn(size(jt))); 

    mse_ = sqrt(1/N.*sum((jt_rand - med).^2)); 
    mse_rand = [mse_rand, mse_]; 
end

% Get std of errors: 
mse_std = std(mse_rand); 
mse_min = mse_true - mse_std; 
mse_max = mse_true + mse_std; 


% MSE equation 
%sqrt(1/length(trl_s2p).*sum(diff_.^2));