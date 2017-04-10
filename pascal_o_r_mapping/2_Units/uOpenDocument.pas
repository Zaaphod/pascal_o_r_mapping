unit uOpenDocument;
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
    uDimensions_Image,
    uOD_Temporaire,
    uOD_JCL,
    uOOoStrings,
    uOOoChrono,
    uOOoStringList,
    uOOoDelphiReportEngineLog,

  {$IFDEF LINUX}
  clocale,
  {$ENDIF}
  SysUtils, Classes, XMLRead,XMLWrite,DOM,Zipper, Math, FileUtil;

type
 TOD_Root_Styles
 =
  (
  ors_xmlStyles_STYLES,
  ors_xmlStyles_AUTOMATIC_STYLES,
  ors_xmlContent_AUTOMATIC_STYLES
  );

 TODStringList
 =
  class( TStringList)
  //M�thodes surcharg�es
  protected
    (*function CompareStrings(const S1:String;const S2:String):Integer;override;*)
  end;

 TEnumere_field_Racine_Callback= procedure ( _e: TDOMNode) of object;

 TOpenDocument= class;

 { TStyle_DateTime }

 TStyle_DateTime
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _od: TOpenDocument; _Root: TOD_Root_Styles; _Style_Name: String);
    destructor Destroy; override;
  //Attributs
  public
    od: TOpenDocument;
    Root: TOD_Root_Styles;
    Style_Name: String;
  //Formatage
  protected
    function Find_Style: TDOMNode; virtual; abstract;
  protected
    Format_e: TDOMNode; //non r�entrant/multithread
    Format_Result: String; //non r�entrant/multithread
    function number_style_SHORT_from_(_e: TDOMNode): Boolean;
    function number_textual_from_(_e: TDOMNode): Boolean;
    function Format_from_number_style(_e: TDOMNode; _Short, _Long: String): String;
    procedure Add_Format(_Short, _Long: String);
    procedure Add_Format_textual(_Short, _Long, _Textual_Short, _Textual_Long: String);
    procedure Add_Text;
    procedure Traite_Node; virtual; abstract;
  public
    function Format: String; //non r�entrant/multithread
  end;

 TStyle_DateTime_class= class of TStyle_DateTime;

 { TStyle_Date }

 TStyle_Date
 =
  class( TStyle_DateTime)
  //Formatage
  protected
   function Find_Style: TDOMNode; override;
   procedure Traite_Node; override;
  end;

 { TStyle_Time }

 TStyle_Time
 =
  class( TStyle_DateTime)
  //Formatage
  protected
   function Find_Style: TDOMNode; override;
   procedure Traite_Node; override;
  end;


 { TOpenDocument }

 TOpenDocument
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String);
    destructor Destroy; override;
  //Extraction
  public
    Repertoire_Extraction: String;
  //Repertoire_Pictures
  private
    FRepertoire_Pictures: String;
  public
    function Repertoire_Pictures: String;
  //Persistance
  private
    procedure XML_from_Repertoire_Extraction;
    procedure Repertoire_Extraction_from_XML;
    procedure Extrait;
  public
    procedure Save;
  //Attributs
  public
    Nom: String;
    is_Calc: Boolean;
  private
    function Ensure_style_text( _NomStyle, _NomStyleParent: String;
                                          _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
    function Find_style_family_multiroot(_NomStyle: String;
      _Root: TOD_Root_Styles; _family: String): TDOMNode;
    function Find_style_text( _NomStyle: String;
                              _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
    function Find_style_text_multiroot(_NomStyle: String;
      _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
  public
    xmlMeta             : TXMLDocument;
    xmlSettings         : TXMLDocument;
    xmlMETA_INF_manifest: TXMLDocument;
    xmlContent          : TXMLDocument;
    xmlStyles           : TXMLDocument;
    function CheminFichier_temporaire( _NomFichier: String): String;
  //M�thodes d'acc�s au XML
  public
    //Text
    function Get_xmlContent_TEXT: TDOMNode;
    function Get_xmlContent_USER_FIELD_DECLS: TDOMNode;
    function Get_xmlContent_AUTOMATIC_STYLES: TDOMNode;

    function Get_xmlStyles_STYLES: TDOMNode;
    function Get_xmlStyles_AUTOMATIC_STYLES: TDOMNode;
    function Get_xmlStyles_MASTER_STYLES: TDOMNode;

    function Get_STYLES( _Root: TOD_Root_Styles): TDOMNode;

    //Spreadsheet
    function Get_xmlContent_SPREADSHEET: TDOMNode;
    function Get_xmlContent_SPREADSHEET_first_TABLE: TDOMNode;
    function Get_xmlContent_SPREADSHEET_NAMED_EXPRESSIONS: TDOMNode;
  //Gestion des properties //deprecated -> uOD_JCL
  private
    function Get_Property_Name( _e: TDOMNode; _NodeName: String): String; //deprecated -> uOD_JCL
  public
    function not_Get_Property( _e: TDOMNode;    //deprecated -> uOD_JCL
                               _NodeName: String;
                               out _Value: String): Boolean;
    function not_Test_Property( _e: TDOMNode;   //deprecated -> uOD_JCL
                                _NodeName: String;
                                _Values: array of String): Boolean;
    procedure Set_Property( _e: TDOMNode;       //deprecated -> uOD_JCL
                            _Fullname, _Value: String);
    procedure Delete_Property( _e: TDOMNode; _Fullname: String);
  //Gestion des items //deprecated -> uOD_JCL
  public
    function Cherche_Item( _eRoot: TDOMNode; _NodeName: String; //deprecated -> uOD_JCL
                           _Properties_Names,
                           _Properties_Values: array of String): TDOMNode;
    function Cherche_Item_Recursif( _eRoot: TDOMNode; //deprecated -> uOD_JCL
                                    _NodeName: String;
                                    _Properties_Names,
                                    _Properties_Values: array of String): TDOMNode;
    function Ensure_Item( _eRoot: TDOMNode; _NodeName: String;//deprecated -> uOD_JCL
                           _Properties_Names,
                           _Properties_Values: array of String): TDOMNode;
    function Add_Item( _eRoot: TDOMNode; _NodeName: String;//deprecated -> uOD_JCL
                           _Properties_Names,
                           _Properties_Values: array of String): TDOMNode;
    procedure Supprime_Item( _e: TDOMNode);//deprecated -> uOD_JCL
    procedure Copie_Item( _Source, _Cible: TDOMNode);//deprecated -> uOD_JCL
  //Gestion des noms de cellules (tableur)
  public
    function  Named_Range_Cherche( _Nom: String): TDOMNode;
    function  Named_Range_Assure ( _Nom: String): TDOMNode;
    procedure Named_Range_Set    ( _Nom, _Base_Cell, _Cell_Range: String);
  //M�thodes cr��es pour compatibilit� OOo
  private
    function Cherche_field( _Name: String): TDOMNode;
    procedure Enumere_field_Racine( _Racine_Name: String; _CallBack: TEnumere_field_Racine_Callback);
    function Find_style_family( _NomStyle: String;
                                _Root: TOD_Root_Styles;
                                _family: String): TDOMNode;
  public
    function Find_style_paragraph( _NomStyle: String;
                            _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
    function Find_style_paragraph_multiroot( _NomStyle: String;
                                     _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
    function Contient_Style_Enfant( _eRoot: TDOMNode;
                                    _NomStyleParent: String): Boolean;
    function Utilise_Style( _eRoot: TDOMNode;
                            _NomStyle: String): Boolean;
    function Style_NameFromDisplayName( _DisplayName: String): String;
    function Style_DisplayNameFromName( _Name: String): String;
    procedure Efface_Styles_Table( _NomTable: String);
  //M�thodes cr��es pour OpenDocument_DelphiReportEngine.exe
  public
    procedure Set_Field( _Name, _Value: String);
    procedure Get_Fields( _sl: TOOoStringList);
    procedure Set_Fields( _sl: TOOoStringList);
    function Field_Value( _Name: String): String;
    procedure Add_FieldGet( _Name: String);
    procedure Set_StylesXML( _Styles: String);

    procedure Add_style_table_column( _NomStyle: String; _Column_Width: double; _Relatif: Boolean);
    procedure Duplique_Style_Colonne( _NomStyle_Source, _NomStyle_Cible: String);

    function Font_size_from_Style( _NomStyle: String): Integer;
  //Styles
  private
    function  Add_style( _NomStyle, _NomStyleParent: String;
                         _Root: TOD_Root_Styles;
                         _family, _class: String): TDOMNode;
    function  Add_style_with_text_properties( _NomStyle: String;
                                              _Root: TOD_Root_Styles;
                                              _family,
                                              _class: String;
                                              _NomStyleParent: String;
                                              _Gras: Boolean;
                                              _DeltaSize: Integer;
                                              _Size: Integer;
                                              _SizePourcent: Integer): TDOMNode;
    function  Add_automatic_style( _NomStyleParent: String;
                                   _Gras: Boolean;
                                   _DeltaSize: Integer;
                                   _Size: Integer;
                                   _SizePourcent: Integer;
                                   out _eStyle: TDOMNode;
                                   _Is_Header: Boolean;
                                   _family,
                                   _class,
                                   _number_prefix: String;
                                   var _number_counter: Integer): String;
  //Styles de paragraphe
  private
    Automatic_style_paragraph_number: Integer;
  public
    function  Add_style_paragraph( _NomStyle, _NomStyleParent: String;
                            _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
    function  Ensure_style_paragraph( _NomStyle, _NomStyleParent: String;
                            _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
    procedure Rename_style_paragraph( _NomStyle_Avant, _NomStyle_Apres: String;
                                      _Root: TOD_Root_Styles= ors_xmlStyles_STYLES);
    function  Add_automatic_style_paragraph( _NomStyleParent: String;
                                        _Gras: Boolean;
                                        _DeltaSize: Integer;
                                        _Size: Integer;
                                        _SizePourcent: Integer): String; overload;
    function  Add_automatic_style_paragraph( _NomStyleParent: String;
                                        _Gras: Boolean;
                                        _DeltaSize: Integer;
                                        _Size: Integer;
                                        _SizePourcent: Integer;
                                        out _eStyle: TDOMNode;
                                        _Is_Header: Boolean): String; overload;
  //Styles de caract�res automatiques
  private
    Automatic_style_text_number: Integer;
  public
    function  Add_style_text( _NomStyle, _NomStyleParent: String;
                              _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
    function  Add_automatic_style_text( _NomStyleParent: String;
                                        _Gras: Boolean;
                                        _DeltaSize: Integer;
                                        _Size: Integer;
                                        _SizePourcent: Integer): String; overload;
    function  Add_automatic_style_text( _NomStyleParent: String;
                                        _Gras: Boolean;
                                        _DeltaSize: Integer;
                                        _Size: Integer;
                                        _SizePourcent: Integer;
                                        out _eStyle: TDOMNode;
                                        _Is_Header: Boolean): String; overload;
  //Styles de cellule automatique
  private
    slStyles_Cellule_Properties: TODStringList;
  public
    function  Ensure_automatic_style_table_cell( _NomTable: String; _X, _Y: Integer): TDOMNode;
    function  Add_automatic_style_table_cell( _NomTable: String; _X, _Y: Integer): TDOMNode;
    function  Ensure_automatic_style_table_cell_properties( _NomTable: String; _X, _Y: Integer): TDOMNode;
  //Changer le style parent d'un style donn�
  public
    procedure Change_style_parent( _NomStyle, _NomStyleParent: String);
  //Styles de date
  public
    function Find_date_style( _NomStyle: String;_Root: TOD_Root_Styles): TDOMNode;
  //Styles de Time
  public
    function Find_Time_style( _NomStyle: String;_Root: TOD_Root_Styles): TDOMNode;
  //G�n�ral
  private
    function Text_Traite_Field( FieldName, FieldContent: String;
                                CreeTextFields: Boolean): Boolean;
  public
    function Traite_Field( FieldName, FieldContent: String;
                           CreeTextFields: Boolean): Boolean;
  //Suppression des valeurs pour toute une sous-branche
  private
    procedure Field_Vide_Branche_CallBack( _e: TDOMNode);
  public
    procedure Field_Vide_Branche( _Racine_FieldName: String);
  //Propri�t�s TextDocument
  public
    function  Text_Lire  ( _Nom: String; _Default: String= ''): String;
    procedure Text_Ecrire( _Nom: String; _Valeur : String);
  //Propri�t�s Calc
  public

  //Acc�s � une cellule par son nom
  public
    procedure Calc_SetText( _Name, _Value: String);
    function  Calc_GetText( _Name: String): String;
    property  Calc_Text[ _Name: String]: String read Calc_GetText write Calc_SetText;
    function  Calc_Lire  ( _Nom: String; _Default: String= ''): String;
    procedure Calc_Ecrire( _Nom: String; _Valeur : String);
  //Contr�le d'existence d'un champ
  public
    function Existe( FieldName: String): Boolean;
  //Lecture de param�tres
  public
    function  Lire  ( _Nom: String; _Default: String= ''): String;
    procedure Ecrire( _Nom: String; _Valeur : String);
  //Destruction de champs
  public
    procedure DetruitChamp( Champ: String);
  //Gestion des noms de fichiers
  public
    function URL_from_WindowsFileName( FileName: String): String;
    function WindowsFileName_from_URL( FileName: String): String;
  //Echappement d'une chaine en XML
  public
    function Escape_XML( S: String): String;
  //Remplace les r�f�rences de champs par leur valeur
  public
    procedure Freeze_fields;
  //Enl�ve les styles inutilis�s
  private
    procedure Try_Delete_Style( _eStyle: TDOMNode);
  public
    procedure Delete_unused_styles;
  //Propri�t�s de table
  public
    function Get_Table_Properties( _NomTable: String): TDOMNode;
    function Get_Table_Width     ( _NomTable: String): String;
  //Propri�t�s de cellule
  private
    Cell_Style: String;
  public
    procedure SetCellPadding( _NomTable: String; _X, _Y: Integer; Padding_cm: double);
    procedure Apply_Cell_Style( e: TDOMNode);
  //Affichage
  (*
  private
    tShow_TimeOut: TTimer;
    Show_TimeOut: Boolean;
    procedure tShow_TimeOutTimer( Sender: TObject);
  *)
  public
    procedure Show;
  //ajout d'espaces
  public
    procedure AddSpace( _e: TDOMNode; _c: Integer);
  //Ajout de texte
  public
    procedure AddText ( _e: TDOMNode; _Value: String;
                        _Escape_XML: Boolean= False; _Gras: Boolean= False); overload;
    procedure AddText ( _Value: String;
                        _Escape_XML: Boolean= False; _Gras: Boolean= False); overload;
    function Append_SOFT_PAGE_BREAK( _eRoot: TDOMNode): TDOMNode;
  //Largeur_imprimable
  public
    function Largeur_Imprimable: double;
  //Entete
  public
    function FirstHeader: TDOMNode;
  //Style caract�res gras
  public
    Name_style_text_bold: String;
    procedure Ensure_style_text_bold;
  //Embed_Image
  private
    slEmbed_Image: TslDimensions_Image;
    Embed_Image_counter: Cardinal;
    Embed_Image_counter_New_name: String;
    procedure Manifeste(_FullPath, _Extension: String);
    function Embed_Image_New_name_exists: Boolean;
    function Embed_Image_New: String;
  public
    function Embed_Image( _NomFichier: String): TDimensions_Image;
  end;

//Gestion tables
function Cree_table( _e: TDOMNode; _Nom: String):TDOMNode;

function CellName_from_XY( X, Y: Integer): String;
procedure XY_from_CellName( CellName: String; var X, Y: Integer);

function RangeName_from_Rect( Left, Top, Right, Bottom: Integer): String;

function MulDiv( Nombre, Numerateur, Denominateur: Integer): Integer;

implementation

function MulDiv( Nombre, Numerateur, Denominateur: Integer): Integer;
begin
     Result:= (Nombre*Numerateur) div Denominateur;
end;

function CellName_from_XY( X, Y: Integer): String;
   procedure Traite_X;
   var
      ln26: Integer;
      I: Integer;
      Value: Integer;
      Power26: Integer;
      Digit: Integer;
      procedure TraiteDigit;
      begin
           Result:= Result + Chr(Ord('A')+Digit-1);
      end;
   begin
        Value:= X+1;
        ln26:= Trunc( LogN( 26, Value));
        for I:= ln26 downto 0
        do
          begin
          Power26:= Trunc( IntPower( 26, I));
          Digit:= Value div Power26;
          Value:= Value mod Power26;
          TraiteDigit;
          end;
   end;
   procedure Traite_Y;
   begin
        Result:=  Result + IntToStr(Y+1);
   end;
begin
     Result:= '';
     Traite_X;
     Traite_Y;
end;

type
  EXY_from_CellName_Exception= class( Exception);

procedure XY_from_CellName( CellName: String; var X, Y: Integer);
var
   I: Integer;
   sX, sY: String;
   procedure Traite_sX;
   var
      LsX: Integer;
      J: Integer;
      C: Char;
      Value: Integer;
   begin
        X:= 0;
        LsX:= Length( sX);
        for J:= 0 to LsX-1
        do
          begin
          C:= sX[ LsX-J];
          Value:= Ord(C)-Ord('A')+1;
          X:= X + Trunc(Value * IntPower( 26, J));
          end;
   end;
   procedure Traite_sY;
   begin
        if not TryStrToInt( sY, Y)
        then
            raise EXY_from_CellName_Exception
                  .
                   Create(  'La syntaxe du num�ro de ligne ('+sY+') '
                           +'est incorrecte dans '
                           +'la r�f�rence de cellule ('+CellName+')');
   end;
begin
     CellName:= UpperCase( CellName);
     sX:= '';
     sY:= '';
     I:= 1;
     while     (I < Length(CellName))
           and (CellName[I] in ['A'..'Z'])
     do
       Inc( I);
     sX:= Copy( CellName, 1, I-1);
     sY:= Copy( CellName, I, Length(CellName));

     Traite_sX;
     Traite_sY;
     Dec(X);
     Dec(Y);
end;

function RangeName_from_Rect( Left, Top, Right, Bottom: Integer): String;
begin
     Result:=  CellName_from_XY( Left , Top   )
              +':'
              +CellName_from_XY( Right, Bottom);
end;

function Cree_table( _e: TDOMNode; _Nom: String):TDOMNode;
begin
     //Result:= Cree_path( _e, 'text:p/table:table');
     Result:= Cree_path( _e, 'table:table');
     if Result = nil then exit;

     Set_Property( Result, 'table:name', _Nom);
     Cree_path( Result, 'table:table-header-rows/table:table-row/table:table-cell');
     Cree_path( Result,                         'table:table-row/table:table-cell');

end;

{ TStyle_DateTime }

constructor TStyle_DateTime.Create(_od: TOpenDocument; _Root: TOD_Root_Styles; _Style_Name: String);
begin
     inherited Create;
     od        := _od        ;
     Root      := _Root      ;
     Style_Name:= _Style_Name;
end;

destructor TStyle_DateTime.Destroy;
begin
     inherited Destroy;
end;

function TStyle_DateTime.number_style_SHORT_from_( _e: TDOMNode): Boolean;
var
   sNUMBER_STYLE: String;
begin
     Result:= True;
     if not_Get_Property( _e, 'number:style', sNUMBER_STYLE) then exit;

     Result:= 'short' = sNUMBER_STYLE;
end;

function TStyle_DateTime.number_textual_from_( _e: TDOMNode): Boolean;
var
   sNUMBER_TEXTUAL: String;
begin
     Result:= False;
     if not_Get_Property( _e, 'number:textual', sNUMBER_TEXTUAL) then exit;

     Result:= 'true' = sNUMBER_TEXTUAL;
end;

function TStyle_DateTime.Format_from_number_style( _e: TDOMNode; _Short, _Long: String): String;
var
   IsShort: Boolean;
begin
     IsShort:= number_style_SHORT_from_( _e);
     if IsShort
     then
         Result:= _Short
     else
         Result:= _Long;
end;

procedure TStyle_DateTime.Add_Format( _Short, _Long: String);
begin
     Format_Result:= Format_Result+ Format_from_number_style( Format_e, _Short, _Long);
end;

procedure TStyle_DateTime.Add_Format_textual( _Short, _Long, _Textual_Short, _Textual_Long: String);
var
   IsTextual: Boolean;
begin
     IsTextual:= number_textual_from_( Format_e);
     if IsTextual
     then
         Add_Format( _Textual_Short, _Textual_Long)
     else
         Add_Format( _Short, _Long);
end;

procedure TStyle_DateTime.Add_Text;
var
   Text: String;
begin
     Text:= Text_from_path( Format_e,'');
     if '' = Text then Text:= ' ';
     Format_Result:= Format_Result+ '"'+Text+'"';
end;

function TStyle_DateTime.Format: String;
var
   eStyle: TDOMNode;
   I: Integer;
begin
     Result:= '';
     Format_Result:= '';

     eStyle:= Find_Style;
     if nil = eStyle then exit;

     for I:= 0 to eStyle.ChildNodes.Count-1
     do
       begin
       Format_e:= eStyle.ChildNodes.Item[ I];
       if nil = Format_e then continue;

       Traite_Node;
       end;

     Result:= Format_Result;
end;

{ TStyle_Date }

function TStyle_Date.Find_Style: TDOMNode;
begin
     Result:= od.Find_date_style( Style_Name, Root);
     if Assigned( Result) or (Root = ors_xmlStyles_AUTOMATIC_STYLES) then exit;

     Result:= od.Find_date_style( Style_Name, ors_xmlStyles_AUTOMATIC_STYLES);
end;

procedure TStyle_Date.Traite_Node;
var
   NodeName: String;
begin
     NodeName:= Format_e.NodeName;
          if NodeName =  'number:day'         then Add_Format        ( 'd'  , 'dd'  )
     else if NodeName =  'number:day-of-week' then Add_Format        ( 'ddd', 'dddd')
     else if NodeName =  'number:month'       then Add_Format_textual( 'm'  , 'mm'  , 'mmm', 'mmmm')
     else if NodeName =  'number:year'        then Add_Format        ( 'yy' , 'yyyy')
     else if NodeName =  'number:text'        then Add_Text;
end;

{ TStyle_Time }

function TStyle_Time.Find_Style: TDOMNode;
begin
     Result:= od.Find_Time_style( Style_Name, Root);
     if Assigned( Result) or (Root = ors_xmlStyles_AUTOMATIC_STYLES) then exit;

     Result:= od.Find_Time_style( Style_Name, ors_xmlStyles_AUTOMATIC_STYLES);
end;

procedure TStyle_Time.Traite_Node;
var
   NodeName: String;
begin
     NodeName:= Format_e.NodeName;
          if NodeName =  'number:hours'       then Add_Format( 'h', 'hh')
     else if NodeName =  'number:minutes'     then Add_Format( 'n', 'nn')
     else if NodeName =  'number:seconds'     then Add_Format( 's', 'ss')
     else if NodeName =  'number:am-pm'       then Add_Format( 'am/pm', 'am/pm')
     else if NodeName =  'number:text'        then Add_Text;
end;

{ TODStringList }

(*function TODStringList.CompareStrings(const S1, S2: String): Integer;
begin
     Result:= CompareStr( S1, S2);
end;*)

{ TOpenDocument }

constructor TOpenDocument.Create( _Nom: String);
var
   I: Integer;
   procedure Calcule_is_Calc;
   var
      Ext: String;
   begin
        Ext:= UpperCase( ExtractFileExt( Nom));
        is_Calc
        :=
            ('.OTS' = Ext)
          or('.ODS' = Ext);
   end;
begin
     Automatic_style_paragraph_number:= 0;
     Automatic_style_text_number:= 0;
     Nom:= _Nom;
     Calcule_is_Calc;

     slStyles_Cellule_Properties:= TODStringList.Create;

     Extrait;

     XML_from_Repertoire_Extraction;
     Embed_Image_counter:= 0;
     slEmbed_Image:= TslDimensions_Image.Create( ClassName+'.slEmbed_Image');
end;

destructor TOpenDocument.Destroy;
begin
     FreeAndNil( slEmbed_Image       );
     FreeAndNil( xmlMeta             );
     FreeAndNil( xmlSettings         );
     FreeAndNil( xmlMETA_INF_manifest);
     FreeAndNil( xmlContent          );
     FreeAndNil( xmlStyles           );
     FreeAndNil( slStyles_Cellule_Properties);

     ChDir( ExtractFilePath( Nom));
     //OD_Temporaire.DetruitRepertoire( Repertoire_Extraction);

     inherited;
end;

const
     sPictures='Pictures';

function TOpenDocument.Repertoire_Pictures: String;
begin
     if '' = FRepertoire_Pictures
     then
         FRepertoire_Pictures
         :=
           IncludeTrailingPathDelimiter( Repertoire_Extraction)
           +sPictures+PathDelim;
     Result:= FRepertoire_Pictures;
end;

procedure TOpenDocument.XML_from_Repertoire_Extraction;
   procedure Cree_XML( _FileName: String; var _xml: TXMLDocument);
   var
      NomFichier: String;
   begin
        NomFichier:= IncludeTrailingPathDelimiter( Repertoire_Extraction)+_FileName;
        ReadXMLFile( _xml, NomFichier);
        (*_xml.IndentString:= '  ';
        with _xml do Options:= Options + [sxoAutoEncodeValue];*)

        OOoChrono.Stop( 'Chargement en objet du fichier xml '+_FileName);
   end;
begin
     Cree_XML( 'meta.xml'             , xmlMeta             );
     Cree_XML( 'settings.xml'         , xmlSettings         );
     Cree_XML( 'META-INF'+PathDelim+'manifest.xml', xmlMETA_INF_manifest);
     Cree_XML( 'content.xml'          , xmlContent          );
     Cree_XML( 'styles.xml'           , xmlStyles           );
end;

procedure TOpenDocument.Repertoire_Extraction_from_XML;
   procedure Sauve_XML( _FileName: String; var _xml: TXMLDocument);
   var
      NomFichier: String;
   begin
        NomFichier:= IncludeTrailingPathDelimiter( Repertoire_Extraction)+_FileName;
        WriteXMLFile( _xml, NomFichier);
   end;
begin
     Sauve_XML( 'meta.xml'             , xmlMeta             );
     Sauve_XML( 'settings.xml'         , xmlSettings         );
     Sauve_XML( 'META-INF'+PathDelim+'manifest.xml', xmlMETA_INF_manifest);
     Sauve_XML( 'content.xml'          , xmlContent          );
     Sauve_XML( 'styles.xml'           , xmlStyles           );
end;

procedure TOpenDocument.Extrait;
var
   UnZipper: TUnZipper;
begin
     Repertoire_Extraction:= OD_Temporaire.Nouveau_Repertoire('OD');
     FRepertoire_Pictures:= '';
     UnZipper := TUnZipper.Create;
     try
        UnZipper.FileName := Nom;
        UnZipper.OutputPath := Repertoire_Extraction;
        UnZipper.Examine;
        UnZipper.UnZipAllFiles;
     finally
            UnZipper.Free;
            end;
     OOoChrono.Stop( 'Extraction des fichiers xml');
end;

procedure TOpenDocument.Save;
var
   Zipper: TZipper;
   procedure Ajoute_SousRepertoire( _SousRepertoire: String);
   var
      F: TSearchRec;
      Erreur: Integer;
      DiskDirPath,
      ZipDirPath,
      DiskFileName,
      ZipFileName: String;
   begin
        ZipDirPath:= _SousRepertoire;
        DiskDirPath:= IncludeTrailingPathDelimiter( Repertoire_Extraction)
                            +_SousRepertoire;
        if 0 = FindFirst( DiskDirPath+'*', faAnyFile, F)
        then
            repeat
                  DiskFileName:= DiskDirPath+F.Name;
                  ZipFileName := ZipDirPath+F.Name;
                  if (F.Attr and faDirectory) = faDirectory
                  then
                      begin
                      if     (F.Name <> '.')
                         and (F.Name <> '..')
                      then
                          Ajoute_SousRepertoire( ZipFileName+PathDelim)
                      end
                  else
                      Zipper.Entries.AddFileEntry( DiskFileName, ZipFileName);
            until FindNext(F)<>0;
        FindClose( F);
   end;
begin
     Repertoire_Extraction_from_XML;
     Zipper := TZipper.Create;
     try
        Zipper.FileName := Nom;
        Ajoute_SousRepertoire( '');
        Zipper.ZipAllFiles;
     finally
            Zipper.Free;
            end;
end;

function TOpenDocument.CheminFichier_temporaire( _NomFichier: String): String;
begin
     Result:= IncludeTrailingPathDelimiter( Repertoire_Extraction)+_NomFichier;
end;

const
     URL_file_prefix= 'file:///';

function TOpenDocument.URL_from_WindowsFileName(FileName: String): String;
var
   I: Integer;
begin
     Result:= FileName;
     for I:= 1 to Length( Result)
     do
       if Result[I]= '\'
       then
           Result[I]:= '/';
     Result:= URL_file_prefix+Result;
end;

function TOpenDocument.WindowsFileName_from_URL( FileName: String): String;
var
   I: Integer;
begin
     Result:= FileName;
     if 1 = Pos( URL_file_prefix, Result)
     then
         Delete( Result, 1, Length( URL_file_prefix));
     for I:= 1 to Length( Result)
     do
       if Result[I]= '/'
       then
           Result[I]:= '\';
end;

procedure TOpenDocument.Manifeste( _FullPath, _Extension: String);
var
   root, e: TDOMNode;
begin
     //==> META-INF/manifest.xml
     //  <manifest:manifest manifest:version="1.2">
     //     <manifest:file-entry manifest:full-path="Pictures/1000020100000064000000323F4469E66C808866.png" manifest:media-type="image/png"/>
     root:= xmlMETA_INF_manifest.DocumentElement;
     e:= Cherche_Item_Recursif( root,
                                'manifest:file-entry',
                                ['manifest:full-path'],
                                [_FullPath]);
    if Assigned(e) then exit;

    Add_Item( root,
              'manifest:file-entry',
              ['manifest:full-path'],
              [_FullPath]);
end;

function TOpenDocument.Embed_Image_New_name_exists: Boolean;
var
   sr: TSearchRec;
   sWildCards: String;
begin
     {$IFDEF WINDOWS}
     sWildCards:= '*.*';
     {$ELSE}
     sWildCards:= '*';
     {$ENDIF}
     Embed_Image_counter_New_name
     :=
       IntToHex( Embed_Image_counter, 40);
     Result:= 0 = FindFirst( Repertoire_Pictures+Embed_Image_counter_New_name+sWildCards, faAnyFile, sr);
     FindClose( sr);
end;

function TOpenDocument.Embed_Image_New: String;
begin
     while Embed_Image_New_name_exists
     do
       Inc( Embed_Image_counter);
     Result:= Embed_Image_counter_New_name;
end;

function TOpenDocument.Embed_Image( _NomFichier: String): TDimensions_Image;
var
   iEmbed_Image: Integer;
   procedure Copie_dans_Pictures;
   var
      Extension: String;
      sFileName: String;
      sRepertoirePictures: String;
      sNomFichierCible: String;
      sURL: String;
   begin
        sRepertoirePictures
        :=
           IncludeTrailingPathDelimiter(Repertoire_Extraction)
          +sPictures;
        ForceDirectories( sRepertoirePictures);

        Extension:= ExtractFileExt( _NomFichier);

        sFileName:= Embed_Image_New+Extension;
        //sFileName:= ExtractFileName( _NomFichier);

        sURL:= sPictures+'/'+sFileName;
        Manifeste( sURL, Extension);

        sNomFichierCible:= Repertoire_Pictures+sFileName;

        CopyFile( _NomFichier, sNomFichierCible);

        Result:= TDimensions_Image.Create( sNomFichierCible, sURL);
        slEmbed_Image.AddObject( _NomFichier, Result);
   end;
begin
     Result:= nil;
     if not FileExists( _NomFichier) then exit;

     Result:= Dimensions_Image_from_sl_sCle( slEmbed_Image, _NomFichier);
     if Assigned( Result) then exit;

     Copie_dans_Pictures;
end;

function TOpenDocument.Get_xmlContent_TEXT: TDOMNode;
begin
     Result:= Elem_from_path( xmlContent.DocumentElement, 'office:body/office:text')
end;

function TOpenDocument.Get_xmlContent_USER_FIELD_DECLS: TDOMNode;
const
     USER_FIELD_DECLS_path='office:body/office:text/text:user-field-decls';
begin
     Result:= Elem_from_path( xmlContent.DocumentElement, USER_FIELD_DECLS_path);
     if Assigned( Result) then exit;

     Result:= Cree_path( xmlContent.DocumentElement, USER_FIELD_DECLS_path);
end;

function TOpenDocument.Get_xmlContent_AUTOMATIC_STYLES: TDOMNode;
begin
     Result:= Elem_from_path( xmlContent.DocumentElement, 'office:automatic-styles');
end;

function TOpenDocument.Get_xmlContent_SPREADSHEET: TDOMNode;
begin
     Result
     :=
       Elem_from_path( xmlContent.DocumentElement,
                       'office:body/office:spreadsheet');
end;

function TOpenDocument.Get_xmlContent_SPREADSHEET_first_TABLE: TDOMNode;
var
   eRoot: TDOMNode;
   e: TDOMNode;
   I: Integer;
begin
     Result:= nil;
     eRoot:= Get_xmlContent_SPREADSHEET;

     for I:= 0 to eRoot.ChildNodes.Count -1
     do
       begin
       e:= eRoot.ChildNodes.Item[0];
       if e = nil then continue;

       if 'table' = Name_from_FullName( e.NodeName)
       then
           begin
           Result:= e;
           break;
           end;
       end;
end;

function TOpenDocument.Get_xmlContent_SPREADSHEET_NAMED_EXPRESSIONS: TDOMNode;
begin
     Result
     :=
       Elem_from_path( xmlContent.DocumentElement,
                       'office:body/office:spreadsheet/table:named-expressions');
end;

function TOpenDocument.Get_xmlStyles_STYLES: TDOMNode;
begin
     Result:= Elem_from_path( xmlStyles.DocumentElement,'office:styles')
end;

function TOpenDocument.Get_xmlStyles_AUTOMATIC_STYLES: TDOMNode;
begin
     Result:= Elem_from_path( xmlStyles.DocumentElement, 'office:automatic-styles');
end;

function TOpenDocument.Get_xmlStyles_MASTER_STYLES: TDOMNode;
begin
     Result:= Elem_from_path( xmlStyles.DocumentElement, 'office:master-styles');
end;

function TOpenDocument.Get_Property_Name( _e: TDOMNode; _NodeName: String): String;
begin
     Result:= uOD_JCL.Get_Property_Name( _e, _NodeName);
end;

function TOpenDocument.not_Get_Property( _e: TDOMNode;
                                         _NodeName: String;
                                         out _Value: String): Boolean;
begin
     Result:= uOD_JCL.not_Get_Property( _e, _NodeName, _Value);
end;

function TOpenDocument.not_Test_Property( _e: TDOMNode;
                                          _NodeName: String;
                                          _Values: array of String): Boolean;
begin
     Result:= uOD_JCL.not_Test_Property( _e, _NodeName, _Values);
end;

procedure TOpenDocument.Set_Property( _e: TDOMNode;
                                      _Fullname, _Value: String);
begin
     uOD_JCL.Set_Property( _e, _Fullname, _Value);
end;

procedure TOpenDocument.Delete_Property( _e: TDOMNode; _Fullname: String);
begin
     uOD_JCL.Delete_Property( _e, _Fullname);
end;

procedure TOpenDocument.Set_Field( _Name, _Value: String);
var
   e: TDOMNode;
begin
     e:= Ensure_Item( Get_xmlContent_USER_FIELD_DECLS, 'text:user-field-decl',
                      ['text:name'],
                      [_Name      ]
                    );
     if e= nil then exit;

     Set_Property( e, 'office:value-type'  , 'string');
     Set_Property( e, 'office:string-value', _Value  );
end;

procedure TOpenDocument.Get_Fields( _sl: TOOoStringList);
var
   eUSER_FIELD_DECLS: TDOMNode;
   I: Integer;
   e: TDOMNode;
   Name, String_Value: String;
begin
     _sl.Clear;

     eUSER_FIELD_DECLS:= Get_xmlContent_USER_FIELD_DECLS;
     if eUSER_FIELD_DECLS = nil then exit;

     for I:= 0 to eUSER_FIELD_DECLS.ChildNodes.Count - 1
     do
       begin
       e:= eUSER_FIELD_DECLS.ChildNodes.Item[ I];
       if e = nil                     then continue;
       if e.NodeName <> 'text:user-field-decl' then continue;

       if not_Get_Property( e, 'text:name'          , Name        ) then continue;
       if not_Get_Property( e, 'office:string-value', String_Value) then continue;

       _sl.Add(Name+'='+String_Value);
       end;
     OOoChrono.Stop( 'Extraction des TextFields');
end;

procedure TOpenDocument.Set_Fields( _sl: TOOoStringList);
var
   eUSER_FIELD_DECLS: TDOMNode;
   I: Integer;
   Line, FieldName, Value: String;
   e: TDOMNode;
   s: TStringStream;

begin
     eUSER_FIELD_DECLS:= Get_xmlContent_USER_FIELD_DECLS;
     if eUSER_FIELD_DECLS = nil then exit;

     RemoveChilds( eUSER_FIELD_DECLS);

     for I:= 0 to _sl.Count - 1
     do
       begin
       Line     := _sl.Strings[I];
       FieldName:= StrTok( '=', Line);
       Value    := Line;

       e:= Cree_path( eUSER_FIELD_DECLS, 'text:user-field-decl');
       if e= nil then continue;


       Set_Property( e, 'office:value-type'  ,'string'  );
       Set_Property( e, 'office:string-value', Value    );
       Set_Property( e, 'text:name'          , FieldName);
       end;

     (*s:= TStringStream.Create( xmlContent.SaveToString);
     try
        F.AddFile( 'content.xml', s);
        F.Compress;
     finally
            FreeAndNil( s);
            end;*)
end;

procedure TOpenDocument.Add_FieldGet( _Name: String);
var
   eTEXT: TDOMNode;
   eP: TDOMNode;
   eUSER_FIELD_GET: TDOMNode;
begin
     eTEXT:= Get_xmlContent_TEXT;
     if eTEXT = nil then exit;

     eP:= Cree_path( eTEXT, 'text:p');
     if eP = nil then exit;

     eUSER_FIELD_GET:= Cree_path( eP, 'text:user-field-get');
     if eUSER_FIELD_GET = nil then exit;

     Set_Property( eUSER_FIELD_GET, 'text:name', _Name);
end;

procedure TOpenDocument.Set_StylesXML( _Styles: String);
var
   s: TStringStream;
begin
     (*xmlStyles.LoadFromString( _Styles);
     s:= TStringStream.Create( xmlStyles.SaveToString);
     try
        F.AddFile( 'styles.xml', s);
        F.Compress;
     finally
            FreeAndNil( s);
            end;*)
end;

function TOpenDocument.Get_STYLES( _Root: TOD_Root_Styles): TDOMNode;
begin
     case _Root
     of
       ors_xmlStyles_STYLES           : Result:= Get_xmlStyles_STYLES;
       ors_xmlStyles_AUTOMATIC_STYLES : Result:= Get_xmlStyles_AUTOMATIC_STYLES;
       ors_xmlContent_AUTOMATIC_STYLES: Result:= Get_xmlContent_AUTOMATIC_STYLES;
       else                             Result:= nil;
       end;
end;

function TOpenDocument.Add_style( _NomStyle,
                                  _NomStyleParent: String;
                                  _Root: TOD_Root_Styles;
                                  _family, _class: String): TDOMNode;
var
   Name: String;
   Parent_Style_Name: String;
   eSTYLES: TDOMNode;
   e: TDOMNode;
begin
     Result:= nil;
     Name             := Style_NameFromDisplayName( _NomStyle      );
     Parent_Style_Name:= Style_NameFromDisplayName( _NomStyleParent);

     eSTYLES:= Get_STYLES( _Root);
     if eSTYLES = nil then exit;

     e:= Cree_path( eSTYLES, 'style:style');
     if e= nil then exit;

     Set_Property(e, 'style:name'             , Name             );
     Set_Property(e, 'style:display-name'     , _NomStyle        );
     Set_Property(e, 'style:parent-style-name', Parent_Style_Name);
     Set_Property(e, 'style:family'           , _family          );
     if _class <> ''
     then
     	 Set_Property(e, 'style:class'        , _class           );

     Result:= e;
end;

function TOpenDocument.Add_style_paragraph( _NomStyle, _NomStyleParent: String;
                                            _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
begin
     Result:= Add_style( _NomStyle, _NomStyleParent, _Root, 'paragraph','text');
end;

function TOpenDocument.Add_style_text( _NomStyle, _NomStyleParent: String; _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
begin
     Result:= Add_style( _NomStyle, _NomStyleParent, _Root, 'text','');
end;

function TOpenDocument.Add_style_with_text_properties(_NomStyle: String;
 _Root: TOD_Root_Styles; _family, _class: String; _NomStyleParent: String;
 _Gras: Boolean; _DeltaSize: Integer; _Size: Integer; _SizePourcent: Integer
 ): TDOMNode;
var
   eTEXT_PROPERTIES: TDOMNode;
   Font_size: Integer;
   sFont_Size: String;
begin
     Result:= Add_style( _NomStyle, _NomStyleParent, _Root, _family, _class);
     if Result = nil then exit;

     eTEXT_PROPERTIES:= Ensure_Item(Result, 'style:text-properties', [], []);
     if eTEXT_PROPERTIES = nil then exit;

     if _Gras
     then
         Set_Property( eTEXT_PROPERTIES, 'fo:font-weight', 'bold');

     if _Size <> 0
     then
         begin
         sFont_Size:= IntToStr( _Size)+'pt';
         Set_Property( eTEXT_PROPERTIES, 'fo:font-size', sFont_Size);
         end;

     if _DeltaSize <> 0
     then
         begin
         Font_size:= Font_size_from_Style( _NomStyleParent);
         if Font_size <> 0
         then
             begin
             Font_size:= Font_size + _DeltaSize;
             sFont_Size:= IntToStr( Font_size)+'pt';
             Set_Property( eTEXT_PROPERTIES, 'fo:font-size', sFont_Size);
             end;
         end;
     if _SizePourcent <> 100
     then
         begin
         Font_size:= Font_size_from_Style( _NomStyleParent);
         if Font_size <> 0
         then
             begin
             Font_size:= MulDiv( Font_size , _SizePourcent, 100);
             sFont_Size:= IntToStr( Font_size)+'pt';
             Set_Property( eTEXT_PROPERTIES, 'fo:font-size', sFont_Size);
             end;
         end;
end;

function TOpenDocument.Add_automatic_style(_NomStyleParent: String;
 _Gras: Boolean; _DeltaSize: Integer; _Size: Integer; _SizePourcent: Integer;
 out _eStyle: TDOMNode; _Is_Header: Boolean; _family, _class,
 _number_prefix: String; var _number_counter: Integer): String;
var
   Style_Root: TOD_Root_Styles;
   eTEXT_PROPERTIES: TDOMNode;
   Font_size: Integer;
   sFont_Size: String;
begin
     Result:= _number_prefix+IntToStr( _number_counter);

     if _Is_Header
     then
         Style_Root:= ors_xmlStyles_AUTOMATIC_STYLES
     else
         Style_Root:= ors_xmlContent_AUTOMATIC_STYLES;

     _eStyle
     :=
       Add_style_with_text_properties( Result,
                                       Style_Root,
                                       _family,
                                       _class,
                                       _NomStyleParent,
                                       _Gras,
                                       _DeltaSize,
                                       _Size,
                                       _SizePourcent
                                       );

     Inc( _number_counter);
end;


function TOpenDocument.Add_automatic_style_paragraph(_NomStyleParent: String;
 _Gras: Boolean; _DeltaSize: Integer; _Size: Integer; _SizePourcent: Integer;
 out _eStyle: TDOMNode; _Is_Header: Boolean): String;
begin
     Result:= Add_automatic_style( _NomStyleParent,
                                   _Gras,
                                   _DeltaSize,
                                   _Size,
                                   _SizePourcent,
                                   _eStyle,
                                   _Is_Header,
                                   'paragraph',
                                   'text',
                                   'ODP',
                                   Automatic_style_paragraph_number);
end;

function TOpenDocument.Add_automatic_style_text(_NomStyleParent: String;
 _Gras: Boolean; _DeltaSize: Integer; _Size: Integer; _SizePourcent: Integer;
 out _eStyle: TDOMNode; _Is_Header: Boolean): String;
begin
     Result:= Add_automatic_style( _NomStyleParent,
                                   _Gras,
                                   _DeltaSize,
                                   _Size,
                                   _SizePourcent,
                                   _eStyle,
                                   _Is_Header,
                                   'text',
                                   '',
                                   'ODT',
                                   Automatic_style_text_number);
end;

function TOpenDocument.Add_automatic_style_paragraph( _NomStyleParent: String;
                                                      _Gras: Boolean;
                                                      _DeltaSize: Integer;
                                                      _Size: Integer;
                                                      _SizePourcent: Integer): String;
var
   e: TDOMNode;
begin
     Result:= Add_automatic_style_paragraph( _NomStyleParent,
                                             _Gras,
                                             _DeltaSize,
                                             _Size,
                                             _SizePourcent,
                                             e,
                                             False);
end;

function TOpenDocument.Add_automatic_style_text( _NomStyleParent: String;
                                                      _Gras: Boolean;
                                                      _DeltaSize: Integer;
                                                      _Size: Integer;
                                                      _SizePourcent: Integer): String;
var
   e: TDOMNode;
begin
     Result:= Add_automatic_style_text( _NomStyleParent,
                                             _Gras,
                                             _DeltaSize,
                                             _Size,
                                             _SizePourcent,
                                             e,
                                             False);
end;

function TOpenDocument.Font_size_from_Style( _NomStyle: String): Integer;
var
   eSTYLE: TDOMNode;
   NomStyle_Parent: String;

   eTEXT_PROPERTIES: TDOMNode;
   sFont_Size: String;
begin
     Result:= 0;
     eSTYLE:= Find_style_paragraph_multiroot( _NomStyle, ors_xmlContent_AUTOMATIC_STYLES);
     if eSTYLE = nil then exit;

     if not_Get_Property( eSTYLE, 'style:parent-style-name', NomStyle_Parent)
     then
         NomStyle_Parent:= '';

     eTEXT_PROPERTIES:= Cherche_Item( eSTYLE, 'style:text-properties', [], []);
     if eTEXT_PROPERTIES = nil then exit;

     if not_Get_Property( eTEXT_PROPERTIES, 'fo:font-size', sFont_Size)
     then
         begin
         if NomStyle_Parent = ''
         then
             exit
         else
             Result:= Font_size_from_Style( NomStyle_Parent);
         end
     else
         begin
         //"8pt"
         Delete( sFont_Size, Length( sFont_Size)-1, 2);
         if not TryStrToInt( sFont_Size, Result)
         then
             Result:= 0;
         end;
end;

function TOpenDocument.Get_Table_Properties( _NomTable: String): TDOMNode;
var
   eSTYLES: TDOMNode;
   eSTYLE: TDOMNode;
begin
     Result:= nil;
     eSTYLES:= Get_xmlContent_AUTOMATIC_STYLES;
     if eSTYLES = nil then exit;

     eSTYLE
     :=
       Ensure_Item( eSTYLES,
                    'style:style',
                    ['style:name','style:family'],
                    [_NomTable   ,'table'       ]);
     if eSTYLE = nil then exit;

     Result:= Ensure_Item( eSTYLE,'style:table-properties',[],[]);
end;

function TOpenDocument.Get_Table_Width(_NomTable: String): String;
var
   eTABLE_PROPERTIES: TDOMNode;
begin
     Result:= '';
     eTABLE_PROPERTIES:= Get_Table_Properties( _NomTable);
     not_Get_Property( eTABLE_PROPERTIES, 'style:width', Result);
end;

procedure TOpenDocument.SetCellPadding( _NomTable: String; _X, _Y: Integer; Padding_cm: double);
var
   eTABLE_CELL_PROPERTIES: TDOMNode;
   sPadding: String;
begin
     eTABLE_CELL_PROPERTIES:= Ensure_automatic_style_table_cell_properties( _NomTable, _X, _Y);

     Str( Padding_cm:5:3, sPadding);
     sPadding:= sPadding + 'cm';

     Set_Property( eTABLE_CELL_PROPERTIES, 'fo:padding', sPadding);

     //<style:table-cell-properties fo:padding="0cm" fo:border-left="" fo:border-right="none" fo:border-top="0.05pt dotted #000000" fo:border-bottom="0.05pt solid #000000"/>
end;

procedure TOpenDocument.Apply_Cell_Style( e: TDOMNode);
begin
     Set_Property( e, 'table:style-name', Cell_Style);
end;


procedure TOpenDocument.Add_style_table_column( _NomStyle: String; _Column_Width: double; _Relatif: Boolean);
var
   eSTYLES: TDOMNode;
   eSTYLE: TDOMNode;

   eTABLE_COLUMN_PROPERTIES: TDOMNode;

   sColumn_Width: String;

   Rel_Column_Width: Integer;
   sRel_Column_Width: String;
begin
     eSTYLES:= Get_xmlContent_AUTOMATIC_STYLES;
     if eSTYLES = nil then exit;

     eSTYLE
     :=
       Ensure_Item( eSTYLES,
                    'style:style',
                    ['style:name','style:family'],
                    [_NomStyle   ,'table-column']);
     if eSTYLE = nil then exit;

     eTABLE_COLUMN_PROPERTIES
     :=
       Ensure_Item( eSTYLE,'style:table-column-properties',[],[]);
     if eTABLE_COLUMN_PROPERTIES= nil then exit;

     Delete_Property( eTABLE_COLUMN_PROPERTIES, 'column-width');
     Delete_Property( eTABLE_COLUMN_PROPERTIES, 'rel-column-width');

     if _Relatif
     then
         begin
         Rel_Column_Width:= Trunc( _Column_Width);
         sRel_Column_Width:= IntToStr( Rel_Column_Width)+'*';
         Set_Property( eTABLE_COLUMN_PROPERTIES, 'style:rel-column-width', sRel_Column_Width);
         end
     else
         begin
         Str( _Column_Width:5:3,sColumn_Width);
         sColumn_Width:= sColumn_Width+'cm';
         Set_Property( eTABLE_COLUMN_PROPERTIES, 'style:column-width', sColumn_Width);
         end;

end;

procedure TOpenDocument.Duplique_Style_Colonne( _NomStyle_Source, _NomStyle_Cible: String);
var
   eSTYLES: TDOMNode;

   eSTYLE_Source, eSTYLE_Cible: TDOMNode;
begin
     eSTYLES:= Get_xmlContent_AUTOMATIC_STYLES;
     if eSTYLES = nil then exit;

     eSTYLE_Source
     :=
       Cherche_Item( eSTYLES,
                    'style:style',
                    ['style:name'    ,'style:family'],
                    [_NomStyle_Source,'table-column']);
     if eSTYLE_Source = nil then exit;

     eSTYLE_Cible
     :=
       Ensure_Item( eSTYLES,
                    'style:style',
                    ['style:name'   ,'style:family'],
                    [_NomStyle_Cible,'table-column']);
     if eSTYLE_Cible = nil then exit;

     Copie_Item( eSTYLE_Source, eSTYLE_Cible);
     Set_Property( eSTYLE_Cible, 'style:name', _NomStyle_Cible);//�cras� par Copie_Item
end;

function TOpenDocument.Ensure_style_paragraph( _NomStyle, _NomStyleParent: String;
                                               _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
var
   StyleName: String;
begin
     Result:= Find_style_paragraph( _NomStyle, _Root);

     if nil = Result
     then
         Result:= Add_style_paragraph( _NomStyle, _NomStyleParent, _Root)
     else
         begin
         StyleName:= Style_NameFromDisplayName(_NomStyleParent);
         if not_Test_Property( Result, 'style:parent-style-name', StyleName)
         then
             begin
             Set_Property( Result, 'style:class', 'text');
             Set_Property( Result, 'style:parent-style-name', StyleName);
             end;
         end;
end;

procedure TOpenDocument.Rename_style_paragraph( _NomStyle_Avant, _NomStyle_Apres: String;
                                               _Root: TOD_Root_Styles= ors_xmlStyles_STYLES);
var
   e: TDOMNode;
   StyleName_Apres: String;
begin
     e:= Find_style_paragraph( _NomStyle_Avant, _Root);

     if nil = e then exit;

     StyleName_Apres:= Style_NameFromDisplayName( _NomStyle_Apres);
     Set_Property( e, 'style:name'        , StyleName_Apres);
     Set_Property( e, 'style:display-name', _NomStyle_Apres);
end;

function TOpenDocument.Ensure_style_text( _NomStyle, _NomStyleParent: String;
                                          _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
var
   StyleName: String;
begin
     Result:= Find_style_text( _NomStyle, _Root);

     if nil = Result
     then
         Result:= Add_style_text( _NomStyle, _NomStyleParent, _Root)
     else
         begin
         StyleName:= Style_NameFromDisplayName(_NomStyleParent);
         if not_Test_Property( Result, 'style:parent-style-name', StyleName)
         then
             begin
             Set_Property( Result, 'style:parent-style-name', StyleName);
             end;
         end;
end;

function TOpenDocument.Ensure_automatic_style_table_cell( _NomTable: String; _X, _Y: Integer): TDOMNode;
var
   CellName: String;
   NomStyle: String;
   eSTYLES: TDOMNode;
begin
     Result:= nil;
     eSTYLES:= Get_STYLES( ors_xmlContent_AUTOMATIC_STYLES);
     if eSTYLES = nil then exit;

     CellName:= CellName_from_XY( _X, _Y);
     NomStyle:= _NomTable+'.'+CellName;
     Result:= Ensure_Item( eSTYLES, 'style:style',
                           ['style:name', 'style:family'],
                           [NomStyle    , 'table-cell'  ]);
end;

function TOpenDocument.Add_automatic_style_table_cell( _NomTable: String; _X, _Y: Integer): TDOMNode;
var
   CellName: String;
   NomStyle: String;
   eSTYLES: TDOMNode;
begin
     Result:= nil;
     eSTYLES:= Get_STYLES( ors_xmlContent_AUTOMATIC_STYLES);
     if eSTYLES = nil then exit;

     CellName:= CellName_from_XY( _X, _Y);
     NomStyle:= _NomTable+'.'+CellName;
     Result:= Add_Item( eSTYLES, 'style:style',
                        ['style:name', 'style:family'],
                        [NomStyle    , 'table-cell'  ]);
end;

function TOpenDocument.Ensure_automatic_style_table_cell_properties( _NomTable: String;
                                                        _X, _Y: Integer): TDOMNode;
var
   sCle: String;
   I: Integer;
   procedure Get_from_XML;
   var
      eStyle: TDOMNode;
   begin                                 
        eStyle:= Add_automatic_style_table_cell( _NomTable, _X, _Y);
        if eStyle = nil then exit;

        Result:= Add_Item( eStyle, 'style:table-cell-properties',[],[]);
        slStyles_Cellule_Properties.AddObject( sCle, Result);
   end;
   procedure Get_from_sl;
   var
      O: TObject;
   begin
        O:= slStyles_Cellule_Properties.Objects[ I];
        if O = nil                      then exit;
        if not (O is TDOMNode) then exit;
        Result:= TDOMNode( O);
   end;
begin
     Result:= nil;

     sCle:= _NomTable+IntToHex(_X,8)+IntToHex(_Y,8);
     I:= slStyles_Cellule_Properties.IndexOf( sCle);
     if I = -1
     then
         Get_from_XML
     else
         Get_from_sl;
end;

procedure TOpenDocument.Change_style_parent( _NomStyle, _NomStyleParent: String);
var
   e: TDOMNode;
   StyleName: String;
begin
     e:= Find_style_paragraph( _NomStyle);
     if e = nil
     then
         Add_style_paragraph( _NomStyle, _NomStyleParent)
     else
         begin
         StyleName:= Style_NameFromDisplayName(_NomStyleParent);
         if not_Test_Property( e, 'style:parent-style-name', StyleName)
         then
             begin
             Set_Property( e, 'style:class', 'text');
             Set_Property( e, 'style:parent-style-name', StyleName);
             end;
         end;
end;

function TOpenDocument.Cherche_field( _Name: String): TDOMNode;
var
   eUSER_FIELD_DECLS: TDOMNode;
   I: Integer;
   e: TDOMNode;
   Name: String;
begin
     Result:= nil;

     eUSER_FIELD_DECLS:= Get_xmlContent_USER_FIELD_DECLS;
     if eUSER_FIELD_DECLS = nil then exit;

     for I:= 0 to eUSER_FIELD_DECLS.ChildNodes.Count - 1
     do
       begin
       e:= eUSER_FIELD_DECLS.ChildNodes.Item[ I];
       if e = nil                     then continue;
       if e.NodeName <> 'text:user-field-decl' then continue;

       if not_Get_Property( e, 'text:name', Name) then continue;

       if UpperCase(Name) = UpperCase(_Name)
       then
           begin
           Result:= e;
           break;
           end;
       end;
end;

procedure TOpenDocument.Enumere_field_Racine( _Racine_Name: String;
                                              _CallBack: TEnumere_field_Racine_Callback);
var
   eUSER_FIELD_DECLS: TDOMNode;
   I: Integer;
   e: TDOMNode;
   Name: String;
begin
     if not Assigned( _CallBack) then exit;

     eUSER_FIELD_DECLS:= Get_xmlContent_USER_FIELD_DECLS;
     if eUSER_FIELD_DECLS = nil then exit;

     for I:= 0 to eUSER_FIELD_DECLS.ChildNodes.Count - 1
     do
       begin
       e:= eUSER_FIELD_DECLS.ChildNodes.Item[ I];
       if e = nil                     then continue;
       if e.NodeName <> 'text:user-field-decl' then continue;

       if not_Get_Property( e, 'text:name', Name) then continue;

       if 1 = Pos( _Racine_Name, Name)
       then
           _CallBack( e);
       end;
end;

function TOpenDocument.Cherche_Item( _eRoot: TDOMNode; _NodeName: String;
                                     _Properties_Names ,
                                     _Properties_Values: array of String): TDOMNode;
begin
     Result
     :=
       uOD_JCL.Cherche_Item( _eRoot, _NodeName,
                                   _Properties_Names , _Properties_Values);
end;

function TOpenDocument.Cherche_Item_Recursif( _eRoot: TDOMNode; _NodeName: String;
                                              _Properties_Names ,
                                              _Properties_Values: array of String): TDOMNode;
begin
     Result
     :=
       uOD_JCL.Cherche_Item_Recursif( _eRoot, _NodeName,
                                            _Properties_Names ,
                                            _Properties_Values);
end;

function TOpenDocument.Ensure_Item( _eRoot: TDOMNode; _NodeName: String;
                                    _Properties_Names ,
                                    _Properties_Values: array of String): TDOMNode;
begin
     Result
     :=
       uOD_JCL.Ensure_Item( _eRoot, _NodeName,
                                  _Properties_Names, _Properties_Values);
end;

function TOpenDocument.Add_Item( _eRoot: TDOMNode; _NodeName: String;
                                    _Properties_Names,
                                    _Properties_Values: array of String): TDOMNode;
begin
     Result
     :=
       uOD_JCL.Add_Item( _eRoot, _NodeName,
                                  _Properties_Names, _Properties_Values);
end;

procedure TOpenDocument.Copie_Item( _Source, _Cible: TDOMNode);
begin
     uOD_JCL.Copie_Item( _Source, _Cible);
end;

function TOpenDocument.Find_style_family( _NomStyle: String;
                                          _Root: TOD_Root_Styles;
                                          _family: String): TDOMNode;
var
   Name: String;
begin
     Name:= Style_NameFromDisplayName( _NomStyle);
     Result
     :=
       Cherche_Item_Recursif( Get_STYLES( _Root),
                              'style:style',
                              ['style:name','style:family'],
                              [Name        ,_family       ]);
end;

function TOpenDocument.Find_date_style( _NomStyle: String; _Root: TOD_Root_Styles): TDOMNode;
var
   Name: String;
begin
     Name:= Style_NameFromDisplayName( _NomStyle);
     Result
     :=
       Cherche_Item_Recursif( Get_STYLES( _Root),
                              'number:date-style',
                              ['style:name'],
                              [Name        ]);
end;

function TOpenDocument.Find_Time_style( _NomStyle: String; _Root: TOD_Root_Styles): TDOMNode;
var
   Name: String;
begin
     Name:= Style_NameFromDisplayName( _NomStyle);
     Result
     :=
       Cherche_Item_Recursif( Get_STYLES( _Root),
                              'number:time-style',
                              ['style:name'],
                              [Name        ]);
end;

function TOpenDocument.Find_style_paragraph( _NomStyle: String;
                                               _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
begin
     Result:= Find_style_family( _NomStyle, _Root, 'paragraph');
end;

function TOpenDocument.Find_style_text( _NomStyle: String;
                                        _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
begin
     Result:= Find_style_family( _NomStyle, _Root, 'text');
end;

function TOpenDocument.Find_style_family_multiroot( _NomStyle: String;
                                                    _Root: TOD_Root_Styles;
                                                    _family: String): TDOMNode;
     function CR( _R: TOD_Root_Styles): TDOMNode;
     begin
          Result:= Find_style_family( _NomStyle, _R, _family);
     end;
begin
     Result:= CR( _Root);
     if Assigned( Result) then exit;

     case _Root
     of
       ors_xmlStyles_STYLES: exit;
       ors_xmlStyles_AUTOMATIC_STYLES : Result:= CR( ors_xmlStyles_STYLES);
       ors_xmlContent_AUTOMATIC_STYLES: Result:= CR( ors_xmlStyles_STYLES);
       end;
end;

function TOpenDocument.Find_style_paragraph_multiroot( _NomStyle: String;
                                                       _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
begin
     Result:= Find_style_family_multiroot( _NomStyle, _Root, 'paragraph');
end;

function TOpenDocument.Find_style_text_multiroot( _NomStyle: String;
                                                  _Root: TOD_Root_Styles= ors_xmlStyles_STYLES): TDOMNode;
begin
     Result:= Find_style_family_multiroot( _NomStyle, _Root, 'paragraph');
end;

function TOpenDocument.Contient_Style_Enfant( _eRoot: TDOMNode;
                                              _NomStyleParent: String): Boolean;
begin
     Result
     :=
       nil
       <>
       Cherche_Item( _eRoot,
                     'style:style',
                     ['style:family','style:parent-style-name'],
                     ['paragraph'   ,_NomStyleParent          ]);
end;

function TOpenDocument.Utilise_Style( _eRoot: TDOMNode;
                                      _NomStyle: String): Boolean;
begin
     Result:=nil<>Cherche_Item_Recursif(_eRoot,'text:p'   ,['text:style-name'],[_NomStyle]);
     if Result then exit;

     Result:=nil<>Cherche_Item_Recursif(_eRoot,'text:span',['text:style-name'],[_NomStyle]);
end;


function TOpenDocument.Text_Traite_Field( FieldName, FieldContent: String;
                                          CreeTextFields: Boolean): Boolean;
begin
     Set_Field( FieldName, FieldContent);

     if CreeTextFields
     then
         Add_FieldGet( FieldName);

     Result:= True;
end;

function TOpenDocument.Traite_Field( FieldName, FieldContent: String;
                                     CreeTextFields: Boolean): Boolean;
begin
     Result:= False;
     if is_Calc
     then
         begin end //Calc_SetText( FieldName, FieldContent)
     else
         Result:= Text_Traite_Field( FieldName, FieldContent, CreeTextFields)
end;

procedure TOpenDocument.Field_Vide_Branche_CallBack( _e: TDOMNode);
begin
     Set_Property( _e, 'office:string-value', '');
end;

procedure TOpenDocument.Field_Vide_Branche( _Racine_FieldName: String);
begin
     Enumere_field_Racine( _Racine_FieldName, Field_Vide_Branche_CallBack);
end;

function TOpenDocument.Existe( FieldName: String): Boolean;
begin
     Result:= nil <> Cherche_field( FieldName);
end;

procedure TOpenDocument.Calc_SetText( _Name, _Value: String);
//var
//   Cell: Variant;
begin
     //Cell:= CellByName( _Name);
     //if varDispatch = VarType( Cell)
     //then
     //    Cell.Formula:= _Value
     //else
     //    OOoDelphiReportEngineLog.Entree(  'TOOo_Document_Context.Calc_SetText: '
     //                                      +'�chec  � la d�finition de '+_Name );
end;

function TOpenDocument.Calc_Lire( _Nom: String; _Default: String= ''): String;
//var
//   Cell: Variant;
begin
     //Result:= _Default;
     //if not Calc_hasByName( _Nom) then exit;
     //
     //Cell:= CellByName( _Nom);
     //if varDispatch	 <> VarType( Cell) then exit;
     //
     //Result:= Cell.Formula;
end;

procedure TOpenDocument.Calc_Ecrire( _Nom: String; _Valeur: String);
//var
//   Cell: Variant;
begin
     //Result:= _Default;
     //if not Calc_hasByName( _Nom) then exit;
     //
     //Cell:= CellByName( _Nom);
     //if varDispatch	 <> VarType( Cell) then exit;
     //
     //Result:= Cell.Formula;
end;

function TOpenDocument.Text_Lire( _Nom: String; _Default: String= ''): String;
var
   e: TDOMNode;
begin
     Result:= _Default;

     e:= Cherche_field( _Nom);
     if e = nil then exit;

     not_Get_Property( e, 'office:string-value', Result);
end;

procedure TOpenDocument.Text_Ecrire( _Nom: String; _Valeur: String);
var
   e: TDOMNode;
begin
     e:= Cherche_field( _Nom);
     if e = nil then exit;

     Set_Property( e, 'office:string-value', _Valeur);
end;

function TOpenDocument.Lire( _Nom: String; _Default: String= ''): String;
begin
     if Is_Calc
     then
         Result:= Calc_Lire( _Nom, _Default)
     else
         Result:= Text_Lire( _Nom, _Default);
end;

procedure TOpenDocument.Ecrire( _Nom: String; _Valeur: String);
begin
     if Is_Calc
     then
         Calc_Ecrire( _Nom, _Valeur)
     else
         Text_Ecrire( _Nom, _Valeur);
end;

function  TOpenDocument.Calc_GetText( _Name: String): String;
begin
     Result:= Calc_Lire( _Name, '');
end;

procedure TOpenDocument.DetruitChamp(Champ: String);
var
   eUSER_FIELD_DECLS: TDOMNode;
   e: TDOMNode;
begin
     eUSER_FIELD_DECLS:= Get_xmlContent_USER_FIELD_DECLS;
     if eUSER_FIELD_DECLS = nil then exit;

     e:= Cherche_field( Champ);
     if e = nil then exit;

     FreeAndNil( e);
end;

function TOpenDocument.Style_NameFromDisplayName( _DisplayName: String): String;
var
   I: Integer;
   C: Char;
begin
     Result:= '';
     for I:= 1 to Length( _DisplayName)
     do
       begin
       C:= _DisplayName[I];
       case C
       of
         'a'..'z','A'..'Z','0'..'9': Result:= Result + C;
         else Result:= Result + '_'+LowerCase( IntToHex(Ord(C), 2))+'_';
         end;
       end;
end;

function TOpenDocument.Style_DisplayNameFromName(_Name: String): String;
var
   I: Integer;
   C: Char;
   hex: String;
begin
     Result:= '';
     I:= 1;
     while I<= Length( _Name)
     do
       begin
       C:= _Name[I];
       if     (C = '_')
          and (I+3 < Length( _Name))
       then
           begin
           hex:= '$'+_Name[I+1]+_Name[I+2];
           Inc( I, 3);
           C:= Chr( StrToInt( hex));
           end;
       Result:= Result + C;
       Inc( I)
       end;
end;

function TOpenDocument.Field_Value(_Name: String): String;
var
   e: TDOMNode;
   String_Value: String;
begin
     Result:= '';

     e:= Cherche_field( _Name);
     if e = nil then exit;

     if not_Get_Property( e, 'office:string-value', String_Value) then exit;
     Result:= String_Value;
end;

procedure TOpenDocument.Supprime_Item( _e: TDOMNode);
begin
     if _e = nil then exit;

     FreeAndNil( _e);
end;

function TOpenDocument.Escape_XML( S: String): String;
var
   I: Integer;
   C: Char;
   X: String;
begin
     Result:= '';
     for I:= 1 to Length( S)
     do
       begin
       C:= S[I];
       case C
       of
         '<'       : X:= '&lt;'  ;
         '>'       : X:= '&gt;'  ;
         '&'       : X:= '&amp;' ;
         ''''      : X:= '&apos;';
         '"'       : X:= '&quot;';
         ' '       ,
         #128..#255: X:= '&#x'+IntToHex( Ord(C),2)+';';
         else        X:= C;
         end;
       Result:= Result + X;
       end;
end;

procedure TOpenDocument.AddSpace( _e: TDOMNode; _c: Integer);
begin
     if _c < 1 then exit;

     if _c = 1
     then
         Add_Item( _e, 'text:s',[],[])
     else
         Add_Item( _e, 'text:s', ['text:c'], [IntToStr( _c)]);
end;

procedure TOpenDocument.AddText( _e: TDOMNode; _Value: String;
                                 _Escape_XML: Boolean= False;
                                 _Gras: Boolean= False);
var
   I: Integer;
   C: Char;
   S: String;
   procedure Ajoute_SautLigne;
   begin
        Cree_path( _e, 'text:line-break');
   end;
   procedure Ajoute_Tabulation;
   begin
        Cree_path( _e, 'text:tab');
   end;
   procedure Ajoute_S;
   var
      eSpan, eText: TDomNode;
   begin
        if S = '' then exit;

        if _Escape_XML
        then
            S:= Escape_XML( S);
        eSpan:= Cree_path( _e, 'text:span');
        if _Gras then Set_Property( eSpan, 'text:style-name', Name_style_text_bold);
        eText:= _e.OwnerDocument.CreateTextNode( S);
        eSpan.AppendChild( eText);
        S:= '';
   end;
   procedure Traite_Espaces;
   var
      L: Integer;
      function Index: Integer;
      begin
           Result:= I+L-1;
      end;
   begin
        S:= S + C;
        Ajoute_S;

        L:= 2;//le premier caract�re a d�j� �t� test�
        while     (Index <= Length( _Value))
              and (_Value[Index] = ' ')
        do
          Inc( L);
        if Index <= Length( _Value)
        then
            Dec( L);

        AddSpace( _e, L-1); // le premier espace est d�j� rajout�

        Inc( I, L-1); // on se place sur le dernier caract�re
   end;
   procedure Traite_SautLigne_Windows_Mac;
   begin
        Ajoute_S;
        Ajoute_SautLigne;
        if     (I < Length( _Value))
           and (_Value[I+1] = #10)
        then
            Inc( I);

   end;
   procedure Traite_SautLigne_Linux;
   begin
        Ajoute_S;
        Ajoute_SautLigne;
   end;
   procedure Traite_Tabulation;
   begin
        Ajoute_S;
        Ajoute_Tabulation;
   end;
   procedure Traite_non_imprimable;
   begin
        S:= S+' ';
   end;
begin
     S:= '';
     I:= 1;
     while I<= Length( _Value)
     do
       begin
       C:= _Value[ I];
       case C
       of
         #0..#8  : Traite_non_imprimable;
         #9      : Traite_Tabulation;
         #10     : Traite_SautLigne_Linux;
         #11,
         #12     : Traite_non_imprimable;
         #13     : Traite_SautLigne_Windows_Mac;
         #14..#31: Traite_non_imprimable;
         ' '     : Traite_Espaces;
         //d�sactiv�, on travaille en UTF8
         //#128..#255: S:= S + ' &#x'+IntToHex( Ord(C),2)+'; ';
         else        S:= S + C;
         end;
       Inc( I);
       end;

     Ajoute_S;
end;

procedure TOpenDocument.AddText( _Value: String; _Escape_XML: Boolean= False;
                                 _Gras: Boolean= False);
begin
     AddText( Get_xmlContent_TEXT, _Value, _Escape_XML, _Gras);
end;

procedure TOpenDocument.Freeze_fields;
    procedure Traite_USER_FIELD_GET( _e: TDOMNode);
    var
       FieldName: String;
       I: Integer;
       Parent: TDOMNode;
       eSPAN: TDOMNode;
       Value: String;
    begin
         if _e = nil then exit;

         if not_Get_Property( _e, 'text:name', FieldName) then exit;

         Parent:= _e.ParentNode;
         if Parent= nil then exit;

         eSPAN:= Parent.OwnerDocument.CreateElement( 'text:span');
         if eSPAN = nil then exit;

         Parent.ReplaceChild( eSPAN, _e);
         FreeAndNil( _e);

         Value:= Field_Value( FieldName);
         AddText( eSPAN, Value, False);
    end;
    procedure Traite_DATE_TIME( _e: TDOMNode; _Root: TOD_Root_Styles; _sdtClass: TStyle_DateTime_class; _Default_Format: String);
    var
       I: Integer;
       DataStyleName, DateFixe: String;
       Parent: TDOMNode;
       eSPAN: TDOMNode;
       Value: String;
       procedure Insecable_to_Space;
       var
          J: Integer;
       begin
            if Value = '' then exit;

            for J:= 1 to Length( Value)
            do
              begin
              if Value[J] = #160
              then
                  Value[J]:= #32; 
              end;
       end;
       function Style_Format: String;
       var
          sdt: TStyle_DateTime;
       begin
            sdt:= _sdtClass.Create( Self, _Root, DataStyleName);
            try
               Result:= sdt.Format;
            finally
                   FreeAndNil( sdt);
                   end;
            if '' = Result
            then
                Result:= _Default_Format;
       end;
       function Value_from_: String;
       var
          sFormat: String;
          d: TDateTime;
       begin
            d:= Now;
                  if '' = DataStyleName then sFormat:= _Default_Format
            else                             sFormat:=    Style_Format;
            Result:= FormatDateTime( sFormat, d);
       end;
    begin
         if _e = nil then exit;

         if not_Get_Property( _e, 'style:data-style-name', DataStyleName)
         then
             DataStyleName:='';

         if not_Get_Property( _e, 'text:fixed', DateFixe) // non utilis� pour l'instant
         then
             DateFixe:= '';

         Parent:= _e.ParentNode;
         if Parent= nil then exit;

         eSPAN:= Parent.OwnerDocument.CreateElement( 'text:span');
         if eSPAN = nil then exit;

         Parent.ReplaceChild( eSPAN, _e);
         FreeAndNil( _e);

         Value:= Value_from_;
         //Insecable_to_Space;
         AddText( eSPAN, Value, False);
    end;
    procedure Traite_DATE( _e: TDOMNode; _Root: TOD_Root_Styles);
    begin
         Traite_DATE_TIME( _e, _Root, TStyle_Date, 'dddddd');
    end;
    procedure Traite_TIME( _e: TDOMNode; _Root: TOD_Root_Styles);
    begin
         Traite_DATE_TIME( _e, _Root, TStyle_Time, 'tt');
    end;
    procedure T( _e: TDOMNode; _Root: TOD_Root_Styles);
    var
       I: Integer;
    begin
         if _e = nil then exit;

              if _e.NodeName = 'text:user-field-get' then Traite_USER_FIELD_GET( _e)
         else if _e.NodeName = 'text:date'           then Traite_DATE( _e, _Root)
         else if _e.NodeName = 'text:time'           then Traite_TIME( _e, _Root)
         else
             for I:= 0 to _e.ChildNodes.Count-1
             do
               T( _e.ChildNodes.Item[ I], _Root);
    end;
    procedure Efface_Declarations;
    var
       e: TDOMNode;
    begin
         e:= Get_xmlContent_USER_FIELD_DECLS;
         RemoveChilds( e);

         while True
         do
           begin
           e:= Cherche_Item_Recursif( Get_xmlStyles_MASTER_STYLES,
                                      'text:user-field-decls', [], []);
           if e = nil then break;
           Supprime_Item( e);
           end;
    end;
begin
     T( Get_xmlContent_TEXT, ors_xmlContent_AUTOMATIC_STYLES);
     T( Get_xmlStyles_MASTER_STYLES, ors_xmlStyles_AUTOMATIC_STYLES);
     Efface_Declarations;
end;

procedure TOpenDocument.Try_Delete_Style( _eStyle: TDOMNode);
var
   Style_Name: String;
begin
     if not_Test_Property( _eStyle, 'style:family', ['paragraph']) then exit;

     if not_Get_Property( _eStyle, 'style:name'  , Style_Name  ) then exit;

     if Contient_Style_Enfant( Get_xmlStyles_STYLES           , Style_Name) then exit;
     if Contient_Style_Enfant( Get_xmlStyles_AUTOMATIC_STYLES , Style_Name) then exit;
     if Contient_Style_Enfant( Get_xmlContent_AUTOMATIC_STYLES, Style_Name) then exit;

     if Utilise_Style( Get_xmlStyles_MASTER_STYLES, Style_Name) then exit;
     if Utilise_Style( Get_xmlContent_TEXT        , Style_Name) then exit;

     OOoDelphiReportEngineLog.Entree( 'Style '+Style_Name+' inutilis�.');
     Supprime_Item( _eStyle);
end;

procedure TOpenDocument.Delete_unused_styles;
var
   eSTYLES: TDOMNode;
   I: Integer;
   e: TDOMNode;
begin
     eSTYLES:= Get_xmlStyles_STYLES;
     I:= eSTYLES.ChildNodes.Count - 1;
     while I >= 0
     do
       begin
       e:= eSTYLES.ChildNodes.Item[ I];
       Try_Delete_Style( e);
       Dec( I);
       end;
end;

procedure TOpenDocument.Efface_Styles_Table( _NomTable: String);
var
   Prefixe: String;
   eAUTOMATIC_STYLES: TDOMNode;
   I: Integer;
   e: TDOMNode;
   Name: String;
   function Supprimer: Boolean;
   begin
        Result:= False;
        if e = nil                                               then exit;
        if not_Test_Property( e, 'style:family',[
                                                'table-column',
                                                'table-cell'
                                                ]
                                                )
                                                                 then exit;
        if  not_Get_Property( e, 'style:name'  , Name          ) then exit;
        if 1 <> Pos( Prefixe, Name)                              then exit;
        Result:= True;
   end;
begin
     Prefixe:= _NomTable+'.';

     slStyles_Cellule_Properties.Clear;

     eAUTOMATIC_STYLES:= Get_xmlContent_AUTOMATIC_STYLES;
     I:= eAUTOMATIC_STYLES.ChildNodes.Count - 1;
     while I >= 0
     do
       begin
       e:= eAUTOMATIC_STYLES.ChildNodes.Item[ I];
       if Supprimer
       then
           Supprime_Item( e);
       Dec( I);
       end;
end;

function TOpenDocument.Named_Range_Cherche( _Nom: String): TDOMNode;
begin
     Result:= Cherche_Item( Get_xmlContent_SPREADSHEET_NAMED_EXPRESSIONS,
                            'table:named-range',
                            ['table:name'],
                            [_Nom        ]);
end;

function TOpenDocument.Named_Range_Assure( _Nom: String): TDOMNode;
begin
     Result:= Ensure_Item( Get_xmlContent_SPREADSHEET_NAMED_EXPRESSIONS,
                           'table:named-range',
                           ['table:name'],
                           [_Nom        ]);
end;

procedure TOpenDocument.Named_Range_Set( _Nom, _Base_Cell, _Cell_Range: String);
var
   e: TDOMNode;
begin
     e:= Named_Range_Assure( _Nom);
     if e = nil then exit;

     Set_Property( e, 'table:base-cell-address' , _Base_Cell );
     Set_Property( e, 'table:cell-range-address', _Cell_Range);
end;

(*
procedure TOpenDocument.tShow_TimeOutTimer(Sender: TObject);
begin
     tShow_TimeOut.Enabled:= False;
     Show_TimeOut:= True;
end;
*)
procedure TOpenDocument.Show;
begin
     ShowURL( Nom);
end;

function TOpenDocument.Largeur_Imprimable: double;
var
   ePage_Layout_Properties: TDOMNode;
   sPage_width  : String;
   sMargin_left : String;
   sMargin_right: String;

   dPage_width  : double;
   dMargin_left : double;
   dMargin_right: double;
begin
     Result:= 0;

     ePage_Layout_Properties
     :=
       Elem_from_path( Get_xmlStyles_AUTOMATIC_STYLES, 'style:page-layout/style:page-layout-properties');

     if not_Get_Property( ePage_Layout_Properties, 'fo:page-width'  , sPage_width  ) then exit;
     if not_Get_Property( ePage_Layout_Properties, 'fo:margin-left' , sMargin_left ) then exit;
     if not_Get_Property( ePage_Layout_Properties, 'fo:margin-right', sMargin_right) then exit;

     dPage_width  := double_from_StrCM( sPage_width  ); if dPage_width  = 0 then exit;
     dMargin_left := double_from_StrCM( sMargin_left ); if dMargin_left = 0 then exit;
     dMargin_right:= double_from_StrCM( sMargin_right); if dMargin_right= 0 then exit;

     Result:= dPage_width - dMargin_left - dMargin_right;
end;

function TOpenDocument.FirstHeader: TDOMNode;
begin
     Result
     :=
       Elem_from_path( Get_xmlStyles_MASTER_STYLES, 'style:master-page/style:header');
end;

procedure TOpenDocument.Ensure_style_text_bold;
var
   e: TDOMNode;
begin
     Name_style_text_bold:= 'bold';
     e
     :=
       Add_style_with_text_properties( Name_style_text_bold,
                                       ors_xmlStyles_STYLES,
                                       'text',
                                       '',
                                       '',
                                       True,
                                       0,0,100);
end;

function TOpenDocument.Append_SOFT_PAGE_BREAK( _eRoot: TDOMNode): TDOMNode;
begin
     Result:= Cree_path( _eRoot, 'text:soft-page-break');
end;

end.
