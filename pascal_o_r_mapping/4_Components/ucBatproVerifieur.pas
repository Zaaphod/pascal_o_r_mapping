unit ucBatproVerifieur;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
  SysUtils, Classes;

type
  TBatproVerifieur = class(TComponent)
  private
    { D�clarations priv�es }

    //fausses propri�t�s
    function  GetFalse: Boolean;
    procedure Setbv2_to_bv0(Value: Boolean);
    procedure Do_bv2_to_bv0;
  protected
    { D�clarations prot�g�es }
    FsValeur: String;

    FPoubelle: TComponent;//variable "poubelle" pour propri�t�s en lecture seule
                          // notamment bv2_Valeur

    procedure Loaded; override;

    // la valeur stock�e dans le composant � v�rifier
    function  GetComponent_Valeur: TComponent; virtual;
  public
    { D�clarations publiques }
    constructor Create(AOwner: TComponent); override;
    property Component_Valeur: TComponent read  GetComponent_Valeur;
  published
    { D�clarations publi�es }
    property bv0sValeur: String read FsValeur write FsValeur;

    property bv2_Valeur:TComponent read GetComponent_Valeur write FPoubelle;

    //fausses propri�t�s servant � lancer une proc�dure dans l'EDI de Delphi

    //copie dans bv0sValeur le bvGetNamePath( Valeur)   (Valeur = bv2_Valeur)
    property bv2_to_bv0: Boolean read GetFalse write Setbv2_to_bv0;
  end;

function bvGetNamePath(C: TComponent): String;

implementation

function bvGetNamePath( C: TComponent): String;
var
   O: TComponent;
begin
     Result:= '';

     if C= nil then exit;
     Result:= C.GetNamePath;

     O:= C.Owner;
     if O = nil then exit;

     Result:= O.GetNamePath+'.'+Result;
end;

constructor TBatproVerifieur.Create(AOwner: TComponent);
begin
     inherited Create( AOwner);
     FsValeur:= '';
end;

function TBatproVerifieur.GetComponent_Valeur: TComponent;
begin
     Result:= nil;          //m�thode virtuelle pure
end;

procedure TBatproVerifieur.Loaded;
   procedure Erreur( S: String);
   begin
        S:= bvGetNamePath( Self)+':'+S;
        WriteLn( S);
   end;
begin
     inherited;

     if bv0sValeur <> ''
     then
         if Component_Valeur = nil
         then
             Erreur( 'le composant est � nil alors qu''il devrait pointer sur '+
                     '>'+bv0sValeur+'<');
end;


function TBatproVerifieur.GetFalse: Boolean;
begin
     Result:= False;
end;

procedure TBatproVerifieur.Do_bv2_to_bv0;
begin
     if (bv0sValeur = '') and Assigned( Component_Valeur)
     then
         bv0sValeur:= bvGetNamePath( Component_Valeur);
end;

procedure TBatproVerifieur.Setbv2_to_bv0(Value: Boolean);
begin
     if Value
     then
         Do_bv2_to_bv0;
end;

end.
