(*                      About Box Unit (Object Pascal)
                           (c) Daniel Doubrovkine
  Stolen Technologies Inc. - University of Geneva - 1996 - All Rights Reserved
            for Scientific Calculator, version revised on 01.07.96
*)
unit About;

interface

uses Forms, StdCtrls, ComCtrls, Controls, Buttons, ExtCtrls, Classes, Messages, TExec;

type
  TAboutBox = class(TForm)
    Label1: TLabel;
    Label7: TLabel;
    Label2: TLabel;
    FClose: TImage;
    Memo2: TMemo;
    VersionLabel: TLabel;
    Timer1: TTimer;
    Memo1: TMemo;
    CloseBevel: TBevel;
    RegExCalc: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    function  MemStatusString : string;
    procedure FCloseClick(Sender: TObject);
    procedure RegExCalcClick(Sender: TObject);
  private
    procedure WMNCHitTest(var M: TWMNCHitTest); message wm_NCHitTest;
  end;

var
   AboutBox: TAboutBox;

implementation

uses init, WinTypes, ScCalc, WinProcs, Dialogs, SysUtils;

{$R *.DFM}

procedure TAboutBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Timer1.Enabled:=False;
   Action := caFree
   end;


function TAboutBox.MemStatusString : string;
var
   MemStatus: TMemoryStatus;
//   a: real;
begin
   try
   MemStatus.dwLength:=sizeOf(TMemoryStatus);
   GlobalMemoryStatus(MemStatus);

   {$ifDEF English}
    MemStatusString:='Total memory: '+FormatFloat('#,###" Kb (physical)"', MemStatus.dwTotalPhys/1024)+FormatFloat(' #,###" Kb"', MemStatus.dwTotalPageFile/1024) + ' (page file)' + Chr(13)+Chr(10) +
                     'Free memory: '+FormatFloat('#,###" Kb (physical)"', MemStatus.dwAvailPhys/1024)+FormatFloat(' #,###" Kb"', MemStatus.dwAvailPageFile/1024) + ' (page file)';
   {$ENDIF}
   {$IFDEF French}
    MemStatusString:='Mémoire totale: '+FormatFloat('#,###" Kb (physique)"', MemStatus.dwTotalPhys/1024)+FormatFloat(' #,###" Kb"', MemStatus.dwTotalPageFile/1024) + ' (fichier d''échange)' + Chr(13)+Chr(10)+
                     'Mémoire disponible: '+FormatFloat('#,###" Kb (physique)"', MemStatus.dwAvailPhys/1024)+FormatFloat(' #,###" Kb"', MemStatus.dwAvailPageFile/1024) + ' (fichier d''échange)';
   {$ENDIF}
   {$IFDEF German}
    MemStatusString:='Speicher (gesamt): '+FormatFloat('#,###" Kb (physisch)"', MemStatus.dwTotalPhys/1024)+FormatFloat(' #,###" Kb"', MemStatus.dwTotalPageFile/1024) + ' (potentiell)' + Chr(13)+Chr(10)+
                     'Speicher (verfügbar): '+FormatFloat('#,###" Kb (physisch)"', MemStatus.dwAvailPhys/1024)+FormatFloat(' #,###" Kb"', MemStatus.dwAvailPageFile/1024) + ' (potentiell)';
   {$ENDIF}
   except
   {$ifDEF English} MemStatusString:='(unable to get memory information)';{$ENDIF}
   {$IFDEF French}  MemStatusString:='(l''état de la mémoire n''a pas pu être déterminé)';{$ENDIF}
   {$IFDEF German}  MemStatusString:='(die Auskunft auf den Speicher konnte nicht erreicht sein)';{$ENDIF}
   end;
   end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
   OnClose:=FormClose;
   Timer1.Enabled:=True;
   AboutBox.Caption:='About the Expression Calculator '+ECVersion+' (multithread)';
   Label1.Caption:='Expression Calculator '+ECVersion;
   VersionLabel.Caption:=VersionString + Chr(10) + Chr(13) + MemStatusString;
   AboutBox.ClientHeight:=VersionLabel.Top+VersionLabel.Height+3;
   VersionLabel.Width:=AboutBox.ClientWidth;
   {$ifDEF English} AboutBox.Caption:='About the Expression Calculator';{$ENDIF}
   {$IFDEF French}  AboutBox.Caption:='A propos de Expression Calculator';{$ENDIF}
   {$IFDEF German}  AboutBox.Caption:='Uber Expression Calculator';{$ENDIF}
   {$IfDef Registered}
   AboutBox.RegExCalc.Visible:=False;
   {$ifndef Uni}
   Memo1.Text:=Memo1.Text + 'This software is a REGISTERED SHAREWARE, If you are a registered user, you may get the latest release at http://www.infomaniak.ch/~dblock.';
   {$endif}
   {$else}
   Memo1.Text:=Memo1.Text + 'This software is SHAREWARE, you must register after trying it for a period of a maximum of 15 days. You may get the latest release and register online at http://www.infomaniak.ch/~dblock.';
   {$EndIf}
   {$ifdef Uni}
   Memo1.Text:=Memo1.Text + #13#10+'This special version is licenced exclusively to the University of Geneva and may not be distributed freely outside the University domain.';
   {$endif}

   end;

procedure TAboutBox.Timer1Timer(Sender: TObject);
begin
   VersionLabel.Caption:=VersionString + Chr(10) + Chr(13) + MemStatusString;
   VersionLabel.Width:=AboutBox.ClientWidth;
   end;

procedure TAboutBox.WMNCHitTest(var M: TWMNCHitTest);
var
   x, y: integer;
begin
   inherited;
   x:=M.xPos - AboutBox.Left;
   y:=M.yPos - AboutBox.Top;
   if (not((x <= CloseBevel.Width) and
           (y <= CloseBevel.Height))) then
   if M.Result = htClient then
      M.Result := htCaption;
   end;

procedure TAboutBox.FCloseClick(Sender: TObject);
begin
   AboutBox.Close;
   end;

procedure TAboutBox.RegExCalcClick(Sender: TObject);
begin
   TFileExecute.Create(ExtractFilePath(Application.ExeName)+'REGISTER.EXE', '', 0);
   end;

end.


