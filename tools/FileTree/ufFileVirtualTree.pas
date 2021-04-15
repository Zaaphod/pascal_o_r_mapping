unit ufFileVirtualTree;

{$mode objfpc}{$H+}

interface

uses
    uFileTree,
    uFileVirtualTree,
    ufFileTree,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
 StdCtrls, IniPropStorage, IniFiles, VirtualTrees;

type

 { TfFileVirtualTree }

 TfFileVirtualTree
 =
  class(TForm)
   bGetChecked: TButton;
   bGetSelection: TButton;
   bfFileTree: TButton;
   bLoad_from_File: TButton;
   bOD: TButton;
   eFileName: TEdit;
   ips: TIniPropStorage;
   Label1: TLabel;
   lCompute_Aggregates: TLabel;
   m: TMemo;
   od: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pb: TProgressBar;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    vstResult: TVirtualStringTree;
    vst: TVirtualStringTree;
    procedure bfFileTreeClick(Sender: TObject);
    procedure bGetCheckedClick(Sender: TObject);
    procedure bGetSelectionClick(Sender: TObject);
    procedure bLoad_from_FileClick(Sender: TObject);
    procedure bODClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    slResult: TStringList;
    hvst: ThVirtualStringTree;
    hvstResult: ThVirtualStringTree;
  end;

var
 fFileVirtualTree: TfFileVirtualTree;

implementation

{$R *.lfm}

{ TfFileVirtualTree }

procedure TfFileVirtualTree.FormCreate(Sender: TObject);
begin
     slResult  := TStringList.Create;

     hvst      := ThVirtualStringTree.Create( True , vst      , pb, lCompute_Aggregates);
     hvstResult:= ThVirtualStringTree.Create( False, vstResult, pb, lCompute_Aggregates);
end;

procedure TfFileVirtualTree.FormDestroy(Sender: TObject);
begin
     FreeAndNil( slResult  );
     FreeAndNil( hvst      );
     FreeAndNil( hvstResult);
end;


procedure TfFileVirtualTree.bLoad_from_FileClick(Sender: TObject);
begin
     hvst.Load_from_File( eFileName.Text);
end;

procedure TfFileVirtualTree.bODClick(Sender: TObject);
begin
     od.FileName:= eFileName.Text;
     if od.Execute
     then
         eFileName.Text:= od.FileName;
end;

procedure TfFileVirtualTree.bGetSelectionClick(Sender: TObject);
begin
     m.Lines.Text:= hvst.Get_Selected;
end;

procedure TfFileVirtualTree.bGetCheckedClick(Sender: TObject);
begin
     slResult.Text:= hvst.Get_Checked;
     slResult.Sort;

     m.Lines .Text:= slResult.Text;
     hvstResult.Load_from_StringList( slResult);
     hvstResult.vst_expand_full;
end;

procedure TfFileVirtualTree.bfFileTreeClick(Sender: TObject);
begin
     fFileTree.Show;
end;

end.

