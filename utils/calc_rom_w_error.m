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
    if df1 > df2
        rom_max_ = rom_max_ + df1; % add bigger one to max (df1)
        rom_min_ = rom_min_ + df2;
    else
        rom_max_ = rom_max_ + df2; % add bigger one to max (df2)
        rom_min_ = rom_min_ + df1;
    end
end

rom = sqrt(rom_/(N-1));
try 
    assert(abs(rom - rom_init) < 1e-12);
catch
    keyboard; 
end

rom_min = sqrt(rom_min_/(N-1));
rom_max = sqrt(rom_max_/(N-1));

if rom_max <= rom_min
    keyboard
end

if rom_min > rom
    rom_min = rom; 
end


