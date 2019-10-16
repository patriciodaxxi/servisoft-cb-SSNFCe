unit uCupomFiscal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, Grids, DBGrids, SMDBGrid,
  StdCtrls, RxLookup, DBFilter, Mask, ToolEdit, CurrEdit, FMTBcd, DB, Provider, DBClient, SqlExpr, DBCtrls, Buttons, jpeg,
  DBTables, uDmCupomFiscal, uDmEstoque, uDmMovimento, rsDBUtils, uDmParametros, NxCollection, UCupomFiscalImposto, StrUtils,
  ValEdit, UCBase, ACBrBase, ACBrBAL, ACBrDevice;

type
  TfCupomFiscal = class(TForm)
    Panel1: TPanel;
    SMDBGrid1: TSMDBGrid;
    Panel2: TPanel;
    Panel4: TPanel;
    Label5: TLabel;
    CurrencyEdit3: TCurrencyEdit;
    PnlParcial: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Panel6: TPanel;
    Label3: TLabel;
    CurrencyEdit1: TCurrencyEdit;
    Label11: TLabel;
    Label12: TLabel;
    SMDBGrid2: TSMDBGrid;
    btCancelar: TNxButton;
    btFinalizar: TNxButton;
    Panel3: TPanel;
    Label7: TLabel;
    DBEdit1: TDBEdit;
    Label8: TLabel;
    pnlDesconto: TPanel;
    btComanda: TNxButton;
    pnlCopiar: TPanel;
    btnCopiarSacola: TBitBtn;
    btnCopiarPedido: TBitBtn;
    ValueListEditor1: TValueListEditor;
    Panel9: TPanel;
    BtPreco: TNxButton;
    btConfirmarIt: TNxButton;
    btPedido: TNxButton;
    btOrcamento: TNxButton;
    Image1: TImage;
    UCControls1: TUCControls;
    btCliente: TNxButton;
    btnCopiarComanda: TBitBtn;
    Panel5: TPanel;
    Label18: TLabel;
    Label19: TLabel;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    Edit3: TEdit;
    Label2: TLabel;
    Label20: TLabel;
    DBEdit4: TDBEdit;
    Edit2: TEdit;
    Label4: TLabel;
    CurrencyEdit2: TCurrencyEdit;
    Label9: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    CurrencyEdit4: TCurrencyEdit;
    CurrencyEdit6: TCurrencyEdit;
    Label17: TLabel;
    CurrencyEdit7: TCurrencyEdit;
    Label10: TLabel;
    DBEdit5: TDBEdit;
    ACBrBAL1: TACBrBAL;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CurrencyEdit1Exit(Sender: TObject);
    procedure RxDBLookupCombo2Exit(Sender: TObject);
    procedure SMDBGrid1GetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CurrencyEdit6Exit(Sender: TObject);
    procedure RxDBLookupCombo2Enter(Sender: TObject);
    procedure btConfirmarItClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btFinalizarClick(Sender: TObject);
    procedure CurrencyEdit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CurrencyEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1Enter(Sender: TObject);
    procedure btPrecoClick(Sender: TObject);
    procedure btnCopiarSacolaClick(Sender: TObject);
    procedure btnCopiarPedidoClick(Sender: TObject);
    procedure Edit3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ValueListEditor1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btComandaClick(Sender: TObject);
    procedure btOrcamentoClick(Sender: TObject);
    procedure btPedidoClick(Sender: TObject);
    procedure ValueListEditor1DblClick(Sender: TObject);
    procedure btClienteClick(Sender: TObject);
    procedure CurrencyEdit7Exit(Sender: TObject);
    procedure CurrencyEdit4Exit(Sender: TObject);
    procedure CurrencyEdit6Enter(Sender: TObject);
    procedure CurrencyEdit4Enter(Sender: TObject);
    procedure CurrencyEdit7Enter(Sender: TObject);
    procedure CurrencyEdit2Enter(Sender: TObject);
    procedure CurrencyEdit2Exit(Sender: TObject);
    procedure btnCopiarComandaClick(Sender: TObject);
    procedure SMDBGrid2DblClick(Sender: TObject);
    procedure CurrencyEdit1Enter(Sender: TObject);
    procedure CurrencyEdit6KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CurrencyEdit4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CurrencyEdit7KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit3Exit(Sender: TObject);
    procedure DBEdit4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SMDBGrid1DblClick(Sender: TObject);
    procedure ACBrBAL1LePeso(Peso: Double; Resposta: String);
  private
    { Private declarations }
    fDmParametros: TDmParametros;
    fDmCupomFiscal: TDmCupomFiscal;
    
    vAliqIcms: Real;
    vTipoDesc: String;
    vSitTrib: Integer;
    vCalcula_IPI, vFinaliza: Boolean;
    vID_Produto: Integer;
    vFilial_Loc : Integer;
    
    procedure Limpa_Campos;
    function posicionaProduto: Boolean;
    procedure prc_Calcular_Tributos_Transparencia;
    function prc_Calcular_Media_Tributos: Currency;
    procedure prc_Calcular_IPI;
    procedure prc_ImprimeComanda;
    procedure prc_EnterCodigo;
    function fnc_VerficaFracionado(vUnidade: String): Boolean;
    procedure FinalizaParcial(vTipo: String);
    procedure prc_CorTamanho;
    procedure prcPesa;

    procedure prc_Inserir;

  public
    { Public declarations }
    fDmEstoque: TDmEstoque;
    fDmMovimento: TDmMovimento;

    vTeste: Boolean;
    vSacolaSelecionada: Boolean;
    vItem_original: Integer;
    vUnidade, vFormaQtd: String;
    vPerc_Ipi: Real;
    vNome_Complementar: String;
    vID_Pedido: Integer;
    vItem_Pedido: Integer;
    vNumero_OC: String;
    vNumero_OS: String;
    vItem_Cliente: Integer;
    vNum_Pedido: Integer;
    vPedidoSelecionado: Boolean;
    vPreco_Ori: Real;
    vGeraIcms: Boolean;
    vCopiandoComanda: Boolean;

    procedure Excluir_Estoque(Filial,NumMov: Integer);
    procedure prc_Move_Itens;
    function fnc_Estoque_OK(ID_Produto, ID_Cor: Integer; Tamanho: String; Qtd: Real): Boolean;

    function fnc_Validacao_OK : Boolean;
    //procedure prc_Busca_IBPT;
  end;

var
  fCupomFiscal: TfCupomFiscal;

implementation

//---------------TROCAR IMPRESSORA
uses UCupomFiscalPgto, UCupomFiscalCanc, USel_Produto, uUtilPadrao, uComandaR, uCupomCliente, uCalculo_CupomFiscal, Math,
  USenha, uUtilCupom, UConsPreco, USel_Sacola_CF, USel_Pedido_CF, DmdDatabase, uMenu, UCupomFiscalCli, USel_Comanda_CF,
  uCupomFiscalParcela, uSel_CorTamanho, uBalanca;

{$R *.dfm}

procedure TfCupomFiscal.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  fim: Integer; //balan�a Urano
begin
  Tag := 0;
  if fDmCupomFiscal.cdsCupomFiscal.State in [dsEdit,dsInsert] then
  begin
    fDmCupomFiscal.Excluir_Duplicata;
    fDmCupomFiscal.Excluir_ExtComissao;
    fDmCupomFiscal.prc_Excluir_Financeiro;
    fDmCupomFiscal.prc_Excluir_Movimento;
    fDmCupomFiscal.prcExcluir;
  end;

  FreeAndNil(fDmEstoque);
  FreeAndNil(fDmMovimento);

  prc_Grava_Grid(SMDBGrid1,Name,fDmCupomFiscal.qParametros_GeralENDGRIDS.AsString);

  if (fDmCupomFiscal.cdsCupomParametrosUSA_BALANCA.AsString = 'S') then
    if vBalanca = 'URANO' then
      fim := _FechaPortaSerial();

  Action := Cafree;
end;

procedure TfCupomFiscal.FormShow(Sender: TObject);
var
  i: Integer;
begin
  fDmCupomFiscal := TDmCupomFiscal.Create(Self);
  oDBUtils.SetDataSourceProperties(Self,fDmCupomFiscal);
  oDBUtils.OpenTables(True,Self);

  fDmParametros := TdmParametros.Create(Self);
  vFilial_Loc   := vFilial;
  if fDmCupomFiscal.cdsFilialID.AsInteger <> vFilial_Loc then
    fDmCupomFiscal.cdsFilial.Locate('ID',fDmCupomFiscal.cdsCupom_ItensID_PRODUTO.AsInteger,[loCaseInsensitive]);

  fDmCupomFiscal.prc_Abrir_CSTICMS(fDmCupomFiscal.cdsFilialSIMPLES.AsString);
  if not fnc_Validacao_OK then
  begin
    Close;
    exit;
  end;
  fDmCupomFiscal.cdsTipoCobranca.Open;
  fDmCupomFiscal.prc_Abrir_CondPgto;
  fDmCupomFiscal.cdsVendedor.Open;

  fDmEstoque := TDmEstoque.Create(Self);
  fDmMovimento := TdmMovimento.Create(Self);

  pnlDesconto.Visible := (fDmCupomFiscal.cdsCupomParametrosUSA_DESCONTO.AsString = 'I') or
                         (fDmCupomFiscal.cdsCupomParametrosUSA_DESCONTO.AsString = 'A');
  vFormaQtd := '0.000';

  prc_le_Grid(SMDBGrid1,Name,fDmCupomFiscal.qParametros_GeralENDGRIDS.AsString);
  PnlParcial.Visible := (fDmCupomFiscal.cdsCupomParametrosUSA_CARTAO_COMANDA.AsString = 'S') or
                        (fDmCupomFiscal.cdsCupomParametrosUSA_ORCAMENTO.AsString = 'S') or
                        (fDmCupomFiscal.cdsCupomParametrosUSA_PEDIDO.AsString = 'S');

  if fDmCupomFiscal.cdsCupomParametrosPRODUTO_PADRAO.AsInteger > 0 then
  begin
    Edit1.Text := fDmCupomFiscal.cdsCupomParametrosPRODUTO_PADRAO.AsString;
    prc_EnterCodigo;
  end;

  CurrencyEdit1.Value := fDmCupomFiscal.cdsCupomParametrosQTD_PADRAO.AsCurrency;
  if Panel2.Enabled then
    case fDmCupomFiscal.cdsCupomParametrosPRIMEIRO_CAMPO.AsInteger of
      1: begin
           CurrencyEdit1.SetFocus;
           CurrencyEdit1.SelectAll;
         end;
      2: Edit1.SetFocus;
      3: Edit3.SetFocus;
    end;

  btComanda.Visible   := fDmCupomFiscal.cdsCupomParametrosUSA_CARTAO_COMANDA.AsString = 'S';
  btOrcamento.Visible := fDmCupomFiscal.cdsCupomParametrosUSA_ORCAMENTO.AsString = 'S';
  btPedido.Visible    := fDmCupomFiscal.cdsCupomParametrosUSA_PEDIDO.AsString = 'S';

  case fDmCupomFiscal.cdsCupomParametrosORDEM_CAMPOS.AsInteger of
    1: begin //Qtd primeiro
         Label3.Top := 20;
         CurrencyEdit1.Top := 3;

         Label1.Top := 53;
         Edit1.Top  := 35;

         CurrencyEdit1.TabOrder := 0;
         Edit1.TabOrder := 1;
       end;
    2: begin //Cod primeiro
         Label3.Top := 53;
         CurrencyEdit1.Top := 35;

         Label1.Top := 20;
         Edit1.Top  := 3;

         CurrencyEdit1.TabOrder := 1;
         Edit1.TabOrder := 0;
       end;
  end;

  if FileExists(fDmCupomFiscal.cdsFilialENDLOGO.AsString) then
    Image1.Picture.LoadFromFile(fDmCupomFiscal.cdsFilialENDLOGO.AsString);

  if fDmCupomFiscal.cdsParametrosUSA_NFCE.AsString = 'S' then
    btCancelar.Caption := 'E&xcluir Produto';

  Label12.Caption := 'C�digo de barras ou' + #13;
  if fDmCupomFiscal.cdsCupomParametrosUSA_COD_REF.AsString = 'R' then
    Label12.Caption := Label12.Caption + 'Refer�ncia'
  else
    Label12.Caption := Label12.Caption + 'C�digo do cadastro';
  Label2.Visible    := (fDmCupomFiscal.cdsCupomParametrosMOSTRA_NOME_PRODUTO.AsString = 'S');
  Edit3.Enabled     := (fDmCupomFiscal.cdsCupomParametrosMOSTRA_NOME_PRODUTO.AsString = 'S');

  for i := 0 to SMDBGrid1.ColCount - 2 do
  begin
    if SMDBGrid1.Columns[i].FieldName = 'REFERENCIA' then
      SMDBGrid1.Columns[i].Visible := fDmCupomFiscal.cdsCupomParametrosUSA_COD_REF.AsString = 'R';
    if (fDmCupomFiscal.cdsParametrosUSA_NFCE.AsString = 'S') and (SMDBGrid1.Columns[i].FieldName = 'NOMEPRODUTO') then
      SMDBGrid1.Columns[i].FieldName := 'NOME_PRODUTO';
  end;
  if fDmCupomFiscal.cdsParametrosGRAVAR_CONSUMO_NOTA.AsString = 'S' then
    fDmCupomFiscal.prc_Abrir_Cupom_ProdPrincipal(fDmCupomFiscal.cdsCupomFiscalID.AsInteger,0);

  pnlCopiar.Visible := ((fDmCupomFiscal.cdsParametrosGRAVAR_CONSUMO_NOTA.AsString = 'S') or
                       (fDmCupomFiscal.cdsCupomParametrosUSA_COPIA_PEDIDO_CF.AsString = 'S') or
                       (fDmCupomFiscal.cdsCupomParametrosUSA_CARTAO_COMANDA.AsString = 'S'));
  if pnlCopiar.Visible then
  begin
    btnCopiarSacola.Visible  := (fDmCupomFiscal.cdsParametrosGRAVAR_CONSUMO_NOTA.AsString = 'S');
    btnCopiarPedido.Visible  := (fDmCupomFiscal.cdsCupomParametrosUSA_COPIA_PEDIDO_CF.AsString = 'S');
    btnCopiarComanda.Visible := (fDmCupomFiscal.cdsCupomParametrosUSA_CARTAO_COMANDA.AsString = 'S');
  end;

//////////////////////////////////
  if (fDmCupomFiscal.cdsCupomParametrosUSA_BALANCA.AsString = 'S') then
  begin
    if vBalanca = 'URANO' then
    begin
      _AlteraModeloBalanca(3);//US POP
      _AlteraModoOperacao(0);//Computador Requisita

      if _AbrePortaSerial(vPortaBalanca) < 1 then
        ShowMessage('N�o foi possivel conectar na porta da balan�a ' + vPortaBalanca + '!');
    end
    else
    if vBalanca = 'ACBR' then
    begin
    end;  
  end;
//////////////////////////////////


  vPedidoSelecionado := False;
  vUnidade           := '';
  vPerc_Ipi          := 0;
  vNome_Complementar := '';
  vID_Pedido         := 0;
  vItem_Pedido       := 0;
  vNumero_OC         := '';
  vNumero_OS         := '';
  vItem_Cliente      := 0;
  vNum_Pedido        := 0;
end;

procedure TfCupomFiscal.Edit1Exit(Sender: TObject);
begin
  if vFinaliza then //quando c�digo vazio
    Exit;

  if Edit1.Text = '0' then  //cai no campo para procura por nome
  begin
    Edit3.ReadOnly := False;
    Edit3.TabStop  := True;
    Edit3.SetFocus;
    Exit;
  end
  else
  if Edit1.Text = fDmCupomFiscal.cdsCupomParametrosID_PRODUTO_GENERICO.AsString then
  begin
    Edit3.ReadOnly := False;
    Edit3.TabStop  := True;
  end
  else
  begin
    Edit3.ReadOnly := True;
    Edit3.TabStop  := False;
  end;

  if not posicionaProduto then
    Exit;

  if Trim(Edit1.Text) <> '' then
  begin
    Edit3.Text := fDmCupomFiscal.cdsProdutoNOME.AsString;
    //11/01/2017  Cleomar
    if StrToFloat(FormatFloat('0.0000',vPreco_Pos)) > 0 then
      CurrencyEdit2.Value := vPreco_Pos
    else
      CurrencyEdit2.Value := fDmCupomFiscal.cdsProdutoPRECO_VENDA.AsCurrency;
    //*************
    if (not vCopiandoComanda) and (Length(Edit1.Text) < 5) and
       ((fDmCupomFiscal.cdsCupomParametrosUSA_BALANCA.AsString = 'S') and
       ((fDmCupomFiscal.cdsProdutoUNIDADE.AsString = 'KG') or
       (fDmCupomFiscal.cdsProdutoUNIDADE.AsString = 'Kg') or
       (fDmCupomFiscal.cdsProdutoUNIDADE.AsString = 'kg'))) then
    begin
       if acbrBal1.Ativo then
          ACBrBAL1.Desativar;
       prcPesa;
    end;

    CurrencyEdit3.Value := StrToFloat(FormatFloat('0.00',CurrencyEdit2.Value * CurrencyEdit1.Value));
    prc_Move_Itens;
    CurrencyEdit1Exit(Sender);
  end;
end;

procedure TfCupomFiscal.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := fnc_Encerrar_Tela(fDmCupomFiscal.cdsCupomFiscal);
end;

procedure TfCupomFiscal.CurrencyEdit1Exit(Sender: TObject);
begin
  if (CurrencyEdit2.Value > 0) and (CurrencyEdit1.Value > 0) then
  begin
    prc_Calcular_IPI;
    CurrencyEdit3.Value := StrToFloat(FormatFloat('0.00',CurrencyEdit2.Value * CurrencyEdit1.Value));
  end;
end;

procedure TfCupomFiscal.RxDBLookupCombo2Exit(Sender: TObject);
begin
//  vAliqIcms := cdsSitTrib_CFPERCENTUAL.AsFloat; //juca 22/04/13
end;

procedure TfCupomFiscal.Limpa_Campos;
begin
  Edit1.Clear;
  Edit3.Clear;
  CurrencyEdit1.Value := fDmCupomFiscal.cdsCupomParametrosQTD_PADRAO.AsCurrency;
  CurrencyEdit2.Clear;
  CurrencyEdit3.Clear;
  CurrencyEdit6.Clear;
  CurrencyEdit4.Clear;
  CurrencyEdit7.Clear;
  vPreco_Pos := 0;
  vAliqIcms  := 0;

  if fDmCupomFiscal.cdsCupomParametrosPRODUTO_PADRAO.AsInteger > 0 then
  begin
    Edit1.Text := fDmCupomFiscal.cdsCupomParametrosPRODUTO_PADRAO.AsString;
    prc_EnterCodigo;
  end;

  vCalcula_IPI := True;
  vPedidoSelecionado := False;
  vUnidade           := '';
  vPerc_Ipi          := 0;
  vNome_Complementar := '';
  vID_Pedido         := 0;
  vItem_Pedido       := 0;
  vNumero_OC         := '';
  vNumero_OS         := '';
  vItem_Cliente      := 0;
  vNum_Pedido        := 0;
end;

procedure TfCupomFiscal.SMDBGrid1GetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  if fDmCupomFiscal.cdsCupom_ItensCANCELADO.AsString = 'S' then
    AFont.Color := clRed;
end;

procedure TfCupomFiscal.Excluir_Estoque(Filial,NumMov: Integer);
begin
  fDmCupomFiscal.cdsEstoqueMov.IndexFieldNames := 'Filial;NumMov';
  if fDmCupomFiscal.cdsEstoqueMov.FindKey([Filial,NumMov]) then
    fDmCupomFiscal.cdsEstoqueMov.Delete;
end;

procedure TfCupomFiscal.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = Vk_Return) then
  begin
    if Copy(Edit1.Text,Length(Edit1.Text),1) = '*' then
    begin
      CurrencyEdit1.Value := StrToFloat(Copy(Edit1.Text,1,Length(Edit1.Text) - 1));
      Edit1.Clear;
      Exit;
    end;

    prc_EnterCodigo;
  end;
end;

procedure TfCupomFiscal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not (Panel4.Enabled) then
    Exit;

  if (Key = Vk_F10) and not(fDmCupomFiscal.cdsCupom_Itens.IsEmpty) then
    btFinalizarClick(Sender);

  if (Shift = [ssCtrl]) and (Key = 87) then
  begin
  end;

  if (Key = Vk_F12) and not(fDmCupomFiscal.cdsCupom_Itens.IsEmpty) then
  begin
    if btComanda.Visible then
      btComandaClick(Sender);
  end
  else
  if (Key = Vk_F4) then
    btPrecoClick(Sender)
  else
  if (Key = Vk_F6) then
    btClienteClick(Sender)
  else
  if (Key = Vk_F7) then
  begin
    btConfirmarIt.SetFocus;
    btConfirmarItClick(Sender)
  end
  else
  if (Key = Vk_F8) then
  begin
    if btOrcamento.Visible then
      btOrcamentoClick(Sender);
  end
  else
  if (Key = Vk_F9) then
  begin
    if btPedido.Visible then
      btPedidoClick(Sender);
  end;

  if (Key = Vk_F2) then
  begin
    Edit1.Clear;
    Edit3.Clear;

    frmSel_Produto := TfrmSel_Produto.Create(Self);
    frmSel_Produto.ShowModal;

    if vCodProduto_Pos > 0 then
    begin
      if fDmCupomFiscal.cdsCupomParametrosUSA_COD_REF.AsString = 'R' then
        Edit1.Text := vReferencia_Pos
      else
        Edit1.Text := IntToStr(vCodProduto_Pos);
      if not posicionaProduto then
        Exit
      else
        Edit1Exit(Sender);
    end;
  end;
end;

procedure TfCupomFiscal.CurrencyEdit6Exit(Sender: TObject);
begin
  if CurrencyEdit6.Value > 0 then
  begin
    CurrencyEdit4.Value := (CurrencyEdit1.Value * CurrencyEdit2.Value * CurrencyEdit6.Value / 100);
    CurrencyEdit7.Value := CurrencyEdit1.Value * CurrencyEdit2.Value - CurrencyEdit4.Value;
    vTipoDesc := 'R$';
  end;
end;

function TfCupomFiscal.posicionaProduto: Boolean;
var
  vCampoPesquisa: String;
  vTamCod: Byte;
begin
  Result      := False;
  vID_Produto := 0;
  vTamCod     := 4;
  if not fDmCupomFiscal.cdsCupomParametrosTAMANHO_COD_ETIQUETA.IsNull then
    vTamCod := fDmCupomFiscal.cdsCupomParametrosTAMANHO_COD_ETIQUETA.AsInteger;

  if trim(Edit1.Text) = '' then
    exit;

  if fDmCupomFiscal.cdsCupomParametrosUSA_COD_REF.AsString = 'R' then
    vCampoPesquisa := 'REF'
  else
    vCampoPesquisa := 'ID';

  if ((Length(Edit1.Text) > 7) and (vCampoPesquisa = 'ID')) or (Length(Edit1.Text) = 13) then  
//  if (Length(Edit1.Text) > 7) and (vCampoPesquisa = 'ID') then  //juca 01/10/2018
//  if Length(Edit1.Text) > 7 then //juca 18/05/2018
  begin
    if copy(Edit1.Text,1,1) = '2' then
    begin
      fDmCupomFiscal.prc_Abrir_Produto(vCampoPesquisa,Copy(Edit1.Text,2,vTamCod)); //aqui criar um parametro, pode ser 4
      if fDmCupomFiscal.cdsProduto.IsEmpty then
      begin
        ShowMessage('C�digo do produto lido: ' + Copy(Edit1.Text,2,vTamCod));
        Result := False;
      end
      else
      begin
        //11/01/2017   Cleomar
        if StrToFloat(FormatFloat('0.00000',vPreco_Pos)) > 0 then
          CurrencyEdit2.Value := vPreco_Pos
        else
        begin
          if (fDmCupomFiscal.cdsProdutoPRECO_VENDA.IsNull) or (fDmCupomFiscal.cdsProdutoPRECO_VENDA.AsFloat = 0) then
          begin
            MessageDlg('*** Pre�o de venda n�o cadastrado no produto!', mtInformation, [mbOk], 0);
            Edit1.Clear;
            Edit1.SetFocus;
            Exit;
          end
          else
            CurrencyEdit2.Value := fDmCupomFiscal.cdsProdutoPRECO_VENDA.AsFloat;
        end;
        //**************
        case fDmCupomFiscal.cdsCupomParametrosETIQUETA_INFO.AsInteger of
        0: ;
        1: begin //peso
             CurrencyEdit1.Value := StrToFloat(Copy(Edit1.Text,7,6)) / 1000;
             CurrencyEdit3.Value := StrToFloat(FormatFloat('0.00',CurrencyEdit2.Value * CurrencyEdit1.Value));
           end;
        2: begin //pre�o
             CurrencyEdit1.Value := StrToFloat(Copy(Edit1.Text,7,6)) / 100 / fDmCupomFiscal.cdsProdutoPRECO_VENDA.AsFloat;
             CurrencyEdit3.Value := StrToFloat(FormatFloat('0.00',CurrencyEdit2.Value * CurrencyEdit1.Value));
           end;
        end;
        vID_Produto := fDmCupomFiscal.cdsProdutoID.AsInteger;
        Result := True;
        Exit;
      end;
    end
    else
    begin

{  22/12/2017  Juca
      if copy(Edit1.Text,1,1) = '0' then
      begin
        fDmCupomFiscal.prc_Abrir_Produto(vCampoPesquisa,IntToStr(StrToInt(Edit1.Text)));
        if fDmCupomFiscal.cdsProduto.IsEmpty then
        begin
          ShowMessage('C�digo do produto lido: ' + Copy(Edit1.Text,2,vTamCod));
          Result := False;
        end
        else
        begin
          vID_Produto := fDmCupomFiscal.cdsProdutoID.AsInteger;
          Result := True;
          Exit;
        end;
      end;}

    end;

    fDmCupomFiscal.prc_Abrir_Produto('CB',Edit1.Text);
    if not fDmCupomFiscal.cdsProduto.IsEmpty then
    begin
      vID_Produto := fDmCupomFiscal.cdsProdutoID.AsInteger;
      Result := True;
    end
    else
    begin
      MessageDlg('*** C�digo de Barra ' + Edit1.Text + ' n�o encontrado!' , mtInformation, [mbOk], 0);
      Edit1.SelectAll;
      Result := False;
      Exit;
    end;

  end
  else
  begin
    fDmCupomFiscal.prc_Abrir_Produto(vCampoPesquisa,Edit1.Text);
    if not fDmCupomFiscal.cdsProduto.IsEmpty then
    begin
      vID_Produto := fDmCupomFiscal.cdsProdutoID.AsInteger;
      Result := True;
    end
    else
    begin
      MessageDlg('*** C�digo / Refer�ncia ' + Edit1.Text + ' n�o encontrado!' , mtInformation, [mbOk], 0);
      Edit1.SelectAll;
      Result := False;
      Exit;
    end;
  end;

  if Result then
  begin
    //11/01/2017 Cleomar
    if StrToFloat(FormatFloat('0.0000',vPreco_Pos)) > 0 then
      CurrencyEdit2.Value := vPreco_Pos
    else
      CurrencyEdit2.Value := fDmCupomFiscal.cdsProdutoPRECO_VENDA.AsFloat;
    //***************
    CurrencyEdit3.Value := StrToFloat(FormatFloat('0.00',CurrencyEdit2.Value * CurrencyEdit1.Value));
    vID_Produto         := fDmCupomFiscal.cdsProdutoID.AsInteger;
  end
  else
  begin
    MessageDlg('*** Registro n�o encontrado!', mtInformation, [mbOk], 0);
    Edit1.Clear;
    Edit1.SetFocus;
  end;
end;

procedure TfCupomFiscal.RxDBLookupCombo2Enter(Sender: TObject);
begin
  fDmCupomFiscal.cdsSitTribCF.IndexFieldNames := 'CODIGO';
end;

//procedure TfCupomFiscal.prc_Busca_IBPT;
//var
//  vComandoAux: String;
//begin
  {if fDmCupomFiscal.cdsCupom_ItensID_PRODUTO.AsInteger <> fDmCupomFiscal.cdsProdutoID.AsInteger then
    fDmCupomFiscal.cdsProduto.Locate('ID',fDmCupomFiscal.cdsCupom_ItensID_PRODUTO.AsInteger,[loCaseInsensitive]);

  fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_FEDERAL.AsFloat   := StrToFloat(FormatFloat('0.00',0));
  fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_ESTADUAL.AsFloat  := StrToFloat(FormatFloat('0.00',0));
  fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_MUNICIPAL.AsFloat := StrToFloat(FormatFloat('0.00',0));
  fDmCupomFiscal.cdsCupom_ItensFONTE_TRIBUTO.Clear;
  fDmCupomFiscal.cdsCupom_ItensVERSAO_TRIBUTO.Clear;

  vComandoAux := '';
  fDmCupomFiscal.qIBPT.Close;
  fDmCupomFiscal.qIBPT.SQL.Text := fDmCupomFiscal.ctqIBPT;
  if (fDmCupomFiscal.cdsParametrosTIPO_LEI_TRANSPARENCIA.AsString = 'P') then
    vComandoAux := 'WHERE I.CODIGO = ' + QuotedStr('COMERCIO')
  else
    vComandoAux := 'WHERE  N.ID = ' + IntToStr(fDmCupomFiscal.cdsCupom_ItensID_NCM.AsInteger)
                 + ' AND I.EX = ' + QuotedStr(fDmCupomFiscal.cdsProdutoNCM_EX.AsString);
  if trim(vComandoAux) = '' then
    exit;
  fDmCupomFiscal.qIBPT.SQL.Text := fDmCupomFiscal.qIBPT.SQL.Text + ' ' + vComandoAux;
  fDmCupomFiscal.qIBPT.Open;
  if not fDmCupomFiscal.qIBPT.IsEmpty then
  begin
    if (fDmCupomFiscal.cdsCupom_ItensORIGEM_PROD.AsString = '0') or (fDmCupomFiscal.cdsCupom_ItensORIGEM_PROD.AsString = '3')
      or (fDmCupomFiscal.cdsCupom_ItensORIGEM_PROD.AsString = '4') or (fDmCupomFiscal.cdsCupom_ItensORIGEM_PROD.AsString = '5') then
      fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_FEDERAL.AsFloat := StrToFloat(FormatFloat('0.00',fDmCupomFiscal.qIBPTPERC_NACIONAL.AsFloat))
    else
      fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_FEDERAL.AsFloat := StrToFloat(FormatFloat('0.00',fDmCupomFiscal.qIBPTPERC_IMPORTACAO.AsFloat));
    fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_ESTADUAL.AsFloat  := StrToFloat(FormatFloat('0.00',fDmCupomFiscal.qIBPTPERC_ESTADUAL.AsFloat));
    fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_MUNICIPAL.AsFloat := StrToFloat(FormatFloat('0.00',fDmCupomFiscal.qIBPTPERC_MUNICIPAL.AsFloat));
    fDmCupomFiscal.cdsCupom_ItensFONTE_TRIBUTO.AsString         := fDmCupomFiscal.qIBPTFONTE.AsString;
    fDmCupomFiscal.cdsCupom_ItensVERSAO_TRIBUTO.AsString        := fDmCupomFiscal.qIBPTVERSAO.AsString;
  end;

  if fDmCupomFiscal.cdsCupom_ItensID_PRODUTO.AsInteger <> fDmCupomFiscal.cdsProdutoID.AsInteger then
    fDmCupomFiscal.cdsProduto.Locate('ID',fDmCupomFiscal.cdsCupom_ItensID_PRODUTO.AsInteger,[loCaseInsensitive]);
  fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO.AsFloat := StrToFloat(FormatFloat('0.00',0));}

{
  fDmCupomFiscal.qIBPT.Close;
  fDmCupomFiscal.qIBPT.ParamByName('ID').AsInteger := fDmCupomFiscal.cdsCupom_ItensID_NCM.AsInteger;
  fDmCupomFiscal.qIBPT.ParamByName('EX').AsString  := fDmCupomFiscal.cdsProdutoNCM_EX.AsString;
  fDmCupomFiscal.qIBPT.Open;
  
  if not fDmCupomFiscal.qIBPT.IsEmpty then
  begin
    if (fDmCupomFiscal.cdsCupom_ItensORIGEM_PROD.AsString = '0') or (fDmCupomFiscal.cdsCupom_ItensORIGEM_PROD.AsString = '3') or
       (fDmCupomFiscal.cdsCupom_ItensORIGEM_PROD.AsString = '4') or (fDmCupomFiscal.cdsCupom_ItensORIGEM_PROD.AsString = '5') then
      fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO.AsFloat := StrToFloat(FormatFloat('0.00',fDmCupomFiscal.qIBPTPERC_NACIONAL.AsFloat))
    else
      fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO.AsFloat := StrToFloat(FormatFloat('0.00',fDmCupomFiscal.qIBPTPERC_IMPORTACAO.AsFloat));
  end;
}
//end;

procedure TfCupomFiscal.prc_Calcular_Tributos_Transparencia;
var
  vAux: Real;
begin
  fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO.AsFloat           := 0;
  fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO_FEDERAL.AsFloat   := 0;
  fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO_ESTADUAL.AsFloat  := 0;
  fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO_MUNICIPAL.AsFloat := 0;

  if (StrToFloat(FormatFloat('0.00',fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_FEDERAL.AsFloat)) > 0) then
  begin
    if fDmCupomFiscal.cdsParametrosARREDONDAR_5.AsString = 'B' then
      vAux := StrToCurr(FormatCurr('0.00',(fDmCupomFiscal.cdsCupom_ItensVLR_TOTAL.AsFloat *
              fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_FEDERAL.AsFloat) / 100))
    else
      vAux := StrToFloat(FormatFloat('0.00',(fDmCupomFiscal.cdsCupom_ItensVLR_TOTAL.AsFloat *
              fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_FEDERAL.AsFloat) / 100));
    fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO_FEDERAL.AsFloat := StrToFloat(FormatFloat('0.00',vAux));
  end;

  if (StrToFloat(FormatFloat('0.00',fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_ESTADUAL.AsFloat)) > 0) then
  begin
    if fDmCupomFiscal.cdsParametrosARREDONDAR_5.AsString = 'B' then
      vAux := StrToCurr(FormatCurr('0.00',(fDmCupomFiscal.cdsCupom_ItensVLR_TOTAL.AsFloat *
              fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_ESTADUAL.AsFloat) / 100))
    else
      vAux := StrToFloat(FormatFloat('0.00',(fDmCupomFiscal.cdsCupom_ItensVLR_TOTAL.AsFloat *
              fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_ESTADUAL.AsFloat) / 100));
    fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO_ESTADUAL.AsFloat := StrToFloat(FormatFloat('0.00',vAux));
  end;

  if (StrToFloat(FormatFloat('0.00',fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_MUNICIPAL.AsFloat)) > 0) then
  begin
    if fDmCupomFiscal.cdsParametrosARREDONDAR_5.AsString = 'B' then
      vAux := StrToCurr(FormatCurr('0.00',(fDmCupomFiscal.cdsCupom_ItensVLR_TOTAL.AsFloat *
              fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_MUNICIPAL.AsFloat) / 100))
    else
      vAux := StrToFloat(FormatFloat('0.00',(fDmCupomFiscal.cdsCupom_ItensVLR_TOTAL.AsFloat *
              fDmCupomFiscal.cdsCupom_ItensPERC_TRIBUTO_MUNICIPAL.AsFloat) / 100));
    fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO_MUNICIPAL.AsFloat := StrToFloat(FormatFloat('0.00',vAux));
  end;
  fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO.AsFloat := fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO_ESTADUAL.AsFloat +
                                                      fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO_FEDERAL.AsFloat +
                                                      fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO_MUNICIPAL.AsFloat;
end;

function TfCupomFiscal.prc_Calcular_Media_Tributos: Currency;
var
  vSoma: Currency;
begin
  vSoma := 0;
  fDmCupomFiscal.cdsCupom_Itens.First;
  while not fDmCupomFiscal.cdsCupom_Itens.Eof do
  begin
    if fDmCupomFiscal.cdsCupom_ItensCANCELADO.AsString <> 'S' then
      vSoma := vSoma + fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO.AsCurrency;
    fDmCupomFiscal.cdsCupom_Itens.Next;
  end;

  Result := vSoma / fDmCupomFiscal.cdsCupomFiscalVLR_TOTAL.AsCurrency * 100;
end;

procedure TfCupomFiscal.btConfirmarItClick(Sender: TObject);
var
  vItemAux: Integer;
  vUni: String;
begin
  if (Edit1.Text = '') or (Edit1.Text = '0') or (Edit3.Text = '') then
  begin
    ShowMessage('Produto n�o informado!');
    Edit1.SetFocus;
    Exit;
  end;
  fDmCupomFiscal.cdsProduto.Locate('ID',vID_Produto,[loCaseInsensitive]);
  if CurrencyEdit1.Value <= 0 then
  begin
    ShowMessage('Quantidade n�o informada!');
    CurrencyEdit1.SetFocus;
    Exit;
  end;
  if CurrencyEdit2.Value <= 0 then
  begin
    CurrencyEdit2.SetFocus;
    Exit;
  end;

  if trim(vUnidade) <> '' then
  begin
    if not fnc_VerficaFracionado(vUnidade) then
    begin
      ShowMessage('Produto n�o pode ser vendido fracionado!');
      Exit;
    end;
  end
  else
  if not fnc_VerficaFracionado(fDmCupomFiscal.cdsProdutoUnidade.AsString) then
  begin
    ShowMessage('Produto n�o pode ser vendido fracionado!');
    Exit;
  end;

  //Controle do estoque  11/05/2015
  if (fDmCupomFiscal.cdsParametrosCONTROLAR_ESTOQUE_SAIDA.AsString = 'S') then
  begin
    if not fnc_Estoque_OK(fDmCupomFiscal.cdsProdutoID.AsInteger,0,
                          '',CurrencyEdit1.Value) then
      Exit;
  end;

  fDmCupomFiscal.cdsCupom_Itens.Last;
  vItemAux := fDmCupomFiscal.cdsCupom_ItensItem.AsInteger;
  try
    fDmCupomFiscal.cdsCupom_Itens.Insert;
    fDmCupomFiscal.cdsCupom_ItensID.AsInteger       := fDmCupomFiscal.cdsCupomFiscalID.AsInteger;
    fDmCupomFiscal.cdsCupom_ItensITEM.AsInteger     := vItemAux + 1;
    fDmCupomFiscal.cdsCupom_ItensID_PRODUTO.AsInteger := vID_Produto;
    fDmCupomFiscal.cdsCupom_ItensQTD.AsFloat        := StrToFloat(FormatFloat(vFormaQtd,CurrencyEdit1.Value));
    fDmCupomFiscal.cdsCupom_ItensTAMANHO.AsString := '';
    fDmCupomFiscal.cdsCupom_ItensVLR_UNITARIO.AsFloat      := CurrencyEdit2.Value;
    fDmCupomFiscal.cdsCupom_ItensVLR_UNIT_ORIGINAL.AsFloat := CurrencyEdit2.Value;
    fDmCupomFiscal.vSomaOriginal := fDmCupomFiscal.vSomaOriginal + CurrencyEdit3.Value;

    if CurrencyEdit6.Value > 0 then
    begin
      fDmCupomFiscal.cdsCupom_ItensVLR_DESCONTO.AsFloat  := CurrencyEdit4.Value;
      vTipoDesc := '$';
      fDmCupomFiscal.cdsCupomFiscalTIPO_DESCONTO.AsString := 'I';
    end;
    fDmCupomFiscal.cdsCupom_ItensVLR_TOTAL.AsFloat := CurrencyEdit3.Value;

    //NFCe
    if fDmCupomFiscal.cdsParametrosUSA_NFCE.AsString <> 'S' then
    begin
      fDmCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat   := 0;
      fDmCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat    := 0;
      if StrToFloat(FormatFloat('0.00',fDmCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat)) > 0 then
      begin
        fDmCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat := CurrencyEdit3.Value;
        if StrToFloat(FormatFloat('0.0000',fDmCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat)) > 0 then
          fDmCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat := StrToFloat(FormatFloat('0.00',(fDmCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat * fDmCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat / 100)));
        fDmCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat  := StrToFloat(FormatFloat('0.00',fDmCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat *
                                                          fDmCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat / 100));
      end;
      fDmCupomFiscal.cdsCupom_ItensID_CFOP.AsInteger := 0;
    end;
    fDmCupomFiscal.cdsCupom_ItensREFERENCIA.AsString  := fDmCupomFiscal.cdsProdutoREFERENCIA.AsString;
    fDmCupomFiscal.cdsCupom_ItensORIGEM_PROD.AsString := fDmCupomFiscal.cdsProdutoORIGEM_PROD.AsString;
    fDmCupomFiscal.cdsCupom_ItensID_NCM.AsString      := fDmCupomFiscal.cdsProdutoID_NCM.AsString;

    fDmCupomFiscal.cdsCupom_ItensID_MOVESTOQUE.AsInteger := 0;
    if (vPedidoSelecionado) and (trim(vUnidade) <> '') then
      fDmCupomFiscal.cdsCupom_ItensUNIDADE.AsString := vUnidade
    else
      fDmCupomFiscal.cdsCupom_ItensUNIDADE.AsString := fDmCupomFiscal.cdsProdutoUnidade.AsString;
    fDmCupomFiscal.cdsCupom_ItensNOMEPRODUTO.AsString := fDmCupomFiscal.cdsProdutoNome.AsString;
    fDmCupomFiscal.cdsCupom_ItensCANCELADO.AsString   := 'N';
    if fDmCupomFiscal.cdsCupom_ItensID_PRODUTO.AsInteger = fDmCupomFiscal.cdsCupomParametrosID_PRODUTO_GENERICO.AsInteger then
      fDmCupomFiscal.cdsCupom_ItensNOME_PRODUTO.AsString := Edit3.Text
    else
      fDmCupomFiscal.cdsCupom_ItensNOME_PRODUTO.AsString := fDmCupomFiscal.cdsProdutoNome.AsString;

    if (vPedidoSelecionado) and (trim(vNome_Complementar) <> '') then
      fDmCupomFiscal.cdsCupom_ItensNOME_PRODUTO.AsString := fDmCupomFiscal.cdsCupom_ItensNOME_PRODUTO.AsString + ' ' + vNome_Complementar;

    fDmCupomFiscal.prc_Busca_IBPT;

    if fDmCupomFiscal.cdsParametrosUSA_NFCE.AsString = 'S' then
    begin
      if fDmCupomFiscal.vID_CFOP > 0 then
      begin
        fDmCupomFiscal.cdsCupom_ItensID_CFOP.AsInteger := fDmCupomFiscal.vID_CFOP;
        if fDmCupomFiscal.vID_Variacao > 0 then
          fDmCupomFiscal.cdsCupom_ItensID_VARIACAO.AsInteger := fDmCupomFiscal.vID_Variacao;
      end;

      if fDmCupomFiscal.vID_Pis > 0 then
        fDmCupomFiscal.cdsCupom_ItensID_PIS.AsInteger := fDmCupomFiscal.vID_Pis;
      if fDmCupomFiscal.vID_Cofins > 0 then
        fDmCupomFiscal.cdsCupom_ItensID_COFINS.AsInteger := fDmCupomFiscal.vID_Cofins;
      if fDmCupomFiscal.vID_CSTICMS > 0 then
        fDmCupomFiscal.cdsCupom_ItensID_CSTICMS.AsInteger := fDmCupomFiscal.vID_CSTICMS;
      fDmCupomFiscal.cdsCupom_ItensTIPO_PIS.AsString     := fDmCupomFiscal.vTipo_Pis;
      fDmCupomFiscal.cdsCupom_ItensTIPO_COFINS.AsString  := fDmCupomFiscal.vTipo_Cofins;
      fDmCupomFiscal.cdsCupom_ItensPERC_PIS.AsFloat      := fDmCupomFiscal.vPerc_Pis;
      fDmCupomFiscal.cdsCupom_ItensPERC_COFINS.AsFloat   := fDmCupomFiscal.vPerc_Cofins;
      fDmCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat := fDmCupomFiscal.vPerc_TribICMS;
      fDmCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat     := fDmCupomFiscal.vPerc_ICMS;
      if (vPedidoSelecionado) then
        fDmCupomFiscal.cdsCupom_ItensPERC_IPI.AsFloat    := vPerc_Ipi
      else
        fDmCupomFiscal.cdsCupom_ItensPERC_IPI.AsFloat    := fDmCupomFiscal.vPerc_IPI;

      prc_Calculo_GeralItem(fDmCupomFiscal,fDmCupomFiscal.cdsCupom_ItensQTD.AsFloat,fDmCupomFiscal.cdsCupom_ItensVLR_UNIT_ORIGINAL.AsFloat,
                                           fDmCupomFiscal.cdsCupom_ItensVLR_DESCONTO.AsFloat,fDmCupomFiscal.cdsCupom_ItensPERC_DESCONTO.AsFloat,
                                           fDmCupomFiscal.cdsCupom_ItensVLR_TOTAL.AsFloat,fDmCupomFiscal.cdsCupom_ItensVLR_ACRESCIMO.AsFloat,'S',0);
    end;

    if (fDmCupomFiscal.cdsCupomFiscalTIPO.AsString = 'CFI') then
      prc_Calcular_Tributos_Transparencia;

    if fDmCupomFiscal.cdsParametrosGRAVAR_CONSUMO_NOTA.AsString = 'S' then
      fDmCupomFiscal.cdsCupom_ItensITEM_ORIGINAL.AsInteger := vItem_original
    else
      fDmCupomFiscal.cdsCupom_ItensITEM_ORIGINAL.AsInteger := 0;

    if vPedidoSelecionado then
    begin
      fDmCupomFiscal.cdsCupom_ItensID_PEDIDO.AsInteger    := vID_Pedido;
      fDmCupomFiscal.cdsCupom_ItensITEM_PEDIDO.AsInteger  := vItem_Pedido;
      fDmCupomFiscal.cdsCupom_ItensNUMERO_OC.AsString     := vNumero_OC;
      fDmCupomFiscal.cdsCupom_ItensNUMERO_OS.AsString     := vNumero_OS;
      fDmCupomFiscal.cdsCupom_ItensITEM_CLIENTE.AsInteger := vItem_Cliente;
      fDmCupomFiscal.cdsCupom_ItensNUM_PEDIDO.AsInteger   := vNum_Pedido;
    end;
    fDmCupomFiscal.cdsCupom_Itens.Post;

    //Total
    if fDmCupomFiscal.cdsParametrosUSA_NFCE.AsString <> 'S' then
    begin
      fDmCupomFiscal.cdsCupomFiscalVLR_TOTAL.AsFloat    := fDmCupomFiscal.cdsCupomFiscalVLR_TOTAL.AsFloat +
                                                           fDmCupomFiscal.cdsCupom_ItensVLR_TOTAL.AsFloat;
      fDmCupomFiscal.cdsCupomFiscalVLR_ICMS.AsFloat     := fDmCupomFiscal.cdsCupomFiscalVLR_ICMS.AsFloat +
                                                           fDmCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat;
      fDmCupomFiscal.cdsCupomFiscalVLR_PRODUTOS.AsFloat := fDmCupomFiscal.cdsCupomFiscalVLR_PRODUTOS.AsFloat +
                                                           fDmCupomFiscal.cdsCupom_ItensVLR_TOTAL.AsFloat;
      fDmCupomFiscal.cdsCupomFiscalBASE_ICMS.AsFloat    := fDmCupomFiscal.cdsCupomFiscalBASE_ICMS.AsFloat +
                                                           fDmCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat;

      fDmCupomFiscal.cdsCupomFiscalVLR_TRIBUTO.AsFloat  := fDmCupomFiscal.cdsCupomFiscalVLR_TRIBUTO.AsFloat +
                                                           fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO.AsFloat;

      fDmCupomFiscal.cdsCupomFiscalVLR_TRIBUTO_FEDERAL.AsFloat   := fDmCupomFiscal.cdsCupomFiscalVLR_TRIBUTO_FEDERAL.AsFloat +
                                                                    fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO_FEDERAL.AsFloat;
      fDmCupomFiscal.cdsCupomFiscalVLR_TRIBUTO_ESTADUAL.AsFloat  := fDmCupomFiscal.cdsCupomFiscalVLR_TRIBUTO_ESTADUAL.AsFloat +
                                                                    fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO_ESTADUAL.AsFloat;
      fDmCupomFiscal.cdsCupomFiscalVLR_TRIBUTO_MUNICIPAL.AsFloat := fDmCupomFiscal.cdsCupomFiscalVLR_TRIBUTO_MUNICIPAL.AsFloat +
                                                                    fDmCupomFiscal.cdsCupom_ItensVLR_TRIBUTO_MUNICIPAL.AsFloat;
    end;
    //*****

    fDmCupomFiscal.cdsCupomFiscal.Post;
    fDmCupomFiscal.cdsCupomFiscal.Edit;
    fDmCupomFiscal.cdsCupom_Itens.Last;

  except
    on E: Exception do
    begin
      ShowMessage('N�o foi poss�vel incluir o item, ' + E.Message + '! Clique para continuar!');
      fDmCupomFiscal.cdsCupom_Itens.CancelUpdates;
    end;
  end;

  if ValueListEditor1.Visible then
    ValueListEditor1.Visible := False;

  Limpa_Campos;
  case fDmCupomFiscal.cdsCupomParametrosPRIMEIRO_CAMPO.AsInteger of
    1: begin
         CurrencyEdit1.SetFocus;
         CurrencyEdit1.SelectAll;
       end;
    2: Edit1.SetFocus;
    3: Edit3.SetFocus;
  end;
end;

procedure TfCupomFiscal.btCancelarClick(Sender: TObject);
begin
  fCupomFiscalCanc := TfCupomFiscalCanc.Create(Self);
  fCupomFiscalCanc.fDmCupomFiscal := fDmCupomFiscal;
  fCupomFiscalCanc.fDmParametros  := fDmParametros;
  fCupomFiscalCanc.vTeste         := vTeste;
  if fDmCupomFiscal.cdsParametrosUSA_NFCE.AsString = 'S' then
    fCupomFiscalCanc.CurrencyEdit1.AsInteger := fDmCupomFiscal.cdsCupom_ItensITEM.AsInteger;
  fCupomFiscalCanc.ShowModal;
  Edit1.SetFocus;
end;

procedure TfCupomFiscal.btFinalizarClick(Sender: TObject);
var
  vTextoFechamento: String;
  i: Byte;
  vVias: Byte;
  ffCupomFiscalPgto: TfCupomFiscalPgto;
begin
  vFilial := vFilial_Loc;

  if not(fDmCupomFiscal.cdsCupomFiscal.State in [dsEdit,dsInsert]) then
    fDmCupomFiscal.cdsCupomFiscal.Edit;

  fDmCupomFiscal.vEncerrado := False;
  ffCupomFiscalPgto := TfCupomFiscalPgto.Create(Self);
  ffCupomFiscalPgto.fDmCupomFiscal := fDmCupomFiscal;
  ffCupomFiscalPgto.fDmParametros  := fDmParametros;
  ffCupomFiscalPgto.ShowModal;
  FreeAndNil(ffCupomFiscalPgto);

  vTextoFechamento := '';
  if (fDmCupomFiscal.cdsCupomFiscalCPF.AsString <> '') and
     (fDmCupomFiscal.cdsCupomFiscalCPF.AsString <> '000.000.000-00') then
    vTextoFechamento := 'Consumidor CPF: ' + fDmCupomFiscal.cdsCupomFiscalCPF.AsString + #13;
  if not fDmCupomFiscal.vEncerrado then
    exit;

  if (fDmCupomFiscal.cdsCupomParametrosBAIXAR_CONSUMO.AsString = 'S') then
    fDmCupomFiscal.prc_Excluir_CupomFiscal_MP;

  case fDmCupomFiscal.cdsParametrosIMPRESSORA_FISCAL.AsInteger of
    5: begin
         if fDmCupomFiscal.vEncerrado then
         begin
           if (fDmCupomFiscal.cdsCupomFiscalTIPO.AsString = 'CNF') and
              (fDmCupomFiscal.cdsCupomParametrosIMPRIME_FISCAL_NFISCAL.AsString = 'S') then
             fDmCupomFiscal.ChamaNaoFiscal(fDmCupomFiscal.cdsCupomFiscalID.AsInteger,'modWrite');
         end
         else
           Exit; //para cupom n�o fiscal, permite continuar vendendo
       end;
    6: begin
         if fDmCupomFiscal.vEncerrado then
         begin
           if (fDmCupomFiscal.cdsCupomFiscalTIPO.AsString = 'CNF') and
              (fDmCupomFiscal.cdsCupomParametrosIMPRIME_FISCAL_NFISCAL.AsString = 'S') then
           begin
             vVias := fDmCupomFiscal.cdsCupomParametrosVIAS_CUPOM.AsInteger;
             if vVias <= 0 then
               vVias := 1;
             fDmCupomFiscal.cdsTipoCobranca.Open;
             fDmCupomFiscal.cdsTipoCobranca.FindKey([fDmCupomFiscal.cdsCupomFiscalID_TIPOCOBRANCA.AsInteger]);
             if fDmCupomFiscal.cdsTipoCobrancaIMPRIME_CARNE.AsString = 'S' then
               vVias := vVias - 1;
             fDmCupomFiscal.cdsTipoCobranca.Close;
             if (fDmCupomFiscal.cdsCupomParametrosEXIBIR_DIALOGO_IMPRESSORA.AsString = 'S') then
             begin
                if (MessageDLg('Deseja imprimir o cupom?',mtConfirmation,[mbyes,mbNo],0) = mrYes) then
                  for i := 1 to vVias do
                    fDmCupomFiscal.ChamaNaoFiscal(fDmCupomFiscal.cdsCupomFiscalID.AsInteger,'modCanvas');
             end
             else
               for i := 1 to vVias do
                 fDmCupomFiscal.ChamaNaoFiscal(fDmCupomFiscal.cdsCupomFiscalID.AsInteger,'modCanvas')
           end;
         end
         else
            Exit; //para cupom n�o fiscal, permite continuar vendendo
       end;
  end;

  if fDmCupomFiscal.cdsCupomFiscal.State in [dsEdit,dsInsert] then
  begin
    fDmCupomFiscal.vID_Cupom_Pos := fDmCupomFiscal.cdsCupomFiscalID.AsInteger;
    fDmCupomFiscal.cdsCupomFiscal.Post;
    fDmCupomFiscal.cdsCupomFiscal.ApplyUpdates(0);
  end;

  fDmCupomFiscal.mPedidoAux.EmptyDataSet;

  ///////////////////////////////////////////////

  


end;

procedure TfCupomFiscal.CurrencyEdit2KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = Vk_Return) and (Trim(Edit1.Text) <> '') then
  begin
    CurrencyEdit3.Value := StrToFloat(FormatFloat('0.00',CurrencyEdit2.Value * CurrencyEdit1.Value));
    btConfirmarIt.SetFocus;
    CurrencyEdit1Exit(Sender);
  end;
end;

procedure TfCupomFiscal.CurrencyEdit1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = vk_F3 then
  begin
    prcPesa;
    if CurrencyEdit1.TabOrder = 0 then
      Edit1.SetFocus;
  end;
  if (Key = Vk_Return) then
    if CurrencyEdit1.TabOrder = 0 then
      Edit1.SetFocus
    else
    begin
      if fDmCupomFiscal.cdsCupomParametrosEXIGE_CAMPO_DESCONTO.AsString = 'S' then
      begin
        if CurrencyEdit2.Value = 0 then
        begin
          CurrencyEdit2.SetFocus;
        end
        else
        if CurrencyEdit6.Visible then
          CurrencyEdit6.SetFocus
        else
        begin
          btConfirmarIt.SetFocus;
          btConfirmarItClick(Sender);
        end
      end
      else
      begin
        if CurrencyEdit2.Value = 0 then
        begin
          CurrencyEdit2.SetFocus;
        end
        else
        begin
          btConfirmarIt.SetFocus;
          btConfirmarItClick(Sender);
        end;
      end;
    end;
end;

procedure TfCupomFiscal.prc_Move_Itens;
begin
  if (fDmCupomFiscal.cdsParametrosUSA_NFCE.AsString <> 'S') then
    exit;
  if Edit1.Text = '' then
    exit;
  if not(fDmCupomFiscal.cdsCupomFiscal.State in [dsEdit,dsInsert]) then
    prc_Inserir;

  if fDmCupomFiscal.cdsProdutoID.AsInteger <> vID_Produto  then
    fDmCupomFiscal.cdsProduto.Locate('ID',vID_Produto,[loCaseInsensitive]);

  fDmCupomFiscal.vID_NCM := fDmCupomFiscal.cdsProdutoID_NCM.AsInteger;
  if fDmCupomFiscal.vID_NCM > 0 then
    fDmCupomFiscal.cdsTab_NCM.Locate('ID',fDmCupomFiscal.vID_NCM,[loCaseInsensitive]);

  if fDmCupomFiscal.cdsProdutoID_CFOP_NFCE.AsInteger > 0 then
    fDmCupomFiscal.vID_CFOP := fDmCupomFiscal.cdsProdutoID_CFOP_NFCE.AsInteger
  else
  if (fDmCupomFiscal.cdsTab_NCMID_CFOP.AsInteger > 0) and (fDmCupomFiscal.cdsTab_NCMID.AsInteger = fDmCupomFiscal.cdsCupom_ItensID_NCM.AsInteger) then
    fDmCupomFiscal.vID_CFOP := fDmCupomFiscal.cdsTab_NCMID_CFOP.AsInteger
  else
  if fDmCupomFiscal.cdsFilialID_CFOP_NFCE_PADRAO.AsInteger > 0 then
    fDmCupomFiscal.vID_CFOP := fDmCupomFiscal.cdsFilialID_CFOP_NFCE_PADRAO.AsInteger;
  if fDmCupomFiscal.vID_CFOP > 0 then
  begin
    fDmCupomFiscal.cdsCFOP.Locate('ID',fDmCupomFiscal.vID_CFOP,[loCaseInsensitive]);
    vGeraIcms := fDmCupomFiscal.cdsCFOPGERAR_ICMS.AsString = 'S';
  end;
  fDmCupomFiscal.vID_Variacao := 0;
  if fDmCupomFiscal.vID_CFOP > 0 then
    fDmCupomFiscal.vID_Variacao := fDmCupomFiscal.fnc_Buscar_Regra_CFOP(fDmCupomFiscal.vID_CFOP);
  if fDmCupomFiscal.vID_Variacao = 0 then
    ShowMessage('Varia��o da CFOP n�o localizada para a opera��o!' + #13 +
                'Cupom fiscal n�o ser� validado!')
  else
    fDmCupomFiscal.prc_Mover_CST;
end;

function TfCupomFiscal.fnc_Estoque_OK(ID_Produto, ID_Cor: Integer; Tamanho: String; Qtd: Real): Boolean;
var
  ffrmSenha: TfrmSenha;
  vQtdAux: Real;
begin
  Result := True;
  if fDmCupomFiscal.cdsParametrosCONTROLAR_ESTOQUE_SAIDA.AsString <> 'S' then
    exit;
  vQtdAux := fnc_Busca_Estoque2(fDmCupomFiscal.cdsCupomFiscalFILIAL.AsInteger,ID_Produto,ID_Cor,Tamanho,1);
  if StrToFloat(FormatFloat('0.0000',vQtdAux)) < StrToFloat(FormatFloat('0.0000',Qtd)) then
  begin
    if trim(fDmCupomFiscal.cdsParametrosSENHA_LIBERA_ESTOQUE.AsString) = '' then
      Result := (MessageDlg('Produto com quantidade menor no estoque, confirma inclus�o do produto?',mtConfirmation,[mbYes,mbNo],0) = mrYes)
    else
    begin
      ffrmSenha := TfrmSenha.Create(self);
      ffrmSenha.Label2.Caption := 'Produto com estoque negativo ';
      ffrmSenha.Label3.Caption := 'Informe a senha para liberar ';
      if Tamanho <> '' then
        ffrmSenha.Label4.Caption := 'Tamanho = ' + Tamanho
      else
        ffrmSenha.Label4.Caption := '';
      ffrmSenha.Label4.Caption := ffrmSenha.Label4.Caption + '   Qtd Est. ' + FormatFloat('0.####',vQtdAux);
      if StrToFloat(FormatFloat('0.0000',vQtdAux)) <= 0 then
        ffrmSenha.Label4.Font.Color := clRed
      else
        ffrmSenha.Label4.Font.Color := clBlue;
      ffrmSenha.vControlaSenha := True;
      ffrmSenha.vSenha_Param := fDmCupomFiscal.cdsParametrosSENHA_LIBERA_ESTOQUE.AsString;
      ffrmSenha.ShowModal;
      FreeAndNil(ffrmSenha);
      if vSenha <> fDmCupomFiscal.cdsParametrosSENHA_LIBERA_ESTOQUE.AsString then
         Result := False;
    end;
  end;
end;


procedure TfCupomFiscal.prc_Calcular_IPI;
begin
  if not vCalcula_IPI then
    Exit;

  if (fDmCupomFiscal.cdsProdutoPERC_IPI.AsCurrency > 0) then
  begin
    if (fDmCupomFiscal.vID_CFOP > 0) and (fDmCupomFiscal.cdsParametrosUSA_NFCE.AsString = 'S') then
    begin
      if (fDmCupomFiscal.cdsCFOP.Locate('ID',fDmCupomFiscal.vID_CFOP,[loCaseInsensitive])) then
        if fDmCupomFiscal.cdsCFOPGERAR_IPI.AsString <> 'S' then
          exit;
    end;
    vCalcula_IPI := False;
  end;
end;

procedure TfCupomFiscal.Edit1Enter(Sender: TObject);
begin
  vCalcula_IPI := True;
  Edit1.SelectAll;
end;

procedure TfCupomFiscal.btPrecoClick(Sender: TObject);
begin
  frmConsPreco := TfrmConsPreco.Create(Self);
  frmConsPreco.ShowModal;
end;

procedure TfCupomFiscal.btnCopiarSacolaClick(Sender: TObject);
var
  ffrmSel_Sacola_CF: TfrmSel_Sacola_CF;
begin
  ffrmSel_Sacola_CF := TfrmSel_Sacola_CF.Create(self);

  ffrmSel_Sacola_CF.fDMCupomFiscal := fDMCupomFiscal;
  ffrmSel_Sacola_CF.ffCupomFiscal2 := fCupomFiscal;
  ffrmSel_Sacola_CF.ShowModal;
  FreeAndNil(ffrmSel_Sacola_CF);
end;

procedure TfCupomFiscal.btnCopiarPedidoClick(Sender: TObject);
var
  ffrmSel_Pedido_CF: TfrmSel_Pedido_CF;
begin
  vUnidade           := '';
  vPerc_Ipi          := 0;
  vNome_Complementar := '';

  ffrmSel_Pedido_CF := TfrmSel_Pedido_CF.Create(self);

  ffrmSel_Pedido_CF.fDMCupomFiscal := fDMCupomFiscal;
  ffrmSel_Pedido_CF.ffCupomFiscal2 := fCupomFiscal;
  ffrmSel_Pedido_CF.ShowModal;
  FreeAndNil(ffrmSel_Pedido_CF);
end;

procedure TfCupomFiscal.Edit3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  sds: TSQLDataSet;
begin
  if (Key = Vk_Return) and (Edit1.Text = '0') then
  begin
    if trim(Edit3.Text) = '' then
    begin
      ValueListEditor1.Strings.Clear;
      ValueListEditor1.SendToBack;
      ValueListEditor1.Visible := False;
      Exit;
    end;
    ValueListEditor1.BringToFront;
    ValueListEditor1.Visible := True;
    ValueListEditor1.Strings.Clear;
    sds := TSQLDataSet.Create(nil);
    try
      sds.SQLConnection := dmDatabase.scoDados;
      sds.NoMetadata    := True;
      sds.GetMetadata   := False;
      sds.CommandText   := 'SELECT ID, NOME, REFERENCIA FROM PRODUTO ';
      sds.CommandText   := sds.CommandText + 'WHERE NOME LIKE ''' + Edit3.Text + '%'' ';
      sds.CommandText   := sds.CommandText + ' AND INATIVO = ' + QuotedStr('N');
      sds.CommandText   := sds.CommandText + 'ORDER BY NOME';
      sds.Open;
      while not sds.Eof do
      begin
        if fDmCupomFiscal.cdsCupomParametrosUSA_COD_REF.AsString = 'R' then
          ValueListEditor1.InsertRow(sds.FieldByName('REFERENCIA').AsString,sds.FieldByName('NOME').AsString,True)
        else
          ValueListEditor1.InsertRow(sds.FieldByName('ID').AsString,sds.FieldByName('NOME').AsString,True);
        sds.Next;
      end;
    finally
      FreeAndNil(sds);
    end;

    ValueListEditor1.SetFocus;
  end;
end;

procedure TfCupomFiscal.ValueListEditor1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = Vk_Return) then
  begin
    Edit1.Text := ValueListEditor1.Strings.Names[ValueListEditor1.Row - 1];
    Edit3.Text := ValueListEditor1.Values[ValueListEditor1.Keys[ValueListEditor1.Row]];
    ValueListEditor1.Visible := False;
    CurrencyEdit1.SetFocus;
    Edit1Exit(Sender);
  end
  else
  if (Key = 27) then
  begin
    ValueListEditor1.Visible := False;
    Edit1.SetFocus;
  end;
end;

procedure TfCupomFiscal.btComandaClick(Sender: TObject);
begin
  if fDmCupomFiscal.cdsCupom_Itens.IsEmpty then
  begin
    ShowMessage('Para grava��o da comanda � preciso ter produtos inclu�dos!');
    Exit;
  end;

  fDmCupomFiscal.cdsCupomFiscalTIPO.AsString := 'COM';
  FinalizaParcial('COM');
end;

procedure TfCupomFiscal.btOrcamentoClick(Sender: TObject);
begin
  if fDmCupomFiscal.cdsCupom_Itens.IsEmpty then
  begin
    ShowMessage('Para grava��o do or�amento � preciso ter produtos inclu�dos!');
    Exit;
  end;

  fDmCupomFiscal.cdsCupomFiscalTIPO.AsString := 'ORC';

  fDmCupomFiscal.vClienteConfirmado := False;
  fCupomCliente := TfCupomCliente.Create(Self);
  fCupomCliente.fDmCupomFiscal := fDmCupomFiscal;
  fCupomCliente.ShowModal;

  if fDmCupomFiscal.vClienteConfirmado then
  begin
    fDmCupomFiscal.cdsCupomFiscalID_CLIENTE.AsInteger := fDmCupomFiscal.vClienteID;

    FinalizaParcial('ORC');
    fDmCupomFiscal.vClienteID := fDmCupomFiscal.cdsParametrosID_CLIENTE_CONSUMIDOR.AsInteger;
  end;
end;

procedure TfCupomFiscal.btPedidoClick(Sender: TObject);
begin
  if fDmCupomFiscal.cdsCupom_Itens.IsEmpty then
  begin
    ShowMessage('Para grava��o do pedido � preciso ter produtos inclu�dos!');
    Exit;
  end;

  fDmCupomFiscal.cdsCupomFiscalTIPO.AsString := 'PED';

  fDmCupomFiscal.vClienteConfirmado := False;
  fCupomCliente := TfCupomCliente.Create(Self);
  fCupomCliente.fDmCupomFiscal := fDmCupomFiscal;
  fCupomCliente.ShowModal;

  if (fDmCupomFiscal.vClienteConfirmado) then
  begin
    fDmCupomFiscal.cdsCupomFiscalID_CLIENTE.AsInteger := fDmCupomFiscal.vClienteID;

    FinalizaParcial('PED');
    fDmCupomFiscal.vClienteID := fDmCupomFiscal.cdsParametrosID_CLIENTE_CONSUMIDOR.AsInteger;
  end;
end;

procedure TfCupomFiscal.FinalizaParcial(vTipo: String);
begin
  if (fDmCupomFiscal.cdsCupomFiscalNUMCUPOM.AsInteger <= 0) then
  begin
    fDmCupomFiscal.qProximoCupom.Close;
    fDmCupomFiscal.qProximoCupom.ParamByName('FILIAL').AsInteger := fDmCupomFiscal.cdsCupomFiscalFILIAL.AsInteger;
    fDmCupomFiscal.qProximoCupom.ParamByName('TIPO').AsString    := vTipo;
    fDmCupomFiscal.qProximoCupom.Open;
    fDmCupomFiscal.cdsCupomFiscalNUMCUPOM.AsInteger   := fDmCupomFiscal.qProximoCupomNUMCUPOM.AsInteger + 1;
    fDmCupomFiscal.cdsCupomFiscalID_CLIENTE.AsInteger := fDmCupomFiscal.vClienteID;
  end;

  if fDmCupomFiscal.cdsCupomFiscal.State in [dsEdit,dsInsert] then
  begin
    fDmCupomFiscal.vID_Cupom_Pos := fDmCupomFiscal.cdsCupomFiscalID.AsInteger;
    fDmCupomFiscal.cdsCupomFiscal.Post;
    fDmCupomFiscal.cdsCupomFiscal.ApplyUpdates(0);
    fDmCupomFiscal.vEncerrado := True;
  end;

  if (vTipo = 'COM') then
  begin
    if (fDmCupomFiscal.cdsCupomParametrosUSA_COMANDA.AsString = 'S') then
      prc_ImprimeComanda;
  end
  else
    if MessageDLg('Deseja imprimir?',mtConfirmation,[mbyes,mbNo],0) = mrYes then
      case fDmCupomFiscal.cdsParametrosIMPRESSORA_FISCAL.AsInteger of
        5: fDmCupomFiscal.ChamaNaoFiscal(fDmCupomFiscal.cdsCupomFiscalID.AsInteger,'modWrite');
        6: fDmCupomFiscal.ChamaNaoFiscal(fDmCupomFiscal.cdsCupomFiscalID.AsInteger,'modCanvas');
      end;

  if fDmCupomFiscal.cdsCupomFiscal.State in [dsBrowse] then
  begin
    Tag := 99;
    fDmCupomFiscal.vSair_Tela := False;
    Close;
  end;
end;

procedure TfCupomFiscal.prc_ImprimeComanda;
begin
  fDmCupomFiscal.cdsComandaRel.Close;
  fDmCupomFiscal.sdsComandaRel.ParamByName('ID').AsInteger := fDmCupomFiscal.cdsCupom_ConsID.AsInteger;
  fDmCupomFiscal.cdsComandaRel.Open;

  fDmCupomFiscal.cdsComandaItem_Rel.Close;
  fDmCupomFiscal.sdsComandaItem_Rel.ParamByName('ID').AsInteger := fDmCupomFiscal.cdsCupom_ConsID.AsInteger;
  fDmCupomFiscal.cdsComandaItem_Rel.Open;

  fComandaR := TfComandaR.Create(Self);
  fComandaR.fDmCupomFiscal := fDmCupomFiscal;
  fComandaR.RLReport1.PrintDialog := False;
  fComandaR.RLReport1.Print;
end;

procedure TfCupomFiscal.prc_EnterCodigo;
begin
  if (Trim(Edit1.Text) <> '') then
  begin
    if not Panel2.Enabled then
      Exit;

    if Edit1.Text = '0' then  //cai no campo para procura por nome
    begin
      Edit3.ReadOnly := False;
      Edit3.TabStop  := True;
      Edit3.SetFocus;
      Exit;
    end
    else
    begin
      if (Length(Edit1.Text) < 9) and (fDmCupomFiscal.cdsCupomParametrosUSA_COD_REF.AsString = 'C' ) and
         (StrToInt(Edit1.Text) = fDmCupomFiscal.cdsCupomParametrosID_PRODUTO_GENERICO.AsInteger) then
      begin
        Edit3.ReadOnly := False;
        Edit3.TabStop  := True;
      end
      else
      begin
        Edit3.ReadOnly := True;
        Edit3.TabStop  := False;
      end;
    end;

//    Edit3.Text := fDmCupomFiscal.cdsProdutoNOME.AsString;

    if Edit1.TabOrder = 0 then
      CurrencyEdit1.SetFocus
    else
      btConfirmarIt.SetFocus;
  end;
end;

procedure TfCupomFiscal.ValueListEditor1DblClick(Sender: TObject);
begin
  Edit1.Text := ValueListEditor1.Strings.Names[ValueListEditor1.Row - 1];
  Edit3.Text := ValueListEditor1.Values[ValueListEditor1.Keys[ValueListEditor1.Row]];
  ValueListEditor1.Visible := False;
  CurrencyEdit1.SetFocus;
  Edit1Exit(Sender);
end;

procedure TfCupomFiscal.btClienteClick(Sender: TObject);
begin
  fCupomFiscalCli := TfCupomFiscalCli.Create(Self);
  fCupomFiscalCli.fDmCupomFiscal := fDmCupomFiscal;
  fCupomFiscalCli.ShowModal;

  fDmCupomFiscal.SQLQuery1.SQL.Text := 'SELECT CF.ID, CF.DTEMISSAO, CF.ID_TIPOCOBRANCA, CF.TIPO ' +
                                       'FROM CUPOMFISCAL CF ' +
                                       'WHERE CF.ID_TIPOCOBRANCA IS NULL AND ' +
                                       ' CF.TIPO IN (''PED'',''ORC'') AND ' +
                                       ' CF.ID_CLIENTE = ' + IntToStr(fDmCupomFiscal.vClienteID) +
                                       ' ORDER BY CF.DTEMISSAO';
  if not fDmCupomFiscal.SQLQuery1.IsEmpty then
  begin
    ShowMessage('Existe or�amento ou pedido aberto para este cliente em ' + fDmCupomFiscal.SQLQuery1.fieldByName('DTEMISSAO').AsString);
  end;

  fDmCupomFiscal.cdsCupomFiscalID_CLIENTE.AsInteger := fDmCupomFiscal.vClienteID;
end;

procedure TfCupomFiscal.CurrencyEdit7Exit(Sender: TObject);
begin
  CurrencyEdit6.Value := 100 - (CurrencyEdit7.Value * 100 / (CurrencyEdit1.Value * CurrencyEdit2.Value));
  CurrencyEdit4.Value := CurrencyEdit1.Value * CurrencyEdit2.Value - CurrencyEdit7.Value;
  CurrencyEdit3.Value := CurrencyEdit7.Value;
end;

procedure TfCupomFiscal.CurrencyEdit4Exit(Sender: TObject);
begin
  CurrencyEdit7.Value := (CurrencyEdit1.Value * CurrencyEdit2.Value - CurrencyEdit4.Value);
  CurrencyEdit6.Value := 100 - (CurrencyEdit7.Value * 100 / (CurrencyEdit1.Value * CurrencyEdit2.Value));
end;

procedure TfCupomFiscal.CurrencyEdit6Enter(Sender: TObject);
begin
  CurrencyEdit6.SelectAll;
end;

procedure TfCupomFiscal.CurrencyEdit4Enter(Sender: TObject);
begin
  CurrencyEdit4.SelectAll;
end;

procedure TfCupomFiscal.CurrencyEdit7Enter(Sender: TObject);
begin
  CurrencyEdit7.SelectAll;
end;

procedure TfCupomFiscal.CurrencyEdit2Enter(Sender: TObject);
begin
  vPreco_Ori := CurrencyEdit2.Value;
  CurrencyEdit2.SelectAll;
end;

procedure TfCupomFiscal.CurrencyEdit2Exit(Sender: TObject);
begin
  if (fDmCupomFiscal.qParametros_FinCONTROLE_DIG_PRECO.AsString = 'S') and (fDmCupomFiscal.qParametros_UsuarioALT_PRECO_PED.AsString = 'C') and
    (StrToFloat(FormatFloat('0.000000',CurrencyEdit2.Value)) < StrToFloat(FormatFloat('0.000000',vPreco_Ori))) then
  begin
    MessageDlg('*** Pre�o n�o pode ser menor que ' + FormatFloat('0.00####',vPreco_Ori), mtError, [mbOk], 0);
    CurrencyEdit2.Value := vPreco_Ori;
    CurrencyEdit2.SetFocus;
  end;

  CurrencyEdit3.Value := CurrencyEdit1.Value * CurrencyEdit2.Value;
end;

procedure TfCupomFiscal.btnCopiarComandaClick(Sender: TObject);
begin
  frmSel_Comanda_CF := TfrmSel_Comanda_CF.Create(Self);
  frmSel_Comanda_CF.WindowState    := wsMaximized;
  frmSel_Comanda_CF.fDmCupomFiscal := fDmCupomFiscal;
  frmSel_Comanda_CF.ShowModal;
  vCopiandoComanda := False;
end;

procedure TfCupomFiscal.SMDBGrid2DblClick(Sender: TObject);
begin
  fCupomFiscalParcela := TfCupomFiscalParcela.Create(Self);
  fCupomFiscalParcela.fdmCupomFiscal := fDmCupomFiscal;
  fCupomFiscalParcela.Tag            := 1;
  fDmCupomFiscal.cdsCupom_Parc.Edit;
  fCupomFiscalParcela.ShowModal;

  fDmCupomFiscal.cdsTipoCobranca.IndexFieldNames := 'ID';
  fDmCupomFiscal.cdsTipoCobranca.FindKey([fDmCupomFiscal.cdsCupom_ParcID_TIPOCOBRANCA.AsInteger]);
  if fDmCupomFiscal.cdsTipoCobrancaCREDITO_LOJA.AsString = 'S' then
  begin
    fDmCupomFiscal.cdsDuplicata.IndexFieldNames := 'ID_CUPOM;PARCELA';
    fDmCupomFiscal.cdsDuplicata.Active := False;
    fDmCupomFiscal.sdsDuplicata.CommandText := fDmCupomFiscal.ctDuplicata + ' WHERE ID_CUPOM = ' + fDmCupomFiscal.cdsCupomFiscalID.AsString +
                                               ' AND PARCELA = ' + fDmCupomFiscal.cdsCupom_ParcPARCELA.AsString;
    fDmCupomFiscal.cdsDuplicata.Active := True;
    if fDmCupomFiscal.cdsDuplicata.IsEmpty then
      fDmCupomFiscal.Gravar_Duplicata('R','N',fDmCupomFiscal.cdsCupom_ParcPARCELA.AsInteger,
                                      fDmCupomFiscal.cdsCupom_ParcVLR_VENCIMENTO.AsFloat,
                                      fDmCupomFiscal.cdsCupom_ParcDTVENCIMENTO.AsDateTime,'')
    else
    begin
      fDmCupomFiscal.cdsDuplicata.Edit;
      fDmCupomFiscal.cdsDuplicataDTVENCIMENTO.AsDateTime := fDmCupomFiscal.cdsCupom_ParcDTVENCIMENTO.AsDateTime;
      fDmCupomFiscal.cdsDuplicataVLR_RESTANTE.AsFloat    := StrToFloat(FormatFloat('0.00',fDmCupomFiscal.cdsCupom_ParcVLR_VENCIMENTO.AsFloat));
      fDmCupomFiscal.cdsDuplicataID_TIPOCOBRANCA.AsInteger := fDmCupomFiscal.cdsCupom_ParcID_TIPOCOBRANCA.AsInteger;
      fDmCupomFiscal.cdsDuplicata.Post;
      fDmCupomFiscal.cdsDuplicata.ApplyUpdates(0);
      fDmCupomFiscal.cdsDuplicata.Active      := False;
      fDmCupomFiscal.sdsDuplicata.CommandText := fDmCupomFiscal.ctDuplicata;
    end;
  end;
  if fDmCupomFiscal.cdsCupomFiscal.State in [dsEdit] then
  begin
    fDmCupomFiscal.cdsCupomFiscal.Post;
    fDmCupomFiscal.cdsCupomFiscal.ApplyUpdates(0);
  end;
end;

procedure TfCupomFiscal.CurrencyEdit1Enter(Sender: TObject);
begin
  if (fDmCupomFiscal.cdsCupomParametrosQTD_AUTO.AsString = 'S') and (Edit1.Text <> '') and
     ((fDmCupomFiscal.cdsCupomParametrosUSA_BALANCA.AsString = 'N') or (fDmCupomFiscal.cdsProdutoUNIDADE.AsString <> 'KG')) then
  begin
    btConfirmarIt.SetFocus;
    btConfirmarIt.Click
  end;
  if (fDmCupomFiscal.cdsCupomParametrosUSA_BALANCA.AsString = 'S') and (vBalanca = 'ACBR') and
     (fDmCupomFiscal.cdsProdutoUNIDADE.AsString = 'KG') then
  begin
  end;
end;

procedure TfCupomFiscal.CurrencyEdit6KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    SelectNext(Sender as TWinControl, True, True);
end;

procedure TfCupomFiscal.CurrencyEdit4KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    SelectNext(Sender as TWinControl, True, True);
end;

procedure TfCupomFiscal.CurrencyEdit7KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    SelectNext(Sender as TWinControl, True, True);
end;

procedure TfCupomFiscal.Edit3Exit(Sender: TObject);
begin
  if (Edit3.Text = '') and (ValueListEditor1.Visible) then
  begin
    ValueListEditor1.Strings.Clear;
    ValueListEditor1.SendToBack;
    ValueListEditor1.Visible := False;
  end;
end;

function TfCupomFiscal.fnc_VerficaFracionado(vUnidade: String): Boolean;
begin
  Result := True;
  fDmCupomFiscal.qUnidade.ParamByName('U1').AsString := vUnidade;
  fDmCupomFiscal.qUnidade.Open;
  if fDmCupomFiscal.qUnidadeFRACIONAVEL.AsString = 'N' then
    if frac(CurrencyEdit1.Value) <> 0.00 then
      Result := False;
  fDmCupomFiscal.qUnidade.Close;
end;

procedure TfCupomFiscal.prc_CorTamanho;
begin
//posiciona pela refer�ncia
  fDmCupomFiscal.cdsProduto.Close;
  fDmCupomFiscal.sdsProduto.CommandText := fDmCupomFiscal.ctProduto;
  if fDmCupomFiscal.cdsCupomParametrosUSA_COD_REF.AsString = 'R' then
    fDmCupomFiscal.sdsProduto.CommandText := fDmCupomFiscal.ctProduto + ' AND REFERENCIA = ' + QuotedStr(Trim(Edit1.Text))
  else
    fDmCupomFiscal.sdsProduto.CommandText := fDmCupomFiscal.ctProduto + ' AND ID = ' + (Trim(Edit1.Text));
  fDmCupomFiscal.cdsProduto.Open;
  if fDmCupomFiscal.cdsProduto.IsEmpty then
  begin
    ShowMessage('Refer�ncia n�o localizada!');
    Exit;
  end;
//  Edit1.Text := fDmCupomFiscal.cdsProdutoID.AsString;

//seleciona cor/tamanho
  fSel_CorTamanho := TfSel_CorTamanho.Create(Self);
  fSel_CorTamanho.fDmCupomFiscal := fDmCupomFiscal;
  fSel_CorTamanho.vProd          := fDmCupomFiscal.cdsProdutoID.AsInteger;
  fSel_CorTamanho.ShowModal;

  Edit1.Text             := fDmCupomFiscal.cdsProdutoID.AsString;
//  RxDBLookupCombo1.Value := fDmCupomFiscal.vTamanho;
//  pnlTamanho.Visible     := True;
end;

procedure TfCupomFiscal.DBEdit4KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = Vk_Return) then
  begin
    if fDmCupomFiscal.cdsCupomFiscal.State in [dsEdit] then
    begin
      fDmCupomFiscal.cdsCupomFiscal.Post;
      fDmCupomFiscal.cdsCupomFiscal.ApplyUpdates(0);
    end;
  end;
end;

procedure TfCupomFiscal.SMDBGrid1DblClick(Sender: TObject);
begin
  fCupomFiscalImposto := TfCupomFiscalImposto.Create(Self);
  fCupomFiscalImposto.fDmCupomFiscal := fDmCupomFiscal;
  fDmCupomFiscal.vID_CFOP := fDmCupomFiscal.cdsCupom_ItensID_CFOP.AsInteger;

  fDmCupomFiscal.vID_Pis         := fDmCupomFiscal.cdsCupom_ItensID_PIS.AsInteger;
  fDmCupomFiscal.vID_Cofins      := fDmCupomFiscal.cdsCupom_ItensID_COFINS.AsInteger;
  fDmCupomFiscal.vID_CSTICMS     := fDmCupomFiscal.cdsCupom_ItensID_CSTICMS.AsInteger;
  fDmCupomFiscal.vID_CSTIPI      := fDmCupomFiscal.cdsCupom_ItensID_CSTIPI.AsInteger;
  fDmCupomFiscal.vVlr_ICMS       := fDmCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat;
  fDmCupomFiscal.vBase_ICMS      := fDmCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat;
  fDmCupomFiscal.vVlr_ICMS_Ret   := fDmCupomFiscal.cdsCupom_ItensVLR_ICMSSUBST_RET.AsFloat;
  fDmCupomFiscal.vBase_ICMS_Ret  := fDmCupomFiscal.cdsCupom_ItensBASE_ICMSSUBST_RET.AsFloat;
  fDmCupomFiscal.vVlr_ICMS_Efet  := fDmCupomFiscal.cdsCupom_ItensVLR_ICMS_EFE.AsFloat;
  fDmCupomFiscal.vPerc_ICMS_Efet := fDmCupomFiscal.cdsCupom_ItensPERC_ICMS_EFET.AsFloat;
  fDmCupomFiscal.vBase_ICMS_Efet := fDmCupomFiscal.cdsCupom_ItensVLR_BASE_EFET.AsFloat;

  {if fDmCupomFiscal.vTipo_Pis = 'P' then
    ComboBox1.ItemIndex := 0
  else
  if fDmCupomFiscal.vTipo_Pis = 'V' then
    ComboBox1.ItemIndex := 1;
  if fDmCupomFiscal.vTipo_Cofins = 'P' then
    ComboBox2.ItemIndex := 0
  else
  if fDmCupomFiscal.vTipo_Cofins = 'V' then
    ComboBox2.ItemIndex := 1;}
  fCupomFiscalImposto.ShowModal;
  FreeAndNil(fCupomFiscalImposto);
end;

procedure TfCupomFiscal.prcPesa;
var
  strPeso: String;
  TimeOut: Integer;
begin
    if vBalanca = 'URANO' then
    begin
      StrPeso := _LePeso;
      if StrPeso = 'Porta serial fechada!'#$D#$A then
      begin
        ShowMessage('Porta serial fechada!');
        Exit;
      end;
      Edit2.Text := _LePeso;
      CurrencyEdit1.Value := StrToFloat(Copy(Edit2.Text,20,6));
    end
    else
    if vBalanca = 'ACBR' then
    begin
       // se houver conec��o aberta, Fecha a conec��o
       if acbrBal1.Ativo then
          ACBrBAL1.Desativar;

       // configura porta de comunica��o
       ACBrBAL1.Modelo           := TACBrBALModelo(2);
       ACBrBAL1.Device.HandShake := TACBrHandShake(0);
       ACBrBAL1.Device.Parity    := TACBrSerialParity(0);
       ACBrBAL1.Device.Stop      := TACBrSerialStop(0);
       ACBrBAL1.Device.Data      := StrToInt('8');
       ACBrBAL1.Device.Baud      := StrToInt('2400');
       ACBrBAL1.Device.Baud      := StrToInt('2400');
       ACBrBAL1.Device.Porta     := 'COM2';                  

       // Conecta com a balan�a
       ACBrBAL1.Ativar;
       TimeOut := 2000 ;
       ACBrBAL1.LePeso( TimeOut );
    end;
end;

procedure TfCupomFiscal.ACBrBAL1LePeso(Peso: Double; Resposta: String);
var
  Valid: Integer;
begin
   CurrencyEdit1.Value := Peso;

   if Peso > 0 then
   else
    begin
      valid := Trunc(ACBrBAL1.UltimoPesoLido);
      case valid of
         0 : ShowMessage('TimeOut !'+sLineBreak+
                         'Coloque o produto sobre a Balan�a!');
        -1 : ShowMessage('Peso Inst�vel ! ' +sLineBreak+
                         'Tente Nova Leitura');
        -2 : ShowMessage('Peso Negativo !');
       -10 : ShowMessage('Sobrepeso !');
      end;
    end ;
end;

function TfCupomFiscal.fnc_Validacao_OK: Boolean;
var
  vMSG : String;
begin
  vMSG := '';
  Result := True;
  if fDmCupomFiscal.cdsCupomParametrosEXIGE_CAIXA_ABERTO.AsString = 'S' then
  begin
    fDmParametros.qCaixaAberto.Close;
    fDmParametros.qCaixaAberto.ParamByName('T1').AsInteger := vTerminal;
    fDmParametros.qCaixaAberto.ParamByName('D1').AsDate    := Date;
    fDmParametros.qCaixaAberto.Open;
    if fDmParametros.qCaixaAberto.IsEmpty then
      vMSG := vMSG + #13 + 'N�o existe caixa aberto para efetuar venda!'
    else
    if (fDmParametros.qCaixaAbertoDATA.AsDateTime < Date) then
    begin
      if (fDmParametros.qCaixaAbertoDATA2.AsDateTime > fDmParametros.qCaixaAbertoDATA.AsDateTime) then
        vMSG := vMSG + #13 + '*** Caixa aberto com data: ' + fDmParametros.qCaixaAbertoDATA.AsString
                     + ', mas j� existe caixa com data superior pendente de confer�ncia ou j� encerrado!'
                     + #13 + ' FAVOR VERIFICAR!';
      if fDmCupomFiscal.vID_Fechamento <> fDmParametros.qCaixaAbertoID.AsInteger then
      begin
        if (MessageDlg('Caixa aberto com data de ' + fDmParametros.qCaixaAbertoDATA.AsString +
                       ', usar este mesmo caixa?',mtConfirmation,[mbYes,mbNo],0) = mrNo) then
          Result := False;
      end;
    end;
  end;
  fDmCupomFiscal.cdsPessoa.IndexFieldNames := 'CODIGO';
  fDmCupomFiscal.vClienteID := fDmCupomFiscal.cdsParametrosID_CLIENTE_CONSUMIDOR.AsInteger;
  if not fDmCupomFiscal.cdsPessoa.FindKey([fDmCupomFiscal.cdsParametrosID_CLIENTE_CONSUMIDOR.AsInteger]) then
    vMSG := vMSG + #13 + 'N�o existe Cliente Consumidor c�digo ' + fDmCupomFiscal.cdsParametrosID_CLIENTE_CONSUMIDOR.AsString + '!';
  if (fDmCupomFiscal.cdsParametrosUSA_NFCE.AsString = 'S') and (trim(fDmCupomFiscal.cdsFilialSERIE_NFCE.AsString) = '') then
    vMSG := vMSG + #13 + 'S�rie da NFCe n�o informada na Filial!';
  if Trim(vMSG) <> '' then
  begin
    MessageDlg(vMSG, mtInformation, [mbOk], 0);
    Result := False;
  end;
  if Result then
    fDmCupomFiscal.vID_Fechamento := fDmParametros.qCaixaAbertoID.AsInteger;
  fDmParametros.qCaixaAberto.Close;
end;

procedure TfCupomFiscal.prc_Inserir;
var
  iRetorno: Integer;
  NCupom, vEst: String;
  vArq: String;
begin
  fDmCupomFiscal.mPedidoAux.EmptyDataSet;

  fDmCupomFiscal.cdsFilial.IndexFieldNames := 'ID';
  fDmCupomFiscal.cdsFilial.FindKey([vFilial_Loc]);
  fDmCupomFiscal.vClienteID := fDmCupomFiscal.cdsParametrosID_CLIENTE_CONSUMIDOR.AsInteger;

  fDmCupomFiscal.prcInserir(0,fDmCupomFiscal.vClienteID);

  if fDmCupomFiscal.cdsParametrosUSA_NFCE.AsString = 'S' then
  begin
    fDmCupomFiscal.cdsCupomFiscalTIPO.AsString := 'NFC';
    if fDmCupomFiscal.cdsCupomParametrosCAIXA_NUMERA_COMANDA.AsString = 'S' then
      fDmCupomFiscal.cdsCupomFiscalNUM_CARTAO.AsInteger := fDmCupomFiscal.fnc_IncrementaCartao(vTerminal);
    fDmCupomFiscal.cdsCupomFiscalID_CLIENTE.AsInteger := fDmCupomFiscal.vClienteID;
    fDmCupomFiscal.cdsCupomFiscalTIPO_DESTINO_OPERACAO.AsInteger := 1;
    fDMCupomFiscal.cdsCupomFiscalTIPO_ATENDIMENTO.AsInteger      := 1;
    fDMCupomFiscal.cdsCupomFiscalTIPO_ENVIONFE.AsString          := '1-NORMAL';
    fDmCupomFiscal.cdsCupomFiscalSERIE.AsString                  := fDmCupomFiscal.cdsFilialSERIE_NFCE.AsString;
  end
  else
  begin
//---------------TROCAR IMPRESSORA
    case fDmCupomFiscal.cdsParametrosIMPRESSORA_FISCAL.AsInteger of
      5: begin
           fDmCupomFiscal.prcNumNaoFiscal;
           fDmCupomFiscal.cdsCupomFiscalTIPO.AsString := 'CNF';
           if fDmCupomFiscal.cdsCupomParametrosCAIXA_NUMERA_COMANDA.AsString = 'S' then
             fDmCupomFiscal.cdsCupomFiscalNUM_CARTAO.AsInteger := fDmCupomFiscal.fnc_IncrementaCartao(vTerminal);
         end;
      6: begin
           fDmCupomFiscal.prcNumNaoFiscal;
           fDmCupomFiscal.cdsCupomFiscalTIPO.AsString := 'CNF';
           if fDmCupomFiscal.cdsCupomParametrosCAIXA_NUMERA_COMANDA.AsString = 'S' then
             fDmCupomFiscal.cdsCupomFiscalNUM_CARTAO.AsInteger := fDmCupomFiscal.fnc_IncrementaCartao(vTerminal);
         end;
    end;
  end;

  if fDmCupomFiscal.cdsCupomFiscal.State in [dsInsert] then
  begin
    fDmCupomFiscal.cdsCupomFiscal.Post;
    fDmCupomFiscal.cdsCupomFiscal.ApplyUpdates(0);
    fDmCupomFiscal.cdsCupomFiscal.Edit;
  end;
end;

end.
