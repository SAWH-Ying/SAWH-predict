function [] = wt_evr_cal(T,Y,P,R,n)
% 将环境数据变为吸附解吸工况下的RH
% 必须与主函数一起用，非并行运算代码见main_wt

ad_hum = zeros(361,576);de_hum = zeros(361,576);
ad_temp = zeros(361,576);de_temp = zeros(361,576);

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
        
        de_temp(i,j) = day_T+sqrt((3.555/0.0580)^2+(1.85*0.5*day_R)/(1.85*0.029))-3.555/0.058;
        ad_temp(i,j) = night_T;
        
        if night_T < 273.15 || de_temp(i,j) < 273.15
            continue;
        end

        Tc = day_T + 8 - 273.15;
        Psat = exp(-1.0440397e4/(Tc*9/5+32+459.67) ...
            -1.129465e1 ...
            -2.7022352e-2*(Tc*9/5+32+459.67) ...
            +1.289036e-5*(Tc*9/5+32+459.67)^2 ...
            -2.4780681e-9*(Tc*9/5+32+459.67)^3 ...
            +6.5459673*log(Tc*9/5+32+459.67))*6890;
        Y_de = 621.945/1000 * 100/100 / (day_P/Psat - 100/100);

        day_RH = RH_cal(de_temp(i,j),Y_de,day_P);
        night_RH = RH_cal(ad_temp(i,j),night_Y,night_P);

        ad_hum(i,j) = 100*exp(log(night_RH/100)*(ad_temp(i,j)/298.15));
        de_hum(i,j) = 100*exp(log(day_RH/100)*(de_temp(i,j)/343.15));
        
    end
end

save(['F:\ywj\matlab\map_NASA_day\wt_par_save\evr_data_save\hum',num2str(n),'.mat'],'ad_hum','de_hum')
save(['F:\ywj\matlab\map_NASA_day\wt_par_save\evr_data_save\temp',num2str(n),'.mat'],'ad_temp','de_temp')
