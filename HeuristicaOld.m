% Initialize variables
A = 1;
Z = 50;
distancias = Dados(:, 4);
nodosPartida = Dados(:, 2);
nodosDestino = Dados(:, 3);

% Lista única dos nodos de partida e de destino para obter n que é o máximo.
nodosUnique = unique([nodosPartida, nodosDestino]);
n = max(nodosUnique);

d = zeros(1, n);
P = zeros(1, n);
S = zeros(1, n);

% Initialize distances and predecessors
d(A) = 0;
for i = 1:n
    rows = find(nodosPartida == A);
    neighbors = nodosDestino(rows);
    
    if ismember(i, neighbors)
        row = find(nodosPartida == A & nodosDestino == i);
        d(i) = distancias(row);
        P(i) = A;
    else
        d(i) = inf;
        P(i) = -1;
    end
end

% Loop until we reach the terminal vertex or there are no more vertices in S
while true
    % Find the vertex with the smallest distance in S
    min_dist = inf;
    min_vertex = -1;
    for i = 1:n
        if ismember(i, S) && d(i) < min_dist
            min_dist = d(i);
            min_vertex = i;
        end
    end
    
    % If the minimum distance vertex is the terminal vertex, we're done
    if min_vertex == Z
        break;
    end
    
    % Remove the minimum distance vertex from S
    index = find(ismember(S, min_vertex));
    S(index) = [];
    
    % Update distances and predecessors for each neighbor of the minimum distance vertex
    for i = 1:n
        rows = find(nodosPartida == min_vertex);
        neighbors = nodosDestino(rows);
        
        row = find(nodosPartida == min_vertex & nodosDestino == i);
        if ismember(i, neighbors) && (d(min_vertex) + nodosDestino(row)) < d(i)
            d(i) = d(min_vertex) + nodosDestino(row);
            P(i) = min_vertex;
            S = union(S, {i});
        end
    end
end

% Initialize the incidence matrix M as a matrix of zeros with the same number of rows as the number of vertices and the same number of columns as the number of arcs in the graph
M = zeros(num_vertices, num_arcs);

% For each element i in the set of predecessors P, set the element M(i, j) to 1, where j is the index of the arc from i to P(i) in the data
for i = 1:num_vertices
    if P(i) ~= -1
        % Find the index of the arc from i to P(i) in the data
        arc_index = nodosPartida == i & nodosDestino == P(i);
        % Set the element M(i, j) to 1
        M(i, arc_index) = 1;
    end
end

% For the starting vertex A, set the element M(A, j) to -1
% where j is the index of the arc from A to P(A) in the data

arc_index = find(nodosPartida == A & nodosDestino == P(A));
M(A, arc_index) = -1;

dlmwrite('incidence_matrix.txt', M, 'delimiter', '\t');
