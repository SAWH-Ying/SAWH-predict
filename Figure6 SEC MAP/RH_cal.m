function [RH] = RH_cal(T,Y,P)
% 相对湿度计算函数
% input:T temperature [K]
%       D specific humidity [g/gkga]
%       P surface pressure [pa]
T = T - 273.15;
if T < 0
%     P_sat = exp(-1.0214165e4/(T*9/5+32+459.67) ...
%         -4.8932428 ...
%         -5.3765794e-3*(T*9/5+32+459.67) ...
%         +1.9202377e-7*(T*9/5+32+459.67)^2 ...
%         +3.5575832e-10*(T*9/5+32+459.67)^3 ...
%         -9.0344688e-14*(T*9/5+32+459.67)^4 ...
%         +4.1635019*log(T*9/5+32+459.67))*6890;
RH = 0/0;
else
    P_sat = exp(-1.0440397e4/(T*9/5+32+459.67) ...
        -1.129465e1 ...
        -2.7022352e-2*(T*9/5+32+459.67) ...
        +1.289036e-5*(T*9/5+32+459.67)^2 ...
        -2.4780681e-9*(T*9/5+32+459.67)^3 ...
        +6.5459673*log(T*9/5+32+459.67))*6890;
    RH =  P/P_sat/(0.621945/Y+1)*100;
end


if RH > 100 || RH < 0
    RH = 0/0;
end



