function Yi = background_correct(Y)
%clear all; close all;
%load 'gpa-4pgcamp_Tc15_7_2_10_27_2009_1712.mat'
%plot(delta_F_median)
%Y = delta_F_median;

w = 15;
if(min(Y)< 0)
   Y = Y + abs(min(Y));
end
win = round(linspace(1,length(Y),w));
delFwin = zeros(1,length(win));
for i = 1:length(win)-1
 delFwin(i) =  quantile(Y(win(i):win(i+1)),.1);
end
delFwin(end) = quantile(Y(win(end-1):win(end)),.1);

b = interp1(win+(w/2),delFwin,1:length(Y),'pchip');

       %  K = 1 - b/max(Y);
       % Y2 = (Y - b) ./ K;

%figure
%hold on
%plot(Y,'k');
%plot(b,'r');
%hold off
%figure;
%plot(Y-b);
%plotyy(1:length(Y),delta_F_median,1:length(Y),Y-b);
Yi = Y-b;


