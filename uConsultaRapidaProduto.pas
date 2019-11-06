unit uConsultaRapidaProduto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RXCtrls, ExtCtrls, AdvPanel, Grids, DBGrids, SMDBGrid, RxLookup,
  StdCtrls, DB, uDmCupomFiscal;

type
  TfrmConsultaRapidaProduto = class(TForm)
    scrollPrincipal: TScrollBox;
    scrollEsquerda: TScrollBox;
    scrollDiretia: TScrollBox;
    lblProduto: TRxLabel;
    pnlCabecalho: TAdvPanel;
    RxLabel1: TRxLabel;
    RxLabel2: TRxLabel;
    RxLabel4: TRxLabel;
    edtDescricao: TEdit;
    edtReferencia: TEdit;
    RxLabel3: TRxLabel;
    edtCodigoBarra: TEdit;
    comboGrupo: TRxDBLookupCombo;
    pnlPrincipal: TAdvPanel;
    pnlDivisao: TAdvPanel;
    gridProduto: TSMDBGrid;
    procedure FormShow(Sender: TObject);
    procedure edtDescricaoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure gridProdutoDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure MakeRounded(Control: TWinControl);
  public
    fdmCupomFiscal : TdmCupomFiscal;
    codigoProdutoRetorno : Integer;
    procedure prc_Consultar;
    { Public declarations }
  end;

var
  frmConsultaRapidaProduto: TfrmConsultaRapidaProduto;

implementation

{$R *.dfm}

{ TfrmConsultaRapidaProduto }

procedure TfrmConsultaRapidaProduto.MakeRounded(Control: TWinControl);
var
  R: TRect;
  Rgn: HRGN;
begin
  with Control do
  begin
    R := ClientRect;
    Rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, 20, 20);
    Perform(EM_GETRECT, 0, lParam(@R));
    InflateRect(R, -5, -5);
    Perform(EM_SETRECTNP, 0, lParam(@R));
    SetWindowRgn(Handle, Rgn, True);
    Invalidate;
  end;
end;

procedure TfrmConsultaRapidaProduto.FormShow(Sender: TObject);
begin
  pnlCabecalho.BorderStyle := bsNone;
  MakeRounded(pnlCabecalho);
  pnlPrincipal.BorderStyle := bsNone;
  MakeRounded(pnlPrincipal);
  if edtDescricao.Text <> EmptyStr then
  begin
    prc_Consultar;
  end;

end;

procedure TfrmConsultaRapidaProduto.prc_Consultar;
var
  filtro : String;
begin
  filtro := fDmCupomFiscal.ctProduto;
  fDmCupomFiscal.cdsProduto.Close;
  if edtDescricao.Text <> EmptyStr then
    filtro := filtro + ' AND NOME LIKE ' + '''%' + edtDescricao.Text + '%''';
  if edtReferencia.Text <> EmptyStr then
    filtro := filtro + ' AND REFERENCIA LIKE' + '''%' + edtReferencia.Text + '%''';
  if edtCodigoBarra.Text <> EmptyStr then
    filtro := filtro + ' AND REFERENCIA = ' + QuotedStr(edtCodigoBarra.Text);
  if comboGrupo.KeyValue > 0 then
    filtro := filtro + ' AND ID_GRUPO = ' + comboGrupo.KeyValue;
  fDmCupomFiscal.sdsProduto.CommandText := filtro;
  fDmCupomFiscal.cdsProduto.Open;
  gridProduto.SetFocus;
end;

procedure TfrmConsultaRapidaProduto.edtDescricaoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_RETURN : edtReferencia.SetFocus;
    VK_DOWN : prc_Consultar;
  end;
end;

procedure TfrmConsultaRapidaProduto.gridProdutoDblClick(Sender: TObject);
begin
  if fdmCupomFiscal.cdsProduto.IsEmpty then
  begin
    ModalResult := mrCancel;
    close;
  end
  else
  begin
    codigoProdutoRetorno := fdmCupomFiscal.cdsProdutoID.AsInteger;
    ModalResult := mrOk;
  end;

end;

end.

