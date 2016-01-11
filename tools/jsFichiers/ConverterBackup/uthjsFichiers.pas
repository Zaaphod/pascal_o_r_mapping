unit uthjsFichiers;

interface

uses
    Classes, ComCtrls;

type
    TthjsFichiers
    =
     class(TThread)
     public
       constructor Create( aRootPath: String);
     protected
       RootPath: String;
       Node, NewNode: TTreeNode;
       Libelle: String;
       procedure Execute; override;
       function TraiteRepertoire(Parent: TTreeNode; Path: String): Int64;
       procedure PrepareLibelle(Taille: Int64; NomFichier: String);
       procedure DoAddNode;
       procedure DoChangeNodeText;
     end;

var
   thjsFichiers: TthjsFichiers;
implementation

uses
    ufjsFichiers, SysUtils;
{ Important : les m�thodes et les propri�t�s des objets dans la VCL ne peuvent
  �tre utilis�es que dans une m�thode appel�e en utilisant Synchronize, par exemple :

      Synchronize(UpdateCaption);

  o� UpdateCaption pourrait �tre du type :

    procedure thjsFichiers.UpdateCaption;
    begin
      Form1.Caption := 'Mise � jour dans un thread';
    end; }

{ thjsFichiers }

procedure TthjsFichiers.DoAddNode;
begin
     NewNode:= fjsFichiers.Tree.Items.AddChild( Node, Libelle);
end;

procedure TthjsFichiers.DoChangeNodeText;
begin
     Node.Text:= Libelle;
end;

procedure TthjsFichiers.PrepareLibelle(Taille: Int64; NomFichier: String);
const
     ko= {ko}1024{o};
     Mo= {Mo}1024{ko};
     Go= {Go}1024{Mo};
var
   TailleEnko: double;
   TailleEnMo: double;
   TailleEnGo: double;
begin
     TailleEnko:= Taille     / ko;
     TailleEnMo:= TailleEnko / Mo;
     TailleEnGo:= TailleEnMo / Go;
     Libelle
     :=
       Format( '%7.2f Go, %10.2f Mo, %13.2f ko, %15d o, %s',
            [ TailleEnGo, TailleEnMo, TailleEnko, Taille, NomFichier]);
end;


function TthjsFichiers.TraiteRepertoire(Parent: TTreeNode; Path: String): Int64;
var
   SearchRec: TSearchRec;
   Courant: TTreeNode;
   NomFichier: String;
   Taille: Int64;
begin
     Result:= 0;
     if FindFirst( Path+'\*.*', faAnyFile, SearchRec) = 0
     then
         repeat
               Taille:= SearchRec.Size;
               NomFichier:= SearchRec.Name;

               Node:= Parent;
               PrepareLibelle( Taille, NomFichier);
               Synchronize( DoAddNode);
               Courant:= NewNode;

               if SearchRec.Attr and faDirectory <> 0
               then
                   if (NomFichier <> '.') and (NomFichier <> '..')
                   then
                       begin
                       Taille:= TraiteRepertoire( Courant, Path+'\'+NomFichier);
                       Node:= Courant;
                       PrepareLibelle( Taille, NomFichier);
                       Synchronize( DoChangeNodeText);
                       end;
               Inc( Result, Taille);
         until FindNext( SearchRec) <> 0;
     Parent.AlphaSort;
end;


procedure TthjsFichiers.Execute;
var
   Parent: TTreeNode;
begin
     { Placez le code du thread ici}
     Node:= nil;
     Libelle:= RootPath;
     Synchronize( DoAddNode);
     Parent:= NewNode;
     TraiteRepertoire( Parent, RootPath);
     Parent.AlphaSort;
     FreeOnTerminate:= True;
     if Self = thjsFichiers
     then
         thjsFichiers:= nil;
end;

constructor TthjsFichiers.Create(aRootPath: String);
begin
     RootPath:= aRootPath;
     inherited Create( False);
end;

initialization
              thjsFichiers:= nil;
end.
