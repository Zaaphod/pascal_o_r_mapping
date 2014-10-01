unit ujpDocksDetails_Affiche;
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
    SysUtils, Classes,
    uGlobal,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint;

type
 TjpDocksDetails_Affiche
 =
  class( TJoinPoint)
  //Attributs
  public
    procedure Finalise; override;
  //Gestion du cycle de vie
  public
    constructor Create;
  //Gestion de la visite d'une classe
  public
    procedure Initialise(_cc: TContexteClasse); override;
    procedure VisiteDetail(s_Detail,sNomTableMembre: String); override;
  end;

var
   jpDocksDetails_Affiche: TjpDocksDetails_Affiche;

implementation

{ TjpDocksDetails_Affiche }

constructor TjpDocksDetails_Affiche.Create;
begin
     Cle:= '//Point d''insertion aggr�gations faibles, accrochage des dock de d�tails';
end;

procedure TjpDocksDetails_Affiche.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpDocksDetails_Affiche.VisiteDetail(s_Detail,sNomTableMembre: String);
begin
     inherited;
     if Valeur = ''
     then
         Valeur:= '		#region Aggr�gations faibles, accrochage des dock de d�tails'#13#10#13#10
     else
         Valeur:= Valeur + #13#10;
     Valeur
     :=
         Valeur
       + '      dkd'+s_Detail+'.Affiche( ml, ml.ha'+s_Detail+');';
end;

procedure TjpDocksDetails_Affiche.Finalise;
begin
     inherited;
     if Valeur <> ''
     then
         Valeur:= Valeur + #13#10#13#10'   #endregion'#13#10;
end;

initialization
              jpDocksDetails_Affiche:= TjpDocksDetails_Affiche.Create;
finalization
              FreeAndNil( jpDocksDetails_Affiche);
end.
