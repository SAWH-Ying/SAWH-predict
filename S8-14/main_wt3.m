clear;clc;close all
% 不换吸附剂,输入经纬度，输出w_take具体值，OP统计值
% w_take - figure C, OP - figure E
tic

% jing = 0.625;wei = 24;%沙漠
% jing = 77;wei = 28;%新德里
% jing = 12.2;wei = 45.26;%威尼斯
% jing = 91.06;wei = 29.36;%拉萨
% jing = -73.2;wei = -3.7;%亚马逊
% jing = 37.5;wei = 55.5;%莫斯科
% jing = -118.15;wei = 34.4;%洛杉矶
% jing = 116.2;wei = 39.56;%北京
jing = 31.05;wei = -17.82;%harare


evr_list = dir('F:\ywj\matlab\map_NASA_day\evr\*.nc4');
iso_list = dir('F:\ywj\matlab\map_NASA_day\Isotherm\*.txt');
evr_num = length(evr_list);iso_num = length(iso_list);

file = ['F:\ywj\matlab\map_NASA_day\evr\',evr_list(1).name];
lats = ncread(file, 'lat');
lons = ncread(file, 'lon');

location1 = find(abs(lats-wei) == min(abs(lats - wei)));
location2 = find(abs(lons-jing) == min(abs(lons - jing)));

OP = zeros(6,1);w_take = zeros(365,6);

for n = 1:evr_num
    load(['F:\ywj\matlab\map_NASA_day\wt_par_save\evr_data_save\hum',num2str(n),'.mat']);
    load(['F:\ywj\matlab\map_NASA_day\wt_par_save\evr_data_save\temp',num2str(n),'.mat']);

    for u = 1:iso_num
        Iso = load(['F:\ywj\matlab\map_NASA_day\Isotherm\',iso_list(u).name]);
        w_ad = interp1(Iso(:,1),Iso(:,2),ad_hum(location1,location2),'linear');
        w_de = interp1(Iso(:,3),Iso(:,4),de_hum(location1,location2),'linear');
        
        if w_ad - w_de > 0
            w_take(n,u) = w_ad - w_de;
        else
            w_take(n,u) = 0;
        end

        OP(u) = OP(u) + w_take(n,u)/evr_num;
    end
end
clear ad_hum ad_temp de_hum de_temp evr_list evr_num file Iso iso_list
clear iso_num jing lats lons n u wei w_ad w_de

figure
set(gca,'LooseInset',[0 0 0 0]);
set(gca,'XLim',[0 365]);
set(gca,'YLim',[0 2]);
box on
hold on 

plot(1:365,w_take(:,1),'Color',[230,111,81]/255,'Linewidth',2);
plot(1:365,w_take(:,2),'Color',[243,162,97]/255,'Linewidth',2);
plot(1:365,w_take(:,3),'Color',[232,197,107]/255,'Linewidth',2);
plot(1:365,w_take(:,4),'Color',[138,176,125]/255,'Linewidth',2);
plot(1:365,w_take(:,5),'Color',[41,157,143]/255,'Linewidth',2);
plot(1:365,w_take(:,6),'Color',[40,114,113]/255,'Linewidth',2);





toc
