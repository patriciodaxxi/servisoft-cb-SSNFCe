object fNFCE_ACBR: TfNFCE_ACBR
  Left = 317
  Top = 228
  Width = 979
  Height = 563
  Caption = 'Cupom Eletr'#244'nico'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 963
    Height = 73
    Align = alTop
    TabOrder = 0
    object Label2: TLabel
      Left = 72
      Top = 41
      Width = 47
      Height = 13
      Caption = 'Ambiente:'
    end
    object ComboAmbiente: TComboBox
      Left = 123
      Top = 33
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 0
      Text = 'Produ'#231#227'o'
      Items.Strings = (
        'Produ'#231#227'o'
        'Homologa'#231#227'o')
    end
  end
  object pnlPrincipal: TPanel
    Left = 0
    Top = 73
    Width = 963
    Height = 410
    Align = alClient
    TabOrder = 1
    object RzPageControl1: TRzPageControl
      Left = 1
      Top = 1
      Width = 961
      Height = 408
      ActivePage = TabSheet1
      Align = alClient
      TabIndex = 0
      TabOrder = 0
      FixedDimension = 19
      object TabSheet1: TRzTabSheet
        Caption = 'Principal'
        object GroupBox1: TGroupBox
          Left = 0
          Top = 0
          Width = 957
          Height = 72
          Align = alTop
          Caption = 'Envio'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object Label6: TLabel
            Left = 51
            Top = 14
            Width = 45
            Height = 13
            Alignment = taRightJustify
            Caption = 'Recibo:'
          end
          object Label7: TLabel
            Left = 9
            Top = 30
            Width = 87
            Height = 13
            Alignment = taRightJustify
            Caption = 'Nro. Protocolo:'
          end
          object Label8: TLabel
            Left = 10
            Top = 46
            Width = 86
            Height = 13
            Alignment = taRightJustify
            Caption = 'Chave Acesso:'
          end
          object lbRecibo: TLabel
            Left = 98
            Top = 14
            Width = 352
            Height = 13
            AutoSize = False
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object lbNroProtocolo: TLabel
            Left = 98
            Top = 30
            Width = 352
            Height = 13
            AutoSize = False
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object lbChaveAcesso: TLabel
            Left = 98
            Top = 46
            Width = 352
            Height = 13
            AutoSize = False
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentColor = False
            ParentFont = False
          end
          object btDanfe: TButton
            Left = 623
            Top = 14
            Width = 89
            Height = 50
            Caption = '&DANFE'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object btEnviarNovo: TButton
            Left = 532
            Top = 14
            Width = 89
            Height = 50
            Caption = 'Enviar Novo'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
          end
        end
        object GroupBox2: TGroupBox
          Left = 0
          Top = 72
          Width = 957
          Height = 48
          Align = alTop
          Caption = 'Cancelamento'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          object Label10: TLabel
            Left = 9
            Top = 16
            Width = 87
            Height = 13
            Alignment = taRightJustify
            Caption = 'Nro. Protocolo:'
          end
          object lbNroProtocoloCancelamento: TLabel
            Left = 100
            Top = 14
            Width = 413
            Height = 13
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object btCancelar: TBitBtn
            Left = 532
            Top = 9
            Width = 89
            Height = 36
            Caption = 'Cancelar'
            Enabled = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clRed
            Font.Height = -13
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
          end
        end
      end
    end
  end
  object pnlBotton: TPanel
    Left = 0
    Top = 483
    Width = 963
    Height = 41
    Align = alBottom
    TabOrder = 2
  end
end
