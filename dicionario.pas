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
  opcao         : byte;
  entradaPT     : TInfo;
  entradaEN     : TInfo;
  listaPrincipal: TNode;

{ =========================================================
    LISTA PRINCIPAL — duplo encadeamento
  ========================================================= }

procedure CriarLista(var lista: TNode);
begin
  lista := nil;
end;

procedure AdicionarChave(var lista: TNode; chave: TInfo);
var
  novoNo  : TNode;
  anterior: TNode;
  atual   : TNode;
  existe  : boolean;
begin
  atual  := lista;
  existe := false;
  while (atual <> nil) and (not existe) do
  begin
    if atual^.portugues = chave then
      existe := true
    else
      atual := atual^.prox;
  end;

  if existe then
  begin
    writeln('>>> Chave "', chave, '" ja existe!'); readkey;
  end
  else
  begin
    new(novoNo);
    if novoNo = nil then
    begin
      writeln('Memoria cheia!'); readkey;
    end
    else
    begin
      novoNo^.portugues := chave;
      novoNo^.infoDois  := nil;
      novoNo^.prox      := nil;
      novoNo^.ant       := nil;

      if (lista = nil) or (chave < lista^.portugues) then
      begin
        novoNo^.prox := lista;
        if lista <> nil then
          lista^.ant := novoNo;
        lista := novoNo;
      end
      else
      begin
        anterior := lista;
        atual    := lista^.prox;

        while (atual <> nil) and (chave > atual^.portugues) do
        begin
          anterior := atual;
          atual    := atual^.prox;
        end;

        novoNo^.prox      := atual;
        novoNo^.ant       := anterior;
        anterior^.prox    := novoNo;
        if atual <> nil then
          atual^.ant := novoNo;
      end;

      writeln('>>> Chave "', chave, '" inserida.'); readkey;
    end;
  end;
end;

{ =========================================================
    DICIONÁRIO — simples encadeamento
    Regra: verbete entra no 1o nó cuja chave > verbete
  ========================================================= }

function BuscarNoCorreto(lista: TNode; verbete: TInfo): TNode;
var
  atual     : TNode;
  encontrado: boolean;
begin
  atual      := lista;
  encontrado := false;
  while (atual <> nil) and (not encontrado) do
  begin
    if atual^.portugues > verbete then
      encontrado := true
    else
      atual := atual^.prox;
  end;
  if encontrado then
    BuscarNoCorreto := atual
  else
    BuscarNoCorreto := nil;
end;

procedure AdicionarVerbete(var lista: TNode; verbetePT, verbeteEN: TInfo);
var
  noCorreto   : TNode;
  noVerbete   : TNode;
  noTraducao  : TNode;
  anterior    : TNode;
  atual       : TNode;
  existe      : boolean;
begin
  noCorreto := BuscarNoCorreto(lista, verbetePT);

  if noCorreto = nil then
  begin
    writeln('>>> Nao ha chave maior que "', verbetePT,
            '". Cadastre uma palavra-chave primeiro.'); readkey;
  end
  else
  begin
    atual  := noCorreto^.infoDois;
    existe := false;
    while (atual <> nil) and (not existe) do
    begin
      if atual^.portugues = verbetePT then
        existe := true
      else
        atual := atual^.prox;
    end;

    if existe then
    begin
      writeln('>>> "', verbetePT, '" ja existe no grupo de "',
              noCorreto^.portugues, '"!'); readkey;
    end
    else
    begin
      { Nó de tradução (C): armazena o inglês no campo portugues }
      new(noTraducao);
      if noTraducao = nil then
      begin
        writeln('Memoria cheia!'); readkey;
      end
      else
      begin
        noTraducao^.portugues := verbeteEN;
        noTraducao^.ant       := nil;
        noTraducao^.infoDois  := nil;
        noTraducao^.prox      := nil;

        { Nó do verbete PT (B) }
        new(noVerbete);
        if noVerbete = nil then
        begin
          dispose(noTraducao);
          writeln('Memoria cheia!'); readkey;
        end
        else
        begin
          noVerbete^.portugues := verbetePT;
          noVerbete^.infoDois  := noTraducao;
          noVerbete^.ant       := nil;
          noVerbete^.prox      := nil;

          if (noCorreto^.infoDois = nil) or
             (verbetePT < noCorreto^.infoDois^.portugues) then
          begin
            noVerbete^.prox    := noCorreto^.infoDois;
            noCorreto^.infoDois := noVerbete;
          end
          else
          begin
            anterior := noCorreto^.infoDois;
            atual    := noCorreto^.infoDois^.prox;

            while (atual <> nil) and (verbetePT > atual^.portugues) do
            begin
              anterior := atual;
              atual    := atual^.prox;
            end;

            noVerbete^.prox := atual;
            anterior^.prox  := noVerbete;
          end;

          writeln('>>> "', verbetePT, ' -> ', verbeteEN,
                  '" inserido no grupo de "', noCorreto^.portugues, '".'); readkey;
        end;
      end;
    end;
  end;
end;

procedure RemoverVerbete(var lista: TNode; verbetePT: TInfo);
var
  noCorreto: TNode;
  anterior : TNode;
  atual    : TNode;
  encontrado: boolean;
begin
  noCorreto := BuscarNoCorreto(lista, verbetePT);

  if noCorreto = nil then
  begin
    writeln('>>> Nenhum grupo encontrado para "', verbetePT, '".'); readkey;
  end
  else
  begin
    anterior   := nil;
    atual      := noCorreto^.infoDois;
    encontrado := false;

    while (atual <> nil) and (not encontrado) do
    begin
      if atual^.portugues = verbetePT then
        encontrado := true
      else
      begin
        anterior := atual;
        atual    := atual^.prox;
      end;
    end;

    if not encontrado then
    begin
      writeln('>>> "', verbetePT, '" nao encontrado no grupo de "',
              noCorreto^.portugues, '".'); readkey;
    end
    else
    begin
      if anterior = nil then
        noCorreto^.infoDois := atual^.prox
      else
        anterior^.prox := atual^.prox;

      dispose(atual^.infoDois);
      dispose(atual);
      writeln('>>> "', verbetePT, '" removido do grupo de "',
              noCorreto^.portugues, '".'); readkey;
    end;
  end;
end;

procedure Consultar(lista: TNode; verbetePT: TInfo);
var
  noCorreto : TNode;
  atual     : TNode;
  encontrado: boolean;
begin
  noCorreto := BuscarNoCorreto(lista, verbetePT);

  if noCorreto = nil then
  begin
    writeln('>>> Nenhum grupo encontrado para "', verbetePT, '".'); readkey;
  end
  else
  begin
    atual      := noCorreto^.infoDois;
    encontrado := false;
    while (atual <> nil) and (not encontrado) do
    begin
      if atual^.portugues = verbetePT then
        encontrado := true
      else
        atual := atual^.prox;
    end;

    if not encontrado then
    begin
      writeln('>>> "', verbetePT, '" nao cadastrado.'); readkey;
    end
    else
    begin
      writeln('----------------------------------------');
      writeln('  [PT] ', atual^.portugues,
              '  ->  [EN] ', atual^.infoDois^.portugues);
      writeln('  (grupo: ', noCorreto^.portugues, ')');
      writeln('----------------------------------------');
      readkey;
    end;
  end;
end;

procedure EscreverTudo(lista: TNode);
var
  noAtual : TNode;
  verbete : TNode;
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
    noAtual := lista;
    while noAtual <> nil do
    begin
      writeln('[ ', noAtual^.portugues, ' ]');
      verbete := noAtual^.infoDois;
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
      noAtual := noAtual^.prox;
    end;
    writeln('========================================');
    readkey;
  end;
end;

{ =========================================================
    PROGRAMA PRINCIPAL
  ========================================================= }
begin
  opcao := 1;
  CriarLista(listaPrincipal);

  while opcao <> 0 do
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
    readln(opcao);
    writeln;

    case opcao of
      1:
      begin
        clrscr;
        write('Palavra-chave: ');
        readln(entradaPT);
        AdicionarChave(listaPrincipal, entradaPT);
      end;

      2:
      begin
        clrscr;
        write('Verbete em portugues: ');
        readln(entradaPT);
        write('Traducao em ingles  : ');
        readln(entradaEN);
        AdicionarVerbete(listaPrincipal, entradaPT, entradaEN);
      end;

      3:
      begin
        clrscr;
        write('Verbete a remover: ');
        readln(entradaPT);
        RemoverVerbete(listaPrincipal, entradaPT);
      end;

      4:
      begin
        clrscr;
        write('Verbete a consultar: ');
        readln(entradaPT);
        Consultar(listaPrincipal, entradaPT);
      end;

      5: EscreverTudo(listaPrincipal);
    end;
  end;

  writeln('Encerrando. Ate logo!');
end.
