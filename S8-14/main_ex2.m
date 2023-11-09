clear;clc;close all
% 不换吸附剂，输入地点的经纬度，输出在该文件计算下的每日能耗柱状图
% OP - figure D, OP2 - figure E
tic

% jing = 0.625;wei = 24;%沙漠
% jing = 77;wei = 28;%新德里
% jing = 12.2;wei = 45.26;%威尼斯
% jing = 91.06;wei = 29.36;%拉萨
jing = -73.2;wei = -3.7;%亚马逊
% jing = 37.5;wei = 55.5;%莫斯科
% jing = -118.15;wei = 34.4;%洛杉矶
% jing = 116.2;wei = 39.56;%北京
% jing = 31.05;wei = -17.82;%harare

evr_list = dir('F:\ywj\matlab\map_NASA_day\evr\*.nc4');
iso_list = dir('F:\ywj\matlab\map_NASA_day\Isotherm\*.txt');
evr_num = length(evr_list);iso_num = length(iso_list);

file = ['F:\ywj\matlab\map_NASA_day\evr\',evr_list(1).name];
lats = ncread(file, 'lat');
lons = ncread(file, 'lon');

location1 = find(abs(lats-wei) == min(abs(lats - wei)));
location2 = find(abs(lons-jing) == min(abs(lons - jing)));

OP = zeros(365,6);OP2 = zeros(6,1);

for n = 1:evr_num
    load(['F:\ywj\matlab\map_NASA_day\Ex_par_save\ex_data_save2\evr',num2str(n),'.mat']);
    for i = 1:iso_num
        if Ex_aver(location1,location2,i) == 1e7
            continue;
        else
        OP(n,i) = Ex_aver(location1,location2,i)/1000;
        end
        OP2(i) = OP2(i) + OP(n,i);
    end
end

for i = 1:6
%     OP2(i) = OP2(i)/sum(OP(:,i)~=0);
    OP2(i) = OP2(i)/evr_num;
end

clear evr_list evr_num Ex_aver file i iso_list iso_num jing wei 
clear lats lons n

figure
set(gca,'LooseInset',[0 0 0 0]);
set(gca,'XLim',[0 365]);
% set(gca,'YLim',[0 5]);
box on
hold on 

plot(1:365,OP(:,1),'Color',[230,111,81]/255,'Linewidth',2);
plot(1:365,OP(:,2),'Color',[243,162,97]/255,'Linewidth',2);
plot(1:365,OP(:,3),'Color',[232,197,107]/255,'Linewidth',2);
plot(1:365,OP(:,4),'Color',[138,176,125]/255,'Linewidth',2);
plot(1:365,OP(:,5),'Color',[41,157,143]/255,'Linewidth',2);
plot(1:365,OP(:,6),'Color',[40,114,113]/255,'Linewidth',2);





toc