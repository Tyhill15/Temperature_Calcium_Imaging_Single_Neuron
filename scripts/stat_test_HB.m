prompt = 'Paste all data columns(no names)';
total_data = input(prompt);
prompt = 'Paste all column names';
genotypes_cell = input(prompt)
genotypes = [];
for i = 1:length(genotypes_cell)
    geno = genotypes_cell{i};
    genotypes(end+1) = geno
end
