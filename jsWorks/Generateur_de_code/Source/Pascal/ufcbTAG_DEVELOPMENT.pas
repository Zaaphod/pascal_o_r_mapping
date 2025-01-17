unit ufcbTag_Development;
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids,
  ufcbBase;

type
 TfcbTag_Development
 =
  class(TfcbBase)
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function fcbTag_Development: TfcbTag_Development;

function DerouleTag_Development( E: TObject; Resultat: TIntegerField):Boolean;

implementation

uses
    uClean,
    upoolTag_Development,
    ufTag_Development;

{$R *.dfm}

var
   FfcbTag_Development: TfcbTag_Development;

function fcbTag_Development: TfcbTag_Development;
begin
     Clean_Get( Result, FfcbTag_Development, TfcbTag_Development);
end;

var
   FiltreTag_Development: String = '';

function DerouleTag_Development(E: TObject; Resultat: TIntegerField): Boolean;
begin
     fcbTag_Development.eFiltre.Text:= FiltreTag_Development;
//     Result
//     :=
//       fcbTag_Development.DerouleListe( E, dmaTag_Development.ds, fTag_Development.Execute,
//                                 Resultat, dmaTag_Development.qNumero);
     FiltreTag_Development:= fcbTag_Development.eFiltre.Text;
     Result:= False;
end;


initialization
              Clean_Create ( FfcbTag_Development, TfcbTag_Development);
finalization
              Clean_Destroy( FfcbTag_Development);
end.
