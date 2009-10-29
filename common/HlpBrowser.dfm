object HtmlHelp: THtmlHelp
  Left = 361
  Top = 184
  Width = 783
  Height = 540
  BorderStyle = bsSizeToolWin
  Caption = 'Expression Calculator HTML Help'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object HtmlHelpBrowser: TWebBrowser
    Left = 0
    Top = 29
    Width = 775
    Height = 465
    Align = alClient
    TabOrder = 0
    OnDownloadBegin = HtmlHelpBrowserDownloadBegin
    OnDownloadComplete = HtmlHelpBrowserDownloadComplete
    OnBeforeNavigate2 = HtmlHelpBrowserBeforeNavigate2
    OnDocumentComplete = HtmlHelpBrowserDocumentComplete
    ControlData = {
      4C000000195000000F3000000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126209000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object BrowserBar: TToolBar
    Left = 0
    Top = 0
    Width = 775
    Height = 29
    Images = BrowserImages
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    object ToolButton1: TToolButton
      Left = 0
      Top = 2
      Hint = 'Index'
      Caption = 'ToolButton1'
      ImageIndex = 2
      OnClick = ToolButton1Click
    end
    object ToolButton2: TToolButton
      Left = 23
      Top = 2
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object btnBack: TToolButton
      Left = 31
      Top = 2
      Hint = 'Back'
      Caption = 'btnBack'
      ImageIndex = 0
      OnClick = btnBackClick
    end
    object btnForward: TToolButton
      Left = 54
      Top = 2
      Hint = 'Forward'
      Caption = 'btnForward'
      ImageIndex = 1
      OnClick = btnForwardClick
    end
  end
  object HtmlHelpStatus: TStatusBar
    Left = 0
    Top = 494
    Width = 775
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object BrowserImages: TImageList
    Left = 8
    Top = 40
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000077777700555555005555550055555500555555005555
      5500555555005555550055555500555555000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000404
      0400CC330000CC33000077777700E3E3E300D6E7E700D6E7E700D6E7E700E3E3
      E300E3E3E300D6E7E700D6E7E700555555000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000006600000099
      330000993300FF33330077777700EAEAEA00F0FBFF00EAEAEA00F0FBFF00F0FB
      FF00E3E3E300E3E3E300D6E7E700555555000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000099330033CC330033CC
      330033CC33000099330077777700EAEAEA00F0FBFF00F0FBFF00EAEAEA00EAEA
      EA00F0FBFF00E3E3E300D6E7E700555555000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0008080800000000000000000000000
      0000000000000000000000000000000000000000000066FF330066FF330033CC
      330033CC33000099330077777700F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00EAEAEA00D6E7E700D6E7E700555555000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C0008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000C0C0C000C0C0C00080808000000000000000
      00000000000000000000000000000000000033CC3300CCFFCC0066FF330066FF
      330033CC33000099330077777700F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00EAEAEA00EAEAEA00D6E7E700555555000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C00080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000808080000000
      000080808000000000000000000000000000CCFFCC00CCFFCC00CCFFCC0066FF
      3300009933000066000077777700F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00F0FBFF00EAEAEA00E3E3E300555555000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00080808000000000000000000000000000FFFFFF00CCFFCC00CCFFCC0066FF
      3300FFCC3300FFCC330077777700F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00EAEAEA00E3E3E300C0C0C000555555000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00080808000000000000000000000000000FFFFCC00CCFFCC00CCFFCC000066
      0000FFCC3300FFCC330077777700F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00E3E3E300C0C0C00096969600555555000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00080808000000000000000000000000000FFFFFF00FFFFCC0033CC3300FFFF
      3300FFFF3300FFCC330077777700F0FBFF00F0FBFF00FF000000FF000000F0FB
      FF0096969600D6E7E70096969600040404000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00C0C0C000C0C0C000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00080808000000000000000000000000000F0CAA600FFFFFF00FFFF3300FFFF
      330000663300FFCC330077777700F0FBFF00F0FBFF00F0FBFF00F0FBFF00F0FB
      FF00969696009696960000993300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00C0C0C000C0C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00080808000000000000000000000000000F0CAA600FFFFFF00FFFF33000066
      330000993300FF99000077777700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00969696000080000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C0C0C00000000000000000000000000000000000FFFFFF0066FF330066FF
      33000099330000993300FF990000FFCC3300FFCC3300FFCC3300FFCC3300FF66
      3300FF663300FF66330004040400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CCFFCC00CCFF
      CC0033CC330033CC330000993300FF99000000663300FF663300FF990000FF99
      0000FF6633000404040000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCFF
      CC00CCFFCC0066FF330033CC330033CC3300009933000099330000663300FF66
      3300FF6633000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000033CC330033CC3300FFFFFF0066FF330066FF330033CC3300009933000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFC000000FFFFFFFFE0000000
      FFFFFCFFC0000000C01FF87F80000000C00FF02780000000C01FE00700000000
      C01FC00700000000C00FC00700000000C007E00700000000C003F00700000000
      C007F80700010000C00FF00700010000EC1FF00780010000FE3FFFFFC0030000
      FF7FFFFFE0070000FFFFFFFFF01F0000}
  end
end
