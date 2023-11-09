clear;clc;close all
% ad_temp - figure S2A, ad_hum - figure S2B
% de_temp - figure S3A, de_hum - figure S3B
tic

evr_list = dir('F:\ywj\matlab\map_NASA_day\evr\*.nc4');
iso_list = dir('F:\ywj\matlab\map_NASA_day\Isotherm\*.txt');
evr_num = length(evr_list);iso_num = length(iso_list);

file = ['F:\ywj\matlab\map_NASA_day\evr\',evr_list(1).name];
lats = ncread(file, 'lat');
lons = ncread(file, 'lon');

OP_ad_t = zeros(361,576);OP_de_t = zeros(361,576);
OP_ad_RH = zeros(361,576);OP_de_RH = zeros(361,576);
OP_num = zeros(361,576);
for n = 1:evr_num
    
    load(['F:\ywj\matlab\map_NASA_day\wt_par_save\evr_data_save\hum',num2str(n),'.mat']);
    load(['F:\ywj\matlab\map_NASA_day\wt_par_save\evr_data_save\temp',num2str(n),'.mat']);
    for i = 1:361
        for j = 1:576
            if ad_temp(i,j) < 273.15
                continue;
            else
                OP_ad_t(i,j) = OP_ad_t(i,j) + ad_temp(i,j);
                OP_de_t(i,j) = OP_de_t(i,j) + de_temp(i,j);
                OP_ad_RH(i,j) = OP_ad_RH(i,j) + ad_hum(i,j);
                OP_de_RH(i,j) = OP_de_RH(i,j) + de_hum(i,j);
                OP_num(i,j) = OP_num(i,j) + 1;
            end
        end
    end
end

for i = 1:361
    for j = 1:576
        OP_ad_t(i,j) = OP_ad_t(i,j)/OP_num(i,j);
        OP_de_t(i,j) = OP_de_t(i,j)/OP_num(i,j);
        OP_ad_RH(i,j) = OP_ad_RH(i,j)/OP_num(i,j);
        OP_de_RH(i,j) = OP_de_RH(i,j)/OP_num(i,j);
    end
end

OP_ad_RH(OP_ad_RH == 0) = 0/0;
OP_de_RH(OP_de_RH == 0) = 0/0;

lons(577,1) = 180;
OP_ad_RH(:,577) = OP_ad_RH(:,1);
OP_de_RH(:,577) = OP_de_RH(:,1);
OP_ad_t(:,577) = OP_ad_t(:,1);
OP_de_t(:,577) = OP_de_t(:,1);
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
%
mycol = [255,255,0;
    255,192,64;
    128,192,64;
    0,192,128;
    0,128,255;]/255;
% mycol = [210,227,243;
%     170,207,229;
%     104,172,213;
%     56,136,192;
%     16,92,164;
%     8,51,110]/255;
mycolor = interp1(linspace(0,1,size(mycol,1)),mycol,linspace(0,1,256),'cubic');
mycolor(mycolor<0) = 0;
mycolor(mycolor>1) = 1;
%
figure
set(gca,'LooseInset',[0 0 0 0])
pcolor(lons,lats,OP_ad_RH);
%去掉网格线
shading flat
c = colorbar;
colormap(mycolor)
caxis([0 100])
hold on
title(' ')
plot(long,lat,'black')
set(gcf,'position',[150,150,1200,600]);
set(gca,'Xtick',(-180:90:180));
set(gca,'Ytick',(-90:45:90));

figure
set(gca,'LooseInset',[0 0 0 0])
pcolor(lons,lats,OP_de_RH);
%去掉网格线
shading flat
c = colorbar;
colormap(mycolor)
caxis([0 100])
hold on
title(' ')
plot(long,lat,'black')
set(gcf,'position',[150,150,1200,600]);
set(gca,'Xtick',(-180:90:180));
set(gca,'Ytick',(-90:45:90));

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
pcolor(lons,lats,OP_ad_t-273.15);
%去掉网格线
shading flat
c = colorbar;
colormap(mycolor)
caxis([0 30])
hold on
title(' ')
plot(long,lat,'black')
set(gcf,'position',[150,150,1200,600]);
set(gca,'Xtick',(-180:90:180));
set(gca,'Ytick',(-90:45:90));

figure
set(gca,'LooseInset',[0 0 0 0])
pcolor(lons,lats,OP_de_t-273.15);
%去掉网格线
shading flat
c = colorbar;
colormap(mycolor)
caxis([10 110])
hold on
title(' ')
plot(long,lat,'black')
set(gcf,'position',[150,150,1200,600]);
set(gca,'Xtick',(-180:90:180));
set(gca,'Ytick',(-90:45:90));


toc