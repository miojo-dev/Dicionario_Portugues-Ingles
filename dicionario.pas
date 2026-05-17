program DicionarioPortuguesIngles;

uses crt;

{ =========================================================
    ESTRUTURAS DE DADOS
  ========================================================= }

type
  { Nó do dicionário (lista simplesmente encadeada, ordenada) }
  PDicionario = ^TDicionario;
  TDicionario = record
    verbetePortugues : string;
    verbeteIngles    : string;
    proximo          : PDicionario;
  end;

  { Nó da lista principal (lista duplamente encadeada, ordenada) }
  PLista = ^TLista;
  TLista = record
    anterior   : PLista;
    proximo    : PLista;
    palavraChave : string;
    ponteiroDic  : PDicionario;
  end;

var
  cabeca : PLista;   { cabeça da lista principal }

{ =========================================================
    FUNÇÕES AUXILIARES
  ========================================================= }

{ Converte string para minúsculas }
function Minusculo(s: string): string;
var
  i   : integer;
  res : string;
begin
  res := s;
  for i := 1 to Length(res) do
    if res[i] in ['A'..'Z'] then
      res[i] := Chr(Ord(res[i]) + 32);
  Minusculo := res;
end;

{ Retorna true se a <= b (comparação alfabética, case insensitive) }
function MenorOuIgual(a, b: string): boolean;
begin
  MenorOuIgual := Minusculo(a) <= Minusculo(b);
end;

{ Busca palavra-chave na lista principal; retorna nil se não encontrada }
function BuscarPalavraChave(palavra: string): PLista;
var
  atual     : PLista;
  encontrado: boolean;
begin
  atual      := cabeca;
  encontrado := false;
  while (atual <> nil) and (not encontrado) do
  begin
    if Minusculo(atual^.palavraChave) = Minusculo(palavra) then
      encontrado := true
    else
      atual := atual^.proximo;
  end;
  if encontrado then
    BuscarPalavraChave := atual
  else
    BuscarPalavraChave := nil;
end;

{ Retorna o primeiro nó da lista cuja palavraChave > verbete
  (esse é o nó que deve armazenar o verbete no seu dicionário)
  Retorna nil se nenhum nó satisfaz a condição }
function BuscarNoCorreto(verbete: string): PLista;
var
  atual     : PLista;
  encontrado: boolean;
begin
  atual      := cabeca;
  encontrado := false;
  while (atual <> nil) and (not encontrado) do
  begin
    if Minusculo(atual^.palavraChave) > Minusculo(verbete) then
      encontrado := true
    else
      atual := atual^.proximo;
  end;
  if encontrado then
    BuscarNoCorreto := atual
  else
    BuscarNoCorreto := nil;
end;

{ =========================================================
    OPERAÇÕES DA LISTA PRINCIPAL
  ========================================================= }

{ 1. Incluir palavra-chave na lista principal (ordenada) }
procedure InserirPalavraChave;
var
  nova      : PLista;
  atual     : PLista;
  palavra   : string;
  encontrado: boolean;
begin
  writeln;
  write('Palavra-chave: ');
  readln(palavra);

  { Verificar duplicata }
  encontrado := BuscarPalavraChave(palavra) <> nil;

  if encontrado then
    writeln('>>> Palavra-chave "', palavra, '" ja existe!')
  else
  begin
    New(nova);
    nova^.palavraChave := palavra;
    nova^.ponteiroDic  := nil;
    nova^.anterior     := nil;
    nova^.proximo      := nil;

    { Lista vazia }
    if cabeca = nil then
      cabeca := nova
    { Inserir antes da cabeça }
    else if MenorOuIgual(palavra, cabeca^.palavraChave) then
    begin
      nova^.proximo   := cabeca;
      cabeca^.anterior := nova;
      cabeca          := nova;
    end
    { Percorrer até encontrar posição correta }
    else
    begin
      atual := cabeca;
      while (atual^.proximo <> nil) and
            (MenorOuIgual(atual^.proximo^.palavraChave, palavra)) do
        atual := atual^.proximo;

      nova^.proximo  := atual^.proximo;
      nova^.anterior := atual;
      if atual^.proximo <> nil then
        atual^.proximo^.anterior := nova;
      atual^.proximo := nova;
    end;

    writeln('>>> Palavra-chave "', palavra, '" inserida com sucesso!');
  end;
end;

{ =========================================================
    OPERAÇÕES DO DICIONÁRIO
  ========================================================= }

{ 2. Incluir verbete: localiza automaticamente o nó correto
     (primeiro nó cuja palavraChave > verbete) }
procedure InserirNoDicionario;
var
  no        : PLista;
  novoDic   : PDicionario;
  atualDic  : PDicionario;
  ptBR, ptEN: string;
  encontrado: boolean;
begin
  writeln;
  write('Verbete em portugues: ');
  readln(ptBR);
  write('Traducao em ingles  : ');
  readln(ptEN);

  { Localizar o nó correto: primeiro cuja palavraChave > ptBR }
  no := BuscarNoCorreto(ptBR);

  if no = nil then
    writeln('>>> Nao existe palavra-chave maior que "', ptBR,
            '" na lista. Cadastre uma palavra-chave adequada primeiro.')
  else
  begin
    { Verificar duplicata }
    atualDic   := no^.ponteiroDic;
    encontrado := false;
    while (atualDic <> nil) and (not encontrado) do
    begin
      if Minusculo(atualDic^.verbetePortugues) = Minusculo(ptBR) then
        encontrado := true
      else
        atualDic := atualDic^.proximo;
    end;

    if encontrado then
      writeln('>>> Verbete "', ptBR, '" ja existe no dicionario de "',
              no^.palavraChave, '"!')
    else
    begin
      New(novoDic);
      novoDic^.verbetePortugues := ptBR;
      novoDic^.verbeteIngles    := ptEN;
      novoDic^.proximo          := nil;

      { Lista de verbetes vazia }
      if no^.ponteiroDic = nil then
        no^.ponteiroDic := novoDic
      { Inserir antes do primeiro }
      else if MenorOuIgual(ptBR, no^.ponteiroDic^.verbetePortugues) then
      begin
        novoDic^.proximo := no^.ponteiroDic;
        no^.ponteiroDic  := novoDic;
      end
      { Percorrer até posição correta }
      else
      begin
        atualDic := no^.ponteiroDic;
        while (atualDic^.proximo <> nil) and
              (MenorOuIgual(atualDic^.proximo^.verbetePortugues, ptBR)) do
          atualDic := atualDic^.proximo;

        novoDic^.proximo  := atualDic^.proximo;
        atualDic^.proximo := novoDic;
      end;

      writeln('>>> "', ptBR, ' -> ', ptEN, '" inserido no grupo de "',
              no^.palavraChave, '".');
    end;
  end;
end;

{ 3. Remover verbete: localiza automaticamente o nó correto pelo verbete }
procedure RemoverDoDicionario;
var
  ptBR        : string;
  no          : PLista;
  atualDic    : PDicionario;
  anteriorDic : PDicionario;
  encontrado  : boolean;
begin
  writeln;
  write('Verbete em portugues a remover: ');
  readln(ptBR);

  { Localizar o nó onde o verbete deveria estar }
  no := BuscarNoCorreto(ptBR);

  if no = nil then
    writeln('>>> Nenhum grupo adequado encontrado para "', ptBR, '".')
  else
  begin
    atualDic    := no^.ponteiroDic;
    anteriorDic := nil;
    encontrado  := false;

    while (atualDic <> nil) and (not encontrado) do
    begin
      if Minusculo(atualDic^.verbetePortugues) = Minusculo(ptBR) then
        encontrado := true
      else
      begin
        anteriorDic := atualDic;
        atualDic    := atualDic^.proximo;
      end;
    end;

    if not encontrado then
      writeln('>>> Verbete "', ptBR, '" nao encontrado no grupo de "',
              no^.palavraChave, '".')
    else
    begin
      if anteriorDic = nil then
        no^.ponteiroDic      := atualDic^.proximo
      else
        anteriorDic^.proximo := atualDic^.proximo;

      Dispose(atualDic);
      writeln('>>> Verbete "', ptBR, '" removido do grupo de "',
              no^.palavraChave, '".');
    end;
  end;
end;

{ 4. Consultar: busca um verbete e exibe sua tradução }
procedure Consultar;
var
  ptBR     : string;
  no       : PLista;
  atualDic : PDicionario;
  encontrado: boolean;
begin
  writeln;
  write('Verbete em portugues: ');
  readln(ptBR);

  no := BuscarNoCorreto(ptBR);

  if no = nil then
    writeln('>>> Nenhum grupo encontrado para "', ptBR, '".')
  else
  begin
    atualDic   := no^.ponteiroDic;
    encontrado := false;
    while (atualDic <> nil) and (not encontrado) do
    begin
      if Minusculo(atualDic^.verbetePortugues) = Minusculo(ptBR) then
        encontrado := true
      else
        atualDic := atualDic^.proximo;
    end;

    if not encontrado then
      writeln('>>> Verbete "', ptBR, '" nao cadastrado.')
    else
    begin
      writeln('----------------------------------------');
      writeln('  [PT] ', atualDic^.verbetePortugues,
              '  ->  [EN] ', atualDic^.verbeteIngles);
      writeln('  (grupo: ', no^.palavraChave, ')');
      writeln('----------------------------------------');
    end;
  end;
end;

{ 5. Exibir todo o dicionário }
procedure EscreverTudo;
var
  no       : PLista;
  atualDic : PDicionario;
begin
  writeln;
  if cabeca = nil then
    writeln('>>> Dicionario vazio!')
  else
  begin
    writeln('========================================');
    writeln('        DICIONARIO PORTUGUES-INGLES     ');
    writeln('========================================');
    no := cabeca;
    while no <> nil do
    begin
      writeln('[ ', no^.palavraChave, ' ]');
      atualDic := no^.ponteiroDic;
      if atualDic = nil then
        writeln('  (sem verbetes)')
      else
      begin
        while atualDic <> nil do
        begin
          writeln('  [PT] ', atualDic^.verbetePortugues,
                  '  ->  [EN] ', atualDic^.verbeteIngles);
          atualDic := atualDic^.proximo;
        end;
      end;
      no := no^.proximo;
    end;
    writeln('========================================');
  end;
end;

{ =========================================================
    MENU PRINCIPAL
  ========================================================= }

procedure Menu;
var
  opcao    : integer;
  continuar: boolean;
begin
  continuar := true;
  while continuar do
  begin
    writeln;
    writeln('========================================');
    writeln('   DICIONARIO PORTUGUES - INGLES        ');
    writeln('========================================');
    writeln(' 1 - Incluir palavra-chave              ');
    writeln(' 2 - Incluir verbete (auto-roteado)     ');
    writeln(' 3 - Remover verbete do dicionario      ');
    writeln(' 4 - Consultar palavra-chave            ');
    writeln(' 5 - Escrever todo o dicionario         ');
    writeln(' 0 - Sair                               ');
    writeln('========================================');
    write('Opcao: ');
    readln(opcao);

    case opcao of
      1: InserirPalavraChave;
      2: InserirNoDicionario;
      3: RemoverDoDicionario;
      4: Consultar;
      5: EscreverTudo;
      0: continuar := false;
    else
      writeln('>>> Opcao invalida! Tente novamente.');
    end;
  end;
end;

{ =========================================================
    PROGRAMA PRINCIPAL
  ========================================================= }

begin
  cabeca := nil;
  Menu;
  writeln('Encerrando o programa. Ate logo!');
end.
