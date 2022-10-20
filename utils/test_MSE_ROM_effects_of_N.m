% Test effects of MSE/ROM as N increases; 
% 10 random trials w/ some structure
data = randn(20, 10) + repmat(linspace(0, 5, 20)', [1, 10]); 
T = 1:20; 

% Interpolate to different levels 
Ns = 20:10:600; 
ROMs = []; 
MSEs = []; 


for N = Ns
    
    % Interpolate data 
    T_new = linspace(1, 20, N); 
    data_new = []; 

    for trl = 1:10
        dnew = interp1(T,data(:, trl), T_new); 
        data_new = [data_new dnew']; % add new column
    end

    % Size in dimension 1 wont match by design!
    assert(size(data, 2) == size(data_new, 2))

    % ROM and MSE on new data 
    rom = median(std(data_new,0,1)); 
    ROMs = [ROMs rom]; 

    % MSE 
    med = median(data_new, 2); 
    med_rep = repmat(med, [1, 10]); 
    assert(size(med_rep, 1) == size(data_new, 1))
    assert(size(med_rep, 2) == size(data_new, 2))
    
    mse = median(sum((med_rep - data_new).^2, 1)./N); 
    MSEs = [MSEs mse]; 

end

figure;
subplot(2, 1, 1); hold all; 
plot(Ns, ROMs, 'k.-')
ylabel('ROM')
xlabel('Number of pts in interpolation')
subplot(2, 1, 2); hold all; 
plot(Ns, MSEs, 'k.-')
ylabel('MSE')
xlabel('Number of pts in interpolation')

pat_unaff = [37.5, 145, 29,  29, 161.5, 131.5]; 
pat_aff   = [58.5, 201, 119, 44, 176.5, 515]; 
ctrls = [278, 310, 364, 381, 416, 386, 525, 576]; 


subplot(2, 1, 1); 
plot(pat_aff, mean(ROMs)*ones(length(pat_aff), 1), 'r.', 'MarkerSize', 15)
plot(pat_unaff, mean(ROMs)*ones(length(pat_unaff), 1), 'b.', 'MarkerSize', 15)
plot(ctrls, mean(ROMs)*ones(length(ctrls), 1), 'k.', 'MarkerSize', 15)

subplot(2, 1, 2); 
plot(pat_aff, mean(MSEs)*ones(length(pat_aff), 1), 'r.', 'MarkerSize', 15)
plot(pat_unaff, mean(MSEs)*ones(length(pat_unaff), 1), 'b.', 'MarkerSize', 15)
plot(ctrls, mean(MSEs)*ones(length(ctrls), 1), 'k.', 'MarkerSize', 15)



