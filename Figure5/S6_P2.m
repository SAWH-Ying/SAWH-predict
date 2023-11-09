clear;clc;close all
%关于压力的灵敏性分析
tic

iso_list = dir('F:\ywj\matlab\map_NASA_day\Isotherm\*.txt');
iso_num = length(iso_list);

OP = zeros(101,7);RH = zeros(101,1);

for i = 1:101
    OP(i,1) = 120000-(i-1)*500;
    RH(i) = RH_cal(25+273.15,12/1000,OP(i,1));
    for k = 1:6
        data_name = ['F:\ywj\matlab\map_NASA_day\Isotherm\',iso_list(k).name];
        OP(i,k+1) = cal_SBCool(RH(i),25,OP(i,1),data_name);
    end

end
% save('F:\ywj\matlab\map_NASA_day\Ex_sens_test\P_sen2.mat','exergy_OP','P')
figure
hold on
plot(OP(:,1),OP(:,2),'Linewidth',2,'Color',[230,111,81]/255);
plot(OP(:,1),OP(:,3),'Linewidth',2,'Color',[243,162,97]/255);
plot(OP(:,1),OP(:,4),'Linewidth',2,'Color',[232,197,107]/255);
plot(OP(:,1),OP(:,5),'Linewidth',2,'Color',[138,176,125]/255);
plot(OP(:,1),OP(:,6),'Linewidth',2,'Color',[41,157,143]/255);
plot(OP(:,1),OP(:,7),'Linewidth',2,'Color',[40,114,113]/255);
xlabel('P(pa)')
ylabel('energy requirement(kJ/kg)')
legend('MOF801','MOF303','BTDD','Zn2Co3','MIL101','soc')
toc