% Inicializar A e Z
A = -1;
Z = -1;
while (~isnumeric(A) || A < 1)
    A = input('Insira o valor de A (nodo de partida): ');
end
while (~isnumeric(Z) || Z < 1)
    Z = input('Insira o valor de Z (nodo de destino): ');
end

distanciasRaw = M(:, 4);
nodosPartidaRaw = M(:, 2);
nodosDestinoRaw = M(:, 3);

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

k = input('Insira um valor de k (número de caminhos): ');
tic;
caminhosPartida = [];
caminhosDestino = [];
for j = 1:k
    % Encontrar o caminho mais curto.
    [solNodosPartida, solNodosDestino, success] = Algoritmo(nodosPartida, nodosDestino, distancias, A, Z);

    if success
        caminhosPartida = [caminhosPartida; {solNodosPartida}];
        caminhosDestino = [caminhosDestino; {solNodosDestino}];
        % Alterar o valor: transformar cada aresta num arco (orientação única
        % direcionada à origem).

        % Iterar todos os nodos do caminho mais curto.
        for i = 1:length(solNodosPartida)
            % Encontrar índice atual se aplicável.
            index = find(nodosPartida == solNodosPartida(i) & nodosDestino == solNodosDestino(i));

            % Remove arco se existe.
            nodosPartida(index) = [];
            nodosDestino(index) = [];
            distancias(index) = [];
        end

        for i = 1:length(solNodosPartida)
            % Encontrar índice do arco para a direção oposta.
            index = find(nodosPartida == solNodosDestino(i) & nodosDestino == solNodosPartida(i));

            distancias(index) = -1;
        end
    else
        disp(['Só foram encontrados ' int2str((j - 1)) ' caminhos.']);
        break;
    end
end

ms = int2str(round(toc * 1000));
disp(['Resultado calculado em ' ms ' milisegundos.']);

cla reset;

plot([NaN NaN], [NaN NaN], 'Color', '#c20202', 'LineWidth', 4);
hold on;

g = graph(nodosPartidaRaw, nodosDestinoRaw, distanciasRaw);
g.Nodes.Name = (E(:, 4));
xData = cell2mat(E(:, 2));
yData = cell2mat(E(:, 3));
h = plot(g, 'XData', xData, 'YData', yData);

highlight(h, nodosPartidaRaw, nodosDestinoRaw, 'EdgeColor', '#b0b0b0', 'LineWidth', 1, 'MarkerSize', 6, 'NodeColor', '#777777');
highlight(h, A, 'NodeColor', '#ffaa00');
highlight(h, Z, 'NodeColor', '#005396');
colors = rand([100 3]);

for i = 1:length(caminhosPartida)
    caminhoPartida = cell2mat(caminhosPartida(i));
    caminhoDestino = cell2mat(caminhosDestino(i));
    
    if ~isempty(caminhoPartida)
        if i == 1
            highlight(h, caminhoPartida, caminhoDestino, 'EdgeColor', '#c20202', 'LineWidth', 4, 'MarkerSize', 6);
        else
            randomIndex = randi(length(colors), 1);
            color = colors(randomIndex, :);
            highlight(h, caminhoPartida, caminhoDestino, 'EdgeColor', color, 'LineWidth', 2, 'MarkerSize', 6);
        end
    end
end

legend('Caminho Mais Curto');
