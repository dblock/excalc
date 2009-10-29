unit PWait;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TProgressWait = class(TForm)
    Panel1: TPanel;
    PLegend: TLabel;
    ProgressBar: TProgressBar;
    Panel2: TPanel;
    cmdCancel: TBitBtn;
    procedure cmdCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FCancelled : boolean;
    procedure SetProgress(Value: integer);
    procedure SetLegend(Value: string);
  public
  published
    property Cancelled: boolean read FCancelled;
    property Progress: integer write SetProgress;
    property Legend: string write SetLegend;
  end;

var
  ProgressWait: TProgressWait;

implementation

{$R *.DFM}

procedure TProgressWait.cmdCancelClick(Sender: TObject);
begin
     FCancelled := True;
     cmdCancel.Enabled := False;
     Hide;
     end;

procedure TProgressWait.SetProgress(Value: integer);
begin
     if (ProgressBar.Position <> Value) then begin
        ProgressBar.Position := Value;
        end;
     end;

procedure TProgressWait.FormShow(Sender: TObject);
begin
     FCancelled := False;
     cmdCancel.Enabled := True;
     end;

procedure TProgressWait.SetLegend(Value: string);
begin
     if (PLegend.Caption <> Value) then begin
        PLegend.Caption := Value;
        end;
     end;

procedure TProgressWait.FormCreate(Sender: TObject);
begin
     FCancelled := False;
     end;

end.
