unit Globals;

interface

uses
  Forms,
  Dialogs,
  SysUtils,
  WinProcs;

procedure InitializeExpressionCalculator;

implementation

uses Options, ScCalc, Init, Define, PWait;

procedure InitializeExpressionCalculator;
var
   i: integer;
   NoTitle: boolean;
begin

   Application.Initialize;
   Application.Title := 'Expression Calculator Multithread';

   NoTitle := not TFormCalculatorOptions.GetOption('show intro', true);

   for i := 1 to ParamCount do begin
       if CompareText(ParamStr(i),'notitle') = 0 then NoTitle:=True;
       if CompareText(ParamStr(i),'noquit') = 0 then NoQuit:=True;
       end;

   if not NoTitle then begin
      Application.CreateForm(TExCalcInit, ExCalcInit);
      ExCalcInit.Show;
      ExcalcInit.Refresh;
      end;

   Application.CreateForm(TCalculator, Calculator);

   if NoTitle then
      ExCalcInit.CreateVersionString;

   Application.CreateForm(TDefineFunc, DefineFunc);
   Application.CreateForm(TProgressWait, ProgressWait);

   Calculator.Show;
   end;

end.
