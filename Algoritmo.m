% Corre o algoritmo com os respetivos dados.
function [solNodosPartida, solNodosDestino, success] = Algoritmo(nodosPartida, nodosDestino, distancias, A, Z)
    % Lista única dos nodos de partida e de destino para obter n que é o máximo.
    nodosUnique = unique([nodosPartida, nodosDestino]);
    n = max(nodosUnique);

    % Inicializar d, P e S.
    d = zeros(1, n);
    P = zeros(1, n);
    S = {};

    % Inicializar as distâncias conforme o algoritmo.
    d(A) = 0;
    for i = 1:n
        rows = nodosPartida == A;
        neighbors = nodosDestino(rows);

        % Apenas aplicável aos vizinhos de A (nodo inicial/partida).
        if ismember(i, neighbors)
            row = nodosPartida == A & nodosDestino == i;
            d(i) = distancias(row);
            P(i) = A;
            S = union(S, num2str(i));
        else
            % Para os não-vizinhos, inicializar com valores por defeito.
            d(i) = inf;
            P(i) = -1;
        end
    end

    j = -1;
    % Entrar em ciclo até j (o vértice com distância mínima atual) for Z (o destino).
    while j ~= Z
        % Repor os valores anteriores.
        min_dist = inf;
        j = -1;

        % Encontrar o vértice de distância mínima.
        for i = 1:n
            if ismember(num2str(i), S) && d(i) < min_dist
                min_dist = d(i);
                j = i;
            end
        end

        % Remover o vértice de distância mínima atual de S, uma vez que já foi
        % processado.
        if (min_dist == inf)
            solNodosPartida = [];
            solNodosDestino = [];
            success = false;
            return
        end
        S(strcmp(S, num2str(j))) = [];

        for i = 1:n
            rows = nodosPartida == j;
            neighbors = nodosDestino(rows);
            % Para todos os valores de i que pertencem aos vizinhos de j...
            if ismember(i, neighbors) && d(i) == inf
                row = find(nodosPartida == j & nodosDestino == i);
                % Verificar se a soma de d(j) + l(j,i) é menor que d(i).
                if (d(j) + distancias(row)) < d(i)
                    % Se sim, aplicar a soma a d(i).
                    d(i) = d(j) + distancias(row(1));
                    P(i) = j;
                    % Apenas fazer a união de S com i se este ainda não
                    % pertencer a S.
                    S = union(S, num2str(i));
                end
            end
        end
    end

    % Converter P a grafo em lista (edges)
    caminho = [];
    v = Z;
    while v ~= A && length(P) >= v && v > 0
        caminho = [v caminho];
        v = P(v);
    end
    caminho = [A caminho];
    solNodosPartida = caminho(1:end-1)';
    solNodosDestino = caminho(2:end)';
    success = true;
end