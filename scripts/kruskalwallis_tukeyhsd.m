close all
[p,tbl,stats] = kruskalwallis(data);
c = multcompare(stats, 'alpha', 0.05, 'ctype', 'hsd')
table = [num2cell(c)]