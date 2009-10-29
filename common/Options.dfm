object FormCalculatorOptions: TFormCalculatorOptions
  Left = 290
  Top = 70
  BorderStyle = bsToolWindow
  Caption = 'Options'
  ClientHeight = 211
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object FormOptionsPages: TPageControl
    Left = 0
    Top = 0
    Width = 334
    Height = 180
    ActivePage = OptionsGeneral
    Align = alClient
    HotTrack = True
    TabOrder = 0
    object OptionsGeneral: TTabSheet
      Caption = '&General'
      object OptionShowIntro: TCheckBox
        Left = 8
        Top = 8
        Width = 113
        Height = 17
        Caption = 'Show &Intro Splash'
        TabOrder = 0
      end
      object OptionSaveSettings: TCheckBox
        Left = 8
        Top = 24
        Width = 241
        Height = 17
        Caption = '&Save Settings on Exit'
        TabOrder = 1
      end
      object OptionScreenLimits: TCheckBox
        Left = 8
        Top = 40
        Width = 241
        Height = 17
        Caption = '&Constraint Screen Limits'
        TabOrder = 2
      end
      object OptionDisableActiveButtons: TCheckBox
        Left = 8
        Top = 56
        Width = 241
        Height = 17
        Caption = '&Disable Active Buttons'
        TabOrder = 3
      end
    end
    object OptionsCalculator: TTabSheet
      Caption = '&Calculator'
      ImageIndex = 1
      object OptionDirectMode: TCheckBox
        Left = 8
        Top = 8
        Width = 241
        Height = 17
        Caption = '&Direct Mode Calculation'
        TabOrder = 0
      end
    end
    object OptionSystem: TTabSheet
      Caption = '&System'
      ImageIndex = 3
      object SystemUsageLabel: TLabel
        Left = 0
        Top = 57
        Width = 68
        Height = 13
        Align = alClient
        Alignment = taCenter
        Caption = 'System Usage'
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 326
        Height = 57
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel1'
        TabOrder = 0
        object Image1: TImage
          Left = 0
          Top = 0
          Width = 33
          Height = 57
          Align = alLeft
          Picture.Data = {
            055449636F6E0000010001002020100000000000E80200001600000028000000
            2000000040000000010004000000000080020000000000000000000000000000
            0000000000000000000080000080000000808000800000008000800080800000
            80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
            FFFFFF0000000000000000000000000000000000000000000000007777770000
            0000000000000000000000000007000000000000000000000000000000070000
            0000000000000000000000777007000000000000000000077070007770070000
            7000000000000077000700787000000007000000000007708000077877000070
            00700000000007088807777777770777000700000000008F88877FFFFF077887
            70070000000000088888F88888FF08870070000000000000880888877778F070
            00700000000777088888880007778F770077777000700008F088007777077F07
            000000700700008F08880800077778F7700000700708888F0880F08F807078F7
            777700700708F88F0780F070F07078F7887700700708888F0780F077807088F7
            777700700700008F0788FF00080888F77000007000000008F0780FFFF0088F77
            0070000000000008F07788000888887700700000000000008F07788888880870
            00700000000000088FF0077788088887000700000000008F888FF00000F87887
            7007000000000708F8088FFFFF88078700700000000007708000088888000070
            0700000000000077007000888007000070000000000000077700008F80070007
            0000000000000000000000888007000000000000000000000000000000070000
            0000000000000000000007777777000000000000000000000000000000000000
            00000000FFFFFFFFFFFC0FFFFFFC0FFFFFF80FFFFFF80FFFFE180E7FFC00043F
            F800001FF800000FF800000FFC00001FFE00001FE0000001C000000180000001
            80000001800000018000000180000001FC00001FFC00001FFE00001FFC00000F
            F800000FF800001FF800003FFC180C7FFE380EFFFFF80FFFFFF80FFFFFF80FFF
            FFFFFFFF}
        end
        object ExCalcSystemLabel: TStaticText
          Left = 33
          Top = 0
          Width = 129
          Height = 19
          Align = alClient
          Alignment = taCenter
          Caption = 'Expression Calculator'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object StaticText1: TStaticText
        Left = 0
        Top = 134
        Width = 137
        Height = 18
        Align = alBottom
        Alignment = taCenter
        Caption = 'http://www.vestris.com/'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
    end
    object OptionsAboutPage: TTabSheet
      Caption = 'Cop&yright'
      ImageIndex = 2
      object CopyrightNotice: TLabel
        Left = 0
        Top = 0
        Width = 78
        Height = 13
        Align = alClient
        Caption = 'Copyright Notice'
        WordWrap = True
      end
      object AboutExcalcLabel: TStaticText
        Left = 0
        Top = 116
        Width = 264
        Height = 18
        Align = alBottom
        Alignment = taCenter
        Caption = '(c) Vestris Inc. - 1994-2001 - All Rights Reserved'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object VestrisComUrl: TStaticText
        Left = 0
        Top = 134
        Width = 137
        Height = 18
        Align = alBottom
        Alignment = taCenter
        Caption = 'http://www.vestris.com/'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
    end
  end
  object FormOptionsCmdPanel: TPanel
    Left = 0
    Top = 180
    Width = 334
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object ButtonOk: TBitBtn
      Left = 256
      Top = 4
      Width = 75
      Height = 25
      TabOrder = 0
      OnClick = ButtonOkClick
      Kind = bkOK
    end
    object ButtonCancel: TBitBtn
      Left = 178
      Top = 4
      Width = 75
      Height = 25
      TabOrder = 1
      OnClick = ButtonCancelClick
      Kind = bkCancel
    end
  end
end
