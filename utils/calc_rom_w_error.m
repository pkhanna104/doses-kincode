function [rom_min, rom_max, rom] = calc_rom_w_error(jt, acc, nstd)

% original ROM, calculating to make sure one at the end matches this one
rom_init = std(jt);

% intermediate variables
rom_ = 0;
rom_min_ = 0;
rom_max_ = 0;

% std of the accuracy error used to put "error bars" on individual
% datapoints 
std_acc = nstd*std(acc);

% Variables used to calculate ROM; 
mn = mean(jt);
N = length(jt);

for i = 1:N
    
    % Differences w/ and w/o error bars
    df = (jt(i) - mn).^2;
    df1 = ((jt(i) + std_acc) - mn).^2;
    df2 = ((jt(i) - std_acc) - mn).^2;

    % True ROM calc
    rom_ = rom_ + df;

    opts = [df, df1, df2]; 
    [~, ix_sort] = sort(opts); % sort in ascending order 

    % Add the biggest ROM to rom_max, smallest to ROM_min
    % This is a fairly aggressive way to calculate ROM error (e.g. compared
    % to the sampling approach)

    % Other suggestions that are consistent with the hysteresis error are
    % definitely welcome !
    rom_max_ = rom_max_ + opts(ix_sort(3)); 
    rom_min_ = rom_min_ + opts(ix_sort(1)); 
end

% True ROM
rom = sqrt(rom_/(N-1));

% Make sure this matches the initial ROM
assert(abs(rom - rom_init) < 1e-12);

rom_min = sqrt(rom_min_/(N-1));
rom_max = sqrt(rom_max_/(N-1));

assert(rom_min<= rom)
assert(rom<= rom_max)

