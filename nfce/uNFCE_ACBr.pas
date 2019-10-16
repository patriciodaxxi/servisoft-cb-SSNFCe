unit uNFCE_ACBr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzTabs, Buttons, StdCtrls, UDMNFCe, uDmParametros,
  uDmCupomFiscal, ACBrDFeUtil, pcnConversao, pcnConversaoNFe;

type
  tEnumAmbiente = (tpProducao, tpHomologacao);

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
  private
    { Private declarations }
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

  public
    fDMNFCe: TDMNFCe;
    fdmCupomFiscal: TdmCupomFiscal;
    function fnc_Gerar_NFCe(ID: Integer): string;

    { Public declarations }
  end;

var
  fNFCE_ACBR: TfNFCE_ACBR;

implementation

uses DB, uUtilPadrao, pcnNFe;

{$R *.dfm}

{ TfNFCE_ACBR }

function TfNFCE_ACBR.fnc_Gerar_NFCe(ID: Integer): string;
var
  vQtdeRegistros, vTipo_Ambiente_NFe, vItemNFe : Integer;
  vCodCST : String;
  vPerc_Interno: Real;
  vValorTotal : Real; 
begin
  fDMNFCe.ACBrNFe.DANFE.vTribFed := 0;
  fDMNFCe.ACBrNFe.DANFE.vTribEst := 0;
  fDMNFCe.ACBrNFe.DANFE.vTribMun := 0;
  vItemNFe := 0;

  case TEnumAmbiente(ComboAmbiente.ItemIndex) of
    tpProducao : vTipo_Ambiente_NFe := 1;
    tpHomologacao : vTipo_Ambiente_NFe := 2;
  end;

  fDMNFCe.ACBrNFe.NotasFiscais.Clear;
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe do
  begin
    Ide.cNF := GerarCodigoDFe(fDMCupomFiscal.cdsCupomFiscalNUMCUPOM.AsInteger);
    Ide.natOp := fDMCupomFiscal.vDescricao_Operacao;
    Ide.modelo := 65;
    Ide.serie := fdmCupomFiscal.cdsCupomFiscalSERIE.AsInteger;
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
    if fDMCupomFiscal.cdsPessoaPESSOA.AsString = 'F' then
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
        Prod.NCM   := Replace(fDMNFCe.mItensNFeClasFiscal.AsString,'.','');
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

        if ((trim(fDMNFCe.qProdutoCOD_CEST.AsString)) <> EmptyStr) then
          Prod.CEST := fDMNFCe.qProdutoCOD_CEST.AsString;

        {CEST CODIGO}
        if (trim(fDMCupomFiscal.cdsTab_NCMCOD_CEST.AsString) <> EmptyStr) and (Prod.CEST = EmptyStr) then
          Prod.CEST := fDMCupomFiscal.cdsTab_NCMCOD_CEST.AsString;

        with Imposto do
        begin
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
            prc_Monta_ICMS00(fDMNFCe,vCodCST)
          else
          if vCodCST = '10' then
            prc_Monta_ICMS10(fDMNFCe,vCodCST,vPerc_Interno)
          else
          if vCodCST = '20' then
            prc_Monta_ICMS20(fDMNFCe,vCodCST)
          else
          if vCodCST = '30' then
            prc_Monta_ICMS30(fDMNFCe,vCodCST,vPerc_Interno)
          else
          if (vCodCST = '40') or (vCodCST = '41') or (vCodCST = '50') then
            prc_Monta_ICMS40(fDMNFCe,vCodCST)
          else
          if (vCodCST = '51') then
            prc_Monta_ICMS51(fDMNFCe,vCodCST)
          else
          if (vCodCST = '60') then
            prc_Monta_ICMS60(fDMNFCe,vCodCST)
          else
          if (vCodCST = '70') then
            prc_Monta_ICMS70(fDMNFCe,vCodCST,vPerc_Interno)
          else
          if (vCodCST = '90') then
            prc_Monta_ICMS90(fDMNFCe,vCodCST,vPerc_Interno)
          else
          if (vCodCST = '101') then
            prc_Monta_ICMSSN101(fDMNFCe,vCodCST,0)
          else
          if (vCodCST = '102') or (vCodCST = '103') or (vCodCST = '300') or (vCodCST = '400') then
            prc_Monta_ICMSSN102(fDMNFCe,vCodCST)
          else
          if vCodCST = '201' then
            prc_Monta_ICMSSN201(fDMNFCe,vCodCST,vPerc_Interno,0)
          else
          if (vCodCST = '202') or (vCodCST = '203') then
            prc_Monta_ICMSSN202(fDMNFCe,vCodCST,vPerc_Interno)
          else
          if vCodCST = '500' then
            prc_Monta_ICMSSN500(fDMNFCe,vCodCST)
          else
          if vCodCST = '900' then
            prc_Monta_ICMSSN900(fDMNFCe,vCodCST,vPerc_Interno,0);

          //Cofins
          fDMCupomFiscal.cdsTab_Pis.FindKey([fDMCupomFiscal.cdsCupom_ItensID_PIS.AsInteger]);
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
            vValorTotal := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_TOTAL.AsFloat +
                                              fDMCupomFiscal.cdsCupom_ItensVLR_DESCONTO.AsFloat +
                                              fDMCupomFiscal.cdsCupom_ItensVLR_DESCONTORATEIO.AsFloat);
          COFINS.vBC := vValorTotal;
          COFINS.pCOFINS := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensPERC_COFINS.AsFloat);
          COFINS.vCOFINS := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_COFINS.AsFloat);

          //Pis
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
            vValorTotal := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_TOTAL.AsFloat +
                                              fDMCupomFiscal.cdsCupom_ItensVLR_DESCONTO.AsFloat +
                                              fDMCupomFiscal.cdsCupom_ItensVLR_DESCONTORATEIO.AsFloat);
          PIS.vBC := vValorTotal;
          PIS.pPIS := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensPERC_PIS.AsFloat);
          PIS.vPIS := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_PIS.AsFloat);

        end;
      end;
      SQLImpressaoCupom.next;
    end;

    //Total ICMS
    Total.ICMSTot.vDesc := TotalDesconto;
    Total.ICMSTot.vBC := FormatFloat('0.00',fDMCupomFiscal.cdsCupomFiscalBASE_ICMS.AsFloat);
    Total.ICMSTot.vICMS := FormatFloat('0.00',fDMCupomFiscal.cdsCupomFiscalVLR_ICMS.AsFloat);
    Total.ICMSTot.vCOFINS := FormatFloat('0.00',fDMCupomFiscal.cdsCupomFiscalVLR_PIS.AsFloat);
    Total.ICMSTot.vPIS := Total.ICMSTot.vPIS + pis.vPIS;

      {Totais da NFCe}
    Total.ICMSTot.vTotTrib := Total_vTotTrib;

    SQLImpressaoCupom.Close;
    SQLImpressaoCupom.RequestLive := False;
    SQLImpressaoCupom.SQL.Clear;
    SQLImpressaoCupom.SQL.Add('Select * From CUPOM Where CUPOA13ID = ''' + idCupom + '''');
    SQLImpressaoCupom.Open;

    Total.ICMSTot.vBCST := 0;
    Total.ICMSTot.vST := 0;
    Total.ICMSTot.vFrete := 0;
    Total.ICMSTot.vSeg := 0;
    Total.ICMSTot.vII := 0;
    Total.ICMSTot.vIPI := 0;
//    Total.ICMSTot.vPIS := 0;
//    Total.ICMSTot.vCOFINS := 0;
    Total.ICMSTot.vOutro := 0;
 //    Total.ICMSTot.vOutro  := SQLImpressaoCupom.fieldbyname('CUPON2ACRESC').AsFloat; // adilson removi pq os cliente nao querem o acrescimo no cupom
    Total.ICMSTot.vNF := Total.ICMSTot.vProd - Total.ICMSTot.vDesc;

    Total.ISSQNtot.vServ := 0;
    Total.ISSQNTot.vBC := 0;
    Total.ISSQNTot.vISS := 0;
    Total.ISSQNTot.vPIS := 0;
    Total.ISSQNTot.vCOFINS := 0;

    Transp.modFrete := mfSemFrete; // NFC-e não pode ter FRETE
    if (SQLParcelasPrazoVendaTemp.Active) and (SQLParcelasPrazoVendaTemp.RecordCount > 1) then
    begin
      SQLParcelasPrazoVendaTemp.First;
      while not SQLParcelasPrazoVendaTemp.eof do
      begin
        with pag.Add do
        begin
          Ide.indPag := ipPrazo;

          if SQLParcelasPrazoVendaTempTIPOPADR.AsString = 'CRD' then
            tPag := fpCartaoCredito
          else if SQLParcelasPrazoVendaTempTIPOPADR.AsString = 'CHQV' then
            tPag := fpCheque
          else
            tPag := fpCartaoCredito;

          vPag := SQLParcelasPrazoVendaTempVALORVENCTO.AsFloat;
          SQLParcelasPrazoVendaTemp.Next;
        end;
      end;
    end
    else
      with ExecSql(' select a.CTRCN2VLR, a.ctrca5tipopadrao, b.numecvistaprazo from CONTASRECEBER A LEFT JOIN Numerario B ON B.numeicod = A.numeicod ' + ' where CUPOA13ID = ' + QuotedStr(idCupom) + ' union all select cpnmn2vlr, ''DIN'', ''V'' from cupomnumerario where cupoa13id = ' + QuotedStr(idCupom)) do
      begin
        if IsEmpty then
        begin
          with pag.Add do
          begin
            if (SQLImpressaoCupom.fieldbyname('CUPOCTIPOPADRAO').AsString = 'VISTA') or (SQLImpressaoCupom.fieldbyname('CUPOCTIPOPADRAO').AsString = 'DIN') then
            begin
              Ide.indPag := ipVista;
              tPag := fpDinheiro;
            end;
            if SQLImpressaoCupom.fieldbyname('CUPOCTIPOPADRAO').AsString = 'CRT' then
            begin
              Ide.indPag := ipPrazo;
              tPag := fpCartaoCredito;
            end;
            if (SQLImpressaoCupom.fieldbyname('CUPOCTIPOPADRAO').AsString = 'CRTF') or (SQLImpressaoCupom.fieldbyname('CUPOCTIPOPADRAO').AsString = 'CRD') then
            begin
              Ide.indPag := ipPrazo;
              tPag := fpCreditoLoja;
            end;
            if (SQLImpressaoCupom.fieldbyname('CUPOCTIPOPADRAO').AsString = 'CHQV') or (SQLImpressaoCupom.fieldbyname('CUPOCTIPOPADRAO').AsString = 'CHQP') then
            begin
              Ide.indPag := ipPrazo;
              tPag := fpCheque;
            end;
            vPag := Total.ICMSTot.vNF;
          end;
        end
        else
        begin
          while not eof do
          begin
            with pag.Add do
            begin
              Ide.indPag := ipPrazo;
              if fieldbyname('ctrca5tipopadrao').AsString = 'DIN' then
                tPag := fpDinheiro
              else if fieldbyname('ctrca5tipopadrao').AsString = 'CRT' then
              begin
                if fieldbyname('numecvistaprazo').AsString = 'P' then
                  tPag := fpCartaoCredito
                else
                  tPag := fpCartaoDebito
              end
              else if fieldbyname('ctrca5tipopadrao').AsString = 'CRD' then
                tPag := fpOutro
              else if fieldbyname('ctrca5tipopadrao').AsString = 'CHQV' then
                tPag := fpCheque
              else
                tPag := fpOutro;
                 //Tirei pq quando era pago com dois tipos de pagamento a tag vpag ficava com o mesmo valor
              vCont := RecordCount;
              VarValorRecebido := SQLImpressaoCupom.fieldbyname('CUPON2TOTITENS').AsFloat + SQLImpressaoCupom.fieldbyname('TROCO').AsFloat - SQLImpressaoCupom.fieldbyname('CUPON3BONUSTROCA').AsFloat;
//                  if (VarValorRecebido > 0) and (vCont = 1) then
              if (VarValorRecebido <> fieldbyname('CTRCN2VLR').AsFloat) and (vCont = 1) then
                vPag := SQLImpressaoCupom.fieldbyname('CUPON2TOTITENS').AsFloat + SQLImpressaoCupom.fieldbyname('TROCO').AsFloat - SQLImpressaoCupom.fieldbyname('CUPON2DESC').AsFloat - SQLImpressaoCupom.fieldbyname('CUPON3BONUSTROCA').AsFloat
              else
                vPag := fieldbyname('CTRCN2VLR').AsFloat;
              if VlrTroco > 0 then
                pag.vTroco := VlrTroco;
            end;
            next;
          end;
        end;
      end;

    //PAGAMENTOS apenas para NFC-e
    SQLImpressaoCupomFinanceiro.Close;

    InfAdic.infCpl := '';
    InfAdic.infAdFisco := '';
      {Dados do Cliente}
    if SQLImpressaoCupom.fieldbyname('CLIENTENOME').AsString <> '' then
      InfAdic.infCpl := InfAdic.infCpl + SQLImpressaoCupom.fieldbyname('CLIENTENOME').AsString + ', ';
    if SQLImpressaoCupom.fieldbyname('CLIENTECNPJ').AsString <> '' then
      InfAdic.infCpl := InfAdic.infCpl + SQLImpressaoCupom.fieldbyname('CLIENTECNPJ').AsString + ', ';
    if SQLImpressaoCupom.fieldbyname('CLIENTEFONE').AsString <> '' then
      InfAdic.infCpl := InfAdic.infCpl + SQLImpressaoCupom.fieldbyname('CLIENTEFONE').AsString + ', ';
    if SQLImpressaoCupom.fieldbyname('CLIENTECIDA').AsString <> '' then
      InfAdic.infCpl := InfAdic.infCpl + SQLImpressaoCupom.fieldbyname('CLIENTECIDA').AsString + ', ';
    if SQLImpressaoCupom.fieldbyname('CLIENTEENDE').AsString <> '' then
      InfAdic.infCpl := InfAdic.infCpl + SQLImpressaoCupom.fieldbyname('CLIENTEENDE').AsString + ', ';
    if SQLImpressaoCupom.fieldbyname('CLIENTEBAIRRO').AsString <> '' then
      InfAdic.infCpl := InfAdic.infCpl + SQLImpressaoCupom.fieldbyname('CLIENTEBAIRRO').AsString;
    if SQLImpressaoCupom.fieldbyname('VENDICOD').AsString <> '' then
      InfAdic.infCpl := InfAdic.infCpl + #13 + 'Vendedor: ' + SQLLocate('VENDEDOR', 'VENDICOD', 'VENDA60NOME', SQLImpressaoCupom.fieldbyname('VENDICOD').AsString);
      CalcularImpostos

    if Obs_Venda <> '' then
      InfAdic.infCpl := InfAdic.infCpl + #13 + Obs_Venda;

      // Gerar XML
    SQLImpressaoCupom.Close;
    try
      dm.ACBrNFe.NotasFiscais.GerarNFe;
    except

    end;

    if DirectoryExists('c:\temp') then
      if dm.ACBrNFe.NotasFiscais.Count > 0 then
        dm.ACBrNFe.NotasFiscais[0].GravarXML('nfe.xml', 'c:\temp');

    if (FileExists('COMUNICACAO_OFFLINE.TXT')) then //or (Imprimir_Nfce) then
      dm.ACBrNFe.NotasFiscais.Imprimir;
  end;

end;

procedure TfNFCE_ACBR.prc_Monta_ICMS00(fDMNFCe: TDMNFCe; CodSitTrib: String);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst00;
    ICMS.modBC := '0'
    ICMS.vBC := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat);
    ICMS.pICMS := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat);
    ICMS.vICMS := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat);
  end;
end;


procedure TfNFCE_ACBR.prc_Monta_ICMS10(fDMNFCe: TDMNFCe;
  CodSitTrib: String; Perc_Interno: Real);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst10;
    ICMS.modBC := '0'
    ICMS.vBC := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat);
    ICMS.pICMS := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat);
    ICMS.vICMS := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat);
    ICMS.modBCST := dbisMargemValorAgregado;
    ICMS.pMVAST := 0;
    ICMS.pRedBCST := 0;
    ICMS.pICMSST := FormatFloat('0.00##',Perc_Interno);
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
    ICMS.modBC := '0'
    ICMS.vBC := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat);
    ICMS.pICMS := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat);
    ICMS.vICMS := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat);
    if fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat > 0 then
      ICMS.pRedBC := 100 - StrToFloat(FormatFloat('0.0000',fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat));
    ICMS.vICMSDeson := 0;
    ICMS.motDesICMS := 0;
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMS30(fDMNFCe: TDMNFCe;
  CodSitTrib: String; Perc_Interno: Real);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst30;
    ICMS.modBC := '0';
    ICMS.modBCST := dbisMargemValorAgregado;
    ICMS.pMVAST := 0;
    ICMS.pRedBCST := 0;
    ICMS.pICMSST := FormatFloat('0.00##',Perc_Interno);
    ICMS.vBCST := 0;
    ICMS.vICMSST := 0;
    ICMS.vICMSDeson := 0;
    ICMS.motDesICMS := 0;
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMS40(fDMNFCe: TDMNFCe;
  CodSitTrib: String);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst40;
    ICMS.vICMSDeson := 0;
    ICMS.motDesICMS := 0;
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMS51(fDMNFCe: TDMNFCe;
  CodSitTrib: String);
begin
with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst51;
    ICMS.modBC := '0';
    if fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat > 0 then
      ICMS.pRedBC := 100 - StrToFloat(FormatFloat('0.0000',fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat));
    ICMS.vBC := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat);
    ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
    ICMS.vICMS := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat);
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMS60(fDMNFCe: TDMNFCe;
  CodSitTrib: String);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst60;
    ICMS.modBC := '0';
    ICMS.VBCSTRet := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMSSUBST_RET.AsFloat);
    ICMS.pST := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensPERC_ST.AsFloat);
    ICMS.vICMSSTRet := FormatFloat('0.00',fDMCupomFiscal.cdscupom_ItensVLR_ICMSSUBST_RET.AsFloat);
    if fDMCupomFiscal.cdsCupom_ItensVLR_ICMS_EFE.AsFloat > 0 then
    begin
      ICMS.vICMSEfet := formatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS_EFE.AsFloat);
      ICMS.pRedBCEfet := formatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensPERC_BASE_RED_EFET.AsFloat);
      ICMS.vBCEfet := formatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_BASE_EFET.AsFloat);
      ICMS.pICMSEfet := FormatFloat('0.00', fDMCupomFiscal.cdsCupom_ItensPERC_ICMS_EFET.AsFloat);
    end;
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMS70(fDMNFCe: TDMNFCe;
  CodSitTrib: String; Perc_Interno: Real);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst70;
    ICMS.modBC := '0';
    if fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat > 0 then
      ICMS.pRedBC := 100 - StrToFloat(FormatFloat('0.0000',fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat));
    ICMS.vBC := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat);
    ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
    ICMS.vICMS := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat);
    ICMS.modBCST := dbisMargemValorAgregado;
    ICMS.pMVAST := 0;
    ICMS.pRedBCST := 0;
    ICMS.pICMSST := FormatFloat('0.00##',Perc_Interno);
    ICMS.vBCST := 0;
    ICMS.vICMSST := 0;
    ICMS.vICMSDeson := 0;
    ICMS.motDesICMS := 0;
  end;
end;

procedure TfNFCE_ACBR.prc_Monta_ICMS90(fDMNFCe: TDMNFCe;
  CodSitTrib: String; Perc_Interno: Real);
begin
  with fDMNFCe.ACBrNFe.NotasFiscais.Add.NFe.Det.Add.Imposto do
  begin
    ICMS.CST := cst90;
    ICMS.modBC := '0';
    if fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat > 0 then
      ICMS.pRedBC := 100 - StrToFloat(FormatFloat('0.0000',fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat));
    ICMS.vBC := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat);
    ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
    ICMS.vICMS := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat);
    ICMS.modBCST := dbisMargemValorAgregado;
    ICMS.pMVAST := 0;
    ICMS.pRedBCST := 0;
    ICMS.pICMSST := FormatFloat('0.00##',Perc_Interno);
    ICMS.vBCST := 0;
    ICMS.vICMSST := 0;
    ICMS.vICMSDeson := 0;
    ICMS.motDesICMS := 0;
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
    ICMS.pICMSST := FormatFloat('0.00##',Perc_Interno);
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
    ICMS.pICMSST := FormatFloat('0.00##',Perc_Interno);
    ICMS.vBCST := 0;
    ICMS.vICMSST := 0;
    ICMS.pCredSN := Perc_Simples;
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
    ICMS.vBCSTRet := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMSSUBST_RET.AsFloat);
    ICMS.pST := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensPERC_ST.AsFloat);
    ICMS.vICMSSTRet := FormatFloat('0.00',fDMNFCe.mItensNFeVlr_ST_Ret.AsFloat + fDMCupomFiscal.cdscupom_ItensVLR_ICMSSUBST_RET.AsFloat);
    if fDMCupomFiscal.cdsCupom_ItensVLR_ICMS_EFE.AsFloat > 0 then
    begin
      ICMS.VICMSEfet := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS_EFE.AsFloat);
      ICMS.vBCEfet := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_BASE_EFET.AsFloat);
      ICMS.pICMSEfet := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensPERC_ICMS_EFET.AsFloat);
      ICMS.pRedBCEfet := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensPERC_BASE_RED_EFET.AsFloat);
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
    ICMS.vBCSTRet := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMSSUBST_RET.AsFloat);
    ICMS.vBC := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensBASE_ICMS.AsFloat);
    if fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat > 0 then
    begin
      ICMS.pRedBC := 100 - FormatFloat('0.0000',fDMCupomFiscal.cdsCupom_ItensPERC_TRIBICMS.AsFloat);
      if ICMS.pRedBC = 100 then
        ICMS.pRedBC := 0;
    end
    else
    begin
      if FormatFloat('0.00',fDMCupomFiscal.cdsTab_CSTICMSPERCENTUAL.AsFloat) > 0 then
        ICMS.pRedBC := 100 - FormatFloat('0.0000',fDMCupomFiscal.cdsTab_CSTICMSPERCENTUAL.AsFloat);
    end;
    ICMS.pICMS := fDMCupomFiscal.cdsCupom_ItensPERC_ICMS.AsFloat;
    ICMS.vICMS := FormatFloat('0.00',fDMCupomFiscal.cdsCupom_ItensVLR_ICMS.AsFloat);
    ICMS.modBCST := dbisMargemValorAgregado;
    ICMS.pMVAST := 0;
    ICMS.pRedBCST := 0;
    ICMS.pICMSST := FormatFloat('0.00##',Perc_Interno);
    ICMS.vBCST := 0;
    ICMS.vICMSST := 0;
    ICMS.PCredSN := Perc_Simples;
    ICMS.VCredICMSSN := 0;

  end;
end;

end.

