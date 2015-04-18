unit ublWork;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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
    uClean,
    u_sys_,
    uuStrings,
    uBatpro_StringList,
    uChamp,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,

    SysUtils, Classes, sqldb, DB;

type

 { TblWork }

 TblWork
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    nUser: Integer;
    nProject: Integer;
    Beginning: TDateTime;
    End_: TDateTime;
    Description: String;
  //Duree en heures
  private
    FDuree: double;
    procedure Duree_GetChaine( var _Chaine: String);
    function GetDuree: double;
  public
    cDuree: TChamp;
    property Duree: double read GetDuree;
  //Gestion de la clé
  public
    function sCle: String; override;
  //Méthodes
  public
    procedure Stop;
  end;

function blWork_from_sl( sl: TBatpro_StringList; Index: Integer): TblWork;
function blWork_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblWork;

implementation

function blWork_from_sl( sl: TBatpro_StringList; Index: Integer): TblWork;
begin
     _Classe_from_sl( Result, TblWork, sl, Index);
end;

function blWork_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblWork;
begin
     _Classe_from_sl_sCle( Result, TblWork, sl, sCle);
end;

{ TblWork }

constructor TblWork.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Work';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Work';

     //champs persistants
     Integer_from_ ( nUser          , 'nUser'          );
     Integer_from_ ( nProject       , 'nProject'       );
     DateTime_from_( Beginning      , 'Beginning'      );
     DateTime_from_( End_           , 'End'            );
     String_from_  ( Description    , 'Description'    );

     cDuree:= Ajoute_Float( FDuree, 'Duree', False);
     cDuree.OnGetChaine:= Duree_GetChaine;

end;

destructor TblWork.Destroy;
begin

     inherited;
end;

procedure TblWork.Duree_GetChaine(var _Chaine: String);
begin
     GetDuree;
     _Chaine:= cDuree.GetChaine_interne;
end;

function TblWork.GetDuree: double;
begin
     if End_ < Beginning
     then
         FDuree:= 0
     else
         FDuree:= (End_ - Beginning)*24;

     Result:= FDuree;
end;

function TblWork.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblWork.Stop;
begin
     End_:= Now;
     Save_to_database;
end;

end.


