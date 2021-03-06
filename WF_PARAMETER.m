function [ED1,ED2,ED3,ED4,ED5,EA5]=WF_PARAMETER(t,x)
% 函数说明: 该函数对信号进行小波变换，并且提取其全局以及细节部分的信号及特征参数
% t: 信号对应的时间
% x: 一维信号
% ED1--ED5: 不同level细节部分的能量参数
% EA5: 全局部分的能量参数

%% 小波变换
% figure(5)
% plot(t,x,'LineWidth',2);xlabel('时间 t/s');ylabel('幅值 A');
%一维小波分解
[c,l] = wavedec(x,5,'db5');  %更改小波的设置信息
%重构第1～5层逼近信号
a5 = wrcoef('a',c,l,'db5',5);
a4 = wrcoef('a',c,l,'db5',4);
a3 = wrcoef('a',c,l,'db5',3);
a2 = wrcoef('a',c,l,'db5',2);
a1 = wrcoef('a',c,l,'db5',1);
%显示各层逼近信号

% figure(3)
% subplot(5,1,1);plot(a5,'LineWidth',2);ylabel('a5');
% subplot(5,1,2);plot(a4,'LineWidth',2);ylabel('a4');
% subplot(5,1,3);plot(a3,'LineWidth',2);ylabel('a3');
% subplot(5,1,4);plot(a2,'LineWidth',2);ylabel('a2');
% subplot(5,1,5);plot(a1,'LineWidth',2);ylabel('a1');
% xlabel('时间 t/s');

%重构第1～5层细节信号
d5 = wrcoef('d',c,l,'db5',5);
d4 = wrcoef('d',c,l,'db5',4);
d3 = wrcoef('d',c,l,'db5',3);
d2 = wrcoef('d',c,l,'db5',2);
d1 = wrcoef('d',c,l,'db5',1);

%显示各层细节信号
% figure(4)
% subplot(5,1,1);plot(d5,'LineWidth',2);ylabel('d5');
% subplot(5,1,2);plot(d4,'LineWidth',2);ylabel('d4');
% subplot(5,1,3);plot(d3,'LineWidth',2);ylabel('d3');
% subplot(5,1,4);plot(d2,'LineWidth',2);ylabel('d2');
% subplot(5,1,5);plot(d1,'LineWidth',2);ylabel('d1');
% xlabel('时间 t/s');


%% 小波能量参数计算
ALL_Cd = sum(d1.^2)+sum(d2.^2)+sum(d3.^2)+sum(d4.^2)+sum(d5.^2);
ALL_Can = sum(a5.^2);
ALL = ALL_Cd+ALL_Can;
ED1 = sum(d1.^2)/ALL*100;
ED2 = sum(d2.^2)/ALL*100;
ED3 = sum(d3.^2)/ALL*100;
ED4 = sum(d4.^2)/ALL*100;
ED5 = sum(d5.^2)/ALL*100;
EA5 = ALL_Can/ALL*100;

end