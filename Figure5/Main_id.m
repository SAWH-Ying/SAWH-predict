clear;clc;close all
% 全吸附剂焓湿图
tic
iso_list = dir('F:\ywj\matlab\map_NASA_day\Isotherm\*.txt');
iso_num = length(iso_list);

exergy_OP = ones(251,251)*1e7;
RH_OP = zeros(251,251);Sor_OP = zeros(251,251);
p = parpool('local',40);
parfor i = 1:251
    Y = i/10-0.1;
    for j = 1:251
        T = j/5-0.2;
        RH_OP(i,j) = RH_cal(T+273.15,Y/1000,101325);
        for k = 1:6
            data_name = ['F:\ywj\matlab\map_NASA_day\Isotherm\',iso_list(k).name];
            Ex = cal_SBCool(RH_OP(i,j),T,101325,data_name);
            if Ex == 0
                continue;
            end
            
            if Ex < exergy_OP(i,j)
                exergy_OP(i,j) = Ex;
                Sor_OP(i,j) = k;
            end
        end
    end
    
end
delete(p);

exergy_OP(exergy_OP==1e7) = 0/0;
Sor_OP(Sor_OP == 0) = 0/0;

save('F:\ywj\matlab\map_NASA_day\Ex_sens_test\Exergy_OP.mat','exergy_OP','Sor_OP','RH_OP')
toc