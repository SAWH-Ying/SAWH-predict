clear;clc;close all
%% 环境温湿压
tic

evr_list = dir('F:\ywj\matlab\map_NASA_day\evr\*.nc4');
% rad_list = dir('F:\ywj\matlab\map_NASA_day\rad\*.nc4');
evr_num = length(evr_list);

file = ['F:\ywj\matlab\map_NASA_day\evr\',evr_list(1).name];
lats = ncread(file, 'lat');
lons = ncread(file, 'lon');

T_aver = zeros(361,576);Y_aver = zeros(361,576);
% R_aver = zeros(361,576);
P_aver = zeros(361,576);
for n = 1:evr_num
    file = ['F:\ywj\matlab\map_NASA_day\evr\',evr_list(n).name];
    % 读取nc4文件内的信息
    % ncdisp(file)
    
    % 2-meter_air_temperature
    T = ncread(file, 'T2M');
    Y = ncread(file, 'QV2M');
    P = ncread(file, 'PS');
    
    T = rot90(fliplr(T));
    Y = rot90(fliplr(Y));
    P = rot90(fliplr(P));
    
%     file = ['F:\ywj\matlab\map_NASA_day\rad\',rad_list(n).name];
%     R = ncread(file, 'SWGDN');
%     R = rot90(fliplr(R));
    for i = 1:24
        T_aver = T_aver + T(:,:,i)/evr_num/24;
        Y_aver = Y_aver + Y(:,:,i)/evr_num/24;
%         R_aver = R_aver + R(:,:,i)/evr_num/24;
        P_aver = P_aver + P(:,:,i)/evr_num/24;
    end
end
lons(577,1) = 180;
T_aver(:,577) = T_aver(:,1);
Y_aver(:,577) = Y_aver(:,1);
% R_aver(:,577) = R_aver(:,1);
P_aver(:,577) = P_aver(:,1);

%% figure
long = zeros(9865,1);
load coast
i = 1;len = length(long);
while i < len
    if long(i) <= 180 && long(i+1) > 180
        lat0 = (lat(i)*(long(i+1)-180)+lat(i+1)*(180-long(i)))/(long(i+1)-long(i));
        for j = len:-1:(i+1)
            long(j+3) = long(j);
            lat(j+3) = lat(j);
        end
        long(i+2) = 0/0;lat(i+2) = 0/0;
        long(i+1) = 180;lat(i+1) = lat0;
        long(i+3) = -180;lat(i+3) = lat0;
        len = len + 3; i = i + 3;
    elseif long(i) > 180 && long(i+1) <= 180
            lat0 = (lat(i)*(long(i+1)-180)+lat(i+1)*(180-long(i)))/(long(i+1)-long(i));
            for j = len:-1:(i+1)
                long(j+3) = long(j);
                lat(j+3) = lat(j);
            end
            long(i+2) = 0/0;lat(i+2) = 0/0;
            long(i+1) = -180;lat(i+1) = lat0;
            long(i+3) = 180;lat(i+3) = lat0;
            len = len + 3; i = i + 3;
    end
    i = i + 1;
end
for i = 1:len
    if long(i) > 180
        long(i) = long(i) - 360;
    end
end

mycol = [44,75,117;
%     255,192,64;
    224,200,200;
%     0,192,128;
    220,62,46;]/255;
mycolor = interp1(linspace(0,1,size(mycol,1)),mycol,linspace(0,1,256),'cubic');
mycolor(mycolor<0) = 0;
mycolor(mycolor>1) = 1;

figure
set(gca,'LooseInset',[0 0 0 0])
pcolor(lons,lats,T_aver-273.15);
%去掉网格线
shading flat
c = colorbar;
colormap(mycolor)
caxis([-50 40])
hold on
title(' ')
plot(long,lat,'black')
set(gcf,'position',[150,150,1200,600]);
set(gca,'Xtick',(-180:90:180));
set(gca,'Ytick',(-90:45:90));

mycol = [255,255,0;
    255,192,64;
    128,192,64;
    0,192,128;
    0,128,255;]/255;
mycolor = interp1(linspace(0,1,size(mycol,1)),mycol,linspace(0,1,256),'cubic');
mycolor(mycolor<0) = 0;
mycolor(mycolor>1) = 1;

figure
set(gca,'LooseInset',[0 0 0 0])
pcolor(lons,lats,Y_aver*1000);
%去掉网格线
shading flat
c = colorbar;
colormap(mycolor)
caxis([0 20])
hold on
title(' ')
plot(long,lat,'black')
set(gcf,'position',[150,150,1200,600]);
set(gca,'Xtick',(-180:90:180));
set(gca,'Ytick',(-90:45:90));

figure
set(gca,'LooseInset',[0 0 0 0])
pcolor(lons,lats,P_aver/1000);
%去掉网格线
shading flat
c = colorbar;
colormap(spring)
caxis([50 110])
hold on
title(' ')
plot(long,lat,'black')
set(gcf,'position',[150,150,1200,600]);
set(gca,'Xtick',(-180:90:180));
set(gca,'Ytick',(-90:45:90));


toc
