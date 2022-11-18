clear;clc;close all
% 能耗预作图
tic

evr_list = dir('F:\ywj\matlab\map_NASA_day\evr\*.nc4');
iso_list = dir('F:\ywj\matlab\map_NASA_day\Isotherm\*.txt');
evr_num = length(evr_list);iso_num = length(iso_list);

file = ['F:\ywj\matlab\map_NASA_day\evr\',evr_list(1).name];
lats = ncread(file, 'lat');
lons = ncread(file, 'lon');

OP = zeros(361,576);Sor = zeros(361,576,evr_num);
for n = 1:evr_num
    load(['F:\ywj\matlab\map_NASA_day\Ex_par_save\ex_data_save\evr',num2str(n),'.mat']);
    Ex_aver(Ex_aver == 1e7) = 0;
    Sor(:,:,n) = Sor_aver;
    OP = OP + Ex_aver/evr_num;
end

OP(OP == 0) = 0/0;
OP = OP/1000;
OP3 = zeros(361,576);
load wt_sor
for i = 1:361
    for j = 1:576
        if isnan(OP(i,j)) || isnan(OP2(i,j))
            OP(i,j) = 0/0;
            OP3(i,j) = 0/0;
            continue;
        end
        sor_num = zeros(6,1);
        for k = 1:evr_num
            for u = 1:6
                if Sor(i,j,k) == u
                    sor_num(u) = sor_num(u) + 1;
                end
            end
        end
        [a,b] = max(sor_num);
        OP3(i,j) = b;
    end
end

lons(577,1) = 180;
OP(:,577) = OP(:,1);
OP3(:,577) = OP3(:,1);
%%
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
% 平均能耗
% mycol = [254,249,244;
%     205,25,25]/255;

mycol = [255,253,223;
    254,205,97;
    252,149,39;
    225,100,14;
    169,59,3;]/255;
mycolor = interp1(linspace(0,1,size(mycol,1)),mycol,linspace(0,1,256),'cubic');
mycolor(mycolor<0) = 0;
mycolor(mycolor>1) = 1;

figure
set(gca,'LooseInset',[0 0 0 0])
pcolor(lons,lats,OP);
%去掉网格线
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
set(gca,'Fontname','Times new Roman');
pcolor(lons,lats,OP3);
%去掉网格线
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