% Carregar dados do ficheiro aplicável.
Dados = importdata('germany50.txt');

% Importar outros dados de cities.txt e adicionar à variável Dados.
Extras = readtable('cities.txt');

% Guardar dados no ficheiro .mat.
save('germany50.mat', 'Dados', 'Extras');