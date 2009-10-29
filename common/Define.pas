unit Define;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids;

type
  TDefineFunc = class(TForm)
    DefFuncs: TStringGrid;
    UpdateB: TBitBtn;
    cancel: TBitBtn;
    clear: TBitBtn;
    remove: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UpdateFGrid;
    procedure RemoveRow(i : integer);
    function  EmptyCell(i: integer): boolean;
    procedure DefFuncsKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cancelClick(Sender: TObject);
    procedure clearClick(Sender: TObject);
    procedure UpdateBClick(Sender: TObject);
    procedure DefFuncsKeyPress(Sender: TObject; var Key: Char);
    procedure DefFuncsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure removeClick(Sender: TObject);
    procedure DefFuncsDrawCell(Sender: TObject; Col, Row: Longint; Rect: TRect; State: TGridDrawState);
    procedure DefFuncsSelectCell(Sender: TObject; Col, Row: Longint; var CanSelect: Boolean);
    procedure FormResize(Sender: TObject);
  private
    MinimumWidth, MinimumHeight: integer;
    procedure WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure WMwindowposchanging(var M: TWMwindowposchanging); message wm_windowposchanging;
    procedure MakeVisible(TheRow: LongInt);
  public
    procedure SetXYPos;
    procedure SaveXYPos;
  end;

var
  DefineFunc: TDefineFunc;

implementation

uses init, ScCalc, mcalc, math;

{$R *.DFM}

procedure TDefineFunc.SetXYPos;
var
   cw, ch: integer;
begin

   cw := ExCalcInit.QueryRegistryVal(HKEY_CURRENT_USER, PChar(gReg), 'xpos_define', (Screen.Width - DefineFunc.Width) div 2);
   ch := ExCalcInit.QueryRegistryVal(HKEY_CURRENT_USER, PChar(gReg), 'ypos_define', (Screen.Height - DefineFunc.Height) div 2);

   DefineFunc.Left := max(min(Screen.Width - DefineFunc.Width, cw), 0);
   DefineFunc.Top := max(min(Screen.Height - DefineFunc.Height, ch), 0);

   cw := ExCalcInit.QueryRegistryVal(HKEY_CURRENT_USER, PChar(gReg), 'width_define', (Screen.Width - DefineFunc.Width) div 2);
   ch := ExCalcInit.QueryRegistryVal(HKEY_CURRENT_USER, PChar(gReg), 'height_define', (Screen.Height - DefineFunc.Height) div 2);

   DefineFunc.Width := max(min(Screen.Width - DefineFunc.Width, cw), 0);
   DefineFunc.Height := max(min(Screen.Height - DefineFunc.Height, ch), 0);

   end;

procedure TDefineFunc.SaveXYPos;
begin
   try
   ExCalcInit.AddRegistryVal(HKEY_CURRENT_USER,
                               PChar(gReg),
                               'xpos_define', DefineFunc.Left);
   except
   end;
   try
   ExCalcInit.AddRegistryVal(HKEY_CURRENT_USER,
                               PChar(gReg),
                               'ypos_define', DefineFunc.Top);
   except
   end;
   try
   ExCalcInit.AddRegistryVal(HKEY_CURRENT_USER,
                               PChar(gReg),
                               'height_define', DefineFunc.Height);
   except
   end;
   try
   ExCalcInit.AddRegistryVal(HKEY_CURRENT_USER,
                               PChar(gReg),
                               'width_define', DefineFunc.Width);
   except
   end;
   end;

procedure TDefineFunc.FormCreate(Sender: TObject);
begin
   with DefFuncs do begin

      {$ifDEF English}
      Cells[0,0]:='Name:';
      Cells[1,0]:='Variables:';
      Cells[2,0]:='Function:';
      DefineFunc.Caption:='User Defined Functions:';
      remove.caption:='&Remove';
      cancel.caption:='&Cancel';
      clear.caption:='C&lear';
      updateB.caption:='&Update';
      {$ENDIF}
      {$IFDEF French}
      Cells[0,0]:='Nom:';
      Cells[1,0]:='Variables:';
      Cells[2,0]:='Fonction:';
      DefineFunc.Caption:='Fonctions Utilisateur:';
      remove.caption:='&Effacer';
      cancel.caption:='&Annuler';
      clear.caption:='&Tout Eff.';
      updateB.caption:='&Sauver';
      {$ENDIF}
      {$IFDEF German}
      Cells[0,0]:='Name:';
      Cells[1,0]:='Veränderliche:';
      Cells[2,0]:='Funktion:';
      DefineFunc.Caption:='Anwender Funktionen:';
      remove.caption:='&Löschen';
      cancel.caption:='&Abbruch';
      clear.caption:='A&lles löschen';
      updateB.caption:='&Speichern';
      {$ENDIF}
      ColWidths[2]:=ColWidths[1]*2;
      RowCount:=2;
      end;
   MinimumWidth:=DefineFunc.Width;
   MinimumHeight:=DefineFunc.Height;
   SetXYPos;
   end;

procedure TDefineFunc.FormShow(Sender: TObject);
var
   i,j: integer;
begin
   for i:=1 to DefFuncs.RowCount do begin
      for j:=0 to DefFuncs.ColCount - 1 do DefFuncs.Cells[j,i]:='';
      end;
   DefFuncs.RowCount:=2;
   for i:=1 to Calculator.User_Functions.Items do begin
      with DefFuncs do begin
         Cells[0,i]:=Calculator.User_Functions.function_names[i];
         Cells[1,i]:=Calculator.User_Functions.function_vars[i];
         Cells[2,i]:=Calculator.User_Functions.function_equiv[i];
         UpdateFGrid;
         end;
      end;
   MakeVisible(DefFuncs.RowCount - 1);
   DefFuncs.Row:=DefFuncs.RowCount - 1;
   DefFuncs.SetFocus;
   end;

procedure TDefineFunc.RemoveRow(i : integer);
var
   j, k: integer;
begin
   with DefFuncs do
      for j:=i to RowCount - 1 do begin
         for k:=0 to ColCount - 1 do begin
            Cells[k, j]:=Cells[k,j+1];
            end;
         end;
   DefFuncs.RowCount:=DefFuncs.RowCount-1;
   end;

procedure TDefineFunc.UpdateFGrid;
var
   i: integer;
begin
   with DefFuncs do begin
      if not EmptyCell(RowCount-1) then RowCount:=RowCount+1;
      for i:=0 to 2 do Cells[i, RowCount-1]:='';
   end;
   end;

function  TDefineFunc.EmptyCell(i: integer): boolean;
var
   j: integer;
begin
   Result:=True;
   with DefFuncs do
      for j:=0 to ColCount - 1 do begin
         if (trim(Cells[j,i])<>'') then begin
             Result:=False;
             break;
             end;
         end;
   end;

procedure TDefineFunc.DefFuncsKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
   i: integer;
begin
   with defFuncs do
      if not(EmptyCell(RowCount-1)) then begin
         RowCount:=RowCount+1;
         for i:=0 to 2 do Cells[i, RowCount-1]:='';
         end;
   end;

procedure TDefineFunc.cancelClick(Sender: TObject);
begin
   DefineFunc.Hide;
   end;

procedure TDefineFunc.clearClick(Sender: TObject);
var
   i: integer;
begin
     with DefFuncs do begin
        RowCount:=Calculator.User_Functions.Fixed+2;
        for i:=0 to 2 do Cells[i, RowCount-1]:='';
        end;

     end;

procedure TDefineFunc.UpdateBClick(Sender: TObject);
var
   i: integer;
begin
   Calculator.User_Functions.Init;
   with DefFuncs do
      for i:=Calculator.user_functions.fixed+1 to RowCount - 1 do begin
         if Length(Cells[0,i])=1 then begin
            {$ifDEF English}MessageDlg('Error in definition of '+Cells[0,i]+#13#10+'Please use the "=" operator to assign single variables!',mtError,[mbOk],0);{$ENDIF}
            {$IFDEF French} MessageDlg('Erreur dans la définition de '+Cells[0,i]+#13#10+'Veuillez utiliser l''opérateur "=" pour désigner les variables simples!',mtError,[mbOk],0);{$ENDIF}
            {$IFDEF German} MessageDlg('Fehler in die Definition von '+Cells[0,i]+#13#10+'Benutzen Sie "=" für einfache Verändliche!',mtError,[mbOk],0);{$ENDIF}
            exit;
            end else
         if Length(Cells[0,i])>1 then begin
            if not Calculator.User_Functions.AddFunction(PChar(Cells[0,i]),PChar(Cells[2,i]),PChar(Cells[1,i])) then begin
            {$ifDEF English}MessageDlg('Function "'+ Cells[0,i] +'" is protected and cannot be modified!',mtError,[mbOk],0);{$ENDIF}
            {$IFDEF French} MessageDlg('La fonction "'+ Cells[0,i] +'" est protégée et ne peut être modifiée!',mtError,[mbOk],0);{$ENDIF}
            {$IFDEF German} MessageDlg('Die Funktion "'+ Cells[0,i] +'" ist beschützt und kann nicht modifiziert werden!',mtError,[mbOk],0);{$ENDIF}
               exit;
               end;
            end;
         end;
   Calculator.User_Functions.SetUserRegistry;
   Hide;
   end;

procedure TDefineFunc.DefFuncsKeyPress(Sender: TObject; var Key: Char);
begin
   with Deffuncs do begin
      if Row <= Calculator.User_functions.Fixed then begin
            {$ifDEF English}MessageDlg('Function "'+Cells[0,Row]+'" is protected and cannot be modified!',mtError,[mbOk],0);{$ENDIF}
            {$IFDEF French} MessageDlg('La fonction "'+Cells[0,Row]+'" est protégée et ne peut être modifiée!',mtError,[mbOk],0);{$ENDIF}
            {$IFDEF German} MessageDlg('Die Funktion "'+ Cells[0,Row] +'" ist beschützt und kann nicht modifiziert werden!',mtError,[mbOk],0);{$ENDIF}
         Key:=Chr(0);
         end;
      if (Col<>2) and (not (Key in [Chr(8), 'a'..'z','A'..'Z'])) then Key:=Chr(0);
      end;
end;

procedure TDefineFunc.DefFuncsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   with Deffuncs do begin
      if Row <= Calculator.User_functions.Fixed then begin
         if (Chr(Key) in [Chr(46), Chr(8), 'a'..'z','A'..'Z']) then Key:=0;
         end;
      end;
   end;

procedure TDefineFunc.removeClick(Sender: TObject);
begin
   with DefFuncs do
   if Row > Calculator.User_Functions.Fixed then
      RemoveRow(DefFuncs.Row) else
            {$ifDEF English}MessageDlg('Function "'+Cells[0,Row]+'" is protected and cannot be modified!',mtError,[mbOk],0);{$ENDIF}
            {$IFDEF French} MessageDlg('La fonction "'+Cells[0,Row]+'" est protégée et ne peut être modifiée!',mtError,[mbOk],0);{$ENDIF}
            {$IFDEF German} MessageDlg('Die Funktion "'+ Cells[0,Row] +'" ist beschützt und kann nicht modifiziert werden!',mtError,[mbOk],0);{$ENDIF}
   UpdateFGrid;
   DefFuncs.Row:=DefFuncs.RowCount - 1;
   DefFuncs.SetFocus;
   end;

procedure TDefineFunc.DefFuncsDrawCell(Sender: TObject; Col, Row: Longint; Rect: TRect; State: TGridDrawState);
var
   OutText: string;
begin
   try
   with (DefFuncs as TStringGrid).Canvas do begin
      if (Calculator.User_Functions.Fixed >= Row) and (Row > 0) then Brush.Color:=clSilver;
      FillRect(Rect);
      OutText:=DefFuncs.Cells[Col, Row];
      while TextWidth(OutText)>Rect.Right-Rect.Left do Delete(OutText,Length(OutText),1);
      TextOut(Rect.Left+2, Rect.Top, OutText);
      Brush.Color:=clGray;
      FrameRect(Rect);
      end;
   except
   end;
end;

procedure TDefineFunc.DefFuncsSelectCell(Sender: TObject; Col,
  Row: Longint; var CanSelect: Boolean);
begin
   try
   if (Row > Calculator.User_Functions.Fixed) then CanSelect:=True else CanSelect:=False;
   except
   end;
   end;

procedure TDefineFunc.FormResize(Sender: TObject);
begin
   Remove.Top:=DefineFunc.ClientHeight - Remove.Height - 1;
   Clear.Top:=Remove.Top;
   Cancel.Top:=Remove.Top;
   UpdateB.Top:=Remove.Top;
   UpdateB.Left:=DefineFunc.ClientWidth - UpdateB.Width - 1;
   Cancel.Left:=UpdateB.Left - Cancel.Width - 1;
   Clear.Left:=Cancel.Left - Clear.Width - 1;
   Remove.Left:=Clear.Left - Remove.Width - 1;
   DefFuncs.Height:=Remove.Top - 1;
   DefFuncs.ColWidths[2]:=DefFuncs.ClientWidth div 2 - 1;
   DefFuncs.ColWidths[0]:=DefFuncs.ClientWidth div 4 - 1;
   DefFuncs.ColWidths[1]:=DefFuncs.ColWidths[0];
   end;

 procedure TDefineFunc.WMGetMinMaxInfo(var Msg: TWMGetMinMaxInfo);
 begin
     inherited;
     with Msg.MinMaxInfo^ do begin
        if ptMinTrackSize.x<MinimumWidth then ptMinTrackSize.x:= MinimumWidth;
        if ptMinTrackSize.y<MinimumHeight then ptMinTrackSize.y:= MinimumHeight;
        end;
     end;

procedure TDefineFunc.WMwindowposchanging(var M: TWMwindowposchanging);
begin
   inherited;
   with M.WindowPos^ do begin
      if cx<=MinimumWidth then
         cx:=MinimumWidth;
      if cy<=MinimumHeight then
         cy:=MinimumHeight;

      if (cx<>Width) or (cy<>Height) then begin
         if x<0 then begin cx:=cx+x; x:=0; end;
         if y<0 then begin cy:=cy+y; y:=0; end;
         if x+cx>Screen.Width then cx:=Screen.Width-x;
         if y+cy>Screen.Height then cy:=Screen.Height-y;
      end else begin
         if x<0 then x:=0;
         if y<0 then y:=0;
         if x+cx>Screen.Width then x:=Screen.Width-cx;
         if y+cy>Screen.Height then y:=Screen.Height-cy;
      end;
   end;
   end;

procedure TDefineFunc.MakeVisible(TheRow: LongInt);
var
   TR: LongInt;
begin
   try
   with DefFuncs do begin
//    {$IFDEF Debug}DebugForm.Debug('TxRepl32::GridStatus::TopRow:'+IntToStr(TopRow)+'::VisibleRowCount:'+IntToStr(VisibleRowCount)+'::Showing:'+IntToStr(TheRow));{$ENDIF}
      TR:=TheRow-TopRow;
      if TR<0 then begin
         TopRow:=TheRow;
         exit;
         end;
      if (TR<=VisibleRowCount - 1) then exit;
      TopRow:= TheRow - VisibleRowCount;
      while(CellRect(0,TheRow).Bottom = 0) do TopRow:=TopRow+1;
      TopRow:=TopRow + 1;
      end;
   except
   end;
   end;

end.
