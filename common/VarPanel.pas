(*                   Variable Panel Unit (Object Pascal)
                           (c) Daniel Doubrovkine
  Stolen Technologies Inc. - University of Geneva - 1996 - All Rights Reserved
            for Scientific Calculator, version revised on 01.07.96
*)
unit VarPanel;

interface

uses
  Windows, Controls, Buttons, Classes, ExtCtrls, Forms;

var
    SelectedItem:char;

type
  TVarForm = class(TForm)
    Panel1: TPanel;
    a: TSpeedButton;
    b: TSpeedButton;
    c: TSpeedButton;
    d: TSpeedButton;
    f: TSpeedButton;
    g: TSpeedButton;
    h: TSpeedButton;
    i: TSpeedButton;
    j: TSpeedButton;
    k: TSpeedButton;
    l: TSpeedButton;
    m: TSpeedButton;
    n: TSpeedButton;
    o: TSpeedButton;
    p: TSpeedButton;
    q: TSpeedButton;
    r: TSpeedButton;
    s: TSpeedButton;
    v: TSpeedButton;
    u: TSpeedButton;
    t: TSpeedButton;
    w: TSpeedButton;
    x: TSpeedButton;
    y: TSpeedButton;
    z: TSpeedButton;
    aa: TSpeedButton;
    BB: TSpeedButton;
    CC: TSpeedButton;
    DD: TSpeedButton;
    FF: TSpeedButton;
    GG: TSpeedButton;
    HH: TSpeedButton;
    II: TSpeedButton;
    JJ: TSpeedButton;
    KK: TSpeedButton;
    LL: TSpeedButton;
    MM: TSpeedButton;
    NN: TSpeedButton;
    OO: TSpeedButton;
    PP: TSpeedButton;
    QQ: TSpeedButton;
    RR: TSpeedButton;
    SS: TSpeedButton;
    TT: TSpeedButton;
    UU: TSpeedButton;
    VV: TSpeedButton;
    WW: TSpeedButton;
    XX: TSpeedButton;
    ZZ: TSpeedButton;
    YY: TSpeedButton;
    e: TSpeedButton;
    EE: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure aClick(Sender: TObject);
    procedure bClick(Sender: TObject);
    procedure cClick(Sender: TObject);
    procedure dClick(Sender: TObject);
    procedure eClick(Sender: TObject);
    procedure gClick(Sender: TObject);
    procedure hClick(Sender: TObject);
    procedure iClick(Sender: TObject);
    procedure jClick(Sender: TObject);
    procedure kClick(Sender: TObject);
    procedure lClick(Sender: TObject);
    procedure mClick(Sender: TObject);
    procedure nClick(Sender: TObject);
    procedure oClick(Sender: TObject);
    procedure pClick(Sender: TObject);
    procedure qClick(Sender: TObject);
    procedure rClick(Sender: TObject);
    procedure sClick(Sender: TObject);
    procedure tClick(Sender: TObject);
    procedure uClick(Sender: TObject);
    procedure vClick(Sender: TObject);
    procedure wClick(Sender: TObject);
    procedure xClick(Sender: TObject);
    procedure yClick(Sender: TObject);
    procedure zClick(Sender: TObject);

    procedure GGClick(Sender: TObject);
    procedure aaClick(Sender: TObject);
    procedure bbClick(Sender: TObject);
    procedure ccClick(Sender: TObject);
    procedure EEClick(Sender: TObject);
    procedure ffClick(Sender: TObject);
    //procedure ggClick(Sender: TObject);
    procedure hhClick(Sender: TObject);
    procedure iiClick(Sender: TObject);
    procedure jjClick(Sender: TObject);
    procedure kkClick(Sender: TObject);
    procedure llClick(Sender: TObject);
    procedure mmClick(Sender: TObject);
    procedure nnClick(Sender: TObject);
    procedure ooClick(Sender: TObject);
    procedure ppClick(Sender: TObject);
    procedure qqClick(Sender: TObject);
    procedure rrClick(Sender: TObject);
    procedure ssClick(Sender: TObject);
    procedure ttClick(Sender: TObject);
    procedure uuClick(Sender: TObject);
    procedure vvClick(Sender: TObject);
    procedure wwClick(Sender: TObject);
    procedure xxClick(Sender: TObject);
    procedure yyClick(Sender: TObject);
    procedure zzClick(Sender: TObject);

  private
    { Private declarations }
  public
  end;

var
  VarForm: TVarForm;

implementation

{$R *.DFM}

procedure TVarForm.FormCreate(Sender: TObject);
begin
     VarForm.ClientWidth:=a.left+i.left+i.width;
     VarForm.ClientHeight:=ZZ.top+ZZ.height+a.top;
end;

procedure TVarForm.aClick(Sender: TObject);
begin
     SelectedItem:='a';
     VarForm.Close;
     end;

procedure TVarForm.bClick(Sender: TObject);
begin
     SelectedItem:='b';
     VarForm.Close;
     end;

procedure TVarForm.cClick(Sender: TObject);
begin
     SelectedItem:='c';
     VarForm.Close;
     end;

procedure TVarForm.dClick(Sender: TObject);
begin
     SelectedItem:='d';
     VarForm.Close;
     end;

procedure TVarForm.eClick(Sender: TObject);
begin
     SelectedItem:='f';
     VarForm.Close;
     end;

procedure TVarForm.gClick(Sender: TObject);
begin
     SelectedItem:='g';
     VarForm.Close;
     end;

procedure TVarForm.hClick(Sender: TObject);
begin
     SelectedItem:='h';
     VarForm.Close;
     end;

procedure TVarForm.iClick(Sender: TObject);
begin
     SelectedItem:='i';
     VarForm.Close;
     end;

procedure TVarForm.jClick(Sender: TObject);
begin
     SelectedItem:='j';
     VarForm.Close;
     end;

procedure TVarForm.kClick(Sender: TObject);
begin
     SelectedItem:='k';
     VarForm.Close;
     end;

procedure TVarForm.lClick(Sender: TObject);
begin
     SelectedItem:='l';
     VarForm.Close;
     end;

procedure TVarForm.mClick(Sender: TObject);
begin
     SelectedItem:='m';
     VarForm.Close;
     end;

procedure TVarForm.nClick(Sender: TObject);
begin
     SelectedItem:='n';
     VarForm.Close;
     end;

procedure TVarForm.oClick(Sender: TObject);
begin
     SelectedItem:='o';
     VarForm.Close;
     end;

procedure TVarForm.pClick(Sender: TObject);
begin
     SelectedItem:='p';
     VarForm.Close;
     end;

procedure TVarForm.qClick(Sender: TObject);
begin
     SelectedItem:='q';
     VarForm.Close;
     end;

procedure TVarForm.rClick(Sender: TObject);
begin
     SelectedItem:='r';
     VarForm.Close;
     end;

procedure TVarForm.sClick(Sender: TObject);
begin
     SelectedItem:='s';
     VarForm.Close;
     end;

procedure TVarForm.tClick(Sender: TObject);
begin
     SelectedItem:='t';
     VarForm.Close;
     end;

procedure TVarForm.uClick(Sender: TObject);
begin
     SelectedItem:='u';
     VarForm.Close;
     end;

procedure TVarForm.vClick(Sender: TObject);
begin
     SelectedItem:='v';
     VarForm.Close;
     end;

procedure TVarForm.wClick(Sender: TObject);
begin
     SelectedItem:='w';
     VarForm.Close;
     end;

procedure TVarForm.xClick(Sender: TObject);
begin
     SelectedItem:='x';
     VarForm.Close;
     end;

procedure TVarForm.yClick(Sender: TObject);
begin
     SelectedItem:='y';
     VarForm.Close;
     end;

procedure TVarForm.zClick(Sender: TObject);
begin
     SelectedItem:='z';
     VarForm.Close;
     end;

procedure TVarForm.aaClick(Sender: TObject);
begin
     SelectedItem:='A';
     VarForm.Close;
     end;

procedure TVarForm.bbClick(Sender: TObject);
begin
     SelectedItem:='B';
     VarForm.Close;
     end;

procedure TVarForm.ccClick(Sender: TObject);
begin
     SelectedItem:='C';
     VarForm.Close;
     end;

procedure TVarForm.EEClick(Sender: TObject);
begin
     SelectedItem:='E';
     VarForm.Close;
     end;

procedure TVarForm.ffClick(Sender: TObject);
begin
     SelectedItem:='F';
     VarForm.Close;
     end;

procedure TVarForm.GGClick(Sender: TObject);
begin
     SelectedItem:='G';
     VarForm.Close;
     end;

procedure TVarForm.hhClick(Sender: TObject);
begin
     SelectedItem:='H';
     VarForm.Close;
     end;

procedure TVarForm.iiClick(Sender: TObject);
begin
     SelectedItem:='I';
     VarForm.Close;
     end;

procedure TVarForm.JjClick(Sender: TObject);
begin
     SelectedItem:='J';
     VarForm.Close;
     end;

procedure TVarForm.kkClick(Sender: TObject);
begin
     SelectedItem:='K';
     VarForm.Close;
     end;

procedure TVarForm.llClick(Sender: TObject);
begin
     SelectedItem:='L';
     VarForm.Close;
     end;

procedure TVarForm.mmClick(Sender: TObject);
begin
     SelectedItem:='M';
     VarForm.Close;
     end;

procedure TVarForm.nnClick(Sender: TObject);
begin
     SelectedItem:='N';
     VarForm.Close;
     end;

procedure TVarForm.ooClick(Sender: TObject);
begin
     SelectedItem:='O';
     VarForm.Close;
     end;

procedure TVarForm.ppClick(Sender: TObject);
begin
     SelectedItem:='P';
     VarForm.Close;
     end;

procedure TVarForm.qqClick(Sender: TObject);
begin
     SelectedItem:='Q';
     VarForm.Close;
     end;

procedure TVarForm.rrClick(Sender: TObject);
begin
     SelectedItem:='R';
     VarForm.Close;
     end;

procedure TVarForm.ssClick(Sender: TObject);
begin
     SelectedItem:='S';
     VarForm.Close;
     end;

procedure TVarForm.ttClick(Sender: TObject);
begin
     SelectedItem:='T';
     VarForm.Close;
     end;

procedure TVarForm.uuClick(Sender: TObject);
begin
     SelectedItem:='U';
     VarForm.Close;
     end;

procedure TVarForm.vvClick(Sender: TObject);
begin
     SelectedItem:='V';
     VarForm.Close;
     end;

procedure TVarForm.wwClick(Sender: TObject);
begin
     SelectedItem:='W';
     VarForm.Close;
     end;

procedure TVarForm.xxClick(Sender: TObject);
begin
     SelectedItem:='X';
     VarForm.Close;
     end;

procedure TVarForm.yyClick(Sender: TObject);
begin
     SelectedItem:='Y';
     VarForm.Close;
     end;

procedure TVarForm.zzClick(Sender: TObject);
begin
     SelectedItem:='Z';
     VarForm.Close;
     end;
end.
