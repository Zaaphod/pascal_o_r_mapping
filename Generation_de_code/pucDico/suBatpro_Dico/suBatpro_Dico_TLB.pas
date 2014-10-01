unit suBatpro_Dico_TLB;
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

// ************************************************************************ //
// AVERTISSEMENT                                                                 
// -------                                                                    
// Les types d�clar�s dans ce fichier ont �t� g�n�r�s � partir de donn�es lues 
// depuis la biblioth�que de types. Si cette derni�re (via une autre biblioth�que de types 
// s'y r�f�rant) est explicitement ou indirectement r�-import�e, ou la commande "Rafra�chir"  
// de l'�diteur de biblioth�que de types est activ�e lors de la modification de la biblioth�que 
// de types, le contenu de ce fichier sera r�g�n�r� et toutes les modifications      
// manuellement apport�es seront perdues.                                     
// ************************************************************************ //

// PASTLWTR : 1.2
// Fichier g�n�r� le 07/05/2008 11:56:02 depuis la biblioth�que de types ci-dessous.

// ************************************************************************  //
// Bibl. types : C:\2_source\06_Batpro_Dico\suBatpro_Dico\suBatpro_Dico.tlb (1)
// LIBID: {D91C6A9C-DB62-4F81-B629-9C0613558C6A}
// LCID: 0
// Fichier d'aide : 
// Cha�ne d'aide : suBatpro_Dico (biblioth�que)
// DepndLst: 
//   (1) v1.0 StarUML, (C:\Program Files\StarUML\StarUML.exe)
//   (2) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // L'unit� doit �tre compil�e sans pointeur � type contr�l�. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StarUML_TLB, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS d�clar�s dans la biblioth�que de types. Pr�fixes utilis�s :    
//   Biblioth�ques de types : LIBID_xxxx                                      
//   CoClasses              : CLASS_xxxx                                      
//   DISPInterfaces         : DIID_xxxx                                       
//   Non-DISP interfaces    : IID_xxxx                                        
// *********************************************************************//
const
  // Versions majeure et mineure de la biblioth�que de types
  suBatpro_DicoMajorVersion = 1;
  suBatpro_DicoMinorVersion = 0;

  LIBID_suBatpro_Dico: TGUID = '{D91C6A9C-DB62-4F81-B629-9C0613558C6A}';

  CLASS_Batpro_Dico: TGUID = '{D3537972-9F9D-4A79-9911-E3781C0ED3FE}';
type

// *********************************************************************//
// D�claration de CoClasses d�finies dans la biblioth�que de types 
// (REMARQUE: On affecte chaque CoClasse � son Interface par d�faut)              
// *********************************************************************//
  Batpro_Dico = IStarUMLAddIn;


// *********************************************************************//
// La classe CoBatpro_Dico fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IStarUMLAddIn expos�e             
// par la CoClasse Batpro_Dico. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoBatpro_Dico = class
    class function Create: IStarUMLAddIn;
    class function CreateRemote(const MachineName: string): IStarUMLAddIn;
  end;

implementation

uses ComObj;

class function CoBatpro_Dico.Create: IStarUMLAddIn;
begin
  Result := CreateComObject(CLASS_Batpro_Dico) as IStarUMLAddIn;
end;

class function CoBatpro_Dico.CreateRemote(const MachineName: string): IStarUMLAddIn;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Batpro_Dico) as IStarUMLAddIn;
end;

end.
