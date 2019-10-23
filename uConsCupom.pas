unit uConsCupom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RxLookup, NxCollection, StdCtrls, Mask, ToolEdit, Grids,
  DBGrids, SMDBGrid, uDmCupomFiscal, uUtilPadrao, uNFCE_ACBr;

type
  TfrmConsCupom = class(TForm)
    pnlPrincipal: TPanel;
    pnlTop: TPanel;
    GridCupom: TSMDBGrid;
    Label1: TLabel;
    dtInicial: TDateEdit;
    Label2: TLabel;
    dtFinal: TDateEdit;
    btnConsultar: TNxButton;
    Label20: TLabel;
    ComboTerminal: TRxDBLookupCombo;
    cbNEnviados: TCheckBox;
    btnEnviar: TNxButton;
    btnReimprimir: TNxButton;
    procedure FormShow(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnEnviarClick(Sender: TObject);
    procedure btnReimprimirClick(Sender: TObject);
  private
    { Private declarations }
    fNFCE_ACBr : TfNFCE_ACBR;
    procedure prc_Consultar;
  public
    { Public declarations }
    fDmCupomFiscal: TDmCupomFiscal;
    vCancelar : Boolean;
  end;

var
  frmConsCupom: TfrmConsCupom;

implementation


{$R *.dfm}

procedure TfrmConsCupom.FormShow(Sender: TObject);
begin
  fNFCE_ACBr := TfNFCE_ACBR.Create(nil);
  fDmCupomFiscal.cdsTerminal.Open;
  dtInicial.Date := Date;
  dtFinal.Date := Date;
  ComboTerminal.KeyValue := vTerminal;
  if vCancelar then
    btnEnviar.Caption := 'Cancelar NFCe';
  btnConsultarClick(Sender);
end;

procedure TfrmConsCupom.btnConsultarClick(Sender: TObject);
begin
  prc_Consultar;
end;

procedure TfrmConsCupom.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Close;
  FreeAndNil(fNFCE_ACBr);  
end;

procedure TfrmConsCupom.btnEnviarClick(Sender: TObject);
var
  NumCupom : String;
begin
  if vCancelar then
  begin
    if trim(fDMCupomFiscal.cdsCupomFiscalNFEPROTOCOLO_CANCELADA.AsString) <> EmptyStr then
    begin
      MessageDlg('*** Cupom j� cancelado!', mtInformation, [mbOk], 0);
      exit;
    end;
    NumCupom := IntToStr(fDmCupomFiscal.cdsCupom_ConsNUMCUPOM.AsInteger);
    if MessageDlg('Tem certeza que deseja cancelar o Cupom N�: ' + NumCupom,mtConfirmation,[mbYes,mbNo],0) = mrNo then
      Exit;
    fNFCE_ACBr.fdmCupomFiscal := fDmCupomFiscal;
    fNFCE_ACBr.vID_Cupom_Novo := fDmCupomFiscal.cdsCupom_ConsID.AsInteger;
    fNFCE_ACBr.ComboAmbiente.ItemIndex := StrToIntDef(fdmCupomFiscal.cdsFilialNFCEPRODUCAO.AsString,1) - 1;
    fDmCupomFiscal.cdsCupomFiscal.Close;
    try
      fNFCE_ACBr.btCancelarClick(Sender);
    except
      on E : Exception do
      begin
        ShowMessage('Erro: ' + e.Message);
      end;
    end;
    btnConsultarClick(Sender);
  end
  else
  begin
    fDmCupomFiscal.cdsCupom_Cons.First;
    while not fDmCupomFiscal.cdsCupom_Cons.Eof do
    begin
      if GridCupom.SelectedRows.CurrentRowSelected then
      begin
        fNFCE_ACBr.fdmCupomFiscal := fDmCupomFiscal;
        fNFCE_ACBr.vID_Cupom_Novo := fDmCupomFiscal.cdsCupom_ConsID.AsInteger;
        fNFCE_ACBr.ComboAmbiente.ItemIndex := StrToIntDef(fdmCupomFiscal.cdsFilialNFCEPRODUCAO.AsString,1) - 1;
        fNFCE_ACBr.chkGravarXml.Checked := True;
        fDmCupomFiscal.cdsCupomFiscal.Close;
        try
          fNFCE_ACBr.btEnviarNovoClick(Sender);
        except
          on E : Exception do
          begin
            ShowMessage('Erro: ' + e.Message);
          end;
        end;
      end;
      fDmCupomFiscal.cdsCupom_Cons.Next;
    end;
    btnConsultarClick(Sender);
  end;
end;

procedure TfrmConsCupom.prc_Consultar;
var
  vComando: string;
begin
  fDmCupomFiscal.cdsCupom_Cons.Close;
  vComando := fDmCupomFiscal.ctConsCupom;
  vComando := vComando + 'WHERE 0=0';
  vComando := vComando + ' AND CF.DTEMISSAO >= ' + QuotedStr(FormatDateTime('MM/DD/YYYY', dtInicial.date));
  vComando := vComando + ' AND CF.DTEMISSAO <= ' + QuotedStr(FormatDateTime('MM/DD/YYYY', dtFinal.date));
  if ComboTerminal.KeyValue > 0 then
    vComando := vComando + ' AND TERMINAL_ID = ' + ComboTerminal.Value;
  if vCancelar then
  begin
    cbNEnviados.Checked := False;
    cbNEnviados.Enabled := False;
    vComando := vComando + ' AND NFEPROTOCOLO IS NOT NULL AND NFEPROTOCOLO_CANCELADA IS NULL';
  end;
  if cbNEnviados.Checked then
    vComando := vComando + ' AND NFECHAVEACESSO IS NULL';
  fDmCupomFiscal.sdsCupom_Cons.CommandText := vComando;
  fDmCupomFiscal.cdsCupom_Cons.Open;
end;

procedure TfrmConsCupom.btnReimprimirClick(Sender: TObject);
begin
  fNFCE_ACBr.fdmCupomFiscal := fDmCupomFiscal;
  fNFCE_ACBr.vID_Cupom_Novo := fDmCupomFiscal.cdsCupom_ConsID.AsInteger;
  fDmCupomFiscal.cdsCupomFiscal.Close;
  try
    fNFCE_ACBr.btImprimirClick(Sender);
  except
    on E : Exception do
    begin
      ShowMessage('Erro: ' + e.Message);
    end;
  end;
end;

end.

