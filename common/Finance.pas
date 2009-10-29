unit Finance;

interface

const
  Max_Pmt = 12;

type
  Currency = extended;
  SeriesPmt = array[1..Max_Pmt] of Currency;

var
  scale_currency : extended;

(* Interfaced only for use by other units
   Conversion  extended ---> currency        *)
function ToCurrency(value : extended) : Currency;
  (* Straight line depreciation - Amortissement lin‚aire                *)

function Sln(InitialValue, Residue : extended; Time : Byte) : Currency;
  (* Sum of the year digits depreciation - Amortissement d‚gressif      *)
function Syd(InitialValue, Residue : extended; Period, Time : Byte) : Currency;
  (* Number of compounding periods - Dur‚e de capitalisation            *)
function Cterm(Rate : extended; FutureValue, PresentValue : extended) : extended;
  (* Number of payments - Nombre de p‚riodes                            *)
function Term(Payment : extended; Rate : extended; FutureValue : extended) : extended;
  (* Payment - Remboursement                                            *)
function Pmt(Principal : extended; Rate : extended; Term : Byte) : currency;
  (* Periodic interest Rate - Taux d'int‚rˆt                            *)
function Rate(FutureValue, PresentValue : extended; Term : Byte) : extended;
  (* Present value - Valeur actualis‚e                                  *)
function Pv(Payment : extended; Rate : extended; Term : Byte) : currency;
  (* Net present value  - Valeur actualis‚e d'une s‚rie                 *)
function Npv(Rate : extended; Series : SeriesPmt) : currency;
  (* Future value - Valeur … terme                                      *)
function Fv(Payment : extended; Rate : extended; Term : Byte) : currency;

  (*  II - Conversion : anglo-saxon measure unit <--> metric measure unit ---*)

  (* ø Celsius to ø Fahrenheit  *)
function CelsToFahr(value : extended) : extended;
  (* ø Fahrenheit to ø Celsius  *)
function FahrToCels(value : extended) : extended;
  (*  US Gallons  to litres  *)
function GalToL(value : extended) : extended;
  (*  Litres to US gallons   *)
function LToGal(value : extended) : extended;
  (*  Inch  to cm            *)
function InchToCm(value : extended) : extended;
  (*  Cm    to inch          *)
function CmToInch(value : extended) : extended;
  (*  Pounds to kilograms       *)
function LbToKg(value : extended) : extended;
  (*  Kilograms to pounds       *)
function KgToLb(value : extended) : extended;

  (* III ------------------ Percentage  calculation -----------------------*)

  (* Compute value2 % from value1  *)
function Percent(value1, value2 : extended) : extended;
  (* Per cent deviation between value1 and value2 . Result is lower than 1  *)
function DeltaPercent(value1, value2 : extended) : extended;

implementation

var
  decimal_currency : Word;

  function Power(number, exponent : extended) : extended;
  begin
    if number > 0.0 then
      Power := Exp(exponent * ln(number))
    else
      Power := 0.0
  end;

  procedure Set_Dec_Prec(value : Byte);
  begin
    decimal_currency := value;
    scale_currency := Power(10, decimal_currency);
    end;

  function ToCurrency(value : extended) : Currency;
  begin
    ToCurrency := value * scale_currency;
  end;

  function Sln(InitialValue, Residue : extended; Time : Byte) : Currency;
  begin
    Sln := (ToCurrency(InitialValue) - ToCurrency(Residue)) / Time;
  end;

  function Syd(InitialValue, Residue : extended; Period, Time : Byte) : Currency;
  begin
    Syd := (ToCurrency(InitialValue) - ToCurrency(Residue)) *
    ((Period + 1 - Time) / (Period * (Period + 1) / 2));
  end;

  function Cterm(Rate : extended; FutureValue, PresentValue : extended) : extended;
  begin
    Cterm := (ln(ToCurrency(FutureValue) / ToCurrency(PresentValue)) /
              ln(1 + Rate));
  end;

  function Term(Payment : extended; Rate : extended; FutureValue : extended) : extended;
  begin
    Term := (ln(1 + ToCurrency(FutureValue) * (Rate / ToCurrency(Payment))) /
             ln(1 + Rate));
  end;

  function Pmt(Principal : extended; Rate : extended; Term : Byte) : Currency;
  begin
    Pmt := ToCurrency(Principal) * (Rate / (1 - Power(1 + Rate, - Term)));
  end;

  function Rate(FutureValue, PresentValue : extended; Term : Byte) : extended;
  begin
    Rate := Power((FutureValue) / (PresentValue), 1 / Term) - 1;
  end;

  function Pv(Payment : extended; Rate : extended; Term : Byte) : Currency;
  begin
    Pv := (ToCurrency(Payment) * (1 - Power(1 + Rate, - Term)) / Rate);
  end;

  function Npv(Rate : extended; Series : SeriesPmt) : Currency;
  var
    i, number : Byte;
    N : Currency;
  begin
    N := 0; i := 1; number := Max_Pmt;
    REPEAT
      if Series[i] = 0 then number := i;
      Inc(i);
    UNTIL (i = Max_Pmt) OR (Series[i] = 0);

    FOR i := 1 TO number DO
      N := N + (ToCurrency(Series[i]) / Power(1 + Rate, i));
    Npv := N;
  end;

  function Fv(Payment : extended; Rate : extended; Term : Byte) : Currency;
  begin
    Fv := ToCurrency(Payment) * (Power(1 + Rate, Term) - 1) / Rate;
  end;
  (*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*)
  function CelsToFahr(value : extended) : extended;
  begin
    CelsToFahr := 9 / 5 * value + 32;
  end;

  function FahrToCels(value : extended) : extended;
  begin
    FahrToCels := 5 / 9 * (value - 32);
  end;

  function GalToL(value : extended) : extended;
  begin
    GalToL := value * 3.785411784;
  end;

  function LToGal(value : extended) : extended;
  begin
    LToGal := value / 3.785411784;
  end;

  function InchToCm(value : extended) : extended;
  begin
    InchToCm := value * 2.54;
  end;

  function CmToInch(value : extended) : extended;
  begin
    CmToInch := value / 2.54;
  end;

  function LbToKg(value : extended) : extended;
  begin
    LbToKg := value * 0.45359237;
  end;

  function KgToLb(value : extended) : extended;
  begin
    KgToLb := value / 0.45359237;
  end;
  (*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*)
  function Percent(value1, value2 : extended) : extended;
  begin
    Percent := (value1 * value2) / 10000;
  end;

  function DeltaPercent(value1, value2 : extended) : extended;
  begin
    if value2 = 0.0 then DeltaPercent := 0
    else DeltaPercent := (value1 - value2) / value2;
  end;

begin
  Set_Dec_Prec(2);
  end.

