function [rom_min, rom_max, rom] = calc_rom_w_error(jt, acc)

rom_init = std(jt);

rom_ = 0;
rom_min_ = 0;
rom_max_ = 0;

std_acc = std(acc);
mn = mean(jt);
N = length(jt);
for i = 1:N

    df = (jt(i) - mn).^2;
    df1 = ((jt(i) + std_acc) - mn).^2;
    df2 = ((jt(i) - std_acc) - mn).^2;

    rom_ = rom_ + df;

    opts = [df, df1, df2]; 
    [~, ix_sort] = sort(opts); % sort in ascending order 
    rom_max_ = rom_max_ + opts(ix_sort(3)); 
    rom_min_ = rom_min_ + opts(ix_sort(1)); 
end

rom = sqrt(rom_/(N-1));
try 
    assert(abs(rom - rom_init) < 1e-12);
catch
    keyboard; 
end

rom_min = sqrt(rom_min_/(N-1));
rom_max = sqrt(rom_max_/(N-1));

assert(rom_min<= rom)
assert(rom<= rom_max)

