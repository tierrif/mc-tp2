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

% Converter P a grafo em lista (edges)
path = [];
current_vertex = Z;
while current_vertex ~= A
    path = [current_vertex path];
    current_vertex = P(current_vertex);
end
path = [A path];
edges = [path(1:end-1); path(2:end)]';

% Definir distâncias
distances = zeros(size(edges, 1), 1);
for i = 1:size(edges, 1)
    node1 = edges(i, 1);
    node2 = edges(i, 2);
    distance_index = find(nodosPartida == node1 & nodosDestino == node2);
    distances(i) = distancias(distance_index);
end

% Passo 2 do algoritmo em 3.1.
for i = 1:length(path)-1
    start_node = path(i);
    end_node = path(i+1);
    row = find(nodosPartida == start_node & nodosDestino == end_node);
    nodosPartida(row) = end_node;
    nodosDestino(row) = start_node;
    distancias(row) = -distancias(row);
end

% Passo 3 do algoritmo em 3.1.
vertices_on_path = path;
vertices = [];
for i = 1:length(vertices_on_path)
    % split vertex into two colocated subvertices
    v_1 = vertices_on_path(i) + n;
    v_2 = vertices_on_path(i) + 2*n;
    vertices = [vertices; v_1; v_2];
    
    % add arc of length zero between subvertices, directed towards source vertex
    edges = [edges; v_1 v_2];
    distances = [distances; 0];
    
    % replace external edges connected to vertex with two oppositely directed arcs of same length
    % connected to subvertices
    edge_indices = find(edges(:,1) == vertices_on_path(i) | edges(:,2) == vertices_on_path(i));
    for j = 1:length(edge_indices)
        if edges(edge_indices(j), 1) == vertices_on_path(i)
            edges = [edges; v_1 edges(edge_indices(j), 2)];
            distances = [distances; distances(edge_indices(j))];
            edges = [edges; edges(edge_indices(j), 2) v_2];
            distances = [distances; distances(edge_indices(j))];
        else
            edges = [edges; v_1 edges(edge_indices(j), 1)];
            distances = [distances; distances(edge_indices(j))];
            edges = [edges; edges(edge_indices(j), 1) v_2];
            distances = [distances; distances(edge_indices(j))];
        end
    end
end

% Get all the vertices on the shortest path
vertices_on_path = unique(path);

% Find all the edges that are connected to a vertex on the shortest path
edge_indices = find(ismember(edges(:,1), vertices_on_path) | ismember(edges(:,2), vertices_on_path));

% For each edge connected to a vertex on the shortest path
for i = 1:length(edge_indices)
  % If the edge originates from a vertex on the shortest path
  if ismember(edges(edge_indices(i), 1), vertices_on_path)
    % Add an edge from the double-primed subvertex to the other endpoint of the edge
    edges = [edges; edges(edge_indices(i), 1)+2*n edges(edge_indices(i), 2)];
    distances = [distances; distances(edge_indices(i))];
  % If the edge terminates at a vertex on the shortest path
  else
    % Add an edge from the other endpoint of the edge to the primed subvertex
    edges = [edges; edges(edge_indices(i), 1) edges(edge_indices(i), 2)+n];
    distances = [distances; distances(edge_indices(i))];
  end
end

for i = 1:length(vertices_on_path)
    edge_indices = find(edges(:,1) == vertices_on_path(i) | edges(:,2) == vertices_on_path(i));
    for j = 1:length(edge_indices)
        if edges(edge_indices(j), 1) == vertices_on_path(i)
            other_vertex = edges(edge_indices(j), 2);
            edges = [edges; vertices_on_path(i)+n other_vertex];
            distances = [distances; distances(edge_indices(j))];
            edges = [edges; other_vertex vertices_on_path(i)+2*n];
            distances = [distances; distances(edge_indices(j))];
        else
            other_vertex = edges(edge_indices(j), 1);
            edges = [edges; vertices_on_path(i)+n other_vertex];
            distances = [distances; distances(edge_indices(j))];
            edges = [edges; other_vertex vertices_on_path(i)+2*n];
            distances = [distances; distances(edge_indices(j))];
        end
        edges(edge_indices(j),:) = [];
        distances(edge_indices(j)) = [];
    end
end

% Append the new_nodes matrix to the departure and destination node vectors
nodosPartida = edges(:,1);
nodosDestino = edges(:,2);
distancias = distances;

% Lista única dos nodos de partida e de destino para obter n que é o máximo.
nodosUnique = unique([nodosPartida, nodosDestino]);
n = max(nodosUnique);

d2 = zeros(1, n);
P2 = zeros(1, n);
S2 = {};

% Initialize distances and predecessors
d2(A) = 0;
for i = 1:n
    rows = find(nodosPartida == A);
    neighbors = nodosDestino(rows);
    
    if ismember(i, neighbors)
        row = find(nodosPartida == A & nodosDestino == i);
        d2(i) = distancias(row);
        P2(i) = A;
        S2 = union(S2, num2str(i));
    else
        d2(i) = inf;
        P2(i) = -1;
    end
end

disp(S2);

% Find the vertex with the smallest distance in S

% Loop until we reach the terminal vertex or there are no more vertices in S
path_count = 0;
while true
    min_dist = inf;
    min_vertex = -1;
    
    for i = 1:n
        if ismember(num2str(i), S2) && d2(i) < min_dist
            min_dist = d2(i);
            min_vertex = i;
        end
    end
    
    if (isempty(S2))
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
    S2(strcmp(S2, num2str(min_vertex))) = [];
    disp(S2);
    
    for i = 1:n
        rows = find(nodosPartida == min_vertex);
        neighbors = nodosDestino(rows);

        if ismember(i, neighbors) && d2(i) == inf
            row = find(nodosPartida == min_vertex & nodosDestino == i);
            if (d2(min_vertex) + distancias(row)) < d2(i)
                d2(i) = d2(min_vertex) + distancias(row);
                P2(i) = min_vertex;
                if ~ismember({num2str(i)}, S2)
                    S2 = union(S2, num2str(i));
                end
            end
        end
    end
end

disp('over')