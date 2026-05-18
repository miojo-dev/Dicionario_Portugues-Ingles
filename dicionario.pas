program DicionarioPortuguesIngles;

uses crt;

{ =========================================================
    TIPOS

    Um único TElemento serve para TODOS os nós do programa:

    (A) Nó da lista PRINCIPAL (duplo encadeamento):
        ant       -> nó anterior na lista principal
        portugues -> palavra-chave (limite do grupo)
        infoDois  -> primeiro nó do dicionário deste grupo
        prox      -> próximo nó na lista principal

    (B) Nó do DICIONÁRIO (simples encadeamento):
        ant       -> nil (não usado)
        portugues -> verbete em português
        infoDois  -> nó-tradução (tipo C abaixo)
        prox      -> próximo verbete

    (C) Nó de TRADUÇÃO (folha):
        ant       -> nil
        portugues -> tradução em inglês
        infoDois  -> nil
        prox      -> nil
  ========================================================= }

type
  TInfo     = string;
  TNode     = ^TElemento;
  TElemento = record
    ant      : TNode;
    portugues: TInfo;
    infoDois : TNode;
    prox     : TNode;
  end;

var
  option    : byte;
  str, strEN: TInfo;
  str_lista : TNode;

{ =========================================================
    AUXILIAR
  ========================================================= }

function Min(s: string): string;
var i: integer;
begin
  for i := 1 to Length(s) do
    if s[i] in ['A'..'Z'] then
      s[i] := Chr(Ord(s[i]) + 32);
  Min := s;
end;

{ =========================================================
    LISTA PRINCIPAL — duplo encadeamento
  ========================================================= }

procedure CriarLista(var lista: TNode);
begin
  lista := nil;
end;

procedure AdicionarChave(var lista: TNode; info: TInfo);
var
  aux, anterior, atual: TNode;
  existe: boolean;
begin
  atual  := lista;
  existe := false;
  while (atual <> nil) and (not existe) do
  begin
    if Min(atual^.portugues) = Min(info) then
      existe := true
    else
      atual := atual^.prox;
  end;

  if existe then
  begin
    writeln('>>> Chave "', info, '" ja existe!'); readkey;
  end
  else
  begin
    new(aux);
    if aux = nil then
    begin
      writeln('Memoria cheia!'); readkey;
    end
    else
    begin
      aux^.portugues := info;
      aux^.infoDois  := nil;
      aux^.prox      := nil;
      aux^.ant       := nil;

      if (lista = nil) or (Min(info) < Min(lista^.portugues)) then
      begin
        aux^.prox := lista;
        if lista <> nil then
          lista^.ant := aux;
        lista := aux;
      end
      else
      begin
        anterior := lista;
        atual    := lista^.prox;

        while (atual <> nil) and (Min(info) > Min(atual^.portugues)) do
        begin
          anterior := atual;
          atual    := atual^.prox;
        end;

        aux^.prox      := atual;
        aux^.ant       := anterior;
        anterior^.prox := aux;
        if atual <> nil then
          atual^.ant := aux;
      end;

      writeln('>>> Chave "', info, '" inserida.'); readkey;
    end;
  end;
end;

{ =========================================================
    DICIONÁRIO — simples encadeamento
    Regra: verbete entra no 1o nó cuja chave > verbete
  ========================================================= }

function BuscarNo(lista: TNode; verbete: TInfo): TNode;
var
  atual     : TNode;
  encontrado: boolean;
begin
  atual      := lista;
  encontrado := false;
  while (atual <> nil) and (not encontrado) do
  begin
    if Min(atual^.portugues) > Min(verbete) then
      encontrado := true
    else
      atual := atual^.prox;
  end;
  if encontrado then
    BuscarNo := atual
  else
    BuscarNo := nil;
end;

procedure AdicionarVerbete(var lista: TNode; ptBR, ptEN: TInfo);
var
  no        : TNode;
  aux, noEN : TNode;
  ant, atual: TNode;
  existe    : boolean;
begin
  no := BuscarNo(lista, ptBR);

  if no = nil then
  begin
    writeln('>>> Nao ha chave maior que "', ptBR,
            '". Cadastre uma palavra-chave primeiro.'); readkey;
  end
  else
  begin
    atual  := no^.infoDois;
    existe := false;
    while (atual <> nil) and (not existe) do
    begin
      if Min(atual^.portugues) = Min(ptBR) then
        existe := true
      else
        atual := atual^.prox;
    end;

    if existe then
    begin
      writeln('>>> "', ptBR, '" ja existe no grupo de "', no^.portugues, '"!');
      readkey;
    end
    else
    begin
      { Nó de tradução (C): portugues = inglês, resto nil }
      new(noEN);
      if noEN = nil then
      begin
        writeln('Memoria cheia!'); readkey;
      end
      else
      begin
        noEN^.portugues := ptEN;
        noEN^.ant       := nil;
        noEN^.infoDois  := nil;
        noEN^.prox      := nil;

        { Nó do verbete PT (B) }
        new(aux);
        if aux = nil then
        begin
          dispose(noEN);
          writeln('Memoria cheia!'); readkey;
        end
        else
        begin
          aux^.portugues := ptBR;
          aux^.infoDois  := noEN;
          aux^.ant       := nil;
          aux^.prox      := nil;

          if (no^.infoDois = nil) or
             (Min(ptBR) < Min(no^.infoDois^.portugues)) then
          begin
            aux^.prox    := no^.infoDois;
            no^.infoDois := aux;
          end
          else
          begin
            ant   := no^.infoDois;
            atual := no^.infoDois^.prox;

            while (atual <> nil) and (Min(ptBR) > Min(atual^.portugues)) do
            begin
              ant   := atual;
              atual := atual^.prox;
            end;

            aux^.prox := atual;
            ant^.prox := aux;
          end;

          writeln('>>> "', ptBR, ' -> ', ptEN,
                  '" inserido no grupo de "', no^.portugues, '".'); readkey;
        end;
      end;
    end;
  end;
end;

procedure RemoverVerbete(var lista: TNode; ptBR: TInfo);
var
  no        : TNode;
  ant, atual: TNode;
  encontrado: boolean;
begin
  no := BuscarNo(lista, ptBR);

  if no = nil then
  begin
    writeln('>>> Nenhum grupo encontrado para "', ptBR, '".'); readkey;
  end
  else
  begin
    ant        := nil;
    atual      := no^.infoDois;
    encontrado := false;

    while (atual <> nil) and (not encontrado) do
    begin
      if Min(atual^.portugues) = Min(ptBR) then
        encontrado := true
      else
      begin
        ant   := atual;
        atual := atual^.prox;
      end;
    end;

    if not encontrado then
    begin
      writeln('>>> "', ptBR, '" nao encontrado no grupo de "',
              no^.portugues, '".'); readkey;
    end
    else
    begin
      if ant = nil then
        no^.infoDois := atual^.prox
      else
        ant^.prox := atual^.prox;

      dispose(atual^.infoDois);   { libera nó de tradução }
      dispose(atual);             { libera nó PT           }
      writeln('>>> "', ptBR, '" removido do grupo de "', no^.portugues, '".');
      readkey;
    end;
  end;
end;

procedure Consultar(lista: TNode; ptBR: TInfo);
var
  no        : TNode;
  atual     : TNode;
  encontrado: boolean;
begin
  no := BuscarNo(lista, ptBR);

  if no = nil then
  begin
    writeln('>>> Nenhum grupo encontrado para "', ptBR, '".'); readkey;
  end
  else
  begin
    atual      := no^.infoDois;
    encontrado := false;
    while (atual <> nil) and (not encontrado) do
    begin
      if Min(atual^.portugues) = Min(ptBR) then
        encontrado := true
      else
        atual := atual^.prox;
    end;

    if not encontrado then
    begin
      writeln('>>> "', ptBR, '" nao cadastrado.'); readkey;
    end
    else
    begin
      writeln('----------------------------------------');
      writeln('  [PT] ', atual^.portugues,
              '  ->  [EN] ', atual^.infoDois^.portugues);
      writeln('  (grupo: ', no^.portugues, ')');
      writeln('----------------------------------------');
      readkey;
    end;
  end;
end;

procedure EscreverTudo(lista: TNode);
var
  no     : TNode;
  verbete: TNode;
begin
  clrscr;
  if lista = nil then
  begin
    writeln('>>> Dicionario vazio!'); readkey;
  end
  else
  begin
    writeln('========================================');
    writeln('      DICIONARIO PORTUGUES - INGLES     ');
    writeln('========================================');
    no := lista;
    while no <> nil do
    begin
      writeln('[ ', no^.portugues, ' ]');
      verbete := no^.infoDois;
      if verbete = nil then
        writeln('  (sem verbetes)')
      else
      begin
        while verbete <> nil do
        begin
          writeln('  [PT] ', verbete^.portugues,
                  '  ->  [EN] ', verbete^.infoDois^.portugues);
          verbete := verbete^.prox;
        end;
      end;
      no := no^.prox;
    end;
    writeln('========================================');
    readkey;
  end;
end;

{ =========================================================
    PROGRAMA PRINCIPAL
  ========================================================= }
begin
  option := 1;
  CriarLista(str_lista);

  while option <> 0 do
  begin
    clrscr;
    writeln('========================================');
    writeln('   DICIONARIO PORTUGUES - INGLES        ');
    writeln('========================================');
    writeln(' 0 - Sair');
    writeln(' 1 - Incluir palavra-chave');
    writeln(' 2 - Incluir verbete');
    writeln(' 3 - Remover verbete');
    writeln(' 4 - Consultar verbete');
    writeln(' 5 - Escrever todo o dicionario');
    writeln('========================================');
    write('Opcao: ');
    readln(option);
    writeln;

    case option of
      1:
      begin
        clrscr;
        write('Palavra-chave: ');
        readln(str);
        AdicionarChave(str_lista, str);
      end;

      2:
      begin
        clrscr;
        write('Verbete em portugues: ');
        readln(str);
        write('Traducao em ingles  : ');
        readln(strEN);
        AdicionarVerbete(str_lista, str, strEN);
      end;

      3:
      begin
        clrscr;
        write('Verbete a remover: ');
        readln(str);
        RemoverVerbete(str_lista, str);
      end;

      4:
      begin
        clrscr;
        write('Verbete a consultar: ');
        readln(str);
        Consultar(str_lista, str);
      end;

      5: EscreverTudo(str_lista);
    end;
  end;

  writeln('Encerrando. Ate logo!');
end.
