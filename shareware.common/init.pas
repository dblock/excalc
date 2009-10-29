 (*                   Expression Calculator Init Unit (Object Pascal)
                           (c) Daniel Doubrovkine
  Stolen Technologies Inc. - University of Geneva - 1996 - All Rights Reserved
            for Scientific Calculator, version revised on 01.07.96
*)
unit init;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Registry, Buttons, d32about, d32reg;

type

 TExCalcInit = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    Image2: TImage;
    Image3: TImage;
    Image1: TImage;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HideTitlebar;
    procedure CreateVersionString;
    function  QueryRegistry(RegSection: HKey; RegMain, RegKey : PChar): string;
    procedure AddRegistryStr(RegSection: HKey; RegMain, RegKey, RegValue : PChar);
    procedure AddRegistryVal(RegSection: HKey; RegMain, RegKey: PChar; RegValue : integer);
    procedure FormDeactivate(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    function QueryRegistryVal(RegSection: HKEY; RegMain, RegKey: PChar; DefaultValue: integer): integer;
   private
    procedure WMNCHitTest(var M: TWMNCHitTest); message wm_NCHitTest;
    end;

const
    gReg : string = '\Software\Vestris Inc.\Expression Calculator\2.x';
    gRegUserFunc : string = '\Software\Vestris Inc.\Expression Calculator\2.x\User Functions';

var
   ExCalcInit : TExCalcInit;
   VersionString: string;
   NoQuit : boolean = False;

implementation

uses ScCalc;

{$R *.DFM}

procedure TExCalcInit.CreateVersionString;
const
   ComputerNameSize : DWORD = 255;
var
   SystInfo : TSystemInfo;
function GetProcessorInfo: string;
begin
   case SystInfo.wProcessorArchitecture of
      0: case SystInfo.wProcessorLevel of
      3,386: Result:='Intel 386';
      4,486: Result:='Intel 486';
      5,586: Result:='Intel Pentium';
      else
      case SystInfo.dwProcessorType of
         1,386: Result:='Intel 386';
         2,486: Result:='Intel 486';
         3,586: Result:='Intel Pentium';
         else Result:='Intel';
         end;
         end;
      1: case SystInfo.wProcessorLevel of
      4: Result:='Mips R4000';
      else Result:='Mips';
      end;
      2: case SystInfo.wProcessorLevel of
         21064: Result:='Alpha 21064';
         21066: Result:='Alpha 21066';
         21164: Result:='Alpha 21164';
         else Result:='Alpha';
         end;
      3: case SystInfo.wProcessorLevel of
         1: Result:='PowerPC 601';
         3: Result:='PowerPC 603';
         4: Result:='PowerPC 604';
         6: Result:='PowerPC 603+';
         9: Result:='PowerPC 604+';
         20: Result:='PowerPC 620';
         else Result:='PowerPC';
         end;
      end;
   end;
var
   ComputerName : array [0..255] of char;
   VersionInfo: TOsVersionInfo;
   i : integer;
   ProcessorId: PChar;
begin
   VersionInfo.dwOsVersionInfoSize:=sizeof(TOsVersionInfo);
   if (GetVersionEx(VersionInfo)=false) then begin
     {$ifDEF English}VersionString:='<unable to get system information>';{$ENDIF}
     {$IFDEF French}VersionString:='<impossible d''obtenir les informations système>';{$ENDIF}
     {$IFDEF German}VersionString:='<unmöglich die System Information zu bekommen>';{$ENDIF}
      exit;
      end;
   GetSystemInfo(SystInfo);
   try
   if GetComputerName(ComputerName,ComputerNameSize)=false then
      {$ifDEF English}ComputerName:='this computer';{$ENDIF}
      {$IFDEF French} ComputerName:='cet ordinateur';{$ENDIF}
      {$IFDEF German} ComputerName:='dieser Computer';{$ENDIF}
   except
      {$ifDEF English}ComputerName:='this computer';{$ENDIF}
      {$IFDEF French} ComputerName:='cet ordinateur';{$ENDIF}
      {$IFDEF German} ComputerName:='dieser Computer';{$ENDIF}
   end;
   {$ifDEF English} VersionString:=ComputerName + ' is running on '+ IntToStr(SystInfo.dwNumberofProcessors) + ' ' + GetProcessorInfo + ' processor(s)';{$ENDIF}
   {$IFDEF French}  VersionString:=ComputerName + ' fonctionne avec '+ IntToStr(SystInfo.dwNumberofProcessors) + ' processeur(s) ' + GetProcessorInfo;{$ENDIF}
   {$IFDEF German}  VersionString:=ComputerName + ' funktioniert mit '+ IntToStr(SystInfo.dwNumberofProcessors) + ' ' + GetProcessorInfo + ' prozessor(s)'; {$ENDIF}
   if SystInfo.dwNumberofProcessors>1 then VersionString:=VersionString+'s';
   ProcessorId:=StrAlloc(1024);
   try
   if VersionInfo.dwPlatformId=2 then
   for i:=0 to SystInfo.dwNumberofProcessors - 1 do begin
      StrPCopy(ProcessorId,'HARDWARE\DESCRIPTION\System\CentralProcessor\'+IntToStr(i));
      VersionString:=VersionString+Chr(13)+Chr(10)+
             QueryRegistry(HKEY_LOCAL_MACHINE,ProcessorId,'VendorIdentifier')+' '+
             QueryRegistry(HKEY_LOCAL_MACHINE,ProcessorId,'Identifier');
      if Trim(QueryRegistry(HKEY_LOCAL_MACHINE,ProcessorId,'~MHz'))<>'' then
         {$ifDEF English}VersionString:=VersionString+' at ';{$ENDIF}
         {$IFDEF French}VersionString:=VersionString+' à ';{$ENDIF}
         {$IFDEF German}VersionString:=VersionString+' auf ';{$ENDIF}
         VersionString:=VersionString + QueryRegistry(HKEY_LOCAL_MACHINE,ProcessorId,'~MHz')+' MHz';
      end;
   finally
      StrDispose(ProcessorId);
   end;

   {$ifDEF English}VersionString:=VersionString + Chr(13)+Chr(10)+'under';{$ENDIF}
   {$IFDEF French}VersionString:=VersionString + Chr(13)+Chr(10)+'sous';{$ENDIF}
   {$IFDEF German}VersionString:=VersionString + Chr(13)+Chr(10)+'auf';{$ENDIF}

   case VersionInfo.dwPlatformId of
      0 : VersionString:=VersionString + ' Windows 3.1x ';   {this should not be possible}
      1 : VersionString:=VersionString + ' Windows 95 ';
      2 : VersionString:=VersionString + ' Windows NT ';
      end;
   VersionString:=VersionString +
                  IntToStr(VersionInfo.dwMajorVersion) + '.' +
                  IntToStr(VersionInfo.dwMinorVersion) + ' (build '+
                  IntToStr(VersionInfo.dwBuildNumber and $FFFF)+')';
   end;

procedure TExCalcInit.Timer1Timer(Sender: TObject);
begin
   Timer1.Enabled:=False;
   ExCalcInit.Destroy;
   end;

Procedure TExCalcInit.HideTitlebar;
Var
   Save : LongInt;
Begin
   if BorderStyle=bsNone then Exit;
   Save:=GetWindowLong(Handle,gwl_Style);
   if (Save and ws_Caption)=ws_Caption then Begin
      Case BorderStyle of
         bsSingle,
         bsSizeable : SetWindowLong(Handle,gwl_Style,Save and
           (not(ws_Caption)) or ws_border);
         bsDialog : SetWindowLong(Handle,gwl_Style,Save and
           (not(ws_Caption)) or ds_modalframe or ws_dlgframe);
         end;
     Height:=Height-getSystemMetrics(sm_cyCaption);
     Refresh;
     end;
   end;

procedure TExCalcInit.FormCreate(Sender: TObject);
begin
   Label1.Top:=Image1.Top+Image1.Height;
   ClientWidth:=Image1.Width-1;
   CreateVersionString;
   Label1.Caption:=
      VersionString + #10#13 +
      MemStatusString  + #10#13 +
      ECVersion;
   {$ifDef Registered}
   Label1.Caption := Label1.Caption + ' - Registered Shareware Version';
   {$Else}
   Label1.Caption := Label1.Caption + ' - Shareware Version - Please Register!';
   {$EndIf}
   {$ifdef Uni}
   UniGe.Visible:=True;
   {$endif}
   Label1.Width:=ClientWidth;
   HideTitleBar;
   ClientHeight:=Image1.Height-1+Label1.Height+5;
   end;

function TExCalcInit.QueryRegistry(RegSection: HKey; RegMain, RegKey : PChar): string;
begin
   Result := QueryReg(RegSection, RegMain, RegKey);
   end;

procedure TExCalcInit.AddRegistryStr(RegSection: HKey; RegMain, RegKey, RegValue : PChar);
begin
   AddReg(RegSection, RegMain, RegKey, string(RegValue));
   end;

procedure TExCalcInit.AddRegistryVal(RegSection: HKey; RegMain, RegKey: PChar; RegValue : integer);
begin
   AddReg(RegSection, RegMain, RegKey, RegValue);
   end;

procedure TExCalcInit.FormDeactivate(Sender: TObject);
begin
   with Image1.Picture.bitmap do begin
      Canvas.Draw(0,0,Image1.Picture.bitmap);
      Update;
      end;
   end;

procedure TExCalcInit.Image2Click(Sender: TObject);
begin
   if Timer1.Enabled then timer1.Enabled:=False else begin
      Hide;
      end;
   end;

procedure TExCalcInit.WMNCHitTest(var M: TWMNCHitTest);
begin
   inherited;
   if M.Result = htClient then begin
    with Image2 do
     with M do begin
         if (XPos>Left+ExCalcInit.Left) and
            (XPos<Left+Width+ExCalcInit.Left) and
            (YPos>Top+ExCalcInit.Top) and
            (YPos<Top+Height+ExCalcInit.Top) then
             exit;
        end;
    with Image3 do
     with M do begin
         if (XPos>Left+ExCalcInit.Left) and
            (XPos<Left+Width+ExCalcInit.Left) and
            (YPos>Top+ExCalcInit.Top) and
            (YPos<Top+Height+ExCalcInit.Top) then
             exit;
        end;
      M.Result := htCaption;
      end;
   end;

procedure TExCalcInit.Image3Click(Sender: TObject);
begin
   NoQuit:=True;
   end;

function TExCalcInit.QueryRegistryVal(RegSection: HKEY; RegMain, RegKey: PChar; DefaultValue: integer): integer;
var
   RegString: string;
begin
   try
      RegString := QueryRegistry(RegSection, RegMain, RegKey);
      if (RegString = '') then begin
         Result := DefaultValue;
      end else if (RegString <> '') then begin
         Result := StrToInt(RegString);
      end else begin
         Result := DefaultValue;
      end;
   except
      Result := DefaultValue;
   end;
   end;

end.
