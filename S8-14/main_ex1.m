clear;clc;close all
% 换吸附剂，输入地点的经纬度，输出在该文件计算下的每日能耗柱状图
% OP第一列每日最小能耗，第二列对应吸附剂
% OP2 - figure F
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

OP = zeros(365,2);OP2 = zeros(6,2);
for n = 1:evr_num
    load(['F:\ywj\matlab\map_NASA_day\Ex_par_save\ex_data_save2\evr',num2str(n),'.mat']);
    [a,b] = min(Ex_aver(location1,location2,:));
    if a == 1e7
        continue;
    else
    OP(n,1) = a/1000;
    OP(n,2) = b;
    end
end
for n = 1:evr_num
    if OP(n,2) == 0
        continue;
    else
        OP2(OP(n,2),1) = OP2(OP(n,2),1) + 1;
        OP2(OP(n,2),2) = OP2(OP(n,2),2) + OP(n,1);
    end
end
for i = 1:6
    if OP2(i,2) == 0
        continue;
    end
    OP2(i,2) = OP2(i,2)/OP2(i,1);
end
clear a b evr_list evr_num Ex_aver file i iso_list iso_num
clear jing lats lons n wei
%% figure
figure
box on
hold on
set(gca,'LooseInset',[0 0 0 0]);
set(gca,'XLim',[0.5 365.5]);
% set(gca,'YLim',[0 3]);
for i = 1:365
    v1 = [i-0.5 0;i-0.5 OP(i);i+0.5 OP(i,1);i+0.5 0];
    f1 = [1 2 3 4];
    if OP(i,2) == 1
        patch('Faces',f1,'Vertices',v1,'Facecolor',[230,111,81]/255,'FaceAlpha',1, ...
'EdgeAlpha',0);
    elseif OP(i,2) == 2
        patch('Faces',f1,'Vertices',v1,'Facecolor',[243,162,97]/255,'FaceAlpha',1, ...
'EdgeAlpha',0);
    elseif OP(i,2) == 3
        patch('Faces',f1,'Vertices',v1,'Facecolor',[232,197,107]/255,'FaceAlpha',1, ...
'EdgeAlpha',0);
    elseif OP(i,2) == 4
        patch('Faces',f1,'Vertices',v1,'Facecolor',[138,176,125]/255,'FaceAlpha',1, ...
'EdgeAlpha',0);
    elseif OP(i,2) == 5
        patch('Faces',f1,'Vertices',v1,'Facecolor',[41,157,143]/255,'FaceAlpha',1, ...
'EdgeAlpha',0);
    elseif OP(i,2) == 6
        patch('Faces',f1,'Vertices',v1,'Facecolor',[40,114,113]/255,'FaceAlpha',1, ...
'EdgeAlpha',0);
    elseif OP(i,2) == 0
        patch('Faces',f1,'Vertices',v1,'Facecolor',[255,255,255]/255,'FaceAlpha',1, ...
'EdgeAlpha',0);
    end
end





