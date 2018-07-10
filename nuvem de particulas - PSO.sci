PopSize=40;
MaxGeracao=40;
MaxW=0.9;
MinW=0.4;
Min=-500;
Max=500;
c1 =2.05;
c2=2.05;
MaxV=Max*0.04;
MinV=Min*0.04;


//funcao que calcula o valor na função dada
function valor=ValoresFuncoes(x, y)
    z=-x.*sin(sqrt(abs(x)))-y.*sin(sqrt(abs(y)));
    x=x/250;
    valor=x.*z;
endfunction

//verifica se a velocidade está entre o min e max
function out=Velocidade(velocidade, MinV, MaxV)
    if velocidade< MinV then
        out=MinV
    else
        if velocidade> MaxV then
            out=MaxV
        else
            out=velocidade
        end
    end
endfunction

//verifica se a posição está entre o minimo e o maximo
function out=Posicao(posicao, Minx, Maxy)
    if posicao< Minx then
        out=Minx
    else
        if posicao> Maxy then
            out=Maxy
        else
            out=posicao
        end
    end
endfunction

function [minimo, MelhorXY]=Nuvemdeparticulas(PopSize, MaxGeracao, MaxW, MinW, Min, Max, c1, c2, MaxV, MinV)
    //inicia população
    MelhorXY = zeros(1 ,2);
    X(1 ,:)=zeros(1 ,PopSize);
    Y(1 ,:)=zeros(1 ,PopSize);
    //da valores aleatorios entre os limites para a população inicial
    for i = 1 : PopSize
        X(1 ,i) = rand() * ( Max-Min ) + Min;
        Y(1 ,i) = rand() * ( Max-Min ) + Min;
    end
    //coloca os valores no vetor de melhores locais
    Melhorx_local(1 ,:)=X(1 ,:);
    Melhory_local(1 ,:)=Y(1 ,:);
    for i=1:PopSize
        Valores(1 ,i)=ValoresFuncoes(X(1 ,i),Y(1 ,i)); //adquire os valores na função
    end
    //pega a melhor aptidão(a) e o índice(b) e adiciona no vetor melhor global
    [a,b]=min(Valores(1 ,:));
    MelhorXY=[X(1 ,b) Y(1 ,b)];
    //Testa a velocidade
    for i=1 :PopSize
        Vx(1 ,i)=Velocidade(MinV+(MaxV-MinV)*rand(),MinV, MaxV);
        Vy(1 ,i)=Velocidade(MinV+(MaxV-MinV)*rand(),MinV, MaxV);
    end
    //calcula os W's para cada geração
    for i=1 :MaxGeracao
        w(i)=MaxW-((MaxW-MinW)/MaxGeracao)*i;
    end
    for j=1 :MaxGeracao-1
        r1=rand();
        r2=rand();
        for k=1 :PopSize
            //calcula os valores da velocidade dentro do limite utilizando a função do algoritmo nuvem de particulas
            newVx=Vx(j,k)*w(j) + c1 *r1 *(Melhorx_local(1 ,k)-X(j,k)) + c2*r2*(MelhorXY(1 ,1 )-X(j,k));
            newVy=Vy(j,k)*w(j) + c1 *r1 *(Melhory_local(1 ,k)-Y(j,k)) + c2*r2*(MelhorXY(1 ,2)-Y(j,k));
            //verifica se é possivel essas velocidades
            Vx(j+1 ,k)=Velocidade(newVx,MinV,MaxV);
            Vy(j+1 ,k)=Velocidade(newVy,MinV,MaxV);
            //calcula novos valores(posições) de X e Y dentro do limite
            newX=X(j,k)+Vx(j+1 ,k);
            newY=Y(j,k)+Vy(j+1 ,k)
            //verifica se é possivel essas posições
            X(j+1 ,k)=Posicao(newX,Min,Max);
            Y(j+1 ,k)=Posicao(newY,Min,Max);
            //calcula a aptidão
            Valores(j+1 ,k)=ValoresFuncoes(X(j+1 ,k),Y(j+1 ,k));
            //atualiza o vetor melhores locais
            if Valores(j,k)> Valores(j+1 ,k) then
                Melhorx_local(1 ,k)=X(j+1 ,k);
                Melhory_local(1 ,k)=Y(j+1 ,k);
            end
        end
        //atualiza o melhor global 
        [a,b]=min(Valores(j+1 ,:)); // a=valor, b=indice
        if ValoresFuncoes(MelhorXY(1 ,1 ),MelhorXY(1 ,2)) > ValoresFuncoes(X(j+1 ,b),Y(j+1 ,b)) then //se o menor global anterior for maior que o menor local da geração atual
            MelhorXY=[X(j+1 ,b) Y(j+1 ,b)]; //atualiza o menor global
        end
    end
    
    minimo=ValoresFuncoes(MelhorXY(1 ,1 ),MelhorXY(1 ,2)); //adquire o menor valor global
    //plot população inicial
    subplot(1 ,3,1 );
    ylabel('Y')
    xlabel('X')
    xtitle("Indivíduos na primeira geração");
    plot(X(1 ,:),Y(1 ,:),'x');
    square(-500, -500, 500, 500)
    xgrid();
    //plot população em (MaxGeração/2)
    subplot(1 ,3,2);
    ylabel('Y')
    xlabel('X')
    xtitle("Indivíduos no meio das gerações");
    plot(X(MaxGeracao/2,:),Y(MaxGeracao/2 ,:),'x');
    square(-500, -500, 500, 500)
    xgrid();
    //plot em população final
    subplot(1 ,3,3);
    ylabel('Y')
    xlabel('X')
    xtitle("Indivíduos na ultima geração");
    plot(X(MaxGeracao,:),Y(MaxGeracao,:),'x');
    square(-500, -500, 500, 500)
    xgrid();
endfunction

testes=1;
for i=1:1:testes
    [resposta(i),melhor]=Nuvemdeparticulas(PopSize,MaxGeracao,MaxW,MinW,Min,Max,c1,c2,MaxV,MinV)
end
disp(resposta);
disp(melhor);
minGlobal=min(resposta);
disp(minGlobal);
