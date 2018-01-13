function [rt_pd, rt_noise] = get_pd_noise_rt()

pd = csvread('./pd.csv');
rt_pd = mean(pd(:,4));

noise = csvread('./noise.csv');
rt_noise = mean(noise(:,4));

end