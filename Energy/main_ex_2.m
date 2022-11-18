clear;clc;close all
%能耗主函数
tic
% Ex_aver = ones(361,576) * 1e7;Sor_aver = zeros(361,576);

iso_list = dir('F:\ywj\matlab\map_NASA_day\Isotherm\*.txt');
iso_num = length(iso_list);

p = parpool('local',40);
for n = 271:280
    load(['F:\ywj\matlab\map_NASA_day\Ex_par_save\evr_data_save\evr',num2str(n),'.mat']);
    Ex_aver = ones(361,576) * 1e7;Sor_aver = zeros(361,576);
    parfor i = 1:361
        for j = 1:576
%             Exergy = 0;
            
            if T_aver(i,j)<273.15 || isnan(RH_aver(i,j))
                continue;
            end
            
            for k = 1:iso_num
                
                data_name = ['F:\ywj\matlab\map_NASA_day\Isotherm\',iso_list(k).name];
                Exergy = cal_SBCool(RH_aver(i,j),T_aver(i,j)-273.15,P_aver(i,j),data_name);
                
                if Exergy == 0
                    continue;
                end
                
                if Exergy < Ex_aver(i,j)
                    Ex_aver(i,j) = Exergy;
                    Sor_aver(i,j) = k;
                end
                
            end
            
        end
    end
save(['F:\ywj\matlab\map_NASA_day\Ex_par_save\ex_data_save\evr',num2str(n),'.mat'],'Ex_aver','Sor_aver');
end
delete(p);
toc



