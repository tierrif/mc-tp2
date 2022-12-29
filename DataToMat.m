% Load the data from the text file
data = importdata('germany50.txt');

% Extract the variables from the data structure
Dados = data.data;

% Save the variables to a .mat file
save('germany50.mat', 'Dados');