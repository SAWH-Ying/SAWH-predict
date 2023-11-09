clear;clc;close all
tic

evr_list = dir('F:\ywj\matlab\map_NASA_day\evr\*.nc4');
iso_list = dir('F:\ywj\matlab\map_NASA_day\Isotherm\*.txt');
rad_list = dir('F:\ywj\matlab\map_NASA_day\rad\*.nc4');
evr_num = length(evr_list);iso_num = length(iso_list);

file = ['F:\ywj\matlab\map_NASA_day\evr\',evr_list(1).name];
lats = ncread(file, 'lat');
lons = ncread(file, 'lon');

R_aver = zeros(361,576);
% T_ad = zeros(361,576);
% T_de = zeros(361,576);

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
    
    file = ['F:\ywj\matlab\map_NASA_day\rad\',rad_list(n).name];
    R = ncread(file, 'SWGDN');
    R = rot90(fliplr(R));

    for i = 1:361
        for j = 1:576
            delta_t = floor((j+12-1)/24)-12;
            %初始化
            night_T = 0;night_Y = 0;night_P = 0;
            day_T = 0;day_Y = 0;day_P = 0;day_R = 0;
            for k = 1:6
                if k-delta_t <= 0
                    night_T = night_T + T(i,j,k+24-delta_t)/12;
                    night_Y = night_Y + Y(i,j,k+24-delta_t)/12;
                    night_P = night_P + P(i,j,k+24-delta_t)/12;
                else
                    night_T = night_T + T(i,j,k-delta_t)/12;
                    night_Y = night_Y + Y(i,j,k-delta_t)/12;
                    night_P = night_P + P(i,j,k-delta_t)/12;
                end
                
                if k+18-delta_t > 24
                    night_T = night_T + T(i,j,k+18-24-delta_t)/12;
                    night_Y = night_Y + Y(i,j,k+18-24-delta_t)/12;
                    night_P = night_P + P(i,j,k+18-24-delta_t)/12;
                else
                    night_T = night_T + T(i,j,k+18-delta_t)/12;
                    night_Y = night_Y + Y(i,j,k+18-delta_t)/12;
                    night_P = night_P + P(i,j,k+18-delta_t)/12;
                end
                
                
                if k+9-delta_t <= 0
                    day_R = day_R + R(i,j,k+9+24-delta_t)/6;
                    day_Y = day_Y + Y(i,j,k+9+24-delta_t)/6;
                    day_P = day_P + P(i,j,k+9+24-delta_t)/6;
                    day_T = day_T + T(i,j,k+9+24-delta_t)/6;
                elseif k+9-delta_t > 24
                    day_R = day_R + R(i,j,k+9-24-delta_t)/6;
                    day_Y = day_Y + Y(i,j,k+9-24-delta_t)/6;
                    day_P = day_P + P(i,j,k+9-24-delta_t)/6;
                    day_T = day_T + T(i,j,k+9-24-delta_t)/6;
                else
                    day_R = day_R + R(i,j,k+9-delta_t)/6;
                    day_Y = day_Y + Y(i,j,k+9-delta_t)/6;
                    day_P = day_P + P(i,j,k+9-delta_t)/6;
                    day_T = day_T + T(i,j,k+9-delta_t)/6;
                end
            end
            R_aver(i,j) = R_aver(i,j) + day_R/evr_num;
%             T_de(i,j) = T_de(i,j) + day_T/evr_num;
        end
    end
    
end
lons(577,1) = 180;
R_aver(:,577) = R_aver(:,1);
% T_de(:,577) = T_de(:,1);

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

mycol = [255,253,223;
    252,149,39;
    169,59,3;]/255;
mycolor = interp1(linspace(0,1,size(mycol,1)),mycol,linspace(0,1,256),'cubic');
mycolor(mycolor<0) = 0;
mycolor(mycolor>1) = 1;

figure
set(gca,'LooseInset',[0 0 0 0])
pcolor(lons,lats,R_aver);
%去掉网格线
shading flat
c = colorbar;
colormap(mycolor)
caxis([0 900])
hold on
title(' ')
plot(long,lat,'black')
set(gcf,'position',[150,150,1200,600]);
set(gca,'Xtick',(-180:90:180));
set(gca,'Ytick',(-90:45:90));

% mycol = [44,75,117;
% %     255,192,64;
%     224,200,200;
% %     0,192,128;
%     220,62,46;]/255;
% mycolor = interp1(linspace(0,1,size(mycol,1)),mycol,linspace(0,1,256),'cubic');
% mycolor(mycolor<0) = 0;
% mycolor(mycolor>1) = 1;
% 
% figure
% set(gca,'LooseInset',[0 0 0 0])
% pcolor(lons,lats,T_de-273.15);
% %去掉网格线
% shading flat
% c = colorbar;
% colormap(mycolor)
% % caxis([-50 40])
% hold on
% title(' ')
% plot(long,lat,'black')
% set(gcf,'position',[150,150,1200,600]);

toc