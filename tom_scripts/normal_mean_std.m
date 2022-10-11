function [u_rom_norm_mean,u_rom_norm_2xstd,u_mse_norm_mean, u_mse_norm_2xstd] = normal_mean_std(mse_rom)

u_rom = mse_rom.u_rom; % rom calculated from start --> pinch on un-zscored data
u_mse = mse_rom.u_mse; % mse calculated from start --> pinch on z-scored data


C = nchoosek([1:10],5);
%bootstrap without replacement unaffect ROM!  -> used for determinng
%"normal datas
for m = 1:12 % for each joint
    
    % For each subselection:
    for k = 1:size(nchoosek([1:10],5),1) %1 to total # of possible permutations -> 252 here
        
        grp1 = C(k, :);
        grp2 = setdiff(1:10, grp1);
        
        u_mse_train = median(cell2mat(u_mse(grp1, m))); %produces a scalar
        u_mse_test =  median(cell2mat(u_mse(grp2 ,m))); %produces a scalar
        
        u_mse_norm(k) = (u_mse_test - u_mse_train) ./ u_mse_train; %  1 x 252 vector after for loop ends
        
        u_rom_train = median(cell2mat(u_rom(grp1, m)));
        u_rom_test =  median(cell2mat(u_rom(grp2, m)));
        u_rom_norm(k) = (u_rom_test - u_rom_train) ./ u_rom_train;
    end
    
    
    u_rom_norm_mean(m) = mean(u_rom_norm);
    u_rom_norm_2xstd(m) = 2.*std(u_rom_norm);
    u_mse_norm_mean(m) = mean(u_mse_norm);
    u_mse_norm_2xstd(m) = 2.*std(u_mse_norm);
    
end
