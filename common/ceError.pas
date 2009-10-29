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
        {$IFDEF French} 'acc�s au bloc m�moire refus�';{$ENDIF}
        {$IFDEF German} 'Speicherblock kann nicht erreicht werden';{$ENDIF}
     ceEConvertError       : string =
        {$ifDEF English}'unhandled convert error';{$ENDIF}
        {$IFDEF French} 'erreur de conversion';{$ENDIF}
        {$IFDEF German} 'Konvertionfehler';{$ENDIF}
     ceEDivByZero          : string =
        {$ifDEF English}'division by zero';{$ENDIF}
        {$IFDEF French} 'division par z�ro';{$ENDIF}
        {$IFDEF German} 'Nullabteilung';{$ENDIF}
     ceEInOutError         : string =
        {$ifDEF English}'In/Out exception';{$ENDIF}
        {$IFDEF French} 'erreur d''E/S';{$ENDIF}
        {$IFDEF German} 'A/E Fehler';{$ENDIF}
     ceEIntOverFlow        : string =
        {$ifDEF English}'integer overflow';{$ENDIF}
        {$IFDEF French} 'd�bordement (entiers)';{$ENDIF}
        {$IFDEF German} '�berlauf';{$ENDIF}
     ceEInvalidOp          : string =
        {$ifDEF English}'invalid floating point operation';{$ENDIF}
        {$IFDEF French} 'op�ration � virgule flottante invalide';{$ENDIF}
        {$IFDEF German} '';{$ENDIF}
     ceEOutOfMemory        : string =
        {$ifDEF English}'insufficient memory';{$ENDIF}
        {$IFDEF French} 'm�moire insuffisante';{$ENDIF}
        {$IFDEF German} 'ungen�gend Speicher';{$ENDIF}
     ceEOverflow           : string =
        {$ifDEF English}'floating point overflow';{$ENDIF}
        {$IFDEF French} 'd�bordement (virgule flottante)';{$ENDIF}
        {$IFDEF German} 'Uberlauf';{$ENDIF}
     ceERangeError         : string =
        {$ifDEF English}'range check error';{$ENDIF}
        {$IFDEF French} 'erreur dans le domaine d''acc�s';{$ENDIF}
        {$IFDEF German} 'Grundbesitz Fehler';{$ENDIF}
     ceEStackOverflow      : string =
        {$ifDEF English}'stack overflow';{$ENDIF}
        {$IFDEF French} 'd�bordement de pile';{$ENDIF}
        {$IFDEF German} 'Stoss�berlauf';{$ENDIF}
     ceEUnderflow          : string =
        {$ifDEF English}'floating point underflow';{$ENDIF}
        {$IFDEF French} 'd�bordement (virgule flottante)';{$ENDIF}
        {$IFDEF German} 'Uberlauf';{$ENDIF}
     ceEZeroDivide         : string =
        {$ifDEF English}'division by zero';{$ENDIF}
        {$IFDEF French} 'division par z�ro';{$ENDIF}
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
