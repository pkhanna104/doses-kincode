function correct_data_LR(filename, change_from, change_to)
% sometimes I record data as Left instead of right
% procedure for fixing: 
% 1. make a copy of the data folder as "edited"
% 2. run this method

data = load(filename); 
data = data.data; 

% Get name
nms = fieldnames(data); 

rm_fields = {}; 

for i=1:length(nms)
    if contains(nms{i}, change_from)
        
        newname = strrep(nms{i}, change_from, change_to); 
        data.(newname) = data.(nms{i}); 
        
        data = rmfield(data, nms{i}); 
    end
end

save(filename, 'data'); 

