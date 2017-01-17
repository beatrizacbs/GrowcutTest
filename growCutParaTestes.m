name = 'mdb002';
imageName = strcat(name, '.bmp');
fileName = strcat(name, '.mat');
image = imread(imageName);
image = rgb2gray(image);
[linha, coluna, cores] = size(image);
labelimg = load(fileName);
maxC = 600;

%pixels de vizinhança
Nx = [-1, -1, 1, 0, 1, 1, -1,  0]; 
Ny = [-1, 0, -1, 1,  1, 0, 1, -1];
	
image4 = edge(image, 'sobel');
strengthimg = zeros(linha, coluna);

%cria a matriz de força de acordo com os pontos do arquivo
parfor k = 1:linha
    for s = 1:coluna
        if(labelimg(k, s) == -1)
            strengthimg(k, s) = 1;
        else
            strengthimg(k,s) = labelimg(k,s);
        end
    end
end

labelimgc = labelimg;
strengthimgc = strengthimg;
sair = true;
vez = 1;
figure();

while(sair)
    
    parfor i = 2 : (linha-1)
        %tempimg = img(i-1:i+1,:);
        %templabel = labelimg(i-1:i+1,:);
        %tempstr = strengthimg(i-1:i+1,:);
        for j = 2 : (coluna-1)

            if((i == 1 || j == 1) || (i == linha || j == coluna))	
                    %aqui tem nada porque é a parte de borda.	
            else
                labelimgc(i,j) = labelimg(i,j);
                strengthimgc(i, j) = strengthimg(i, j);
                for q = 1 : 8
                    %maxC = max(max(image));
                    g = 1 - (abs((image(i, j)) - (image(i + Nx(q), j + Ny(q)))) / maxC);
                    resultado = g * strengthimg(i + Nx(q), j + Ny(q));
                    %resultado = g * tempstr(2 + Nx(q), j + Ny(q));

                    if((resultado > (strengthimg(i, j))))
                        if((image4(i, j)) == 1)
                           break; 
                        else
                            labelimgc(i,j) = labelimg(i + Nx(q), j + Ny(q));
                            %labelimgc(i,j) = templabel(2 + Nx(q), j + Ny(q));
                            %strengthimgc(i,j) = g * strengthimg(i + Nx(q), j + Ny(q));
                            strengthimgc(i,j) = resultado;
                            %break;
                        end
                    end
                end
            end
        end	
    end
    
    contador = mod(vez, 3);
    
    if(contador == 0) 
       
        imshow(image);
        hold on
        contour(labelimgc,[0 0],'g','linewidth',1);
        hold off
    %set(himg, 'CData', labelimgc);
        drawnow;
    end
    
    vez = vez + 1;
    
    if(isequal(labelimg,labelimgc))
        sair = false;
    end
    labelimg = labelimgc;
    strengthimg = strengthimgc;
    
end

ouro = load
parfor h=1:linha
    for p = 1:coluna
        
    end
end