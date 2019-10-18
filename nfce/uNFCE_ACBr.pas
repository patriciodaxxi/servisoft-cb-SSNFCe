unit uNFCE_ACBr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzTabs, Buttons, StdCtrls, UDMNFCe, uDmParametros,
  uDmCupomFiscal, ACBrDFeUtil, pcnConversao, pcnConversaoNFe, ACBrPosPrinter,
  SqlExpr, dbXPress;

type
  tEnumAmbiente = (tpProducao = 1, tpHomologacao = 2);

type
  TfNFCE_ACBR = class(TForm)
    pnlTop: TPanel;
    pnlPrincipal: TPanel;
    pnlBotton: TPanel;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lbRecibo: TLabel;
    lbNroProtocolo: TLabel;
    lbChaveAcesso: TLabel;
    btDanfe: TButton;
    btEnviarNovo: TButton;
    GroupBox2: TGroupBox;
    Label10: TLabel;
    lbNroProtocoloCancelamento: TLabel;
    btCancelar: TBitBtn;
    Label2: TLabel;
    ComboAmbiente: TComboBox;
    pnlErro: TPanel;
    lbErro: TLabel;
    chkGravarXml: TCheckBox;
    procedure btEnviarNovoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    sXML: string;
    procedure prc_Monta_ICMS00(fDMNFCe: TDMNFCe; CodSitTrib: String);
    procedure prc_Monta_ICMS10(fDMNFCe: TDMNFCe; CodSitTrib: String; Perc_Interno: Real);
    procedure prc_Monta_ICMS20(fDMNFCe: TDMNFCe; CodSitTrib: String);
    procedure prc_Monta_ICMS30(fDMNFCe: TDMNFCe; CodSitTrib: String; Perc_Interno: Real);
    procedure prc_Monta_ICMS40(fDMNFCe: TDMNFCe; CodSitTrib: String);
    procedure prc_Monta_ICMS51(fDMNFCe: TDMNFCe; CodSitTrib: String);
    procedure prc_Monta_ICMS60(fDMNFCe: TDMNFCe; CodSitTrib: String);
    procedure prc_Monta_ICMS70(fDMNFCe: TDMNFCe; CodSitTrib: String; Perc_Interno: Real);
    procedure prc_Monta_ICMS90(fDMNFCe: TDMNFCe; CodSitTrib: String; Perc_Interno: Real);
    procedure prc_Monta_ICMSSN101(fDMNFCe: TDMNFCe; CodSitTrib: String; Perc_Simples: Real);
    procedure prc_Monta_ICMSSN102(fDMNFCe: TDMNFCe; CodSitTrib: String);
    procedure prc_Monta_ICMSSN201(fDMNFCe: TDMNFCe; CodSitTrib: String; Perc_Interno, Perc_Simples: Real);
    procedure prc_Monta_ICMSSN202(fDMNFCe: TDMNFCe; CodSitTrib: String; Perc_Interno: Real);
    procedure prc_Monta_ICMSSN500(fDMNFCe: TDMNFCe; CodSitTrib: String);
    procedure prc_Monta_ICMSSN900(fDMNFCe: TDMNFCe; CodSitTrib: String; Perc_Interno, Perc_Simples: Real);
    procedure Inicia_NFe();
  public
    fDMNFCe: TDMNFCe;
    fdmCupomFiscal: TdmCupomFiscal;
    vID_Cupom_Novo : Integer;
    function fnc_Gerar_NFCe(ID: Integer): string;
    function fnc_Buscar_Finalidade : Integer;

    { Public declarations }
  end;

var
  fNFCE_ACBR: TfNFCE_ACBR;

implementation

uses DB, uUtilPadrao, pcnNFe, ACBrNFe, DmdDatabase, ACBrNFeWebServices;

{$R *.dfm}

{ TfNFCE_ACBR }

function TfNFCE_ACBR.fnc_Gerar_NFCe(ID: Integer): string;
var
  vQtdeRegistros, vTipo_Ambiente_NFe, vItemNFe : Integer;
  vCodCST : String;
  vPerc_Interno: Real;
  vValorTotal, vVlr_Desconto_NFCe : Real;
begin
  fdmCupomFiscal.prcLocalizar(ID);
  fdmCupomFiscal.prc_Localizar_Pessoa(fdmCupomFiscal.cdsCupomFiscalID_CLIENTE.AsInteger);
  Inicia_NFe;
  
  fDMNFCe.Posiciona_CidadeUF(fDMNFCe.qFilialID_CIDADE.AsInteger, -1);
  fDMNFCe.ACBrNFe.DANFE.vTribFed := 0;
  fDMNFCe.ACBrNFe.DANFE.vTribEst := 0;
  fDMNFCe.ACBrNFe.DANFE.vTribMun := 0;
  vItemNFe := 0;
  vVlr_Desconto_NFCe := 0;

  case TEnumAmbiente(ComboAmbiente.ItemIndex) of
    tpProducao : vTipo_Ambiente_NFe := 1;
    tpHomologacao : vTipo_Ambiente_NFe := 2;
  end;
  vTipo_Ambiente_NFe := 2;
  fDMCupomFiscal.vDescricao_Operacao := fDMCupomFiscal.cdsCFOPNOME.AsString;
  fdmCupomFiscal.cdsCupomFiscal.First;
  fDMNFCe.ACBrNFe.NotasFiscais.Clear;
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe do
  begin
    Ide.cNF := GerarCodigoDFe(fDMCupomFiscal.cdsCupomFiscalNUMCUPOM.AsInteger);
    Ide.natOp := 'VENDA CONSUMIDOR';// fDMCupomFiscal.vDescricao_Operacao;
    Ide.modelo := 65;
    Ide.serie := StrToInt(fdmCupomFiscal.cdsCupomFiscalSERIE.AsString);
    Ide.nNF := fDMCupomFiscal.cdsCupomFiscalNUMCUPOM.AsInteger;
    Ide.dEmi := now;
    Ide.dSaiEnt := now;
    Ide.hSaiEnt := now;
    Ide.tpNF := tnSaida;
    Ide.tpEmis := teNormal;
    Ide.cUF := fDMNFCe.qUFCODUF.AsInteger;
    Ide.cMunFG := fDMNFCe.qCidadeCODMUNICIPIO.AsInteger;
    Ide.finNFe := fnNormal;
    Ide.tpImp := tiNFCe;
    if fDMCupomFiscal.cdsPessoaTIPO_CONSUMIDOR.AsInteger = 0 then
      Ide.indFinal := cfNao
    else
      Ide.indFinal := cfConsumidorFinal;
    Ide.indPres := pcPresencial;
    Emit.CNPJCPF := Monta_Texto(fDMNFCe.qFilialCNPJ_CPF.AsString,14);
    Emit.IE := Monta_Numero(fDMNFCe.qFilialINSCR_EST.AsString,0);
    Emit.xNome := TirarAcento(fDMNFCe.qFilialNOME.AsString);
    Emit.xFant := TirarAcento(fDMNFCe.qFilialNOME_INTERNO.AsString);
    Emit.EnderEmit.fone := Monta_Texto(fDMNFCe.qFilialDDD1.AsString + fDMNFCe.qFilialFONE.AsString,0);
    Emit.EnderEmit.CEP := StrToInt(Monta_Texto(fDMNFCe.qFilialCEP.AsString,8));
    Emit.EnderEmit.xLgr := TirarAcento(fDMNFCe.qFilialENDERECO.AsString);
    Emit.EnderEmit.nro := fDMNFCe.qFilialNUM_END.AsString;
    if trim(fDMNFCe.qFilialCOMPLEMENTO_END.AsString) <> EmptyStr then
      Emit.EnderEmit.xCpl := trim(fDMNFCe.qFilialCOMPLEMENTO_END.AsString);
    Emit.EnderEmit.xBairro := TirarAcento(fDMNFCe.qFilialBAIRRO.AsString);
    Emit.EnderEmit.cMun := fDMNFCe.qCidadeCODMUNICIPIO.AsInteger;
    Emit.EnderEmit.xMun := TirarAcento(fDMNFCe.qCidadeNOME.AsString);
    Emit.EnderEmit.UF := fDMNFCe.qCidadeUF.AsString;
    Emit.enderEmit.cPais := 1058;
    Emit.enderEmit.xPais := 'BRASIL';
    Emit.IEST := '';
    if fDMCupomFiscal.cdsFilialID_REGIME_TRIB.AsInteger = 1 then
      Emit.CRT := crtSimplesNacional
    else
    if fDMCupomFiscal.cdsFilialID_REGIME_TRIB.AsInteger = 3 then
      Emit.CRT := crtRegimeNormal
    else
      Emit.CRT := crtSimplesExcessoReceita;

    if fDMCupomFiscal.cdsPessoaPESSOA.AsString = 'J' then
      Dest.CNPJCPF := Monta_Texto(fDMCupomFiscal.cdsPessoaCNPJ_CPF.AsString,14)
    else
    if (fDMCupomFiscal.cdsPessoaPESSOA.AsString = 'F') and (fDMCupomFiscal.cdsPessoaCNPJ_CPF.AsString <> '000.000.000-00') then
      Dest.CNPJCPF := Monta_Texto(fDMCupomFiscal.cdsPessoaCNPJ_CPF.AsString,11);

    if vTipo_Ambiente_NFe = 2 then
      Dest.xNome := 'NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'
    else
      Dest.xNome := TirarAcento(fDMCupomFiscal.cdsPessoaNOME.AsString);
      
    Dest.indIEDest := inNaoContribuinte; {Pq NFCe nao informa Destinatario}

    Total.ICMSTot.vBC := 0;
    Total.ICMSTot.vICMS := 0;
    //Itens Cupom
    fDMCupomFiscal.cdsCupom_Itens.First;
    vQtdeRegistros := fDMCupomFiscal.cdsCupom_Itens.RecordCount;
    while not fDMCupomFiscal.cdsCupom_Itens.Eof do
    begin
      fDMNFCe.prc_Abrir_Produto(fDMCupomFiscal.cdsCupom_ItensID_PRODUTO.AsInteger);
      Inc(vItemNFe);
      with Det.Add do
      begin
        Prod.nItem := vItemNFe;
        Prod.cProd := fDMNFCe.qProdutoID.AsString;

        if fDMNFCe.qParametros_NFeENVAR_CODBARRA.AsString = 'S' then
          Prod.cEAN := fDMCupomFiscal.cdsProdutoCOD_BARRA.AsString;
        if Trim(Prod.cEAN) = EmptyStr then
          Prod.cEAN   := 'SEM GTIN';

        Prod.cEANTrib := Prod.cEAN;
        if fDMNFCe.qProdutoCOD_BARRA2.AsString <> EmptyStr then
          Prod.cEANTrib := trim(fDMNFCe.qProdutoCOD_BARRA2.AsString);

        if (vItemNFe = 1) and (vTipo_Ambiente_NFe = 2) then
          Prod.XProd := 'NOTA FISCAL EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL'
        else
          Prod.XProd := TirarAcento(fDMCupomFiscal.cdsCupom_ItensNOME_PRODUTO.AsString);

        if fDMCupomFiscal.cdsTab_NCM.FindKey([fDMCupomFiscal.cdsCupom_ItensID_NCM.AsInteger]) then
        begin
          Prod.NCM := fDMCupomFiscal.cdsTab_NCMNCM.AsString;
          if (trim(fDMCupomFiscal.cdsTab_NCMCOD_CEST.AsString) <> '') then
            Prod.CEST := fDMCupomFiscal.cdsTab_NCMCOD_CEST.AsString;
        end;
        Prod.EXTIPI := '';
        fDMCupomFiscal.cdsCFOP.Locate('ID',fDMCupomFiscal.cdsCupom_ItensID_CFOP.AsInteger,([Locaseinsensitive]));
        Prod.CFOP := fDMCupomFiscal.cdsCFOPCODCFOP.AsString;
        Prod.uCom := TirarAcento(fDMCupomFiscal.cdsCupom_ItensUNIDADE.AsString);
        Prod.qCom := StrToFloat(FormatFloat('0.000',fDMCupomFiscal.cdsCupom_ItensQTD.AsFloat));

        Prod.vUnCom := StrToFloat(FormatFloat('0.0000000000',fDMCupomFiscal.cdsCupom_ItensVLR_UNITARIO.AsFloat));
        Prod.vProd := strToFloat(FormatFloat('0.00',(fDMCupomFiscal.cdsCupom_ItensVLR_TOTAL.AsFloat + fDMCupomFiscal.cdsCupom_ItensVLR_DESCONTO.AsFloat +
                                                     fDMCupomFiscal.cdsCupom_ItensVLR_DESCONTORATEIO.AsFloat)));
        Prod.uTrib := fDMCupomFiscal.cdsCupom_ItensUNIDADE.AsString;
        Prod.qTrib := StrToFloat(FormatFloat('0.0000',fDMCupomFiscal.cdsCupom_ItensQTD.AsFloat * fDMCupomFiscal.cdsProdutoQTD_EMBALAGEM.AsFloat));
        if Prod.qTrib = 0 then
          Prod.qTrib := Prod.qCom;

        if (StrToFloat(FormatFloat('0.0000',fDMNFCe.qProdutoQTD_EMBALAGEM.AsFloat)) > 0) and (trim(fDMNFCe.qProdutoCOD_BARRA2.AsString) <> EmptyStr) then
          Prod.vUnTrib :=  StrToFloat(FormatFloat('0.0000000000',fDMCupomFiscal.cdsCupom_ItensVLR_UNITARIO.AsFloat / fDMNFCe.qProdutoQTD_EMBALAGEM.AsFloat))
        else
          Prod.vUnTrib := StrToFloat(FormatFloat('0.0000000000',fDMCupomFiscal.cdsCupom_ItensVLR_UNITARIO.AsFloat));
        Prod.vOutro := StrToFloat(FormatFloat('0.000',fDMCupomFiscal.cdsCupomFiscalVLR_OUTROS.AsCurrency));
        Prod.vFrete := 0;
        Prod.vSeg := 0;
        Prod.vDesc := 0;

        Prod.vDesc := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_DESCONTO.AsFloat + fDMCupomFiscal.cdsCupom_ItensVLR_DESCONTORATEIO.AsFloat));
        vVlr_Desconto_NFCe := Prod.vdesc + vVlr_Desconto_NFCe;

        if ((trim(fDMNFCe.qProdutoCOD_CEST.AsString)) <> EmptyStr) then
          Prod.CEST := fDMNFCe.qProdutoCOD_CEST.AsString;

        {CEST CODIGO}
        if (trim(fDMCupomFiscal.cdsTab_NCMCOD_CEST.AsString) <> EmptyStr) and (Prod.CEST = EmptyStr) then
          Prod.CEST := fDMCupomFiscal.cdsTab_NCMCOD_CEST.AsString;

        with Imposto do
        begin
          fdmCupomFiscal.cdsTab_CSTICMS.Locate('ID',fdmCupomFiscal.cdsCupom_ItensID_CSTICMS.AsInteger,[loCaseInsensitive]);
          vCodCST := fDMCupomFiscal.cdsTab_CSTICMSCOD_CST.AsString;
          if fDMCupomFiscal.cdsCupom_ItensORIGEM_PROD.AsString = '0' then
            ICMS.orig := oeNacional
          else
          if fDMCupomFiscal.cdsCupom_ItensORIGEM_PROD.AsString = '1' then
            ICMS.orig := oeEstrangeiraImportacaoDireta
          else
            ICMS.orig := oeEstrangeiraAdquiridaBrasil;

          vPerc_Interno := StrToFloat(FormatFloat('0.0000',fDMCupomFiscal.qUFPERC_ICMS_INTERNO.AsFloat));

          if vCodCST = '00' then
          begin
            ICMS.CST := cst00;
            ICMS.modBC := dbiMargemValorAgregado;
            ICMS.vBC := fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat;
            ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
            ICMS.vICMS := fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat;
          end
          else
          if vCodCST = '10' then
          begin
            ICMS.CST := cst10;
            ICMS.modBC := dbiMargemValorAgregado;
            ICMS.vBC := fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat;
            ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
            ICMS.vICMS := fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat;
            ICMS.modBCST := dbisMargemValorAgregado;
            ICMS.pMVAST := 0;
            ICMS.pRedBCST := 0;
            ICMS.pICMSST := vPerc_Interno;
            ICMS.vBCST := 0;
            ICMS.vICMSST := 0;
          end
          else
          if vCodCST = '20' then
          begin
            ICMS.CST := cst20;
            ICMS.modBC := dbiMargemValorAgregado;
            ICMS.vBC := fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat;
            ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
            ICMS.vICMS := fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat;
            if fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat > 0 then
              ICMS.pRedBC := 100 - fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat;
            ICMS.vICMSDeson := 0;
          end
          else
          if vCodCST = '30' then
          begin
            ICMS.CST := cst30;
            ICMS.modBC := dbiMargemValorAgregado;
            ICMS.modBCST := dbisMargemValorAgregado;
            ICMS.pMVAST := 0;
            ICMS.pRedBCST := 0;
            ICMS.pICMSST := StrToFloat(FormatFloat('0.00##',vPerc_Interno));
            ICMS.vBCST := 0;
            ICMS.vICMSST := 0;
            ICMS.vICMSDeson := 0;
          end
          else
          if (vCodCST = '40') or (vCodCST = '41') or (vCodCST = '50') then
          begin
            ICMS.CST := cst40;
            ICMS.vICMSDeson := 0;
          end
          else
          if (vCodCST = '51') then
          begin
            ICMS.CST := cst51;
            ICMS.modBC := dbiMargemValorAgregado;
            if fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat > 0 then
              ICMS.pRedBC := 100 - StrToFloat(FormatFloat('0.0000',fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat));
            ICMS.vBC := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat));
            ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
            ICMS.vICMS := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat));
          end
          else
          if (vCodCST = '60') then
          begin
            ICMS.CST := cst60;
            ICMS.modBC := dbiMargemValorAgregado;
            ICMS.VBCSTRet := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMSSUBST_RET.AsFloat));
            ICMS.pST := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensPERC_ST.AsFloat));
            ICMS.vICMSSTRet := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdscupom_ItensVLR_ICMSSUBST_RET.AsFloat));
            if fDMCupomFiscal.cdsCupom_ItensVLR_ICMS_EFE.AsFloat > 0 then
            begin
              ICMS.vICMSEfet := StrToFloat(formatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS_EFE.AsFloat));
              ICMS.pRedBCEfet := StrToFloat(formatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensPERC_BASE_RED_EFET.AsFloat));
              ICMS.vBCEfet := StrToFloat(formatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_BASE_EFET.AsFloat));
              ICMS.pICMSEfet := StrToFloat(FormatFloat('0.00', fDMCupomFiscal.cdsCupom_ItensPERC_ICMS_EFET.AsFloat));
            end;
//            prc_Monta_ICMS60(fDMNFCe,vCodCST)
          end
          else
          if (vCodCST = '70') then
          begin
            ICMS.CST := cst70;
            ICMS.modBC := dbiMargemValorAgregado;
            if fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat > 0 then
              ICMS.pRedBC := 100 - fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat;
            ICMS.vBC := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat));
            ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
            ICMS.vICMS := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat));
            ICMS.modBCST := dbisMargemValorAgregado;
            ICMS.pMVAST := 0;
            ICMS.pRedBCST := 0;
            ICMS.pICMSST := StrToFloat(FormatFloat('0.00##',vPerc_Interno));
            ICMS.vBCST := 0;
            ICMS.vICMSST := 0;
            ICMS.vICMSDeson := 0;
          end
          else
          if (vCodCST = '90') then
          begin
            ICMS.CST := cst90;
            ICMS.modBC := dbiMargemValorAgregado;
            if fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat > 0 then
              ICMS.pRedBC := 100 - StrToFloat(FormatFloat('0.0000',fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat));
            ICMS.vBC := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat));
            ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
            ICMS.vICMS := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat));
            ICMS.modBCST := dbisMargemValorAgregado;
            ICMS.pMVAST := 0;
            ICMS.pRedBCST := 0;
            ICMS.pICMSST := StrToFloat(FormatFloat('0.00##',vPerc_Interno));
            ICMS.vBCST := 0;
            ICMS.vICMSST := 0;
            ICMS.vICMSDeson := 0;
          end
          else
          if (vCodCST = '101') then
          begin
            ICMS.CSOSN := csosn101;
            ICMS.pCredSN := vPerc_Interno;
            ICMS.VCredICMSSN := 0;
          end
          else
          if (vCodCST = '102') or (vCodCST = '103') or (vCodCST = '300') or (vCodCST = '400') then
          begin
            ICMS.CSOSN := csosn102;
          end
          else
          if vCodCST = '201' then
          begin
            ICMS.CSOSN := csosn201;
            ICMS.modBCST := dbisMargemValorAgregado;
            ICMS.pMVAST := 0;
            ICMS.pRedBCST := 0;
            ICMS.pICMSST := vPerc_Interno;
            ICMS.vBCST := 0;
            ICMS.vICMSST := 0;
            ICMS.pCredSN := vPerc_Interno;
            ICMS.vCredICMSSN := 0
          end
          else
          if (vCodCST = '202') or (vCodCST = '203') then
          begin
            ICMS.CSOSN := csosn202;
            ICMS.modBCST := dbisMargemValorAgregado;
            ICMS.pMVAST := 0;
            ICMS.pRedBCST := 0;
            ICMS.pICMSST := vPerc_Interno;
            ICMS.vBCST := 0;
            ICMS.vICMSST := 0;
            ICMS.vCredICMSSN := 0
          end
          else
          if vCodCST = '500' then
          begin
            ICMS.CSOSN := csosn500;
            ICMS.modBCST := dbisMargemValorAgregado;
            ICMS.vBCSTRet := fDMCupomFiscal.cdsCupom_ItensBASE_ICMSSUBST_RET.AsFloat;
            ICMS.pST := fDMCupomFiscal.cdsCupom_ItensPERC_ST.AsFloat;
            ICMS.vICMSSTRet := fDMNFCe.mItensNFeVlr_ST_Ret.AsFloat + fDMCupomFiscal.cdscupom_ItensVLR_ICMSSUBST_RET.AsFloat;
            if fDMCupomFiscal.cdsCupom_ItensVLR_ICMS_EFE.AsFloat > 0 then
            begin
              ICMS.VICMSEfet := fDMCupomFiscal.cdsCupom_ItensVLR_ICMS_EFE.AsFloat;
              ICMS.vBCEfet := fDMCupomFiscal.cdsCupom_ItensVLR_BASE_EFET.AsFloat;
              ICMS.pICMSEfet := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS_EFET.AsFloat;
              ICMS.pRedBCEfet := fDMCupomFiscal.cdsCupom_ItensPERC_BASE_RED_EFET.AsFloat;
            end;
          end
          else
          if vCodCST = '900' then
          begin
            ICMS.CSOSN := csosn900;
            ICMS.modBCST := dbisListaPositiva;
            ICMS.vBCSTRet := fDMCupomFiscal.cdsCupom_ItensBASE_ICMSSUBST_RET.AsFloat;
            ICMS.vBC := fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat;
            if fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat > 0 then
            begin
              ICMS.pRedBC := 100 - fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat;
              if ICMS.pRedBC = 100 then
                ICMS.pRedBC := 0;
            end
            else
            begin
              if fDMCupomFiscal.cdsTab_CSTICMSPERCENTUAL.AsFloat > 0 then
                ICMS.pRedBC := 100 - fDMCupomFiscal.cdsTab_CSTICMSPERCENTUAL.AsFloat;
            end;
            ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
            ICMS.vICMS := fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat;
            ICMS.modBCST := dbisMargemValorAgregado;
            ICMS.pMVAST := 0;
            ICMS.pRedBCST := 0;
            ICMS.pICMSST := vPerc_Interno;
            ICMS.vBCST := 0;
            ICMS.vICMSST := 0;
            ICMS.PCredSN := vPerc_Interno;
            ICMS.VCredICMSSN := 0;
          end;
          //Cofins
          fDMCupomFiscal.cdsTab_Cofins.FindKey([fDMCupomFiscal.cdsCupom_ItensID_COFINS.AsInteger]);
          if fDMCupomFiscal.cdsTab_CofinsCODIGO.AsString = '01' then
            COFINS.CST := cof01;
          if fDMCupomFiscal.cdsTab_CofinsCODIGO.AsString = '02' then
            COFINS.CST := cof02;
          if fDMCupomFiscal.cdsTab_CofinsCODIGO.AsString = '03' then
            COFINS.CST := cof03;
          if fDMCupomFiscal.cdsTab_CofinsCODIGO.AsString = '04' then
            COFINS.CST := cof04;
          if fDMCupomFiscal.cdsTab_CofinsCODIGO.AsString = '05' then
            COFINS.CST := cof05;
          if fDMCupomFiscal.cdsTab_CofinsCODIGO.AsString = '06' then
            COFINS.CST := cof06;
          if fDMCupomFiscal.cdsTab_CofinsCODIGO.AsString = '07' then
            COFINS.CST := cof07;
          if fDMCupomFiscal.cdsTab_CofinsCODIGO.AsString = '08' then
            COFINS.CST := cof08;
          if fDMCupomFiscal.cdsTab_CofinsCODIGO.AsString = '09' then
            COFINS.CST := cof09;
          if fDMCupomFiscal.cdsTab_CofinsCODIGO.AsString = '49' then
            COFINS.CST := cof49;
          if fDMCupomFiscal.cdsTab_CofinsCODIGO.AsString = '99' then
            COFINS.CST := cof99;
          vValorTotal := 0;

          if (fDMCupomFiscal.cdsCupom_ItensPERC_COFINS.AsFloat > 0) and (fDMCupomFiscal.cdsCupom_ItensVLR_COFINS.AsFloat > 0) then
            vValorTotal := fDMCupomFiscal.cdsCupom_ItensVLR_TOTAL.AsFloat +
                           fDMCupomFiscal.cdsCupom_ItensVLR_DESCONTO.AsFloat +
                           fDMCupomFiscal.cdsCupom_ItensVLR_DESCONTORATEIO.AsFloat;
          COFINS.vBC := vValorTotal;
          COFINS.pCOFINS := fDMCupomFiscal.cdsCupom_ItensPERC_COFINS.AsFloat;
          COFINS.vCOFINS := fDMCupomFiscal.cdsCupom_ItensVLR_COFINS.AsFloat;

          //Pis
          fDMCupomFiscal.cdsTab_Pis.FindKey([fDMCupomFiscal.cdsCupom_ItensID_PIS.AsInteger]);
          if fDMCupomFiscal.cdsTab_PisCODIGO.AsString = '01' then
            PIS.CST := pis01;
          if fDMCupomFiscal.cdsTab_PisCODIGO.AsString = '02' then
            PIS.CST := pis02;
          if fDMCupomFiscal.cdsTab_PisCODIGO.AsString = '03' then
            PIS.CST := pis03;
          if fDMCupomFiscal.cdsTab_PisCODIGO.AsString = '04' then
            PIS.CST := pis04;
          if fDMCupomFiscal.cdsTab_PisCODIGO.AsString = '05' then
            PIS.CST := pis05;
          if fDMCupomFiscal.cdsTab_PisCODIGO.AsString = '06' then
            PIS.CST := pis06;
          if fDMCupomFiscal.cdsTab_PisCODIGO.AsString = '07' then
            PIS.CST := pis07;
          if fDMCupomFiscal.cdsTab_PisCODIGO.AsString = '08' then
            PIS.CST := pis08;
          if fDMCupomFiscal.cdsTab_PisCODIGO.AsString = '09' then
            PIS.CST := pis09;
          if fDMCupomFiscal.cdsTab_PisCODIGO.AsString = '49' then
            PIS.CST := pis49;
          if fDMCupomFiscal.cdsTab_PisCODIGO.AsString = '99' then
            PIS.CST := pis99;
          vValorTotal := 0;
          if (fDMCupomFiscal.cdsCupom_ItensPERC_PIS.AsFloat > 0) and (fDMCupomFiscal.cdsCupom_ItensVLR_PIS.AsFloat > 0) then
            vValorTotal := fDMCupomFiscal.cdsCupom_ItensVLR_TOTAL.AsFloat +
                           fDMCupomFiscal.cdsCupom_ItensVLR_DESCONTO.AsFloat +
                           fDMCupomFiscal.cdsCupom_ItensVLR_DESCONTORATEIO.AsFloat;
          PIS.vBC := vValorTotal;
          PIS.pPIS := fDMCupomFiscal.cdsCupom_ItensPERC_PIS.AsFloat;
          PIS.vPIS := fDMCupomFiscal.cdsCupom_ItensVLR_PIS.AsFloat;
          vTotTrib := fDMCupomFiscal.cdsCupom_ItensVLR_TRIBUTO.AsFloat;
        end;
      end;
      fDMCupomFiscal.cdsCupom_Itens.Next;
    end;

    //Total ICMS
    Total.ICMSTot.vProd := fDMCupomFiscal.cdsCupomFiscalVLR_PRODUTOS.AsFloat + vVlr_Desconto_NFCe;
    Total.ICMSTot.vDesc := vVlr_Desconto_NFCe;
    Total.ICMSTot.vBC := fDMCupomFiscal.cdsCupomFiscalBASE_ICMS.AsFloat;
    Total.ICMSTot.vICMS := fDMCupomFiscal.cdsCupomFiscalVLR_ICMS.AsFloat;
    Total.ICMSTot.vCOFINS := fDMCupomFiscal.cdsCupomFiscalVLR_COFINS.AsFloat;
    Total.ICMSTot.vPIS := fDMCupomFiscal.cdsCupomFiscalVLR_PIS.AsFloat;

      {Totais da NFCe}
    Total.ICMSTot.vTotTrib := fDMCupomFiscal.cdsCupomFiscalVLR_TRIBUTO.AsFloat;

    Total.ICMSTot.vBCST := 0;
    Total.ICMSTot.vST := 0;
    Total.ICMSTot.vFrete := 0;
    Total.ICMSTot.vSeg := 0;
    Total.ICMSTot.vII := 0;
    Total.ICMSTot.vIPI := 0;
    Total.ICMSTot.vOutro := 0;
    Total.ICMSTot.vNF := Total.ICMSTot.vProd - Total.ICMSTot.vDesc;

    Total.ISSQNtot.vServ := 0;
    Total.ISSQNTot.vBC := 0;
    Total.ISSQNTot.vISS := 0;
    Total.ISSQNTot.vPIS := 0;
    Total.ISSQNTot.vCOFINS := 0;
    Transp.modFrete := mfSemFrete; // NFC-e não pode ter FRETE



    if fDMCupomFiscal.cdsCupomFiscalTIPO_PGTO.AsString = 'V' then
    begin
      with pag.Add do
      begin
        Ide.indPag := ipVista;
        if fDMCupomFiscal.cdsTipoCobranca.Locate('ID',fDMCupomFiscal.cdsCupomFiscalID_TIPOCOBRANCA.AsInteger,([Locaseinsensitive])) then
        begin
          if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '01' then
            tPag := fpDinheiro
          else
          if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '02' then
            tPag := fpCheque
          else
          if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '03' then
            tPag := fpCartaoCredito
          else
          if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '04' then
            tPag := fpCartaoDebito
          else
          if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '05' then
            tPag := fpCreditoLoja
          else
          if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '06' then
            tPag := fpValeAlimentacao
          else
          if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '07' then
            tPag := fpValeRefeicao
          else
          if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '08' then
            tPag := fpValePresente
          else
          if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '99' then
            tPag := fpOutro;
        end;
        vPag := fDMCupomFiscal.cdsCupomFiscalVLR_TOTAL.AsFloat;
      end;
    end
    else
    begin
      fDMNFCe.cdsTPag.Close;
      fDMNFCe.sdsTPag.ParamByName('ID').AsInteger := fDMCupomFiscal.cdsCupomFiscalID.AsInteger;
      fDMNFCe.cdsTPag.Open;
      fDMNFCe.cdsTPag.First;
      while not fDMNFCe.cdsTPag.Eof do
      begin
        with pag.Add do
        begin
          Ide.indPag := ipPrazo;

          if fDMCupomFiscal.cdsTipoCobranca.Locate('ID',fDMCupomFiscal.cdsCupomFiscalID_TIPOCOBRANCA.AsInteger,([Locaseinsensitive])) then
          begin
            if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '01' then
              tPag := fpDinheiro
            else
            if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '02' then
              tPag := fpCheque
            else
            if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '03' then
              tPag := fpCartaoCredito
            else
            if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '04' then
              tPag := fpCartaoDebito
            else
            if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '05' then
              tPag := fpCreditoLoja
            else
            if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '06' then
              tPag := fpValeAlimentacao
            else
            if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '07' then
              tPag := fpValeRefeicao
            else
            if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '08' then
              tPag := fpValePresente
            else
            if fDMCupomFiscal.cdsTipoCobrancaCOD_IMP_FISCAL.AsString = '99' then
              tPag := fpOutro;
          end;
          vPag := fDMNFCe.cdsTPagVLR_VENCIMENTO.AsFloat;
        end;
        fDMNFCe.cdsTPag.Next;
      end;
    end;
    pag.vTroco := fDMCupomFiscal.cdsCupomFiscalVLR_TROCO.AsFloat;

    //PAGAMENTOS apenas para NFC-e

    InfAdic.infCpl := '';
    InfAdic.infAdFisco := '';
    fDMNFCe.ACBrNFe.DANFE.vTribMun := fDMCupomFiscal.cdsCupomFiscalVLR_TRIBUTO_MUNICIPAL.AsFloat;
    fDMNFCe.ACBrNFe.DANFE.vTribEst := fDMCupomFiscal.cdsCupomFiscalVLR_TRIBUTO_ESTADUAL.AsFloat;
    fDMNFCe.ACBrNFe.DANFE.vTribFed := fDMCupomFiscal.cdsCupomFiscalVLR_TRIBUTO_FEDERAL.AsFloat;

  end;

  try
    fDMNFCe.ACBrNFe.NotasFiscais.GerarNFe;
  except

  end;
  if DirectoryExists('c:\a') then
    if (fDMNFCe.ACBrNFe.NotasFiscais.Count > 0) then //and (chkGravarXml.Checked) then
      fDMNFCe.ACBrNFe.NotasFiscais[0].GravarXML('nfe.xml', 'c:\a');

end;

procedure TfNFCE_ACBR.prc_Monta_ICMS00(fDMNFCe: TDMNFCe; CodSitTrib: String);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst00;
    ICMS.modBC := dbiMargemValorAgregado;
    ICMS.vBC := fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat;
    ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
    ICMS.vICMS := fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat;
  end;
end;


procedure TfNFCE_ACBR.prc_Monta_ICMS10(fDMNFCe: TDMNFCe;
  CodSitTrib: String; Perc_Interno: Real);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst10;
    ICMS.modBC := dbiMargemValorAgregado;
    ICMS.vBC := fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat;
    ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
    ICMS.vICMS := fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat;
    ICMS.modBCST := dbisMargemValorAgregado;
    ICMS.pMVAST := 0;
    ICMS.pRedBCST := 0;
    ICMS.pICMSST := Perc_Interno;
    ICMS.vBCST := 0;
    ICMS.vICMSST := 0;
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMS20(fDMNFCe: TDMNFCe;
  CodSitTrib: String);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst20;
    ICMS.modBC := dbiMargemValorAgregado;
    ICMS.vBC := fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat;
    ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
    ICMS.vICMS := fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat;
    if fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat > 0 then
      ICMS.pRedBC := 100 - fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat;
    ICMS.vICMSDeson := 0;
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMS30(fDMNFCe: TDMNFCe;
  CodSitTrib: String; Perc_Interno: Real);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst30;
    ICMS.modBC := dbiMargemValorAgregado;
    ICMS.modBCST := dbisMargemValorAgregado;
    ICMS.pMVAST := 0;
    ICMS.pRedBCST := 0;
    ICMS.pICMSST := StrToFloat(FormatFloat('0.00##',Perc_Interno));
    ICMS.vBCST := 0;
    ICMS.vICMSST := 0;
    ICMS.vICMSDeson := 0;
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMS40(fDMNFCe: TDMNFCe;
  CodSitTrib: String);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst40;
    ICMS.vICMSDeson := 0;
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMS51(fDMNFCe: TDMNFCe;
  CodSitTrib: String);
begin
with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst51;
    ICMS.modBC := dbiMargemValorAgregado;
    if fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat > 0 then
      ICMS.pRedBC := 100 - StrToFloat(FormatFloat('0.0000',fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat));
    ICMS.vBC := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat));
    ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
    ICMS.vICMS := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat));
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMS60(fDMNFCe: TDMNFCe;
  CodSitTrib: String);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst60;
    ICMS.modBC := dbiMargemValorAgregado;
    ICMS.VBCSTRet := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMSSUBST_RET.AsFloat));
    ICMS.pST := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensPERC_ST.AsFloat));
    ICMS.vICMSSTRet := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdscupom_ItensVLR_ICMSSUBST_RET.AsFloat));
    if fDMCupomFiscal.cdsCupom_ItensVLR_ICMS_EFE.AsFloat > 0 then
    begin
      ICMS.vICMSEfet := StrToFloat(formatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS_EFE.AsFloat));
      ICMS.pRedBCEfet := StrToFloat(formatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensPERC_BASE_RED_EFET.AsFloat));
      ICMS.vBCEfet := StrToFloat(formatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_BASE_EFET.AsFloat));
      ICMS.pICMSEfet := StrToFloat(FormatFloat('0.00', fDMCupomFiscal.cdsCupom_ItensPERC_ICMS_EFET.AsFloat));
    end;
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMS70(fDMNFCe: TDMNFCe;
  CodSitTrib: String; Perc_Interno: Real);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst70;
    ICMS.modBC := dbiMargemValorAgregado;
    if fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat > 0 then
      ICMS.pRedBC := 100 - fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat;
    ICMS.vBC := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat));
    ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
    ICMS.vICMS := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat));
    ICMS.modBCST := dbisMargemValorAgregado;
    ICMS.pMVAST := 0;
    ICMS.pRedBCST := 0;
    ICMS.pICMSST := StrToFloat(FormatFloat('0.00##',Perc_Interno));
    ICMS.vBCST := 0;
    ICMS.vICMSST := 0;
    ICMS.vICMSDeson := 0;
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMS90(fDMNFCe: TDMNFCe;
  CodSitTrib: String; Perc_Interno: Real);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst90;
    ICMS.modBC := dbiMargemValorAgregado;
    if fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat > 0 then
      ICMS.pRedBC := 100 - StrToFloat(FormatFloat('0.0000',fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat));
    ICMS.vBC := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat));
    ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
    ICMS.vICMS := StrToFloat(FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat));
    ICMS.modBCST := dbisMargemValorAgregado;
    ICMS.pMVAST := 0;
    ICMS.pRedBCST := 0;
    ICMS.pICMSST := StrToFloat(FormatFloat('0.00##',Perc_Interno));
    ICMS.vBCST := 0;
    ICMS.vICMSST := 0;
    ICMS.vICMSDeson := 0;
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMSSN101(fDMNFCe: TDMNFCe;
  CodSitTrib: String; Perc_Simples: Real);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CSOSN := csosn101;
    ICMS.pCredSN := Perc_Simples;
    ICMS.VCredICMSSN := 0;
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMSSN102(fDMNFCe: TDMNFCe;
  CodSitTrib: String);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CSOSN := csosn102;
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMSSN201(fDMNFCe: TDMNFCe;
  CodSitTrib: String; Perc_Interno, Perc_Simples: Real);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CSOSN := csosn201;
    ICMS.modBCST := dbisMargemValorAgregado;
    ICMS.pMVAST := 0;
    ICMS.pRedBCST := 0;
    ICMS.pICMSST := Perc_Interno;
    ICMS.vBCST := 0;
    ICMS.vICMSST := 0;
    ICMS.pCredSN := Perc_Simples;
    ICMS.vCredICMSSN := 0
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMSSN202(fDMNFCe: TDMNFCe;
  CodSitTrib: String; Perc_Interno: Real);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CSOSN := csosn202;
    ICMS.modBCST := dbisMargemValorAgregado;
    ICMS.pMVAST := 0;
    ICMS.pRedBCST := 0;
    ICMS.pICMSST := Perc_Interno;
    ICMS.vBCST := 0;
    ICMS.vICMSST := 0;
    ICMS.vCredICMSSN := 0
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMSSN500(fDMNFCe: TDMNFCe;
  CodSitTrib: String);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CSOSN := csosn500;
    ICMS.modBCST := dbisMargemValorAgregado;
    ICMS.vBCSTRet := fDMCupomFiscal.cdsCupom_ItensBASE_ICMSSUBST_RET.AsFloat;
    ICMS.pST := fDMCupomFiscal.cdsCupom_ItensPERC_ST.AsFloat;
    ICMS.vICMSSTRet := fDMNFCe.mItensNFeVlr_ST_Ret.AsFloat + fDMCupomFiscal.cdscupom_ItensVLR_ICMSSUBST_RET.AsFloat;
    if fDMCupomFiscal.cdsCupom_ItensVLR_ICMS_EFE.AsFloat > 0 then
    begin
      ICMS.VICMSEfet := fDMCupomFiscal.cdsCupom_ItensVLR_ICMS_EFE.AsFloat;
      ICMS.vBCEfet := fDMCupomFiscal.cdsCupom_ItensVLR_BASE_EFET.AsFloat;
      ICMS.pICMSEfet := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS_EFET.AsFloat;
      ICMS.pRedBCEfet := fDMCupomFiscal.cdsCupom_ItensPERC_BASE_RED_EFET.AsFloat;
    end;
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMSSN900(fDMNFCe: TDMNFCe;
  CodSitTrib: String; Perc_Interno, Perc_Simples: Real);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CSOSN := csosn900;
    ICMS.modBCST := dbisListaPositiva;
    ICMS.vBCSTRet := fDMCupomFiscal.cdsCupom_ItensBASE_ICMSSUBST_RET.AsFloat;
    ICMS.vBC := fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat;
    if fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat > 0 then
    begin
      ICMS.pRedBC := 100 - fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat;
      if ICMS.pRedBC = 100 then
        ICMS.pRedBC := 0;
    end
    else
    begin
      if fDMCupomFiscal.cdsTab_CSTICMSPERCENTUAL.AsFloat > 0 then
        ICMS.pRedBC := 100 - fDMCupomFiscal.cdsTab_CSTICMSPERCENTUAL.AsFloat;
    end;
    ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
    ICMS.vICMS := fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat;
    ICMS.modBCST := dbisMargemValorAgregado;
    ICMS.pMVAST := 0;
    ICMS.pRedBCST := 0;
    ICMS.pICMSST := Perc_Interno;
    ICMS.vBCST := 0;
    ICMS.vICMSST := 0;
    ICMS.PCredSN := Perc_Simples;
    ICMS.VCredICMSSN := 0;
  end;
end;

procedure TfNFCE_ACBR.btEnviarNovoClick(Sender: TObject);
var
  chave, vMSGNFCe : String;
  Tentativa, RetornoStatus : Integer;
  ID: TTransactionDesc;
  sds: TSQLDataSet;
  Flag: Boolean;  
begin
  sXML := fnc_Gerar_NFCe(vID_Cupom_Novo);
  chave := copy(fDMNFCe.ACBrNFe.NotasFiscais.Items[0].NFe.infNFe.ID, (length(fDMNFCe.ACBrNFe.NotasFiscais.Items[0].NFe.infNFe.ID) - 44) + 1, 44);
  if chave = '' then
  begin
    ShowMessage('O sistema nao conseguiu gerar a Chave Eletronica! Tente Novamente');
    Exit;
  end;

  fDMNFCe.ACBrNFe.NotasFiscais.Assinar;
  Flag := True;
  try
    fDMNFCe.ACBrNFe.NotasFiscais.Validar;
  except
    on e: Exception do
    begin
      MessageDlg('Nota não Enviada ' + #13 + e.Message,mtError,[mbOK],0);
      fdmCupomFiscal.cdsCupomFiscal.Close;
      Flag := False;
    end;
  end;

  if not Flag then
    exit;

  vMSGNFCe := '';
  sds := TSQLDataSet.Create(nil);
  ID.TransactionID  := 71;
  ID.IsolationLevel := xilREADCOMMITTED;
  dmDatabase.scoDados.StartTransaction(ID);
  try
    try
      sds.SQLConnection := dmDatabase.scoDados;
      sds.NoMetadata    := True;
      sds.GetMetadata   := False;
      sds.CommandText   := ' UPDATE TABELALOC SET FLAG = 1 WHERE TABELA = ' + QuotedStr('CUPOMFISCAL');
      Flag := False;
      while not Flag do
      begin
        try
          sds.Close;
          sds.ExecSQL;
          Flag := True;
        except
          on E: Exception do
          begin
            Flag := False;
          end;
        end;
      end;
    except
      raise
    end;
    lbChaveAcesso.Caption  := chave;

    fDMNFCe.ACBrNFe.Enviar('1', False, False);
    try

    finally

    end;
    RetornoStatus := fDMNFCe.ACBrNFe.WebServices.Retorno.cStat;
    if (RetornoStatus = 302) or (RetornoStatus = 301) then
    begin
      fdmCupomFiscal.Gravar_Envio_Nota(fDMNFCe.ACBrNFe.WebServices.Retorno.Recibo,
                                       fDMNFCe.ACBrNFe.WebServices.Retorno.Protocolo,
                                       chave,
                                       1,
                                       fnc_Buscar_Finalidade,
                                       RetornoStatus,
                                       fDMNFCe.ACBrNFe.WebServices.Retorno.xMotivo);
      lbErro.Visible := (fDMCupomFiscal.cdsCupomFiscalNFEDENEGADA.AsString = 'S');
      lbErro.Caption := 'CUPOM DENEGADO: ' + fDMCupomFiscal.cdsCupomFiscalMOTIVO_DENEGADO.AsString;
      vMSGNFCe := '*** CUPOM FISCAL - DENEGADO:  ' + fDMCupomFiscal.cdsCupomFiscalMOTIVO_DENEGADO.AsString
                 +#13 + #13 + ' Verificar esta ocorrência, venda não realizada!'
    end
    else
    if (RetornoStatus = 100) then
    begin
      fdmCupomFiscal.Gravar_Envio_Nota(fDMNFCe.ACBrNFe.WebServices.Retorno.Recibo,
                                       fDMNFCe.ACBrNFe.WebServices.Retorno.Protocolo,
                                       fDMNFCe.ACBrNFe.WebServices.Retorno.ChaveNFe,
                                       1,
                                       fnc_Buscar_Finalidade,RetornoStatus,
                                       fDMNFCe.ACBrNFe.WebServices.Retorno.xMotivo);
      Tentativa := 6;
    end;
    lbRecibo.Caption       := fDMNFCe.ACBrNFe.WebServices.Retorno.Recibo;
    lbNroProtocolo.Caption := fDMNFCe.ACBrNFe.WebServices.Retorno.Protocolo;
    dmDatabase.scoDados.Commit(ID);
  except
    on e: Exception do
    begin
      dmDatabase.scoDados.Rollback(ID);
      vMSGNFCe := 'Não foi possível enviar o NFCe!' + #13 + E.Message + #13+ '  Clique para continuar!';
    end;
  end;

//  fDMNFCe.ACBrNFe.NotasFiscais.Imprimir;

  fDMNFCe.ACBrNFe.NotasFiscais.Clear;

end;

procedure TfNFCE_ACBR.Inicia_NFe;
begin

  fDMNFCe.prc_Abrir_Filial(fdmCupomFiscal.cdsCupomFiscalFILIAL.AsInteger);

{$IFDEF ACBrNFeOpenSSL}
  fDMNFCe.ACBrNFe.Configuracoes.Certificados.ArquivoPFX := fDMNFCe.qFilial_CertificadoNUMERO_SERIE.AsString;
  fDMNFCe.ACBrNFe.Configuracoes.Certificados.Certificado := fDMNFCe.qFilial_CertificadoNUMERO_SERIE.AsString;
  fDMNFCe.ACBrNFe.Configuracoes.Certificados.Senha := fDMNFCe.qFilial_CertificadoSENHA.AsString;
{$ELSE}
  fDMNFCe.ACBrNFe.Configuracoes.Certificados.NumeroSerie := fDMNFCe.qFilial_CertificadoNUMERO_SERIE.AsString;
  fDMNFCe.ACBrNFe.Configuracoes.Certificados.Senha := fDMNFCe.qFilial_CertificadoSENHA.AsString;
{$ENDIF}

  fDMNFCe.ACBrNFe.Configuracoes.Geral.IdCSC := fDMNFCe.qFilial_NFCeCLDTOKEN.AsString;
  fDMNFCe.ACBrNFe.Configuracoes.Geral.CSC := fDMNFCe.qFilial_NFCeCSC.AsString;

  fDMNFCe.ACBrNFe.Configuracoes.Geral.VersaoQRCode := veqr200;
  fDMNFCe.ACBrNFeDANFeESCPOS.ViaConsumidor := True;
  fDMNFCe.ACBrNFeDANFeESCPOS.ImprimeItens  := True;
  fDMNFCe.ACBrNFeDANFeESCPOS.QuebraLinhaEmDetalhamentos := False;
  if vModeloImpressora = 'DR700' then fDMNFCe.ACBrPosPrinter.Modelo := ppEscDaruma;
  if vModeloImpressora = 'DR800' then fDMNFCe.ACBrPosPrinter.Modelo := ppEscDaruma;
  if vModeloImpressora = 'BEMATECH' then fDMNFCe.ACBrPosPrinter.Modelo := ppEscBematech;
  if vModeloImpressora = 'EPSON' then fDMNFCe.ACBrPosPrinter.Modelo := ppEscPosEpson;
  if vModeloImpressora = 'ELGIN' then fDMNFCe.ACBrPosPrinter.Modelo := ppEscPosEpson;
  fDMNFCe.ACBrPosPrinter.Device.Porta      := vPorta;
  fDMNFCe.ACBrPosPrinter.Device.Baud       := StrToInt(vVelocidade);

  fDMNFCe.ACBrNFeDANFeESCPOS.ImprimeDescAcrescItem := True;
end;

procedure TfNFCE_ACBR.FormCreate(Sender: TObject);
begin
  fDMNFCe := TDMNFCe.Create(Self);
end;

procedure TfNFCE_ACBR.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(fDMNFCe);
end;

function TfNFCE_ACBR.fnc_Buscar_Finalidade : Integer;
var
  Tipo : tEnumAmbiente;
begin
  Tipo := tEnumAmbiente(ComboAmbiente.ItemIndex);
  Result := Ord(Tipo);
end;

procedure TfNFCE_ACBR.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = 87) then
    chkGravarXml.Visible := not(chkGravarXml.Visible);
end;

end.

