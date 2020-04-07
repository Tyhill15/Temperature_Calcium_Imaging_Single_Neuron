clear all
close all


%BASES = ['A' 'T' 'G' 'C'];
BASES = [1 2 3 4]
c = 1;
shared_seq = BASES(randi(4,200,1));
for j = 1:100
    frag_1_length = randi(1000,1);
    frag_2_length = 1000-frag_1_length;
    
    gene(c).unique_seq1 = BASES(randi(4,frag_1_length,1));
    gene(c).unique_seq2 = BASES(randi(4,frag_2_length,1));
    gene(c).complete_seq = horzcat(gene(c).unique_seq1, shared_seq, gene(c).unique_seq2);
    gene(c).shared_seq_index = strfind(gene(c).complete_seq, shared_seq);
    gene(c).align = gene(c).complete_seq(gene(c).shared_seq_index:end);
    c = c + 1;
end
all_genes = vertcat(gene.complete_seq);
all_genes_aligned = catpad(1, gene.align);
imagesc(all_genes_aligned)
