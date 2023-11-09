clear;clc;close all
load Exergy_OP
%%
figure
set(gca,'LooseInset',[0 0 0 0])
pcolor(0:0.2:50,0:0.1:25,exergy_OP);
shading flat
colormap(parula)
colorbar
title(' ')
caxis([0,5000])
%%
figure
set(gca,'LooseInset',[0 0 0 0])
mesh(0:0.2:50,0:0.1:25,exergy_OP)
view(0,90)
shading flat
colormap(parula)
colorbar
title(' ')
caxis([0,5000])
%%
mycol = [
    230,111,81;
    243,162,97;
    232,197,107;
    138,176,125;
    41,157,143;
    40,114,113;]/255;
figure
set(gca,'LooseInset',[0 0 0 0])
mesh(0:0.2:50,0:0.1:25,Sor_OP)
view(0,90)
colormap(mycol)
title(' ')
colorbar
