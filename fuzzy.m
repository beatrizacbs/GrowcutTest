%aqui tem a parte de criaÃ§Ã£o dos elementos, que no cÃ³digo jÃ¡ tem alguns
image = imread('mdb010.bmp');
[linha, coluna] = size(image);

Nx = [-1, -1, 1, 0, 1, 1, -1,  0]; 
Ny = [-1, 0, -1, 1,  1, 0, 1, -1];

maximo = 0;
alpha = 0.1; %parÃ¢metro de espalhamento do numero fuzzy
W = 3; %tamanho da vizinhanÃ§a
T = 0.1; %threshold
matriz_pertinencia = zeros(linha, coluna);
for x = 2:(linha - 1)
	for y = 2:(coluna - 1)
		for k = 1:((W^2) - 1)
			
			maximo = maximo + max(0, (1 - image(x + Nx(k), y + Ny(k))/alpha));
            % o problema desse código tá sendo aqui porque na hora de
            % calcular, da sempre negativo, daí ele fica sendo 0 no valor
            % do máximo. Não sei se mudando alguma coisa na equação isso
            % mude, mas É bom tentar e dar uma olhada. No mais, ele tá
            % funcionando. É só a equação mesmo.
			
		end
		
		matriz_pertinencia(x, y) = (maximo - 1)/((W^2) - 1);
		
		if(matriz_pertinencia(x, y) > T)
			
			matriz_pertinencia(x, y) = 1;
			
		else
			
			matriz_pertinencia(x, y) = 0;
			
		end
		
		maximo = 0;
		
	end
end

imshow(matriz_pertinencia);
