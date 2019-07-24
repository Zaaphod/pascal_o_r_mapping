unit uReels;
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

{ uReels
Un test d'�galit� entre deux r�els R1 et R2 ne peut pas �tre fait de fa�on
fiable par (R1 = R2) car des arrondis automatiques peuvent survenir si R1 ou R2
sont obtenus par calcul.

A la place on teste si R1-R2 est suffisamment petit.

remarque: pour l'instant on ne se pr�occupe pas de > et < mais le cas peut
aussi se poser.
Cod� pour les probl�mes de troncature sur les calculs dans uJournee de
Batpro_Planning
}


const
     precision_Millionnieme= 1E-6;

function EgalReel( R1, R2: Double; Precision: Double): Boolean;

function Reel_Zero( R: Double): Boolean;

implementation

{ EgalReel
Retourne Abs(R1-R2) <= Precision
}
function EgalReel( R1, R2: Double; Precision: Double): Boolean;
begin
     Result:= Abs(R1-R2) <= Precision;
end;

function Reel_Zero( R: Double): Boolean;
begin
     Result:= EgalReel( R, 0, precision_Millionnieme);
end;

end.
