clear all
close all
data = randn(100, 5);%each column is a different group, organize in this fashion
boxplot(data);
hold on
plot(data', 'o', 'markeredgecolor', 'k', 'markerfacecolor', 'k')