inherited fdg_ctx: Tfdg_ctx
  Left = 104
  Top = 184
  Width = 1124
  Height = 371
  Caption = 'fdg_ctx'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited sLog: TSplitter
    Top = 309
    Width = 1116
  end
  inherited pSociete: TPanel
    Width = 1116
    inherited lSociete: TLabel
      Width = 1044
    end
    inherited lHeure: TLabel
      Left = 1060
    end
    inherited animation: TAnimate
      Left = 1044
    end
  end
  inherited pBas: TPanel
    Top = 268
    Width = 1116
    inherited pFermer: TPanel
      Left = 883
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 318
    Width = 1116
  end
  inherited pLog: TPanel
    Top = 315
    Width = 1116
    Height = 3
    inherited lLog: TLabel
      Width = 1114
    end
    inherited mLog: TMemo
      Width = 1114
      Height = 0
    end
  end
  object Panel1: TPanel [5]
    Left = 0
    Top = 18
    Width = 1116
    Height = 250
    Align = alClient
    ParentBackground = False
    TabOrder = 4
    object lCONTEXTE: TLabel
      Caption = 'contexte'    
      Left = 16           
      Top = 26                          
      Height = 13                               
    end                                         
    object lCONTEXTETYPE: TLabel
      Caption = 'contextetype'    
      Left = 16           
      Top = 48                          
      Height = 13                               
    end                                         
    object lLIBELLE: TLabel
      Caption = 'libelle'    
      Left = 16           
      Top = 70                          
      Height = 13                               
    end                                         
    object lNomChamp: TLabel
      Left = 16
      Top = 8
      Width = 57
      Height = 13
      Caption = 'lNomChamp'
    end
    object ceCONTEXTE: TChamp_Edit
      Field = 'contexte'                   
      Left = 81            
      Top = 26                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceCONTEXTETYPE: TChamp_Edit
      Field = 'contextetype'                   
      Left = 81            
      Top = 48                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceLIBELLE: TChamp_Edit
      Field = 'libelle'                   
      Left = 81            
      Top = 70                           
      Height = 21                                
      Width  = 179                               
    end                                          
    object ceNomChamp: TChamp_Edit
      Left = 81
      Top = 4
      Width = 121
      Height = 21
      TabOrder = 0
      Text = 'ceNomChamp'
    end
  end
end