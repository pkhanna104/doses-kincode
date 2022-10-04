function [u_rom_norm,u_rom_norm_mean,u_rom_norm_std,u_mse_norm_mean, u_mse_norm_std] = normal_mean_std(mse_rom)

    u_rom = mse_rom.u_rom;
    u_mse = mse_rom.u_mse;
  

    C = nchoosek([1:10],5);
     %bootstrap without replacement unaffect ROM!  -> used for determinng
     %"normal data
     for m = 1:12
            for k = 1:size(nchoosek([1:10],5),1) %1 to total # of possible permutations -> 252 here
                u_mse_train = median(cell2mat(u_mse(C(k,:),m))); %produces a scalar
                u_mse_test = median(setdiff(cell2mat(u_mse(:,m)),cell2mat(u_mse(C(k,:),m)))); %produces a scalar
                u_mse_norm(k) = (u_mse_test - u_mse_train) ./ u_mse_train; %  1 x 252 vector after for loop ends
                                
                u_rom_train = median(cell2mat(u_rom(C(k,:),m)));
                u_rom_test = median(setdiff(cell2mat(u_rom(:,m)),cell2mat(u_rom(C(k,:),m))));
                u_rom_norm(k) = (u_rom_test - u_rom_train) ./ u_rom_train;
            end      
        u_rom_norm_mean(m) = mean(u_rom_norm);
        u_rom_norm_std(m) = 2.*std(u_rom_norm);
        u_mse_norm_mean(m) = mean(u_mse_norm);
        u_mse_norm_std(m) = 2.*std(u_mse_norm);
         
     end
       