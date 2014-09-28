unit upoolG_CTXTYPE;
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
    ublG_CTXTYPE,

    udmBatpro_DataModule,
    uPool,

    uhfG_CTXTYPE,

  SysUtils, Classes,
  FMTBcd, BufDataset, DB, SQLDB;

type

 { TpoolG_CTXTYPE }

 TpoolG_CTXTYPE
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { D�clarations priv�es }
  protected
    { D�clarations prot�g�es }
  public
    { D�clarations publiques }
  //Filtre
  public
    hfG_CTXTYPE: ThfG_CTXTYPE;
  //Acc�s g�n�ral
  public
    function Get( _id: integer): TblG_CTXTYPE;
  //Gestion de la cl�
  protected
    contextetype: String;

    procedure To_SQLQuery_Params( SQLQuery: TSQLQuery); override;
  public
    function Get_by_Cle( _contextetype: String): TblG_CTXTYPE;
  //Ind�pendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  end;

function poolG_CTXTYPE: TpoolG_CTXTYPE;

implementation

uses
    uClean,
{implementation_uses_key}
    udmDatabase;

{$R *.dfm}

var
   FpoolG_CTXTYPE: TpoolG_CTXTYPE;

function poolG_CTXTYPE: TpoolG_CTXTYPE;
begin
     Clean_Get( Result, FpoolG_CTXTYPE, TpoolG_CTXTYPE);
end;

{ TpoolG_CTXTYPE }

procedure TpoolG_CTXTYPE.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'g_ctxtype';
     Classe_Elements:= TblG_CTXTYPE;
     Classe_Filtre:= ThfG_CTXTYPE;

     inherited;

     hfG_CTXTYPE:= hf as ThfG_CTXTYPE;
end;

procedure TpoolG_CTXTYPE.DataModuleDestroy(Sender: TObject);
begin
     inherited;
end;

function TpoolG_CTXTYPE.Get( _id: integer): TblG_CTXTYPE;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolG_CTXTYPE.Get_by_Cle( _contextetype: String): TblG_CTXTYPE;
begin                               
     contextetype:=  _contextetype;
     sCle:= TblG_CTXTYPE.sCle_from_( contextetype);
     Get_Interne( Result);       
end;                             


procedure TpoolG_CTXTYPE.To_SQLQuery_Params(SQLQuery: TSQLQuery);
begin
     inherited;
     with SQLQuery.Params
     do
       begin
       ParamByName( 'contextetype'    ).AsString:= contextetype;
       end;
end;

function TpoolG_CTXTYPE.SQLWHERE_ContraintesChamps: String;
begin
     Result
     :=
       'where                        '#13#10+
       '         contextetype    = :contextetype   ';
end;

initialization
              Clean_Create ( FpoolG_CTXTYPE, TpoolG_CTXTYPE);
finalization
              Clean_destroy( FpoolG_CTXTYPE);
end.
