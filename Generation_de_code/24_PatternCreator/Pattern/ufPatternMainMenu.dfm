inherited fPatternMainMenu: TfPatternMainMenu
  Caption = 'fPatternMainMenu'
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited pBas: TPanel
    inherited pFermer: TPanel
      Left = 729
      Width = 132
    end
  end
  object mm: TMainMenu
    Left = 88
    Top = 96
    object miBase: TMenuItem
      Caption = 'Base'
      object miVide: TMenuItem
        Caption = 'Vide'
      end
    end
    object miRelations: TMenuItem
      Caption = 'Relations'
      object miRelationVide: TMenuItem
        Caption = 'Vide'
      end
    end
  end
end
