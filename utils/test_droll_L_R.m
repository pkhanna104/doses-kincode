angs = [-179:20:179]; 
figure; subplot(1, 2, 1); hold all; 
v = [cosd(angs); sind(angs)];

for i=1:length(angs)
    plot([0, v(1, i)], [0, v(2, i)], 'color', [1,1,1]*i*1/length(angs)); 
    text(v(1, i), v(2, i), num2str(angs(i)));
end

subplot(1, 2, 2); hold all; 
for i = 1:length(angs)
    a = angs(i); 
    R = [cosd(a) -sind(a);
         sind(a) cosd(a)]; 
    RT = R'; 
    
    v_ = RT*v; 
    plot([0, v_(1, i)], [0, v_(2, i)], 'color', [1,1,1]*i*1/length(angs));
    text(v_(1, i), v_(2, i), num2str(angs(i)));
end
    