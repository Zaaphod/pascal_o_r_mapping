unit ufOpenDocument_DelphiReportEngine;

{$MODE Delphi}

{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2011,2012,2014 Jean SUZINEAU - MARS42                             |
    Copyright 2011,2012,2014 Cabinet Gilles DOUTRE - BATPRO                     |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

interface

uses
    uOD_Forms,
    uODRE_Table,
    uOD_TextTableContext,
    uOD_Dataset_Columns,
    uOD_Dataset_Column,
    uOOoStrings,
    uOOoStringList,
    uOpenDocument,
    uVide,
    Zipper ,
    DOM,
    uOOoChrono, 
    ucChampsGrid,

    ublODRE_Table,
    ublOD_Dataset_Columns,
    uhDessinnateurWeb,//pour mise au point

  LCLIntf, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Grids, ValEdit, Registry,
  Spin,LCLType,XMLWrite,XMLRead,StrUtils;

type

 { TfOpenDocument_DelphiReportEngine }

 TfOpenDocument_DelphiReportEngine
 =
  class(TForm)
   cg: TChampsGrid;
    odODF: TOpenDialog;
    pc: TPageControl;
    tsContent: TTabSheet;
    tsStyles: TTabSheet;
    tvContent: TTreeView;
    tvStyles: TTreeView;
    tsVLE: TTabSheet;
    vle: TValueListEditor;
    tsTV: TTabSheet;
    tv: TTreeView;
    Panel1: TPanel;
    bArborescence_from_Natif: TButton;
    bToutOuvrir: TButton;
    bToutFermer: TButton;
    gbBranche: TGroupBox;
    bDupliquer: TButton;
    bSupprimer: TButton;
    bExporter: TButton;
    bImporter: TButton;
    tsTV_Insertion: TTabSheet;
    Panel3: TPanel;
    tvi: TTreeView;
    bInserer: TButton;
    cbOptimiserInsertion: TCheckBox;
    sd: TSaveDialog;
    od: TOpenDialog;
    bFrom_Document: TButton;
    tsContent_XML: TTabSheet;
    mContent_XML: TMemo;
    tsStyles_XML: TTabSheet;
    mStyles_XML: TMemo;
    bOuvrir: TButton;
    bFermer: TButton;
    bChrono: TButton;
    tShow: TTimer;
    Panel2: TPanel;
    bContent_Enregistrer: TButton;
    Panel4: TPanel;
    bStyles_Enregistrer: TButton;
    tsMIMETYPE: TTabSheet;
    tsMETA_XML: TTabSheet;
    tsSETTINGS_XML: TTabSheet;
    mMIMETYPE: TMemo;
    mMETA_XML: TMemo;
    mSETTINGS_XML: TMemo;
    tsMETA_INF_manifest_xml: TTabSheet;
    mMETA_INF_manifest_xml: TMemo;
    tsODRE_Table: TTabSheet;
    lbODRE_Table: TListBox;
    Panel5: TPanel;
    speODRE_Table_NbColonnes: TSpinEdit;
    Label1: TLabel;
    mODRE_Table_Colonnes: TMemo;
    bSupprimerColonne: TButton;
    speSupprimerColonne_Numero: TSpinEdit;
    eStyles_XML_Chercher: TEdit;
    bStyles_XML_Chercher: TButton;
    eContent_XML_Chercher: TEdit;
    bContent_XML_Chercher: TButton;
    bInsererColonne: TButton;
    speInsererColonne_Numero: TSpinEdit;
    bDecalerChampsApresColonne: TButton;
    speDecalerChampsApresColonne_Numero: TSpinEdit;
    gbBranche_Insertion: TGroupBox;
    bSupprimer_Insertion: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure tvEditing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
    procedure bDupliquerClick(Sender: TObject);
    procedure bArborescence_from_NatifClick(Sender: TObject);
    procedure bFrom_DocumentClick(Sender: TObject);
    procedure bToutOuvrirClick(Sender: TObject);
    procedure bToutFermerClick(Sender: TObject);
    procedure bSupprimerClick(Sender: TObject);
    procedure bInsererClick(Sender: TObject);
    procedure bExporterClick(Sender: TObject);
    procedure bImporterClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure bOuvrirClick(Sender: TObject);
    procedure bFermerClick(Sender: TObject);
    procedure bChronoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tShowTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bContent_EnregistrerClick(Sender: TObject);
    procedure bStyles_EnregistrerClick(Sender: TObject);
    procedure lbODRE_TableClick(Sender: TObject);
    procedure bSupprimerColonneClick(Sender: TObject);
    procedure bStyles_XML_ChercherClick(Sender: TObject);
    procedure bContent_XML_ChercherClick(Sender: TObject);
    procedure bInsererColonneClick(Sender: TObject);
    procedure bDecalerChampsApresColonneClick(Sender: TObject);
    procedure bSupprimer_InsertionClick(Sender: TObject);
  //Optimisation de l'arborescence
  private
   procedure From_m(var _xml: TXMLDocument; _m: TMemo);
    procedure Optimise( _tns: TTreeNodes);
    procedure To_m(_xml: TXMLDocument; _m: TMemo);
  //Attributs et m�thodes priv�s g�n�raux
  private
    Embedded: Boolean; //pour distinguer l'appel par Execute de l'affichage comme fiche principale
    Document: TOpenDocument;
    OldTitre: String;
    __sl: TOOoStringList;
    __sli: TOOoStringList;
    slSuppressions: TOOoStringList;
    tns, tnsi: TTreeNodes;
    procedure Ajoute_Valeur_dans_tv( sKey, sValue: String);
    procedure Ajoute_Valeur_dans_tvi( sKey, sValue: String);
    function Cle_from_tn( tn: TTreeNode): String;
    function Racine_from_tn( tn: TTreeNode): String;
    function Name_from_Text( tn: TTreeNode): String;
    function HasValue( tn: TTreeNode): Boolean;
    procedure Copie_Sous_branche( tn: TTreeNode; Source, Cible: String);
    procedure Supprime_Sous_branche( tn: TTreeNode; Selection: String);
    procedure Supprime_Sous_branche_Insertion( tn: TTreeNode; Selection: String);
    procedure Affiche_XMLs;
    procedure From_Document;
    procedure Exporte_Sous_branche(tn: TTreeNode; Source: String; sl: TOOoStringList);
  //Gestion de l'ouverture
  public
    procedure Ouvre( _NomDocument: String);
    procedure Ferme;
  //M�thodes g�n�rales
  public
    function Execute( _NomDocument: String): Boolean;
  //Composition du Treeview
  private
    procedure tv_Add( _tv: TTreeView; _e: TDOMNode; _Parent: TTreeNode = nil);
  //Surcharge de la m�thode de gestion des messages
  protected
    procedure WndProc(var Message: TMessage); override;
  //Inscription dans la base de registre
  private
    procedure Enregistre_Extension;
  //Gestion des ODRE_Tables
  public
   OD_TextTableContext: TOD_TextTableContext;
   slT: TslODRE_Table;
   blODRE_Table: TblODRE_Table;
  end;

var
   //seulement utile dans le projet OpenDocument_DelphiReportEngine.dpr
   //ailleurs utiliser ufOpenDocument_DelphiReportEngine_Execute ci dessous
   fOpenDocument_DelphiReportEngine: TfOpenDocument_DelphiReportEngine= nil;

function ufOpenDocument_DelphiReportEngine_Execute( _NomDocument: String): Boolean;

implementation

{$R *.lfm}

function ufOpenDocument_DelphiReportEngine_Execute( _NomDocument: String): Boolean;
var
   F: TfOpenDocument_DelphiReportEngine;
begin
     Result:= False;
     F:= TfOpenDocument_DelphiReportEngine.Create( nil);
     try
        Result:= F.Execute( _NomDocument);
     finally
            FreeAndNil( F);
            end;
end;

{ TfOpenDocument_DelphiReportEngine }

procedure TfOpenDocument_DelphiReportEngine.FormCreate(Sender: TObject);
begin
     Document:= nil;
     OD_TextTableContext:= nil;
     blODRE_Table:= nil;

     __sl            := TOOoStringList.Create;
     __sli           := TOOoStringList.Create;
     slSuppressions:= TOOoStringList.Create;
     tns := tv.Items;
     tnsi:= tvi.Items;
     Embedded:= False;
     slT:= TslODRE_Table.Create( Classname+'.slT');
end;

procedure TfOpenDocument_DelphiReportEngine.FormDestroy(Sender: TObject);
begin
     Detruit_StringList( slT);
     FreeAndNil( OD_TextTableContext);
     FreeAndNil( Document      );
     FreeAndNil( __sl            );
     FreeAndNil( __sli           );
     FreeAndNil( slSuppressions);
end;

procedure TfOpenDocument_DelphiReportEngine.FormShow(Sender: TObject);
begin
     if Embedded then exit;

     Enregistre_Extension;

     if ParamCount = 1
     then
         Ouvre( ParamStr( 1))
     else
         tShow.Enabled:= True;
end;

procedure TfOpenDocument_DelphiReportEngine.Ferme;
begin
     if Document = nil then exit;

     if idYes
        =
        MessageDlg( 'Voulez vous enregistrer les modifications ?',
                    mtConfirmation, [mbYes, mbNo], 0)
     then
         Document.Save;

     pc.Hide;
     FreeAndNil( OD_TextTableContext);
     FreeAndNil( Document);
     Caption:= 'OpenDocument_DelphiReportEngine';
end;

procedure TfOpenDocument_DelphiReportEngine.tShowTimer(Sender: TObject);
begin
     tShow.Enabled:= False;

     //odODF.InitialDir:= '\\linuxm\p\tmp';
     //odODF.InitialDir:= 'C:\2_source\03_Batpro_Editions\00_bin\modeles_np\';
     odODF.InitialDir:= '\\Linuxm\a\modeles_oo_hollywood';
     odODF.DefaultExt:= 'ott';
     odODF.FileName:= 'DEV*.ott';
     if odODF.Execute
     then
         Ouvre( odODF.FileName);
end;

procedure TfOpenDocument_DelphiReportEngine.Ouvre( _NomDocument: String);
begin
     Ferme;

     OOoChrono.Start;
     Document:= TOpenDocument.Create( _NomDocument);
     OD_TextTableContext:= TOD_TextTableContext.Create( Document);

     Caption:= ExtractFileName( Document.Nom);

     From_Document;
     pc.Show;
end;

procedure TfOpenDocument_DelphiReportEngine.Ajoute_Valeur_dans_tv( sKey, sValue: String);
var
   sTreePath: String;
   procedure Recursif( Racine: String; Parent: TTreeNode);
   var
      s, sCle: String;
      i: Integer;
      LsTreePath: Integer;
      sTreePath_has_final_underscore: Boolean;
   begin
        LsTreePath:= Length( sTreePath);
        if LsTreePath = 0
        then
            sTreePath_has_final_underscore:= False
        else
            sTreePath_has_final_underscore:= sTreePath[ LsTreePath] = '_';
        s:= StrTok( '_', sTreePath);
        if      sTreePath_has_final_underscore
           and (sTreePath = '')
        then
            s:= s+'_';

        sCle:= Racine+'_'+s;
        i:= __sl.IndexOf( sCle);
        if i = -1
        then
            begin
            Parent:= tns.AddChild( Parent, s);
            __sl.AddObject( sCle, Parent);
            end
        else
            Parent:= __sl.Objects[i] as TTreeNode;

        if sTreePath = ''
        then //cas terminal
            Parent.Text:= s + '=' + sValue
        else
            Recursif( sCle, Parent);
   end;
begin
     sTreePath:= sKey;
     Recursif( '', nil);
end;

procedure TfOpenDocument_DelphiReportEngine.Ajoute_Valeur_dans_tvi( sKey, sValue: String);
var
   sTreePath: String;
   procedure Recursif( Racine: String; Parent: TTreeNode);
   var
      s, sCle: String;
      i: Integer;
      LsTreePath: Integer;
      sTreePath_has_final_underscore: Boolean;
   begin
        LsTreePath:= Length( sTreePath);
        if LsTreePath = 0
        then
            sTreePath_has_final_underscore:= False
        else
            sTreePath_has_final_underscore:= sTreePath[ LsTreePath] = '_';
        s:= StrTok( '_', sTreePath);
        if      sTreePath_has_final_underscore
           and (sTreePath = '')
        then
            s:= s+'_';

        sCle:= Racine+'_'+s;
        i:= __sli.IndexOf( sCle);
        if i = -1
        then
            begin
            Parent:= tnsi.AddChild( Parent, s);
            __sli.AddObject( sCle, Parent);
            end
        else
            Parent:= __sli.Objects[i] as TTreeNode;

        if sTreePath = ''
        then //cas terminal
            Parent.Text:= s
        else
            Recursif( sCle, Parent);
   end;
begin
     sTreePath:= sKey;
     Recursif( '', nil);
end;

procedure TfOpenDocument_DelphiReportEngine.Optimise( _tns: TTreeNodes);
var
   I: Integer;
   TreeNode: TTreeNode;
     procedure T( _Root: TTreeNode);
     var
        Cle_Root: String;
        iRoot: Integer;
        tv_root_node: TTreeNode;
        ok_singlechild: Boolean;
        procedure Move_Child( _Parent: TTreeNode);
        var
           tn, fish: TTreeNode;
        begin
             tn:= _Parent.getFirstChild;
             while Assigned( tn)
             do
               begin
               fish:= _Parent.GetNextChild( tn);
               tn.MoveTo( _Root, naAddChild);
               tn:= fish;
               end;
        end;
        procedure Traite_SingleChild;
        var
           iRoot: Integer;

           SingleChild: TTreeNode;
           SingleChild_Text: String;
           iSingleChild: Integer;
           S: String;
        begin
             SingleChild:= _Root.getFirstChild;

             Move_Child( SingleChild);
             SingleChild_Text:= SingleChild.Text;
             with _Root do Text:= Text + '_' + SingleChild_Text;

             iRoot:= __sl.IndexOfObject( _Root);
             if iRoot <> -1
             then
                 begin
                 S:= __sl[iRoot];
                 __sl[iRoot]:= S+'_'+StrToK( '=',SingleChild_Text);
                 end;

             iSingleChild:= __sl.IndexOfObject( SingleChild);
             if iSingleChild <> -1 then __sl.Delete( iSingleChild);

             _tns.Delete( SingleChild);
        end;
        procedure Recursive;
        var
           tn: TTreeNode;
        begin
             tn:= _Root.getFirstChild;
             while Assigned( tn)
             do
               begin
               T( tn);
               tn:= _Root.GetNextChild( tn);
               end;
        end;
     begin
          if _Root = nil then exit;

          ok_singlechild:= 0 = Pos( '=', _Root.Text);
          if ok_singlechild
          then
              begin
              Cle_Root:= Cle_from_tn(_Root);
              iRoot:= __sl.IndexOf( '_'+Cle_Root);
              ok_singlechild:= iRoot <> -1;
              if ok_singlechild
              then
                  begin
                  tv_root_node:= TTreeNode( __sl.Objects[iRoot]);
                  ok_singlechild
                  :=
                        Assigned( tv_root_node)
                    and (tv_root_node is TTreeNode);
                  if ok_singlechild
                  then
                      ok_singlechild:= 0 = Pos( '=', tv_root_node.Text);
                  end;
              end;


          if ok_singlechild
          then
              while _Root.Count = 1
              do
                Traite_SingleChild;

          if _Root.Count > 0
          then
              Recursive;
     end;
begin
     I:= 0;
     while I < _tns.Count
     do
       begin
       TreeNode:= _tns.Item[ I];
       if TreeNode.Parent =  nil
       then
           T( TreeNode);
       Inc( I);
       end;
end;

function TfOpenDocument_DelphiReportEngine.Execute( _NomDocument: String): Boolean;
begin
     Embedded:= True;
     Ouvre( _NomDocument);
     try
        Result:= inherited ShowModal = mrOK;
     finally
            Ferme;
            end;
end;

function TfOpenDocument_DelphiReportEngine.Name_from_Text( tn: TTreeNode): String;
begin
     if tn = nil
     then
         Result:= ''
     else
         begin
         Result:= tn.Text;
         Result:= StrTok( '=', Result);
         end;
end;

procedure TfOpenDocument_DelphiReportEngine.tvEditing(Sender: TObject;
  Node: TTreeNode; var AllowEdit: Boolean);
var
   I, iRow: Integer;
   sKey, sValue: String;
begin
     AllowEdit:= False;

     I:= __sl.IndexOfObject( Node);
     if i = -1 then exit;

     sKey:= __sl.Strings[ I];
     Delete( sKey, 1, 1);
     if not vle.FindRow( sKey,  iRow)  then exit;
     sValue:= vle.Values[ sKey];
     OldTitre:= Name_from_Text( Node);

     if InputQuery( 'Modification', OldTitre, sValue)
     then
         begin
         Document.Set_Field( sKey, sValue);
         vle.Values[ sKey]:= sValue;
         Node.Text:= OldTitre+'='+sValue;
         Affiche_XMLs;
         end;
end;


function TfOpenDocument_DelphiReportEngine.Cle_from_tn(tn: TTreeNode): String;
begin
     if tn = nil
     then
         Result:= ''
     else
         begin
         if tn.Parent = nil
         then // Cas terminal
             Result:= ''
         else // Appel r�cursif
             Result:= Cle_from_tn( tn.Parent) + '_';
         Result:= Result + Name_from_Text( tn);
         end;
end;

function TfOpenDocument_DelphiReportEngine.Racine_from_tn( tn: TTreeNode): String;
begin
     if    (tn        = nil)
        or (tn.Parent = nil)
     then
         Result:= ''
     else
         Result:= Cle_from_tn
         ( tn.Parent);
end;

function TfOpenDocument_DelphiReportEngine.HasValue( tn: TTreeNode): Boolean;
begin
     if tn = nil
     then
         Result:= False
     else
         Result:= Pos( '=', tn.Text) > 0
end;

procedure TfOpenDocument_DelphiReportEngine.bDupliquerClick(Sender: TObject);
var
   tn: TTreeNode;
   Source, Cible: String;
begin
     tn:= tv.Selected;
     if tn = nil then exit;

     Source:= Cle_from_tn( tn);
     Cible:= Source+'_Copie';

     if InputQuery( 'Duplication', 'Nouvelle cl� pour Open Office', Cible)
     then
         begin
         if HasValue( tn)
         then
             Document.Set_Field( Cible, vle.Values[ Source]);
         Copie_Sous_branche( tn, Source, Cible);
         From_document;
         end;
end;

procedure TfOpenDocument_DelphiReportEngine.Copie_Sous_branche( tn: TTreeNode; Source, Cible: String);
var
   Child: TTreeNode;
   _Name: String;
   Child_Source,
   Child_Cible : String;
begin
     Child:= tn.getFirstChild;
     while Assigned( Child)
     do
       begin
       _Name:= '_'+Name_from_Text( Child);
       Child_Source:= Source + _Name;
       Child_Cible := Cible  + _Name;
       if HasValue( Child)
       then
           Document.Set_Field( Child_Cible, vle.Values[ Child_Source]);

       Copie_Sous_branche( Child, Child_Source, Child_Cible);

       Child:= tn.GetNextChild( Child);
       end;
end;

procedure TfOpenDocument_DelphiReportEngine.bSupprimerClick(Sender: TObject);
var
   tn: TTreeNode;
   Selection: String;
begin
     tn:= tv.Selected;
     if tn = nil then exit;

     Selection:= Cle_from_tn( tn);

     Supprime_Sous_branche( tn, Selection);
     tv.Items.Delete( tn);
end;

procedure TfOpenDocument_DelphiReportEngine.Supprime_Sous_branche( tn: TTreeNode; Selection: String);
var
   Child, Trash: TTreeNode;
   _Name: String;
   procedure Supprime_Champ( Champ: String);
   var
      Row: Integer;
   begin
        slSuppressions.Add( Champ);
        if vle.FindRow( Champ, Row)
        then
            vle.DeleteRow( Row);
        Document.DetruitChamp( Champ);
   end;
begin
     Child:= tn.getFirstChild;
     while Assigned( Child)
     do
       begin
       _Name:= Selection+'_'+Name_from_Text( Child);

       Supprime_Sous_branche( Child, _Name);

       Trash:= Child;
       Child:= tn.GetNextChild( Child);
       tv.Items.Delete( Trash);
       end;

     Supprime_Champ( Selection);
end;

procedure TfOpenDocument_DelphiReportEngine.Supprime_Sous_branche_Insertion( tn: TTreeNode; Selection: String);
var
   Child, Trash: TTreeNode;
   _Name: String;
   procedure Supprime_Champ( Champ: String);
   var
      Row: Integer;
   begin
        slSuppressions.Add( Champ);
        if vle.FindRow( Champ, Row)
        then
            vle.DeleteRow( Row);
        Document.DetruitChamp( Champ);
   end;
begin
     Child:= tn.getFirstChild;
     while Assigned( Child)
     do
       begin
       _Name:= Selection+'_'+Name_from_Text( Child);

       Supprime_Sous_branche_Insertion( Child, _Name);

       Trash:= Child;
       Child:= tn.GetNextChild( Child);
       tvi.Items.Delete( Trash);
       end;

     Supprime_Champ( Selection);
end;

procedure TfOpenDocument_DelphiReportEngine.bArborescence_from_NatifClick( Sender: TObject);
begin
     From_Document;
end;

procedure TfOpenDocument_DelphiReportEngine.bFrom_DocumentClick(Sender: TObject);
begin
     From_Document;
end;

var
   sys_Racine_Champ          : String= 'com.sun.star.text.FieldMaster.User.';
   sys_Racine_Champ_UpperCase: String= 'COM.SUN.STAR.TEXT.FIELDMASTER.USER.';
   
function FieldName_from_FieldPathName( _FieldPathName: String): String;
begin
     Result:= Copy( _FieldPathName, Length( sys_Racine_Champ)+1, Length( _FieldPathName));
end;

function FieldPathName_from_FieldName( _FieldName    : String): String;
begin
     Result:= sys_Racine_Champ+_FieldName;
end;

procedure TfOpenDocument_DelphiReportEngine.To_m( _xml: TXMLDocument; _m: TMemo);
var
   ms: TMemoryStream;
begin
     ms:= TMemoryStream.Create;
     try
        WriteXML( _xml, ms);
        _m.Lines.LoadFromStream( ms);
     finally
            FreeAndNil( ms);
            end;
     OOoChrono.Stop( 'Chargement de l''objet XML dans le memo '+_m.Name);

end;
procedure TfOpenDocument_DelphiReportEngine.From_m( var _xml: TXMLDocument; _m: TMemo);
var
   ms: TMemoryStream;
begin
     FreeAndnil( _xml);
     ms:= TMemoryStream.Create;
     try
        _m.Lines.SaveToStream( ms);
        ReadXMLFile( _xml, ms);
     finally
            FreeAndNil( ms);
            end;
end;

procedure TfOpenDocument_DelphiReportEngine.Affiche_XMLs;
   procedure To_tv( _xml: TXMLDocument; _tv: TTreeView; _m: TMemo);
   begin
        To_m( _xml, _m);
        _tv.Items.Clear;
        tv_add( _tv, _XML.DocumentElement);
        _tv.FullExpand;
        OOoChrono.Stop( 'Chargement de l''objet XML dans le TreeView '+_tv.Name);
   end;
begin
     To_m( Document.xmlMeta             , mMeta_xml             );
     To_m( Document.xmlSettings         , mSettings_xml         );
     To_m( Document.xmlMETA_INF_manifest, mMETA_INF_manifest_xml);
     To_tv( Document.xmlContent, tvContent, mContent_XML);
     To_tv( Document.xmlStyles , tvStyles , mStyles_XML );
end;

procedure TfOpenDocument_DelphiReportEngine.From_Document;
var
   sl: TOOoStringList;

   Ligne, Nom, Valeur: String;
   Nom_ODRE_Table: String;
   function Is_NbColonnes: Boolean;
   const
        sNbColonnes= '_NbColonnes';
   var
      iNbColonnes: Integer;
   begin //Test si se termine par NbColonnes
        iNbColonnes:= Pos( sNbColonnes, Nom);
        Result:= iNbColonnes = Length( Nom)-Length(sNbColonnes)+1;
        if Result
        then
            Nom_ODRE_Table:= Copy( Nom, 2, iNbColonnes-2)
        else
            Nom_ODRE_Table:= '';
   end;
   procedure Ajoute_ODRE_Table;
   var
      bl: TblODRE_Table;
   begin
        lbODRE_Table.Items.Add( Nom_ODRE_Table);
        bl:= TblODRE_Table.Create( slT, nil, nil);
        bl.Charge( Nom_ODRE_Table, OD_TextTableContext);
        slT.AddObject( bl.sCle, bl);
   end;
   procedure Traite_Tables;//d�tection des datasets dans les tables
   const
        sAvant_Composition='_avant_composition';
        lAvant_Composition=Length(sAvant_Composition);
   var
      I: TIterateur_ODRE_Table;
      bl: TblODRE_Table;
      Prefixe: String;
      iAvant_Composition: Integer;
   begin
        I:= slT.Iterateur;
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl)     then continue;

          Prefixe:= bl.Nom+'_';
          if 1 <> Pos( Prefixe, Nom) then continue;

          Delete( Nom, 1, Length(Prefixe));
          iAvant_Composition:= Length( Nom)-lAvant_Composition;
          if iAvant_Composition <> Pos(sAvant_Composition, Nom) then continue;

          Delete( Nom, iAvant_Composition, lAvant_Composition);
          bl.haOD_Dataset_Columns.AddDataset( Nom, OD_TextTableContext);
          end;
   end;
   procedure Traite_Dataset( _blODRE_Table: TblODRE_Table);
   var
      I: TIterateur_OD_Dataset_Columns;
      bl: TblOD_Dataset_Columns;
      Prefixe: String;
      function not_Traite_Avant: Boolean;
      const
           sAvant='Avant_';
           lAvant=Length( sAvant);
      var
         DCs: TOD_Dataset_Columns;
         NomAvant: String;
      begin
           Result:= True;
           if 1 <> Pos( sAvant, Nom) then exit;

           Result:= False;
           Delete( Nom, 1, lAvant);

           DCs:= bl.DCs;
           NomAvant:= DCs.Nom_Avant( '_'+_blODRE_Table.Nom+'_');
           DCs.Avant[ Nom].from_Doc( NomAvant, OD_TextTableContext);
      end;
      function not_Traite_Apres: Boolean;
      const
           sApres='Apres_';
           lApres=Length( sApres);
      var
         DCs: TOD_Dataset_Columns;
         NomApres: String;
      begin
           Result:= True;
           if 1 <> Pos( sApres, Nom) then exit;

           Result:= False;
           Delete( Nom, 1, lApres);

           DCs:= bl.DCs;
           NomApres:= DCs.Nom_Apres( '_'+_blODRE_Table.Nom+'_');
           DCs.Apres[ Nom].from_Doc( NomApres, OD_TextTableContext);
      end;
   begin
        I:= _blODRE_Table.haOD_Dataset_Columns.Iterateur;
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl)     then continue;

          Prefixe:= bl.Nom+'_';
          if 1 <> Pos( Prefixe, Nom) then continue;

          Delete( Nom, 1, Length(Prefixe));

          if   not_Traite_Avant
          then not_Traite_Apres;
          end;
   end;
   procedure Traite_Datasets;//d�tection des champs dans les datasets
   const
        sDebut='_Debut';
        lDebut=Length(sDebut);
   var
      I: TIterateur_ODRE_Table;
      bl: TblODRE_Table;
      Prefixe: String;
      iDebut: Integer;
   begin
        I:= slT.Iterateur;
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl)     then continue;

          Prefixe:= bl.Nom+'_';
          if 1 <> Pos( Prefixe, Nom) then continue;

          Delete( Nom, 1, Length(Prefixe));
          iDebut:= Length( Nom)-lDebut;
          if iDebut <> Pos(sDebut, Nom) then continue;

          Delete( Nom, iDebut, lDebut);
          Traite_Dataset( bl);
          end;
   end;
begin
     Affiche_XMLs;

     vle.Strings.Clear;
     tns .Clear;
     tnsi.Clear;
     __sl .Clear;
     __sli.Clear;

     sl:= TOOoStringList.Create;
     try
        Document.Get_Fields( sl);

        for Ligne in sl
        do
          begin
          Nom:= StrToK( '=', Ligne);
          Valeur:= Ligne;
          vle.Values[Nom]:= Valeur;
          if  1 = Pos( '_', Nom)
          then
              begin
              Ajoute_Valeur_dans_tv ( Nom, Valeur);
              if Is_NbColonnes
              then
                  Ajoute_ODRE_Table;
              end
          else
              Ajoute_Valeur_dans_tvi( Nom, Valeur);
          end;

        for Ligne in sl
        do
          begin
          if ''  =  Ligne    then continue;
          if '_' <> Ligne[1] then continue;

          Delete(Ligne,1,1);
          Nom:= StrToK( '=', Ligne);
          Valeur:= Ligne;
          Traite_Tables;
          end;

        for Ligne in sl
        do
          begin
          if ''  =  Ligne    then continue;
          if '_' <> Ligne[1] then continue;

          Delete(Ligne,1,1);
          Nom:= StrToK( '=', Ligne);
          Valeur:= Ligne;
          Traite_Datasets;
          end;
     finally
            FreeAndNil( sl);
            end;
     OOoChrono.Stop( 'Affichage des TextFields');

     slSuppressions.Clear;

     if cbOptimiserInsertion.Checked then Optimise( tnsi);
     Optimise( tns );
     tv .FullCollapse;
     tvi.FullCollapse;

     OOoChrono.Stop( 'Optimisation des TextFields');

     mMIMETYPE    .Lines.LoadFromFile( Document.CheminFichier_temporaire( 'mimetype'    ));

     OOoChrono.Stop( 'Affichage des autres fichiers');
end;

procedure TfOpenDocument_DelphiReportEngine.bToutOuvrirClick(Sender: TObject);
begin
     tv.FullExpand;
end;

procedure TfOpenDocument_DelphiReportEngine.bToutFermerClick(Sender: TObject);
begin
     tv.FullCollapse;
end;

procedure TfOpenDocument_DelphiReportEngine.bInsererClick(Sender: TObject);
var
   tn: TTreeNode;
   Selection: String;
begin
     tn:= tvi.Selected;
     if tn = nil then exit;

     Selection:= Cle_from_tn( tn);
     Document.Add_FieldGet( Selection);

     To_m( Document.xmlContent, mContent_XML);
end;

procedure TfOpenDocument_DelphiReportEngine.Exporte_Sous_branche( tn: TTreeNode; Source: String; sl: TOOoStringList);
var
   Child: TTreeNode;
   _Name: String;
   Child_Source: String;
begin
     Child:= tn.getFirstChild;
     while Assigned( Child)
     do
       begin
       _Name:= '_'+Name_from_Text( Child);
       Child_Source:= Source + _Name;
       if HasValue( Child)
       then
           sl.Values[Child_Source]:= vle.Values[Child_Source];

       Exporte_Sous_branche( Child, Child_Source, sl);

       Child:= tn.GetNextChild( Child);
       end;
end;

procedure TfOpenDocument_DelphiReportEngine.bExporterClick(Sender: TObject);
var
   tn: TTreeNode;
   Source: String;
   sl: TOOoStringList;
begin
     tn:= tv.Selected;
     if tn = nil then exit;

     sl:= TOOoStringList.Create;
     try
        Source:= Cle_from_tn( tn);
        if HasValue( tn)
        then
            sl.Values[Source]:= vle.Values[ Source];
        Exporte_Sous_branche( tn, Source, sl);

        if sd.Execute
        then
            sl.SaveToFile( sd.FileName);
     finally
            FreeAndNil( sl);
            end;
end;

procedure TfOpenDocument_DelphiReportEngine.bImporterClick(Sender: TObject);
var
   sl: TOOoStringList;
   I: Integer;
   Source: String;
begin
     sl:= TOOoStringList.Create;
     try
        if od.Execute
        then
            sl.LoadFromFile( od.FileName);
        for I:= 0 to sl.Count - 1
        do
          begin
          Source:= sl.Names[ I];
          Document.Set_Field( Source, sl.Values[ Source]);
          end;
     finally
            FreeAndNil( sl);
            end;
     From_Document;
end;

procedure TfOpenDocument_DelphiReportEngine.tv_Add( _tv: TTreeView; _e: TDOMNode;
                                                    _Parent: TTreeNode = nil);
var
   I: Integer;
   tn: TTreeNode;
   Properties: String;
begin
     if _tv = nil then exit;
     if _e = nil  then exit;
     if _e.Attributes = nil then exit;

     Properties:= '';
     for I:= 0 to _e.Attributes.Length -1
     do
       begin
       if Properties <> '' then Properties:= Properties + '     ';
       with _e.Attributes.Item[I]
       do
         Properties:= Properties+NodeName+': '+NodeValue;
       end;
     tn:= _tv.Items.AddChild( _Parent, '<'+_e.NodeName+' '+Properties+' >'+_e.TextContent);
     
     for I:= 0 to _e.ChildNodes.count - 1
     do
       tv_Add( _tv, _e.ChildNodes.Item[I], tn);
end;

procedure TfOpenDocument_DelphiReportEngine.FormCloseQuery( Sender: TObject;
                                                            var CanClose: Boolean);
begin
     Ferme;
end;

procedure TfOpenDocument_DelphiReportEngine.bOuvrirClick(Sender: TObject);
var
   tn: TTreeNode;
begin
     tn:= tv.Selected;
     if tn = nil then exit;

     tn.Expand( True);
end;

procedure TfOpenDocument_DelphiReportEngine.bFermerClick(Sender: TObject);
var
   tn: TTreeNode;
begin
     tn:= tv.Selected;
     if tn = nil then exit;

     tn.Collapse( True);
end;

procedure TfOpenDocument_DelphiReportEngine.bChronoClick(Sender: TObject);
begin
     uOD_Forms_ShowMessage( OOoChrono.Get_Liste);
end;

procedure TfOpenDocument_DelphiReportEngine.WndProc(var Message: TMessage);
var
   TailleNom: Integer;
   Nom: PChar;
begin
     case Message.Msg
     of
       WM_DROPFILES:
         begin
         //TailleNom:= DragQueryFile( Message.WParam, 0, nil, 0)+1;
         Nom:= StrAlloc( TailleNom);
         try
            //DragQueryFile( Message.WParam, 0, Nom, TailleNom);
            Ouvre( StrPas( Nom));
         finally
                StrDispose( Nom);
                end;
         end;
       else inherited;
       end;

end;

procedure TfOpenDocument_DelphiReportEngine.bContent_EnregistrerClick( Sender: TObject);
begin
     From_m( Document.xmlContent, mContent_XML);
     From_Document;
end;

procedure TfOpenDocument_DelphiReportEngine.bStyles_EnregistrerClick( Sender: TObject);
begin
     From_m( Document.xmlStyles, mStyles_XML);
     From_Document;
end;

procedure TfOpenDocument_DelphiReportEngine.Enregistre_Extension;
const
     //extension= '.ott';
     extension_modele= 'opendocument.WriterTemplate.1';
     extension_texte = 'opendocument.WriterDocument.1';
     extension_feuille = 'opendocument.CalcDocument.1';
     extension_modele_feuille = 'opendocument.CalcTemplate.1';

var
   r: TRegistry;
   Failed: Boolean;
   procedure T( _extension: String);
   var
      Key, Value: String;
   begin
        if Failed then exit;

        //verbe OpenDocument_DelphiReportEngine
        Key:= '\'+_extension+'\shell\OpenDocument_DelphiReportEngine\command';
        Value:= '"'+Application.ExeName+'" "%1"';

        try
           if not r.OpenKey( Key, True)
           then
               begin
               //MessageDlg( 'Echec de l''ouverture de la cl� '+Key, mtError, [mbOK], 0);
               Failed:= True;
               exit;
               end;

           r.WriteString( '', Value);
        except
              on E: ERegistryException
              do
                begin
                Failed:= True;
                MessageDlg( 'Echec de l''inscription dans la base de registre '#13#10
                           +'pour acc�s avec le bouton droit de la souris '#13#10
                           +'sur un document Open document'#13#10
                           +'dans l''explorateur de fichiers.'#13#10
                           +'Peut-�tre que vous devriez ex�cuter '
                           +'le programme en temps qu''administrateur.'#13#10
                           +E.Message, mtError, [mbOK], 0);
                end;
              end;
   end;
begin
     Failed:= False;
     r:= TRegistry.Create;
     try
        r.RootKey:= HKEY_CLASSES_ROOT;
        T( extension_modele);
        T( extension_texte );
        T( extension_feuille);
        T( extension_modele_feuille);
     finally
            FreeAndNil( r);
            end;
end;

procedure TfOpenDocument_DelphiReportEngine.lbODRE_TableClick( Sender: TObject);
var
   Nom: String;
   I: Integer;
begin
     Nom:= lbODRE_Table.Items[lbODRE_Table.ItemIndex];
     blODRE_Table:= blODRE_Table_from_sl_sCle( slT, Nom);
     if nil = blODRE_Table then exit;

     speODRE_Table_NbColonnes.Value:= blODRE_Table.T.GetNbColonnes;
     mODRE_Table_Colonnes.Clear;
     for I:= Low( blODRE_Table.T.Columns) to High( blODRE_Table.T.Columns)
     do
       mODRE_Table_Colonnes.Lines.Add( blODRE_Table.T.Columns[I].Titre);
end;

procedure TfOpenDocument_DelphiReportEngine.bSupprimerColonneClick( Sender: TObject);
begin
     if blODRE_Table = nil then exit;
     ShowMessage('� d�boguer');
     blODRE_Table.T.SupprimerColonne(speSupprimerColonne_Numero.Value);
     blODRE_Table.T.To_Doc( OD_TextTableContext);
end;

procedure TfOpenDocument_DelphiReportEngine.bInsererColonneClick( Sender: TObject);
begin
     if blODRE_Table = nil then exit;
     ShowMessage('� d�boguer');
     blODRE_Table.T.InsererColonneApres(speInsererColonne_Numero.Value);
     blODRE_Table.T.To_Doc( OD_TextTableContext);
end;

procedure TfOpenDocument_DelphiReportEngine.bDecalerChampsApresColonneClick(
  Sender: TObject);
begin
     if blODRE_Table = nil then exit;
     ShowMessage('� d�boguer');
     blODRE_Table.T.DecalerChampsApresColonne(speDecalerChampsApresColonne_Numero.Value);
     blODRE_Table.T.To_Doc( OD_TextTableContext);
end;

procedure TfOpenDocument_DelphiReportEngine.bStyles_XML_ChercherClick( Sender: TObject);
var
   I: Integer;
begin
     I:= PosEx( eStyles_XML_Chercher.Text, mStyles_XML.Text, mStyles_XML.SelStart+mStyles_XML.SelLength+1);
     if I = 0
     then
         begin
         uOD_Forms_ShowMessage( 'Texte non trouv�');
         exit;
         end;
     mStyles_XML.SetFocus;
     mStyles_XML.SelStart:= I-1;
     mStyles_XML.SelLength:= Length(eStyles_XML_Chercher.Text);
end;

procedure TfOpenDocument_DelphiReportEngine.bContent_XML_ChercherClick(
  Sender: TObject);
var
   I: Integer;
begin
     I:= PosEx( eContent_XML_Chercher.Text, mContent_XML.Text, mContent_XML.SelStart+mContent_XML.SelLength+1);
     if I = 0
     then
         begin
         uOD_Forms_ShowMessage( 'Texte non trouv�');
         exit;
         end;
     mContent_XML.SetFocus;
     mContent_XML.SelStart:= I-1;
     mContent_XML.SelLength:= Length(eContent_XML_Chercher.Text);
end;

procedure TfOpenDocument_DelphiReportEngine.bSupprimer_InsertionClick( Sender: TObject);
var
   tn: TTreeNode;
   Selection: String;
begin
     tn:= tvi.Selected;
     if tn = nil then exit;

     Selection:= Cle_from_tn( tn);

     Supprime_Sous_branche_Insertion( tn, Selection);
     tvi.Items.Delete( tn);
end;

end.


