
function varargout = Interface(varargin)
% INTERFACE MATLAB code for Interface.fig
%      INTERFACE, by itself, creates a new INTERFACE or raises the existing
%      singleton*.
%
%      H = INTERFACE returns the handle to a new INTERFACE or the handle to
%      the existing singleton*.
%
%      INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE.M with the given input arguments.
%
%      INTERFACE('Property','Value',...) creates a new INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Interface

% Last Modified by GUIDE v2.5 01-Oct-2018 21:19:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Interface_OpeningFcn, ...
                   'gui_OutputFcn',  @Interface_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Interface is made visible.
function Interface_OpeningFcn(hObject, eventdata, handles, varargin) %QUANDO A INTERFACE É ABERTA
axes(handles.axes4);
foto = imread('foto5.jpg'); %%Imagem para o padrão de posicionamento
imshow(foto);
% axes(handles.axes3);
% foto = imread('foto1.jpg');
% imshow(foto);
resultado=0;
mostra = sprintf('%d',resultado);
set(handles.testevalor,'string',mostra); %%Mostra o valor '0' no valor lido

mostra = sprintf('%d',resultado);
set(handles.ValorGerador,'string',mostra); %%Mostra o valor '0' no valor gerado

texto = sprintf('Calibração Não Iniciada'); %%Texto informativo sobre a situação
set(handles.texto,'string',texto);
% Choose default command line output for Interface

handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in configurarcamera.
function configurarcamera_Callback(hObject, eventdata, handles) %Botão que tira a foto para ver a posição do display
% vid=videoinput('winvideo',2);%armazena a web na variavel
% foto=getsnapshot(vid);%tira uma foto com a webcam
% axes(handles.axes3);%configura o axes para receber a imagem
% imshow(foto);%apresenta a foto tirada no axes3
webcamlist;
cam=webcam('USB2.0 PC CAMERA');
cam.Resolution = '320x240'; %%Configura a webcam
axes(handles.axes3);
foto =  snapshot(cam); %Captura a primeira imagem
% foto = imread('foto1.jpg');
imshow(foto); %Mostra a foto tirada na "Imagem do display"
fotocortada = imcrop(foto,[43.5100 69.5100 235.9800 145.9800]); %Recorta a foto para um tamanho padrão - fica 146X236
level = graythresh(fotocortada);
fotobinaria = im2bw(fotocortada,level);
m2 = sum(~fotobinaria,1);
m = medfilt1(m2);
% aux = sum(~fotobinaria,1); %Soma de todas as colunas da imagem binaria, criando um vetor.
% filtro = ones(3,3)/9; %Filtro de média 3x3
% m = imfilter(aux,filtro); %aplicando o filtro de media na imagem binaria.


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
if aux >=16 && aux < 69
    seg_segundo_digito_esquerda = 1; % 1 segmento ligado
elseif aux >= 69 && aux <= 80
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
if aux >= 10 && aux < 14
    seg_segundo_digito_meio=1; % 1 segmento ligado
elseif aux >= 14 && aux <= 24
    seg_segundo_digito_meio=2; % 2 segmentos ligados
elseif aux > 22 && aux <= 35
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
elseif aux > 61 && aux <= 100
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
if aux >=18 && aux <= 78
    seg_terceiro_digito_esquerda = 1; % 1 segmento ligado
elseif aux > 78 && aux <= 100
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
elseif aux >= 13 && aux <= 29
    seg_terceiro_digito_meio=2; % 2 segmentos ligados
elseif aux >= 30 && aux <= 100
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
elseif aux >= 65 && aux <= 200
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
if aux >=13 && aux <= 78
    seg_quarto_digito_esquerda = 1; % 1 segmento ligado
elseif aux > 78 && aux <= 150
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
elseif aux >10 && aux <= 21
    seg_quarto_digito_meio=2; % 2 segmentos ligados
elseif aux > 21 && aux <= 50
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
mostra = sprintf('%d',resultado); %%Apresenta o resultado final na interface
set(handles.testevalor,'string',mostra);




% --- Executes on button press in configurargerador.
function configurargerador_Callback(hObject, eventdata, handles)
global porta;
porta = gpib('ni',0,4);
fopen(porta);
fprintf(porta, '*IDN?');


% --- Executes on button press in Iniciar.
function Iniciar_Callback(hObject, eventdata, handles)
global porta;
%----VERIFICA QUANTAS ABAS A PLANILHA POSSUI
numero_de_abas = get(handles.planilhasedit,'String');
protocolo = get(handles.protocoloedit,'String');
assignin('base','numero_de_abas',numero_de_abas); %Atualiza o workspace
if numero_de_abas == '0'
   erro = msgbox('Quantidade de planilhas incorreta','Error','error');
end
numero_de_abas = str2num(numero_de_abas);
sheet = 1;
xlRange1 = 'C9'; %Primeiro ponto
xlRange2 = 'D9'; %Segundo ponto
xlRange3 = 'E9'; %Terceiro ponto
xlRange4 = 'J2'; %Grandeza
xlRange5 = 'J3'; %Frequência

diretorio = protocolo;
for n=1:1:numero_de_abas
    primeiro_ponto(n) = xlsread(diretorio,sheet,xlRange1);
    segundo_ponto(n) = xlsread(diretorio,sheet,xlRange2);
    terceiro_ponto(n) = xlsread(diretorio,sheet,xlRange3);
    [num,grandeza1,raw] = xlsread(diretorio,sheet,xlRange4);
    grandeza(n) = grandeza1;
    frequencia(n) = xlsread(diretorio,sheet,xlRange5);
    assignin('base','terceiro_ponto',terceiro_ponto);
    assignin('base','primeiro_ponto',primeiro_ponto);
    assignin('base','segundo_ponto',segundo_ponto);
    assignin('base','grandeza',grandeza);
    assignin('base','frequencia',frequencia);
    sheet = sheet+1;
end
sheet = 1;
for n=1:1:numero_de_abas
    grandeza1 = grandeza(n);
    frequencia1 = frequencia(n);
    if grandeza1 == "V" && frequencia1 == 0
        troca = questdlg('Realizar ligação para medidas de Tensão Contínua','Aviso','OK','Parar');
        switch troca
            case 'OK'
                texto = sprintf('Realizando medidas de Tensão Contínua');
                set(handles.texto,'string',texto);
                ponto1 = primeiro_ponto(n);
                fprintf(porta,'OUT %d V, 0HZ',ponto1);
                fprintf(porta,'OPER');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles); %Primeira Medida
                %%Leitura do valor apresentado na interface e realizada a escrita no excel
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0.2) && (ponto1<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C13');
                set(handles.testevalor,'string',escreve);
                %-----------------------------------------
                %Apresentação do valor que está sendo gerado pelo gerador
                valorgerado = sprintf('%.2fV',ponto1);
                set(handles.ValorGerador,'string',valorgerado);
                %-------------------------------------------
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Segunda Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0.2) && (ponto1<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Terceira Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0.2) && (ponto1<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Quarta Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0.2) && (ponto1<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C16');
                pause(3);
                ponto2 = segundo_ponto(n);
                fprintf(porta,'OUT %d V, 0HZ',ponto2);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Primeira medida
                valorgerado = sprintf('%.2fV',ponto2);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0.2) && (ponto2<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto2>=200) && (ponto2<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0.2) && (ponto2<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto2>=200) && (ponto2<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0.2) && (ponto2<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto2>=200) && (ponto2<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0.2) && (ponto2<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto2>=200) && (ponto2<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D16');
                pause(3);
                ponto3 = terceiro_ponto(n);
                fprintf(porta,'OUT %d V, 0HZ',ponto3);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                valorgerado = sprintf('%.2fV',ponto3);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0.2) && (ponto3<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=3) && (ponto3<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto3<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0.2) && (ponto3<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=3) && (ponto3<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto3<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0.2) && (ponto3<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=3) && (ponto3<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto3<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0.2) && (ponto3<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=3) && (ponto3<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto3<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E16');
                pause(3);
                fprintf(porta,'STBY');
            case 'Parar'
                fprintf(porta,'STBY');
                fclose(porta);
        end     
    elseif grandeza1 =="V" && frequencia1 == 60
            troca = questdlg('Realizar ligação para medidas de Tensão Alternada','Aviso','OK','Parar');
        switch troca
            case 'OK'
                texto = sprintf('Realizando medidas de Tensão Alternada');
                set(handles.texto,'string',texto);
                ponto1 = primeiro_ponto(n);
                fprintf(porta,'OUT %d V, 60HZ',ponto1);
                fprintf(porta,'OPER');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles); %Primeira Medida
                %%Leitura do valor apresentado na interface e realizada a escrita no excel
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0.2) && (ponto1<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C13');
                %-----------------------------------------
                %Apresentação do valor que está sendo gerado pelo gerador
                valorgerado = sprintf('%.2fV',ponto1);
                set(handles.ValorGerador,'string',valorgerado);
                %-------------------------------------------
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Segunda Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0.2) && (ponto1<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Terceira Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0.2) && (ponto1<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Quarta Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0.2) && (ponto1<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C16');
                pause(3);
                ponto2 = segundo_ponto(n);
                fprintf(porta,'OUT %d V, 60HZ',ponto2);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Primeira medida
                valorgerado = sprintf('%.2fV',ponto2);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0.2) && (ponto2<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto2>=200) && (ponto2<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0.2) && (ponto2<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto2>=200) && (ponto2<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0.2) && (ponto2<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto2>=200) && (ponto2<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0.2) && (ponto2<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto2>=200) && (ponto2<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D16');
                pause(3);
                ponto3 = terceiro_ponto(n);
                fprintf(porta,'OUT %d V, 60HZ',ponto3);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                valorgerado = sprintf('%.2fV',ponto3);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0.2) && (ponto3<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=3) && (ponto3<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto3<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0.2) && (ponto3<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=3) && (ponto3<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto3<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0.2) && (ponto3<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=3) && (ponto3<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto3<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0.2) && (ponto3<2) %%Faixa de 2V
                   escreve = escreve/1000;
                end
                if(ponto2>=3) && (ponto3<20) %%Faixa de 20V
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200V
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto3<1000) %%Faixa de 750V ou 1000V
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E16');
                pause(3);
                fprintf(porta,'STBY');
            case 'Parar'
                fprintf(porta,'STBY');
                fclose(porta);
        end     
        elseif grandeza1 =="mV" && frequencia1 == 0
            troca = questdlg('Realizar ligação para medidas de Tensão Continua','Aviso','OK','Parar');
        switch troca
            case 'OK'
                texto = sprintf('Realizando medidas de Tensão Contínua');
                set(handles.texto,'string',texto);
                ponto1 = primeiro_ponto(n);
                fprintf(porta,'OUT %d mV, 0HZ',ponto1);
                fprintf(porta,'OPER');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles); %Primeira Medida
                %%Leitura do valor apresentado na interface e realizada a escrita no excel
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C13');
                %-----------------------------------------
                %Apresentação do valor que está sendo gerado pelo gerador
                valorgerado = sprintf('%.2f mV',ponto1);
                set(handles.ValorGerador,'string',valorgerado);
                %-------------------------------------------
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Segunda Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Terceira Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Quarta Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C16');
                pause(3);
                ponto2 = segundo_ponto(n);
                fprintf(porta,'OUT %d mV, 0HZ',ponto2);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Primeira medida
                valorgerado = sprintf('%.2f mV',ponto2);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0) && (ponto2<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto2>=200) && (ponto2<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0) && (ponto2<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto2>=200) && (ponto2<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D16');
                pause(3);
                ponto3 = terceiro_ponto(n);
                fprintf(porta,'OUT %d mV, 0HZ',ponto3);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                valorgerado = sprintf('%.2f mV',ponto3);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0) && (ponto3<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto3<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0) && (ponto3<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto3<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0) && (ponto3<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto3<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0) && (ponto3<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto2<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E16');
                pause(3);
                fprintf(porta,'STBY');
            case 'Parar'
                fprintf(porta,'STBY');
                fclose(porta);
        end     
        elseif grandeza1 =="mV" && frequencia1 == 60
            troca = questdlg('Realizar ligação para medidas de Tensão Alternada','Aviso','OK','Parar');
        switch troca
            case 'OK'
                texto = sprintf('Realizando medidas de Tensão Alternada');
                set(handles.texto,'string',texto);
                ponto1 = primeiro_ponto(n);
                fprintf(porta,'OUT %d mV, 60HZ',ponto1);
                fprintf(porta,'OPER');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles); %Primeira Medida
                %%Leitura do valor apresentado na interface e realizada a escrita no excel
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C13');
                %-----------------------------------------
                %Apresentação do valor que está sendo gerado pelo gerador
                valorgerado = sprintf('%.2f mV',ponto1);
                set(handles.ValorGerador,'string',valorgerado);
                %-------------------------------------------
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Segunda Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Terceira Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Quarta Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto1>=200) && (ponto1<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C16');
                pause(3);
                ponto2 = segundo_ponto(n);
                fprintf(porta,'OUT %d mV, 60HZ',ponto2);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Primeira medida
                valorgerado = sprintf('%.2f mV',ponto2);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0) && (ponto2<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto2>=200) && (ponto2<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0) && (ponto2<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto2>=200) && (ponto2<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0) && (ponto2<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto2>=200) && (ponto2<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0) && (ponto2<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto2>=200) && (ponto2<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D16');
                pause(3);
                ponto3 = terceiro_ponto(n);
                fprintf(porta,'OUT %d mV, 60HZ',ponto3);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                valorgerado = sprintf('%.2fmV',ponto3);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0) && (ponto3<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto3<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0) && (ponto3<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto3<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0) && (ponto3<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto3<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0) && (ponto3<200) %%Faixa de 200mV
                   escreve = escreve/10;
                end
                if(ponto3>=200) && (ponto3<2000) %%Faixa de 2000mV (Quando possuir)
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E16');
                pause(3);
                fprintf(porta,'STBY');
            case 'Parar'
                fprintf(porta,'STBY');
                fclose(porta);
        end     
        elseif grandeza1 =="A" && frequencia1 == 0
            troca = questdlg('Realizar ligação para medidas de Corrente Continua','Aviso','OK','Parar');
        switch troca
            case 'OK'
                texto = sprintf('Realizando medidas de Corrente Contínua');
                set(handles.texto,'string',texto);
                ponto1 = primeiro_ponto(n);
                fprintf(porta,'OUT %d A, 0HZ',ponto1);
                fprintf(porta,'OPER');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles); %Primeira Medida
                %%Leitura do valor apresentado na interface e realizada a escrita no excel
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C13');
                %-----------------------------------------
                %Apresentação do valor que está sendo gerado pelo gerador
                valorgerado = sprintf('%.2fA',ponto1);
                set(handles.ValorGerador,'string',valorgerado);
                %-------------------------------------------
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Segunda Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Terceira Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Quarta Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C16');
                pause(3);
                ponto2 = segundo_ponto(n);
                fprintf(porta,'OUT %d A, 0HZ',ponto2);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Primeira medida
                valorgerado = sprintf('%.2fA',ponto2);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D16');
                pause(3);
                ponto3 = terceiro_ponto(n);
                fprintf(porta,'OUT %d A, 0HZ',ponto3);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                valorgerado = sprintf('%.2fV',ponto3);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);                
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E16');
                pause(3);
                fprintf(porta,'STBY');
            case 'Parar'
                fprintf(porta,'STBY');
                fclose(porta);
        end
        elseif grandeza1 =="A" && frequencia1 == 60
            troca = questdlg('Realizar ligação para medidas de Corrente Alternada','Aviso','OK','Parar');
        switch troca
            case 'OK'
                texto = sprintf('Realizando medidas de Corrente Alternada');
                set(handles.texto,'string',texto);
                ponto1 = primeiro_ponto(n);
                fprintf(porta,'OUT %d A, 60HZ',ponto1);
                fprintf(porta,'OPER');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles); %Primeira Medida
                %%Leitura do valor apresentado na interface e realizada a escrita no excel
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C13');
                %-----------------------------------------
                %Apresentação do valor que está sendo gerado pelo gerador
                valorgerado = sprintf('%.2fA',ponto1);
                set(handles.ValorGerador,'string',valorgerado);
                %-------------------------------------------
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Segunda Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Terceira Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Quarta Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'C16');
                pause(3);
                ponto2 = segundo_ponto(n);
                fprintf(porta,'OUT %d A, 60HZ',ponto2);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Primeira medida
                valorgerado = sprintf('%.2fA',ponto2);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'D16');
                pause(3);
                ponto3 = terceiro_ponto(n);
                fprintf(porta,'OUT %d A, 60HZ',ponto3);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                valorgerado = sprintf('%.2fV',ponto3);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);                
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20A
                   escreve = escreve/1;
                end
                xlswrite(diretorio,escreve,sheet,'E16');
                pause(3);
                fprintf(porta,'STBY');
            case 'Parar'
                fprintf(porta,'STBY');
                fclose(porta);
        end
        elseif grandeza1 =="mA" && frequencia1 == 0
            troca = questdlg('Realizar ligação para medidas de Corrente Continua','Aviso','OK','Parar');
        switch troca
            case 'OK'
                texto = sprintf('Realizando medidas de Corrente Contínua');
                set(handles.texto,'string',texto);
                ponto1 = primeiro_ponto(n);
                fprintf(porta,'OUT %d mA, 0HZ',ponto1);
                fprintf(porta,'OPER');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles); %Primeira Medida
                %%Leitura do valor apresentado na interface e realizada a escrita no excel
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'C13');
                %-----------------------------------------
                %Apresentação do valor que está sendo gerado pelo gerador
                valorgerado = sprintf('%.2fmA',ponto1);
                set(handles.ValorGerador,'string',valorgerado);
                %-------------------------------------------
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Segunda Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'C14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Terceira Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'C15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Quarta Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'C16');
                pause(3);
                ponto2 = segundo_ponto(n);
                fprintf(porta,'OUT %d mA, 0HZ',ponto2);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Primeira medida
                valorgerado = sprintf('%.2fmA',ponto2);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0) && (ponto2<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'D13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0) && (ponto2<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'D14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0) && (ponto2<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'D15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0) && (ponto2<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'D16');
                pause(3);
                ponto3 = terceiro_ponto(n);
                fprintf(porta,'OUT %d mA, 0HZ',ponto3);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                valorgerado = sprintf('%.2fmA',ponto3);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0) && (ponto3<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'E13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);                
                if(ponto3>=0) && (ponto3<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'E14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0) && (ponto3<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'E15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0) && (ponto3<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'E16');
                pause(3);
                fprintf(porta,'STBY');
            case 'Parar'
                fprintf(porta,'STBY');
                fclose(porta);
        end
        elseif grandeza1 =="mA" && frequencia1 == 60
            troca = questdlg('Realizar ligação para medidas de Corrente Alternada','Aviso','OK','Parar');
        switch troca
            case 'OK'
                texto = sprintf('Realizando medidas de Corrente Alternada');
                set(handles.texto,'string',texto);
                ponto1 = primeiro_ponto(n);
                fprintf(porta,'OUT %d mA, 60HZ',ponto1);
                fprintf(porta,'OPER');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles); %Primeira Medida
                %%Leitura do valor apresentado na interface e realizada a escrita no excel
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'C13');
                %-----------------------------------------
                %Apresentação do valor que está sendo gerado pelo gerador
                valorgerado = sprintf('%.2fmA',ponto1);
                set(handles.ValorGerador,'string',valorgerado);
                %-------------------------------------------
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Segunda Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'C14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Terceira Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'C15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Quarta Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=0) && (ponto1<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto1>=2) && (ponto1<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'C16');
                pause(3);
                ponto2 = segundo_ponto(n);
                fprintf(porta,'OUT %d mA, 60HZ',ponto2);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Primeira medida
                valorgerado = sprintf('%.2fmA',ponto2);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0) && (ponto2<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'D13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0) && (ponto2<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'D14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0) && (ponto2<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'D15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto2>=0) && (ponto2<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto2>=2) && (ponto2<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto2>=20) && (ponto2<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'D16');
                pause(3);
                ponto3 = terceiro_ponto(n);
                fprintf(porta,'OUT %d mA, 60HZ',ponto3);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                valorgerado = sprintf('%.2fmA',ponto3);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0) && (ponto3<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'E13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);                
                if(ponto3>=0) && (ponto3<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'E14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0) && (ponto3<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'E15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto3>=0) && (ponto3<2) %%Faixa de 2mA
                   escreve = escreve/1000;
                end
                if(ponto3>=2) && (ponto3<20) %%Faixa de 20mA
                   escreve = escreve/100;
                end
                if(ponto3>=20) && (ponto3<200) %%Faixa de 200mA
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'E16');
                pause(3);
                fprintf(porta,'STBY');
            case 'Parar'
                fprintf(porta,'STBY');
                fclose(porta);
        end
    elseif grandeza1 =="Ohm" && frequencia1 == 0
            troca = questdlg('Realizar ligação para medidas de Resistência','Aviso','OK','Parar');
        switch troca
            case 'OK'
                texto = sprintf('Realizando medidas de Resistência');
                set(handles.texto,'string',texto);
                ponto1 = primeiro_ponto(n);
                fprintf(porta,'OUT %d OHM, 0HZ',ponto1);
                fprintf(porta,'OPER');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles); %Primeira Medida
                %%Leitura do valor apresentado na interface e realizada a escrita no excel
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200Ohm
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'C13');
                %-----------------------------------------
                %Apresentação do valor que está sendo gerado pelo gerador
                valorgerado = sprintf('%.2fOhm',ponto1);
                set(handles.ValorGerador,'string',valorgerado);
                %-------------------------------------------
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Segunda Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200Ohm
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'C14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Terceira Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200Ohm
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'C15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Quarta Medida
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200Ohm
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'C16');
                pause(3);
                ponto2 = segundo_ponto(n);
                fprintf(porta,'OUT %d OHM, 0HZ',ponto2);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);%Primeira medida
                valorgerado = sprintf('%.2fOhm',ponto2);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200Ohm
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'D13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200Ohm
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'D14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200Ohm
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'D15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200Ohm
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'D16');
                pause(3);
                ponto3 = terceiro_ponto(n);
                fprintf(porta,'OUT %d OHM, 0HZ',ponto3);
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                valorgerado = sprintf('%.2fOhm',ponto3);
                set(handles.ValorGerador,'string',valorgerado);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200Ohm
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'E13');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);                
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200Ohm
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'E14');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200Ohm
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'E15');
                pause(3);
                configurarcamera_Callback(hObject,eventdata,handles);
                escreve = get(handles.testevalor,'string');
                escreve = str2num(escreve);
                if(ponto1>=20) && (ponto1<200) %%Faixa de 200Ohm
                   escreve = escreve/10;
                end
                xlswrite(diretorio,escreve,sheet,'E16');
                pause(3);
                fprintf(porta,'STBY');
            case 'Parar'
                fprintf(porta,'STBY');
                fclose(porta);
        end
    end
        sheet = sheet+1;
end
acabou = msgbox('Calibração finalizada','','none');
fclose(porta);

% --- Executes on button press in parar.
function parar_Callback(hObject, eventdata, handles)
 global porta;
 fclose(porta);


function protocoloedit_Callback(hObject, eventdata, handles)
% hObject    handle to protocoloedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of protocoloedit as text
%        str2double(get(hObject,'String')) returns contents of protocoloedit as a double


% --- Executes during object creation, after setting all properties.
function protocoloedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to protocoloedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function planilhasedit_Callback(hObject, eventdata, handles)
% x = get(handles.planilhasedit,'String');
% assignin('base','x',x);


% --- Executes during object creation, after setting all properties.
function planilhasedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to planilhasedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
