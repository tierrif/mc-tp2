% Carregar dados do ficheiro aplicável.
Dados = importdata('germany50.txt');

% Guardar dados no ficheiro .mat.
save('germany50.mat', 'Dados');
