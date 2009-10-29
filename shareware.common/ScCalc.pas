(*              Scientific Calc - 32 Interface Unit (Object Pascal)
                           (c) Daniel Doubrovkine
  Stolen Technologies Inc. - University of Geneva - 1996 - All Rights Reserved
            for Scientific Calculator, version revised on 01.07.96
*)
unit ScCalc;

interface

uses
  Math,SysUtils, Forms, Dialogs, TreeView, Buttons, Classes, Controls, Menus, Spin,
  ExtCtrls, StdCtrls, Grids, Messages, TExec, WinProcs, VarPanel, MCalc,
  ComCtrls, SpriteClass, Mdlg, d32about, d32reg, d32debug;

const
    MaxArraySize = (MaxInt div 2 div SizeOf(LongInt));
    {$ifDef English}
    EvalString : string = 'Evaluation in progress...';
    EvalSuspend : string = 'Suspended...';
    sIntegral: string ='(Gauss):';
    sPrime: string = 'Current prime';
    {$EndIf}
    {$ifDef French}
    EvalString : string = 'Evaluation en cours...';
    EvalSuspend : string = 'Suspendu...';
    sIntegral: string ='(Gauss):';
    sPrime: string = 'Premier actuel:';
    {$EndIf}
    {$ifDef German}
    EvalString : string = 'Rechnung...';
    EvalSuspend : string = 'Eingestellt...';
    sIntegral: string ='(Gauss):';
    sPrime: string = 'Lätzte Primfaktor:';
    {$EndIf}

   ECversionId: string = '020302100';
   ECVersion: string ='Expression Calculator 2.43';
   {$ifdef Registered}
   ECBuild: string = 'build 2.43.0522';
   {$else}
   ECBuild: string = 'build 2.43.0522 - unregistered';
   {$endif}

   {$ifndef Registered}
   ShareWareMax : integer = 15;
   {$endif}

    ProtectedVars : array[1..4] of char = ('E','e','G','m');

type
//  PBinArray = ^TBinArray;
//  TBinArray = array[0..MaxBinArraySize] of byte;

  PPrimesArray=^TPrimesArray;
  TPrimesArray=array[0..MaxArraySize] of LongInt;
  PResultsArray=^TResultsArray;
  TResultsArray=array[0..MaxArraySize div 2] of extended;
  tCopyType = (expression, short, long);
  tCopySet = set of TCopyType;
  {this is just a definition..does not allocate 1GB of ram}

type
  TExecute = class (TThread)
    private
     CalcString:string;
     CalcMode:TCalcMode;
     CalcId:integer;
    protected
     procedure Execute; override;
    public
     constructor Create(CurrentString:string;MyCalcMode:TCalcMode);
     end;

  TCalculator = class(TForm)
    CalcEdit: TEdit;
    CalcGrid: TStringGrid;
    CalcPanel: TPanel;
    CalcLabel: TLabel;
    ModePanel: TPanel;
    DegMode: TSpeedButton;
    RadMode: TSpeedButton;
    CalcLabelFull: TLabel;
    SelPanel: TPanel;
    CalcIndicator: TLabel;
    AboutButton: TSpeedButton;
    AbortButton: TSpeedButton;
    OpMenu: TPopupMenu;
    gcd: TMenuItem;
    Fibonacci1: TMenuItem;
    EulerPhi: TMenuItem;
    EulerGamma: TMenuItem;
    FractPart: TMenuItem;
    IntPart: TMenuItem;
    Floor: TMenuItem;
    Ceiling: TMenuItem;
    RandomOp: TMenuItem;
    Truncate: TMenuItem;
    Round: TMenuItem;
    Maxxy1: TMenuItem;
    Minxy1: TMenuItem;
    Mersenne: TMenuItem;
    MersenneGen: TMenuItem;
    MersGen: TMenuItem;
    GenMers: TMenuItem;
    Perfect: TMenuItem;
    lcm: TMenuItem;
    PrimeX: TMenuItem;
    HexFlag: TSpeedButton;
    BinFlag: TSpeedButton;
    OctFlag: TSpeedButton;
    InterruptMenu: TPopupMenu;
    CancelAll: TMenuItem;
    Cancel: TMenuItem;
    ExitEC: TMenuItem;
    Average: TMenuItem;
    Suspend: TMenuItem;
    Resume: TMenuItem;
    SuspendAll: TMenuItem;
    ResumeAll: TMenuItem;
    N8: TMenuItem;
    EulerFncts: TMenuItem;
    EulerBeta: TMenuItem;
    PrimDiv: TMenuItem;
    N6: TMenuItem;
    Other: TMenuItem;
    RanAv: TMenuItem;
    N3: TMenuItem;
    PrimesI: TMenuItem;
    PrimeC: TMenuItem;
    PrimeN: TMenuItem;
    Binom: TMenuItem;
    Special: TMenuItem;
    ClearPrimes: TMenuItem;
    CopyPrimes: TMenuItem;
    Reset: TMenuItem;
    ButtonSizeUp: TSpeedButton;
    ButtonSizeDown: TSpeedButton;
    CopyMenu: TMenuItem;
    cExp: TMenuItem;
    cShort: TMenuItem;
    cLong: TMenuItem;
    TaskForce: TMenuItem;
    N2: TMenuItem;
    SaveGrid: TMenuItem;
    N4: TMenuItem;
    LoadGrid: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Catalan: TMenuItem;
    N7: TMenuItem;
    N5: TMenuItem;
    N9: TMenuItem;
    Approx: TMenuItem;
    IntExact: TMenuItem;
    Trapezoid: TMenuItem;
    N10: TMenuItem;
    Newton1: TMenuItem;
    Boole1: TMenuItem;
    OrderSix: TMenuItem;
    Weddle1: TMenuItem;
    IntGauss1: TMenuItem;
    Summ: TMenuItem;
    Product: TMenuItem;
    N11: TMenuItem;
    EulerG: TMenuItem;
    N12: TMenuItem;
    Series: TMenuItem;
    Harmonic: TMenuItem;
    Sigmanp1: TMenuItem;
    Taun1: TMenuItem;
    Dilog: TMenuItem;
    Trig: TMenuItem;
    Si: TMenuItem;
    Ci: TMenuItem;
    Ssi: TMenuItem;
    Shi: TMenuItem;
    Chi: TMenuItem;
    ErfError: TMenuItem;
    ErcfCompl: TMenuItem;
    IntegralsFresnel1: TMenuItem;
    FresnelC: TMenuItem;
    FresnelS: TMenuItem;
    FresnelF: TMenuItem;
    FresnelG: TMenuItem;
    Integrals: TMenuItem;
    Elliptic: TMenuItem;
    EllipticE: TMenuItem;
    EllipticCE: TMenuItem;
    EllipticF: TMenuItem;
    EllipticK: TMenuItem;
    EllipticCK: TMenuItem;
    Pochhammern1: TMenuItem;
    N13: TMenuItem;
    DropIntegral: TMenuItem;
    Fermat: TMenuItem;
    N14: TMenuItem;
    UserDefine: TMenuItem;
    Edit: TMenuItem;
    N15: TMenuItem;
    OpButton: TSpeedButton;
    HelpButton: TSpeedButton;
    N1: TMenuItem;
    ClipProcess: TMenuItem;
    cAll: TMenuItem;
    cAllShort: TMenuItem;
    cAllLong: TMenuItem;
    cAllShortEv: TMenuItem;
    cAllLongEv: TMenuItem;
    cEverything: TMenuItem;
    N17: TMenuItem;
    RegCommand: TSpeedButton;
    RegisterSeparator: TMenuItem;
    RegisterCommand: TMenuItem;
    RegExCalc: TMenuItem;
    OpsBar: TProgressBar;
    Dawson: TMenuItem;
    SafePrime: TMenuItem;
    IsPrime: TMenuItem;
    ValuePanel: TPanel;
    Value7: TSprite;
    Value8: TSprite;
    Value9: TSprite;
    Value4: TSprite;
    Value5: TSprite;
    Value6: TSprite;
    Value1: TSprite;
    Value2: TSprite;
    Value3: TSprite;
    Value0: TSprite;
    ValuePoint: TSprite;
    ExpVal: TSprite;
    OpPanel: TPanel;
    DelOp: TSprite;
    COp: TSprite;
    ACOp: TSprite;
    OpMult: TSprite;
    OpDiv: TSprite;
    RclOp: TSprite;
    OpPlus: TSprite;
    OpMinus: TSprite;
    StoOp: TSprite;
    AnsOp: TSprite;
    functionExe: TSprite;
    OpOff: TSprite;
    OpLeftPanel: TPanel;
    SinOp: TSprite;
    CotOp: TSprite;
    log: TSprite;
    CosOp: TSprite;
    ln: TSprite;
    IntDiv: TSprite;
    IntMod: TSprite;
    LogN: TSprite;
    AbsOp: TSprite;
    Factor: TSprite;
    Percent: TSprite;
    EPowerX: TSprite;
    EVal: TSprite;
    PiVal: TSprite;
    PhiOp: TSprite;
    Arc: TSprite;
    Hyp: TSprite;
    NotOp: TSprite;
    HexPanel: TPanel;
    ValD: TSprite;
    ValE: TSprite;
    ValF: TSprite;
    ValA: TSprite;
    ValB: TSprite;
    ValC: TSprite;
    OpRightPanel: TPanel;
    TanOp: TSprite;
    SecOp: TSprite;
    CscOp: TSprite;
    SqrtRoot: TSprite;
    SqrtOp: TSprite;
    sqrOp: TSprite;
    OrOp: TSprite;
    XorOp: TSprite;
    AndOp: TSprite;
    ShrOp: TSprite;
    ShlOp: TSprite;
    Power: TSprite;
    IntOp: TSprite;
    LeftParenthesis: TSprite;
    RightParenthesis: TSprite;
    Options: TMenuItem;
    N123: TMenuItem;
    MnuOptions: TMenuItem;
    procedure FunctionEXEClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpdateCalcGrid;
    procedure UpdateEntryBox;
    procedure CalcEditKeyPress(Sender: TObject; var Key: Char);
    procedure UpdateCalcPanel;
    procedure Value0Click(Sender: TObject);
    procedure ValuePointClick(Sender: TObject);
    procedure InsertCalcEditChar(IChar:string);
    procedure Value1Click(Sender: TObject);
    procedure Value2Click(Sender: TObject);
    procedure Value3Click(Sender: TObject);
    procedure Value4Click(Sender: TObject);
    procedure Value5Click(Sender: TObject);
    procedure Value6Click(Sender: TObject);
    procedure Value7Click(Sender: TObject);
    procedure Value8Click(Sender: TObject);
    procedure Value9Click(Sender: TObject);
    procedure OpMultClick(Sender: TObject);
    procedure OpDivClick(Sender: TObject);
    procedure OpMinusClick(Sender: TObject);
    procedure OpPlusClick(Sender: TObject);
    procedure CalcGridSelectCell(Sender: TObject; Col, Row: Longint;var CanSelect: Boolean);
    procedure CalcGridDblClick(Sender: TObject);
    procedure CalcEditKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure SinOpClick(Sender: TObject);
    procedure COSOpClick(Sender: TObject);
    procedure TANOpClick(Sender: TObject);
    procedure COTOpClick(Sender: TObject);
    procedure SECOpClick(Sender: TObject);
    procedure CSCOpClick(Sender: TObject);
    procedure EXPValClick(Sender: TObject);
    procedure ANSOpClick(Sender: TObject);
    procedure COpClick(Sender: TObject);
    procedure DELOpClick(Sender: TObject);
    procedure ACOpClick(Sender: TObject);
    procedure AppException(Sender: TObject; E: Exception);
    procedure CalcGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure OPOffClick(Sender: TObject);
    procedure STOOpClick(Sender: TObject);
    procedure RCLOpClick(Sender: TObject);
    procedure DegModeClick(Sender: TObject);
    procedure RadModeClick(Sender: TObject);
    procedure NewOpClick(Sender: TObject);
    procedure IntModClick(Sender: TObject);
    procedure IntDivClick(Sender: TObject);
    procedure EPowerXClick(Sender: TObject);
    procedure SqrtOpClick(Sender: TObject);
    procedure LogClick(Sender: TObject);
    procedure EValClick(Sender: TObject);
    procedure SqrtRootClick(Sender: TObject);
    procedure LnClick(Sender: TObject);
    procedure PiValClick(Sender: TObject);
    procedure FactorClick(Sender: TObject);
    procedure PercentClick(Sender: TObject);
    procedure PowerClick(Sender: TObject);
    procedure RightParenthesisClick(Sender: TObject);
    procedure LeftParenthesisClick(Sender: TObject);
    procedure LognClick(Sender: TObject);
    procedure MaxClick(Sender: TObject);
    procedure MinClick(Sender: TObject);
    procedure TruncOpClick(Sender: TObject);
    procedure FracOpClick(Sender: TObject);
    procedure RoundOpClick(Sender: TObject);
    procedure CeilOpClick(Sender: TObject);
    procedure FloorOpClick(Sender: TObject);
    procedure AbsOpClick(Sender: TObject);
    procedure IntOpClick(Sender: TObject);
    procedure RandomOpClick(Sender: TObject);
    procedure AboutButtonClick(Sender: TObject);
    procedure SqrOpClick(Sender: TObject);
    procedure XorOpClick(Sender: TObject);
    procedure OrOpClick(Sender: TObject);
    procedure AndOpClick(Sender: TObject);
    procedure ShrOpClick(Sender: TObject);
    procedure ShlOpClick(Sender: TObject);
    procedure AbortButtonClick(Sender: TObject);
    procedure FibOpClick(Sender: TObject);
//    procedure SpinButton1DownClick(Sender: TObject);
//    procedure SpinButton1UpClick(Sender: TObject);
    procedure GCDOpClick(Sender: TObject);
    procedure OpButtonClick(Sender: TObject);
    procedure EulerGammaClick(Sender: TObject);
    procedure EulerPhiClick(Sender: TObject);
    procedure MersGenClick(Sender: TObject);
    procedure GenMersClick(Sender: TObject);
    procedure MersenneGenClick(Sender: TObject);
    procedure MersenneClick(Sender: TObject);
    procedure lcmClick(Sender: TObject);
    procedure PerfectClick(Sender: TObject);
    procedure PrimeXClick(Sender: TObject);
    procedure HexFlagClick(Sender: TObject);
    procedure BinFlagClick(Sender: TObject);
    procedure OctFlagClick(Sender: TObject);
    procedure UpdateCalcButtons(MyMode:TCalcMode);
    procedure ConvertLastOperation(MyMode: TCalcMode);
    procedure CancelClick(Sender: TObject);
    procedure CancelAllClick(Sender: TObject);
    procedure ExitECClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AverageClick(Sender: TObject);
    procedure UpdateExpressions;
    procedure SuspendClick(Sender: TObject);
    procedure ResumeClick(Sender: TObject);
    procedure BringUpMedium;
    procedure BringUpSmall;
    procedure BringUpScientific;
    procedure SuspendAllClick(Sender: TObject);
    procedure ResumeAllClick(Sender: TObject);
    procedure SpeedButton1ClickHelpButton(Sender: TObject);
    procedure EulerBetaClick(Sender: TObject);
    procedure PrimesIClick(Sender: TObject);
    procedure PrimeNClick(Sender: TObject);
    procedure PrimeCClick(Sender: TObject);
    procedure BinomClick(Sender: TObject);
    procedure ClearPrimesClick(Sender: TObject);
    procedure CopyPrimesClick(Sender: TObject);
    procedure ResetClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ButtonSizeUpClick(Sender: TObject);
    procedure ButtonSizeDownClick(Sender: TObject);
    procedure cExpClick(Sender: TObject);
    procedure cShortClick(Sender: TObject);
    procedure cLongClick(Sender: TObject);
    procedure SaveGridClick(Sender: TObject);
    procedure LoadGridClick(Sender: TObject);
    procedure CatalanClick(Sender: TObject);
    procedure TrapezoidClick(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure Newton1Click(Sender: TObject);
    procedure Boole1Click(Sender: TObject);
    procedure OrderSixClick(Sender: TObject);
    procedure Weddle1Click(Sender: TObject);
    procedure IntGauss1Click(Sender: TObject);
    procedure SummClick(Sender: TObject);
    procedure ProductClick(Sender: TObject);
    procedure EulerGClick(Sender: TObject);
    procedure HarmonicClick(Sender: TObject);
    procedure Sigmanp1Click(Sender: TObject);
    procedure Taun1Click(Sender: TObject);
    procedure DilogClick(Sender: TObject);
    procedure SiClick(Sender: TObject);
    procedure CiClick(Sender: TObject);
    procedure SsiClick(Sender: TObject);
    procedure ShiClick(Sender: TObject);
    procedure ChiClick(Sender: TObject);
    procedure FresnelSClick(Sender: TObject);
    procedure FresnelCClick(Sender: TObject);
    procedure FresnelFClick(Sender: TObject);
    procedure FresnelGClick(Sender: TObject);
    procedure EllipticEClick(Sender: TObject);
    procedure EllipticCEClick(Sender: TObject);
    procedure EllipticFClick(Sender: TObject);
    procedure EllipticKClick(Sender: TObject);
    procedure EllipticCKClick(Sender: TObject);
    procedure Pochhammern1Click(Sender: TObject);
    procedure ErfErrorClick(Sender: TObject);
    procedure ErcfComplClick(Sender: TObject);
    procedure DropIntegralClick(Sender: TObject);
    procedure FermatClick(Sender: TObject);
    procedure CalcGridTopLeftChanged(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure ClipProcessClick(Sender: TObject);
    procedure cAllClick(Sender: TObject);
    procedure cEverythingClick(Sender: TObject);
    procedure cAllShortClick(Sender: TObject);
    procedure cAllLongClick(Sender: TObject);
    procedure cAllShortEvClick(Sender: TObject);
    procedure cAllLongEvClick(Sender: TObject);
    procedure RegCommandClick(Sender: TObject);
    procedure RegisterCommandClick(Sender: TObject);
    procedure DawsonClick(Sender: TObject);
    procedure SafePrimeClick(Sender: TObject);
    procedure IsPrimeClick(Sender: TObject);
    procedure ValAClick(Sender: TObject);
    procedure ValBClick(Sender: TObject);
    procedure ValCClick(Sender: TObject);
    procedure ValDClick(Sender: TObject);
    procedure ValEClick(Sender: TObject);
    procedure ValFClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpecialClick(Sender: TObject);
    procedure OptionsClick(Sender: TObject);
  private
    {$ifndef Registered}
    Expired: boolean;
    {$endif}
    GridSelect         : boolean;
    InsertRow          : integer;
    MinimumWidth       : LongInt;
    //MaximumWidth       : LongInt;
    MinimumHeight      : LongInt;
    MinGridHeight      : LongInt;
    //NormalGridHeight   : integer;
    ProbablyInterrupt  : integer;
    CurrentState       : array [0..10] of char;
    //MyVarTree          : PNode;
    procedure Another;
    procedure InitPrimes;
    procedure InsertLastOp;
    procedure UpdateModePanel;
    procedure UpdateSelPanel;
    //procedure ConstructOpArray;
    //procedure UpdateOpPanel;
    procedure UpdateDependencies;
    procedure WMwindowposchanging(var M: TWMwindowposchanging); message wm_windowposchanging;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure InsertOp(Key: word);
    function  GetEval(Count: integer):string;
    procedure CreateNewVar;
    procedure SetLanguage;
    function GetCell(var Arow: LongInt; cType: TCopySet):string;
    procedure GetResAll(cType: TCopySet; mStart, mStep: integer);
    procedure SetRegistered;
    procedure RegisterMsg (var Msg: TMsg; var Handled: boolean);
    procedure AppendToSystemMenu (Form: TForm; Item: string; ItemID: word);
    procedure ShowOptions;
    {$ifndef Registered}
    procedure SharewareNag;
    {$endif}
    procedure ReadOptions;
    procedure ShowHelp;
  public
    EvalResults        : PResultsArray;
    EvalCount          : longint;
    user_functions     : user_f;
    DroppedIntegral    : array[0..1] of integer;
    VarArray           : VariablesArray;
    PrimeTableUser     : longint;
    PrimeTableInUse    : boolean;
    EvalExpressions    : integer;
    LastResult         : extended;
    LastStrResult      : string;
    LastResultMode     : TCalcMode;
    PrimesCount        : longint;
    AllPrimes          : PPrimesArray;
    CurrentPrime       : LongInt;
    {$ifdef Registered}
    ScreenLimits       : boolean;
    {$endif}
    {$ifndef Registered}
    TillExpired: integer;
    {$endif}
    procedure          ResultsAdd(ResultToAdd: extended; ResultIndex: longint);
    procedure          ResultsRemove;
    procedure          PrimesAdd(PrimeToAdd:longint;var PrimesArray:PPrimesArray;var PrimesCount: longint);
    procedure          PrimesRemove(var PrimesArray: PPrimesArray);
    procedure          ReadRegistry;
    procedure          UpdateRegistry;
    procedure          UpdateUserMenu;
    procedure          UserMenuClick(Sender: tObject);
    end;

var
   Calculator   : TCalculator;

implementation

uses init, WinTypes, Clipbrd, Define, PWait, Options, SpriteReact,
  HlpBrowser;

{$R *.DFM}

procedure TCalculator.WMwindowposchanging(var M: TWMwindowposchanging);
begin
   try
   inherited;
   with M.WindowPos^ do begin
      if cx < MinimumWidth then cx:=MinimumWidth;
      if cy < MinimumHeight then cy:=MinimumHeight;
      if (cx <> Width) or (cy <> Height) then begin
         {$ifdef Registered}
         if ScreenLimits then begin
         {$endif}
            if x < 0 then begin cx:=cx+x; x:=0; end;
            if y < 0 then begin cy:=cy+y; y:=0; end;
            if x+cx > Screen.Width then begin
               cx:=Screen.Width-x;
               if cx < MinimumWidth then begin
                  cx:=MinimumWidth;
                  x := Screen.Width - cx;
                  end;
               end;
            if y+cy > Screen.Height then begin
               cy:=Screen.Height-y;
               if cy < MinimumHeight then begin
                  cy:=MinimumHeight;
                  y := Screen.Height - cy;
                  end;
               end;
            {$ifdef Registered}
            end;
            {$endif}
      end else
      {$ifdef Registered}
      if ScreenLimits then
      {$endif}
      begin
         if x<0 then x:=0;
         if y<0 then y:=0;
         if x+cx>Screen.Width then x:=Screen.Width-cx;
         if y+cy>Screen.Height then y:=Screen.Height-cy;
      end;
   end;
   except
   end;
   end;

procedure TCalculator.UpdateRegistry;
          function BoolToInt(Val: boolean): integer;
          begin
             if Val then Result:=1 else Result:=0;
             end;
begin
   try

   if not TFormCalculatorOptions.GetOption('save settings', true) then
        exit;

   ExCalcInit.AddRegistryStr(HKEY_CURRENT_USER,
                               PChar(gReg),
                               'init',
                               CurrentState);
   ExCalcInit.AddRegistryVal(HKEY_CURRENT_USER,
                               PChar(gReg),
                               'width',
                               Calculator.Width);
   ExCalcInit.AddRegistryVal(HKEY_CURRENT_USER,
                               PChar(gReg),
                               'height',
                               Calculator.Height);
   ExCalcInit.AddRegistryVal(HKEY_CURRENT_USER,
                               PChar(gReg),
                               'xpos',
                               Calculator.Left);
   ExCalcInit.AddRegistryVal(HKEY_CURRENT_USER,
                               PChar(gReg),
                               'ypos',
                               Calculator.Top);
   except
   end;
   DefineFunc.SaveXYPos;
   end;

procedure TCalculator.AppException(Sender: TObject; E: Exception);
begin
   {MessageDlg('ERROR::Expression Calculator ('+Sender.ClassName+':'+Format('%p',[Addr(Sender)])+') has raised an error.'+Chr(13)+Chr(10)+E.Message,mtError,[mbOk],0);}
   SysUtils.Beep;
   {$ifDEF English}CalcLabel.Caption:='Error';{$ENDIF}
   {$IFDEF French}CalcLabel.Caption:='Erreur';{$ENDIF}
   {$IFDEF German}CalcLabel.Caption:='Fehler';{$ENDIF}
   CalcLabelFull.Caption:=E.Message;
   dec(EvalExpressions);
   Calculator.OpsBar.Position:=Calculator.EvalExpressions * 10;
   if EvalExpressions=0 then AbortButton.Visible:=False
      else AbortButton.Visible:=True;
   UpdateCalcGrid;
   end;


procedure TCalculator.ResultsAdd(ResultToAdd: extended; ResultIndex: longint);
begin
   {$IFDEF Debug}DebugForm.Debug('ExCalc :: ResultsAdd ' + FloatToStr(ResultToAdd) + ' at ' + IntToStr(ResultIndex) + '.');{$ENDIF}
   if (ResultIndex >= EvalCount) then begin
      ReAllocMem(EvalResults, (ResultIndex + 1) * SizeOf(extended));
      EvalCount := ResultIndex;
      end;
   EvalResults^[ResultIndex] := ResultToAdd;
   end;

{-- primes table constructor ----------------------}
procedure TCalculator.PrimesAdd(PrimeToAdd:longint;var PrimesArray: PPrimesArray;var PrimesCount:LongInt);
begin
   ReAllocMem(PrimesArray,(PrimesCount+2)*SizeOf(LongInt));
   PrimesArray^[PrimesCount]:=PrimeToAdd;
   PrimesArray^[PrimesCount+1]:=0;
   inc(PrimesCount);
   {CurrentPrime:=PrimeToAdd;}
   end;

procedure TCalculator.ResultsRemove;
begin
   try
   FreeMem(EvalResults);
   EvalResults:=nil;
   except
   end;
   end;

{-- primes table destructor ------------------------}
procedure TCalculator.PrimesRemove(var PrimesArray: PPrimesArray);
begin
   try
   FreeMem(PrimesArray);
   PrimesArray:=nil;
   except
   end;
   end;

procedure TCalculator.FunctionEXEClick(Sender: TObject);
var
   ExecuteString : string;
   iRow : LongInt;
   tStr: string;
begin
   if Calculator.CalcEdit.Text='' then exit;

   ExecuteString:=Calculator.CalcEdit.Text;
   Calculator.CalcEdit.Text:='';

   if TFormCalculatorOptions.GetOption('direct mode', false) then
   if ExecuteString[1] in ['+','-','*','/','^','%','?','<','>','!'] then begin
      iRow := CalcGrid.RowCount - 3;
      tStr:=GetCell(iRow, [expression]);
      if tStr <> '' then
         ExecuteString:='('+tStr+')'+ExecuteString;
      end;

   {$ifndef Registered}
   if Expired then begin
      ShareWareNag;
      exit;
      end;
   {$endif}

   if OctFlag.Down then TExecute.Create(ExecuteString, Oct) else
   if BinFlag.Down then TExecute.Create(ExecuteString, Bin) else
   if HexFlag.Down then TExecute.Create(ExecuteString, Hex) else
   if RadMode.Down then TExecute.Create(ExecuteString, Rad) else
                        TExecute.Create(ExecuteString, Deg);
   end;

procedure TCalculator.UpdateCalcGrid;
var
   i:integer;
begin
   with CalcGrid do begin
      Left:=0;
      Width:=Calculator.ClientWidth;
      ColWidths[0]:=21;
      ColWidths[2]:=0;
      ColWidths[3]:=0;
      ColWidths[1]:=Width - ColWidths[0] - (ColCount * GridLineWidth);
      if RowCount>trunc(ClientHeight/DefaultRowHeight) then TopRow:=RowCount-trunc(ClientHeight/DefaultRowHeight);
      if EvalExpressions=0 then begin
         for i:=0 to RowCount-1 do begin
             if (Cells[1,i]=EvalString) or
                (Copy(Cells[1,i],1,Length(sIntegral))=sIntegral) then Cells[1,i]:='General exception fault.';
             end;
         end;
      end;
   end;

procedure TCalculator.UpdateCalcPanel;
begin
   CalcPanel.Left:=0;
   CalcPanel.Width:=Calculator.ClientWidth;
   //CalcPanel.top:=CalcEdit.Top+CalcEdit.Height;
   CalcLabel.Top:=2;
   CalcLabelFull.Top:=CalcLabel.Height+4;
   CalcLabel.Width:=CalcPanel.ClientWidth-4;
   CalcLabelfull.Width:=CalcLabel.Width;
   CalcLabel.Left:=2;
   CalcLabelFull.Left:=2;
   end;

procedure TCalculator.UpdateEntryBox;
begin
   CalcEdit.Left:=0;
   CalcEdit.Width:=Calculator.ClientWidth;
   //CalcEdit.Top:=CalcGrid.Top+CalcGrid.Height;
   end;

procedure TCalculator.InitPrimes;
begin
    PrimeTableInUse:=true;
    PrimesCount:=0;
    AllPrimes:=nil;
    PrimesAdd(0,AllPrimes,PrimesCount);
    PrimesAdd(1,AllPrimes,PrimesCount);
    PrimesAdd(2,AllPrimes,PrimesCount);
    PrimesAdd(3,AllPrimes,PrimesCount);
    PrimesAdd(5,AllPrimes,PrimesCount);
    CurrentPrime:=5;
    PrimeTableInUse:=false;
    end;

procedure TCalculator.FormCreate(Sender: TObject);
  {$ifndef Registered}
   procedure AddRevisionDate;
   var
      FirstRunDate: LongInt;
      Year, Mon, Day: Word;
   begin
        try
        DecodeDate(Now, Year, Mon, Day);
        FirstRunDate:=Day + Mon * 100 + Year * 10000;
        AddReg(HKEY_CURRENT_USER,   '\Console\Revision Data\_vxdr_ec',
                                       ECVersionID,
                                       FirstRunDate);
        except
        end;
        end;
   function ElapsedDays(First, Second: TDateTime): LongInt;
   var
      aYear, aMon, aDay,
      bYear, bMon, bDay: word;
      internal1, internal2: LongInt;
      jnum: real;
      cd: integer;
      sOut: string;

      function Jul( mo, da, yr: integer): real;
      var
         i, j, k, j2, ju: real;
      begin
           i := yr;     j := mo;     k := da;
           j2 := int( (j - 14)/12 );
           ju := k - 32075 + int(1461 * ( i + 4800 + j2 ) / 4 );
           ju := ju + int( 367 * (j - 2 - j2 * 12) / 12);
           ju := ju - int(3 * int( (i + 4900 + j2) / 100) / 4);
           Jul := ju;
           end;
      begin
        try
        DecodeDate(First, aYear, aMon, aDay);
        DecodeDate(Second, bYear, bMon, bDay);
        jnum:=jul(aMon,aDay,aYear);
        str(jnum:10:0,sOut);
        val(sOut,internal1,cd);
        jnum:=jul(bMon,bDay,bYear);
        str(jnum:10:0,sOut);
        val(sOut,internal2,cd);
        Result:=internal1-internal2;
        except
        AddRevisionDate;
        Result:=0;
        end;
        end;
   procedure ExpirationManager;
   var
      FirstRunDate: LongInt;
      aDate: TDateTime;
      Year, Mon, Day: Word;
   begin
        Expired:=False;
        try FirstRunDate:=QueryReg(HKEY_CURRENT_USER,
                    '\Console\Revision Data\_vxdr_ec',
                    ECVersionId); except FirstRunDate:=0; end;
        if FirstRunDate = -3 then begin
           SharewareNag;
           end else
        if FirstRunDate > 0 then begin
           try
           Year:=FirstRunDate div 10000;
           Mon:=FirstRunDate div 100 - Year * 100;
           Day:=FirstRunDate - Year * 10000 - Mon * 100;
           aDate:=EncodeDate(Year, Mon, Day);
           tillExpired:=ElapsedDays(Now, aDate);
           //ShowMessage(IntToStr(15 - eDays) + ' left till expiration.');
           if tillExpired > ShareWareMax then begin
              AddReg(HKEY_CURRENT_USER,   '\Console\Revision Data\_vxdr_ec',
                                          ECVersionID,
                                          -3);
              SharewareNag;
              end;
           except
           AddRevisionDate;
           end;
           end else begin
           AddRevisionDate;
           end;
        end;
   {$endif}
 begin
   {$ifndef Registered}
   ExpirationManager;
   {$endif}
   MinGridHeight := 80;
   BringUpScientific;
   MinimumWidth := OpLeftPanel.Width + OpRightPanel.Width + (Width - ClientWidth);
   //MaximumWidth:=Image1.Width;
   SetLanguage;
   SetRegistered;
   Application.HelpFile := ExtractFilePath(Application.ExeName) + 'docs\index.html';
   CalcLabelFull.Font.Size:=9;
   CalcIndicator.Font.Size:=7;
   CalcLabel.Font.Size:=11;
   CalcEdit.Font.Size:=10;
   CalcGrid.Font.Size:=8;
   InsertRow:=1;
   GridSelect:=True;
   //Calculator.Visible:=False;
   //NormalGridHeight:=0;

   Application.OnException := AppException;
   Calculator.Caption:=ECVersion;
   CurrentState:='scientific';
   UpdateDependencies;
   //NormalGridHeight:=CalcGrid.Height;
   EvalExpressions:=0;
   EvalCount := 0;
   EvalResults := nil;
   AbortButton.Visible:=False;
   RadMode.Down:=True;
   CreateNewVar;
   UpdateCalcGrid;
   UpdateEntryBox;
   UpdateCalcPanel;
   CalcEdit.TabOrder:=0;
   CalcLabel.Caption:='0.00';
   InitPrimes;
   ReadRegistry;
   ReadOptions;
   AppendToSystemMenu(Calculator, '&About the Expression Calculator', 199);
   Application.OnMessage := Calculator.RegisterMsg;
   if CurrentState = '' then CurrentState:='scientific';
   Calculator.Visible:=True;
   end;

procedure TCalculator.CalcEditKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = Chr(32) then OpButtonClick(Sender);

   if Ord(Key) in [3,24,22] then exit else
   if Key=Chr(27) then begin
      CalcEdit.Clear;
      Key:=Chr(0);
      end else
   if Key=Chr(13) then begin
      InsertRow:=CalcGrid.RowCount div 2+1;
      FunctionEXEClick(Self);{(FunctionEXE);}
      Key:=Chr(0);
      end;

   if OctFlag.Down then begin
      if Not(Key in ['0'..'7',
                     '+','-','/','\',')','(',
                     '*',Chr(8),'=','?','<','>']) then Key:=Chr(0);
      Key:=UpCase(Key);
      end else
   if BinFlag.Down then begin
      if Not(Key in ['0'..'1','+','-','/','\',')','(',
                     '*',Chr(8),'=','?','<','>']) then Key:=Chr(0);
      Key:=UpCase(Key);
      end else
   if HexFlag.Down then begin
      if Not(Key in ['A'..'F','0'..'9','a'..'f',
                     '+','-','/','\',')','(',
                     '*',Chr(8),'=','?','<','>']) then Key:=Chr(0);
      Key:=UpCase(Key);
      end else begin
      if Not(Key in ['A'..'Z','a'..'z','0'..'9',
                     '+','-','/','\',')','(',
                     '|','¦','*','!','^',Chr(8),
                     '.','%',',','=','?','<','>']) then Key:=Chr(0);
      end;
   end;

procedure TCalculator.Value0Click(Sender: TObject);
begin
   InsertCalcEditChar('0');
   end;

procedure TCalculator.InsertCalcEditChar(IChar:string);
var
   TmpStart:integer;
begin
   if Length(Trim(IChar))=0 then exit;
   CalcEdit.ClearSelection;
   TmpStart:=CalcEdit.SelStart;
   CalcEdit.Text:=Copy(CalcEdit.Text,0,CalcEdit.SelStart)+IChar+Copy(CalcEdit.Text,CalcEdit.SelStart+1,Length(CalcEdit.Text)-CalcEdit.SelStart);
   CalcEdit.SelStart:=TmpStart+Length(IChar);
   end;

procedure TCalculator.ValuePointClick(Sender: TObject);
begin
   InsertCalcEditChar('.');
   end;

procedure TCalculator.Value1Click(Sender: TObject);
begin
   InsertCalcEditChar('1');
   end;

procedure TCalculator.Value2Click(Sender: TObject);
begin
   InsertCalcEditChar('2');
   end;

procedure TCalculator.Value3Click(Sender: TObject);
begin
   InsertCalcEditChar('3');
   end;

procedure TCalculator.Value4Click(Sender: TObject);
begin
   InsertCalcEditChar('4');
   end;

procedure TCalculator.Value5Click(Sender: TObject);
begin
   InsertCalcEditChar('5');
   end;

procedure TCalculator.Value6Click(Sender: TObject);
begin
   InsertCalcEditChar('6');
   end;

procedure TCalculator.Value7Click(Sender: TObject);
begin
   InsertCalcEditChar('7');
   end;

procedure TCalculator.Value8Click(Sender: TObject);
begin
   InsertCalcEditChar('8');
   end;

procedure TCalculator.Value9Click(Sender: TObject);
begin
   InsertCalcEditChar('9');
   end;

procedure TCalculator.OpMultClick(Sender: TObject);
begin
   InsertCalcEditChar('*');
   end;

procedure TCalculator.OpDivClick(Sender: TObject);
begin
   InsertCalcEditChar('/');
   end;

procedure TCalculator.OpMinusClick(Sender: TObject);
begin
   InsertCalcEditChar('-');
   end;

procedure TCalculator.OpPlusClick(Sender: TObject);
begin
   InsertCalcEditChar('+');
   end;

procedure TCalculator.CalcGridSelectCell(Sender: TObject; Col,Row: Longint; var CanSelect: Boolean);
var
   CalcEditSelStart:integer;
   CalcEditSelLength:integer;
begin
   if not GridSelect then exit;
   if Row=CalcGrid.RowCount-1 then begin
      CalcEditSelLength:=CalcEdit.SelLength;
      CalcEditSelStart:=CalcEdit.SelStart;
      try CalcEdit.Setfocus; except end;
      CalcEdit.SelStart:=CalcEditSelStart;
      CalcEdit.SelLength:=CalcEditSelLength;
      exit;
      end;
   CalcEdit.ClearSelection;
   if Odd(Row) then dec(Row);
   {if Row=CalcGrid.RowCount-3 then begin
      InsertLastOp;
      exit;
      end;}
   if HexFlag.Down and (CalcGrid.Cells[2,Row]<>'hex') then exit;
   if BinFlag.Down and (CalcGrid.Cells[2,Row]<>'bin') then exit;
   if OctFlag.Down and (CalcGrid.Cells[2,Row]<>'oct') then exit;
   CalcEditSelStart:=CalcEdit.SelStart;
   InsertCalcEditChar('('+CalcGrid.Cells[Col,Row]+')');
   try CalcEdit.SetFocus; except end;
   CalcEdit.SelStart:=CalcEditSelStart;
   CalcEdit.SelLength:=length(('('+CalcGrid.Cells[Col,Row]+')'));
   end;

procedure TCalculator.CalcGridDblClick(Sender: TObject);
var
   CalcEditSelStart:integer;
   CalcEditSelLength:integer;
begin
   CalcEditSelStart:=CalcEdit.SelStart;
   CalcEditSelLength:=CalcEdit.SelLength;
   try CalcEdit.Setfocus; except end;
   CalcEdit.SelStart:=CalcEditSelStart;
   CalcEdit.SelLength:=CalcEditSelLength;
   end;

procedure TCalculator.InsertLastOp;
var
   CalcEditSelStart:integer;
   StringToInsert: string;
begin
   if CalcGrid.RowCount-1=0 then exit;
   StringToInsert:=CalcGrid.Cells[1,CalcGrid.RowCount-3];
   if (HexFlag.Down and (CalcGrid.Cells[2,CalcGrid.RowCount-3]<>'hex')) or
      (BinFlag.Down and (CalcGrid.Cells[2,CalcGrid.RowCount-3]<>'bin')) or
      ((DegMode.Down or RadMode.Down) and
      (CalcGrid.Cells[2,CalcGrid.RowCount-3]<>'deg') and
      (CalcGrid.Cells[2,CalcGrid.RowCount-3]<>'rad')) or
      (OctFlag.Down and (CalcGrid.Cells[2,CalcGrid.RowCount-3]<>'oct')) then begin
      StringToInsert:=CalcLabel.Caption;
         if StringtoInsert='N/A' then exit;
         end;
   CalcEdit.ClearSelection;
   CalcEditSelStart:=CalcEdit.SelStart;
   if CalcEdit.Text='' then begin
      InsertCalcEditChar(StringToInsert);
      CalcEdit.SelStart:=CalcEditSelStart+Length(StringToInsert);
      end else begin
      InsertCalcEditChar('('+StringToInsert+')');
      CalcEdit.SelStart:=CalcEditSelStart+Length('('+StringToInsert+')');
      end;
   end;

procedure TCalculator.CalcEditKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
   if (Key = 32) and (ssAlt in Shift) then begin
      if (CalcGrid.Row < CalcGrid.TopRow) or (CalcGrid.Row > CalcGrid.TopRow + CalcGrid.VisibleRowCount) then CalcGrid.TopRow := CalcGrid.Row;
      CalcGridMouseDown(Sender, mbRight, [], CalcGrid.ClientWidth div 2, ((CalcGrid.Row-CalcGrid.TopRow) * CalcGrid.DefaultRowHeight) + CalcGrid.DefaultRowHeight div 2);
      end;
   if Key=113 then Edit.Click();
   if Key=112 then ShowHelp else //Application.HelpCommand(HELP_FINDER, 0) else
   if (Key=38) or (Key=40) then begin
      InsertOp(Key);
      Key:=0;
      end else InsertRow:=CalcGrid.RowCount div 2;
   end;

procedure TCalculator.SinOpClick(Sender: TObject);
begin
   if ARC.Down then
      if hyp.down then InsertCalcEditChar('ArcSinh()') else
         InsertCalcEditChar('ArcSin()')
         else if hyp.down then InsertCalcEditChar('Sinh()') else
         InsertCalcEditChar('Sin()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.COSOpClick(Sender: TObject);
begin
   if ARC.Down then
      if hyp.down then InsertCalcEditChar('ArcCosh()') else
         InsertCalcEditChar('ArcCos()')
         else
         if hyp.down then InsertCalcEditChar('Cosh()') else
         InsertCalcEditChar('Cos()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.TANOpClick(Sender: TObject);
begin
   if ARC.Down then
      if hyp.down then InsertCalcEditChar('ArcTanh()') else
      InsertCalcEditChar('ArcTan()')
      else
      if hyp.down then InsertCalcEditChar('Tanh()') else
      InsertCalcEditChar('Tan()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.COTOpClick(Sender: TObject);
begin
   if ARC.Down then
      if hyp.down then InsertCalcEditChar('ArcCoth()') else
         InsertCalcEditChar('ArcCot()')
         else
         if hyp.down then InsertCalcEditChar('Coth()') else
         InsertCalcEditChar('Cot()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.SECOpClick(Sender: TObject);
begin
   if ARC.Down then
      if hyp.down then InsertCalcEditChar('ArcSech()') else
         InsertCalcEditChar('ArcSec()')
         else
         if hyp.down then InsertCalcEditChar('Sech()') else
         InsertCalcEditChar('Sec()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.CSCOpClick(Sender: TObject);
begin
   if ARC.Down then
      if hyp.down then InsertCalcEditChar('ArcCsch()') else
         InsertCalcEditChar('ArcCsc()')
         else
         if hyp.down then InsertCalcEditChar('Csch()') else
         InsertCalcEditChar('Csc()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.EXPValClick(Sender: TObject);
begin
   InsertCalcEditChar('e');
   end;

procedure TCalculator.ANSOpClick(Sender: TObject);
begin
   InsertLastOp;
   end;

procedure TCalculator.COpClick(Sender: TObject);
begin
   CalcEdit.Clear;
   end;

procedure TCalculator.DELOpClick(Sender: TObject);
begin
   if CalcEdit.SelLength>0 then begin
      CalcEdit.ClearSelection;
      exit;
      end;
   if CalcEdit.SelStart>0 then begin
      CalcEdit.SelStart:=CalcEdit.SelStart-1;
      CalcEdit.SelLength:=1;
      CalcEdit.ClearSelection;
      end;
   end;

procedure TCalculator.ACOpClick(Sender: TObject);
var
   i:integer;
begin
   if EvalExpressions>0 then begin
      {$ifDEF English}if MessageDlg('Do you wish to destroy the '+IntToStr(EvalExpressions)+' task(s)?',mtConfirmation,[mbYes]+[mbNo],0)=mrYes then begin{$ENDIF}
      {$IFDEF French}if MessageDlg('Voulez-vous interrompre '+IntToStr(EvalExpressions)+' tache(s)?',mtConfirmation,[mbYes]+[mbNo],0)=mrYes then begin{$ENDIF}
      {$IFDEF German}if MessageDlg('Wollen Sie '+IntToStr(EvalExpressions)+' Aufgabe(n) unterbrechen?',mtConfirmation,[mbYes]+[mbNo],0)=mrYes then begin{$ENDIF}
         CancelAll.Click;
         end else exit;
      end;
   CalcEdit.Clear;
   ClearPrimes.Click;
   for i:=0 to CalcGrid.RowCount-1 do begin
       CalcGrid.Cells[0,i]:='';
       CalcGrid.Cells[1,i]:='';
       CalcGrid.Cells[2,i]:='';
       CalcGrid.Cells[3,i]:='';
       end;
   CalcGrid.RowCount:=1;
   //Dispose(MyVarTree,Destroy);
   CreateNewVar;
   CalcLabel.Caption:='0.00';
   CalcLabelFull.Caption:='0.00000000000000e+0000';

   UpdateEntryBox;
   UpdateCalcGrid;
   end;

procedure TCalculator.CalcGridMouseDown(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ARow:LongInt;
   ACol:LongInt;
   ClipText : string;
   i : integer;
   iPt: TPoint;
begin
   CalcGrid.MouseToCell(X,Y,ACol,Arow);
   if (ARow = -1) or (ACol = -1) then exit;
   CalcGrid.Row:=ARow;
   CalcGrid.Col:=ACol;
    if Button=mbLeft then begin
       GridSelect:=True;
       if ARow<CalcGrid.RowCount-1 then begin
         if not(Odd(ARow)) then inc(ARow);
         ClipText:=CalcGrid.Cells[1,ARow];
         for i:=1 to Length(ClipText)-1 do begin
            if ClipText[i]=' ' then break;
            end;
         if ACol=0 then ClipBoard.AsText:=Trim(Copy(ClipText,1,i));
         end;
      end else
   if Button=mbRight then begin
      GridSelect:=False;
      if Not(Odd(ARow)) then inc(ARow);
      if (CalcGrid.Cells[ACol,ARow]=EvalString) or
         (CalcGrid.Cells[ACol,ARow]=EvalSuspend) or
         (Copy(CalcGrid.Cells[ACol,ARow],1,Length(sIntegral))=sIntegral) or
         (Copy(CalcGrid.Cells[ACol,ARow],0,Length(sPrime))=SPrime) and
         (ARow<>CalcGrid.RowCount-1) then begin
         with InterruptMenu do begin
            Cancel.Enabled:=True;
            CancelAll.Enabled:=True;
            Suspend.Enabled:=True;
            SuspendAll.Enabled:=True;
            CopyMenu.Enabled:=False;
            if (Copy(CalcGrid.Cells[ACol,ARow],1,Length(sIntegral))=sIntegral) then
               DropIntegral.Enabled:=True else DropIntegral.Enabled:=False;
            end;
         ProbablyInterrupt:=ARow;
         if (CalcGrid.Cells[ACol,ARow]=EvalSuspend) then begin
             Suspend.Enabled:=False;
             Resume.Enabled:=True;
             end else begin
             Suspend.Enabled:=True;
             Resume.Enabled:=False;
             end;
         iPt.X:=X;
         iPt.Y:=Y;
         iPt:=ClientToScreen(iPt);
         InterruptMenu.Popup(iPt.X,iPt.Y);
         end else begin
         with InterruptMenu do begin
            Cancel.Enabled:=False;
            Suspend.Enabled:=False;
            Resume.Enabled:=False;
            DropIntegral.Enabled:=False;
            if EvalExpressions <=0 then CancelAll.Enabled:=False;
            if EvalExpressions <=0 then SuspendAll.Enabled:=False;
            if EvalExpressions <=0 then ResumeAll.Enabled:=False;
            CopyMenu.Enabled:=True;
            end;
         iPt.X:=X;
         iPt.Y:=Y;
         iPt:=ClientToScreen(iPt);
         InterruptMenu.Popup(iPt.X,iPt.Y);
         end;
      end;
   CalcGridDblClick(Sender);
   end;

procedure TCalculator.OPOffClick(Sender: TObject);
begin
   if NoQuit then begin
      Another;
      Exit;
      end;
   ReactManager.Kill;
   Application.ProcessMessages;
   UpdateRegistry;
   if EvalExpressions>0 then begin
      {$ifDEF English}if MessageDlg('Do you wish to destroy the '+IntToStr(EvalExpressions)+' task(s) and exit the Expression Calculator?',mtConfirmation,[mbYes]+[mbNo],0)=mrYes then{$ENDIF}
      {$IFDEF French}if MessageDlg('Voulez-vous interrompre '+IntToStr(EvalExpressions)+' tache(s) et quitter Expression Calculator?',mtConfirmation,[mbYes]+[mbNo],0)=mrYes then{$ENDIF}
      {$IFDEF German}if MessageDlg('Wollen Sie '+IntToStr(EvalExpressions)+' Aufgabe(n) unterbrechen und Expression Calculator beenden?',mtConfirmation,[mbYes]+[mbNo],0)=mrYes then{$ENDIF}
         CancelAll.Click
         else exit;
      end;
   PrimesRemove(AllPrimes);
   ResultsRemove;
   Application.Terminate;
   end;

procedure TCalculator.STOOpClick(Sender: TObject);
var
   i: char;
   j,k: integer;
   OrdValue: integer;
   GridValue: longint;
begin

   if VarForm = nil then begin
        {$IFDEF Debug}DebugForm.Debug('ExCalc :: STOOpClick - creating var form.');{$ENDIF}
        Application.CreateForm(TVarForm, VarForm);
        end;

   {$IFDEF Debug}DebugForm.Debug('ExCalc :: STOOpClick - setting selected item.');{$ENDIF}
   VarPanel.SelectedItem := Chr(0);

   GridValue := CalcGrid.RowCount - 1;

   if (Trim(CalcEdit.Text) = '') and (GridValue - 1 <= 0) then exit;
   if (Trim(CalcEdit.Text) <> '') or (GridValue - 1 = 0) then begin
      {$IFDEF Debug}DebugForm.Debug('ExCalc :: STOOpClick - executing function.');{$ENDIF}
      FunctionExeClick(Sender);
      end;

   {$IFDEF Debug}DebugForm.Debug('ExCalc :: STOOpClick - enabling buttons.');{$ENDIF}
   for i:='a' to 'z' do begin
      VarForm.Panel1.Controls[Ord(i)-Ord('a')].Enabled:=True;
      VarForm.Panel1.Controls[Ord(i)-Ord('a')+26].Enabled:=True;
      end;

   {$IFDEF Debug}DebugForm.Debug('ExCalc :: STOOpClick - enabling variables.');{$ENDIF}
   for j:=1 to SizeOf(ProtectedVars) div SizeOf(Char) do begin
      k:=Ord(ProtectedVars[j]);
      if k<Ord('Z') then begin
        VarForm.Panel1.Controls[k-Ord('A')+26].Enabled:=False
        end else begin
        VarForm.Panel1.Controls[k-Ord('a')].Enabled:=False;
        end;
      end;

   while (CalcGrid.RowCount - 1 = 0) do begin
        {$IFDEF Debug}DebugForm.Debug('ExCalc :: STOOpClick - waiting for the calculation to finish.');{$ENDIF}
        Application.ProcessMessages;
        end;

   VarForm.left := Calculator.Left + Calculator.Width;
   VarForm.Top := Calculator.Top + OpPanel.Top+StoOp.Top;

   {$IFDEF Debug}DebugForm.Debug('ExCalc :: STOOpClick - showing form.');{$ENDIF}
   VarForm.ShowModal;

   if VarPanel.SelectedItem = Chr(0) then begin
       {$IFDEF Debug}DebugForm.Debug('ExCalc :: STOOpClick - nothing selected.');{$ENDIF}
        exit;
        end;

   OrdValue := Ord(VarPanel.SelectedItem);
   {$IFDEF Debug}DebugForm.Debug('ExCalc :: STOOpClick - ord is ' + IntToStr(OrdValue) + '.');{$ENDIF}

   {$IFDEF Debug}DebugForm.Debug('ExCalc :: STOOpClick - setting vararray at ' + IntToStr(Ord(VarPanel.SelectedItem)) + '.');{$ENDIF}
   VarArray[OrdValue, 1] := 0;

   {$IFDEF Debug}DebugForm.Debug('ExCalc :: STOOpClick - index is ' + IntToStr(EvalCount) + ' num is ' + FloatToStr(EvalResults[EvalCount]) + '.');{$ENDIF}
   VarArray[OrdValue, 0] := EvalResults[EvalCount];
   VarArray[OrdValue, 1] := 1;
   {$IFDEF Debug}DebugForm.Debug('ExCalc :: STOOpClick - value stored.');{$ENDIF}
   end;

procedure TCalculator.RCLOpClick(Sender: TObject);
var
   i:char;
   SelStart:integer;
   SelLength:integer;
   EditText:string;
begin
   if VarForm = nil then Application.CreateForm(TVarForm, VarForm);
   VarPanel.SelectedItem:=Chr(0);
   VarForm.left:=Calculator.Left+Calculator.Width;
   if VarForm.left+VarForm.Width>Screen.Width then
      VarForm.left:=Calculator.Left-VarForm.Width;
   VarForm.Top:=Calculator.Top+OpPanel.Top+StoOp.Top;
   if VarForm.Top+VarForm.Height>Screen.Height then
      VarForm.Top:=Screen.Height-VarForm.Height;
   for i:='a' to 'z' do begin
      if VarArray[Ord(i),1]=0 then
         VarForm.Panel1.Controls[Ord(i)-Ord('a')].Enabled:=False
         else
         VarForm.Panel1.Controls[Ord(i)-Ord('a')].Enabled:=True;
      if VarArray[Ord(UpCase(i)),1]=0 then
         VarForm.Panel1.Controls[Ord(i)-Ord('a')+26].Enabled:=False
         else
         VarForm.Panel1.Controls[Ord(i)-Ord('a')+26].Enabled:=True;
      end;

   VarForm.ShowModal;
   if VarPanel.SelectedItem=Chr(0) then exit;
   if VarArray[Ord(VarPanel.SelectedItem),1]=0 then exit;
   SelStart:=CalcEdit.SelStart;
   SelLength:=CalcEdit.SelLength;
   EditText:=CalcEdit.Text;
   CalcEdit.Text:=VarPanel.SelectedItem;
   FunctionEXEClick(Self);
   CalcEdit.Text:=EditText;
   CalcEdit.SelStart:=SelStart;
   CalcEdit.SelLength:=SelLength;
   InsertCalcEditChar(VarPanel.SelectedItem);
   end;

procedure TCalculator.NewOpClick(Sender: TObject);
begin
   InsertCalcEditChar('New()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.IntModClick(Sender: TObject);
begin
   InsertCalcEditChar('m');
   end;

procedure TCalculator.IntDivClick(Sender: TObject);
begin
   InsertCalcEditChar('|');
   end;

procedure TCalculator.EPowerXClick(Sender: TObject);
begin
   InsertCalcEditChar('E^');
   end;

procedure TCalculator.SqrtOpClick(Sender: TObject);
begin
   InsertCalcEditChar('Sqrt()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.LogClick(Sender: TObject);
begin
   InsertCalcEditChar('LogTen()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.EValClick(Sender: TObject);
begin
   InsertCalcEditChar('E');
   end;

procedure TCalculator.SqrtRootClick(Sender: TObject);
begin
   InsertCalcEditChar('\');
   end;

procedure TCalculator.LnClick(Sender: TObject);
begin
   InsertCalcEditChar('Ln()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.PiValClick(Sender: TObject);
begin
   InsertCalcEditChar('Pi');
   end;

procedure TCalculator.FactorClick(Sender: TObject);
begin
   InsertCalcEditChar('!');
   end;

procedure TCalculator.PercentClick(Sender: TObject);
begin
  InsertCalcEditChar('%');
  end;

procedure TCalculator.PowerClick(Sender: TObject);
begin
   InsertCalcEditChar('^');
   end;

procedure TCalculator.RightParenthesisClick(Sender: TObject);
begin
   InsertCalcEditChar(')');
   end;

procedure TCalculator.LeftParenthesisClick(Sender: TObject);
begin
   InsertCalcEditChar('(');
   end;

procedure TCalculator.LognClick(Sender: TObject);
begin
   InsertCalcEditChar('LogN(,)');
   CalcEdit.SelStart:=CalcEdit.SelStart-2;
   end;

procedure TCalculator.MaxClick(Sender: TObject);
begin
   InsertCalcEditChar('Max()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.MinClick(Sender: TObject);
begin
   InsertCalcEditChar('Min()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.TruncOpClick(Sender: TObject);
begin
   InsertCalcEditChar('Trunc()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.FracOpClick(Sender: TObject);
begin
   InsertCalcEditChar('Frac()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.RoundOpClick(Sender: TObject);
begin
   InsertCalcEditChar('Round()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.CeilOpClick(Sender: TObject);
begin
   InsertCalcEditChar('Ceil()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.FloorOpClick(Sender: TObject);
begin
   InsertCalcEditChar('Floor()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.AbsOpClick(Sender: TObject);
begin
   InsertCalcEditChar('Abs()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.IntOpClick(Sender: TObject);
begin
   InsertCalcEditChar('Intg()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.RandomOpClick(Sender: TObject);
begin
   InsertCalcEditChar('Random()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.AboutButtonClick(Sender: TObject);
begin
  if (FormCalculatorOptions = nil) then
    Application.CreateForm(TFormCalculatorOptions, FormCalculatorOptions);
  FormCalculatorOptions.FormOptionsPages.ActivePageIndex := FormCalculatorOptions.OptionSystem.PageIndex;
  ShowOptions;
  end;

procedure TCalculator.SqrOpClick(Sender: TObject);
begin
   InsertCalcEditChar('Sqr()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.XorOpClick(Sender: TObject);
begin
   if notop.down then InsertCalcEditChar('xnor') else InsertCalcEditChar('xor');
   end;

procedure TCalculator.OrOpClick(Sender: TObject);
begin
   if notop.down then InsertCalcEditChar('nor') else InsertCalcEditChar('or');
   end;

procedure TCalculator.AndOpClick(Sender: TObject);
begin
   if notop.down then InsertCalcEditChar('nand') else InsertCalcEditChar('and');
   end;

procedure TCalculator.ShrOpClick(Sender: TObject);
begin
   InsertCalcEditChar('Shr(,)');
   CalcEdit.SelStart:=CalcEdit.SelStart-2;
   end;

procedure TCalculator.ShlOpClick(Sender: TObject);
begin
   InsertCalcEditChar('Shl(,)');
   CalcEdit.SelStart:=CalcEdit.SelStart-2;
   end;

procedure TCalculator.AbortButtonClick(Sender: TObject);
begin
   if EvalExpressions>0 then
      {$ifDEF English}if MessageDlg('Do you wish to destroy the '+IntToStr(EvalExpressions)+' task(s)?', mtConfirmation,[mbYes]+[mbNo],0)=mrYes then begin{$ENDIF}
      {$IFDEF French}if MessageDlg('Voulez-vous interrompre '+IntToStr(EvalExpressions)+' tache(s)?', mtConfirmation,[mbYes]+[mbNo],0)=mrYes then begin{$ENDIF}
      {$IFDEF German}if MessageDlg('Wollen Sie '+IntToStr(EvalExpressions)+' Aufgabe(n) unterbrechen?', mtConfirmation,[mbYes]+[mbNo],0)=mrYes then begin{$ENDIF}
         CancelAll.Click{(Sender)};
         end;
  end;

procedure TCalculator.FibOpClick(Sender: TObject);
begin
   InsertCalcEditChar('Fib()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

(*procedure TCalculator.SpinButton1DownClick(Sender: TObject);
var
   TempNormalHeight: integer;
begin
   if not(OpPanel.Visible) then begin
      tempNormalHeight:=NormalGridHeight;
      NormalGridHeight:=0;
      MinimumHeight:=MinimumHeight+Oppanel.Height;
      Calculator.ClientHeight:=Calculator.ClientHeight+OpPanel.Height;
      ValuePanel.Visible:=True;
      OpPanel.Visible:=True;
      CurrentState:='medium';
      UpdateDependencies;
      NormalGridHeight:=TempNormalHeight;
      end else
      if not(OpPanel2.Visible) then begin
         CurrentState:='scientific';
         CalcGrid.Height:=CalcGrid.Height+CalcGrid.DefaultRowHeight;
         NormalGridHeight:=NormalGridHeight+CalcGrid.DefaultRowHeight;
         tempNormalHeight:=NormalGridHeight;
         NormalGridHeight:=0;
         CalcEdit.Top:=CalcGrid.Top+CalcGrid.Height;
         CalcPanel.Top:=CalcEdit.Top+CalcEdit.Height;
         ModePanel.Top:=CalcPanel.Top+CalcPanel.Height;
         SelPanel.Top:=ModePanel.Top+ModePanel.Height;
         OpPanel2.Top:=SelPanel.Top+SelPanel.Height;
         OpPanel.Top:=OpPanel2.Top+OpPanel2.Height;
         ValuePanel.Top:=OpPanel.Top;
         OpPanel2.Visible:=True;
         SelPanel.Visible:=True;
         OpPanel.Visible:=True;
         ValuePanel.Visible:=True;
         MinimumHeight:=MinimumHeight+OpPanel.Height;
         Calculator.ClientHeight:=OpPanel.Height+OpPanel.Top;
         UpdateDependencies;
         NormalGridHeight:=TempNormalHeight;
         end;
   end;

procedure TCalculator.SpinButton1UpClick(Sender: TObject);
begin
     if OpPanel2.Visible then begin
        BringUpMedium;
        end else if OpPanel.Visible then begin
        BringUpSmall;
        end;
     end;
*)
procedure TCalculator.GCDOpClick(Sender: TObject);
begin
   InsertCalcEditChar('Gcd()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.OpButtonClick(Sender: TObject);
begin
   OpMenu.Popup(Calculator.Left+ModePanel.Left+OpButton.Left+OpButton.Width,
                Calculator.Top+ModePanel.Top+OpButton.Top)
   end;

procedure TCalculator.EulerGammaClick(Sender: TObject);
begin
   InsertCalcEditChar('Gamma(,)');
   CalcEdit.SelStart:=CalcEdit.SelStart-2;
   end;

procedure TCalculator.EulerPhiClick(Sender: TObject);
begin
   InsertCalcEditChar('eInd()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.MersGenClick(Sender: TObject);
begin
   InsertCalcEditChar('MersGen()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.GenMersClick(Sender: TObject);
begin
   InsertCalcEditChar('GenMers()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.MersenneGenClick(Sender: TObject);
begin
   InsertCalcEditChar('MersenneGen()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.MersenneClick(Sender: TObject);
begin
   InsertCalcEditChar('Mersenne()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.lcmClick(Sender: TObject);
begin
   InsertCalcEditChar('Lcm()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.PerfectClick(Sender: TObject);
begin
   InsertCalcEditChar('Perfect()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.PrimeXClick(Sender: TObject);
begin
   InsertCalcEditChar('Prime()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

constructor TExecute.Create(CurrentString:string;MyCalcMode:TCalcMode);
begin
   CalcString:=CurrentString;
   CalcMode:=MyCalcMode;
   inherited Create(False);
   end;

procedure TExecute.Execute;
var
   i: integer;
   OldCalcString: string;
begin
   OldCalcString:=CalcString;
   while(CalcString='') do ;
   for i:=1 to Length(CalcString)-1 do begin
       if (CalcString[i+1] in ['-']) and (CalcString[i]='(') then begin
           Insert('0',CalcString,i+1);
           end;
       if (CalcString[i+1] in ['-']) and (CalcString[i]='-') then begin
           CalcString[i]:=' ';
           CalcString[i+1]:='+';
           end;
       if (CalcString[i+1] in ['+']) and (CalcString[i]='-') then begin
           CalcString[i+1]:=' ';
           end;
       if (CalcString[i+1] in ['-']) and (CalcString[i]='+') then begin
           CalcString[i]:=' ';
           CalcString[i+1]:='-';
           end;
       if (CalcString[i+1] in ['0'..'9']) and (CalcString[i]=')') then begin
           Insert('*',CalcString,i+1);
           end;
       if (CalcString[i] in ['0'..'9']) and (CalcString[i+1]='(') then begin
           Insert('*',CalcString,i+1);
           end;
       if (CalcString[i]=')') and (CalcString[i+1]='(') then begin
           Insert('*',CalcString,i+1);
           end;
       end;

   for i:=Length(CalcString) downto 1 do
      if CalcString[i]=' ' then Delete(CalcString,i,1);
   CalcString:=OldCalcString;
   if CompareText(CalcString,'erase')=0 then begin
      //Dispose(Calculator.MyVarTree,Destroy);
      Calculator.CreateNewVar;
      exit;
      end;
   if CalcString='' then exit;
   inc(Calculator.EvalExpressions);

   Calculator.OpsBar.Position:=Calculator.EvalExpressions * 10;

   Calculator.AbortButton.Visible:=True;

   with Calculator.CalcGrid do begin
        Cells[0,RowCount-1]:=IntToStr(RowCount div 2+1);
        Cells[1,RowCount-1]:=CalcString;
        CalcId:=RowCount;

        Case CalcMode of
             Deg: Cells[2,CalcId-1]:='deg';
             Rad: Cells[2,CalcId-1]:='rad';
             Hex: Cells[2,CalcId-1]:='hex';
             Bin: Cells[2,CalcId-1]:='bin';
             Oct: Cells[2,CalcId-1]:='oct';
             end;

        RowCount:=RowCount+1;
        Cells[1,RowCount-1]:=EvalString;
        RowCount:=RowCount+1;
        Left:=0;
        Width:=Calculator.ClientWidth;
        ColWidths[0]:=21;
        {Calculator.CalcGrid.ColWidths[1]:=Trunc((Calculator.CalcGrid.ClientWidth-Calculator.CalcGrid.ColWidths[0]-Calculator.CalcGrid.GridLineWidth));}
        ColWidths[1]:=Width - ColWidths[0] - (ColCount * GridLineWidth);
        TCalcThread.Create(CalcString,CalcMode,CalcId);
        if RowCount > trunc(ClientHeight/DefaultRowHeight) then
        TopRow:=RowCount-trunc(ClientHeight/DefaultRowHeight);
        end;
   end;

procedure TCalculator.UpdateCalcButtons(MyMode:TCalcMode);
var
   NewSet:boolean;
begin
   if MyMode=Bin then NewSet:=False else NewSet:=True;
      Value2.Enabled:=NewSet;
      Value3.Enabled:=NewSet;
      Value4.Enabled:=NewSet;
      Value5.Enabled:=NewSet;
      Value6.Enabled:=NewSet;
      Value7.Enabled:=NewSet;
      Value8.Enabled:=NewSet;
      Value9.Enabled:=NewSet;
   if MyMode=Oct then begin
      Value9.Enabled:=False;
      Value8.Enabled:=False;
      end;
   if (MyMode<>Rad) and (MyMode<>Deg) then NewSet:=False else NewSet:=True;
      ValuePoint.Enabled:=NewSet;
      SinOp.Enabled:=NewSet;
      CosOp.Enabled:=NewSet;
      TanOp.Enabled:=NewSet;
      CotOp.Enabled:=NewSet;
      SecOp.Enabled:=NewSet;
      CscOp.Enabled:=NewSet;
      ExpVal.Enabled:=NewSet;
      StoOp.Enabled:=NewSet;
      RclOp.Enabled:=NewSet;
      Log.Enabled:=NewSet;
      Ln.Enabled:=NewSet;
      SqrtRoot.Enabled:=NewSet;
      SqrtOp.Enabled:=NewSet;
      IntDiv.Enabled:=NewSet;
      IntMod.Enabled:=NewSet;
      EVal.Enabled:=NewSet;
      PiVal.Enabled:=NewSet;
      Percent.Enabled:=NewSet;
      PhiOp.Enabled := NEwSet;
      IntOp.Enabled := NewSet;
      Power.Enabled:=NewSet;
      Factor.Enabled:=NewSet;
      EPowerX.Enabled:=NewSet;
      Logn.Enabled:=NewSet;
      ARC.Enabled:=NewSet;
      Hyp.Enabled:=NewSet;
      AbsOp.Enabled:=NewSet;
      SqrOp.Enabled:=NewSet;
      OpButton.Enabled:=NewSet;
      HexPanel.Visible := MyMode=Hex;
   end;

procedure TCalculator.ConvertLastOperation(MyMode: TCalcMode);
var
   CalcResult: extended;
   ToString  : string;
   CalcStrResult: string;
   i: integer;
begin
   CalcResult:=LastResult;
   CalcStrResult:=LastStrResult;
   if MyMode=CurrentMode then begin
      if DegMode.Down then MyMode:=Deg;
      if RadMode.Down then MyMode:=Rad;
      if OctFlag.Down then MyMode:=Oct;
      if BinFlag.Down then MyMode:=Bin;
      if HexFlag.Down then MyMode:=Hex;
      end;
   try
      ToString:='';
      case MyMode of
         Hex: if {(CalcResult>=0) and} (Trunc(CalcResult)=CalcResult) then
              ToString:=IntToHex(trunc(CalcResult))
              else begin
                 ToString:='#.##';
                 CalcStrResult:='';
                 end;
         Oct: if {(CalcResult>=0) and }(Trunc(CalcResult)=CalcResult) then
              ToString:=IntToOct(trunc(CalcResult))
              else begin
              ToString:='#.##';
              CalcStrResult:='';
              end;
         Bin: if (CalcResult>=0) and (Trunc(CalcResult)=CalcResult) then
              ToString:=IntToBin(trunc(CalcResult))
              else begin
              ToString:='#.##';
              CalcStrResult:='';
              end;
         else
              CalcStrResult:=Trim(CalcStrResult);
              Str(CalcResult:0:2,ToString);
              for i:=1 to Length(ToString) do if ToString[i]='E' then begin
                  ToString:=CalcStrResult;
                  break;
                  end;
              ToString:=Trim(ToString);
         end;
   except
      if ToString='' then begin
         CalcStrResult:='';
         ToString:='#.##';
         end;
      end;
   if CalcStrResult<>'' then CalcLabelFull.Caption:=CalcStrResult;
   if ToString='' then ToString:='--';
   if ToString='-0.00' then ToString:='0.00';
   CalcLabel.Caption:=ToString;
   end;

procedure TCalculator.HexFlagClick(Sender: TObject);
begin
   if HexFlag.Down then begin
      CalcEdit.Clear;
      CalcIndicator.Caption:='Hex';
      DegMode.Down:=False;
      RadMode.Down:=False;
      BinFlag.Down:=False;
      OctFlag.Down:=False;
      ConvertLastOperation(Hex);
      UpdateCalcButtons(Hex);
      end else begin
         RadMode.Down:=True;
         RadModeClick(Sender);
         end;
   end;

procedure TCalculator.BinFlagClick(Sender: TObject);
begin
   if BinFlag.Down then begin
      CalcEdit.Clear;
      CalcIndicator.Caption:=' Bin';
      DegMode.Down:=False;
      RadMode.Down:=False;
      HexFlag.Down:=False;
      OctFlag.Down:=False;
      ConvertLastOperation(Bin);
      UpdateCalcButtons(Bin);
      end else begin
         RadMode.Down:=True;
         RadModeClick(Sender);
         end;
   end;

procedure TCalculator.OctFlagClick(Sender: TObject);
begin
     if OctFlag.Down then begin
        CalcEdit.Clear;
        CalcIndicator.Caption:=' Oct';
        DegMode.Down:=False;
        HexFlag.Down:=False;
        RadMode.Down:=False;
        BinFlag.Down:=False;
        ConvertLastOperation(Oct);
        UpdateCalcButtons(Oct);
        end else begin
         RadMode.Down:=True;
         RadModeClick(Sender);
         end;
end;

procedure TCalculator.DegModeClick(Sender: TObject);
begin
    if DegMode.Down then begin
     CalcEdit.Clear;
     CalcIndicator.Caption:='Deg';
     DegMode.Down:=true;
     RadMode.Down:=False;
     HexFlag.Down:=False;
     BinFlag.Down:=False;
     OctFlag.Down:=False;
     ConvertLastOperation(Deg);
     end else DegMode.Down:=True;
     UpdateCalcButtons(Deg);
end;

procedure TCalculator.RadModeClick(Sender: TObject);
begin
   if RadMode.Down then begin
      CalcEdit.Clear;
      CalcIndicator.Caption:='Rad';
      RadMode.Down:=True;
      DegMode.Down:=False;
      HexFlag.Down:=False;
      BinFlag.Down:=False;
      OctFlag.Down:=False;
      ConvertLastOperation(Rad);
      UpdateCalcButtons(Rad);
        end else begin
         RadMode.Down:=True;
         RadModeClick(Sender);
         end;
   end;

procedure TCalculator.UpdateExpressions;
begin
   Calculator.CalcPanel.Update;
   if Calculator.EvalExpressions=0 then
      Calculator.AbortButton.Visible:=False
      else Calculator.AbortButton.Visible:=True;
   Calculator.UpdateCalcGrid;
   end;

procedure TCalculator.CancelClick(Sender: TObject);
begin
   TerminateThread(StrToInt(CalcGrid.Cells[3,ProbablyInterrupt-1]), 0);
   if PrimeTableUser=StrToInt(CalcGrid.Cells[3,ProbablyInterrupt-1]) then PrimeTableInUse:=False;
   CalcGrid.Cells[3,ProbablyInterrupt-1]:='int';
   CalcGrid.Cells[1,ProbablyInterrupt]:=
      {$ifDEF English}'Interrupted by user.';{$ENDIF}
      {$IFDEF French}'Interrompu par l''utilisateur.';{$ENDIF}
      {$IFDEF German}'Untergebrochen.';{$ENDIF}
   dec(EvalExpressions);
   Calculator.OpsBar.Position:=Calculator.EvalExpressions * 10;
   UpdateExpressions;
   end;

procedure TCalculator.CancelAllClick(Sender: TObject);
var
   i:longint;
begin
  if EvalExpressions>0 then
     for i:=0 to CalcGrid.RowCount-1 do
        if (CalcGrid.Cells[3,i]<>'') and
           (CalcGrid.Cells[3,i]<>'ok') and
           (CalcGrid.Cells[3,i]<>'int') and
           (CalcGrid.Cells[3,i]<>'all') then begin
              TerminateThread(StrToInt(CalcGrid.Cells[3,i]), 0);
              PrimeTableInUse:=False;
              CalcGrid.Cells[3,i]:='all';
              CalcGrid.Cells[1,i+1]:=
                    {$ifDEF English}'Interrupted by user.';{$ENDIF}
                    {$IFDEF French}'Interrompu par l''utilisateur.';{$ENDIF}
                    {$IFDEF German}'Untergebrochen.';{$ENDIF}
              dec(EvalExpressions);
              Calculator.OpsBar.Position:=Calculator.EvalExpressions * 10;
              UpdateExpressions;
            end;
  end;

procedure TCalculator.ExitECClick(Sender: TObject);
begin
   OpOffClick(Sender);
   end;

procedure TCalculator.FormCloseQuery(Sender: TObject;
var
   CanClose: Boolean);
begin
   try
   if NoQuit then begin
      Another;
      CanClose:=False;
      exit;
      end;
   UpdateRegistry;
   if EvalExpressions>0 then begin
      {$ifDEF English}if MessageDlg('Do you wish to destroy the '+IntToStr(EvalExpressions)+' task(s) and exit the Expression Calculator?',mtConfirmation,[mbYes]+[mbNo],0)=mrYes then{$ENDIF}
      {$IFDEF French}if MessageDlg('Voulez-vous interrompre '+IntToStr(EvalExpressions)+' tache(s) et quitter Expression Calculator?',mtConfirmation,[mbYes]+[mbNo],0)=mrYes then{$ENDIF}
      {$IFDEF German}if MessageDlg('Wollen Sie '+IntToStr(EvalExpressions)+' Aufgabe(n) unterbrechen und Expression Calculator beenden?',mtConfirmation,[mbYes]+[mbNo],0)=mrYes then{$ENDIF}
         CancelAll.Click{(Sender)}
         else CanClose:=False;
      end;
   if CanClose then begin
      PrimesRemove(AllPrimes);
      ResultsRemove;
      Application.Terminate;
      end;
   except
   CanClose:=True;
   Application.Terminate;
   end;
   end;

procedure TCalculator.AverageClick(Sender: TObject);
begin
   InsertCalcEditChar('Average()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
end;

procedure TCalculator.SuspendClick(Sender: TObject);
begin
     SuspendThread(StrToInt(CalcGrid.Cells[3,ProbablyInterrupt-1]));
     CalcGrid.Cells[1,ProbablyInterrupt]:=EvalSuspend;
end;

procedure TCalculator.ResumeClick(Sender: TObject);
begin
   ResumeThread(StrToInt(CalcGrid.Cells[3,ProbablyInterrupt-1]));
   CalcGrid.Cells[1,ProbablyInterrupt]:=EvalString;
end;

procedure TCalculator.BringUpMedium;
begin
        MinimumHeight :=
            MinGridHeight +
            CalcEdit.Height +
            CalcPanel.Height +
            OpPanel.Height +
            (Height - ClientHeight);
        ClientHeight :=
            CalcGrid.Height +
            CalcEdit.Height +
            ModePanel.Height +
            CalcPanel.Height +
            OpPanel.Height;
        CurrentState:='medium';
        OpLeftPanel.Visible:=False;
        OpRightPanel.Visible:=False;
        SelPanel.Visible:=False;
        OpPanel.Visible := True;
        ValuePanel.Visible := True;
        UpdateDependencies;
   end;

procedure TCalculator.BringUpSmall;
begin
        MinimumHeight :=
            MinGridHeight +
            CalcEdit.Height +
            CalcPanel.Height +
            (Height - ClientHeight);
        ClientHeight :=
            CalcGrid.Height +
            CalcEdit.Height +
            ModePanel.Height +
            CalcPanel.Height;
        CurrentState:='small';
        ValuePanel.Visible:=False;
        OpPanel.Visible:=False;
        SelPanel.Visible:=False;
        UpdateDependencies;
   end;

procedure TCalculator.SuspendAllClick(Sender: TObject);
var
   i:longint;
begin
  if EvalExpressions>0 then
     for i:=0 to CalcGrid.RowCount-1 do
        if (CalcGrid.Cells[3,i]<>'') and
           (CalcGrid.Cells[3,i]<>'ok') and
           (CalcGrid.Cells[3,i]<>'int') and
           (CalcGrid.Cells[3,i]<>'all') then begin
              SuspendThread(StrToInt(CalcGrid.Cells[3,i]));
              CalcGrid.Cells[1,i+1]:=EvalSuspend;
            end;
  end;

procedure TCalculator.ResumeAllClick(Sender: TObject);
var
   i:longint;
begin
  if EvalExpressions>0 then
     for i:=0 to CalcGrid.RowCount-1 do
           if (CalcGrid.Cells[1,i+1]=EvalSuspend) then begin
              ResumeThread(StrToInt(CalcGrid.Cells[3,i]));
              CalcGrid.Cells[1,i+1]:=EvalString;
            end;
  end;

procedure TCalculator.SpeedButton1ClickHelpButton(Sender: TObject);
begin
   // Application.HelpCommand(HELP_FINDER, 0);
   ShowHelp;
   end;

procedure TCalculator.EulerBetaClick(Sender: TObject);
begin
   InsertCalcEditChar('Beta(,)');
   CalcEdit.SelStart:=CalcEdit.SelStart-2;
end;

procedure TCalculator.PrimesIClick(Sender: TObject);
begin
   InsertCalcEditChar('eInd()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
end;

procedure TCalculator.PrimeNClick(Sender: TObject);
begin
   InsertCalcEditChar('PrimeN()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
end;

procedure TCalculator.PrimeCClick(Sender: TObject);
begin
   InsertCalcEditChar('PrimeC()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
end;

procedure TCalculator.BinomClick(Sender: TObject);
begin
   InsertCalcEditChar('Binom(,)');
   CalcEdit.SelStart:=CalcEdit.SelStart-2;
end;

procedure TCalculator.ClearPrimesClick(Sender: TObject);
var
   MessageQuery: word;
begin
   MessageQuery:=mrRetry;
   while (PrimeTableInUse) and (MessageQuery=mrRetry) do
      {$ifDEF English}MessageQuery:=MessageDlg('A thread ('+IntToStr(PrimeTableUser)+') is currently using the primes'' table!'+Chr(13)+Chr(10)+'Please try later or cancel that thread.',mtError,[mbCancel]+[mbRetry],0);{$ENDIF}
      {$IFDEF French}MessageQuery:=MessageDlg('Une tache ('+IntToStr(PrimeTableUser)+') est en cours d''utilisation de la table des nombres premiers!'+Chr(13)+Chr(10)+'Veuillez essayer plus tard ou interrompez la tache.',mtError,[mbCancel]+[mbRetry],0);{$ENDIF}
      {$IFDEF German}MessageQuery:=MessageDlg('Eine Aufgabe ('+IntToStr(PrimeTableUser)+') benuzt die Primfaktoren Verzeichnis!'+Chr(13)+Chr(10)+'Probieren später oder unterbrechen die Aufgabe!',mtError,[mbCancel]+[mbRetry],0);{$ENDIF}
   if (Messagequery=mrRetry) and (PrimeTableInUse=False) then begin
      PrimesRemove(AllPrimes);
      PrimesCount:=0;
      InitPrimes;
      end;
   end;

procedure TCalculator.CopyPrimesClick(Sender: TObject);
var
   PrimesString, CurPrimesString : string;
   j : longint;
begin
   if PrimesCount>50000 then begin
      {$ifDEF French}if MessageDlg('La table des nombres premiers est particulièrement grande, cette opération peut prendre un temps considérable. Voulez-vous continuer de toute façon?',mtWarning,[mbYes]+[mbNo],0)=mrNo then exit;{$ENDIF}
      {$IFDEF English}if MessageDlg('The primes table is really huge, and it will take a moment to copy it to the clipboard. Would you like to continue anyway?',mtWarning,[mbYes]+[mbNo],0)=mrNo then exit;{$ENDIF}
      {$IFDEF German}if MessageDlg('Die Primfactoren Verzeichnis ist sehr beträchtlich, es kann sehr viel Zeit um es abzuschreiben. Wollen Sie auf Jeden Fall weitermachen?',mtWarning,[mbYes]+[mbNo],0)=mrNo then exit;{$ENDIF}
      end;

      try
      ProgressWait.Show;
      j:=PrimesCount-1;
      PrimesString:='';
      ClearPrimes.Enabled:=False;
      CopyPrimes.Enabled:=False;
      ProgressWait.Legend := 'Copying ' + IntToStr(PrimesCount-1) + ' primes to clipboard ...';
      while j>=2 do begin
         CurPrimesString:=IntToStr(AllPrimes^[j])+','+CurPrimesString;
         ProgressWait.Progress := trunc(((PrimesCount - j)/PrimesCount)*100);
         Application.ProcessMessages;
         if (ProgressWait.Cancelled) then break;
         if (j mod 1000 = 0) then begin
            PrimesString := CurPrimesString + PrimesString;
            CurPrimesString := '';
            end;
         dec(j);
         end;
      finally
      PrimesString := CurPrimesString + PrimesString;
      if not (ProgressWait.Cancelled) then begin
         ProgressWait.Hide;
         Clipboard.AsText:=PrimesString;
         end;
      ClearPrimes.Enabled:=True;
      CopyPrimes.Enabled:=True;
      end;

   end;

procedure TCalculator.ResetClick(Sender: TObject);
begin
   ACOpClick(Sender);
   end;

procedure TCalculator.UpdateSelPanel;
begin
   SelPanel.Width:=Calculator.ClientWidth;
   OpButton.Left:=SelPanel.ClientWidth-OpButton.Width-2;
   HelpButton.Left:=OpButton.Left-HelpButton.Width-2;
   AboutButton.Left:=HelpButton.Left-AboutButton.Width-2;
   AbortButton.Left:=AboutButton.Left-AbortButton.Width-2;
   RegCommand.Left:=AbortButton.Left - RegCommand.Width - 2;
   //UniGe.Left:=NoTop.Left + NoTop.Width + (AbortButton.Left - (NoTop.Left + NoTop.Width) - UniGe.Width) div 2;
   end;

procedure TCalculator.UpdateModePanel;
begin
   ModePanel.Width:=Calculator.ClientWidth;
   OctFlag.Left:=ModePanel.ClientWidth-OctFlag.Width-3;
   BinFlag.Left:=OctFlag.Left-BinFlag.Width-2;
   HexFlag.Left:=BinFlag.Left-HexFlag.Width-2;
   OpsBar.Left:=(HexFlag.Left + (RadMode.Left + RadMode.Width) - OpsBar.Width) div 2;
   end;

procedure TCalculator.FormResize(Sender: TObject);
begin
   CalcGrid.Width := Calculator.ClientWidth;
   CalcGrid.ColWidths[1] := CalcGrid.Width - CalcGrid.ColWidths[0] - (CalcGrid.ColCount * CalcGrid.GridLineWidth);
   UpdateCalcPanel;
   UpdateModePanel;
   UpdateSelPanel;
   CalcEdit.Width := Calculator.ClientWidth;
   OpRightPanel.Left := Calculator.ClientWidth - OpRightPanel.Width;
   OpPanel.Left := Calculator.ClientWidth - OpPanel.Width;
   UpdateDependencies;
   end;

(*
procedure TCalculator.ConstructOpArray;
begin
   OpsArray[0][0]:=@SinOp;
   OpsArray[0][1]:=@CosOp;
   OpsArray[0][2]:=@TanOp;
   OpsArray[0][3]:=@Power;

   OpsArray[1][0]:=@CotOp;
   OpsArray[1][1]:=@CscOp;
   OpsArray[1][2]:=@SecOp;
   OpsArray[1][3]:=@Percent;

   OpsArray[2][0]:=@Log;
   OpsArray[2][1]:=@Ln;
   OpsArray[2][2]:=@Logn;
   OpsArray[2][3]:=@EPowerX;

   OpsArray[3][0]:=@SqrtOp;
   OpsArray[3][1]:=@SqrOp;
   OpsArray[3][2]:=@SqrtRoot;
   OpsArray[3][3]:=@eVal;

   OpsArray[4][0]:=@AndOp;
   OpsArray[4][1]:=@OrOp;
   OpsArray[4][2]:=@XorOp;
   OpsArray[4][3]:=@PiVal;

   OpsArray[5][0]:=@ShrOp;
   OpsArray[5][1]:=@ShlOp;
   OpsArray[5][2]:=@AbsOp;
   OpsArray[5][3]:=@LeftParenthesis;

   OpsArray[6][0]:=@IntDiv;
   OpsArray[6][1]:=@IntMod;
   OpsArray[6][2]:=@Factor;
   OpsArray[6][3]:=@RightParenthesis;
   end;
   *)

(*procedure TCalculator.UpdateOpPanel;
var
   ColLeft: integer;
   NewWidth: integer;
   i,j: integer;
begin
  NewWidth:=(OpPanel2.Width) div 7 -2;
   ColLeft:=4;
   for i:=0 to 6 do begin
    for j:=0 to 3 do begin
       OpsArray[i][j].Left:=ColLeft;
       OpsArray[i][j].Width:=NewWidth;
       end;
       ColLeft:=ColLeft+NewWidth+2;
      end;
   for j:=0 to 3 do begin
      OpsArray[6][j].Width:=OpPanel2.Width-IntDiv.Left-2;
      end;
   end;*)

procedure TCalculator.Updatedependencies;
begin
   if (CurrentState='scientific') or (currentState='') then begin
      OpPanel.Top := ClientHeight - OpPanel.Height;
      ValuePanel.Top:=OpPanel.Top;
      OpLeftPanel.Top := OpPanel.Top - OpLeftPanel.Height;
      OpRightPanel.Top := OpLeftPanel.Top;
      HexPanel.Top := OpLeftPanel.ClientHeight - HexPanel.Height;
      SelPanel.Top := OpRightPanel.Top - SelPanel.Height;
      ModePanel.Top := SelPanel.Top - ModePanel.Height;
      CalcPanel.Top:=ModePanel.Top - CalcPanel.Height;
      CalcEdit.Top := CalcPanel.Top - CalcEdit.Height;
      CalcGrid.Height := CalcEdit.Top;
      end else
   if CurrentState='medium' then begin
      OpPanel.Top := ClientHeight - OpPanel.Height;
      ValuePanel.Top:=OpPanel.Top;
      ModePanel.Top := ValuePanel.Top - ModePanel.Height;
      CalcPanel.Top:=ModePanel.Top - CalcPanel.Height;
      CalcEdit.Top := CalcPanel.Top - CalcEdit.Height;
      CalcGrid.Height := CalcEdit.Top;
      end else
   if CurrentState='small' then begin
      ModePanel.Top := ClientHeight - ModePanel.Height;
      CalcPanel.Top:=ModePanel.Top - CalcPanel.Height;
      CalcEdit.Top := CalcPanel.Top - CalcEdit.Height;
      CalcGrid.Height := CalcEdit.Top;
      end;
   end;

function TCalculator.GetEval(Count: integer):string;
begin
   if CalcGrid.RowCount-1=0 then begin
      GetEval:='';
      exit;
      end;
   GetEval:=CalcGrid.Cells[1,Count*2];
   if (HexFlag.Down and (CalcGrid.Cells[2,Count*2]<>'hex')) or
      (BinFlag.Down and (CalcGrid.Cells[2,Count*2]<>'bin')) or
      ((DegMode.Down or RadMode.Down) and
      (CalcGrid.Cells[2,Count*2]<>'deg') and
      (CalcGrid.Cells[2,Count*2]<>'rad')) or
      (OctFlag.Down and (CalcGrid.Cells[2,Count*2]<>'oct')) then begin
         GetEval:='';
         exit;
         end;
   end;

procedure TCalculator.InsertOp(Key: word);
var
   CalcEditSelStart: integer;
   StringToInsert: string;
   PreviousInsertString:string;
begin
   case Key of
    38:   begin
          if InsertRow>0 then dec(InsertRow);
          while(InsertRow>CalcGrid.RowCount div 2) do dec(InsertRow);
          while(InsertRow<0) do inc(InsertRow);
          end;
    40:   begin
          if InsertRow<CalcGrid.RowCount div 2 then inc(InsertRow);
          while(InsertRow>=CalcGrid.RowCount div 2) do dec(InsertRow);
          while(InsertRow<0) do inc(InsertRow);
          end;
    end;

   PreviousInsertString:=Trim(CalcEdit.SelText);
   StringToInsert:=Trim(GetEval(InsertRow));
   while (StringToInsert=PreviousInsertString) and
         ((InsertRow>0) and (InsertRow<CalcGrid.RowCount div 2)) do
         begin
            StringToInsert:=Trim(GetEval(InsertRow));
            if Key=38 then dec(InsertRow);
            if Key=40 then inc(InsertRow);
            end;

   if Length(StringToInsert)=0 then exit;
   CalcEdit.ClearSelection;
   CalcEditSelStart:=CalcEdit.SelStart;
   if CalcEdit.Text='' then begin
      InsertCalcEditChar(StringToInsert);
      CalcEdit.SelStart:=CalcEditSelStart;
      CalcEdit.SelLength:=Length(StringToInsert);
      end else begin
      InsertCalcEditChar('('+StringToInsert+')');
      CalcEdit.SelStart:=CalcEditSelStart;
      CalcEdit.SelLength:=Length('('+StringToInsert+')');
      end;
   end;

procedure TCalculator.WMSysCommand(var Msg: TWMSysCommand);
begin
   if Msg.CmdType=SC_MINIMIZE then begin
      Application.Minimize;
      end else inherited;
   end;

procedure TCalculator.Another;
begin
   TFileExecute.Create(Application.ExeName, Application.ExeName+' noquit', 0);
   end;

procedure TCalculator.ButtonSizeUpClick(Sender: TObject);
begin
   if CurrentState = 'medium' then BringUpSmall
   else if CurrentState = 'scientific' then BringUpMedium;
   end;

procedure TCalculator.ButtonSizeDownClick(Sender: TObject);
begin
   if CurrentState = 'small' then BringUpMedium
   else if CurrentState = 'medium' then BringUpScientific;
   end;

procedure TCalculator.CreateNewVar;
var
   i: integer;
begin
   for i:=0 to 255 do VarArray[i,1]:=0;
   VarArray[Ord('E'),0]:=exp(1.0);
   VarArray[Ord('E'),1]:=1;
   VarArray[Ord('G'),0]:=0.5772156649015328606065120900824024310421593359399235988057672348848677267776646709369470632917467495;
   VarArray[Ord('G'),1]:=1;
   end;

function TCalculator.GetCell(var Arow: LongInt; cType: TCopySet): string;
var
   ClipText: string;
   i: LongInt;
begin
   Result:='';
   try
   if (not(odd(ARow)) and (expression in cType)) then begin
      Result:=Result + CalcGrid.Cells[1,ARow];
      end;
   if (odd(ARow) and (short in cType) and (long in cType)) then begin
      if length(Result)>0 then  Result:=Result + #13#10;
      Result := Result + CalcGrid.Cells[1,ARow];
      end else
   if (odd(ARow) and (short in cType)) then begin
      ClipText:=CalcGrid.Cells[1,ARow];
      for i:=1 to Length(ClipText) do
         if ClipText[i]=' ' then break;
      ClipText:=Copy(ClipText, 1, i-1);
      Result:=Result + ClipText;
      end else
   if (odd(ARow) and (long in cType)) then begin
      ClipText:=CalcGrid.Cells[1,ARow];
      for i:=Length(ClipText) downto 0 do
         if ClipText[i]=' ' then break;
         ClipText:=Trim(Copy(ClipText, i+1, Length(ClipText)-i));
         if ClipText[1]='(' then Delete(ClipText,1,1);
         if ClipText[Length(ClipText)]=')' then Delete(ClipText,Length(ClipText),1);
         Result:=Result + ClipText;
         end;
   except
   end;
   end;

procedure TCalculator.cExpClick(Sender: TObject);
var
   ARow: LongInt;
begin
   ARow:=CalcGrid.Row;
   if Odd(ARow) then dec(ARow);
   if ARow<CalcGrid.RowCount-1 then begin
      ClipBoard.AsText:=GetCell(ARow, [expression]);
      end;
   end;

procedure TCalculator.cShortClick(Sender: TObject);
var
   ARow: LongInt;
begin
   ARow:=CalcGrid.Row;
   if not Odd(ARow) then inc(ARow);
   ClipBoard.AsText:=GetCell(ARow, [short]);
   end;

procedure TCalculator.cLongClick(Sender: TObject);
var
   ARow: LongInt;
begin
   ARow:=CalcGrid.Row;
   if not Odd(ARow) then inc(ARow);
   ClipBoard.AsText:=GetCell(ARow, [long]);
   end;

procedure TCalculator.SaveGridClick(Sender: TObject);
const
   ExCalcHeader: string = 'ExCalc0231';
var
   WriteText, FileName: string;
   ContainerStream: TFileStream;
   i: LongInt;
begin

   if SaveDialog1.Execute=False then exit;
   FileName:=SaveDialog1.Filename;
   if FileName='' then exit;
   OpenDialog1.FileName:=FileName;
   if FileExists(FileName) then DeleteFile(PChar(FileName));
   ContainerStream:=TFileStream.Create(FileName, fmOpenWrite or fmShareDenyWrite or fmCreate);
   try
   ContainerStream.Write(PChar(ExCalcHeader)^, Length(ExCalcHeader));
   WriteText:=','+IntToStr((CalcGrid.RowCount - 1) div 2)+#13#10;
   ContainerStream.Write(PChar(WriteText)^, Length(WriteText));
   for i:=1 to (CalcGrid.RowCount - 1) div 2 do begin
         WriteText:=CalcGrid.Cells[2,2*(i-1)]+',';
         ContainerStream.Write(PChar(WriteText)^, Length(WriteText));
         WriteText:=CalcGrid.Cells[3,2*(i-1)]+',';
         ContainerStream.Write(PChar(WriteText)^, Length(WriteText));
         WriteText:=CalcGrid.Cells[1,2*(i-1)]+#13#10;
         ContainerStream.Write(PChar(WriteText)^, Length(WriteText));
         WriteText:=CalcGrid.Cells[1,2*(i-1)+1]+#13#10;
         ContainerStream.Write(PChar(WriteText)^, Length(WriteText));
      end;

   WriteText:=FloatToStr(VarArray[0,0])+','+IntToStr(Trunc(VarArray[0,1]));
   for i:=1 to 255 do
      WriteText:=WriteText+','+FloatToStr(VarArray[i,0])+','+IntToStr(Trunc(VarArray[i,1]));
   ContainerStream.Write(PChar(WriteText)^, Length(WriteText));


   WriteText:=#13#10+IntTostr(User_Functions.Items - User_Functions.Fixed)+#13#10;
   ContainerStream.Write(PChar(WriteText)^, Length(WriteText));
   for i:=User_Functions.Fixed+1 to User_Functions.Items do begin
      with User_Functions do WriteText:=function_names[i]+','+function_vars[i]+'#'+function_equiv[i]+#13#10;
      ContainerStream.Write(PChar(WriteText)^, Length(WriteText));
      end;
   except
   {$ifDEF English}MessageDlg('Container Save operation failed.',mtError,[mbOk],0);{$ENDIF}
   {$IFDEF French}MessageDlg('L''opération de sauvegarde a échoué.',mtError,[mbOk],0);{$ENDIF}
   {$IFDEF German}MessageDlg('Der Rettungsvorgang hat gescheitert.',mtError,[mbOk],0);{$ENDIF}
   end;
   ContainerStream.Destroy;
end;

procedure TCalculator.LoadGridClick(Sender: TObject);
var
   FileName: string;
   ContainerStream: TFileStream;
   procedure ReadLine(var iString: string);
   var
      iChar: char;
   begin
      iString:='';
      ContainerStream.Read(iChar, 1);
      while (iChar<>Chr(13)) do begin
         iString:=iString+iChar;
         ContainerStream.Read(iChar, 1);
         end;
      ContainerStream.Read(iChar, 1);
      end;

   procedure ReadItem(var iString: string);
   var
      iChar: char;
   begin
      ContainerStream.Read(iChar, 1);
      iString:='';
      while (iChar<>',') and (iChar<>Chr(13)) do begin
         iString:=iString+iChar;
         ContainerStream.Read(iChar, 1);
         end;
      if iChar=Chr(13) then ContainerStream.Read(iChar,1);
      end;
var
   iString, iMode, iStatus, iResult: string;
   items, iCount: LongInt;

   procedure ReadVersion230File;
   var
      i: LongInt;
   begin
      ReadItem(iString);
      items:=StrToInt(iString);

      for i:=1 to Items do begin
         ReadItem(iMode);
         ReadItem(iStatus);
         ReadLine(iString);
         ReadLine(iResult);

         if iStatus = 'ok' then
         with CalcGrid do begin
            Cells[0,RowCount-1]:=IntToStr(RowCount div 2+1);
            Cells[1,RowCount-1]:=iString;
            Cells[2,RowCount-1]:=iMode;
            Cells[3,RowCount-1]:=iStatus;
            RowCount:=RowCount+1;
            Cells[1,RowCount-1]:=iResult;
            RowCount:=RowCount+1;
            end else begin
            iCount:=CalcGrid.RowCount;
            iResult:=CalcEdit.Text;
            CalcEdit.Text:=iString;
            FunctionEXEClick(Sender);
            while CalcEdit.Text<>'' do Application.ProcessMessages;
            while CalcGrid.RowCount<iCount+2 do Application.ProcessMessages;
            CalcEdit.Text:=iResult;
            end;

         end;

      for i:=0 to 254 do begin
         ReadItem(iResult);
         ReadItem(iStatus);
         if iStatus<>'0' then begin
            VarArray[i,0]:=StrToFloat(iResult);
            VarArray[i,1]:=1;
            end;
            end;

      VarArray[Ord('E'),0]:=exp(1.0);
      VarArray[Ord('E'),1]:=1;
      VarArray[Ord('G'),0]:=0.5772156649015328606065120900824024310421593359399235988057672348848677267776646709369470632917467495;
      VarArray[Ord('G'),1]:=1;
      end;
procedure ReadUserFunctions;
var
   i: LongInt;
begin
   ReadLine(iString);
   ReadItem(iString);
   items:=StrToInt(iString);
   for i:=1 to Items do begin
      ReadItem(iString);
      ReadLine(iStatus);
      {$ifDef Registered}
      Calculator.User_Functions.AddFullFunction(iString, iStatus);
      {$EndIf}
      end;
   UpdateUserMenu;
   {$ifDef Registered}
   User_functions.SetUserRegistry;
   {$EndIf}
   end;

begin

   if OpenDialog1.Execute=False then exit;
   FileName:=OpenDialog1.Filename;
   if FileName='' then exit;
   SaveDialog1.FileName:=FileName;

   ContainerStream:=TFileStream.Create(FileName, fmOpenRead);

   try
   if CalcGrid.RowCount > 1 then begin
      {$ifDEF English}if MessageDlg('Do you want to keep the current results?',mtInformation,[mbYes]+[mbNo],0) = mrNo then begin{$ENDIF}
      {$IFDEF French}if MessageDlg('Voulez-vous garder les résultats actuels?',mtInformation,[mbYes]+[mbNo],0) = mrNo then begin{$ENDIF}
      {$IFDEF German}if MessageDlg('Wollen Sie derzeitige Ergebnisse behalten?',mtInformation,[mbYes]+[mbNo],0) = mrNo then begin{$ENDIF}
         ACOpClick(Sender);
         while EvalExpressions > 0 do Application.ProcessMessages;
         end;
      end;

   ReadItem(iString);
   if iString = 'ExCalc0230' then begin
      ReadVersion230File;
      end else
   if iString = 'ExCalc0231' then begin
      ReadVersion230File;
      ReadUserFunctions;
      end else begin
      {$ifDEF English}MessageDlg('Error loading container file: unknown container format.',mtError, [mbCancel],0);{$ENDIF}
      {$IFDEF French} MessageDlg('Erreur de chargement: format du fichier inconnu.',mtError, [mbCancel],0);{$ENDIF}
      {$IFDEF German}MessageDlg('Fehler in Ladung: die Dateiformat ist unbekannt.',mtError, [mbCancel],0);{$ENDIF}
      end;

   except
      {$ifDEF English}MessageDlg('Error loading container.',mtError,[mbOk],0);{$ENDIF}
      {$IFDEF French}MessageDlg('Erreur de chargement.',mtError,[mbOk],0);{$ENDIF}
      {$IFDEF German}MessageDlg('Fehler in Ladung',mtError,[mbOk],0);{$ENDIF}
   end;
   ContainerStream.Destroy;
   end;


procedure TCalculator.CatalanClick(Sender: TObject);
begin
   InsertCalcEditChar('Catalan');
   end;

procedure TCalculator.TrapezoidClick(Sender: TObject);
begin
   InsertCalcEditChar('Trapezoid(,,,)');
   CalcEdit.SelStart:=CalcEdit.SelStart-4;
   end;

procedure TCalculator.N10Click(Sender: TObject);
begin
   InsertCalcEditChar('Simpson(,,,)');
   CalcEdit.SelStart:=CalcEdit.SelStart-4;
   end;

procedure TCalculator.Newton1Click(Sender: TObject);
begin
   InsertCalcEditChar('Newton(,,,)');
   CalcEdit.SelStart:=CalcEdit.SelStart-4;
   end;

procedure TCalculator.Boole1Click(Sender: TObject);
begin
   InsertCalcEditChar('Boole(,,,)');
   CalcEdit.SelStart:=CalcEdit.SelStart-4;
   end;

procedure TCalculator.OrderSixClick(Sender: TObject);
begin
   InsertCalcEditChar('OrderSix(,,,)');
   CalcEdit.SelStart:=CalcEdit.SelStart-4;
   end;

procedure TCalculator.Weddle1Click(Sender: TObject);
begin
   InsertCalcEditChar('Weddle(,,,)');
   CalcEdit.SelStart:=CalcEdit.SelStart-4;
   end;

procedure TCalculator.IntGauss1Click(Sender: TObject);
begin
   InsertCalcEditChar('Int(,,,)');
   CalcEdit.SelStart:=CalcEdit.SelStart-4;
   end;

procedure TCalculator.SummClick(Sender: TObject);
begin
   InsertCalcEditChar('Sum()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.ProductClick(Sender: TObject);
begin
   InsertCalcEditChar('Mul()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.EulerGClick(Sender: TObject);
begin
   InsertCalcEditChar('G');
   end;

procedure TCalculator.HarmonicClick(Sender: TObject);
begin
   InsertCalcEditChar('Harmonic()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.Sigmanp1Click(Sender: TObject);
begin
   InsertCalcEditChar('Sigma(,)');
   CalcEdit.SelStart:=CalcEdit.SelStart-2;
   end;

procedure TCalculator.Taun1Click(Sender: TObject);
begin
   InsertCalcEditChar('Tau()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.DilogClick(Sender: TObject);
begin
   InsertCalcEditChar('Dilog()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.SiClick(Sender: TObject);
begin
   InsertCalcEditChar('Si()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.CiClick(Sender: TObject);
begin
   InsertCalcEditChar('Ci()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;



procedure TCalculator.SsiClick(Sender: TObject);
begin
   InsertCalcEditChar('Ssi()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;



procedure TCalculator.ShiClick(Sender: TObject);
begin
   InsertCalcEditChar('Shi()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;



procedure TCalculator.ChiClick(Sender: TObject);
begin
   InsertCalcEditChar('Chi()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;



procedure TCalculator.FresnelSClick(Sender: TObject);
begin
   InsertCalcEditChar('FresnelS()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;



procedure TCalculator.FresnelCClick(Sender: TObject);
begin
   InsertCalcEditChar('FresnelC()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;


procedure TCalculator.FresnelFClick(Sender: TObject);
begin
   InsertCalcEditChar('FresnelF()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;



procedure TCalculator.FresnelGClick(Sender: TObject);
begin
   InsertCalcEditChar('FresnelG()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;



procedure TCalculator.EllipticEClick(Sender: TObject);
begin
   InsertCalcEditChar('EllipticE()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.EllipticCEClick(Sender: TObject);
begin
   InsertCalcEditChar('EllipticCE()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;



procedure TCalculator.EllipticFClick(Sender: TObject);
begin
   InsertCalcEditChar('EllipticF()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;



procedure TCalculator.EllipticKClick(Sender: TObject);
begin
   InsertCalcEditChar('EllipticK()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;



procedure TCalculator.EllipticCKClick(Sender: TObject);
begin
   InsertCalcEditChar('EllipticCK()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;



procedure TCalculator.Pochhammern1Click(Sender: TObject);
begin
   InsertCalcEditChar('Pochhammer()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;



procedure TCalculator.ErfErrorClick(Sender: TObject);
begin
   InsertCalcEditChar('Erf()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.ErcfComplClick(Sender: TObject);
begin
   InsertCalcEditChar('Erfc()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.DropIntegralClick(Sender: TObject);
begin
   while DroppedIntegral[0] = 1 do Application.ProcessMessages;
   DroppedIntegral[0]:=1;
   DroppedIntegral[1]:=ProbablyInterrupt;
   end;

procedure TCalculator.FermatClick(Sender: TObject);
begin
   InsertCalcEditChar('Fermat()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.CalcGridTopLeftChanged(Sender: TObject);
begin
   with CalcGrid do if Col<>1 then Col:=1;
   end;

procedure TCalculator.UpdateUserMenu;
var
   mi: TMenuItem;
   nc: string;
   i,j: integer;
begin
  while (UserDefine.Count > 2) do UserDefine.Remove(UserDefine.Items[2]);
  for i:=User_Functions.Fixed+1 to User_functions.Items do begin
     mi:=TMenuItem.Create(WindowMenu); {Creates the new menu item}
     nc := User_functions.function_names[i];  {Caption for the new menu item}
     mi.hint:=nc;
     if Length(User_functions.function_vars[i])>0 then begin
        nc := nc + '(';
        for j:=1 to Length(user_functions.function_vars[i])-1 do begin
           nc := nc+user_functions.function_Vars[i][j-1]+',';
           end;
        nc := nc+user_functions.function_Vars[i][Length(user_functions.function_vars[i])-1];
        nc := nc + ')';
        end;
   mi.caption:=nc;
   mi.OnClick:=UserMenuClick;
   mi.tag:=Length(user_functions.function_vars[i]);
   UserDefine.Insert(2, mi);   {Inserts the new menu item}
   end;
   end;

procedure TCalculator.UserMenuClick(Sender: tObject);
var
   iStr: string;
   i: integer;
begin
   iStr:=(Sender as TMenuItem).Hint; //Copy((Sender as TMenuItem).Caption, 1, Pos('(', (Sender as TMenuItem).Caption)-1);
   InsertCalcEditChar(iStr);
   if (Sender as TMenuItem).Tag > 0 then begin
      InsertCalcEditChar('(');
   for i:=1 to (Sender as TMenuItem).Tag - 1 do begin
      InsertCalcEditChar(',');
      end;
      InsertCalcEditChar(')');
      end;
   CalcEdit.SelStart:=CalcEdit.SelStart-(Sender as TMenuItem).Tag;
   end;

procedure TCalculator.EditClick(Sender: TObject);
begin
   {$ifDef Registered}
   DefineFunc.Show;
   {$else}
   MessageDlg('This is a registered version feature only!'+#13#10+'Please register at http://www.vestris.com',mtInformation,[mbOk],0);
   {$endif}
   end;

procedure TCalculator.SetLanguage();
begin
   {$ifDEF English}
   AbortButton.Caption:='a';
   CopyMenu.Caption:='&Copy';
   TaskForce.Caption:='&Tasks';
   Special.Caption:='&Primes';
   SaveGrid.Caption:='&Save ...';
   LoadGrid.Caption:='&Load ...';
   Reset.Caption:='&Reset the E.C.';
   ExitEc.Caption:='&Exit the E.C.';
   //--------------------------------------
   cExp.Caption:='&Expression';
   cShort.Caption:='&Short Result';
   cLong.Caption:='&Long Result';
   cAll.Caption:='&All Expressions';
   cAllShort.Caption:='All Short Resu&lts';
   cAllLong.Caption:='All Long Res&ults';
   cEverything.Caption:='A&bsolutely Everything';
   cAllShortEv.Caption:='E&verything (Short Results)';
   cAllLongEv.Caption:='Every&thing (Long Results)';
   //--------------------------------------
   Cancel.Caption:='&Cancel This Task';
   Suspend.Caption:='&Suspend This Task';
   Resume.Caption:='&Resume This Task';
   CancelAll.Caption:='Cancel &All Running Tasks';
   SuspendAll.Caption:='Suspend All &Running Tasks';
   ResumeAll.Caption:='Resume All Suspended &Tasks';
   DropIntegral.Caption:='&Drop Integral';
   //--------------------------------------
   ClearPrimes.Caption:='Clear the &Primes Table';
   CopyPrimes.Caption:='&Copy Primes to Clipboard';
   //--------------------------------------
   UserDefine.Caption:='&User Defined Functions';
   EulerFncts.Caption:='&Euler''s functions';
   PrimDiv.Caption:='&Primes, Perf., Mers. && Divisors';
   RanAv.Caption:='&Random && Average';
   Integrals.Caption:='&Integrals';
   Series.Caption:='&Series';
   Other.Caption:='&Other';
   //--------------------------------------
   Edit.Caption:='&Edit ...';
   EulerPhi.Caption:='&Euler''s indice |x| (Phi)';
   EulerGamma.Caption:='&Gamma (x,step)';
   EulerBeta.Caption:='&Beta (x,y,step)';
   RandomOp.Caption:='&Random (<=x)';
   Average.Caption:='A&verage(x,...,y)';
   Summ.Caption:='&Sum(x,...,y)';
   Product.Caption:='&Mul(x,...,y)';
   //--------------------------------------
   Approx.Caption:='&Approximations - student';
   Trapezoid.Caption:='&Trapezoid';
   OrderSix.Caption:='&OrderSix';
   IntExact.Caption:='&Exact (Gauss)';
   Dilog.Caption:='&Dilogarithm';
   ErfError.Caption:='&Erf (Error Function)';
   ErcfCompl.Caption:='Ercf (&Complementary Erf)';
   Trig.Caption:='&Trigonometric';
   Si.Caption:='&Si (Sine Integral)';
   Ci.Caption:='&Ci (Cosine Integral)';
   Ssi.Caption:='Ss&i (Shifted Sine Integral)';
   Shi.Caption:='S&hi (Hyperbolic Sine Integral)';
   Chi.Caption:='Chi (H&yperbolic Cosine Integral)';
   FresnelS.Caption:='FresnelS (Sine)';
   FresnelC.Caption:='Fresnel&C (Cosine)';
   FresnelF.Caption:='Fresnel&F (Auxilary SC)';
   FresnelG.Caption:='Fresnel&G (Auxilary CS)';
   Elliptic.Caption:='E&lliptic';
   EllipticE.Caption:='Elliptic&E (incomplete second kind)';
   EllipticCE.Caption:='Elliptic&CE (complete second kind)';
   EllipticF.Caption:='Elliptic&F (incomplete first kind)';
   EllipticK.Caption:='Elliptic&K (complete first kind)';
   EllipticCK.Caption:='Ell&ipticCK (complementary complete of 1st kind)';
   Binom.Caption:='&Binomial (n,j)';
   Harmonic.Caption:='&Harmonic(n)';
   //--------------------------------------
   FractPart.Caption:='F&ractional part (x)';
   IntPart.Caption:='&Integer part (x)';
   Floor.Caption:='F&loor (x)';
   Ceiling.Caption:='&Ceiling (x)';
   Truncate.Caption:='&Truncate (x)';
   Round.Caption:='&Round (x)';
   Catalan.Caption:='C&atalan Constant';
   EulerG.Caption:='&Euler''s Gamma Constant';
   //--------------------------------------
   gcd.Caption:='&Greatest Common Divisor (x,...,y)';
   lcm.Caption:='&Least Common Multiple (x,...,y)';
   PrimeX.Caption:='&Prime (x)';
   PrimeN.Caption:='Prime&N (n) (nth prime)';
   PrimeC.Caption:='Prime&C (<=x) (primes count)';
   PrimesI.Caption:='Primes''s &Indice |x| (Euler''s Phi)';
   mersenne.Caption:='&mersenne (3 <= x <= 2^32)';
   mersenneGen.Caption:='mersenne&Gen(2 <= x <=32)';
   MersGen.Caption:='Mer&sGen (x mersenne number)';
   GenMers.Caption:='&GenMers (x mersenne generator)';
   Perfect.Caption:='Per&fect (6 <= x <=2^32)';
   Fermat.Caption:='Fermat (0<=x<=3)';
   ClipProcess.Caption:='&Process Clipboard';
   {$ENDIF}

   {$IFDEF French}
   DirectMode.Caption:='Mode &Direct';
   AbortButton.Caption:='a';
   CopyMenu.Caption:='&Copier';
   TaskForce.Caption:='&Taches';
   Special.Caption:='&Nombres Premiers';
   SaveGrid.Caption:='&Sauvegarder';
   LoadGrid.Caption:='&Charger';
   Reset.Caption:='&Reinitializer';
   ExitEc.Caption:='&Quitter';
   //-------------------------------------
   cExp.Caption:='&Expression';
   cShort.Caption:='Résultat &Arrondi';
   cLong.Caption:='Résultat &Complet';
   cAll.Caption:='&Toutes les Expressions';
   cAllShort.Caption:='Tous les Résultats Arrondis';
   cAllLong.Caption:='Tous les Résultats Complets';
   cEverything.Caption:='Table Entière';
   cAllShortEv.Caption:='Tout (Résultats Courts)';
   cAllLongEv.Caption:='Tout (Résultats Longs)';
   //--------------------------------------
   Cancel.Caption:='&Interrompre Cette Tache';
   Suspend.Caption:='&Suspendre Cette Tache';
   Resume.Caption:='&Reprendre Cette Tache';
   CancelAll.Caption:='Interrompre &Toutes les Taches';
   SuspendAll.Caption:='S&uspendre Toutes les Taches';
   ResumeAll.Caption:='Re&prendre Toutes les Taches';
   DropIntegral.Caption:='&Abandonner l''Intégrale';
   //--------------------------------------
   ClearPrimes.Caption:='&Effacer Tous les Nombres Premiers';
   CopyPrimes.Caption:='&Copier la Liste des Nombres Premiers';
   //--------------------------------------
   UserDefine.Caption:='&Fonction Utilisateur';
   EulerFncts.Caption:='Fonctions d''&Euler';
   PrimDiv.Caption:='&Premiers, Parfaits, mersens && Diviseurs';
   RanAv.Caption:='&Aléatoires && Moyennes';
   Integrals.Caption:='&Intégrales';
   Series.Caption:='&Séries';
   Other.Caption:='&Autres';
   //-------------------------------------
   Edit.Caption:='&Edition ...';
   EulerPhi.Caption:='&Indice d''Euler |x| (Phi)';
   EulerGamma.Caption:='&Gamma (x,step)';
   EulerBeta.Caption:='&Beta (x,y,step)';
   RandomOp.Caption:='&Aléatoires (<=x)';
   Average.Caption:='&Moyenne(x,...,y)';
   Summ.Caption:='&Somme(x,...,y)';
   Product.Caption:='&Produit(x,...,y)';
   //--------------------------------------
   Approx.Caption:='&Approximations (étudiant)';
   Trapezoid.Caption:='&Trapezoide';
   OrderSix.Caption:='&d''Ordre Six';
   IntExact.Caption:='&Exacte (Gauss)';
   Dilog.Caption:='&Dilogarithme';
   ErfError.Caption:='&Erf (Fonction d''Erreur)';
   ErcfCompl.Caption:='Ercf (&Complémentaire à Erf)';
   Trig.Caption:='Fonctions &Trigonométriques';
   Si.Caption:='&Si (Sinus)';
   Ci.Caption:='&Ci (Cosinus)';
   Ssi.Caption:='Ss&i (Sinus, Décalée)';
   Shi.Caption:='S&hi (Sinus Hyperbolique)';
   Chi.Caption:='Chi (Cosinus H&yperbolique)';
   FresnelS.Caption:='FresnelS (Sinus)';
   FresnelC.Caption:='Fresnel&C (Cosinus)';
   FresnelF.Caption:='Fresnel&F (auxiliaire SC)';
   FresnelG.Caption:='Fresnel&G (auxiliaire CS)';
   Elliptic.Caption:='E&lliptique';
   EllipticE.Caption:='Elliptique&E (incomplète du second order)';
   EllipticCE.Caption:='Elliptique&CE (complète du second ordre)';
   EllipticF.Caption:='Elliptique&F (incomplète du premier ordre)';
   EllipticK.Caption:='Elliptique&K (complète du premier ordre)';
   EllipticCK.Caption:='Ell&iptiqueCK (complète complémentaire du premier ordre)';
   Binom.Caption:='Coefficient &Binomial (n,j)';
   Harmonic.Caption:='&Harmonique(n)';
   //--------------------------------------
   FractPart.Caption:='Partie F&ractionnaire (x)';
   IntPart.Caption:='Partie &Intière (x)';
   Floor.Caption:='Arrondi en &Bas (x)';
   Ceiling.Caption:='Arrondi en &Haut (x)';
   Truncate.Caption:='&Tronquer (x)';
   Round.Caption:='&Arrondir (x)';
   Catalan.Caption:='Constante de C&atalan';
   EulerG.Caption:='Constante Gamma d''&Euler';
   //--------------------------------------
   gcd.Caption:='&Plus Grand Commun Diviseur (x,...,y)';
   lcm.Caption:='Plus Petit Commun &Multiple (x,...,y)';
   PrimeX.Caption:='&Premier (x)';
   PrimeN.Caption:='Premier&N (n) (n-ème premier)';
   PrimeC.Caption:='Premier&C (<=x) (premiers inférieurs)';
   PrimesI.Caption:='&Indice d''Euler |x| (Phi d''Euler)';
   mersenne.Caption:='&mersenne (3 <= x <= 2^32)';
   mersenneGen.Caption:='mersenne&Gen(2 <= x <=32)';
   MersGen.Caption:='Mer&sGen (x mersenne)';
   GenMers.Caption:='&GenMers (x générateur mersenne)';
   Perfect.Caption:='Par&fait (6 <= x <=2^32)';
   Fermat.Caption:='F&ermat (0<=x<=3)';
   ClipProcess.Caption:='&Evaluer le Presse-Papier';
   {$ENDIF}

   {$IFDEF German}
   DirectMode.Caption:='&Direkt Mode';
   AbortButton.Caption:='h';
   CopyMenu.Caption:='&Kopieren';
   TaskForce.Caption:='&Aufgaben';
   Special.Caption:='&Primfaktoren';
   SaveGrid.Caption:='&Retten ...';
   LoadGrid.Caption:='&Laden ...';
   Reset.Caption:='&Alles Löschen';
   ExitEc.Caption:='&Beenden';
   //-------------------------------------
   cExp.Caption:='&Expression';
   cShort.Caption:='Ergebnis (&gerundet)';
   cLong.Caption:='Ergebnis (&völlig)';
   cAll.Caption:='&Alle Expressionen';
   cAllShort.Caption:='Alle Ergebnisse (gerundete)';
   cAllLong.Caption:='Alle Ergebnisse (völlige)';
   cEverything.Caption:='Alles';
   cAllShortEv.Caption:='Alles (gerundete Ergebnisse)';
   cAllLongEv.Caption:='Alles (vöillige Ergebnisse)';
   //--------------------------------------
   Cancel.Caption:='Diese Aufgabe &Unterbrechen';
   Suspend.Caption:='Diese Aufgabe &Einstellen';
   Resume.Caption:='Diese Aufgabe &Weiterrechnen';
   CancelAll.Caption:='Alle Aufgaben U&nterbrechen';
   SuspendAll.Caption:='Alle Aufgaben E&instellen';
   ResumeAll.Caption:='Alle Aufgaben Weite&rrechnen';
   DropIntegral.Caption:='&Integrationrechnung Unterbrechen';
   //--------------------------------------
   ClearPrimes.Caption:='&Alle Primfaktoren Löschen';
   CopyPrimes.Caption:='Alle Primfaktoren &Copieren';
   //--------------------------------------
   UserDefine.Caption:='&Verbraucherfunktionnen';
   EulerFncts.Caption:='Funktionnen von &Euler';
   PrimDiv.Caption:='&Primfaktoren, Perfektzahlen';
   RanAv.Caption:='&Zufallszahlen und Durchschnitte';
   Integrals.Caption:='&Integrationsrechnung';
   Series.Caption:='&Reihen';
   Other.Caption:='&Andere Funktionnen';
   //-------------------------------------
   Edit.Caption:='&Editieren ...';
   EulerPhi.Caption:='&Primfaktorenzahl von Euler';
   EulerGamma.Caption:='&Gamma (x,Schritt)';
   EulerBeta.Caption:='&Beta (x,y,Schritt)';
   RandomOp.Caption:='&Zufallszahl(<=x)';
   Average.Caption:='&Durchschnitt(x,...,y)';
   Summ.Caption:='&Summe(x,...,y)';
   Product.Caption:='&Produkt(x,...,y)';
   //--------------------------------------
   Approx.Caption:='&Ungefähr (Student)';
   Trapezoid.Caption:='&Trapezoid';
   OrderSix.Caption:='&Ordnung Sechs';
   IntExact.Caption:='&Exakt (Gauss)';
   Dilog.Caption:='&Dilogarithmus';
   ErfError.Caption:='&Erf (Fehlerfunktion)';
   ErcfCompl.Caption:='Ercf (&Erganzefehlerfunktion)';
   Trig.Caption:='&Trigonometrische';
   Si.Caption:='&Si (Sin)';
   Ci.Caption:='&Ci (Cos)';
   Ssi.Caption:='Ss&i (Sin, verschieben)';
   Shi.Caption:='S&hi (Sinh)';
   Chi.Caption:='Ch&i (Cosh)';
   FresnelS.Caption:='FresnelS (Sin)';
   FresnelC.Caption:='Fresnel&C (Cos)';
   FresnelF.Caption:='Fresnel&F (hilfs SC)';
   FresnelG.Caption:='Fresnel&G (hilfs CS)';
   Elliptic.Caption:='E&lliptique';
   EllipticE.Caption:='Elliptique&E (unvoll, Ordnung Zwei)';
   EllipticCE.Caption:='Elliptique&CE (voll, Ordnung Zwei)';
   EllipticF.Caption:='Elliptique&F (unvoll, Erste Ordnung)';
   EllipticK.Caption:='Elliptique&K (voll, Erste Ordnung)';
   EllipticCK.Caption:='Ell&iptiqueCK (hilfsvoll, Erste Ordnung)';
   Binom.Caption:='&Binomkoeffizent(n,j)';
   Harmonic.Caption:='&Hasmonisch(n)';
   //--------------------------------------
   FractPart.Caption:='&Bruchteil (x)';
   IntPart.Caption:='&Vollsteil (x)';
   Floor.Caption:='&Untergerundet (x)';
   Ceiling.Caption:='Obengerunded (x)';
   Truncate.Caption:='&Abstumpfen (x)';
   Round.Caption:='&Runden (x)';
   Catalan.Caption:='&Catalan';
   EulerG.Caption:='&Gamma';
   //--------------------------------------
   gcd.Caption:='&Größter Gemeinsamer Teiler (x,...,y)';
   lcm.Caption:='&Kleinste Gemeinsame Vielfache (x,...,y)';
   PrimeX.Caption:='&Primfaktor (x)';
   PrimeN.Caption:='Primfaktor&N (n) (n-Primfaktor)';
   PrimeC.Caption:='Primfaktor&C (Primfaktoren <=x)';
   PrimesI.Caption:='&Phi(x) (Primfaktoren zu x)';
   mersenne.Caption:='&mersenne (3 <= x <= 2^32)';
   mersenneGen.Caption:='mersenne&Gen(2 <= x <=32)';
   MersGen.Caption:='Mer&sGen (x mersenne)';
   GenMers.Caption:='&GenMers (x mersenne Generator)';
   Perfect.Caption:='Per&fekt (6 <= x <=2^32)';
   Fermat.Caption:='F&ermat (0<=x<=3)';
   ClipProcess.Caption:='C&lipboarddateien Rechnen';   
   {$ENDIF}

   end;

procedure TCalculator.ClipProcessClick(Sender: TObject);
   procedure Execute(var te: string);
   begin
            if OctFlag.Down then TExecute.Create(te,Oct) else
            if BinFlag.Down then TExecute.Create(te,Bin) else
            if HexFlag.Down then TExecute.Create(te,Hex) else
            if RadMode.Down then TExecute.Create(te,Rad) else
                                 TExecute.Create(te,Deg);
   te:='';
   end;
var
   te, ce: string;
   i: LongInt;
begin
   ce:=ClipBoard.AsText;
   te:='';
   for i:=1 to Length(ce) do begin
      if (ce[i]>' ') then begin
         te:=te + ce[i];
         end;
      if (ce[i]<' ') then begin
         if length(te)>0 then execute(te);
         end;
      end;
   if length(te)>0 then execute(te);
   end;

procedure TCalculator.GetResAll(cType: TCopySet; mStart, mStep: integer);
var
   i: longint;
   fr: string;
begin
   i:=CalcGrid.RowCount - mStart;
   fr:='';
   while i>=0 do begin
      fr:=GetCell(i, cType) + #13#10 + fr;
      dec(i,mStep);
      end;
   ClipBoard.AsText:=fr;
   end;

procedure TCalculator.cAllClick(Sender: TObject);
begin
   GetResAll([expression],3,2);
   end;

procedure TCalculator.cEverythingClick(Sender: TObject);
begin
   GetResAll([expression, short, long], 2, 1);
   end;

procedure TCalculator.cAllShortClick(Sender: TObject);
begin
   GetResAll([short], 2, 2);
   end;

procedure TCalculator.cAllLongClick(Sender: TObject);
begin
   GetResAll([long],2,2);
   end;

procedure TCalculator.cAllShortEvClick(Sender: TObject);
begin
   GetResAll([expression, short], 2, 1);
   end;

procedure TCalculator.cAllLongEvClick(Sender: TObject);
begin
   GetResAll([expression, long], 2, 1);
   end;

procedure TCalculator.RegCommandClick(Sender: TObject);
begin
   RegisterCommand.Click;
   end;

procedure TCalculator.RegisterCommandClick(Sender: TObject);
begin
   TFileExecute.Create(ExtractFilePath(Application.ExeName)+'REGISTER.EXE', '', 0);
   end;

procedure TCalculator.SetRegistered;
begin
   {$ifDef Registered}
   RegCommand.Visible:=False;
   OpMenu.Items.Delete(RegisterCommand.MenuIndex);
   InterruptMenu.Items.Delete(RegExCalc.MenuIndex);
   {$Else}
   {$EndIf}
   {$ifdef Uni}
   //UniGe.Visible:=True;
   {$endif}
   end;

procedure TCalculator.DawsonClick(Sender: TObject);
begin
   InsertCalcEditChar('Dawson()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.SafePrimeClick(Sender: TObject);
begin
   InsertCalcEditChar('SafePrime()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.IsPrimeClick(Sender: TObject);
begin
   InsertCalcEditChar('IsPrime()');
   CalcEdit.SelStart:=CalcEdit.SelStart-1;
   end;

procedure TCalculator.RegisterMsg (var Msg: TMsg; var Handled: boolean);
begin
  if Msg.Message = WM_SYSCOMMAND then
    if Msg.wParam = 99 then RegCommand.Click else
    if Msg.wParam = 199 then AboutButton.Click;
       {Registration stuff}
end;

procedure TCalculator.AppendToSystemMenu (Form: TForm; Item: string; ItemID: word);
var
   NormalSysMenu, MinimizedMenu: HMenu;
   AItem: array[0..255] of Char;
   PItem: PChar;
begin
   NormalSysMenu := GetSystemMenu(Form.Handle, false);
   MinimizedMenu := GetSystemMenu(Application.Handle, false);
   if Item = '-' then
   begin
     AppendMenu(NormalSysMenu, MF_SEPARATOR, 0, nil);
     AppendMenu(MinimizedMenu, MF_SEPARATOR, 0, nil);
   end
   else
   begin
     PItem := StrPCopy(@AItem, Item);
     AppendMenu(NormalSysMenu, MF_STRING, ItemID, PItem);
     AppendMenu(MinimizedMenu, MF_STRING, ItemID, PItem);
   end
   end; {AppendToSystemMenu}


procedure TCalculator.ValAClick(Sender: TObject);
begin
     InsertCalcEditChar('A');
     end;

procedure TCalculator.ValBClick(Sender: TObject);
begin
     InsertCalcEditChar('B');
     end;

procedure TCalculator.ValCClick(Sender: TObject);
begin
     InsertCalcEditChar('C');
     end;

procedure TCalculator.ValDClick(Sender: TObject);
begin
     InsertCalcEditChar('D');
     end;

procedure TCalculator.ValEClick(Sender: TObject);
begin
     InsertCalcEditChar('E');
     end;

procedure TCalculator.ValFClick(Sender: TObject);
begin
     InsertCalcEditChar('F');
     end;

procedure TCalculator.BringUpScientific;
begin
         CurrentState:='scientific';
         MinimumHeight :=
            MinGridHeight +
            CalcEdit.Height +
            CalcPanel.Height +
            ModePanel.Height +
            SelPanel.Height +
            OpRightPanel.Height +
            OpPanel.Height +
            (OpPanel.Top - OpRightPanel.Top - OpRightPanel.Height) +
            (Height - ClientHeight);
         ClientHeight :=
            CalcGrid.Height +
            CalcEdit.Height +
            CalcPanel.Height +
            ModePanel.Height +
            SelPanel.Height +
            OpRightPanel.Height +
            (OpPanel.Top - OpRightPanel.Top - OpRightPanel.Height) +
            OpPanel.Height;
         OpLeftPanel.Visible:=True;
         OpRightPanel.Visible := True;
         SelPanel.Visible:=True;
         OpPanel.Visible:=True;
         UpdateDependencies;
     end;

{$ifndef Registered}
procedure TCalculator.SharewareNag;
begin
     MsgForm.MessageDlg('Expression Calculator shareware release has expired. No Calculations shall be possible.',
                'The Shareware agreement allows you to use the Expression Calculator for a period of '+IntToStr(ShareWareMax)+' days. '+
                'You now have to register the Expression Calculator if you continue to use it. You may also download the latest shareware release and register online at '+
                'http://www.vestris.com.', mtError, [mbOk], 0, '');
     Expired:=True;
     end;
{$endif}

procedure TCalculator.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Application.Terminate;
     end;

procedure TCalculator.SpecialClick(Sender: TObject);
begin
     ClearPrimes.Enabled := not PrimeTableInUse;
     CopyPrimes.Enabled := not PrimeTableInUse;
     end;

procedure TCalculator.ReadRegistry;
var
   i: integer;
   InitMode: string;
   cw, ch: integer;
begin

   CurrentState := '';

   for i := 1 to ParamCount do begin
     if CompareText(ParamStr(i), 'medium') = 0 then begin
        BringUpMedium;
        break;
        end else
     if CompareText(ParamStr(i), 'small') = 0 then begin
        BringUpMedium;
        BringUpSmall;
        break;
        end else
     if CompareText(ParamStr(i), 'scientific') = 0 then begin
        CurrentState:='scientific';
        break;
        end;
     end;

   // init mode
   InitMode := ExCalcInit.QueryRegistry(HKEY_CURRENT_USER, PChar(gReg), 'init');

   if (InitMode = '') then begin

      ExCalcInit.AddRegistryStr(HKEY_CURRENT_USER, PChar(gReg), 'init', 'scientific');
      CurrentState := 'scientific';
      end else begin

      if CurrentState = '' then begin
        if (InitMode='medium') then begin
           BringUpMedium;
        end else if (InitMode='small') then begin
           BringUpMedium;
           BringUpSmall;
        end;
      end;

      end;

   // calculator width
   Calculator.width := ExCalcInit.QueryRegistryVal(HKEY_CURRENT_USER, PChar(gReg), 'width', MinimumWidth);
   Calculator.height := ExCalcInit.QueryRegistryVal(HKEY_CURRENT_USER, PChar(gReg), 'height', MinimumHeight);

   cw := ExCalcInit.QueryRegistryVal(HKEY_CURRENT_USER, PChar(gReg), 'xpos', (Screen.Width - Calculator.Width) div 2);
   ch := ExCalcInit.QueryRegistryVal(HKEY_CURRENT_USER, PChar(gReg), 'ypos', (Screen.Height - Calculator.Height) div 2);

   cw := max(min(Screen.Width - Calculator.Width, cw), 0);
   ch := max(min(Screen.Height - Calculator.Height, ch), 0);

   if NoQuit then begin
      Randomize;
      Calculator.Left := Random(Screen.Width);
      Calculator.Top := Random(Screen.Height);
      end else begin
      Calculator.Left := cw;
      Calculator.Top := ch;
      end;

   {with Image1.Picture.bitmap do begin
      Image1.Picture.Bitmap.Palette:=Image1.Picture.Bitmap.Palette;
      Canvas.Draw(0,0,Image1.Picture.bitmap);
      Update;
      end;}

   {$ifDef Registered}
   {$Else If}
   AppendToSystemMenu(Calculator, '&Register the Expression Calculator', 99);
   {$EndIf}
   //-------------------------
   user_functions := user_f.init;
   {$ifDef Registered}
   user_functions.GetUserRegistry;
   {$EndIf}
   //-------------------------
   end;

procedure TCalculator.ReadOptions;
begin
   {$ifdef Registered}
   ScreenLimits := TFormCalculatorOptions.GetOption('screen limits', true);
   if (TFormCalculatorOptions.GetOption('inactive buttons', false)) then begin
      ReactManager.Suspend;
   end else begin
      ReactManager.Launch;
   end;
   {$endif}
   end;

procedure TCalculator.OptionsClick(Sender: TObject);
begin
   ShowOptions;
   end;

procedure TCalculator.ShowOptions;
begin
    if (FormCalculatorOptions = nil) then
       Application.CreateForm(TFormCalculatorOptions, FormCalculatorOptions);
    FormCalculatorOptions.ShowModal;
    ReadOptions;
    end;

procedure TCalculator.ShowHelp;
begin
   if (HtmlHelp = nil) then
       Application.CreateForm(THtmlHelp, HtmlHelp);
   HtmlHelp.Show;
   end;

end.


