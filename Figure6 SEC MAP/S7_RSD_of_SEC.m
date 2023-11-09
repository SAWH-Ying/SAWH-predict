clear;clc;close all
% SEC求RSD图
tic
% jing = 0.625;wei = 24;%沙漠
% jing = 77;wei = 28;%新德里
% jing = 12.2;wei = 45.26;%威尼斯
% jing = 91.06;wei = 29.36;%拉萨
% jing = -73.2;wei = -3.7;%亚马逊
% jing = 37.5;wei = 55.5;%莫斯科
% jing = -118.15;wei = 34.4;%洛杉矶
jing = 116.2;wei = 39.56;%北京
% jing = 31.05;wei = -17.82;%harare

evr_list = dir('F:\ywj\matlab\map_NASA_day\evr\*.nc4');
iso_list = dir('F:\ywj\matlab\map_NASA_day\Isotherm\*.txt');
evr_num = length(evr_list);iso_num = length(iso_list);

file = ['F:\ywj\matlab\map_NASA_day\evr\',evr_list(1).name];
lats = ncread(file, 'lat');
lons = ncread(file, 'lon');

location1 = find(abs(lats-wei) == min(abs(lats - wei)));
location2 = find(abs(lons-jing) == min(abs(lons - jing)));
% OP = zeros(361,576,iso_num);
%%
lons(577,1) = 180;
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
%% 循环计算各个陆地

test_data1 = zeros(361,577,12);
test_data2 = zeros(361,577,12);
test_data3 = zeros(361,577,12);
test_data4 = zeros(361,577,12);
test_data5 = zeros(361,577,12);
test_data6 = zeros(361,577,12);

month = [31,28,31,30,31,30,31,31,30,31,30,31];
m_num = 1;num_tra = zeros(361,577,6);
for n = 1:365
    load(['F:\ywj\matlab\map_NASA_day\Ex_par_save\ex_data_save2\evr',num2str(n),'.mat'],'Ex_aver')
    Ex_aver(:,577,:) = Ex_aver(:,1,:);

    num_tra = num_tra + (Ex_aver < 1e7);
    
    if n > sum(month(1:m_num))
        m_num = m_num + 1;
    end
    
    Ex_aver(Ex_aver == 1e7) = 0;
    test_data1(:,:,m_num) = test_data1(:,:,m_num) + Ex_aver(:,:,1);
    test_data2(:,:,m_num) = test_data2(:,:,m_num) + Ex_aver(:,:,2);
    test_data3(:,:,m_num) = test_data3(:,:,m_num) + Ex_aver(:,:,3);
    test_data4(:,:,m_num) = test_data4(:,:,m_num) + Ex_aver(:,:,4);
    test_data5(:,:,m_num) = test_data5(:,:,m_num) + Ex_aver(:,:,5);
    test_data6(:,:,m_num) = test_data6(:,:,m_num) + Ex_aver(:,:,6);
    
    if n == sum(month(1:m_num))
        test_data1(:,:,m_num) = test_data1(:,:,m_num)./num_tra(:,:,1);
        test_data2(:,:,m_num) = test_data2(:,:,m_num)./num_tra(:,:,2);
        test_data3(:,:,m_num) = test_data3(:,:,m_num)./num_tra(:,:,3);
        test_data4(:,:,m_num) = test_data4(:,:,m_num)./num_tra(:,:,4);
        test_data5(:,:,m_num) = test_data5(:,:,m_num)./num_tra(:,:,5);
        test_data6(:,:,m_num) = test_data6(:,:,m_num)./num_tra(:,:,6);
        num_tra = zeros(361,577,6);
    end
end

test_data1(isnan(test_data1)) = 0;
test_data2(isnan(test_data2)) = 0;
test_data3(isnan(test_data3)) = 0;
test_data4(isnan(test_data4)) = 0;
test_data5(isnan(test_data5)) = 0;
test_data6(isnan(test_data6)) = 0;

OP_ave1 = zeros(361,577);OP_RSD1 = zeros(361,577);
OP_ave2 = zeros(361,577);OP_RSD2 = zeros(361,577);
OP_ave3 = zeros(361,577);OP_RSD3 = zeros(361,577);
OP_ave4 = zeros(361,577);OP_RSD4 = zeros(361,577);
OP_ave5 = zeros(361,577);OP_RSD5 = zeros(361,577);
OP_ave6 = zeros(361,577);OP_RSD6 = zeros(361,577);

for i = 1:361
    for j = 1:577
        [OP_ave1(i,j),OP_RSD1(i,j)] = RSD(test_data1(i,j,:));
        [OP_ave2(i,j),OP_RSD2(i,j)] = RSD(test_data2(i,j,:));
        [OP_ave3(i,j),OP_RSD3(i,j)] = RSD(test_data3(i,j,:));
        [OP_ave4(i,j),OP_RSD4(i,j)] = RSD(test_data4(i,j,:));
        [OP_ave5(i,j),OP_RSD5(i,j)] = RSD(test_data5(i,j,:));
        [OP_ave6(i,j),OP_RSD6(i,j)] = RSD(test_data6(i,j,:));
        
    end
end

%%
OP1 = zeros(361,577);OP2 = zeros(361,577);
for i = 1:361
    for j = 1:577
        
        test = [OP_ave1(i,j),OP_ave2(i,j),OP_ave3(i,j),OP_ave4(i,j),OP_ave5(i,j),OP_ave6(i,j)];
        [a,b] = min(test);
        if a == 0
            OP1(i,j) = 0/0;
            OP2(i,j) = 0/0;
        else
            OP1(i,j) = a;
            OP2(i,j) = b;
        end
    end
end

AANS = zeros(13,6);
for n = 1:12
    AANS(n,1) = test_data1(location1,location2,n)/1000;
    AANS(n,2) = test_data2(location1,location2,n)/1000;
    AANS(n,3) = test_data3(location1,location2,n)/1000;
    AANS(n,4) = test_data4(location1,location2,n)/1000;
    AANS(n,5) = test_data5(location1,location2,n)/1000;
    AANS(n,6) = test_data6(location1,location2,n)/1000;
end
AANS(13,1) = OP_RSD1(location1,location2);
AANS(13,2) = OP_RSD2(location1,location2);
AANS(13,3) = OP_RSD3(location1,location2);
AANS(13,4) = OP_RSD4(location1,location2);
AANS(13,5) = OP_RSD5(location1,location2);
AANS(13,6) = OP_RSD6(location1,location2);


figure
hold on 
plot(1:12,AANS(1:12,1),'o')
plot(12*1+1:12*2,AANS(1:12,2),'o')
plot(12*2+1:12*3,AANS(1:12,3),'o')
plot(12*3+1:12*4,AANS(1:12,4),'o')
plot(12*4+1:12*5,AANS(1:12,5),'o')
plot(12*5+1:12*6,AANS(1:12,6),'o')
ylim([0 4])
toc



