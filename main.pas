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
            1: writeln('em breve...');
            2: writeln('em breve...');
            3: writeln('em breve...');
            4: writeln('em breve...');
            5: writeln('em breve...');
        end;
    end;
end.
