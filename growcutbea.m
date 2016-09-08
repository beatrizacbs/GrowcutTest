image2 = imread('dog.jpg');
image2 = rgb2gray(image2);
image = imresize(image2, 0.2);
[linha, coluna, cores] = size(image);

Nx = [-1, -1, 1, 0, 1, 1, 1,  0]; 
Ny = [-1, 0, -1, 1,  1, 0, -1, -1];
	
labelimg = zeros(linha, coluna);
strengthimg = zeros(linha, coluna);
%imshow(labelimg);
imshow(image);
%pra fora
[col,lin] = ginput(3); %da o input
for u = 1: 3
    labelimg(int16(lin(u)),int16(col(u))) = 1; % atualiza label
    strengthimg(int16(lin(u)),int16(col(u))) = 1;
end


%pra dentro
[col_in,lin_in] = ginput(3);
for k = 1 : 3
    labelimg(int16(lin_in(k)),int16(col_in(k))) = -1;
    strengthimg(int16(lin_in(k)),int16(col_in(k))) = 1;
end
    
%labelimgc(linha, coluna/3);
%strengtheimgc(linha, coluna/3);
labelimgc = labelimg;
strengthimgc = strengthimg;
sair = true;
vez = 1;
figure();
imshow(labelimgc,[]);
while(sair)
    for i = 1 : linha
        for j = 1 : coluna

            if((i == 1 || j == 1) || (i == linha || j == coluna))	
                    %aqui tem nada porque é a parte de borda.	
                    %PODE SER QUE O ERRO ESTEJA EM DEIXAR ESSAS BORDAS
                    %SOBRANDO.
            else
                labelimgc(i,j) = labelimg(i,j);
                strengthimgc(i, j) = strengthimg(i, j);
                for q = 1 : 8 %8 é o tamalho do array de coordenadas dos vizinhos em relação ao pixel central
                    %aqui os vizinhos atacam o pixel central da máscara.
                    g = 1 - (abs((labelimgc(i, j)) - (labelimgc(i + Nx(q), j + Ny(q)))) / max(max(image)));
                    resultado = g * strengthimgc(i + Nx(q), j + Ny(q));

                    if((resultado > (strengthimgc(i, j))))

                        labelimgc(i,j) = labelimgc(i + Nx(q), j + Ny(q));
                        strengthimgc(i,j) = g * strengthimgc(i + Nx(q), j + Ny(q));
                        
                    end
                end
            end
        end	
    end
    
    contador = mod(vez, 10);
    %mostra a imagem a cada 10 interações para verificar o andamento do
    %algoritmo
    if(contador == 0) 
        figure();
        imshow(labelimgc,[]);
    end
    
    vez = vez + 1;
    
    if(labelimg == labelimgc)
        sair = false;
    end
end

