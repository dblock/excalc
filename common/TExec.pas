unit TExec;
{(c) Daniel Doubrovkine - 1996 - Stolen Technologies Inc. - University of Geneva }
{ All Rights Reserved                                                            }

interface

uses Classes, WinProcs, SysUtils;

type
  TFileExecute = class (TThread)
     private
        ApplicationPath: string;
        ApplicationParams: string;
        ApplicationVisibility: word;
     public
        constructor Create(const AppPath, AppParams: string; Visibility: word); virtual;
     protected
        function CreateProcessAndWait(const AppPath, AppParams: String; Visibility: word): DWord;
        procedure Execute; override;
     end;

implementation

constructor TFileExecute.Create(const AppPath, AppParams: string; Visibility: word);
begin
   ApplicationPath:=AppPath;
   ApplicationParams:=AppParams;
   ApplicationVisibility:=Visibility;
   inherited Create(False);
   end;

procedure TfileExecute.Execute;
begin
   try
   CreateProcessAndWait(ApplicationPath, ApplicationParams, ApplicationVisibility);
   except
   (*MessageDlg('Exception Raised, error code '+IntToStr(GetLastError),mtError,[mbOk],0);*)
   end;
   end;

function TFileExecute.CreateProcessAndWait(const AppPath, AppParams: String; Visibility: word): DWord;
var
   SI: TStartupInfo;
   PI: TProcessInformation;
   Proc: THandle;
begin
   FillChar(SI, SizeOf(SI), 0);
   SI.cb := SizeOf(SI);
   SI.wShowWindow := Visibility;
   if not CreateProcess(PChar(AppPath), PChar(AppPath+' '+AppParams), Nil, Nil, False,Normal_Priority_Class, Nil, Nil, SI, PI) then
      raise Exception.CreateFmt('Failed to execute program.  Error Code %d',[GetLastError]);
   Proc := PI.hProcess;
   CloseHandle(PI.hThread);
   if WaitForSingleObject(Proc, Infinite) <> Wait_Failed then
      GetExitCodeProcess(Proc, Result);
   CloseHandle(Proc);
   end;

end.
