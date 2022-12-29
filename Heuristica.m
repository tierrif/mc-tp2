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
    rows = find(nodosPartida == A);
    neighbors = nodosDestino(rows);
    
    % Apenas aplicável aos vizinhos de A (nodo inicial/partida).
    if ismember(i, neighbors)
        row = find(nodosPartida == A & nodosDestino == i);
        d(i) = distancias(row);
        P(i) = A;
        S = union(S, num2str(i));
    else
        % Para os não-vizinhos, inicializar com valores por defeito.
        d(i) = inf;
        P(i) = -1;
    end
end


% Entrar em ciclo até j (o vértice com distância mínima atual) for Z (o destino).
while true
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
    
    % Se j for Z, acabámos (END no algoritmo).
    if j == Z
        break;
    end
   
    
    % Remover o vértice de distância mínima atual de S, uma vez que já foi
    % processado.
    S(strcmp(S, num2str(j))) = [];
    
    for i = 1:n
        rows = find(nodosPartida == j);
        neighbors = nodosDestino(rows);
        % Para todos os valores de i que pertencem aos vizinhos de j...
        if ismember(i, neighbors) && d(i) == inf
            row = find(nodosPartida == j & nodosDestino == i);
            % Verificar se a soma de d(j) + l(j,i) é menor que d(i).
            if (d(j) + distancias(row)) < d(i)
                % Se sim, aplicar a soma a d(i).
                d(i) = d(j) + distancias(row);
                P(i) = j;
                % Apenas fazer a união de S com i se este ainda não
                % pertencer a S.
                if ~ismember({num2str(i)}, S)
                    S = union(S, num2str(i));
                end
            end
        end
    end
end

% Converter P a grafo em lista (edges)
caminho = [];
v = Z;
while v ~= A
    caminho = [v caminho];
    v = P(v);
end
caminho = [A caminho];
edges = [caminho(1:end-1); caminho(2:end)]';

% Definir distâncias
distances = zeros(size(edges, 1), 1);
for i = 1:size(edges, 1)
    nodo1 = edges(i, 1);
    nodo2 = edges(i, 2);
    iDistancia = find(nodosPartida == nodo1 & nodosDestino == nodo2);
    distances(i) = distancias(iDistancia);
end

% Caminho 1 encontrado.
