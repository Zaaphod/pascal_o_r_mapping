unit ufDecoupe_gcode;

{$mode objfpc}{$H+}

interface

uses
    uEXE_INI,
    uFichierGCODE,
    ufFichierGCODE,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
 StdCtrls, ExtCtrls, Spin;

type

 { TfDecoupe_gcode }

 TfDecoupe_gcode = class(TForm)
  bAfficher: TButton;
  bChoix: TButton;
  bDecoupe_en: TButton;
  bReprendre: TButton;
  eSource: TEdit;
  Label1: TLabel;
  od: TOpenDialog;
  seNb: TSpinEdit;
  seReprendre: TSpinEdit;
  procedure bAfficherClick(Sender: TObject);
  procedure bChoixClick(Sender: TObject);
  procedure bDecoupe_enClick(Sender: TObject);
  procedure bReprendreClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormDestroy(Sender: TObject);
 private
  procedure Afficher;
  procedure Decoupe;
  procedure Reprendre;
 end;

var
 fDecoupe_gcode: TfDecoupe_gcode;

implementation

{$R *.lfm}

{ TfDecoupe_gcode }

procedure TfDecoupe_gcode.FormCreate(Sender: TObject);
begin
     eSource.Text:= EXE_INI.ReadString('Options', 'Source','');
end;

procedure TfDecoupe_gcode.FormDestroy(Sender: TObject);
begin
     EXE_INI.WriteString('Options', 'Source',eSource.Text);
end;

procedure TfDecoupe_gcode.bChoixClick(Sender: TObject);
begin
     od.FileName:= eSource.Text;
     if od.Execute
     then
         eSource.Text:= od.FileName;
end;

procedure TfDecoupe_gcode.bAfficherClick(Sender: TObject);
begin
     Afficher;
end;

procedure TfDecoupe_gcode.bDecoupe_enClick(Sender: TObject);
begin
     Decoupe;
end;

procedure TfDecoupe_gcode.bReprendreClick(Sender: TObject);
begin
     Reprendre;
end;

procedure TfDecoupe_gcode.Afficher;
begin
     TfFichierGCODE.Create( eSource.Text).Show;
end;

procedure TfDecoupe_gcode.Decoupe;
var
   F: TFichierGCODE;
begin
     F:= TFichierGCODE.Create;
     try
        F.Charge( eSource.Text);
        F.Decoupe( seNb.Value);
     finally
            FreeAndNil(F);
            end;
end;

procedure TfDecoupe_gcode.Reprendre;
var
   F: TFichierGCODE;
   Nom: String;
begin
     F:= TFichierGCODE.Create;
     try
        F.Charge( eSource.Text);
        Nom:= F.Reprendre( seReprendre.Value);
        TfFichierGCODE.Create( Nom).Show;
     finally
            FreeAndNil(F);
            end;
end;


end.

