%%Imagens para o artigo


foto = imread('foto19.jpg');
fotocortada = imcrop(foto,[43.5100 69.5100 235.9800 145.9800]); %fica 146X236
% figure(1);
% imshow(foto);
% title('Imagem Original');
% figure(2);
% imshow(fotocortada);
% title('Imagem Cortada');
% 
% 
% 
% 
level = graythresh(fotocortada);
fotobinaria = im2bw(fotocortada,level);

figure(1);
%imshow(fotobinaria);


m2 = sum(~fotobinaria,1);
m = medfilt1(m2);
% figure(1);
subplot(3,1,1);
imshow(fotobinaria);
% stem(m2);
title('Imagem Binarizada');
% xlabel('Colunas');
% ylabel('Amplitude');
% legend('Original');
subplot(3,1,2);
stem(m);
title('Assinatura Padrão');
hold on;
stem(37,120,'k');
stem(59,120,'k');
stem(62,120,'k');
stem(99 ,120,'k');
stem(102,120,'k');
stem(138,120,'k');
stem(146,120,'k');
stem(186,120,'k');
hold off;
% xlabel('Colunas');
% ylabel('Amplitude');
% legend('Filtrado');

% quatro = m(1,145:185);
% figure(5);
% stem(quatro);
% title('Assinatura Número 0')
% xlabel('Colunas');
% ylabel('Amplitude');

%--------- VERIFICAR O PRIMEIRO DIGITO---------%
for n=45:1:48
    primeiro_digito(n)=m(n);
end
aux = max(primeiro_digito);
if aux >= 15 && aux <= 100
    seg_primeiro_digito = 2;
else
    seg_primeiro_digito = 0;
end
valor_final(1)=seg_primeiro_digito; %PRIMEIRO VALOR
% subplot(3,1,3);
% stem(primeiro_digito);
%--------FIM DO PRIMEIRO DIGITO -------------%
%-----------VERIFICAR SEGUNDO DIGITO---------%
%parte esquerda do digito
for n=60:1:66
    segundo_digito_esquerda(n)=m(n);
end
aux = max(segundo_digito_esquerda);
if aux >=16 && aux <54
    seg_segundo_digito_esquerda = 1; % 1 segmento ligado
elseif aux >= 54 && aux <= 80
    seg_segundo_digito_esquerda = 2; % 2 segmentos ligados
else 
    seg_segundo_digito_esquerda = 0; % nenhum ligado
end
valor_final(2)=seg_segundo_digito_esquerda;

%parte meio do digito
for n=77:1:79
    segundo_digito_meio(n)=m(n);
end
aux = max(segundo_digito_meio);
if aux >= 5 && aux < 14
    seg_segundo_digito_meio=1; % 1 segmento ligado
elseif aux >= 14 && aux <= 20
    seg_segundo_digito_meio=2; % 2 segmentos ligados
elseif aux > 20 && aux <= 35
    seg_segundo_digito_meio=3; % 3 segmentos ligados
else
    seg_segundo_digito_meio=0; % nenhum ligado
end
valor_final(3)=seg_segundo_digito_meio;

%parte direita do digito
for n=89:1:94
    segundo_digito_direita(n)=m(n);
end
aux = max(segundo_digito_direita);
if aux >=15 && aux <= 60
    seg_segundo_digito_direita=1; % 1 segmento ligado
elseif aux >61 && aux <= 80
    seg_segundo_digito_direita=2; % 2 segmentos ligados
else
    seg_segundo_digito_direita=0; % nenhum ligado
end
valor_final(4)=seg_segundo_digito_direita;
%--------FIM DO SEGUNDO DIGITO -------------%
%-----------VERIFICAR TERCEIRO DIGITO---------%
%parte esquerda do digito
for n=108:1:114
    terceiro_digito_esquerda(n)=m(n);
end
aux = max(terceiro_digito_esquerda);
if aux >=18 && aux <= 60
    seg_terceiro_digito_esquerda = 1; % 1 segmento ligado
elseif aux > 60 && aux <= 100
    seg_terceiro_digito_esquerda = 2; % 2 segmentos ligados
else 
    seg_terceiro_digito_esquerda = 0; % nenhum ligado
end
valor_final(5)=seg_terceiro_digito_esquerda;

%parte meio do digito
for n=120:1:124
    terceiro_digito_meio(n)=m(n);
end
aux = max(terceiro_digito_meio);
if aux >= 1 && aux < 13
    seg_terceiro_digito_meio=1; % 1 segmento ligado
elseif aux >= 13 && aux < 20
    seg_terceiro_digito_meio=2; % 2 segmentos ligados
elseif aux >= 20 && aux <= 100
    seg_terceiro_digito_meio=3; % 3 segmentos ligados
else
    seg_terceiro_digito_meio=0; % nenhum ligado
end
valor_final(6)=seg_terceiro_digito_meio;

%parte direita do digito
for n=132:1:135
    terceiro_digito_direita(n)=m(n);
end
aux = max(terceiro_digito_direita);
if aux >=13 && aux <= 64
    seg_terceiro_digito_direita=1; % 1 segmento ligado
elseif aux >= 65 && aux <= 100
    seg_terceiro_digito_direita=2; % 2 segmentos ligados
else
    seg_terceiro_digito_direita=0; % nenhum ligado
end
valor_final(7)=seg_terceiro_digito_direita;
%--------FIM DO TERCEIRO DIGITO -------------%
% %-----------VERIFICAR QUARTO DIGITO---------%
%parte esquerda do digito
for n=149:1:155
    quarto_digito_esquerda(n)=m(n);
end
aux = max(quarto_digito_esquerda);
if aux >=13 && aux < 57
    seg_quarto_digito_esquerda = 1; % 1 segmento ligado
elseif aux >=57 && aux <= 100
    seg_quarto_digito_esquerda = 2; % 2 segmentos ligados
else 
    seg_quarto_digito_esquerda = 0; % nenhum ligado
end
valor_final(8)=seg_quarto_digito_esquerda;

%parte meio do digito
for n=165:1:167
    quarto_digito_meio(n)=m(n);
end
aux = max(quarto_digito_meio);
if aux >= 5 && aux <= 10
    seg_quarto_digito_meio=1; % 1 segmento ligado
elseif aux >10 && aux <= 18
    seg_quarto_digito_meio=2; % 2 segmentos ligados
elseif aux > 16 && aux <= 36
    seg_quarto_digito_meio=3; % 3 segmentos ligados
else
    seg_quarto_digito_meio=0; % nenhum ligado
end
valor_final(9)=seg_quarto_digito_meio;

%parte direita do digito
for n=175:1:182
    quarto_digito_direita(n)=m(n);
end
aux = max(quarto_digito_direita);
if aux >=15 && aux < 63
    seg_quarto_digito_direita=1; % 1 segmento ligado
elseif aux >= 63 && aux <= 150
    seg_quarto_digito_direita=2; % 2 segmentos ligados
else
    seg_quarto_digito_direita=0; % nenhum ligado
end
valor_final(10)=seg_quarto_digito_direita;
%--------FIM DO TERCEIRO DIGITO -------------%


% vetor valor final possui 10 posições onde a posição '1' é referente ao primeiro digito, da posição '2' até a '4' é o segundo digito, posição '5' a '7' é o
% terceiro digito e '8' a '10' o quarto digito.

%PRIMEIRO DIGITO
if valor_final(1) == 2
   resultado(1) = 1;
else
    resultado(1) = 0;
end
%SEGUNDO DIGIT0
    if valor_final(2)==0 && valor_final(3)==0 && valor_final(4)==2
        resultado(2)=1;
    elseif valor_final(2)==1 && valor_final(3)==3 && valor_final(4)==1
        [V,P] = max(segundo_digito_esquerda);
        x = ~fotobinaria(P,:);
        teste = x(1,1:236/2);
        teste3 = sum(teste,2);
        if(resultado(1)==0)
            if(teste3<19)
                resultado(2)=5;
            else
                resultado(2)=2;
            end
        else
            if(teste3<32)
                resultado(2)=2;
            else
                resultado(2)=5;
            end
        end
    elseif valor_final(2)==0 && valor_final(3)==3 && valor_final(4)==2
        resultado(2)=3;
    elseif valor_final(2)==1 && valor_final(3)==1 && valor_final(4)==2
        resultado(2)=4;
    elseif valor_final(2)==2 && valor_final(3)==3 && valor_final(4)==1
        resultado(2)=6;
    elseif valor_final(2)==0 && valor_final(3)==1 && valor_final(4)==2
        resultado(2)=7;
    elseif valor_final(2)==2 && valor_final(3)==3 && valor_final(4)==2
        resultado(2)=8;
    elseif valor_final(2)==1 && valor_final(3)==3 && valor_final(4)==2
        resultado(2)=9;
    elseif valor_final(2)==2 && valor_final(3)==2 && valor_final(4)==2
        resultado(2)=0;
    end
%TERCEIRO DIGITO
     if valor_final(5)==0 && valor_final(6)==0 && valor_final(7)==2
         resultado(3)=1;
     elseif valor_final(5)==1 && valor_final(6)==3 && valor_final(7)==1
          [V,P] = max(terceiro_digito_esquerda);
        x = ~fotobinaria(P,:);
        teste = x(1,1:236/2);
        teste2 = sum(teste,2);
        if(teste2>=35)
            resultado(3)=2;
        else
            resultado(3)=5;
        end
     elseif valor_final(5)==0 && valor_final(6)==3 && valor_final(7)==2
         resultado(3)=3;
     elseif valor_final(5)==1 && valor_final(6)==1 && valor_final(7)==2
         resultado(3)=4;
     elseif valor_final(5)==2 && valor_final(6)==3 && valor_final(7)==1
         resultado(3)=6;
     elseif valor_final(5)==0 && valor_final(6)==1 && valor_final(7)==2
         resultado(3)=7;
     elseif valor_final(5)==2 && valor_final(6)==3 && valor_final(7)==2
         resultado(3)=8;
     elseif valor_final(5)==1 && valor_final(6)==3 && valor_final(7)==2
         resultado(3)=9;
     elseif valor_final(5)==2 && valor_final(6)==2 && valor_final(7)==2
         resultado(3)=0;
     end
%QUARTO DIGITO
    if valor_final(8)==0 && valor_final(9)==0 && valor_final(10)==2
        resultado(4)=1;
    elseif valor_final(8)==1 && valor_final(9)==3 && valor_final(10)==1
         [V,P] = max(quarto_digito_esquerda);
       x = ~fotobinaria(:,P);
        teste = x(1:236/2,1);
        teste2 = sum(teste,1);
        if(teste2>=35)
            resultado(4)=2;
        else
            resultado(4)=5;
        end
    elseif valor_final(8)==0 && valor_final(9)==3 && valor_final(10)==2
        resultado(4)=3;
    elseif valor_final(8)==1 && valor_final(9)==1 && valor_final(10)==2
        resultado(4)=4;
    elseif valor_final(8)==2 && valor_final(9)==3 && valor_final(10)==1
        resultado(4)=6;
    elseif valor_final(8)==0 && valor_final(9)==1 && valor_final(10)==2
        resultado(4)=7;
    elseif valor_final(8)==2 && valor_final(9)==3 && valor_final(10)==2
        resultado(4)=8;
    elseif valor_final(8)==1 && valor_final(9)==3 && valor_final(10)==2
        resultado(4)=9;
    elseif valor_final(8)==2 && valor_final(9)==2 && valor_final(10)==2
        resultado(4)=0;
    end
 subplot(3,1,3);
 stem(valor_final);
 title('Sub-Regiões');
% xlabel('Sub-Regiões');
% ylabel('Segmentos Ligados');

