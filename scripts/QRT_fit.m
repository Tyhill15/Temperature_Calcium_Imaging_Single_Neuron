close all
x = hour';
y = gcy_23';
figure(1)
[fo1 go1] = fit(x,y,'exp2')%%%%%taken from cflibhelp/routed to doc from help
plot(fo1)
hold on
plot(x,y, 'o')

figure(2)
s2 = fitoptions('Method','NonlinearLeastSquares','StartPoint',[3 1 15 2 0.1]);
s1 = fitoptions('Method','NonlinearLeastSquares','StartPoint',[5 1 15]);

pmexp2 = fittype('a*(1-exp(-x/b))+c+d*(1-exp(-x/e))','options',s2);
pmexp1 = fittype('a*(1-exp(-x/b))+c','options',s1);

[fo2 go2] = fit(x,y,pmexp2)
plot(fo2,'b')
hold on
plot(x,y, 'o')

figure(3)
[fo3 go3]  = fit(x,y,pmexp1)
plot(fo3,'g')
hold on
plot(x,y, 'o')
