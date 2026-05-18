program pointer_lista;

uses crt;

type
    TInfo = string;
    TNode = ^TElemento;
    TElemento = record
        ant : Tnode;
        info : TInfo;
        infoDois : TNode
        prox : TNode;
    end;

var option : byte;
    str : TInfo;
    str_lista : TNode;

procedure LerInfo(var info : TInfo);
begin
    clrscr;
    write('Insira informação: ');
    read(info);
end;

// Lista Simples

procedure AdicionarSimples(var lista : TNode; info : TInfo);
var aux, anterior, atual : TNode;
begin
    new(aux);
    if aux = nil then
    begin
        write('Memoria cheia!'); readkey;
    end
    else
    begin
        aux^.info := info;
        aux^.prox := nil;
        
        if (lista = nil) or (info < lista^.info) then
        begin
            aux^.prox := lista;
            lista := aux;
        end
        else
        begin
            anterior := lista;
            atual := lista^.prox;
            
            while (atual <> nil) and (info > atual^.info) do
            begin
                anterior := atual;
                atual := atual^.prox;
            end;
            
            aux^.prox := atual;
            anterior^.prox := aux;
        end;
    end;
end;

procedure RemoverSimples(var lista : TNode; info : TInfo);
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
        
        while (atual <> nil) and (atual^.info <> info) do
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
            
            writeln('Elemento ', atual^.info, ' removido!');
            dispose(atual);
            readkey;
        end;
    end;
end;

// lista dupla
procedure Dupla(var lista : TNode);
begin
    lista := nil;
end;

procedure AdicionarDupla(var lista : TNode; info : TInfo);
var aux, anterior, atual : TNode;
begin
    new(aux);
    if aux = nil then
    begin
        write('Memoria cheia!'); readkey;
    end
    else
    begin
        aux^.info := info;
        aux^.prox := nil;
        
        if (lista = nil) or (info < lista^.info) then
        begin
            aux^.prox := lista;
            lista := aux;
        end
        else
        begin
            anterior := lista;
            atual := lista^.prox;
            
            while (atual <> nil) and (info > atual^.info) do
            begin
                anterior := atual;
                atual := atual^.prox;
            end;
            
            aux^.prox := atual;
            anterior^.prox := aux;
        end;
    end;
end;

procedure RemoverDupla(var lista : TNode; info : TInfo);
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
        
        while (atual <> nil) and (atual^.info <> info) do
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
            
            writeln('Elemento ', atual^.info, ' removido!');
            dispose(atual);
            readkey;
        end;
    end;
end;

begin
    option := 1;
    CriarListaDupla(str_lista);
    
    while option <> 0 do
    begin
        clrscr;
        writeln ('0 - Sair');
        writeln ('1 - Incluir');
        writeln ('2 - Remover');
        writeln ('3 - Contar elementos');
        readln (option);
        writeln;
       
        case option of
            1:
            begin
                LerInfo(str);
                AdicionarSimples(str_lista, str);
            end;
            
            2:
            begin
                LerInfo(str);
                RemoverSimples(str_lista, str);
            end;
            
            3:
            begin
                writeln(ContarListaSimples(str_lista), ' elementos');
                readkey;
            end;
        end;
    end;
end.
