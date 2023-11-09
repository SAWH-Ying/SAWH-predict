clear;clc;close all
%输入地点的经纬度，输出温湿度
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
rad_list = dir('F:\ywj\matlab\map_NASA_day\rad\*.nc4');
nc4_num = length(evr_list);

file = ['F:\ywj\matlab\map_NASA_day\evr\',evr_list(1).name];
lats = ncread(file, 'lat');
lons = ncread(file, 'lon');

location1 = find(abs(lats-wei) == min(abs(lats - wei)));
location2 = find(abs(lons-jing) == min(abs(lons - jing)));

T_aver = zeros(12*25,1);
Y_aver = zeros(12*25,1);
P_aver = zeros(12*25,1);
R_aver = zeros(12*25,1);
RH_aver = zeros(12*25,1);
x = zeros(12*25,1);

mm = [31 28 31 30 31 30 31 31 30 31 30 31];
mm_flag = 1;
delta_t = floor((location2+12-1)/24)-12;
for i = 1:nc4_num
    file = ['F:\ywj\matlab\map_NASA_day\evr\',evr_list(i).name];
    % 读取nc4文件内的信息
    % ncdisp(file)
    
    % 2-meter_air_temperature
    T = ncread(file, 'T2M');
    Y = ncread(file, 'QV2M');
    P = ncread(file, 'PS');
    
    T = rot90(fliplr(T));
    Y = rot90(fliplr(Y));
    P = rot90(fliplr(P));
    
    file = ['F:\ywj\matlab\map_NASA_day\rad\',rad_list(i).name];
    R = ncread(file, 'SWGDN');
    R = rot90(fliplr(R));
    
    if i > sum(mm(1:mm_flag))
        mm_flag = mm_flag + 1;
    end
    
    n = 0;
    for j = 1:24
        if j - delta_t > 24
            n = j-delta_t-24;
        elseif j - delta_t < 1
            n = j-delta_t+24;
        else
            n = j-delta_t;
        end
        
        T_aver((mm_flag-1)*25+j) = T_aver((mm_flag-1)*25+j) + T(location1,location2,n)/mm(mm_flag);
        Y_aver((mm_flag-1)*25+j) = Y_aver((mm_flag-1)*25+j) + Y(location1,location2,n)/mm(mm_flag);
        P_aver((mm_flag-1)*25+j) = P_aver((mm_flag-1)*25+j) + P(location1,location2,n)/mm(mm_flag);
        R_aver((mm_flag-1)*25+j) = R_aver((mm_flag-1)*25+j) + R(location1,location2,n)/mm(mm_flag);
        
    end
end


for i = 1:12
    RH_aver(i*25) = 0/0;x(i*25) = 0/0;
    T_aver(i*25) = 0/0;Y_aver(i*25) = 0/0;P_aver(i*25) = 0/0;R_aver(i*25) = 0/0;
    for j = 1:24
        RH_aver(i*25-25+j) = RH_cal(T_aver(i*25-25+j),Y_aver(i*25-25+j),P_aver(i*25-25+j));
        x(i*25-25+j) = 1/24*j+i-1;
    end
end
T_aver = T_aver - 273.15;

clear P R T Y lons lats i j file evr_list delta_t
clear mm mm_flag n nc4_num location1 location2
%%

figure
set(gca,'LooseInset',[0 0 0 0])
set(gca,'XLim',[0 12])
yyaxis left
plot(x,T_aver)
set(gca,'YLim',[0 50])
yyaxis right
plot(x,RH_aver)
set(gca,'YLim',[0 100])

figure
set(gca,'LooseInset',[0 0 0 0])
set(gca,'XLim',[0 12])
yyaxis left
plot(x,P_aver/1000)
set(gca,'YLim',[50 110])
yyaxis right
plot(x,R_aver)
set(gca,'YLim',[0 1000])


toc