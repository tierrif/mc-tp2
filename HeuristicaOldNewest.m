% Initialize variables
A = 1;
Z = 50;
k = 2;
distanciasRaw = Dados(:, 4);
nodosPartidaRaw = Dados(:, 2);
nodosDestinoRaw = Dados(:, 3);

% Create an empty matrix to store the new entries
new_nodes = [];

for i = 1:length(nodosPartidaRaw)
    % Check if the departure node is in the destination node vector
    % Add the departure node to the new_nodes matrix
    new_nodes = [new_nodes; [nodosDestinoRaw(i) nodosPartidaRaw(i)]];
end

% Append the new_nodes matrix to the departure and destination node vectors
nodosPartida = [nodosPartidaRaw; new_nodes(:,1)];
nodosDestino = [nodosDestinoRaw; new_nodes(:,2)];
distancias = [distanciasRaw; distanciasRaw];

% Lista única dos nodos de partida e de destino para obter n que é o máximo.
nodosUnique = unique([nodosPartida, nodosDestino]);
n = max(nodosUnique);

d = zeros(1, n);
P = zeros(1, n);
S = {};

% Initialize distances and predecessors
d(A) = 0;
for i = 1:n
    rows = find(nodosPartida == A);
    neighbors = nodosDestino(rows);
    
    if ismember(i, neighbors)
        row = find(nodosPartida == A & nodosDestino == i);
        d(i) = distancias(row);
        P(i) = A;
        S = union(S, num2str(i));
    else
        d(i) = inf;
        P(i) = -1;
    end
end

disp(S);

% Find the vertex with the smallest distance in S

% Loop until we reach the terminal vertex or there are no more vertices in S
path_count = 0;
while true
    min_dist = inf;
    min_vertex = -1;
    
    for i = 1:n
        if ismember(num2str(i), S) && d(i) < min_dist
            min_dist = d(i);
            min_vertex = i;
        end
    end
    
    if (isempty(S))
        break;
    end
    
    % If the minimum distance vertex is the terminal vertex, increment the path count
    if min_vertex == Z
        path_count = path_count + 1;
        % If we have found two paths, we're done
        if path_count == k
            break;
        end
    end
   
    
    % Remove the minimum distance vertex from S
    % index = find(ismember(num2str(min_vertex), S));
    S(strcmp(S, num2str(min_vertex))) = [];
    disp(S);
    
    for i = 1:n
        rows = find(nodosPartida == min_vertex);
        neighbors = nodosDestino(rows);

        if ismember(i, neighbors) && d(i) == inf
            row = find(nodosPartida == min_vertex & nodosDestino == i);
            if (d(min_vertex) + distancias(row)) < d(i)
                d(i) = d(min_vertex) + distancias(row);
                P(i) = min_vertex;
                if ~ismember({num2str(i)}, S)
                    S = union(S, num2str(i));
                end
            end
        end
    end
end

path = [];
current_vertex = Z;
while current_vertex ~= A
    path = [current_vertex path];
    current_vertex = P(current_vertex);
end
path = [A path];
edges = [path(1:end-1); path(2:end)]';

for i = 1:size(edges, 1)
    start_vertex = edges(i, 1);
    end_vertex = edges(i, 2);
    distance_row = find(nodosPartida == start_vertex & nodosDestino == end_vertex);
    distance = distancias(distance_row);
    edges(i, 3) = distance;
end

G = graph(edges(:,1), edges(:,2), edges(:,3));

plot(G);
dlmwrite('incidence_matrix.txt', P, 'delimiter', '\t');

