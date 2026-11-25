object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Form1'
  ClientHeight = 667
  ClientWidth = 926
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Chart1: TChart
    Left = 30
    Top = 24
    Width = 888
    Height = 306
    Title.Text.Strings = (
      'Signal')
    BottomAxis.Title.Caption = 'Sample Index (n)'
    DepthAxis.Title.Caption = ''
    LeftAxis.Title.Caption = 'Amplitude (V)'
    View3D = False
    View3DWalls = False
    TabOrder = 0
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      25
      15
      25)
    ColorPaletteIndex = 13
    object Series1: TLineSeries
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object RadioGroup1: TRadioGroup
    Left = 41
    Top = 0
    Width = 289
    Height = 41
    Caption = 'Signals'
    Columns = 3
    Items.Strings = (
      'X+Y'
      'ECG'
      'ECG + Noise')
    TabOrder = 1
  end
  object Chart2: TChart
    Left = 30
    Top = 346
    Width = 888
    Height = 313
    Title.Text.Strings = (
      'DFT Spectrum')
    BottomAxis.Title.Caption = 'Frequency (Hz)'
    DepthAxis.Title.Caption = ''
    LeftAxis.Title.Caption = 'Magnitude (V)'
    View3D = False
    View3DWalls = False
    TabOrder = 2
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      25
      15
      25)
    ColorPaletteIndex = 13
    object Series2: TBarSeries
      Marks.Visible = False
      Marks.OnTop = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object Button1: TButton
    Left = 51
    Top = 336
    Width = 75
    Height = 35
    Caption = 'DFT'
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 809
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Plot'
    TabOrder = 4
    OnClick = Button2Click
  end
end
