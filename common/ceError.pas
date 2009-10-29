unit ceError;

{$ifndef English}
{$ifndef French}
{$ifndef German}
{$define English}
{$endif}
{$endif}
{$endif}

interface

const
     ceEAccessViolation    : string =
        {$ifDEF English}'multithread access violation';{$ENDIF}
        {$IFDEF French} 'accès au bloc mémoire refusé';{$ENDIF}
        {$IFDEF German} 'Speicherblock kann nicht erreicht werden';{$ENDIF}
     ceEConvertError       : string =
        {$ifDEF English}'unhandled convert error';{$ENDIF}
        {$IFDEF French} 'erreur de conversion';{$ENDIF}
        {$IFDEF German} 'Konvertionfehler';{$ENDIF}
     ceEDivByZero          : string =
        {$ifDEF English}'division by zero';{$ENDIF}
        {$IFDEF French} 'division par zéro';{$ENDIF}
        {$IFDEF German} 'Nullabteilung';{$ENDIF}
     ceEInOutError         : string =
        {$ifDEF English}'In/Out exception';{$ENDIF}
        {$IFDEF French} 'erreur d''E/S';{$ENDIF}
        {$IFDEF German} 'A/E Fehler';{$ENDIF}
     ceEIntOverFlow        : string =
        {$ifDEF English}'integer overflow';{$ENDIF}
        {$IFDEF French} 'débordement (entiers)';{$ENDIF}
        {$IFDEF German} 'überlauf';{$ENDIF}
     ceEInvalidOp          : string =
        {$ifDEF English}'invalid floating point operation';{$ENDIF}
        {$IFDEF French} 'opération à virgule flottante invalide';{$ENDIF}
        {$IFDEF German} '';{$ENDIF}
     ceEOutOfMemory        : string =
        {$ifDEF English}'insufficient memory';{$ENDIF}
        {$IFDEF French} 'mémoire insuffisante';{$ENDIF}
        {$IFDEF German} 'ungenügend Speicher';{$ENDIF}
     ceEOverflow           : string =
        {$ifDEF English}'floating point overflow';{$ENDIF}
        {$IFDEF French} 'débordement (virgule flottante)';{$ENDIF}
        {$IFDEF German} 'Uberlauf';{$ENDIF}
     ceERangeError         : string =
        {$ifDEF English}'range check error';{$ENDIF}
        {$IFDEF French} 'erreur dans le domaine d''accès';{$ENDIF}
        {$IFDEF German} 'Grundbesitz Fehler';{$ENDIF}
     ceEStackOverflow      : string =
        {$ifDEF English}'stack overflow';{$ENDIF}
        {$IFDEF French} 'débordement de pile';{$ENDIF}
        {$IFDEF German} 'Stossüberlauf';{$ENDIF}
     ceEUnderflow          : string =
        {$ifDEF English}'floating point underflow';{$ENDIF}
        {$IFDEF French} 'débordement (virgule flottante)';{$ENDIF}
        {$IFDEF German} 'Uberlauf';{$ENDIF}
     ceEZeroDivide         : string =
        {$ifDEF English}'division by zero';{$ENDIF}
        {$IFDEF French} 'division par zéro';{$ENDIF}
        {$IFDEF German} 'Nullabteilung';{$ENDIF}
     ceDomain              : string =
        {$ifDEF English}'domain error';{$ENDIF}
        {$IFDEF French} 'erreur dans le domaine';{$ENDIF}
        {$IFDEF German} '';{$ENDIF}
     ceUnexpected          : string =
        {$ifDEF English}'unexpected error';{$ENDIF}
        {$IFDEF French} 'erreur inattendue';{$ENDIF}
        {$IFDEF German} 'unerwartete Fehler';{$ENDIF}
     ceIntegers            : string =
        {$ifDEF English}'integers required';{$ENDIF}
        {$IFDEF French} 'entiers requis';{$ENDIF}
        {$IFDEF German} 'Ganzzahl erforderlich';{$ENDIF}

implementation

end.
