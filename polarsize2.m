function [pos_loc, pos_val, neg_loc, neg_val] = polarsize2(l_loc, l_pv, l_flag)

N = size(l_loc, 1);
pos_loc = [];
pos_val = [];
neg_loc = [];
neg_val = [];
for i = 1:N

    curr_loc = l_loc(i)/2000000*2*pi;
    curr_val = l_pv(i);
    curr_polar = l_flag(i);
    if (curr_polar==1)
        pos_loc = [pos_loc, curr_loc];
        pos_val = [pos_val, curr_val];
    else
        neg_loc = [neg_loc, curr_loc];
        neg_val = [neg_val, curr_val];
    end
end
end