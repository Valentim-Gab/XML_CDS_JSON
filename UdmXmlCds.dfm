object Form1: TForm1
  Left = 1916
  Top = 76
  Width = 292
  Height = 276
  Caption = 'XML to CDS'
  Color = 8388672
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 200
    Width = 129
    Height = 25
    Caption = 'Show XML in Memo'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 257
    Height = 185
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Button2: TButton
    Left = 144
    Top = 200
    Width = 121
    Height = 25
    Caption = 'Save in JSON'
    TabOrder = 2
    OnClick = Button2Click
  end
  object OpenDialog1: TOpenDialog
    Left = 232
    Top = 168
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.json'
    Filter = 'Arquivo JSON|*.json'
    Left = 200
    Top = 168
  end
end
