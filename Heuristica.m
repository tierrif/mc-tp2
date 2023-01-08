% Inicializar A e Z
A = 1;
Z = 50;
distanciasRaw = Dados(:, 4);
nodosPartidaRaw = Dados(:, 2);
nodosDestinoRaw = Dados(:, 3);

% Fazer com que os nodos de partida sejam nodos de destino e vice-versa.
new_nodes = [];
for i = 1:length(nodosPartidaRaw)
    % Adicionar o nodo de partida atual como nodo de destino do nodo de
    % destino atual e vice-versa.
    new_nodes = [new_nodes; [nodosDestinoRaw(i) nodosPartidaRaw(i)]];
end

% Criar os nodos de partida e de destino, já preenchidos pelos recíprocos.
nodosPartida = [nodosPartidaRaw; new_nodes(:,1)];
nodosDestino = [nodosDestinoRaw; new_nodes(:,2)];

% Fazer o mesmo para as distâncias, mas simplesmente duplicá-las.
distancias = [distanciasRaw; distanciasRaw];

tic;
% Encontrar o caminho mais curto.
[solNodosPartida, solNodosDestino] = Algoritmo(nodosPartida, nodosDestino, distancias, A, Z);

% Alterar o valor: transformar cada aresta num arco (orientação única
% direcionada à origem).

% Criar cópia das listas originais
novoNodosPartida = nodosPartida(:);
novoNodosDestino = nodosDestino(:);
novoDistancias = distancias(:);

% Iterar todos os nodos do caminho mais curto.
for i = 1:length(solNodosPartida)
    % Encontrar índice atual se aplicável.
    index = find(novoNodosPartida == solNodosPartida(i) & novoNodosDestino == solNodosDestino(i));
    
    % Remove arco se existe.
    novoNodosPartida(index) = [];
    novoNodosDestino(index) = [];
    novoDistancias(index) = [];
end

for i = 1:length(solNodosPartida)
    % Encontrar índice do arco para a direção oposta.
    index = find(novoNodosPartida == solNodosDestino(i) & novoNodosDestino == solNodosPartida(i));
    
    novoDistancias(index) = -1;
end

% Correr o algoritmo de novo com os novos dados.
[sol2NodosPartida, sol2NodosDestino] = Algoritmo(novoNodosPartida, novoNodosDestino, novoDistancias, A, Z);

ms = int2str(round(toc * 1000));
disp(['Resultado calculado em ' ms ' milisegundos.']);

g = graph(nodosPartidaRaw, nodosDestinoRaw, distanciasRaw);
h = plot(g);

highlight(h, nodosPartidaRaw, nodosDestinoRaw, 'EdgeColor', 'k', 'LineWidth', 2, 'MarkerSize', 6, 'NodeColor', 'k');
highlight(h, solNodosPartida, solNodosDestino, 'EdgeColor', 'b', 'LineWidth', 2, 'MarkerSize', 6);
highlight(h, sol2NodosPartida, sol2NodosDestino, 'EdgeColor', 'r', 'LineWidth', 2, 'MarkerSize', 6);


