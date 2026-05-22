program pointer_lista;

uses crt;

type
    TInfo = string;
    TNode = ^TElemento;
    TElemento = record
        ant: Tnode;
        infoUm: TInfo;
        infoDois: TNode;
        prox: TNode;
    end;

var
    opcao: byte;
    str, strIngles: TInfo;
    str_lista: TNode;

procedure LerInfo(var infoUm : TInfo);
begin
    clrscr;
    write('Insira informação: ');
    read(infoUm);
end;

function BuscarNo(lista: TNode; valor: TInfo): TNode;
var atual: TNode;
    encontrado: boolean;
begin
    atual := lista;
    encontrado := false;

    while (atual <> nil) and (not encontrado) do
    begin
        if atual^.infoUm = valor then
            encontrado := true
        else
            atual := atual^.prox;
    end;

    if encontrado then
        BuscarNo := atual
    else
        BuscarNo := nil;
end;

// Lista Simples

procedure AdicionarSimples(var lista : TNode; infoUm : TInfo);
var aux, anterior, atual : TNode;
begin
    new(aux);
    if aux = nil then
    begin
        write('Memoria cheia!'); readkey;
    end
    else
    begin
        aux^.infoUm := infoUm;
        aux^.prox := nil;
        
        if (lista = nil) or (infoUm < lista^.infoUm) then
        begin
            aux^.prox := lista;
            lista := aux;
        end
        else
        begin
            anterior := lista;
            atual := lista^.prox;
            
            while (atual <> nil) and (infoUm > atual^.infoUm) do
            begin
                anterior := atual;
                atual := atual^.prox;
            end;
            
            aux^.prox := atual;
            anterior^.prox := aux;
        end;
    end;
end;

procedure RemoverSimples(var lista : TNode; infoUm : TInfo);
var anterior, atual : TNode;
begin
    if lista = nil then
    begin
        write('Lista vazia!'); readkey;
    end
    else
    begin
        anterior := nil;
        atual := lista;
        
        while (atual <> nil) and (atual^.infoUm <> infoUm) do
        begin
            anterior := atual;
            atual := atual^.prox;
        end;
        
        if atual = nil then
        begin
            write('Elemento não encontrado!'); readkey;
        end
        else
        begin
            // Era o primeiro da listaa?
            if anterior = nil then
                lista := atual^.prox
            else
                anterior^.prox := atual^.prox;
            
            writeln('Elemento ', atual^.infoUm, ' removido!');
            dispose(atual);
            readkey;
        end;
    end;
end;

// lista dupla
procedure CriarListaDupla(var lista : TNode);
begin
    lista := nil;
end;

procedure AdicionarDupla(var lista : TNode; infoUm : TInfo);
var aux, anterior, atual : TNode;
begin
    new(aux);

    if aux = nil then
    begin
        write('Memoria cheia!'); readkey;
    end
    else
    begin
        aux^.ant := nil;
        aux^.infoUm := infoUm;
        aux^.infoDois := nil;
        aux^.prox := nil;
        
        if (lista = nil) or (infoUm < lista^.infoUm) then
        begin
            aux^.prox := lista;

            if lista <> nil then
                lista^.ant := aux;
            
            lista := aux;
        end
        else
        begin
            anterior := lista;
            atual := lista^.prox;
            
            while (atual <> nil) and (infoUm > atual^.infoUm) do
            begin
                anterior := atual;
                atual := atual^.prox;
            end;
            
            aux^.prox := atual;
            aux^.ant := anterior;
            anterior^.prox := aux;
            if atual <> nil then
                atual^.ant := aux;
        end;
    end;
end;

procedure RemoverDupla(var lista : TNode; infoUm : TInfo);
var anterior, atual : TNode;
begin
    if lista = nil then
    begin
        write('Lista vazia!'); readkey;
    end
    else
    begin
        anterior := nil;
        atual := lista;
        
        while (atual <> nil) and (atual^.infoUm <> infoUm) do
        begin
            anterior := atual;
            atual := atual^.prox;
        end;
        
        if atual = nil then
        begin
            write('Elemento não encontrado!'); readkey;
        end
        else
        begin
            // Era o primeiro da listaa?
            if anterior = nil then
                lista := atual^.prox
            else
                anterior^.prox := atual^.prox;
            
            writeln('Elemento ', atual^.infoUm, ' removido!');
            dispose(atual);
            readkey;
        end;
    end;
end;

procedure InserirChave(var lista: TNode; chave:TInfo);
begin
    if BuscarNo(lista, chave) <> nil then
    begin
        writeln('Chave "', chave, '" ja existe!');
        readkey;
    end
    else
        AdicionarDupla(lista, chave);
end;

function BuscarNoCerto(lista: TNode; verbete: TInfo): TNode;
var atual: TNode;
    encontrado: boolean;
begin
    atual := lista;
    encontrado := false;

    while(atual <> nil) and (not encontrado) do
    begin
        if atual^.infoUm > verbete then
            encontrado := true
        else
            atual := atual^.prox;
    end;

    if encontrado then
        BuscarNoCerto := atual
    else
        BuscarNoCerto := nil;
end;

procedure InserirVerbete(var lista: TNode; verbetePT, verbeteEN: TInfo);
var noCerto, noVerbete, noTraducao, anterior, atual: TNode;
begin
    noCerto := BuscarNoCerto(lista, verbetePT);

    if noCerto = nil then
    begin
        writeln('Ainda não há uma chave válida para "', 
            verbetePT, '", cadastre uma chave válida primeiro!');
        readkey;
    end
    else
    begin
        if BuscarNo(noCerto^.infoDois, verbetePT) <> nil then
        begin
            writeln('"', verbetePT, '" ja existe no grupo de "',
                noCerto^.infoUm, '"!');
            readkey;
        end
        else
        begin
            //noTraducao guarda valor em inglês
            new(noTraducao);
            noTraducao^.ant := nil;
            noTraducao^.infoUm := verbeteEN;
            noTraducao^.infoDois := nil;
            noTraducao^.prox := nil;

            //noVerbete guarda valor em português
            new(noVerbete);
            noVerbete^.ant := nil;
            noVerbete^.infoUm := verbetePT;
            noVerbete^.infoDois := noTraducao;
            noVerbete^.prox := nil;

            noTraducao^.infoDois := noVerbete;

            if (noCerto^.infoDois = nil) or 
                (verbetePT < noCerto^.infoDois^.infoUm) then
            begin
                noVerbete^.prox := noCerto^.infoDois;
                noCerto^.infoDois := noVerbete;
            end
            else
            begin
                anterior := noCerto^.infoDois;
                atual := noCerto^.infoDois^.prox;

                while (atual <> nil) and (verbetePT > atual^.infoUm) do
                begin
                    anterior := atual;
                    atual := atual^.prox;
                end;

                noVerbete^.prox := atual;
                anterior^.prox := noVerbete;
            end;

            writeln('"', verbetePT, ' -> ', verbeteEN,
                '" inserido no grupo de "', noCerto^.infoUm, '".');
            readkey;
        end;
    end;
end;

procedure RemoverVerbete(var lista: TNode; verbetePT:TInfo);
var noCerto, anterior, atual: TNode;
begin
    noCerto := BuscarNoCerto(lista, verbetePT);
    
    if noCerto = nil then
    begin
        writeln('Nenhum grupo encontrado para "', verbetePT, '"!');
        readkey;
    end
    else
    begin
        anterior := nil;
        atual := noCerto^.infoDois;
        
        while (atual <> nil) and (atual^.infoUm <> verbetePT) do
        begin
            anterior := atual;
            atual := atual^.prox;
        end;
        
        if atual = nil then
        begin
            writeln('"', verbetePT, '" nao encontrado no grupo de "',
                noCerto^.infoUm, '"');
            readkey;
        end
        else
        begin
            if anterior = nil then
                noCerto^.infoDois := atual^.prox
            else
                anterior^.prox := atual^.prox;
            
            dispose(atual^.infoDois);
            dispose(atual);
            
            writeln('"', verbetePT, '" removido do grupo de "',
                noCerto^.infoUm, '"');
            readkey;
        end;
    end;
end;

begin
    opcao := 1;
    CriarListaDupla(str_lista);

    while opcao <> 0 do
    begin
        clrscr;
        writeln('0 - Sair');
        writeln('1 - Incluir palavra-chave');
        writeln('2 - Incluir no dicionario');
        writeln('3 - Remover do dicionario');
        writeln('4 - Consultar');
        writeln('5 - Escrever todo o dicionario');
        readln(opcao);
        writeln;

        case opcao of
            1: begin
                clrscr;
                write('Palavra-chave: ');
                readln(str);
                InserirChave(str_lista, str);
            end;

            2: begin
                clrscr;
                write('Verbete em portugues: ');
                readln(str);
                write('Traducao em ingles  : ');
                readln(strIngles);
                InserirVerbete(str_lista, str, strIngles);
            end;
            
            3: begin
                clrscr;
                write('Digite o verbete a ser removido: ');
                readln(str);
                RemoverVerbete(str_lista, str);
            end;
            4: writeln('em breve...');
            5: writeln('em breve...');
        end;
    end;
end.
