inherited fBase: TfBase
  Left = 385
  Top = 250
  Caption = 'Base'
  WindowState = wsMaximized
  inherited pSociete: TPanel
    TabOrder = 4
    inherited lHeure: TLabel
      Width = 56
    end
  end
  object Splitter1: TSplitter[5]
    Cursor = crVSplit
    Left = 0
    Height = 6
    Top = 272
    Width = 821
    Align = alBottom
    Color = clLime
    ParentColor = False
    ResizeAnchor = akBottom
  end
  object pc: TPageControl[6]
    Left = 0
    Height = 193
    Top = 278
    Width = 821
    Align = alBottom
    TabOrder = 1
  end
  object Panel1: TPanel[7]
    Left = 0
    Height = 254
    Top = 18
    Width = 821
    Align = alClient
    Caption = 'Panel1'
    ClientHeight = 254
    ClientWidth = 821
    TabOrder = 2
    object Panel2: TPanel
      Left = 1
      Height = 41
      Top = 212
      Width = 819
      Align = alBottom
      ClientHeight = 41
      ClientWidth = 819
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Height = 13
        Top = 16
        Width = 33
        Caption = 'Total : '
        ParentColor = False
      end
      object lNbTotal: TLabel
        Left = 48
        Height = 13
        Top = 16
        Width = 40
        Caption = 'lNbTotal'
        ParentColor = False
      end
      object bImprimer: TBitBtn
        Left = 416
        Height = 25
        Top = 8
        Width = 75
        Caption = 'Imprimer'
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
          00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
          8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
          8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
          8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
          03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
          03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
          33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
          33333337FFFF7733333333300000033333333337777773333333
        }
        NumGlyphs = 2
        TabOrder = 0
      end
      object bNouveau: TButton
        Left = 496
        Height = 25
        Top = 8
        Width = 75
        Caption = 'Nouveau'
        OnClick = bNouveauClick
        TabOrder = 1
      end
      object bSupprimer: TButton
        Left = 576
        Height = 25
        Top = 8
        Width = 75
        Caption = 'Supprimer'
        OnClick = bSupprimerClick
        TabOrder = 2
      end
    end
    object cg: TChampsGrid
      Left = 1
      Height = 181
      Top = 31
      Width = 819
      Align = alClient
      ColCount = 1
      FixedCols = 0
      FixedRows = 0
      RowCount = 1
      TabOrder = 1
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      OnSelectCell = cgSelectCell
      Persistance = True
    end
    object Panel3: TPanel
      Left = 1
      Height = 30
      Top = 1
      Width = 819
      Align = alTop
      ClientHeight = 30
      ClientWidth = 819
      TabOrder = 2
      object Label2: TLabel
        Left = 8
        Height = 13
        Top = 8
        Width = 52
        Caption = 'Ordre de tri'
        ParentColor = False
      end
      object lTri: TLabel
        Left = 72
        Height = 13
        Top = 8
        Width = 14
        Caption = 'lTri'
        ParentColor = False
      end
      object cbReadOnly: TCheckBox
        Left = 312
        Height = 19
        Top = 8
        Width = 84
        Action = aReadOnly_Change
        TabOrder = 0
      end
    end
  end
  inherited al: TActionList[8]
    left = 504
    top = 160
    object aReadOnly_Change: TAction[2]
      Caption = 'Lecture seule'
      OnExecute = aReadOnly_ChangeExecute
    end
  end
  inherited pmValidation: TPopupMenu[9]
  end
end
