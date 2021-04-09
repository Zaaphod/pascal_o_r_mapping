program Quasi_prime;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ufQuasi_prime, uQuasi_prime, uGeometrie, ufCanvas
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(TfQuasi_prime, fQuasi_prime);
 Application.CreateForm(TfCanvas, fCanvas);
 Application.Run;
end.

