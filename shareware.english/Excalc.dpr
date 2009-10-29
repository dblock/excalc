(*                   Expression Calculator launch Unit (Object Pascal)
                           (c) Daniel Doubrovkine
  Stolen Technologies Inc. - University of Geneva - 1996 - All Rights Reserved
            for Scientific Calculator, version revised on 01.07.96
*)
program excalc;

uses
  Forms,
  Dialogs,
  TreeView in '..\common\treeview.pas',
  VarPanel in '..\common\VarPanel.pas' {VarForm},
  MCalc in '..\common\MCalc.pas',
  SysUtils,
  WinProcs,
  TExec in '..\common\TExec.pas',
  Define in '..\common\Define.pas' {DefineFunc},
  ceError in '..\common\ceError.pas',
  init in '..\shareware.common\init.pas' {ExCalcInit},
  MDlg in '..\common\MDlg.pas' {MsgForm},
  d32debug in '..\..\XReplace-32\Classes\Common\d32debug.pas',
  d32errors in '..\..\XReplace-32\Classes\Common\d32errors.pas',
  d32gen in '..\..\XReplace-32\Classes\Common\d32gen.pas',
  d32reg in '..\..\XReplace-32\Classes\Common\d32reg.pas',
  PWait in '..\common\PWait.pas' {ProgressWait},
  ScCalc in '..\shareware.common\ScCalc.pas' {Calculator},
  Options in '..\common\Options.pas' {FormCalculatorOptions},
  Globals in '..\common\Globals.pas',
  d32about in '..\..\XReplace-32\Classes\Common\d32about.pas',
  HlpBrowser in '..\common\HlpBrowser.pas' {HtmlHelp};

{$R *.RES}

begin
   InitializeExpressionCalculator;
   Application.Run;

end.
