program Generateur;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, virtualtreeview_package, synafpc, ufGenerateur, ufAutomatic_VST,
 ublAutomatic, uRequete, upoolG_CTX, uhVST, ufAccueil, uContexteClasse,
 uJoinPoint, ujpAngular_TypeScript_NomFichierElement,
 ujpAngular_TypeScript_NomClasseElement,
 ujpAngular_TypeScript_declaration_champs, ujpPHP_Doctrine_Has_Column,
 ujpCSharp_Champs_persistants, ujpPascal_Affecte, ujpSQL_CREATE_TABLE,
 ujpNom_de_la_table, uMenuHandler, ufAutomatic_Genere_tout_sl
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource := True;
 Application.Initialize;
 Application.CreateForm(TfGenerateur, fGenerateur);
 Application.Run;
end.

