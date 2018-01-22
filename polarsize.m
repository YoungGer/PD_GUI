function [pos_loc, pos_val, neg_loc, neg_val] = polarsize(M)
N = size(M(:,7), 1);
pos_loc = [];
pos_val = [];
neg_loc = [];
neg_val = [];
for i = 1:N
    curr_loc = M(:,1);
    curr_loc = curr_loc(i)/2000000*2*pi;
    
    curr_val = M(:,6);
    curr_val = curr_val(i);
    
    curr_polar = M(:, 7);
    curr_polar = curr_polar(i);
    if (curr_polar==1)
        pos_loc = [pos_loc, curr_loc];
        pos_val = [pos_val, curr_val];
    else
        neg_loc = [neg_loc, curr_loc];
        neg_val = [neg_val, curr_val];
    end
end
end