clear;clc;close all
% 数据预处理
tic

evr_list = dir('F:\ywj\matlab\map_NASA_day\evr\*.nc4');
rad_list = dir('F:\ywj\matlab\map_NASA_day\rad\*.nc4');
evr_num = length(evr_list);

p = parpool('local',20);
parfor n = 1:evr_num
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
    % 数据处理子函数并保存数据
    wt_evr_cal(T,Y,P,R,n);
end

delete(p);

toc