unit Options;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFormCalculatorOptions = class(TForm)
    FormOptionsPages: TPageControl;
    FormOptionsCmdPanel: TPanel;
    ButtonOk: TBitBtn;
    ButtonCancel: TBitBtn;
    OptionsGeneral: TTabSheet;
    OptionShowIntro: TCheckBox;
    OptionSaveSettings: TCheckBox;
    OptionsCalculator: TTabSheet;
    OptionDirectMode: TCheckBox;
    OptionsAboutPage: TTabSheet;
    AboutExcalcLabel: TStaticText;
    OptionSystem: TTabSheet;
    SystemUsageLabel: TLabel;
    CopyrightNotice: TLabel;
    VestrisComUrl: TStaticText;
    Panel1: TPanel;
    ExCalcSystemLabel: TStaticText;
    Image1: TImage;
    StaticText1: TStaticText;
    OptionScreenLimits: TCheckBox;
    OptionDisableActiveButtons: TCheckBox;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure SaveOptions;
    procedure LoadOptions;
    procedure OnOptionsChange;
    class function MemStatusString: string;
  public
    { Public declarations }
    procedure SaveOption(var Checkbox: TCheckBox; RegValue: string);
    procedure LoadOption(var Checkbox: TCheckBox; RegValue: string; DefaultValue: boolean);
    class function GetOption(RegValue: string; DefValue: boolean): boolean;
  end;

var
  FormCalculatorOptions: TFormCalculatorOptions;

implementation

uses init, d32about, sccalc, SpriteReact;

{$R *.DFM}

procedure TFormCalculatorOptions.ButtonCancelClick(Sender: TObject);
begin
    Close;
    end;

procedure TFormCalculatorOptions.ButtonOkClick(Sender: TObject);
begin
    SaveOptions;
    Close;
    end;

procedure TFormCalculatorOptions.OnOptionsChange;
begin
   {$ifdef Registered}   
   {$endif}
   end;

procedure TFormCalculatorOptions.SaveOption(var Checkbox: TCheckBox; RegValue: string);
var
    IntValue: integer;
begin
    if (Checkbox.Checked)
        then IntValue := 1
    else IntValue := 0;
    ExCalcInit.AddRegistryVal(HKEY_CURRENT_USER, PChar(gReg), PChar(RegValue), IntValue);
    end;

procedure TFormCalculatorOptions.LoadOption(var Checkbox: TCheckBox; RegValue: string; DefaultValue: boolean);
var
    IntValue: integer;
begin
    if (DefaultValue = true)
        then IntValue := 1
    else IntValue := 0;
    IntValue := ExCalcInit.QueryRegistryVal(HKEY_CURRENT_USER, PChar(gReg), PChar(RegValue), IntValue);
    if (IntValue = 1) then
        Checkbox.Checked := true
    else Checkbox.Checked := false;
    end;

procedure TFormCalculatorOptions.FormShow(Sender: TObject);
begin
    LoadOptions;
    {$ifnDef Registered}
    OptionDirectMode.Enabled := false;
    OptionShowIntro.Enabled := false;
    OptionScreenLimits.Enabled := false;
    OptionDisableActiveButtons.Enabled := false;
    {$endif}
    CreateVersionString;
    SystemUsageLabel.Caption := VersionString + #13#10 + MemStatusString;
    CopyrightNotice.Caption :=
        'This computer program is protected by copyright law and international treaties. ' +
        'Unauthorized reproduction or distribution of this program, or any portion of it, ' +
        'may result in severe civil and criminal penalties, and will be ' +
        'prosectuted to the maximum extent possible under the law. ' +
        'The copyright owner of this software as well as any party ' +
        'involved in the production and distribution may not be held ' +
        'responsible for any kind of whatsoever may be claimed due directly ' +
        'or indirectly to the use of this product.';
    ExCalcSystemLabel.Caption :=
        ecVersion
        + #13#10 + ecBuild
        {$ifndef Registered}
        + #13#10 + IntToStr(ShareWareMax - Calculator.TillExpired) + ' days of evaluation left.'
        {$endif}
        ;

    end;

procedure TFormCalculatorOptions.LoadOptions;
begin
    LoadOption(OptionSaveSettings, 'save settings', true);
    {$ifDef Registered}
    LoadOption(OptionShowIntro, 'show intro', true);
    LoadOption(OptionScreenLimits, 'screen limits', true);
    LoadOption(OptionDisableActiveButtons, 'inactive buttons', false);
    LoadOption(OptionDirectMode, 'direct mode', false);
    {$endif}
    end;

procedure TFormCalculatorOptions.SaveOptions;
begin
    SaveOption(OptionSaveSettings, 'save settings');
    {$ifDef Registered}
    SaveOption(OptionShowIntro, 'show intro');
    SaveOption(OptionDirectMode, 'direct mode');
    SaveOption(OptionScreenLimits, 'screen limits');
    SaveOption(OptionDisableActiveButtons, 'inactive buttons');
    {$endif}
    OnOptionsChange;
    end;

class function TFormCalculatorOptions.GetOption(RegValue: string; DefValue: boolean): boolean;
var
    IntValue: integer;
begin
    if (DefValue = true)
        then IntValue := 1
    else IntValue := 0;
    IntValue := ExCalcInit.QueryRegistryVal(HKEY_CURRENT_USER, PChar(gReg), PChar(RegValue), IntValue);
    if (IntValue = 1) then
        Result := true
    else Result := false;
    end;

class function TFormCalculatorOptions.MemStatusString: string;
var
   MemStatus: TMemoryStatus;
begin
   try
   MemStatus.dwLength:=sizeOf(TMemoryStatus);
   GlobalMemoryStatus(MemStatus);

    MemStatusString:='Total memory: '+FormatFloat('#,###" Kb (physical)"', MemStatus.dwTotalPhys/1024)+FormatFloat(' #,###" Kb"', MemStatus.dwTotalPageFile/1024) + ' (page file)' + Chr(13)+Chr(10) +
                     'Free memory: '+FormatFloat('#,###" Kb (physical)"', MemStatus.dwAvailPhys/1024)+FormatFloat(' #,###" Kb"', MemStatus.dwAvailPageFile/1024) + ' (page file)';
   except
   MemStatusString:='(unable to get memory information)';
   end;
   end;

procedure TFormCalculatorOptions.FormCreate(Sender: TObject);
begin
    FormOptionsPages.ActivePageIndex := 0;
    end;

end.
