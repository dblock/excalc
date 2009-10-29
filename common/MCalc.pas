(*                   MathCalc 32 Multithread Unit (Object Pascal)
                           (c) Daniel Doubrovkine
  Stolen Technologies Inc. - University of Geneva - 1996 - All Rights Reserved
            for Scientific Calculator, version revised on 04.02.97
*)

unit MCalc;

interface

uses Classes,TreeView,SysUtils,Dialogs,Math, WinProcs, Init, Registry, ceError, Forms,
     Graphics, Messages, Controls, ExtCtrls, d32debug;

function IntToHex(AnyLong: extended):string;
function IntToBin(AnyLong: extended):string;
function IntToOct(AnyLong: extended):string;

const
  MaxArraySize = (MaxInt div 2 div SizeOf(LongInt));
  KnownCount = 126;
  KnownFunctions  : array [0..KnownCount - 1] of string=('simpson','trapez','trapezoid','trapezoide','newton','boole',
                                             'ordersix','ordresix','weddle','int','gauss','fermat','tau',
                                             'sigma','elliptice','ellipticce','ellipticf','elliptick','ellipticck',
                                             'pochhammer','harmonic','binom','bth','perfect','parfait','mersgen',
                                             'genmers','mersenne','mersennegen','primec','prime','premier',
                                             'primen','sin','arcsin','sinh','arcsinh','cos',
                                             'arccos','cosh','arccosh','tan','arctan','tanh',
                                             'arctanh','cot','coth','arccot','arccoth','sec',
                                             'arcsec','sech','arcsech','csc','arccsc','csch',
                                             'arccsch','random','sqr','sqrt','floor','ceil',
                                             'ln','exp','logn','log','logten','trunc','round',
                                             'intg','abs','frac','not','eind','phi','max','min',
                                             'sum','som','mul','prod','average','moyenne','shl','shr','beta','gamma',
                                             'fib','lcm','ppcm','pgcd','gcd','pi','catalan','moebius','mu',
                                             'durschschnitt','safeprime','plot','zplot',
                                             //--- conversions
                                             'celstofahr','fahrtocels','galtol','ltoGal',
                                             'inchtocm','cmtoinch','lbtokg','kgtolb',
                                             //--- financial
                                             'db','sln','syd','cterm','term','pmt','rate',
                                             'pv','npv','fv','ddb','irate','nper','paymt',
                                             'fval','ipaymt','ppaymt','pval'
                                             );

type

  VariablesArray = array[0..255,0..1] of extended;
  IntRules = (Trapezoid, Simpson, Newton, Boole, OrderSix, Weddle, Nothing);

  PBoolArray=^TBoolArray;
  TBoolArray=array[1..MaxArraySize div 2] of boolean;
  PExtArray=^TExtArray;
  TExtArray=array[1..MaxArraySize div 2] of extended;
  PIntArray=^TIntArray;
  TIntArray=array[1..MaxArraySize div 2] of integer;

  TGraphForm = class(TForm)
      end;

  TCalcThread = class (TThread)
   protected
//------XPLOT
     XForm: TGraphForm;
     XImage: TImage;
     XCanvas: TCanvas;
     maxx, maxy: LongInt;
     xmin, xmax: real;
     ymin, ymax: real;
     zmin, zmax: real;
     iHead: PNode;
     d3v1, d3v2, PlotVariable: char;
     PlotVariableIndex: integer;
     V1index, V2index: integer;
     PlotArray: PExtArray;
     PlotBoolArray: PBoolArray;
     ResCount: LongInt;
     TotCount: LongInt;
     Ex,Ey     : extended; {grandissement}
     Xa,Ya     : integer;  {Coord. du centre}
     Ortho,Grid: boolean;  {Orthonormé,Grille}
     sStr: string;
//-----------
     CalcString    : string;
     VarTree       : VariablesArray;
     CalcTree      : PNode;
     CalcMode      : TCalcMode;
     CharRead      : char;
     CalcPos       : integer;
     ReadNode      : PNode;
     CalcNode      : PNode;
     CalcError     : Boolean;
     RaisedError   : string;
     ErrorPosition : integer;
     CalcResult    : extended;
     CalcStrResult : string;
     GridId        : LongInt;
     function      Known(const name: string): boolean;
//---------------------------- integrals
     function      fSum(ExpTree, Variable: PNode; a, b, N: extended;
                        fRule: IntRules): extended;
     function      Tegral(ExpTree, Variable: PNode; borne_a, borne_b, tolerance: extended): extended;
     function      fProtected(Variable: string): boolean;
//----------------------------
     procedure     Execute; override;
     procedure     ReadItem;
     procedure     AnalyseExpression(Expression:PNode);
     procedure     UpdateResult;
     procedure     PrimesAdd(PrimeToAdd: LongInt);
     function      Integral(Expr: string): extended;
     function      UserEval(expr, vars: string; var Expression: PNode): extended;
     function      GeneralPlot(var HeadExpression: PNode): extended;
     function      GeneralPlot3D(var Expression: PNode): extended;
//--- XPLOT
     procedure     XFormCreate;
     function      NewY(Y: extended): LongInt;
     function      NewX(X: extended): LongInt;
     function      NewYTrue(Y: extended): LongInt;
     function      NewXTrue(X: extended): LongInt;
     procedure     DrawLine(X1,Y1,X2,Y2: extended; xCol: TColor);

     procedure     DrawPoint(X,Y: extended; COLOR: TColor);
     procedure     DrawTruePoint(X,Y: extended; COLOR: TColor);
     procedure     DrawCadre;
     procedure     Calculate;
     procedure     Calculate3D;
     procedure     On3dXPaint(Sender: TObject);
     function      XPlotCreate(Expression, Variable: PNode; left, right: extended): extended;
     procedure     XPlotExecute;
     procedure     XPlot3dExecute;
     procedure     XStatus(xStr: string);
     procedure     XDraw;
     procedure     XMakeAxe(draw: boolean);
//--- XPLOT3D
     function      XPlot3DCreate(Expression, v1, v2: PNode; v1_a, v1_b, v2_a, v2_b: extended): extended;
//---------
   public
     function      Evaluation(Expression:PNode):extended;
     constructor   Create(CalculateString:string;ToCalcMode:TCalcMode;MyGridId:integer);
     end;

  PArray=^TArray;
  TArray=array[1..MaxArraySize] of PChar;

//---------------------------------------- user functions
  user_f = class
      function_names ,
      function_equiv ,
      function_vars  : PArray;
      items, fixed: LongInt;
      constructor init;
      procedure Clear;
      function AddFunction(name, equiv, vars: PChar): boolean;
      function RemoveFunction(name: PChar): boolean;
      function GetFunction(name: string; var expr, vars: string): boolean;
      procedure GetUserRegistry;
      procedure SetUserRegistry;
      procedure AddFullFunction(iName, iVal: string);
      end;

implementation

uses ScCalc;

   function IntToHex(AnyLong: extended):string;
   function SecIntToHex(AnyLong:extended):string;
      const
      HexArray: string='0123456789ABCDEF';
      begin
      if AnyLong<16 then SecIntToHex:=HexArray[Trunc(AnyLong)+1] else
      SecIntToHex:=SecIntToHex(Trunc(AnyLong/16))+SecIntToHex(AnyLong-Trunc(AnyLong/16)*16);
      end;
   var
      IntToHexString: string;
      Sign: integer;
   begin
        if AnyLong<0 then begin
           Sign:=-1;
           AnyLong:=-AnyLong;
           end else Sign:=1;
        IntToHexString:=SecIntToHex(AnyLong);
        while Length(IntToHexString) mod 2>0 do IntToHexString:='0'+IntToHexString;
        if Sign=-1 then IntToHex:='-'+IntToHexString else IntToHex:=IntToHexString;
   end;
   function IntToBin(AnyLong: extended):string;
   function SecIntToBin(AnyLong: extended):string;
      const
      BinArray: string='01';
      begin
      if AnyLong<2 then SecIntToBin:=BinArray[Trunc(AnyLong)+1] else begin
         SecIntToBin:=SecIntToBin(Trunc(AnyLong/2))+SecIntToBin(AnyLong-Trunc(AnyLong/2)*2);
      end;
      end;
   var
      IntToBinString: string;
   begin
        IntToBinString:=SecIntToBin(AnyLong);
        while Length(IntToBinString) mod 4>0 do IntToBinString:='0'+IntToBinString;
        IntToBin:=IntToBinString;
   end;
   function IntToOct(AnyLong: extended):string;
      const
         OctArray: string='01234567';
      var
         Sign: integer;
         SecIntToOct: string;
      begin
      if AnyLong<0 then begin
         Sign:=-1;
         AnyLong:=-AnyLong
         end else Sign:=1;
      if AnyLong<8 then SecIntToOct:=OctArray[Trunc(AnyLong)+1] else
      SecIntToOct:=IntToOct(Trunc(AnyLong/8))+IntToOct(AnyLong-Trunc(AnyLong/8)*8);
      if Sign=-1 then IntToOct:='-'+SecIntToOct else IntToOct:=SecIntToOct;
      end;

function TCalcThread.Known(const name: string): boolean;
var
   i: integer;
begin
   Result:=False;
   for i:=0 to KnownCount - 1 do if (CompareText(name, KnownFunctions[i]) = 0) then begin Result:=True; break; end;
   end;

constructor TCalcThread.Create(CalculateString:string;ToCalcMode:TCalcMode;MyGridId:integer);
var
   i: integer;
begin
   GridId:=MyGridId;
   FreeOnTerminate:=True;
   CalcString:=CalculateString;

   for i:=1 to 255 do begin
      VarTree[i,1]:=Calculator.VarArray[i,1];
      VarTree[i,0]:=Calculator.VarArray[i,0];
      end;

   CalcMode:=ToCalcMode;
   CalcError:=False;
   CharRead:=' ';
   ErrorPosition:=0;
   inherited Create(False);
   end;

procedure TCalcThread.PrimesAdd(PrimeToAdd: LongInt);
begin
   {MessageDlg('Adding '+IntToStr(PrimeToAdd),mtInformation,[mbOk],0);}
   Calculator.CurrentPrime:=PrimeToAdd;
   ReAllocMem(Calculator.AllPrimes,(Calculator.PrimesCount+2)*SizeOf(LongInt));
   Calculator.AllPrimes^[Calculator.PrimesCount]:=PrimeToAdd;
   Calculator.AllPrimes^[Calculator.PrimesCount+1]:=0;
   inc(Calculator.PrimesCount);
   end;

procedure TCalcThread.Execute;
begin
   try
   {latency for initialization...this is to avoid NT multithread concurrence bug!!!}
   while GridId=0 do ;
   while Handle=0 do ;
   Calculator.CalcGrid.Cells[3,GridId-1]:=IntToStr(Handle);
   New(CalcTree,Create(NodeSingle,'Calculating Tree:'));
   New(ReadNode,Create(NodeSingle,'_'));
   CalcNode:=CalcTree^.AddChild(NodeSingle,'Extended Calculator');
   CalcNode:=CalcNode^.AddChild(NodeSingle,'(c) Daniel Doubrovkine');
   CalcNode^.AddChild(NodeSingle,'University of Geneva - 1996');
   CalcNode:=CalcNode^.AddChild(NodeValue,'0');
   CalcPos:=1;
   if CalcError=true then begin
      Synchronize(UpdateResult);
      exit;
      end;
   ReadItem;
   if CalcError=true then begin
      Synchronize(UpdateResult);
      exit;
      end;
   AnalyseExpression(CalcNode);
//   CalcNode^.Show;
   if CalcError=true then begin
      Synchronize(UpdateResult);
      exit;
      end;
   if (ReadNode.NodeType<>NodeOperator) or
      (ReadNode.NodeContents.MyOperator <> '$') then begin
      RaisedError:=
        {$ifDEF English}'missing operator';{$ENDIF}
        {$IFDEF French} 'opérateur manquant';{$ENDIF}
        {$IFDEF German} 'Operator fehlt';{$ENDIF}
      CalcError:=true;
      ErrorPosition:=CalcPos;
      end;
   if not CalcError then begin
      CalcResult:=Evaluation(CalcNode);
      if CalcError=False then begin
         Str(CalcResult, CalcStrResult);
         if (CalcStrResult='-0.0000000000') or
            (CalcStrResult='0.00000000000') then begin
            CalcResult:=0;
            CalcStrResult:='0.00';
            end;
         end;
       end;
   Synchronize(UpdateResult);
   exit;
   except
      CalcError:=True;
      RaisedError:=ceUnexpected;
      ErrorPosition:=0;
      Synchronize(UpdateResult);
      exit;
      end;
   end;

procedure TCalcThread.UpdateResult;
var
   ToString:string;
   i,j,k: integer;
begin
   Calculator.LastResultMode:=CalcMode;
   Calculator.LastResult:=CalcResult;

   Calculator.ResultsAdd(CalcResult, GridId div 2);

      if CalcError=False then begin
         try
            ToString:='';
            if CalcMode=Bin then begin                                          {$ifdef Debug} DebugForm.Debug('MCalc::Binary result.'); {$endif}
               if (CalcResult>=0) and (Trunc(CalcResult)=CalcResult) then
                  ToString:=IntToBin(trunc(CalcResult))
                  else begin
                  ToString:='- E -';
                  CalcStrResult:='non integer or negative result';                          {$ifdef Debug} DebugForm.Debug('ToString: '+ToString+' CalcStrResult: '+CalcStrResult); {$endif}
                  end;
                  end else
               if CalcMode=Oct then begin                                       {$ifdef Debug} DebugForm.Debug('MCalc::Octal result'); {$endif}
                  if {(CalcResult<>0) and }(Trunc(CalcResult)=CalcResult) then
                  ToString:=IntToOct(trunc(CalcResult))
                  else begin
                  ToString:='- E -';
                  CalcStrResult:='non integer result';                          {$ifdef Debug} DebugForm.Debug('ToString: '+ToString+' CalcStrResult: '+CalcStrResult); {$endif}
                  end;
                  end else
               if CalcMode=Hex then begin                                       {$ifdef Debug} DebugForm.Debug('MCalc::Hex result'); {$endif}
                  if {(CalcResult>=0) and }(Trunc(CalcResult)=CalcResult) then
                  ToString:=IntToHex(trunc(CalcResult))
                  else begin
                  ToString:='- E -';
                  CalcStrResult:='non integer result';                          {$ifdef Debug} DebugForm.Debug('ToString: '+ToString+' CalcStrResult: '+CalcStrResult); {$endif}
                  end;
            end else begin
            CalcStrResult:=Trim(CalcStrResult);                                 {$ifdef Debug} DebugForm.Debug('ToString: '+ToString+' CalcStrResult: '+CalcStrResult); {$endif}
            for i:=1 to Length(CalcStrResult) do if CalcStrResult[i]='E' then break;
                if i<Length(CalcStrResult) then
                   CalcStrResult:=Trim(Copy(CalcStrResult,1,i-1)+'e'+Copy(CalcStrResult,i+1,Length(CalcStrResult)));
                Str(CalcResult:0:2,ToString);                                   {$ifdef Debug} DebugForm.Debug('ToString: '+ToString+' CalcStrResult: '+CalcStrResult); {$endif}
                ToString:=Trim(ToString);
                for i:=1 to Length(ToString) do if ToString[i]='E' then begin
                    ToString:=CalcStrResult;
                    break;
                    end;                                                        {$ifdef Debug} DebugForm.Debug('ToString: '+ToString+' CalcStrResult: '+CalcStrResult); {$endif}
               end;
          except
          ToString:='N/A';                                                      {$ifdef Debug} DebugForm.Debug('ToString: '+ToString+' CalcStrResult: '+CalcStrResult); {$endif}
          end;

         CalcStrResult:=Trim(CalcStrResult);                                    {$ifdef Debug} DebugForm.Debug('ToString: '+ToString+' CalcStrResult: '+CalcStrResult); {$endif}
         for i:=1 to Length(CalcStrResult) do if CalcStrResult[i]='E' then break;
            if i<Length(CalcStrResult) then CalcStrResult:=Trim(Copy(CalcStrResult,1,i-1)+'e'+Copy(CalcStrResult,i+1,Length(CalcStrResult)));

         {decimal precision}
         if ToString='-0.00' then begin
            ToString:='0.00';                                                   {$ifdef Debug} DebugForm.Debug('ToString: '+ToString+' CalcStrResult: '+CalcStrResult); {$endif}
            for i:=1 to Length(CalcStrResult) do if CalcStrResult[i]='e' then break;
            j:=0;
            if i<Length(CalcStrResult) then Val(Copy(CalcStrResult,i+1,Length(CalcStrResult)),j,k);
            if j<-10 then CalcStrResult:='0.00000000000000e+0000';
            CalcResult:=0;
            end;

         Calculator.LastStrResult:=CalcStrResult;
         Calculator.CalcLabel.Caption:=ToString;
         Calculator.CalcLabelFull.Caption:=CalcStrResult;
         if (ToString<>'- E -') and
            (ToString<>'N/A') and
            not((ToString='0.00') and (CalcResult>0)) and (ToString<>CalcStrResult) then
            Calculator.CalcGrid.Cells[1,GridId]:=ToString+' ('+CalcStrResult+')'
            else Calculator.CalcGrid.Cells[1,GridId]:=CalcStrResult;
         Calculator.UpdateCalcGrid;
         Calculator.ConvertLastOperation(CurrentMode);
         end
         else begin
         if ErrorPosition<>0 then begin
         {MessageDlg('ERROR: '+ToCalculate.RaisedError+' at position '+IntToStr(ToCalculate.ErrorPosition-1),mtError,[mbOk],0);}
         Calculator.CalcLabel.Caption:='- E -';
         Calculator.CalcLabelFull.Caption:=RaisedError+' ('+IntToStr(ErrorPosition-1)+')';
         Calculator.CalcGrid.Cells[1,GridId]:=RaisedError+' ('+IntToStr(ErrorPosition-1)+')';
         SysUtils.Beep;
         end
         else begin
         {MessageDlg('ERROR: '+ToCalculate.RaisedError+'.',mtError,[mbOk],0);}
         Calculator.CalcLabel.Caption:='- E -';
         Calculator.CalcLabelFull.Caption:=RaisedError;
         Calculator.CalcGrid.Cells[1,GridId]:=RaisedError;
         SysUtils.Beep;
         end;
      end;
   Calculator.CalcGrid.Cells[3,GridId-1]:='ok';
   dec(Calculator.EvalExpressions);
   Calculator.OpsBar.Position:=Calculator.EvalExpressions * 10;
   Synchronize(Calculator.UpdateExpressions);
   end;

procedure TCalcThread.ReadItem;
   procedure ReadCh; {gets the next char}
   begin
      if CalcPos>Length(CalcString) then
         CharRead := '$'
      else begin
         CharRead:=CalcString[CalcPos];
         inc(CalcPos);
         end; {else}
      end; {ReadCh}
   function ReadOctNumber:extended;
   var
      MyNumber:extended;
   begin
      try
      MyNumber:=0;
      while CharRead in ['0'..'7'] do begin
            MyNumber := MyNumber * 8 + (ord(CharRead)-ord('0'));
            ReadCh;
            end;{while}
      ReadOctNumber:=MyNumber;
      except
         CalcError:=true;
         RaisedError :=ceEIntOverFlow + ' (oct)';
         ErrorPosition:= CalcPos;
         ReadOctNumber:=0;
         exit;
      end;
      end;
   function ReadBinNumber:extended;
   var
      MyNumber:extended;
   begin
      try
      MyNumber:=0;
      while CharRead in ['0'..'1'] do begin
        MyNumber := MyNumber * 2 + (ord(CharRead)-ord('0'));
        ReadCh;
      end;{while}
      ReadBinNumber:=MyNumber;
      except
         CalcError:=true;
         RaisedError :=ceEIntOverFlow + ' (bin)';
         ErrorPosition:= CalcPos;
         ReadBinNumber:=0;
         exit;
      end;
      end;
   function ReadHexNumber:extended;
   var
      MyNumber:extended;
   begin
      try
      MyNumber:=0;
      while CharRead in ['0'..'9','A'..'F'] do begin
         if CharRead in ['0'..'9'] then
            MyNumber := MyNumber * 16 + (ord(CharRead)-ord('0'))
            else
            MyNumber := MyNumber * 16 + (ord(CharRead)-ord('A')+10);
         ReadCh;
      end;{while}
      ReadHExNumber:=MyNumber;
      except
         CalcError:=true;
         RaisedError :=ceEIntOverFlow + ' (hexa)';
         ErrorPosition:= CalcPos;
         ReadHexNumber:=0;
         exit;
      end;
      end;{ReadNumber}
   {check variable table for a variable, returns a pointer if node found}
   function ReadNumber:extended;
   var
      MyNumber:extended;
      dCounter:extended;
   begin
      try
      MyNumber:=0;
      while CharRead in ['0'..'9'] do begin
         MyNumber := MyNumber * 10 + (ord(CharRead)-ord('0'));
         ReadCh;
      end;{while}
      dCounter:=1;
      if (CharRead='.') then begin
         ReadCh;
         while CharRead in ['0'..'9'] do begin
            MyNumber:=MyNumber*10 + (ord(CharRead)-ord('0'));
            DCounter:=DCounter*10;
            ReadCh;
            end;{while}
         end;{if}
      MyNumber:=MyNumber/DCounter;
      ReadNumber:=MyNumber;
      except
         CalcError:=true;
         RaisedError :=ceEIntOverFlow + ' (dec)';
         ErrorPosition:= CalcPos;
         ReadNumber:=0;
         exit;
      end;
      end;{ReadNumber}

{check variable table for a variable, returns a pointer if node found}
 procedure ReadNotDecimal;
   var {ReadItem}
   SymbolProc:string;
 begin
   {if (Calculator.InterruptRequest=true) or (Calculator.IdInterruptRequest=GridId) then exit;}
   if CalcError=true then exit;
   while CharRead=' ' do ReadCh;
   with ReadNode^ do begin
      case CharRead of
         '0'..'9','A'..'F' : begin
         {read an unsigned integer}
                       NodeType:=NodeValue;
                       if (CalcMode=hex) then NodeContents^.MyValue:=ReadHexNumber;
                       if (CalcMode=bin) then NodeContents^.MyValue:=ReadBinNumber;
                       if (CalcMode=oct) then NodeContents^.MyValue:=ReadOctNumber;
                       end;{'0'..'9'}
         'S','H','L','R','a'..'z' : begin
                       SymbolProc:='';
                              while CharRead in ['S','H','L','R','a'..'z'] do begin
                                    SymbolProc:=SymbolProc+CharRead;
                                    ReadCh;
                                    end;{while}
                                 if (CompareText(SymbolProc,'or')=0) or
                                    (CompareText(SymbolProc,'and')=0) or
                                    (CompareText(SymbolProc,'xor')=0) or
                                    (CompareText(SymbolProc,'nor')=0) or
                                    (CompareText(SymbolProc,'xnor')=0) or
                                    (CompareText(SymbolProc,'nand')=0) then begin
                                     CalcPos:=CalcPos-1;
                                     NodeType:=NodeOperator;
                                     NodeContents^.MyOperator:=SymbolProc;
                                     ReadCh;
                                 end else begin
                                     NodeType:=NodeSingle;
                                     NodeContents^.MySingle:=SymbolProc;
                                     end;{else begin}

                                 end;{'A'..'z'}
         '(': begin
                 NodeType:=NodeOperator;
                 NodeContents^.MyOperator:=CharRead;
                 Readch;
              end;
         '+','-','*','/','^','%',',','=','?','<','>': begin
                 NodeType:=NodeOperator;
                 NodeContents^.MyOperator:=CharRead;
                 ReadCh;
                 end;
         '!',')','$' : begin
                 NodeType:=NodeOperator;
                 NodeContents^.MyOperator:=CharRead;
                 ReadCh;
                 end;
         else begin {else case}
                 CalcError:=true;
                 RaisedError:=
                         {$ifDEF English}'invalid character: ' + CharRead;{$ENDIF}
                         {$IFDEF French} 'caractère invalide: ' + CharRead;{$ENDIF}
                         {$IFDEF German} 'ungültige Zeichen' + CharRead;{$ENDIF}
                 ErrorPosition:= CalcPos;
                 NodeType:=NodeOperator;
                 NodeContents^.MyOperator:='$';
                 end;{else}
         end;{case}
      end;{with}
   end;
 procedure ReadDegRad;
   var {ReadItem}
   SymbolProc:string;
 begin {ReadDegRad}
   if CalcError=true then exit;
   while CharRead=' ' do ReadCh;
   with ReadNode^ do begin
      case CharRead of
         '.','0'..'9' : begin
         {read an unsigned integer}
                       NodeType:=NodeValue;
                       NodeContents^.MyValue:=ReadNumber;
                       end;{'0'..'9'}
         'A'..'Z', 'a'..'z' : begin
                                 SymbolProc:='';
                                 while CharRead in ['A'..'Z','a'..'z'] do begin
                                       SymbolProc:=SymbolProc+CharRead;
                                       ReadCh;
                                       end;{while}
                                 if (CompareText(SymbolProc,'or')=0) or
                                    (CompareText(SymbolProc,'and')=0) or
                                    (CompareText(SymbolProc,'xor')=0) or
                                    (CompareText(SymbolProc,'nor')=0) or
                                    (CompareText(SymbolProc,'xnor')=0) or
                                    (CompareText(SymbolProc,'nand')=0) or
                                    (SymbolProc='\') or
                                    (SymbolProc='m') or
                                    (SymbolProc='e') then begin
                                     CalcPos:=CalcPos-1;
                                     NodeType:=NodeOperator;
                                     NodeContents^.MyOperator:=SymbolProc;
                                     ReadCh;
                                 end else
                                 if (Length(SymbolProc)=1) then begin
                                     NodeType:=NodeVariable;
                                     NodeContents^.MyVariable := SymbolProc;
                                     end{<>'E'}
                                 else begin
                                         if CompareText(SymbolProc,'pi')=0 then begin
                                             NodeType:=NodeValue;
                                             NodeContents^.MyValue:=Pi;
                                             end
                                         else if CompareText(SymbolProc,'catalan')=0 then begin
                                             NodeType:=NodeValue;
                                             NodeContents^.MyValue:=0.9159655941772190150546035149323841107741493742816721342664981196217630197762547694793565129261151062;
                                             end else begin
                                                NodeType:=NodeSingle;
                                                NodeContents^.MySingle:=SymbolProc;
                                             end;
                                         end;{else begin}
                                 end;{'A'..'z'}
         '(': begin
                 NodeType:=NodeOperator;
                 NodeContents^.MyOperator:=CharRead;
                 Readch;
              end;
         '+','-','*','/','^','¦','|','%','\','=','?','<','>': begin
                 NodeType:=NodeOperator;
                 NodeContents^.MyOperator:=CharRead;
                 ReadCh;
                 end;
         ',': begin
                 NodeType:=NodeOperator;
                 NodeContents^.MyOperator:=CharRead;
                 ReadCh;
              end;
         '!',')','$' : begin
                 NodeType:=NodeOperator;
                 NodeContents^.MyOperator:=CharRead;
                 ReadCh;
                 end;
         else begin {else case}
                  CalcError:=true;
                 RaisedError:=
                         {$ifDEF English}'invalid character: '+CharRead;{$ENDIF}
                         {$IFDEF French} 'caractère invalide: '+CharRead;{$ENDIF}
                         {$IFDEF German} 'ungültige Zeichen'+CharRead;{$ENDIF}
                 ErrorPosition:= CalcPos;
                 NodeType:=NodeOperator;
                 NodeContents^.MyOperator:='$';
                 end;{else}
         end;{case}
      end;{with}
      end;
   begin {ReadItem}
      if (CalcMode<>Deg) and (CalcMode<>Rad) then ReadNotDecimal else ReadDegRad;
   end;{ReadItem}

procedure TCalcThread.AnalyseExpression(Expression:PNode);
  procedure Term(Expression:PNode);
   procedure Percentage(Expression:PNode);
    procedure AnyRoot(Expression:PNode);
     procedure Power(Expression:PNode);
      procedure TenPower(Expression:PNode);
       procedure Factor(Expression:PNode);
        procedure Operator(Expression:PNode);
         function ct(MyCompareText:string):boolean;
         begin
           if (CompareText(Expression^.Contents,MyCompareText)=0)
           or (CompareText(Expression^.Contents,'-'+MyCompareText)=0) then ct:=true else ct:=false;
           end;
          var
             ParamCount:integer;
             ParamRead: integer;
             expr, vars: string;
             NoParam: boolean;
          begin
             NoParam:=False;
             if (ReadNode^.NodeType=NodeSingle) then begin
                 ParamCount:=0;
                 Expression^.NodeType:=NodeSingle;
                 Expression^.NodeContents^.MySingle:=ReadNode^.NodeContents^.MySingle;

                 if (Calculator.User_Functions.GetFunction(Expression^.Contents, expr, vars)) then begin
                    ParamCount:=Length(vars)-1;
                    if ParamCount < 0 then NoParam:=True;
                    end else
                 if not Known(Expression^.Contents) then begin
                    CalcError:=True;
                    RaisedError:=
                          {$ifDEF English}'unknown function: '{$ENDIF}
                          {$IFDEF French} 'fonction inconnue: '{$ENDIF}
                          {$IFDEF German} 'unbekannte Funktion: '{$ENDIF}
                          + Expression^.Contents;
                    ErrorPosition:=CalcPos;
                    exit;
                    end;

                 if ct('binom') then ParamCount:=1 else
                 if ct('bth') then ParamCount:=2 else
                 if ct('logn') then ParamCount:=1 else
                 if ct('sum') then ParamCount:=-1 else
                 if ct('som') then ParamCount:=-1 else
                 if ct('mul') then ParamCount:=-1 else
                 if ct('prod') then ParamCount:=-1 else
                 if ct('max') then ParamCount:=-1 else
                 if ct('min') then ParamCount:=-1 else
                 if ct('shr') then ParamCount:=1 else
                 if ct('shl') then ParamCount:=1 else
                 if ct('gcd') then ParamCount:=-1 else
                 if ct('pgcd') then ParamCount:=-1 else
                 if ct('gamma') then ParamCount:=1 else
                 if ct('beta') then ParamCount:=-2 else
                 if ct('lcm') then ParamCount:=-1 else
                 if ct('ppcm') then ParamCount:=-1 else
                 if ct('average') then ParamCount:=-1 else
                 if ct('durchschnitt') then ParamCount:=-1 else
                 if ct('moyenne') then ParamCount:=-1 else
                 if ct('elliptice') then ParamCount:=-1 else
                 if ct('ellipticf') then ParamCount:=-1 else
                 if ct('pochhammer') then ParamCount:=1 else
                 if ct('plot') then ParamCount:=-4 else
                 if ct('zplot') then ParamCount:=6 else
                 if ct('sigma') then ParamCount:=1 else
                 //--- financial block
                 if ct('ddb') then ParamCount:=-4 else
                 if ct('db') then ParamCount:=-4 else
                 if ct('fv') then ParamCount:=2 else
                 if ct('fv') then ParamCount:=2 else
                 if ct('syd') then ParamCount:=3 else
                 if ct('cterm') then ParamCount:=2 else
                 if ct('term') then ParamCount:=2 else
                 if ct('pmt') then ParamCount:=2 else
                 if ct('rate') then ParamCount:=2 else
                 if ct('irate') then ParamCount:=4 else
                 if ct('pv') then ParamCount:=2 else
                 if ct('npv') then ParamCount:=-2 else
                 if ct('nper') then ParamCount:=4 else
                 if ct('paymt') then ParamCount:=4 else
                 if ct('fval') then ParamCount:=4 else
                 if ct('ipaymt') then ParamCount:=5 else
                 if ct('ppaymt') then ParamCount:=5 else
                 if ct('pval') then ParamCount:=4 else
                 //---
                 if ct('simpson') or ct('newton') or ct('trapez') or
                    ct('boole') or ct('ordersix') or ct('weddle') or
                    ct('int') or ct('trapezoid') or ct('gauss') or
                    ct('trapezoide') or ct('ordresix') then
                    ParamCount:=-4;

                 ReadItem;
                 if CalcError=true then exit;

            if (ParamCount<>0) and (not NoParam) then
               if (ReadNode^.NodeType<>NodeOperator) or
                  (ReadNode^.NodeContents^.MyOperator<>'(') then begin
                     CalcError:=True;
                     RaisedError:=
                          {$ifDEF English}'function requires "("';{$ENDIF}
                          {$IFDEF French}'fonction requière "("';{$ENDIF}
                          {$IFDEF German}'Funktion erfordet "("';{$ENDIF}

                     ErrorPosition:=CalcPos;
                     exit;
                   end;

          if not NoParam then begin {?*-}
               ReadItem;
               if CalcError=true then exit;
               AnalyseExpression(Expression^.AddChild(NodeValue,'0'));

               ParamRead:=1;
               if ParamCount<0 then begin
                  while (ReadNode^.NodeType=NodeOperator) and
                        (ReadNode^.NodeContents^.MyOperator=',') {and
                        (ParamRead<255)} do begin
                         ReadItem;
                         inc(ParamRead);
                         AnalyseExpression(Expression^.Addchild(NodeValue,'0'));
                         if CalcError=true then exit;
                         if (ParamRead = 3) then
                             if ct('elliptice') or
                                ct('ellipticf') or
                                ct('beta') then break;
                         end;
                  if abs(ParamRead)<abs(ParamCount) then begin
                     CalcError:=True;
                     RaisedError:=
                          {$ifDEF English}'insuff. parameters for '{$ENDIF}
                          {$IFDEF French}'paramètres insuff. pour '{$ENDIF}
                          {$IFDEF German}'ungenügende Argumenten für '{$ENDIF}
                                  + Expression^.Contents;
                     ErrorPosition:=CalcPos;
                     exit;
                     end;
                  end;

               while ParamCount>0 do begin
                 if (ReadNode^.NodeType<>NodeOperator) or
                    (ReadNode^.NodeContents^.MyOperator<>',') then begin
                     CalcError:=True;
                     RaisedError:=
                          {$ifDEF English}'insuff. parameters for '{$ENDIF}
                          {$IFDEF French}'paramètres insuff. pour '{$ENDIF}
                          {$IFDEF German}'ungenügende Argumenten für '{$ENDIF}
                                  + Expression^.Contents;
                     ErrorPosition:=CalcPos;
                     exit;
                     end;
                 ReadItem;
                 AnalyseExpression(Expression^.Addchild(NodeValue,'0'));
                 ParamCount:=ParamCount-1;
                 if CalcError=true then exit;
                 end;

               if (ParamRead <> 0) then
               if (ReadNode^.NodeType<>NodeOperator) or
                  (ReadNode^.NodeContents^.MyOperator<>')') then begin
                     CalcError:=True;
                     RaisedError:=Expression^.Contents+
                          {$ifDEF English}': error in parameters';{$ENDIF}
                          {$IFDEF French}': erreur dans les paramètres';{$ENDIF}
                          {$IFDEF German}'Fehler in Argumenten';{$ENDIF}
                     ErrorPosition:=CalcPos;
                     exit;
                   end;{')'}

               //integrals ----------------------------------------------------------------
               if ct('simpson') or ct('newton') or ct('trapez') or
                  ct('boole') or ct('ordersix') or ct('weddle') or
                  ct('trapezoid') or ct('trapezoide') or ct('ordresix') then
                  if (ParamRead = 4) then
                  Expression^.Addchild(NodeValue,'2048')
                  else
                  if ((Expression^.Child(4)^.NodeContents^.MyValue) < 1) or
                   (Trunc(Expression^.Child(4)^.NodeContents^.MyValue)<>
                   (Expression^.Child(4)^.NodeContents^.MyValue)) then begin
                    CalcError:=True;
                    RaisedError:=
                          {$ifDEF English}'invalid integral step';{$ENDIF}
                          {$IFDEF French}'pas d''intégration invalide';{$ENDIF}
                          {$IFDEF German}'ungültige Integration Schritt';{$ENDIF}
                    ErrorPosition:=CalcPos;
                    exit;
                    end;

               if ct('int') or ct('gauss') then
                  if (ParamRead = 4) then Expression^.Addchild(NodeValue,'0')
                  else if ((Expression^.Child(4)^.NodeContents^.MyValue) < 0) then begin
                    CalcError:=True;
                    RaisedError:=
                          {$ifDEF English}'invalid integral tolerance';{$ENDIF}
                          {$IFDEF French}'tolérance d''intégration invalide';{$ENDIF}
                          {$IFDEF German}'ungültige Integration Toleranz';{$ENDIF}
                    ErrorPosition:=CalcPos;
                    exit;
                    end;

               //integrals ----------------------------------------------------------------
                ReadItem;
                if CalcError=true then exit;
                end; {?*- constant functions definitions}

                end {NodeSingle} else
            if (ReadNode^.NodeType=NodeValue) then begin
                Expression^.NodeType:=NodeValue;
                Expression^.NodeContents^.MyValue:=ReadNode^.NodeContents^.MyValue;
                ReadItem;
                if CalcError=true then exit;
                end{NodeValue} else
            if (ReadNode^.NodeType=NodeVariable) then begin
                Expression^.NodeType:=NodeVariable;
                Expression^.NodeContents^.MyVariable:=ReadNode^.NodeContents^.MyVariable;
                ReadItem;
                if CalcError=true then exit;
                end {variable} else

                //under heavy testing
            if (ReadNode^.NodeType=NodeOperator) and
               ((ReadNode^.NodeContents^.MyOperator='-') or
                (ReadNode^.NodeContents^.MyOperator='+')) then begin
                Expression^.NodeType:=NodeOperator;
                Expression^.NodeContents^.MyOperator:=ReadNode^.NodeContents^.MyOperator;
                Expression^.AddChild(NodeValue, '0');
                Expression^.AddChild(NodeValue, '0');
                ReadItem;
                Percentage(Expression^.Child(1));
                end else
            if (ReadNode^.NodeType=NodeOperator) and
               (ReadNode^.NodeContents^.MyOperator='(') then begin

                ReadItem;

                if CalcError=true then exit;
                if Expression^.Parent^.Child(1)=nil then
                AnalyseExpression(Expression^.Parent^.Child(0)) else
                AnalyseExpression(Expression^.Parent^.Child(1));
                if (ReadNode^.NodeType<>NodeOperator) or
                   (ReadNode^.NodeContents^.MyOperator<>')') then begin
                     CalcError:=True;
                     RaisedError:=
                          {$ifDEF English}'")" expected';{$ENDIF}
                          {$IFDEF French}'")" attendu';{$ENDIF}
                          {$IFDEF German}'")" erwartet';{$ENDIF}
                     ErrorPosition:=CalcPos;
                     exit;
                    end;{')'}
                ReadItem;
                if CalcError=true then exit;
                end {'('}
            else begin
                     CalcError:=True;
                     RaisedError:=
                          {$ifDEF English}'unexpected symbol';{$ENDIF}
                          {$IFDEF French}'symbole inattendu';{$ENDIF}
                          {$IFDEF German}'unerwartete Symbol';{$ENDIF}
                     ErrorPosition:=CalcPos;
                     exit;
                 end; {else}
            end;{Operator}
        begin {Factor}
           Operator(Expression);
           if CalcError=true then exit;
           while (ReadNode^.NodeType=NodeOperator) and
                 (ReadNode^.NodeContents^.MyOperator='!') do begin
                  Expression:=Expression^.InsertLevel(ReadNode);
                  ReadNode^.NodeType:=NodeValue;
                  ReadNode^.NodeContents^.MyValue:=1;
                  Operator(Expression^.Parent^.Child(1));
                  if CalcError=true then exit;
                  Expression:=Expression^.Parent;
                  end;{while}
           end; {Factor}
      begin {TenPower}
         Factor(Expression);
         if CalcError=true then exit;
         while (ReadNode^.NodeType=NodeOperator) and
               (ReadNode^.NodeContents^.MyOperator='e') do begin
                ReadNode^.NodeContents^.MyOperator:='*';
                Expression:=Expression^.InsertLevel(ReadNode);
                Expression^.NodeType:=NodeOperator;
                Expression^.NodeContents^.MyOperator:='^';
                Expression^.AddChild(NodeValue,'10');
                Expression:=Expression^.AddChild(NodeValue,'0');
                ReadNode^.NodeType:=NodeValue;
                ReadNode^.NodeContents^.MyValue:=0;
                ReadItem;
                Factor(Expression^.Parent^.Child(1));
                if CalcError=true then exit;
                Expression:=Expression^.Parent;
                end;{while}
        end;{TenPower}
      begin {Power}
         TenPower(Expression);
         if CalcError=true then exit;
         while (ReadNode^.NodeType=NodeOperator) and
               (ReadNode^.NodeContents^.MyOperator='^') do begin
                Expression:=Expression^.InsertLevel(ReadNode);
                ReadItem;
                TenPower(Expression^.Parent^.Child(1));
                if CalcError=true then exit;
                Expression:=Expression^.Parent;
                end;{while}
         end;{Power}
      begin{AnyRoot}
         Power(Expression);
         if CalcError=true then exit;
         while(ReadNode^.NodeType=NodeOperator) and
              (ReadNode^.NodeContents^.MyOperator='\') do begin
              Expression:=Expression^.InsertLevel(ReadNode);
              ReadItem;
              Power(Expression^.Parent^.Child(1));
              if CalcError=true then exit;
              Expression:=Expression^.Parent;
              end;
         end;{AnyRoot}
   begin {Percentage}
        AnyRoot(Expression);
        if CalcError=true then exit;
        while (ReadNode^.NodeType=NodeOperator) and
              (ReadNode^.NodeContents^.MyOperator='%') do begin
               Expression:=Expression^.InsertLevel(ReadNode);
               ReadItem;
               AnyRoot(Expression^.Parent^.Child(1));
               if CalcError=true then exit;
               Expression:=Expression^.Parent;
               end;{while}
        end;{Percentage}
   begin {Term}
      Percentage(Expression);
      if CalcError=true then exit;
      //omitting the multiply sign
      if (ReadNode^.NodeType=NodeVariable) then begin
         Expression:=Expression^.InsertLevel(ReadNode);
         Expression^.Parent^.NodeType:=NodeOperator;
         Expression^.Parent^.NodeContents^.MyOperator:='*';
         Term(Expression);
      end else
      if (ReadNode^.NodeType=NodeOperator) and
         (ReadNode^.NodeContents^.MyOperator='(') then begin
                ReadNode^.NodeContents^.MyOperator:='*';
                Expression:=Expression^.InsertLevel(ReadNode);
                ReadItem;
                if CalcError=true then exit;
                if Expression^.Parent^.Child(1)=nil then
                AnalyseExpression(Expression^.Parent^.Child(0)) else
                AnalyseExpression(Expression^.Parent^.Child(1));
                if (ReadNode^.NodeType<>NodeOperator) or
                   (ReadNode^.NodeContents^.MyOperator<>')') then begin
                     CalcError:=True;
                     RaisedError:=
                          {$ifDEF English}'")" expected';{$ENDIF}
                          {$IFDEF French}'")" attendu';{$ENDIF}
                          {$IFDEF German}'")" erwartet';{$ENDIF}
                     ErrorPosition:=CalcPos;
                     exit;
                    end;{')'}
                ReadItem;
                if CalcError=true then exit;
                end {'('} else
      while (ReadNode^.NodeType=NodeOperator) and
            ((CompareText(ReadNode^.NodeContents^.MyOperator,'xor')=0) or
             (CompareText(ReadNode^.NodeContents^.MyOperator,'or')=0) or
             (CompareText(ReadNode^.NodeContents^.MyOperator,'and')=0) or
             (CompareText(ReadNode^.NodeContents^.MyOperator,'nor')=0) or
             (CompareText(ReadNode^.NodeContents^.MyOperator,'xnor')=0) or
             (CompareText(ReadNode^.NodeContents^.MyOperator,'nand')=0) or

             (ReadNode^.NodeContents^.MyOperator='z') or {xnor}
             (ReadNode^.NodeContents^.MyOperator='n') or {nor}
             (ReadNode^.NodeContents^.MyOperator='d') or {nand}
             (ReadNode^.NodeContents^.MyOperator='x') or {xor}
             (ReadNode^.NodeContents^.MyOperator='o') or {or}
             (ReadNode^.NodeContents^.MyOperator='a') or {and}

             (ReadNode^.NodeContents^.MyOperator='=') or
             (ReadNode^.NodeContents^.MyOperator='?') or
             (ReadNode^.NodeContents^.MyOperator='>') or
             (ReadNode^.NodeContents^.MyOperator='<') or
             (ReadNode^.NodeContents^.MyOperator='*') or
             (ReadNode^.NodeContents^.MyOperator='/') or
             (ReadNode^.NodeContents^.MyOperator='m') or
             (ReadNode^.NodeContents^.MyOperator='|') or
             (ReadNode^.NodeContents^.MyOperator='¦')) do begin
              Expression:=Expression^.InsertLevel(ReadNode);
              ReadItem;
              Percentage(Expression^.Parent^.Child(1));
              if CalcError=true then exit;
              Expression:=Expression^.Parent;
              end;{while}
      end; {Term}
  begin {Expression}
     Term(Expression);
     if CalcError=true then exit;
     while (ReadNode^.NodeType=NodeOperator) and
           ((ReadNode^.NodeContents^.MyOperator='+') or
            (ReadNode^.NodeContents^.MyOperator='-')) do begin
             Expression:=Expression^.InsertLevel(ReadNode);
             ReadItem;
             Term(Expression^.Parent^.Child(1));
             if CalcError=true then exit;
             Expression:=Expression^.Parent;
             end;{while}
     end; {Expression}

function TCalcThread.Evaluation(Expression:PNode):extended;
   type
      MArray=array[0..7] of LongInt;
      PArray=array[0..4] of LongInt;
   const
      mersennePArray:MArray=(2,3,5,7,13,17,19,31);
      mersenneArray:MArray=(3,7,31,127,8191,131071,524287,2147483647);
      PerfectArray:PArray=(6,28,496,8128,33550336);

{------- returns the closest inferiour perfect number ----------}
function Perfect(n:extended): extended;
var
      i:integer;
   begin
      if (n<6) or (n>Power(2,32)) then begin
         RaisedError:=
            {$ifDEF English}'invalid bounds (perfect)';{$ENDIF}
            {$IFDEF French}'bornes invalides (parfait)';{$ENDIF}
            {$IFDEF German}'ungültige Grenzen (perfekt)';{$ENDIF}
         CalcError:=true;
         ErrorPosition:=0;
         Perfect:=0;
         exit;
         end;
      for i:=4 downto 0 do begin
          if n>=PerfectArray[i] then begin
             Perfect:=PerfectArray[i];
             exit;
             end;
         end;
         Perfect:=6;
      end;
   {------- returns the generator for a mersenne number ----------}
   function mersenneP(n: extended): extended;
   var
      i:integer;
   begin
      for i:=0 to 7 do begin
          if n=mersenneArray[i] then begin
             mersenneP:=mersennePArray[i];
             exit;
             end;
         end;
         RaisedError:=
            {$ifDEF English}'not a mersenne prime';{$ENDIF}
            {$IFDEF French}'pas un premier mersenne';{$ENDIF}
            {$IFDEF German}'kein mersenne Primfaktor';{$ENDIF}
         CalcError:=true;
         ErrorPosition:=0;
         mersenneP:=0;
      end;
   {-------- returns a mersenne number for a mersenne generator -----------}
   function Pmersenne(n: extended): extended;
   var
      i:integer;
   begin
      for i:=0 to 7 do begin
          if n=mersennePArray[i] then begin
             Pmersenne:=mersenneArray[i];
             exit;
             end;
         end;
         RaisedError:=
            {$ifDEF English}'not a mersenne generator';{$ENDIF}
            {$IFDEF French}'pas un générateur mersenne';{$ENDIF}
            {$IFDEF German}'kein mersenne Generator';{$ENDIF}
         CalcError:=true;
         ErrorPosition:=0;
         Pmersenne:=0;
      end;
   {------- returns the closest inferiour mersenne number known ---------------}
   function mersenneN(n: extended): extended;
   var
      i:integer;
   begin
      if (n<3) or (n>Power(2,32)) then begin
         RaisedError:=
            {$ifDEF English}'invalid bounds (mersenne)';{$ENDIF}
            {$IFDEF French}'bornes invalides (mersenne)';{$ENDIF}
            {$IFDEF German}'ungültige Grenzen (mersenne)';{$ENDIF}
         CalcError:=true;
         ErrorPosition:=0;
         mersenneN:=0;
         exit;
         end;
      for i:=7 downto 0 do begin
          if n>=mersenneArray[i] then begin
             mersenneN:=mersenneArray[i];
             exit;
             end;
         end;
         mersenneN:=3;
      end;
   {----------- returns the closest inferiour mersenne generator known ----------------}
   function mersenneG(n: extended): extended;
   var
      i:integer;
   begin
      if (n<2) or (n>32) then begin
         RaisedError:=
            {$ifDEF English}'invalid bounds (mersenne)';{$ENDIF}
            {$IFDEF French}'bornes invalides (mersenne)';{$ENDIF}
            {$IFDEF German}'ungültige Grenzen (mersenne)';{$ENDIF}
         CalcError:=true;
         ErrorPosition:=0;
         mersenneG:=0;
         exit;
         end;
      for i:=7 downto 0 do begin
          if n>=mersennePArray[i] then begin
             mersenneG:=mersennePArray[i];
             exit;
             end;
         end;
         mersenneG:=3;
      end;
   {- prime numbers ------- awesome multitasking routine threaded to the same table}
function MyPrime(n:extended):extended;
 procedure CalculateTPrime;
    var
      CurrentPrime: LongInt;
      CurrentCounter:LongInt;
      prime:boolean;
      number,max_div,divisor:longint;
      NextWillTerminate:boolean;
      LastShownPrime: LongInt;
    begin
      Calculator.PrimeTableUser:=Handle;
      Calculator.PrimeTableInUse:=True;
      NextWillTerminate:=False;
      CurrentPrime:=Calculator.AllPrimes^[Calculator.PrimesCount-1]+2;
      LastShownPrime:=CurrentPrime;
      Calculator.CalcGrid.Cells[1,GridId]:=sPrime + ' ' + IntToStr(CurrentPrime);
      for number:=Calculator.CurrentPrime to MaxInt do begin
         CurrentCounter:=2;
         max_div:=round(Sqrt(number)+0.5);
         divisor:=Calculator.AllPrimes^[CurrentCounter];
         prime:=number mod divisor <> 0;
         while prime and (divisor<=max_div) do begin
             prime:=number mod divisor <> 0;
             inc(CurrentCounter);
             divisor:=Calculator.AllPrimes[CurrentCounter];
             end;
        if prime then begin

        CurrentPrime:=number;

        if Calculator.AllPrimes^[Calculator.PrimesCount-1]<CurrentPrime then
           PrimesAdd(CurrentPrime);

        if (CurrentPrime-LastShownPrime>20000) then begin
           Calculator.CalcGrid.Cells[1,GridId]:=sPrime + ' ' +IntToStr(CurrentPrime);
           LastShownPrime:=CurrentPrime;
           end;
        if NextWillTerminate=true then begin
           Calculator.PrimeTableInUse:=False;
           exit;
           end;

        if number>n then NextWillTerminate:=True;
        end;

        end;

      end;

var
   sign: integer;
   i : longint;
   begin
      if (n>-1) and (n<1) then begin
         RaisedError:=ceDomain + ' (prime)';
         CalcError:=true;
         ErrorPosition:=0;
         MyPrime:=0;
         exit;
         end;
      if n>maxint then begin
         RaisedError:=ceEIntOverFlow + ' (prime)';
         CalcError:=true;
         ErrorPosition:=0;
         MyPrime:=0;
         exit;
         end;
      if n<0 then sign:=-1 else sign:=1;
      n:=abs(n);
      while Calculator.PrimeTableInUse do begin
            Sleep(0);
            if n<=Calculator.CurrentPrime then break;
            end;
      if (n>Calculator.CurrentPrime) then CalculateTPrime;
      for i:=Calculator.PrimesCount-1 downto 0 do begin
       if n>=Calculator.AllPrimes^[i] then begin
          MyPrime:=Calculator.AllPrimes^[i]*Sign;
          exit;
          end;
      end;
      MyPrime:=0;
      RaisedError:=ceUnexpected;
      ErrorPosition:=0;
      CalcError:=True;
   end;
{- Fibonacci -}
   function Fib(n:extended):extended;
   var
   {FibArray:array[0..2] of extended;}
    FA1, FA2, FA3 : extended;
   begin
      if n<2 then Fib:=n else
      if n=2 then Fib:=1 else begin
         FA2:=1;
         FA3:=2;
         while n>3 do begin
            FA1:=FA2;
            FA2:=FA3;
            FA3:=FA1+FA3;
            n:=n-1;
            end;
            Fib:=FA3;
            end;
         end;
{- PGCD -}
   function PGCD(u,v:extended):extended;
   var
       t: extended;
   begin
      if (trunc(u)<>u) or (trunc(v)<>v) then begin
         RaisedError:=ceIntegers + ' (gcd)';
         CalcError:=true;
         ErrorPosition:=0;
         PGCD:=0;
         exit;
         end;
      while (v<>0) do begin
         t:=u - (trunc(u / v))*v;
         u:=v;
         v:=t;
         end;
      PGCD:=abs(u);
     end;

function gcd(g:extended):extended;
var
   ChildValue: extended;
   i:integer;
begin
   i:=1;
   while (Expression^.Child(i)<>nil) do begin
         ChildValue:=Evaluation(Expression^.Child(i));
         g:=PGCD(ChildValue,g);
         inc(i);
         end;
   gcd:=g;
   end;

{-- least common multiple ---------------------------------------------------------}
function lcm(g:extended):extended;
var
   ChildValue: extended;
   i:integer;
begin
   i:=1;
   while (Expression^.Child(i)<>nil) do begin
         ChildValue:=Evaluation(Expression^.Child(i));

      if (trunc(ChildValue)<>ChildValue) or (trunc(g)<>g) then begin
         RaisedError:=ceIntegers + ' (lcm)';
         CalcError:=true;
         ErrorPosition:=0;
         lcm:=0;
         exit;
         end;

         g:=abs(trunc(g/pgcd(g,ChildValue))*ChildValue);
         inc(i);
         end;
   lcm:=g;
   end;
{- VariableValue ---------------------------------------------------------------------}
 function VariableValue(Variable:string):extended;
 begin
    if VarTree[Ord(Variable[1]),1]=0 then begin
       CalcError:=True;
       RaisedError:=
            {$ifDEF English}'undefined variable: '{$ENDIF}
            {$IFDEF French}'variable inconnue: '{$ENDIF}
            {$IFDEF German}'unbekannte Veränderliche: '{$ENDIF}
                    + Variable;
       Result:=0;
       end else begin
       Result:=VarTree[Ord(Variable[1]),0];
       end;
    end;{VariableValue}

function ShortGamma(Alpha:extended;Step:extended;Infinity:longint):extended;
  function GIntegral(x:extended):extended;
      begin
      GIntegral:=Power(x,Alpha-1)/Power(Exp(1),x);
      end;
     var i:extended;
         TempGamma:extended;
       begin
       if (Step>=1) or (Step=0) then begin
          CalcError:=True;
          ErrorPosition:=0;
          RaisedError:=
            {$ifDEF English}'inaccurate (>=1||=0) step for "gamma"';{$ENDIF}
            {$IFDEF French}'pas aberrant (>=1||=0) pour "gamma"';{$ENDIF}
            {$IFDEF German}'absurde Schritt (>=1||=0) für "gamma"';{$ENDIF}
          ShortGamma:=0;
          exit;
          end;
       i:=0;
       TempGamma:=0;
       while i<Infinity do begin
        i:=i+Step;
        TempGamma:=TempGamma+GIntegral(i)*Step;
       end;
       ShortGamma:=TempGamma;
       end;
{- Factor ----------------------------------------------------------------------------}
   function Factor(n,step:extended):extended;
     var i:integer;
         NewGamma:extended;
     begin
     if (n<0) then
       if (trunc(n)=n) then begin
          Factor:=0;
          RaisedError:=
            {$ifDEF English}'factor results to infinity';{$ENDIF}
            {$IFDEF French}'factorielle tend vers infini';{$ENDIF}
            {$IFDEF German}'Unendlichkeit';{$ENDIF}
          CalcError:=true;
          ErrorPosition:=0;
          exit;
        end else begin
            NewGamma:=ShortGamma(abs(1+frac(n))+1,step,50+abs(trunc(n*1.2)));
            for i:=-1 to trunc(abs(n))-1 do begin
                NewGamma:=NewGamma/(frac(n)-i);
                end;
            Factor:=NewGamma;
        end else
     if n=0 then Factor:=1 else
     if n=1 then Factor:=1 else
     if n=2 then Factor:=2 else
     if n=3 then Factor:=6 else
     Factor:=ShortGamma(n+1,step,50+trunc(n*1.2));
    end;
function Gamma(Alpha:extended;Step:extended):extended;
begin
   Gamma:=Factor(Alpha-1,Step);
   end;
function Beta(a,b: extended): extended;
var
   Step: extended;
begin
   if Expression^.ChildCount=3 then Step := Evaluation(Expression^.Child(2)) else Step:= 0.01;
   Beta:=Gamma(a,step)*Gamma(b,step)/Gamma(a+b,step);
   end;
{-------------------------------------------------------------------------------------}
function Precise(Value:extended;DecimalPrecision:integer):extended;
var NewValue:extended;
begin
   try
     NewValue:=Value*(Power(10,DecimalPrecision));
     NewValue:=Trunc(NewValue);
     NewValue:=NewValue/(Power(10,DecimalPrecision));
     Precise:=NewValue;
     except
     Precise:=Value;
     end;
   end;
{- Coth -------------------------------------------------------------------------------}
function Coth(g:extended):extended;
begin
   if exp(g)=exp(-g) then begin
      RaisedError:=ceEzeroDivide + ' (Coth)';
      CalcError:=true;
      ErrorPosition:=0;
      Coth:=0;
      exit;
      end;
   Coth:=(exp(g)+exp(-g))/(exp(g)-exp(-g));
   end;
{- MyRandom ---------------------------------------------------------------------------}
function MyRandom(g:extended):extended;
begin
   Randomize;
   if g<=0 then begin
      RaisedError:=
            {$ifDEF English}'senseless random request';{$ENDIF}
            {$IFDEF French}'générateur aléatoire abérant';{$ENDIF}
            {$IFDEF German}'absurd Zufallszahlgenerator';{$ENDIF}
      CalcError:=true;
      ErrorPosition:=0;
      MyRandom:=0;
      exit;
      end;
   MyRandom:= Random(trunc(g));
   end;
{- Sec -------------------------------------------------------------------------}
function Sec(g:extended):extended;
begin
   if CalcMode=deg then g:=DegToRad(g);
   if Precise(Cos(g),10)=0 then begin
      Sec:=0;
      RaisedError:=ceEZeroDivide + ' (Sec)';
      CalcError:=true;
      ErrorPosition:=0;
      exit;
      end;
   Sec:= 1/Precise(cos(g),10);
   end;
{- MySqrt ----------------------------------------------------------------------}
function MySqrt(g:extended):extended;
begin
   if g<0 then begin
      MySqrt:=0;
      RaisedError:=
            {$ifDEF English}'complex result for "sqrt"';{$ENDIF}
            {$IFDEF French}'résultat complexe pour "sqrt"';{$ENDIF}
            {$IFDEF German}'Ergebnis ist complex für "sqrt"';{$ENDIF}
      CalcError:=true;
      ErrorPosition:=0;
      exit;
      end;
   MySqrt:= sqrt(g)
   end;
{- MySin ------------------------------------------------------------------------}
function MySin(g:extended):extended;
begin
   if CalcMode=deg then g:=DegToRad(g);
   MySin:=Precise(Sin(g),10);
   end;
{- MyCos ------------------------------------------------------------------------}
function MyCos(g:extended):extended;
begin
   if CalcMode=deg then g:=DegToRad(g);
   MyCos:= Precise(Cos(g),10);
   end;
{- MyTan ------------------------------------------------------------------------}
function MyTan(g:extended):extended;
begin
   if CalcMode=deg then g:=DegToRad(g);
   if Precise(Cos(g),10)=0 then begin
      MyTan:=0;
      RaisedError:=ceEZeroDivide + ' (Tan)';
      CalcError:=true;
      ErrorPosition:=0;
      exit;
      MyTan:=0;
      exit;
      end;
   MyTan:=Precise(Tan(g),10);{Precise(Sin(g),10)/Precise(Cos(g),10);}
   end;
{- MyArcSin ---------------------------------------------------------------------}
function MyArcSin(g:extended):extended;
begin
   if (1-sqr(g))<0 then begin
      RaisedError:=
            {$ifDEF English}'complex result for "sqrt"'{$ENDIF}
            {$IFDEF French}'résultat complexe pour "sqrt"'{$ENDIF}
            {$IFDEF German}'Ergebnis ist complex für "sqrt"'{$ENDIF}
                    + ' (ArcSin)';
      CalcError:=true;
      ErrorPosition:=0;
      MyArcSin:=0;
      exit;
      end;
   if sqrt(1-sqr(g))=0 then begin
      RaisedError:=ceEZeroDivide + ' (ArcSin)';
      CalcError:=true;
      ErrorPosition:=0;
      MyArcSin:=0;
      exit;
      end;
      {Evaluation:= ArcSin(g);{Precise(ArcTan (g/sqrt(1-sqr (g))),10);}
   if CalcMode=deg then MyArcSin:=RadToDeg(ArcSin(g)) else
      MyArcSin:=ArcSin(g);
   end;
{- MyArcCos --------------------------------------------------------------------}
function MyArcCos(g:extended):extended;
begin
   if g=0 then begin
      RaisedError:=ceEZeroDivide + ' (ArcCos)';
      CalcError:=true;
      ErrorPosition:=0;
      MyArcCos:=0;
      exit;
      end;
   if (1-sqr(g))<0 then begin
      RaisedError:=
            {$ifDEF English}'complex result for "sqrt"'{$ENDIF}
            {$IFDEF French}'résultat complexe pour "sqrt"'{$ENDIF}
            {$IFDEF German}'Ergebnis ist complex für "sqrt"'{$ENDIF}
                    +' (ArcCos)';
      CalcError:=true;
      ErrorPosition:=0;
      MyArcCos:=0;
      exit;
      end;
   {Evaluation:= ArcCos(g);{Precise(ArcTan (sqrt (1-sqr (g)) /g),10);}
   if CalcMode=deg then MyArcCos:=RadToDeg(ArcCos(g)) else
      MyArcCos:=ArcCos(g);
   end;
{- MyArcCosH--------------------------------------------------------------------}
function MyArcCosh(g:extended):extended;
begin
   if g<1 then begin
      RaisedError:=
            {$ifDEF English}'complex result for "sqrt"'{$ENDIF}
            {$IFDEF French}'résultat complexe pour "sqrt"'{$ENDIF}
            {$IFDEF German}'Ergebnis ist complex für "sqrt"'{$ENDIF}
                    + ' (ArcCosh)';
      CalcError:=true;
      ErrorPosition:=0;
      MyArcCosh:=0;
      exit;
      end;
      MyArcCosh:=ArcCosh(g);
   end;
{- MyArcTanh -------------------------------------------------------------------}
function MyArcTanh(g:extended):extended;
begin
   if Abs(g)>1 then begin
      RaisedError:=ceDomain + ' (ArcTanh)';
      CalcError:=true;
      ErrorPosition:=0;
      MyArcTanh:=0;
      exit;
      end;
      MyArcTanh:=ArcTanh(g);
   end;
{- MyArcTan --------------------------------------------------------------------}
function MyArcTan(g:extended):extended;
begin
      if CalcMode=deg then MyArcTan:=RadToDeg(ArcTan(g)) else
      MyArcTan:=ArcTan(g)
   end;
{- MyCot ------------------------------------------------------------------------}
function MyCot(g:extended):extended;
begin
   if CalcMode=deg then g:=DegToRad(g);
   if Precise(g,10)=0 then begin
      RaisedError:=ceEZeroDivide + ' (Cot)';
      CalcError:=true;
      ErrorPosition:=0;
      MyCot:=0;
      exit;
      end;
   MyCot:= Cotan(g);
   {Precise(Cos(g),10)/Precise(Sin(g),10);}
   end;
{- MyCsch------------------------------------------------------------------------}
function MyCsch(g:extended):extended;
begin
   if Precise(Sinh(g),10)=0 then begin
      RaisedError:=ceEZeroDivide + ' (Csch)';
      CalcError:=true;
      ErrorPosition:=0;
      MyCsch:=0;
      exit;
      end;
   MyCsch:=1/Sinh(g);
   end;
{- MySech -----------------------------------------------------------------------}
function MySech(g:extended):extended;
begin
   if Precise(Cosh(g),10)=0 then begin
      RaisedError:=ceEZeroDivide + ' (Sech)';
      CalcError:=true;
      ErrorPosition:=0;
      MySech:=0;
      exit;
      end;
   MySech:=1/Cosh(g);
   end;
{- MyCsc ------------------------------------------------------------------------}
function MyCsc(g:extended):extended;
begin
   if CalcMode=deg then g:=DegToRad(g);
   if Precise(Sin(g),10)=0 then begin
      RaisedError:=ceEZeroDivide+ ' (Csc)';
      CalcError:=true;
      ErrorPosition:=0;
      MyCsc:=0;
      exit;
      end;
   MyCsc:= 1/Precise(sin(g),10);
   end;
{- MyLn -------------------------------------------------------------------------}
function MyLn(g:extended):extended;
begin
   if g<=0 then begin
      RaisedError:=ceDomain + ' (ln)';
      CalcError:=true;
      ErrorPosition:=0;
      MyLn:=0;
      exit;
      end;
   MyLn:= ln(g);
   end;
{- MyLog ------------------------------------------------------------------------}
function MyLog(g:extended):extended;
begin
   if g<=0 then begin
      RaisedError:=ceDomain + ' (log)';
      CalcError:=true;
      ErrorPosition:=0;
      MyLog:=0;
      exit;
      end;
   {Evaluation:= ln(g)/ln(10);}
   MyLog:=log10(g);
   end;
{- ArcSec -----------------------------------------------------------------------}
function ArcSec(g:extended):extended;
begin
   if g=0 then begin
      RaisedError:=ceEZeroDivide+' (ArcSec)';
      CalcError:=true;
      ErrorPosition:=0;
      ArcSec:=0;
      exit;
      end;
   if abs(1/g)>1 then begin
      RaisedError:=ceDomain + ' (ArcSec)';
      CalcError:=true;
      ErrorPosition:=0;
      ArcSec:=0;
      exit;
      end;
  if CalcMode=deg then ArcSec:=RadToDeg(ArcCos(1/g)) else
     ArcSec:=ArcCos(1/g);
  end;
{- ArcCsc -----------------------------------------------------------------------}
function ArcCsc(g:extended):extended;
begin
   if g=0 then begin
      RaisedError:=ceEZeroDivide+ ' (ArcCsc)';
      CalcError:=true;
      ErrorPosition:=0;
      ArcCsc:=0;
      exit;
      end;
   if abs(1/g)>1 then begin
      RaisedError:=ceDomain + ' (ArcCsc)';
      CalcError:=true;
      ErrorPosition:=0;
      ArcCsc:=0;
      exit;
      end;
  if CalcMode=deg then ArcCsc:=RadToDeg(ArcSin(1/g)) else
     ArcCsc:=ArcSin(1/g);
   end;
{- ArcCot -----------------------------------------------------------------------}
function ArcCot(g:extended):extended;
begin
   if g=0 then begin
      RaisedError:=ceEZeroDivide + ' (ArcCot)';
      CalcError:=true;
      ErrorPosition:=0;
      ArcCot:=0;
      exit;
      end;
   if CalcMode=deg then ArcCot:=RadToDeg(ArcTan(1/g)) else
      ArcCot:=ArcTan(1/g);
  end;
{- ArcSech -----------------------------------------------------------------------}
function ArcSech(g:extended):extended;
begin
   if g=0 then begin
      RaisedError:=ceEZeroDivide + ' (ArcSech)';
      CalcError:=true;
      ErrorPosition:=0;
      ArcSech:=0;
      exit;
      end;
   if (1/g)<1 then begin
      RaisedError:=ceDomain + ' (ArcSech)';
      CalcError:=true;
      ErrorPosition:=0;
      ArcSech:=0;
      exit;
      end;
   ArcSech:=ArcCosh(1/g);
   end;
{- ArcCsch -----------------------------------------------------------------------}
function ArcCsch(g:extended):extended;
begin
   if g=0 then begin
      RaisedError:=ceEZeroDivide + ' (ArcCsch)';
      CalcError:=true;
      ErrorPosition:=0;
      ArcCsch:=0;
      exit;
      end;
   ArcCsch:=ArcSinh(1/g);
   end;
{- ArcCoth -----------------------------------------------------------------------}
function ArcCoth(g:extended):extended;
begin
   if g=0 then begin
      RaisedError:=ceEZeroDivide + ' (ArcCoth)';
      CalcError:=true;
      ErrorPosition:=0;
      ArcCoth:=0;
      exit;
      end;
   if Abs(1/g)>1 then begin
      RaisedError:=ceDomain + ' (ArcCoth)';
      CalcError:=true;
      ErrorPosition:=0;
      ArcCoth:=0;
      exit;
      end;
      ArcCoth:=ArcTanh(1/g);
   end;
{- MyNot -----------------------------------------------------------------}
function MyNot(g:extended):extended;
begin
   if trunc(g)<>g then begin
      RaisedError:=ceIntegers + ' (logic)';
      CalcError:=true;
      ErrorPosition:=0;
      MyNot:=0;
      exit;
      end;
   MyNot:=Not(trunc(g));
   end;
{- MyShl -----------------------------------------------------------------}
function MyShr(g,d:extended):extended;forward;
function MyShl(g,d:extended):extended;
begin
   if d<0 then MyShl:=MyShr(g,-d) else
   if (trunc(g)<>g) or (trunc(d)<>d) then begin
      RaisedError:=ceIntegers + ' (logic)';
      CalcError:=true;
      ErrorPosition:=0;
      MyShl:=0;
      exit;
      end else
   MyShl:=trunc(g) shl trunc(d)
   end;
{- MyShr -----------------------------------------------------------------}
function MyShr(g,d:extended):extended;
begin
   if d<0 then MyShr:=MyShl(g,-d) else
   if (trunc(g)<>g) or (trunc(d)<>d) then begin
      RaisedError:=ceIntegers + ' (logic)';
      CalcError:=true;
      ErrorPosition:=0;
      MyShr:=0;
      exit;
      end else
   MyShr:=trunc(g)shr trunc(d)
   end;
{- Euler's Indice, the Phi function --------------------------------------}
function eInd(g:extended):extended;
var
   UsedPrimes:PPrimesArray;
   UniquePrimesCount: longint;
   {-----------------}
   procedure UniquePrimesAdd(PrimeToAdd: LongInt);
   var
      i:LongInt;
   begin
   {$ifdef Debug} DebugForm.Debug('adding::'+IntToStr(PrimeToAdd)); {$endif}
        for i:=0 to UniquePrimesCount-1 do begin
            if UsedPrimes^[i]=PrimeToAdd then exit;
            end;
            Calculator.PrimesAdd(PrimeToAdd,UsedPrimes,UniquePrimesCount);
      end;
   procedure Factoring(lin:longint);
   var
      lcnt:longint;
      CurrentCounter:longint;
   begin
      {$ifdef Debug} DebugForm.Debug('Step 1::factoring '+IntToStr(Calculator.PrimesCount)); {$endif}
      if (Calculator.AllPrimes^[Calculator.PrimesCount-1]<lin) then MyPrime(lin);
      {$ifdef Debug} DebugForm.Debug('Step 2::factoring'); {$endif}
      CurrentCounter:=2;
      lcnt:=Calculator.AllPrimes^[CurrentCounter];
      {$ifdef Debug} DebugForm.Debug('Step 3::factoring'); {$endif}
      if MyPrime(lin)=lin then begin
         UniquePrimesAdd(lin);
         end else
         while(lcnt*lcnt<=lin) do begin
            if (lin mod lcnt) = 0 then begin
               if MyPrime(lcnt)<>lcnt then
                  factoring(lcnt) else UniquePrimesAdd(lcnt);
               if MyPrime(lin div lcnt)<>(lin div lcnt) then
                  factoring(lin div lcnt) else UniquePrimesAdd(lin div lcnt);
               exit;
               end;
          inc(CurrentCounter);
          lcnt:=Calculator.AllPrimes^[CurrentCounter];
         end;
      end;
   {-----------------}
   var
      FinalResult:extended;
      i: longint;
   begin
     UniquePrimesCount:=0;
     if trunc(g)<>g then begin
        RaisedError:=ceIntegers + ' (phi)';
        CalcError:=true;
        ErrorPosition:=0;
        eInd:=0;
        exit;
        end;
     if g=0 then begin
        eInd:=0;
        exit;
        end;
     g:=Abs(g);
     if Round(g) = 1 then begin
        eInd:=1;
        exit;
        end;
     FinalResult:=g;
     UsedPrimes:=nil;
     {$ifdef Debug} DebugForm.Debug('Factoring initialized.'); {$endif}
     Factoring(Round(g));
     {$ifdef Debug} DebugForm.Debug('Factoring successful.'); {$endif}
     for i:=0 to UniquePrimesCount-1 do begin
        FinalResult:=FinalResult*(1-1/UsedPrimes^[i]);
        end;
     eInd:=FinalResult;
     Calculator.PrimesRemove(UsedPrimes);
   end;
function MyAverage(g: extended):extended;
var
   i,j:integer;
begin
   Result:=g;
   j:=Expression^.ChildCount;
   for i:=1 to j-1 do begin
      Result:=Result + Evaluation(Expression^.Child(i));
      end;
   Result:=Result / j;
   end;
{---------------}
function MyMin(g: extended):extended;
var
   i:integer;
   iValue: extended;
begin
   Result:=g;
   for i:=1 to Expression^.ChildCount-1 do begin
      iValue:=Evaluation(Expression^.Child(i));
      if iValue < Result then Result:=iValue;
      end;
   end;
{-----------------------}
function MySum(g: extended):extended;
var
   i:integer;
begin
   Result:=0;
   for i:=0 to Expression^.ChildCount-1 do
      Result:=Result + Evaluation(Expression^.Child(i));
   end;
function MyProd(g: extended):extended;
var
   i:integer;
begin
   Result:=g;
   for i:=1 to Expression^.ChildCount-1 do
      Result:=Result * Evaluation(Expression^.Child(i));
   end;
function MyMax(g: extended):extended;
var
   i:integer;
   iValue: extended;
begin
   Result:=g;
   for i:=1 to Expression^.ChildCount-1 do begin
      iValue:=Evaluation(Expression^.Child(i));
      if iValue > Result then Result:=iValue;
      end;
   end;{-------------------------}
function MyPrimen(g: extended):extended;
var
   LocalCounter: longint;
begin
   if g<=0 then begin
      CalcError:=True;
      ErrorPosition:=0;
      RaisedError:=ceDomain + ' (PrimeN)';
      MyPrimeN:=0;
      exit;
      end;
   LocalCounter:=Calculator.AllPrimes[Calculator.PrimesCount-1];
   g:=g+1;
   while(Calculator.PrimesCount<=g) do begin
     MyPrime(LocalCounter);
     LocalCounter:=LocalCounter+2;
     end;
     MyPrimen:=Calculator.AllPrimes[trunc(g)];
   end;
{-------------------------}
function MyPrimeC(g: extended):extended;
var
   i: integer;
begin
   if g<0 then begin
      CalcError:=True;
      ErrorPosition:=0;
      RaisedError:=ceDomain + ' (PrimeC)';
      MyPrimeC:=0;
      exit;
      end;
   if (g>Calculator.CurrentPrime) then MyPrime(g);
   for i:=Calculator.PrimesCount-1 downto 0 do begin
   if  g>=Calculator.AllPrimes^[i] then begin
          MyPrimeC:=i-1;
          exit;
          end;
      end;
      CalcError:=True;
      ErrorPosition:=0;
      RaisedError:=ceUnexpected + ' (PrimeC)';
      MyPrimeC:=0;
      end;
{-----------------------}
function Bth(a,b,n: extended): extended;
var
   i: integer;
   curN: extended;
   curU: extended;
   sign: integer;
begin
     { (a+b)^n = a^n+n*(a^(n-1))*b + .... }
     if (trunc(n)<>n) then begin
         Result := Power(a+b, n);
         end else begin
         if (n < 0) then begin
            sign:=-1;
            n := -n;
            end else sign:=1;
         Result := 0;
         curN := 1;
         curU := 1;
         for i:=trunc(n) downto 0 do begin
             Result := Result + (Power(a,i)*Power(b,n-i)*curN)/curU;
             curN := curN * i;
             curU := curU * (n-i+1);
             end;
         if (sign = -1) then Result := 1/Result;
         end;
     end;
{-----------------------}
function Binom(n,j:extended):extended;
var
   _1Fact,_2Fact,_3Fact:extended;
begin
   _1Fact:=Factor(n,0.01);
   _2Fact:=Factor(j,0.01);
   _3Fact:=Factor(n-j,0.01);
   if (_2Fact=0) or (_3Fact=0) then begin
      CalcError:=True;
      ErrorPosition:=0;
      RaisedError:=
            {$ifDEF English}'factor results to infinity (binom)';{$ENDIF}
            {$IFDEF French}'factorielle tend vers infini (binom)';{$ENDIF}
            {$IFDEF German}'Unendlichkeit (binom)';{$ENDIF}
      binom:=0;
      exit;
      end;
   Binom:=_1Fact/(_2Fact*_3Fact);
   end;
{----------------------}
function Harmonic(g: extended): extended;
var
   i: LongInt;
begin
(*     if (trunc(g)<>g) or
        (g<=0) then begin
        RaisedError:='harmonic requires positive integers';
        CalcError:=true;
        ErrorPosition:=0;
        Result:=0;
        exit;
        end;*)
   Result:=1;
   for i:=1 downto trunc(g) do begin
      Result:=Result + 1/i;
      end;
   for i:=2 to trunc(g) do begin
      Result:=Result + 1/i;
      end;
   end;
function Sigma(g, ipower: extended): extended;
var
   n,i: longint;
begin
     if (trunc(g)<>g) then begin
        RaisedError:=ceIntegers + ' (sigma)';
        CalcError:=true;
        ErrorPosition:=0;
        Result:=0;
        exit;
        end;
     n:=trunc(Abs(g));
     if n=0 then begin
        Result:=0;
        exit;
        end;
     Result:=1;
     for i:=2 to n do begin
        if n mod i = 0 then Result:=Result + Power(i, iPower);
        end;
   end;
{---------------------}
function EllipticE(k: extended): extended;
var
   z: extended;
   sk, sz: string;
begin
   Result:=k;
   if Expression^.ChildCount=1 then z:=1 else z:=Evaluation(Expression^.Child(1));
   if CalcError then exit;
   sk:=FloatToStr(k);
   sz:=FloatToStr(z);
   Result:=Integral('int(sqrt(1-'+sk+'^2*t^2)/sqrt(1-t^2),t,0,'+sz+',10^-7)');
   end;

function EllipticF(k: extended): extended;
var
   z: extended;
   sk, sz: string;
begin
   Result:=k;
   if Expression^.ChildCount=1 then z:=1 else z:=Evaluation(Expression^.Child(1));
   if CalcError then exit;
   sk:=FloatToStr(k);
   sz:=FloatToStr(z);
   Result:=Integral('int((1/sqrt(1-t^2))/sqrt(1-'+sk+'^2*t^2),t,0,'+sz+',10^-7)');
   end;

function PochHammer(g, z: extended): extended;
begin
   try
   if (g=0) and (z=0) then begin
      CalcError:=True;
      RaisedError:=ceDomain + ' (pochhammer)';
      Result:=0;
      exit;
      end;
   Result:=Gamma(g+z,0.01)/Gamma(g,0.01);
   except
   Result:=0;
   end;
   end;
function Fermat(g: extended): extended;
const
   FermatTable: array[0..4] of LongInt = (3, 5,17,257,65537);
var
   f: LongInt;
begin
     if (trunc(g)<>g) or (g<0) then begin
        RaisedError:=ceIntegers + ' (fermat)';
        CalcError:=true;
        ErrorPosition:=0;
        Result:=0;
        exit;
        end;
     f:=trunc(g);
     if f >= SizeOf(FermatTable)div SizeOf(LongInt) then begin
        RaisedError:=ceEIntOverFlow + ' (fermat)';
        CalcError:=true;
        ErrorPosition:=0;
        Result:=0;
        exit;
        end;
     Result:=FermatTable[f];
   end;
function Moebius(g: extended): extended;
var
   FinalResult: extended;
   UsedPrimes:PPrimesArray;
   UniquePrimesCount: longint;

   procedure DecompUpdate(PrimeToAdd: longint);
   var
      i:LongInt;
   begin
   {$ifdef Debug} DebugForm.Debug('adding::'+IntToStr(PrimeToAdd)); {$endif}
        for i:=0 to UniquePrimesCount-1 do begin
            if UsedPrimes^[i] = PrimeToAdd then begin
               FinalResult:=0;
               exit;
               end;
            end;
            Calculator.PrimesAdd(PrimeToAdd,UsedPrimes,UniquePrimesCount);
      end;
   procedure Factoring(lin:longint);
   var
      lcnt:longint;
      CurrentCounter:longint;
   begin
      {$ifdef Debug} DebugForm.Debug('Step 1::factoring '+IntToStr(Calculator.PrimesCount)); {$endif}
      if (Calculator.AllPrimes^[Calculator.PrimesCount-1]<lin) then MyPrime(lin);
      {$ifdef Debug} DebugForm.Debug('Step 2::factoring'); {$endif}
      CurrentCounter:=2;
      lcnt:=Calculator.AllPrimes^[CurrentCounter];
      {$ifdef Debug} DebugForm.Debug('Step 3::factoring'); {$endif}
      if MyPrime(lin)=lin then begin
         DecompUpdate(lin);
         end else
         while(lcnt*lcnt<=lin) do begin
            if (lin mod lcnt) = 0 then begin
               if MyPrime(lcnt)<>lcnt then
                  factoring(lcnt) else DecompUpdate(lcnt);
               if MyPrime(lin div lcnt)<>(lin div lcnt) then
                  factoring(lin div lcnt) else DecompUpdate(lin div lcnt);
               exit;
               end;
          inc(CurrentCounter);
          lcnt:=Calculator.AllPrimes^[CurrentCounter];
         end;
      end;
   var
      i: longint;
      Sign: integer;
   begin
     UniquePrimesCount:=0;
     if trunc(g) <> g then begin
        RaisedError:=ceIntegers + ' (moebius)';
        CalcError:=true;
        ErrorPosition:=0;
        Result:=0;
        exit;
        end;
     if g = 0 then begin
        Result:=0;
        exit;
        end;
     if g < 0 then Sign:=-1 else Sign:=1;
     g:=Abs(g);
     if Round(g) = 1 then begin
        Result:=1;
        exit;
        end;
     UsedPrimes:=nil;                                                            {$ifdef Debug} DebugForm.Debug('Factoring initialized.'); {$endif}
     FinalResult:=-1;
     Factoring(Round(g));                                                        {$ifdef Debug} DebugForm.Debug('Factoring successful.'); {$endif}
     if FinalResult <> 0 then begin
        FinalResult:=0;
        for i:=0 to UniquePrimesCount-1 do begin
           FinalResult:=FinalResult + 1;
           end;
        FinalResult:=Power(-1, FinalResult);
        end;
     Calculator.PrimesRemove(UsedPrimes);
     Result:=FinalResult*Sign;
   end;
function SafePrime(g: extended): extended;
var
   p : extended;
begin
   p:=trunc(g);
   if p <> g then begin
      RaisedError:=ceIntegers + ' (safeprime)';
      CalcError:=true;
      ErrorPosition:=0;
      Result:=0;
      exit;
      end;
   if (p < 1) then begin
      RaisedError:=ceDomain + ' (safeprime)';
      CalcError:=true;
      ErrorPosition:=0;
      Result:=0;
      exit;
      end;
   if (p < 5) then begin
      Result:=5;
      exit;
      end;
   p:=p+1;
   while (MyPrime((p - 1)/2) <> (p - 1) / 2) or (MyPrime(p) <> p) do p:=p+1;
   Result:=p;
   end;
//--------------------------- financial
  function isRegistered: boolean;
  begin
       {$ifDef Registered}
       Result:=True;
       {$else}
       Result:=False;
       CalcError:=True;
       RaisedError:='registered version function encountered';
       CalcError:=true;
       ErrorPosition:=0;
       {$endif}
       end;
  (* Straight line depreciation - Amortissement linéaire                *)
  function Sln(InitialValue, Residue, Time : extended):extended;
  begin
       isRegistered;
       Result := (InitialValue - Residue) / time;
       end;
  (* Sum of the year digits depreciation - Amortissement dégressif      *)
  function Syd(InitialValue, Residue, Period, Time : extended):extended;
  begin
       isRegistered;
       Result := (InitialValue - Residue) * ((Period + 1 - Time) / (Period * (Period + 1) / 2));
       end;
  (* Number of compounding periods - Durée de capitalisation            *)
  function Cterm(Rate, FutureValue, PresentValue : extended):extended;
  begin
       isRegistered;
       Result := (ln(FutureValue / PresentValue) / ln(1 + Rate));
       end;
  (* Number of payments - Nombre de périodes                            *)
  function Term(Payment, Rate, FutureValue : extended):extended;
  begin
       isRegistered;
       Result := (ln(1 + FutureValue * (Rate / Payment))/ln(1 + Rate));
       end;
  (* Payment - Remboursement                                            *)
  function Pmt(Principal, Rate, Term : extended):extended;
  begin
       isRegistered;
       Result:= Principal * (Rate / (1 - Power(1 + Rate, - Term)));
       end;
  (* Periodic interest Rate - Taux d'intérêt                            *)
  function Rate(FutureValue, PresentValue, Term : extended):extended;
  begin
       isRegistered;
       Result:= Power((FutureValue) / (PresentValue), 1 / Term) - 1;
       end;
  (* Present value - Valeur actualisée                                  *)
  function Pv(Payment, Rate, Term : extended):extended;
  begin
       isRegistered;
       Pv := (Payment * (1 - Power(1 + Rate, - Term)) / Rate);
       end;
  (* Net present value  - Valeur actualisée d'une série                 *)
  function Npv(Rate : extended; Expression: PNode): extended;
  var
    i: integer;
  begin
    isRegistered;
    Result:=0;
    for i:=1 to Expression^.ChildCount - 1 do begin
        Result := Result + (Evaluation(Expression^.Child(i)) / Power(1 + Rate, i));
        end;
    end;
  (* Future value - Valeur à terme                                      *)
   function Fv(payment, rate, term : extended): extended;
   begin
       isRegistered;
       Result:= Payment * (Power(1 + Rate, Term) - 1) / Rate;
       end;
   (* depreciation of an asset for a specified period using the fixed-declining balance method *)
   function fDB(cost, salvage, life, period, month: extended): extended;
   var
      i: integer;
      rate: extended;
      depreciation: extended;
      dtot: extended;
   begin
     isRegistered;
     if (trunc(life) <> life) or
        (trunc(life) <= 0) then begin
        RaisedError:=ceDomain + ' (db - life)';
        CalcError:=true;
        ErrorPosition:=0;
        Result:=0;
        exit;
        end;
     if (trunc(period) <> period) or
        (trunc(period) <= 0) or
        (trunc(period) > trunc(life)+1) then begin
        RaisedError:=ceDomain + ' (db - period)';
        CalcError:=true;
        ErrorPosition:=0;
        Result:=0;
        exit;
        end;
     if (trunc(month) <> month) or
        (trunc(month) > 12) or
        (trunc(month) < 1) then begin
        RaisedError:=ceDomain + ' (db - month)';
        CalcError:=true;
        ErrorPosition:=0;
        Result:=0;
        exit;
        end;

     rate := 1 - Power((salvage / cost),(1 / life));
     if (trunc(period) = 1) then begin
        depreciation:=cost * rate * month / 12
        end else
     if (trunc(period) = life+1) then begin
        dtot:=0;
        for i:=1 to trunc(period)-1 do begin
            dTot:=dTot + fDB(cost, salvage, life, i, month)
            end;
        depreciation:=((cost - dTot) * rate * (12 - month)) / 12;
     end else begin
        dTot:=0;
        for i:=1 to trunc(period)-1 do begin
            dTot:=dTot + fDB(cost, salvage, life, i, month);
            end;
        depreciation:=(cost - dTot) * rate;
     end;
     Result:=depreciation;
     end;

  { double declining balance depreciation for the "period" (should be a
    positive, whole number) interval on an item with initial "cost" and
    final "salvage" value at the end of "life" intervals }
     function DDB( cost, salvage, life, period:extended):extended;
     var x:extended; n:integer;
     begin
          isRegistered;
          x:=0; n:=0;
          while period>n do begin
          x:=2*cost/life;
          if (cost-x)<salvage then x:=cost-salvage;
          if x<0 then x:=0;
          cost:=cost-x; inc(n); end;
          ddb:=x;
          end;
{extended version of the RATE function}
function IRATE ( nper, pmt, pv, fv, ptype:extended):extended;
var
   rate,x0,x1,y0,y1:extended;
   function y:extended;
   var
      f:extended;
   begin
        if abs(rate)<1e-6 then y:=pv*(1+nper*rate)+pmt*(1+rate*ptype)*nper+fv
        else begin
             f:=exp(nper*ln(1+rate));
             y:=pv*f+pmt*(1/rate+ptype)*(f-1)+fv;
             end;
        end;
   begin {irate}
         isRegistered;
         rate:=0; y0:=pv+pmt*nper+fv; x0:=rate;
         rate:=exp(1/nper)-1; y1:=y; x1:=rate;
         while abs(y0-y1)>1e-6 do begin { find root by secant method }
               rate:=(y1*x0-y0*x1)/(y1-y0); x0:=x1; x1:=rate; y0:=y1; y1:=y;
               end;
         irate:=rate;
         end; {irate}

{extended version of the CTERM and TERM functions}
function nper (rate, pmt, pv, fv, ptype:extended):extended;
var
   f:extended;
begin
     isRegistered;
     f:=pmt*(1+rate*ptype);
     if abs(rate)>1e-6 then
        nper:=ln((f-rate*fv)/(pv*rate+f))/ln(1+rate)
        else
        nper:=-(fv+pv)/(pv*rate+f);
     end;

{extended version of the PMT function}
function PAYMT ( rate, nper, pv, fv, ptype:extended):extended;
var
   f:extended;
begin
     isRegistered;
     f:=exp(nper*ln(1+rate));
     paymt:= (fv+pv*f)*rate/((1+rate*ptype)*(1-f));
     end;
{extended version of the FV function}
function FVAL  ( rate, nper, pmt, pv, ptype:extended):extended;
var
   f: extended;
begin
     isRegistered;
     f:=exp(nper*ln(1+rate));
     if abs(rate)<1e-6 then
        fval :=-pmt*nper*(1+(nper-1)*rate/2)*(1+rate*ptype)-pv*f
        else
        fval := pmt*(1-f)*(1/rate+ptype)-pv*f;
        end;
{computes the portion of a loan payment that is interest on the principal}
function IPAYMT(rate, per, nper, pv, fv, ptype:extended):extended;
begin
    isRegistered;
    ipaymt := rate* fval( rate, per-ptype-1, paymt( rate, nper, pv, fv, ptype), pv, ptype);
    end;
{computes the portion of a loan payment that reduces the principal}
function PPAYMT( rate, per, nper, pv, fv, ptype:extended):extended;
var
   f:extended;
begin
     isRegistered;
     f:=paymt(rate,nper,pv,fv,ptype);
     ppaymt:=f-rate*fval(rate,per-ptype-1,f,pv,ptype);
     end;
{extended version of the PV function}
function PVAL (rate, nper, pmt, fv, ptype:extended):extended;
var
   f:extended;
begin
     isRegistered;
     if abs(rate)>1e-6 then begin
     f:=exp(nper*ln(1+rate)); pval := (pmt*(1/rate+ptype)*(1-f)-fv)/f; end
     else
     pval:=-(pmt*(1+rate*ptype)*nper+fv)/(1+nper*rate)
     end;
{---------------------}
var
   g, d : extended;
   IntegralType: IntRules;
   QueryVar: char;
   expr, vars, sg: string;
   i: integer;
begin
  try
   Evaluation:=0;
   if CalcError=true then exit;
   if Expression^.Contents=':' then Evaluation:=Evaluation(Expression^.Child(0)) else
   if Expression^.NodeType = NodeValue then Evaluation := Expression^.NodeContents^.MyValue else
   if Expression^.NodeType = NodeVariable then begin
      QueryVar:=Expression.NodeContents.MyVariable[1];
      Evaluation := VariableValue(QueryVar);
      end else
   if Expression^.NodeType = NodeSingle then begin

      if (CompareText(Expression^.NodeContents^.MySingle,'simpson')=0) then IntegralType:=Simpson else
      if (CompareText(Expression^.NodeContents^.MySingle,'trapez')=0) then IntegralType:=Trapezoid else
      if (CompareText(Expression^.NodeContents^.MySingle,'trapezoid')=0) then IntegralType:=Trapezoid else
      if (CompareText(Expression^.NodeContents^.MySingle,'trapezoide')=0) then IntegralType:=Trapezoid else
      if (CompareText(Expression^.NodeContents^.MySingle,'newton')=0) then IntegralType:=Newton else
      if (CompareText(Expression^.NodeContents^.MySingle,'boole')=0) then IntegralType:=Boole else
      if (CompareText(Expression^.NodeContents^.MySingle,'ordersix')=0) then IntegralType:=OrderSix else
      if (CompareText(Expression^.NodeContents^.MySingle,'ordresix')=0) then IntegralType:=OrderSix else
      if (CompareText(Expression^.NodeContents^.MySingle,'weddle')=0) then IntegralType:=Weddle else
      IntegralType:=Nothing;

      if IntegralType <> Nothing then begin
          Evaluation:=fSum(Expression^.Child(0),
                                      Expression^.Child(1),
                                      Evaluation(Expression^.Child(2)),
                                      Evaluation(Expression^.Child(3)),
                                      Evaluation(Expression^.Child(4)),
                                      IntegralType);
          exit;
       end else
       if (Calculator.User_Functions.GetFunction(Expression^.NodeContents^.MySingle, expr, vars)) then
           Evaluation:=UserEval(expr, vars, expression) else
//----------graph plotter init
       if CompareText(Expression^.NodeContents^.MySingle,'plot')=0 then
          Evaluation:=GeneralPlot (Expression)
                                   else
       if CompareText(Expression^.NodeContents^.MySingle,'zplot')=0 then
          Evaluation:=GeneralPlot3d (Expression)
                                   else

//----------------------------
       if (CompareText(Expression^.NodeContents^.MySingle,'int')=0) or
          (CompareText(Expression^.NodeContents^.MySingle,'gauss')=0) then begin
          Evaluation:=Tegral(Expression^.Child(0),
                                         Expression^.Child(1),
                                         Evaluation(Expression^.Child(2)),
                                         Evaluation(Expression^.Child(3)),
                                         Evaluation(Expression^.Child(4)));
          exit;
       end else begin
       if CalcError then exit;
       g := Evaluation(Expression^.Child(0));
//-----------financial
       if CompareText(Expression^.NodeContents^.MySingle,'fv')=0 then Evaluation:=fv(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2))) else
       if CompareText(Expression^.NodeContents^.MySingle,'db')=0 then begin
          if Expression^.ChildCount = 4 then d:=12 else d:=Evaluation(Expression^.Child(4));
          Evaluation:=fDB(g,Evaluation(Expression^.Child(1)),Evaluation(Expression^.Child(2)),Evaluation(Expression^.Child(3)),d)
          end
       else
       if CompareText(Expression^.NodeContents^.MySingle,'sln')=0 then Evaluation:=sln(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2))) else
       if CompareText(Expression^.NodeContents^.MySingle,'syd')=0 then Evaluation:=syd(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2)), Evaluation(Expression^.Child(3))) else
       if CompareText(Expression^.NodeContents^.MySingle,'cterm')=0 then Evaluation:=cterm(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2))) else
       if CompareText(Expression^.NodeContents^.MySingle,'ddb')=0 then Evaluation:=ddb(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2)), Evaluation(Expression^.Child(3))) else
       if CompareText(Expression^.NodeContents^.MySingle,'term')=0 then Evaluation:=term(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2))) else
       if CompareText(Expression^.NodeContents^.MySingle,'pmt')=0 then Evaluation:=pmt(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2))) else
       if CompareText(Expression^.NodeContents^.MySingle,'rate')=0 then Evaluation:=rate(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2))) else
       if CompareText(Expression^.NodeContents^.MySingle,'irate')=0 then Evaluation:=irate(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2)), Evaluation(Expression^.Child(3)), Evaluation(Expression^.Child(4))) else
       if CompareText(Expression^.NodeContents^.MySingle,'pv')=0 then Evaluation:=pv(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2))) else
       if CompareText(Expression^.NodeContents^.MySingle,'npv')=0 then Evaluation:=npv(g, Expression) else
       if CompareText(Expression^.NodeContents^.MySingle,'nper')=0 then Evaluation:=nper(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2)), Evaluation(Expression^.Child(3)), Evaluation(Expression^.Child(4))) else
       if CompareText(Expression^.NodeContents^.MySingle,'paymt')=0 then Evaluation:=paymt(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2)), Evaluation(Expression^.Child(3)), Evaluation(Expression^.Child(4))) else
       if CompareText(Expression^.NodeContents^.MySingle,'fval')=0 then Evaluation:=fval(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2)), Evaluation(Expression^.Child(3)), Evaluation(Expression^.Child(4))) else
       if CompareText(Expression^.NodeContents^.MySingle,'ipaymt')=0 then Evaluation:=ipaymt(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2)), Evaluation(Expression^.Child(3)), Evaluation(Expression^.Child(4)), Evaluation(Expression^.Child(5))) else
       if CompareText(Expression^.NodeContents^.MySingle,'ppaymt')=0 then Evaluation:=ppaymt(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2)), Evaluation(Expression^.Child(3)), Evaluation(Expression^.Child(4)), Evaluation(Expression^.Child(5))) else
       if CompareText(Expression^.NodeContents^.MySingle,'pval')=0 then Evaluation:=pval(g, Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2)), Evaluation(Expression^.Child(3)), Evaluation(Expression^.Child(4))) else
//-----------conversions
       if CompareText(Expression^.NodeContents^.MySingle,'celstofahr')=0 then Evaluation:=9/5*g+32 else
       if CompareText(Expression^.NodeContents^.MySingle,'fahrtocels')=0 then Evaluation:=5/9*(g-32) else
       if CompareText(Expression^.NodeContents^.MySingle,'galtol')=0 then Evaluation:=g*3.785411784 else
       if CompareText(Expression^.NodeContents^.MySingle,'ltogal')=0 then Evaluation:=g/3.785411784 else
       if CompareText(Expression^.NodeContents^.MySingle,'inchtocm')=0 then Evaluation:=g*2.54 else
       if CompareText(Expression^.NodeContents^.MySingle,'cmtoinch')=0 then Evaluation:=g/2.54 else
       if CompareText(Expression^.NodeContents^.MySingle,'lbtokg')=0 then Evaluation:=g*0.45359237 else
       if CompareText(Expression^.NodeContents^.MySingle,'kgtolb')=0 then Evaluation:=g/0.45359237 else
//--------- new additions
       if CompareText(Expression^.NodeContents^.MySingle,'safeprime')=0 then Evaluation:=SafePrime(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'fermat')=0 then Evaluation:=Fermat(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'tau')=0 then Evaluation:=Sigma(g, 0) else
       if CompareText(Expression^.NodeContents^.MySingle,'sigma')=0 then Evaluation:=Sigma(g, Evaluation(Expression^.Child(1))) else
       if CompareText(Expression^.NodeContents^.MySingle,'elliptice')=0 then Evaluation:=EllipticE(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'ellipticce')=0 then Evaluation:=EllipticE(sqrt(1-Power(g,2))) else
       if CompareText(Expression^.NodeContents^.MySingle,'ellipticf')=0 then Evaluation:=EllipticF(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'elliptick')=0 then Evaluation:=EllipticF(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'ellipticck')=0 then Evaluation:=EllipticF(sqrt(1-Power(g,2))) else
       if CompareText(Expression^.NodeContents^.MySingle,'pochhammer')=0 then Evaluation:=Pochhammer(g, Evaluation(expression^.Child(1))) else
       if CompareText(Expression^.NodeContents^.MySingle,'harmonic')=0 then Evaluation:=Harmonic(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'moebius')=0 then Evaluation:=Moebius(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'mu')=0 then Evaluation:=Moebius(g) else
//---------
       if CompareText(Expression^.NodeContents^.MySingle,'binom')=0 then Evaluation:=Binom(g,Evaluation(Expression^.Child(1))) else
       if CompareText(Expression^.NodeContents^.MySingle,'bth')=0 then Evaluation:=Bth(g,Evaluation(Expression^.Child(1)), Evaluation(Expression^.Child(2))) else
       if CompareText(Expression^.NodeContents^.MySingle,'perfect')=0 then Evaluation:=Perfect(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'parfait')=0 then Evaluation:=Perfect(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'mersgen')=0 then Evaluation:=Pmersenne(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'genmers')=0 then Evaluation:=mersenneP(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'mersenne')=0 then Evaluation:=mersenneN(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'mersennegen')=0 then Evaluation:=mersenneG(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'primec')=0 then Evaluation:=MyPrimec(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'prime')=0 then Evaluation:=MyPrime(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'premier')=0 then Evaluation:=MyPrime(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'primen')=0 then Evaluation:=MyPrimen(g) else
{sin}  if CompareText(Expression^.NodeContents^.MySingle,'sin')=0 then Evaluation:=MySin(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'arcsin')=0 then Evaluation:=MyArcSin(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'sinh')=0 then Evaluation:=Sinh(g) else {(exp(g)-exp(-g))/2}
       if CompareText(Expression^.NodeContents^.MySingle,'arcsinh')=0 then Evaluation:=ArcSinh(g) else
{cos}  if CompareText(Expression^.NodeContents^.MySingle,'cos')=0 then Evaluation:=MyCos(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'arccos')=0 then Evaluation:=MyArcCos(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'cosh')=0 then Evaluation:= cosh(g){(exp(g)+exp(-g))/2} else
       if CompareText(Expression^.NodeContents^.MySingle,'arccosh')=0 then Evaluation:=MyArcCosh(g) else
{tan}  if CompareText(Expression^.NodeContents^.MySingle,'tan')=0 then Evaluation:=MyTan(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'arctan')=0 then Evaluation:=MyArcTan(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'tanh')=0 then Evaluation:=tanh(g) else {Evaluation:=(exp(g)-exp(-g))/(exp(g)+exp(-g)); {tanh has R for domain}
       if CompareText(Expression^.NodeContents^.MySingle,'arctanh')=0 then Evaluation:=MyArcTanh(g) else
{cot}  if CompareText(Expression^.NodeContents^.MySingle,'cot')=0 then Evaluation:=MyCot(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'coth')=0 then Evaluation:=coth(g) else
       if (CompareText(Expression^.NodeContents^.MySingle,'arccot')=0) then Evaluation:=arccot(g) else
       if (CompareText(Expression^.NodeContents^.MySingle,'arccoth')=0) then Evaluation:=arccoth(g) else
{sec}  if CompareText(Expression^.NodeContents^.MySingle,'sec')=0 then Evaluation:=Sec(g) else
       if (CompareText(Expression^.NodeContents^.MySingle,'arcsec')=0) then Evaluation:=arcsec(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'sech')=0 then Evaluation:=MySech(g) else
       if (CompareText(Expression^.NodeContents^.MySingle,'arcsech')=0) then Evaluation:=arcsech(g) else
{csc}  if CompareText(Expression^.NodeContents^.MySingle,'csc')=0 then Evaluation:=MyCsc(g) else
       if (CompareText(Expression^.NodeContents^.MySingle,'arccsc')=0) then Evaluation:=arccsc(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'csch')=0 then Evaluation:=MyCsch(g) else
       if (CompareText(Expression^.NodeContents^.MySingle,'arccsch')=0) then Evaluation:=arccsch(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'random')=0 then Evaluation:=MyRandom(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'sqr')=0 then Evaluation:= sqr(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'sqrt')=0 then Evaluation:= MySqrt(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'floor')=0 then Evaluation:=floor(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'ceil')=0 then Evaluation:=ceil(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'ln')=0 then Evaluation:=MyLn(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'exp')=0 then Evaluation:= exp(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'logn')=0 then Evaluation:=logn(g,Evaluation(Expression^.Child(1))) else
       if CompareText(Expression^.NodeContents^.MySingle,'log')=0 then Evaluation:=MyLn(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'logten')=0 then Evaluation:=log10(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'trunc')=0 then Evaluation:= trunc(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'round')=0 then Evaluation:= round(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'intg')=0 then Evaluation:= int(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'abs')=0 then Evaluation:= abs(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'frac')=0 then Evaluation:= (g-trunc(g)) else
       if CompareText(Expression^.NodeContents^.MySingle,'not')=0 then Evaluation:=MyNot(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'eind')=0 then Evaluation:=eInd(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'phi')=0 then Evaluation:=eInd(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'max')=0 then Evaluation:=MyMax(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'min')=0 then Evaluation:=MyMin(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'sum')=0 then Evaluation:=MySum(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'som')=0 then Evaluation:=MySum(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'mul')=0 then Evaluation:=MyProd(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'prod')=0 then Evaluation:=MyProd(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'average')=0 then Evaluation:=MyAverage(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'durchschnitt')=0 then Evaluation:=MyAverage(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'moyenne')=0 then Evaluation:=MyAverage(g) else
       if CompareText(Expression^.NodeContents^.MySingle,'shl')=0 then Evaluation:=MyShl(g,Evaluation(Expression^.Child(1))) else
       if CompareText(Expression^.NodeContents^.MySingle,'shr')=0 then Evaluation:=MyShr(g,Evaluation(Expression^.Child(1))) else
       if CompareText(Expression^.NodeContents^.MySingle,'beta')=0 then Evaluation:=beta(g,Evaluation(Expression^.Child(1))) else
       if CompareText(Expression^.NodeContents^.MySingle,'gamma')=0 then Evaluation:=Gamma(g,Evaluation(Expression^.Child(1))) else
       if CompareText(Expression^.NodeContents^.MySingle,'fib')=0 then begin
         if (trunc(g)<>g) or (g<0) then begin
            RaisedError:=ceIntegers + ' (fibonacci)';
            CalcError:=true;
            ErrorPosition:=0;
            exit;
            end;
            Evaluation:=Fib(g);
         end else
      if CompareText(Expression^.NodeContents^.MySingle,'lcm')=0 then Evaluation:=lcm(g) else
      if CompareText(Expression^.NodeContents^.MySingle,'ppcm')=0 then Evaluation:=lcm(g) else
      if CompareText(Expression^.NodeContents^.MySingle,'pgcd')=0 then Evaluation:=gcd(g) else
      if CompareText(Expression^.NodeContents^.MySingle,'gcd')=0 then Evaluation:=gcd(g)
      else begin {else}
                RaisedError:=
                             {$ifDEF English}'unknown function: '{$ENDIF}
                             {$IFDEF French} 'fonction unconnue: '{$ENDIF}
                             {$IFDEF German} 'unbekannte Funktion: '{$ENDIF}
                                     + Expression^.NodeContents^.MySingle;
                CalcError:=true;
                ErrorPosition:=0;
                exit;
                end;
       end;
   end{else}
   else begin
      if (CompareText(Expression^.NodeContents^.MyOperator,'=')=0) then begin
         sg:=Trim(Expression^.Child(0).Contents);
         if (Length(sg)<>1) then begin
               for i:=1 to Length(sg) do
                  if (not (sg[i] in ['a'..'z','A'..'Z'])) then begin
                     RaisedError:=
                                  {$ifDEF English}'leftside cannot be assigned to';{$ENDIF}
                                  {$IFDEF French} 'désignation invalide';{$ENDIF}
                                  {$IFDEF German} 'ungültige Eingabe';{$ENDIF}
                     CalcError:=True;
                     Result:=0;
                     exit;
                     end;
         end else if (not (sg[1] in ['a'..'z','A'..'Z'])) or
            (fProtected(sg[1])) then begin
               RaisedError:=
                            {$ifDEF English}'leftside cannot be assigned to';{$ENDIF}
                            {$IFDEF French} 'désignation invalide';{$ENDIF}
                            {$IFDEF German} 'ungültige Eingabe';{$ENDIF}
               CalcError:=true;
               end else begin
               d:=Evaluation(Expression^.Child(1));
               Calculator.VarArray[Ord(sg[1]),1]:=1;
               Calculator.VarArray[Ord(sg[1]),0]:=d;
               Result:=d;
               end;
         exit;
         end;
      g := Evaluation(Expression^.Child(0));
      if CalcError=true then exit;
      d := Evaluation(Expression^.Child(1));
      if CalcError=true then exit;
      if (CompareText(Expression^.NodeContents^.MyOperator,'xor')=0) then Result:=trunc(g) xor trunc(d) else
      if (CompareText(Expression^.NodeContents^.MyOperator,'xnor')=0) then Result:=not(trunc(g) xor trunc(d)) else
      if (CompareText(Expression^.NodeContents^.MyOperator,'or')=0) then Result:=trunc(g) or trunc(d) else
      if (CompareText(Expression^.NodeContents^.MyOperator,'nor')=0) then Result:=not(trunc(g) or trunc(d)) else
      if (CompareText(Expression^.NodeContents^.MyOperator,'and')=0) then Result:=trunc(g) and trunc(d) else
      if (CompareText(Expression^.NodeContents^.MyOperator,'nand')=0) then Result:=not (trunc(g) and trunc(d)) else
      case Expression^.NodeContents^.MyOperator[1] of
         '&'   : Result:=trunc(g) and trunc(d);
         'm'   : Result:=trunc(g) mod trunc(d);
         '%'   : Result := (d/100)*g;
         '>'   : if g > d then Result:=1 else Result:=0;
         '<'   : if g < d then Result:=1 else Result:=0;
         '?'   : if g <> d then Result:=0 else Result:=1;
         '+'   : Result := g + d;
         '-'   : Result := g - d;
         '*'   : Result := g * d;
         '¦','|'
               : begin {detects zero divisions!!!}
                 if d=0 then begin
                   RaisedError:=ceEZeroDivide + ' (|)';
                   CalcError:=true;
                   ErrorPosition:=0;
                   exit;
                   end;
                 Result := trunc(g/d);
                 end;
         '/'   : begin
                 Result:=g/d;
                 end;
         '^'   : begin
                 Result := Power(g,d);
                 if CalcError=true then exit;
                 end;
         '!'   : begin
                 Result := Factor(g,0.01);
                 if CalcError=true then exit;
                 end;
         '\'   : begin
                 if d=0 then Result:=0 else
                 if d>0 then Result:=Power(d,1/g)
                  else
                   if (Trunc(g)=g) and (odd(Trunc(g))) then Result:=-Power(-d,1/g)
                   else begin
                    RaisedError:=ceDomain +
                       {$ifDEF English}' (root)';{$ENDIF}
                       {$IFDEF French} ' (racine)';{$ENDIF}
                       {$IFDEF German} ' (Wurzel)';{$ENDIF}
                    CalcError:=true;
                    ErrorPosition:=0;
                    exit;
                    end;
                  end;
         end;{case}
   end;{else}
   exit;
   except
      on EAccessViolation do RaisedError:=ceEAccessViolation;
      on EDivByZero  do RaisedError:=ceEZeroDivide;
      on EIntOverFlow  do RaisedError:=ceEIntOverFlow;
      on EInvalidOp  do RaisedError:=ceEInvalidOp;
      on EOutOfMemory do RaisedError:=ceEOutOfMemory;
      on EOverflow do RaisedError:=ceEOverflow;
      on ERangeError do RaisedError:=ceERangeError;
      on EStackOverflow do RaisedError:=ceEStackOverflow;
      on EZeroDivide do RaisedError:=ceEZeroDivide;
      on EUnderFlow  do RaisedError:=ceEUnderFlow;
      else RaisedError:=
        {$ifDEF English}'general exception fault';{$ENDIF}
        {$IFDEF French} 'erreur niveau système';{$ENDIF}
        {$IFDEF German} 'Systemfehler';{$ENDIF}
      end;{evaluation}
      CalcError:=true;
      ErrorPosition:=0;
      Evaluation:=0;
      exit;
   end;
//----------------------------------------------------------- INTEGRALS
function TCalcThread.fProtected(Variable: string): boolean;
const
   chararray : set of char = ['a'..'z','A'..'Z'];
var
   j: integer;
begin
   Result:=True;
   if not (Variable[1] in CharArray) then exit;
   for j:=1 to SizeOf(ProtectedVars) div SizeOf(Char) do
      if Variable[1] = ProtectedVars[j] then exit;
   Result:=False;
   end;

function TCalcThread.fSum(ExpTree, Variable: PNode; a, b, N: extended;
                          fRule: IntRules): extended;
var
   VariableNode: integer;
function EvalFunction(x: extended): extended;
begin
   VarTree[VariableNode,0]:=x;
   Result:=Evaluation(ExpTree);
   end;

function fTrapezoid(h, x: extended): extended;
begin
   Result:=h/2*(EvalFunction(x)+EvalFunction(x+h));
   end;

function fSimpson(h, x: extended): extended;
begin
   Result:=(h/6)*(EvalFunction(x)+ 4*EvalFunction(x+h/2)+EvalFunction(x+h))
   end;

function fNewton(h, x: extended): extended;
begin
   Result:=(h/8)*(EvalFunction(x)+3*EvalFunction(x+h/3)+3*EvalFunction(x+2*h/3)+EvalFunction(x+h))
   end;

function fBoole(h, x: extended): extended;
begin
   Result := (h/90)*(7*EvalFunction(x)+32*EvalFunction(x+h/4)+12*EvalFunction(x+h/2)+
                       32*EvalFunction(x+3*h/4)+7*EvalFunction(x+h))
   end;

function fOrderSix(h, x: extended): extended;
begin
   Result:=h/288*(19*EvalFunction(x)+
                  75*EvalFunction(x+h/5)+
                  50*EvalFunction(x+2*h/5)+
                  50*EvalFunction(x+3*h/5)+
                  75*EvalFunction(x+4*h/5)+
                  19*EvalFunction(x+h));
   end;
function fWeddle(h, x: extended): extended;
begin
   Result:=h/840*(41*EvalFunction(x)+
                  216*EvalFunction(x+h/6)+
                  27*EvalFunction(x+h/3)+
                  272*EvalFunction(x+h/2)+
                  27*EvalFunction(x+2*h/3)+
                  216*EvalFunction(x+5*h/6)+
                  41*EvalFunction(x+h));
   end;
var
   IntegrationVariable: char;
   t: extended;
   OldValue, OldData: extended;
   PartialSum, h, xj: extended;
begin
   if (Variable^.NodeType<>NodeVariable) or
      (Variable^.ChildCount > 0) or
      fProtected(Variable^.Contents) then begin
                    RaisedError:=
                          {$ifDEF English}'invalid integration variable';{$ENDIF}
                          {$IFDEF French}'variable d''intégration invalide';{$ENDIF}
                          {$IFDEF German}'Integrationverändliche ist ungültig';{$ENDIF}
      CalcError:=True;
      Result:=0;
      exit;
      end;
   if (a=b) then begin
      Result:=0;
      exit;
      end;
   if (a>b) then begin
      t:=b;
      b:=a;
      a:=t;
      end;

   IntegrationVariable:=Trim(Variable^.NodeContents^.MyVariable)[1];
   VariableNode:=Ord(IntegrationVariable);
   OldValue:=VarTree[VariableNode,0];
   OldData:=VarTree[VariableNode,1];
   VarTree[VariableNode,1]:=1;

   PartialSum := 0;
   h := (b - a) / N;
   xj:= a;

   while xj <= b-h do begin
      case fRule of
        trapezoid: PartialSum:=PartialSum + fTrapezoid(h, xj);
        simpson  : PartialSum:=PartialSum + fSimpson(h, xj);
        newton:    PartialSum:=PartialSum + fNewton(h, xj);
        boole:     PartialSum:=PartialSum + fBoole(h, xj);
        ordersix:  PartialSum:=PartialSum + fOrderSix(h, xj);
        weddle:    PartialSum:=PartialSum + fWeddle(h, xj);
        end;
        xj := xj + h;
        end;

   Result := PartialSum;
   VarTree[VariableNode,0]:=OldValue;
   VarTree[VariableNode,1]:=OldData;
   end;

(*---------------- TEGRAL & Gauss (c) Daniel Doubrovkine - University of Geneva - 1996*)
(* Gauss Integrals using Hairer's method of inside quadrature formulars of order 30, 14 and 6.*)
function TCalcThread.Tegral(ExpTree, Variable: PNode; borne_a, borne_b, tolerance: extended): extended;
const
   node: array [1..8] of extended = (
                  0.00600374098975728575521714070669,
                  0.0313633037996470478461205261449,
                  0.0758967082947863918996758396129,
                  0.137791134319914976291906972693,
                  0.214513913695730576231386631373,
                  0.302924326461218315051396314509,
                  0.399402953001282738849685848303,
                  0.5);
   weight_30: array [1..8] of extended = (
                  0.0153766209980586341772753638452,
                  0.0351830237440540623547638781650,
                  0.0535796102335859675056982246787,
                  0.0697853389630771572242389105833,
                  0.0831346029084969667761856620583,
                  0.0930805000077811055138625653991,
                  0.0992157426635557882275828790533,
                  0.101289120962780636440769280331);
   weight_14: array [1..7] of extended = (
                  0.0214740282173397570054935876277,
                  0.0143731551004187641018611845407,
                  0.0925992181052370926086398741690,
                  0.011827741709315709982738051631,
                  0.158470036396794584781221195409,
                  0.0038429189419875016111623666981,
                  0.197412901528906589908878520779);
   weight_6: array[1..3] of extended = (
                  0.107157609486215771321856577380,
                  0.0311309019298138180329408798985,
                  0.361711488583970410645202542665);
var
   VariableNode: integer;
procedure Gauss(Alpha, Beta: extended; var Res, Err, ResAbs: extended);
   function EvalFunction(x: extended): extended;
   begin
      VarTree[VariableNode, 0]:=x;
      Result:=Evaluation(ExpTree);
      end;
var
   h: extended;
   iDiv, fRes, gRes, Res1, Res2, Err1, Err2 : extended;
   i : integer;
begin
   h:=beta-alpha;
   ResAbs:=0;
   Res1:=0;
   Res2:=0;

   Res:=weight_30[8]*EvalFunction(Alpha+node[8]*h);
   ResAbs:=Abs(Res);
   for i:=1 to 3 do begin
      fRes   := EvalFunction(alpha+node[2*i]*h);
      gRes   := EvalFunction(beta-node[2*i]*h);
      Res    := Res + weight_30[2*i]*(fRes + gRes);
      ResAbs := ResAbs + weight_30[2*i]*(Abs(fRes)+abs(gRes));
      Res1   := Res1 + weight_14[2*i]*(fRes + gRes);
      Res2   := Res2 + weight_6[i]*(fRes + gRes);
      end;
   for i:=1 to 4 do begin
      fRes   := EvalFunction(alpha+node[2*i-1]*h);
      gRes   := EvalFunction(beta-node[2*i-1]*h);
      Res    := Res + weight_30[2*i-1]*(fRes + gRes);
      ResAbs := ResAbs + weight_30[2*i-1]*(Abs(fRes)+abs(gRes));
      Res1   := Res1 + weight_14[2*i-1]*(fRes + gRes);
      end;
   Res := h*Res;
   ResAbs := h*ResAbs;
   Err1 := Abs(h*Res1 - Res);
   Err2 := Abs(h*Res2 - Res);
   if Err2<>0 then iDiv:=(Power((Err1 / Err2),2)) else iDiv:=Err1;
   Err := Err1 * iDiv;
   end;

type
  PInterval = ^TInterval;
  TInterval = record
     gm_a,
     gm_b,
     gm_Res,
     gm_Err,
     gm_ResAbs : extended;
     end;
  PDivTableArray = ^TDivTableArray;
  TDivTableArray = array[1..MaxArraySize div 10] of TInterval;
  PAitkenArray = ^TAitkenArray;
  TAitkenArray = array [1..MaxArraySize div 3] of extended;
  PAitkens = ^TAitkens;
  TAitkens = array [0..MaxArraySize div 3] of PAitkenArray;
const
   iMaxCounter : integer = 10;
var
   GlobalMatrix : PDivTableArray;
   Aitkens: PAitkens;
   N, AitkenCounter: LongInt;
   FinalResult: extended;
   StopAitken: boolean;

procedure CalculateAitkenMatrix;
var
   i: integer;
//   m: string;
   K: LongInt;
   CmB: extended;
begin
     //int(log(log(1/x)),x,0,1)
   ReAllocMem(Aitkens, Sizeof(PAitkens)*(N+1));
   //allocate the new column
   GetMem(Aitkens[N], Sizeof(Extended));
   //----------------------------------------------------------------
   K:=N-1;
   for i:=0 to K do begin
      ReallocMem(Aitkens[i], SizeOf(Extended)*(N-i));
      end;
   inc(AitkenCounter);
   Aitkens[1][K]:=FinalResult;
   Aitkens[0][K]:=0;
   //---------------------------------- memory allocation ends here math starts now
   for i:=2 to K do begin
      //accessing to last column element as follows: Aitkens[i][K-i+1]:=0;
         try
         CmB:=(Aitkens[i-1][K-i+2] - Aitkens[i-1][K-i+1]);
         except
         StopAitken:=True;
         CmB:=0;
         end;
      if (CmB<>0) then begin
         try
         Aitkens[i][K-i+1] := Aitkens[i-2][K-i+2]+ 1 / CmB;
         if (odd(i)) then FinalResult:=Aitkens[i][K-i+1];
         except
         StopAitken:=True;
         end;
         end;
      end;

   (*   m:='';
   for j:=1 to K do m:=m+FloatToStr(Aitkens[1][j])+#13#10;
   ShowMessage(m);*)

   //----------------------------------------------------------------
   (*for j:=K downto 0 do begin
      for i:=1 to j do begin
         try
         m:=m+' '+FloatToStr(Aitkens[K-j][i]);
         except
         m:=m+' ?';
         end;
         end;
      m:=m+#13#10;
      end;
   ShowMessage(m);*)
   end;

var
   Res, Err, ResAbs, t: extended;
   IntegrationVariable: char;
   OldValue, OldData: extended;
   ErrorSumAbs, ResAbsSum: extended;
   i, WorstError, iTmp: LongInt;
   PreviousResult: extended;
   iCounter: integer;
begin  {Tegral}
   Result:=0;
   if (Variable^.NodeType<>NodeVariable) or
      (Variable^.ChildCount > 0) or
      fProtected(Variable^.Contents) then begin
                    RaisedError:=
                          {$ifDEF English}'invalid integration variable';{$ENDIF}
                          {$IFDEF French}'variable d''intégration invalide';{$ENDIF}
                          {$IFDEF German}'Integrationverändliche ist ungültig';{$ENDIF}
      CalcError:=True;
      Result:=0;
      exit;
      end;
   if (borne_a=borne_b) then begin
      Result:=0;
      exit;
      end;

   IntegrationVariable:=Trim(Variable^.NodeContents^.MyVariable)[1];
   VariableNode:=Ord(IntegrationVariable);
   OldValue:=VarTree[VariableNode,0];
   OldData:=VarTree[VariableNode,1];
   VarTree[VariableNode,1]:=1;

   N:=1;
   AitkenCounter:=2;
   StopAitken:=False;
   iCounter:=1;
   Gauss(borne_a, borne_b, Res, Err, ResAbs);

   if CalcError then exit;

   ErrorSumAbs:=Err;
   ResAbsSum:=Res;
   FinalResult:=Res;

   GetMem(GlobalMatrix, SizeOf(TInterval)*N);

   GetMem(Aitkens, SizeOf(PAitkens)*2);
   GetMem(Aitkens[0], Sizeof(Extended));
   GetMem(Aitkens[1], Sizeof(Extended));

   with GlobalMatrix[1] do begin
      gm_a:=borne_a;
      gm_b:=borne_b;
      gm_Res:=Res;
      gm_Err:=Err;
      gm_ResAbs:=ResAbs;
      end;

   PreviousResult:=FinalResult;
   while ErrorSumAbs >= Tolerance * ResAbsSum do begin
      if CalcError then break;
      inc(N);

      ReAllocMem(GlobalMatrix, SizeOf(TInterval)*N);

      WorstError:=1;
      for i:=1 to N-1 do begin
         if GlobalMatrix[i].gm_Err>GlobalMatrix[WorstError].gm_Err then
            WorstError:=i;
            end;

         with GlobalMatrix[WorstError] do begin
            borne_a:=gm_a;
            borne_b:=gm_b;
            end;
         with GlobalMatrix[N] do begin
            gm_a:=(borne_b + borne_a) / 2;
            gm_b:= borne_b;
            Gauss(gm_a, borne_b, Res, Err, ResAbs);
            end;


         if CalcError then break;
         with GlobalMatrix[N] do begin
            gm_res:=Res;
            gm_err:=Err;
            gm_resabs:=ResAbs;
            end;

         with GlobalMatrix[WorstError] do begin
            gm_a:=borne_a;
            gm_b:=(borne_b + borne_a) / 2;
            Gauss(borne_a,gm_b, Res, Err, ResAbs);
            end;

         if CalcError then break;
         with GlobalMatrix[WorstError] do begin
            gm_res:=Res;
            gm_err:=Err;
            gm_resabs:=ResAbs;
            end;

         ErrorSumAbs:=0;
         ResAbsSum:=0;
         FinalResult:=0;
         for i:=1 to N do
            with GlobalMatrix[i] do begin
               FinalResult := gm_res + FinalResult;
               ErrorSumAbs := gm_err + ErrorSumAbs;
               ResAbsSum   := gm_resabs + ResAbsSum;
               end;

   //implementing delta ^2 of Aitken
   if not StopAitken then CalculateAitkenMatrix();
   //-------------------------------

   if (PreviousResult = FinalResult) then inc(iCounter);

   with Calculator do
   if DroppedIntegral[0] = 1 then
      if DroppedIntegral[1] = GridId then begin
         DroppedIntegral[0]:=0;
         break;
         end;
   if iCounter >= iMaxCounter then break;
   PreviousResult:=FinalResult;
   Calculator.CalcGrid.Cells[1,GridId]:=sIntegral+FloatToStr(FinalResult);
   Sleep(5);
   end;
   if RaisedError = ceEOverFlow then begin
      RaisedError :=
           {$ifDEF English}'maybe infinity ('+ceEOverFlow+')';{$ENDIF}
           {$IFDEF French}'prob. infini ('+ceEOverFlow+')';{$ENDIF}
           {$IFDEF German}'möglich Unendlichkeit ('+ceEOverFlow+')';{$ENDIF}
           end;
   Result:=FinalResult;
   VarTree[VariableNode,0]:=OldValue;
   VarTree[VariableNode,1]:=OldData;

   FreeMem(GlobalMatrix);
   for i:=0 to AitkenCounter-1 do FreeMem(Aitkens[i]);
   FreeMem(Aitkens);
   end;

function TCalcthread.UserEval(expr, vars: string; var Expression:PNode): extended;
var
   OldVarTree: VariablesArray;
   i: integer;
begin
   OldVarTree:=VarTree;
   for i:=1 to Length(vars) do begin
      VarTree[ord(vars[i]), 0]:=Evaluation(Expression^.Child(i-1));
      VarTree[ord(vars[i]), 1]:=1;
      end;
   Result:=Integral(expr);
   VarTree:=OldVarTree;
   end;

function TCalcthread.Integral(Expr: string): extended;
var
   GTree, GNode: PNode;
begin
   CalcString:=Expr;
   CalcError:=False;
   CharRead:=' ';
   ErrorPosition:=0;
   New(GTree,Create(NodeSingle,'Calculating Tree:'));
   New(ReadNode,Create(NodeSingle,'_'));
   GNode:=GTree^.AddChild(NodeSingle,'Extended Calculator');
   GNode:=GNode^.AddChild(NodeSingle,'(c) Daniel Doubrovkine');
   GNode^.AddChild(NodeSingle,'University of Geneva - 1996');
   GNode:=GNode^.AddChild(NodeValue,'0');
   CalcPos:=1;
   ReadItem;
   AnalyseExpression(GNode);
   Result:=Evaluation(GNode);
   GTree^.Destroy;
   end;

function user_f.AddFunction(name, equiv, vars: PChar): boolean;
var
   Source, Target, Variab: PChar;
begin
   try
   Result:=True;
   if Length(Trim(equiv))=0 then exit;
   if Length(Trim(name))=0 then exit;
   Result:=RemoveFunction(name);
   if not Result then exit;
   inc(Items);
   ReAllocMem(function_names, SizeOf(PChar)*(Items));
   ReAllocMem(function_equiv, SizeOf(PChar)*(Items));
   ReAllocMem(function_vars,  SizeOf(PChar)*(Items));
   Source:=StrAlloc(Length(name)+1);
   Target:=StrAlloc(Length(equiv)+1);
   Variab:=StrAlloc(Length(vars)+1);
   StrCopy(Source, name);
   StrCopy(Target, equiv);
   StrCopy(Variab, vars);
   function_names[Items]:=Source;
   function_equiv[Items]:=Target;
   function_vars[Items]:=Variab;
   except
      Result:=False;
      exit;
   end;
   end;

function user_f.GetFunction(name: string; var expr, vars: string): boolean;
var
   i: integer;
   nI: integer;
begin
   nI:=1;
   if name[1]='-' then begin
      nI:=-1;
      Delete(name,1,1);
      end;
   Result:=False;
   for i:=1 to Items do begin
      if (CompareText(name, function_names[i])=0) then begin
      expr:=function_equiv[i];
      if nI=-1 then expr:='-('+expr+')';
      vars:=function_vars[i];
      Result:=True;
      end;
   end;
   end;

procedure user_f.Clear;
var i: integer;
begin
   if Items > 0 then begin
      for i:=1 to Items do begin
         StrDispose(function_names[i]);
         StrDispose(function_equiv[i]);
         StrDispose(function_vars[i]);
         end;
      FreeMem(function_names);
      FreeMem(function_equiv);
      FreeMem(function_vars);
      end;
   Items:=0;
   end;

function user_f.RemoveFunction(name: PChar): boolean;
var
   i,j: integer;
begin
   Result:=True;
   for i:=1 to Items do begin
      if (CompareText(name, function_names[i])=0) then begin
         if i <= Fixed then begin
            Result:=False;
            exit;
            end;
         StrDispose(function_names[i]);
         StrDispose(function_equiv[i]);
         StrDispose(function_vars[i]);
         for j:=i to Items - 1 do begin
            function_names[j]:=function_names[j+1];
            function_equiv[j]:=function_equiv[j+1];
            function_vars[j]:=function_vars[j+1];
            end;
         dec(Items);
         exit;
         end;
      end;
   end;

constructor user_f.init;
begin
   Clear;
   GetMem(function_names, sizeOf(PChar));
   GetMem(function_equiv, sizeOf(PChar));
   GetMem(function_vars, sizeOf(PChar));
   Fixed:=0;
   //---------------------------------------------------------------------------
   AddFunction('true','1','');
   AddFunction('false','0','');
   AddFunction('rem','x-quot(x,y)','xy');
   AddFunction('quot','x|y','xy');
   AddFunction('ithprime','PrimeN(x)','x');
   AddFunction('dilog','int(ln(t)/(1-t),t,1,n)','n');
   AddFunction('si','int(sin(t)/t,t,0,n,10^-10)','n');
   AddFunction('ci','G+ln(n)+int((cos(t)-1)/t,t,0,n,10^-10)','n');
   AddFunction('ssi','si(n)-pi/2','n');
   AddFunction('shi','int(sinh(t)/t,t,0,n,10^-10)','n');
   AddFunction('chi','G+ln(n)+int((cosh(t)-1)/t,t,0,n,10^-10)','n');
   AddFunction('erf','(2/sqrt(pi))*int(exp(-(t^2)),t,0,f)','f');
   AddFunction('erfc','1-(2/sqrt(pi))*int(exp(-(t^2)),t,0,f)','f');
   AddFunction('fresnelc','int(cos((pi/2)*(t^2)),t,0,n,10^-10)','n');
   AddFunction('fresnels','int(sin(pi/2*t^2),t,0,n,10^-10)','n');
   AddFunction('fresnelf','(1/2 - fresnels(n))*cos(pi/2*n^2)-(1/2-fresnelc(n))*sin(pi/2*n^2)','n');
   AddFunction('fresnelg','(1/2 - fresnelc(n))*cos(pi/2*n^2)-(1/2-fresnels(n))*sin(pi/2*n^2)','n');
   AddFunction('dawson','exp(-x^2)*int(exp(t^2),t,0,x)','x');
   AddFunction('isprime','prime(x)?x','x');
   AddFunction('bman','(a+b)^n','abn');
   Fixed:=20;
   //---------------------------------------------------------------------------
   end;

procedure user_f.AddFullFunction(iName, iVal: string);
var
   i: integer;
   LS, RS: string;
begin
   i:=Pos('#', iVal);
   LS:=Copy(iVal, 1, i-1);
   RS:=Copy(iVal, i+1, Length(iVal)-i);
   AddFunction(PChar(iName), PChar(RS), PChar(LS));
   end;

procedure user_f.GetUserRegistry;
var
   i : LongInt;
   AllStr, Cur, iVal: string;
begin
   AllStr:=ExCalcInit.QueryRegistry(HKEY_CURRENT_USER,PChar(gRegUserFunc), PChar('_all'));
   if Length(AllStr)>0 then begin
      Cur:=''; i:=1;
      while i <= length(AllStr) do begin
         if AllStr[i] = ',' then begin
            iVal:=ExCalcInit.QueryRegistry(HKEY_CURRENT_USER,PChar(gRegUserFunc), PChar(Cur));
            AddFullFunction(Cur, iVal);
            Cur:='';
            inc(i);
            end;
         Cur:=Cur+AllStr[i]; inc(i);
         end;
      end;
   Calculator.UpdateUserMenu;
   end;

procedure user_f.SetUserRegistry;
var
   i: integer;
   iStr: string;
   iTotStr: string;
   TReg: TRegistry;
begin
   TReg:=TRegistry.Create;
   TReg.DeleteKey(gRegUserFunc);

      iTotStr:='';
      for i:=Fixed+1 to Items do begin
      iTotStr:=iTotStr+function_names[i]+',';
      iStr:=function_vars[i]+'#'+function_equiv[i];
      ExCalcInit.AddRegistryStr(HKEY_CURRENT_USER,PChar(gRegUserFunc),
                             PChar(function_names[i]),PChar(iStr));
      end;
      ExCalcInit.AddRegistryStr(HKEY_CURRENT_USER,PChar(gRegUserFunc),
                             PChar('_all'),PChar(iTotStr));

   Treg.Destroy;
   Calculator.UpdateUserMenu;
   end;

function TCalcThread.GeneralPlot3D(var Expression: PNode): extended;
begin
     //plot3d(x^2+y^2,x,0,1,y,1,2)
     {$ifDef Registered}
     XPlot3DCreate(Expression^.Child(0),
                           Expression^.Child(1),
                           Expression^.Child(4),
                           Evaluation(Expression^.Child(2)),
                           Evaluation(Expression^.Child(3)),
                           Evaluation(Expression^.Child(5)),
                           Evaluation(Expression^.Child(6))
                           );
     {$Else}
     RaisedError:=
        {$ifDEF English}'plot is registered version feature';{$ENDIF}
        {$IFDEF French}'';{$ENDIF}
        {$IFDEF German}'';{$ENDIF}
      CalcError:=True;
      Result:=0;
      exit;
     {$Endif}
     Result:=0;
     end;

function TCalcThread.GeneralPlot(var HeadExpression: PNode): extended;
var
   iRes: extended;
begin
     Grid:=False;
     Ortho:=False;
     if HeadExpression^.ChildCount >= 5 then begin
        iRes:=Evaluation(HeadExpression^.Child(4));
        if iRes = Integral('true') then Ortho:=True;
        end;
     if HeadExpression^.ChildCount >= 6 then begin
        iRes:=Evaluation(HeadExpression^.Child(5));
        if iRes = Integral('false') then Grid:=False else Grid := True;
        end;

     {$ifDef Registered}
     {$ifdef Debug} DebugForm.Debug('XPlot::step1'); {$endif}
     Result:=XPlotCreate(HeadExpression^.Child(0),
                         HeadExpression^.Child(1),
                         Evaluation(HeadExpression^.Child(2)),
                         Evaluation(HeadExpression^.Child(3)));
     {$Else}
     RaisedError:=
        {$ifDEF English}'plot is registered version feature';{$ENDIF}
        {$IFDEF French}'';{$ENDIF}
        {$IFDEF German}'';{$ENDIF}
      CalcError:=True;
      Result:=0;
      exit;
     {$Endif}
     end;

//--------- XPLOT

function TCalcThread.XPlot3DCreate(Expression, v1, v2: PNode; v1_a, v1_b, v2_a, v2_b: extended): extended;
var
   V1_N, V2_N: integer;
   V1_O, V2_O: extended;
   V1_V, V2_V: extended;
begin
     iHead:=Expression;
     if (v1_a = v1_b) or
        (v2_a = v2_b) then begin
        RaisedError :=
           {$ifDEF English}'empty plot (equal bounds)';{$ENDIF}
           {$IFDEF French}'graph vide (bornes égales)';{$ENDIF}
           {$IFDEF German}'';{$ENDIF}
        CalcError:=True;
        Result:=-1;
        exit;
        end;

     if v1_a < v1_b then begin
        xmin:=trunc(v1_a)-1;
        xmax:=trunc(v1_b)+1;
        end else begin
        xmax:=trunc(v1_a)-1;
        xmin:=trunc(v1_b)+1;
        end;

     if v2_a < v2_b then begin
        zmin:=trunc(v2_a)-1;
        zmax:=trunc(v2_b)+1;
        end else begin
        zmax:=trunc(v2_a)-1;
        zmin:=trunc(v2_b)+1;
        end;

     ymin:=-15;
     ymax:=15;

     if (V1^.NodeType<>NodeVariable) or
        (V1^.ChildCount > 0) or
        fProtected(V1^.Contents) or
        (V2^.NodeType<>NodeVariable) or
        (V2^.ChildCount > 0) or
        fProtected(V2^.Contents) then begin
                    RaisedError:=
                          {$ifDEF English}'invalid 3D plot variable(s)';{$ENDIF}
                          {$IFDEF French}'variable(s) de graph 3D invalide(s)';{$ENDIF}
                          {$IFDEF German}'verändliche ungültig (graph 3D)';{$ENDIF}
        CalcError:=True;
        Result:=-1;
        exit;
        end;

        d3v1:=Trim(V1^.NodeContents^.MyVariable)[1];
        d3v2:=Trim(V2^.NodeContents^.MyVariable)[1];

        V1_N:=Ord(d3v1);
        V2_N:=Ord(d3v2);

        V1_V:=VarTree[V1_N,0];
        V1_O:=VarTree[V1_N,1];
        V2_V:=VarTree[V2_N,0];
        V2_O:=VarTree[V2_N,1];

        VarTree[V1_N,1]:=1;
        VarTree[V2_N,1]:=1;

        v1index:= V1_N;
        v2index:= v2_N;

        XPlot3DExecute;

        VarTree[V1_N,0]:=V1_V;
        VarTree[V1_N,1]:=V1_O;
        VarTree[V2_N,0]:=V2_V;
        VarTree[V2_N,1]:=V2_O;

        Result:=0;

     end;

function TCalcThread.XPlotCreate(Expression, Variable: PNode; left, right: extended): extended;
var
   OldValue, OldData: extended;
   VariableNode: integer;
begin
     iHead:=Expression;
     {$ifdef Debug} DebugForm.Debug('XPlot::init xplotcreate'); {$endif}
     if left = right then begin
        RaisedError :=
           {$ifDEF English}'empty plot (equal bounds)';{$ENDIF}
           {$IFDEF French}'graph vide (bornes égales)';{$ENDIF}
           {$IFDEF German}'';{$ENDIF}
        CalcError:=True;
        Result:=-1;
        exit;
        end;

     if left < right then begin
        xmin:=trunc(left)-1;
        xmax:=trunc(right)+1;
        end else begin
        xmax:=trunc(left)-1;
        xmin:=trunc(right)+1;
        end;

     ymin:=0;
     ymax:=0;

     if (Variable^.NodeType<>NodeVariable) or
        (Variable^.ChildCount > 0) or
        fProtected(Variable^.Contents) then begin
                    RaisedError:=
                          {$ifDEF English}'invalid 2D plot variable';{$ENDIF}
                          {$IFDEF French}'variable de graph 2D invalide';{$ENDIF}
                          {$IFDEF German}'verändliche ungültig (graph 2D)';{$ENDIF}
        CalcError:=True;
        Result:=-1;
        exit;
        end;

        PlotVariable:=Trim(Variable^.NodeContents^.MyVariable)[1];
        VariableNode:=Ord(PlotVariable);
        OldValue:=VarTree[VariableNode,0];
        OldData:=VarTree[VariableNode,1];
        VarTree[VariableNode,1]:=1;

        PlotVariableIndex := VariableNode;
        {$ifdef Debug} DebugForm.Debug('xPlot::xplotexecute entry'); {$endif}
        XPlotExecute;
        {$ifdef Debug} DebugForm.Debug('xPlot::xplotexecute exit'); {$endif}
        VarTree[VariableNode,0]:=OldValue;
        VarTree[VariableNode,1]:=OldData;
        Result:=0;
     end;

procedure TCalcThread.On3dXPaint(Sender: TObject);
begin
     DrawCadre;
     XMakeAxe(false);
     Calculate3D;
     end;

procedure TCalcThread.XFormCreate;
begin
     XForm:=TGraphForm.CreateNew(nil);
     XImage:=TImage.Create(XForm);

     with xForm do begin
          Color:=clWhite;                                                                                           {$ifdef Debug} DebugForm.Debug('xPlot::xplotexecute withformcolor'); {$endif}
          ClientWidth:=400;                                                                                         {$ifdef Debug} DebugForm.Debug('xPlot::xplotexecute withformclientwidht'); {$endif}
          ClientHeight:=380;
          Caption:='Plot ' + 'Expression Calculator ' + ECVersion + ' ('+IntToStR(ThreadId)+')';
          BorderStyle:=bsDialog;
          end;                                                                                     {$ifdef Debug} DebugForm.Debug('xPlot::xplotexecute withend'); {$endif}

     XForm.InsertControl(XImage);

     with XImage do begin
          Width:=XForm.ClientWidth;
          Height:=XForm.ClientHeight;
          end;

     maxx := XForm.ClientWidth - 1;
     maxy := XForm.ClientHeight - 50;

     XCanvas := XImage.Canvas;                                                                        {$ifdef Debug} DebugForm.Debug('xPlot::xplotexecute canvas'); {$endif}
     end;

procedure TCalcThread.XPlot3dExecute;
begin
     Synchronize(XFormCreate);
     XCanvas.Lock;
     try
     Calculate3D;                                                                                    {$ifdef Debug} DebugForm.Debug('xPlot::xplotexecute calculated'); {$endif}
     except
     end;
     DrawCadre;
     xStatus(Calculator.CalcGrid.Cells[1,GridId-1] + ' ready.');
     xForm.Visible:=True;
     XCanvas.Unlock;
     end;

procedure TCalcThread.XPlotExecute;
begin
     Synchronize(XFormCreate);
     XCanvas.Lock;
     try
     Calculate;                                                                                    {$ifdef Debug} DebugForm.Debug('xPlot::xplotexecute calculated'); {$endif}
     except                                                                                        {$ifdef Debug} DebugForm.Debug('xPlot::xplotexecute calculated exception'); {$endif}
     end;

     DrawCadre;
     XMakeAxe(true);
     XDraw;
     XCanvas.UnLock;
     xForm.Visible:=True;
     end;


function TCalcThread.NewY(Y: extended): LongInt;
//var
//   tempy: extended;
begin
{     try
     tempy  := (Y-yMin)*maxy/(yMax-yMin) + 0.5;
     Result := Trunc(maxy-tempy);
     except
     Result:=Trunc(maxy);
     end;}
     Result:=trunc(Ya - Ey*Y);
     end;

function TCalcThread.NewYTrue(Y: extended): LongInt;
begin
     Result:=trunc(Y);
     end;

function TCalcThread.NewXTrue(X: extended): LongInt;
begin
     Result:=trunc(X);
     end;

function TCalcThread.NewX(X: extended): LongInt;
begin
     //Result:= trunc((X-Xmin) * maxx / (Xmax-Xmin) + 0.5);
     Result:=trunc(Xa + Ex*X);
     end;

procedure TCalcThread.DrawLine(X1,Y1,X2,Y2: extended; xCol: TColor);
var
   OldColor: TColor;
begin
     with XCanvas do begin
          OldColor:=Pen.Color;
          Pen.Color:=xCol;
          MoveTo(NEWX(X1),NEWY(Y1));
          LineTo(NEWX(X2),NEWY(Y2));
          Pen.Color:=OldColor;
          end;
     end;

procedure TCalcThread.DrawPoint(X,Y: extended; COLOR: TColor);
var
   XLoc, YLoc: LongInt;
   OldColor: TColor;
begin
   YLOC := NEWY(Y);
   if (YLOC <= MAXY) then begin
        XLOC := NEWX(X);
        OldColor := XCanvas.Brush.Color;
        XCanvas.Brush.Color := COLOR;
        XCanvas.Ellipse(XLOC+2, YLOC+2, XLOC, YLOC);
        XCanvas.Brush.Color := OldColor;
        end;
   end;

procedure TCalcThread.DrawTruePoint(X,Y: extended; COLOR: TColor);
var
   XLoc, YLoc: LongInt;
begin
   XLOC := NEWXTrue(X);
   YLOC := NEWYTrue(Y);

   if (YLOC <= MAXY) then begin
        XCanvas.Pixels[XLOC, YLOC] := Color;
        end;

   end;


procedure TCalcThread.DrawCadre;
begin
     with xCanvas do begin
     MOVETO(NEWX(XMIN),NEWY(YMIN));
     LINETO(NEWX(XMAX),NEWY(YMIN));
     LINETO(NEWX(XMAX),NEWY(YMAX));
     LINETO(NEWX(XMIN),NEWY(YMAX));
     LINETO(NEWX(XMIN),NEWY(YMIN));
     end;
     end;

procedure TCalcThread.Calculate3D;
          function max(x,y: extended): extended;
          begin
               if x > y then Result := x else Result := y;
               end;
          function min(x, y: extended): extended;
          begin
               if x < y then Result := x else Result := y;
               end;
var
   dy, y, x, iRes, dx, g: extended;
   i, prout, x_screen, y_screen: integer;
   proutMin, proutMax: PIntArray;

begin
     GetMem(proutMin, sizeof(Integer) * XForm.ClientWidth);
     GetMem(proutMax, sizeof(Integer) * Xform.ClientWidth);
     for i:=1 to XForm.ClientWidth do begin
         proutMin[i] := -2034;
         proutMax[i] := 16000;
         end;
     y:=zmin;
     dy:=(zmax - zmin) / 100;
     dx:=(xmax - xmin) / 100;
     g := max((xmax - xmin)/(XForm.ClientWidth - 100), (zmax - zmin)/(XForm.ClientHeight - 100));
     prout := 1;
     while (y < zmax) do begin

     Calculator.CalcGrid.Cells[1,GridId]:= IntToStr(round((y - zmin)/(zmax-zmin)*100)) + '% complete';

     inc(prout);
     x:=xmin;
     VarTree[V2index, 0]:= y;
     ResCount:=0;
     CalcError:=False;
     while (x < xmax) do begin
           VarTree[V1index,0]:=x;
           iRes := Evaluation(iHead);
           if not CalcError then begin
                x_screen := round(prout+(x-xmin)/g);
                if (x_screen <= XForm.ClientWidth) and (x_screen > 0) then begin
                    y_screen := round(XForm.ClientHeight - (prout+(-zmin+iRes)/g));
                    if (y_screen > proutMin[x_screen]) and (y_screen < proutMax[x_screen]) then begin
                        proutMax[x_screen] := round(max(proutMax[x_screen], y_screen));
                        proutMin[x_screen] := round(min(proutMin[x_screen], y_screen));
                        DrawTruePoint(x_screen, y_screen, clRed)
                        end;
                    end;
              end else CalcError := False;
           inc(ResCount);
           x := x + dx;
           end;
     TotCount := ResCount;
     y := y+dy;
     end;
     FreeMem(proutMin, sizeof(Integer) * XForm.ClientWidth);
     FreeMem(proutMax, sizeof(Integer) * Xform.ClientWidth);
     end;

procedure TCalcThread.Calculate;
var
   x, iRes, dx: extended;
   EmptyPlot: boolean;
//   i: LongInt;
begin
     ResCount:=0;
     xStatus('Allocating memory...');
     GetMem(PlotArray, sizeof(Extended)* (XForm.ClientWidth+1));
     GetMem(PlotBoolArray, sizeof(boolean)* (XForm.ClientWidth+1));

     dx:=(xmax - xmin) / XForm.ClientWidth;
     x:=xmin;

     CalcError:=True;
     EmptyPlot:=True;
     while (x < xmax) do begin
           VarTree[PlotVariableIndex,0]:=x;
           iRes:=Evaluation(iHead);
           if CalcError then begin
              PlotBoolArray^[ResCount]:=False;
              CalcError:=False;
              end else begin
              PlotArray^[ResCount]:=iRes;
              if iRes >= yMax then yMax:=trunc(iRes) + 1;
              if iRes <= yMin then yMin:=trunc(iRes) - 1;
              EmptyPlot:=False;
              PlotBoolArray^[ResCount]:=True;
              end;
           inc(ResCount);
           x:=x + dx;
           end;
     TotCount:=ResCount;

     if EmptyPlot then begin
        xStatus('Empty plot.');
        end;

     end;

procedure TCalcThread.XDraw;
var
   x, dx: extended;
begin
     ResCount:=TotCount;
     dx:=(xmax - xmin) / XForm.ClientWidth;
     x:=xmax - dx;
     dec(ResCount);
     while (x > xmin) do begin
           x:=x - dx;
           dec(ResCount);
           if PlotBoolArray^[ResCount] then begin
              if PlotBoolArray^[ResCount + 1] then begin
                 DrawLine(x+dx, PlotArray^[ResCount+1], x, PlotArray^[ResCount], clRed);
                 end else begin
                 DrawPoint(x, PlotArray^[ResCount], clBlack);
                 end;
              end;
           end;
     xStatus(Calculator.CalcGrid.Cells[1,GridId-1] + ' ready - '+ sStr);
     end;

procedure TCalcThread.XStatus(xStr: string);
begin
     with xCanvas do begin
          Rectangle(1,
                    xForm.ClientHeight - 40,
                    xForm.ClientWidth - 1,
                    xForm.ClientHeight - 1);
          TextOut(5, xForm.ClientHeight - 28, xStr);
          //Refresh;
          end;
     end;

procedure TCalcThread.XMakeAxe(draw: boolean);
var
   xx, yy, ll, px, py, u, r      : real;
   jj, ii, i, j, k, c4, l4, hx, hy, x, y : integer;
   maxcol,maxlig                 : integer;
   S1,S2,S3                      : string;
begin
   maxcol := maxx;
   c4     := maxcol - 4;
   maxlig := maxy;
   l4     := maxlig - 4;

   xx := Xmax - Xmin;
   yy := Ymax - Ymin;

   if Ortho Then begin
      r  := maxcol / maxlig ;
      ll := yy * r;
      If (xx > ll) Then ll := xx;
      u  := ln (ll/4)/ln(10);
      If (u < 0) Then u := u - 1;
      px := exp(ln(10)*Int(u));
      ll := Int(ll/px + 1.5)*px;
      hx := trunc(px/ll * c4);
      u  := xx - r*yy;

   if (u < 0) Then xa := 2 + round(c4*(0.5+(-Xmin-xx/2)/r/yy))
              else xa := 2 + round(c4*(-Xmin)/xx);
   if (u > 0) Then ya := 2 + round(l4*(0.5+(Ymax-yy/2)/r/xx))
              else ya := 2 + round(l4*Ymax/yy);
   py := px;
   hy := trunc(1.0*hx);
  end else begin
      u  := ln(xx/4)/ln(10);
      If (u < 0) Then u := u - 1;
      px := exp(ln(10)*int(u));
      u  := ln(yy/4)/ln(10);
      If (u < 0) Then u := u - 1;
      py := exp(ln(10)*int(u));
      hx := trunc(c4/int(xx/px+1.5));
      hy := trunc(l4/int(yy/py+1.5));
  Xa := 2 + round(c4*(-Xmin)/xx);
  Ya := 2 + round(l4*(Ymax)/yy);
  If Ya > maxy Then Ya := maxy;
 end;

 if draw then
 with XCanvas do begin
      MoveTo(0, ya);
      LineTo(maxcol, ya);
      MoveTo(xa, 0);
      LineTo(xa, maxlig);
      end;

    sStr:='Scale: ';
    Str(px :3 :1,S1);
    Str(py :3 :1,S2);
    S3 := 'Dx ='+S1+', Dy ='+S2;
    sStr:='Scale: '+s3;

 for i := (-xa div hx) to (maxcol-xa) div hx do
  begin
   x := xa + i*hx;
   if draw then begin
      XCanvas.moveTo(x, ya-2);
      XCanvas.lineTo(x, ya+2);
      end;
   if (i mod 5 = 0) then
    if draw then begin
      XCanvas.MoveTo(x, ya-3);
      XCanvas.LineTo(x, ya+3);
      end;
   if (i mod 10 = 0) then
    if draw then begin
      XCanvas.MoveTo(x, ya-4);
      XCanvas.LineTo(x, ya+4);
      end;

  for ii:=(-ya div hy) to (maxlig-ya) div hy do begin
       y := ya + ii*hy;
       if draw then begin
          XCanvas.MoveTo(xa-2, y);
          XCanvas.LineTo(xa+2, y);
          end;
       if (ii mod 5 = 0) Then
        if draw then begin
          XCanvas.moveTo(xa-3,y);
          XCanvas.LineTo(xa+3, y);
          end;
       if (ii mod 10 = 0) Then
        if draw then begin
          XCanvas.MoveTo(xa-4,y);
          XCanvas.LineTo(xa+4, y);
          end;
       end;

  if grid and draw Then begin

     XCanvas.Pen.Color:=clBlue;

     for ii := (-xa div hx) to (maxcol-xa) div hx do
     if (ii <> 0) then begin
        x := xa + ii*hx;
     if (ii mod 5 = 0) then k := 2
     else k := 4;
     j := 0;
     while (j < Maxlig) do begin
        XCanvas.MoveTo(x,j);
        XCanvas.LineTo(x+1,j);
        Inc(j, k);
        end;
     end;

  for jj := (-ya div hy) to (maxlig-ya) div hy do
      if (jj <> 0) then begin
         y := ya + jj*hy;
         if (jj mod 5=0) then k := 4 else k := 8;
         j := 0;
         while (j < Maxcol) do begin
               XCanvas.MoveTo(j,y);
               XCanvas.LineTo(j,y-1);
               Inc(j, k);
         end;
    end;
   end;
 end;
XCanvas.Pen.Color:=clBlack;
ex := hx / px;
ey := hy / py;
end;


end.
