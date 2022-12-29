%Opção T – Sair do programa:
%Esta opção termina a execução do programa (mas não a do Matlab).
% Ao ser seleccionada o programa apresentará uma mensagem pedindo ao 
% utilizador para confirmar se deseja efectivamente terminar a execução 
% (usando caracteres S/N maiúsculos ou minúsculos). 
% Se a opção for sim o programa termina, se for não o programa volta a apresentar o menu.


executouLerDados = false;
ENTER = 13; % string com a mudança de linha ENTER = char(13)
while true % repetir até obter indicação para terminar 
	prompt = strcat('Menu', ENTER, ' A - Seleccionar ficheiro de dados', ENTER, ' B – Correr Heurística', ENTER,' T - Terminar o programa', ENTER, 'Escolha uma opcao:');
	txt = input(prompt, 's');
	choice = upper(txt); % Converte string em uppercase
	switch choice
		  case 'A'
			  LerDados;
              executouLerDados = true;
		  case 'B'
              % Se o utilizador ainda não tiver executado a Opção A o programa deverá pedir-lhe para o fazer
              if executouLerDados == false
                  disp('Atenção: a Opção "A" deve ser executada primeiro.');
              else
                  % disp('Atenção: a Heurística não está disponível.');
                  Heuristica;
              end
		  case 'T' % 't' ou 'T'
              confirmar = input('Deseja efectivamente terminar a execução? S/N', 's');
              res = upper(confirmar);
              if res == 'S'
                  return; % termina a execução do programa (mas não a do Matlab)
                  % para sair do Matlab invocar a função 'exit' ou 'quit'
              end
	end
end