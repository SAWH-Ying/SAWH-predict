clear;clc;close all
% 取水地图主程序
% 全年不换吸附剂
tic

evr_list = dir('F:\ywj\matlab\map_NASA_day\evr\*.nc4');
iso_list = dir('F:\ywj\matlab\map_NASA_day\Isotherm\*.txt');
evr_num = length(evr_list);iso_num = length(iso_list);

file = ['F:\ywj\matlab\map_NASA_day\evr\',evr_list(1).name];
lats = ncread(file, 'lat');
lons = ncread(file, 'lon');

OP = zeros(361,576,iso_num);

for n = 1:evr_num
    load(['F:\ywj\matlab\map_NASA_day\wt_par_save\evr_data_save\hum',num2str(n),'.mat']);
    load(['F:\ywj\matlab\map_NASA_day\wt_par_save\evr_data_save\temp',num2str(n),'.mat']);
    w_take = zeros(361,576,iso_num);
    for u = 1:iso_num
        Iso = load(['F:\ywj\matlab\map_NASA_day\Isotherm\',iso_list(u).name]);
        
        w_ad = interp1(Iso(:,1),Iso(:,2),ad_hum,'linear');
        w_de = interp1(Iso(:,3),Iso(:,4),de_hum,'linear');
        
        w_take(:,:,u) = (w_ad - w_de).*(w_ad - w_de > 0);
        OP(:,:,u) = OP(:,:,u) + w_take(:,:,u)/evr_num;
    end
end

OP(OP == 0) = 0/0;
OP1 = zeros(361,576);
OP2 = zeros(361,576);

for i = 1:361
    for j = 1:576
        [a,b] = max(OP(i,j,:));
        OP1(i,j) = a;
        if isnan(a)
            OP2(i,j) = 0/0;
        else
            OP2(i,j) = b;
        end
    end
end
% 补充东经180
lons(577,1) = 180;
OP1(:,577) = OP1(:,1);
OP2(:,577) = OP2(:,1);
%% figure
% 海岸线修正
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

%平均取水
mycol = [210,227,243;
    170,207,229;
    104,172,213;
    56,136,192;
    16,92,164;
    8,51,110]/255;

mycolor = interp1(linspace(0,1,size(mycol,1)),mycol,linspace(0,1,256),'cubic');
mycolor(mycolor<0) = 0;
mycolor(mycolor>1) = 1;

figure
set(gca,'LooseInset',[0 0 0 0])
pcolor(lons,lats,OP1);
shading flat
c = colorbar;
colormap(mycolor)
caxis([0 2])
hold on
title(' ')
plot(long,lat,'black')
set(gcf,'position',[150,150,1200,600]);
set(gca,'Xtick',(-180:90:180));
set(gca,'Ytick',(-90:45:90));

%对应最多次吸附剂
mycol = [
    230,111,81;
    243,162,97;
    232,197,107;
    138,176,125;
    41,157,143;
    40,114,113;]/255;
figure
set(gca,'LooseInset',[0 0 0 0])
pcolor(lons,lats,OP2);
shading flat
c = colorbar;
colormap(mycol)
caxis([1 7])
hold on
title(' ')
plot(long,lat,'black')
set(gcf,'position',[150,150,1200,600]);
set(gca,'Xtick',(-180:90:180));
set(gca,'Ytick',(-90:45:90));

toc

