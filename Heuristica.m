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

tic;
% Encontrar o caminho mais curto.
[solNodosPartida, solNodosDestino, success] = Algoritmo(nodosPartida, nodosDestino, distancias, A, Z);

if success
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
    [sol2NodosPartida, sol2NodosDestino, success2] = Algoritmo(novoNodosPartida, novoNodosDestino, novoDistancias, A, Z);
    
    if success2
        ms = int2str(round(toc * 1000));
        disp(['Resultado calculado em ' ms ' milisegundos.']);
        
        cla reset;
        
        tmp1 = plot([NaN NaN], [NaN NaN], 'Color', '#ff0000');
        hold on;
        tmp2 = plot([NaN NaN], [NaN NaN], 'Color', '#42eb00');

        g = graph(nodosPartidaRaw, nodosDestinoRaw, distanciasRaw);
        disp((E(:, 4)));
        g.Nodes.Name = (E(:, 4));
        xData = cell2mat(E(:, 2));
        yData = cell2mat(E(:, 3));
        h = plot(g, 'XData', xData, 'YData', yData);

        highlight(h, nodosPartidaRaw, nodosDestinoRaw, 'EdgeColor', '#b0b0b0', 'LineWidth', 1, 'MarkerSize', 6, 'NodeColor', '#777777');
        highlight(h, solNodosPartida, solNodosDestino, 'EdgeColor', '#ff0000', 'LineWidth', 3, 'MarkerSize', 6);
        highlight(h, sol2NodosPartida, sol2NodosDestino, 'EdgeColor', '#42eb00', 'LineWidth', 3, 'MarkerSize', 6);
        
        legend('Caminho Mais Curto', 'Segundo Caminho');
    end
end
