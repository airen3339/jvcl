{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvComplex.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is Peter Th?rnqvist [peter3@peter3.com]
Portions created by Peter Th?rnqvist are Copyright (C) 1997 Peter Th?rnqvist.
All Rights Reserved.

Contributor(s):

Last Modified: 2002-06-24

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I JVCL.INC}

{
  @abstract(functions to handle complex numbers)
  @author(Peter Thornqvist (peter3@peter3.com))
  @created()
  @lastmod()
}
unit JvComplex;

{
@exclude
This is a unit that implements functions to handle complex numbers. It is a
translation of the complex.cpp files supplied with, among others, Symantec's C++ 7.0.

These functions might not be public domain which means I'm up for a trial RSN...
Anyway, you need at least Delphi 2.0 and the Math.pas unit (supplied with Delphi) to make
this code work. Slight changes might make it compilable under Delphi 1.0 though
I strongly doubt it. Delphi 1.0 doesn't have the Double type or a Math.pas unit,
as far as I can remember. This unit is,of course, free.
This adaption, Copyright ? 1997 by Peter Th?rnqvist

NOTES:
*. Z denotes a complex number, Z.Re is the real part  and Z.Im is the imaginary part.
*. all functions use a common naming scheme:
   a. as far as possible all functions start off with a name equal to the standard
      library functions, like LogXX, ExpXX, SqrtXX...
   b. the action taken (and the order) is denoted by the letters Z,R,I:
      PowZR means raise Z to the power of R (i.e. Z^R),
      PowRZ means raise R to the power of Z (i.e: R^Z), etc

*. There are no functions to manipulate imaginary numbers directly.
   That's because you can't have imag numbers "floating around":
   The computer can't differentiate between R and I variables
   and would treat them both as reals, generating errors. Instead, you must
   "hide" the imaginary number in a TComplex variable where Z.re := 0
   and then use the functions in this library.
*. The functions PowZR1 and PowZR2 does the same except for the fact that
   PowZR1 truncates the real part to an integer
*. All the ArcXXX functions will generate an exception if |z| > 1
*. Trig and hyperbolic functions calculations are done in radians

}


interface

uses Math, SysUtils;

type
  TComplex = record
    Re,Im:Double;
  end;

{ Conversions & Extractions }

{ ToComplex convert R and I to complex }
function ToComplex(R,I:Double):TComplex;
{ Real return real part of Z }
function Real(Z:TComplex):Double;
{ Imag return imag part of Z }
function Imag(Z:TComplex):Double;

{ Utility functions }

{ IsValidComplexString returns true if S is a valid complex string }
function IsValidComplexString(S:string):boolean;
{ IsValidComplexNumber returns true if Z is a valid complex number }
function IsValidComplexNumber(Z:TComplex):boolean;
{ BoolToString returns boolean as string }
function BoolToString(B:boolean):string;
{ ComplexToString convert Complex to a string }
function ComplexToString(Z:TComplex):string;
{ StringToComplex convert string to a TComplex }
function StringToComplex(S:String):TComplex;


{ Standard operators (+,-,*,/) for complex numbers }

{ AddZZ add two complex numbers }
function AddZZ(const Z,Z2:TComplex):TComplex;
{ AddZR add a complex and a real }
function AddZR(const Z:TComplex;R:Double):TComplex;
{ SubZZ subtract two complex numbers }
function SubZZ(Z,Z2:TComplex):TComplex;
{ SubZR subtract Z.re from R (Z - R) }
function SubZR(Z:TComplex;R:Double):TComplex;
{ SubRZ subtract R from Z.re (R - Z) }
function SubRZ(R:Double;Z:TComplex):TComplex;
{ MulZZ multiply two complex numbers }
function MulZZ(Z,Z2:TComplex):TComplex;
{ MulRZ multiply a real and a complex }
function MulRZ(R:Double;Z:TComplex):TComplex;
{ DivZR divide Z with R ( Z/R ) - let compiler handle divbyzero}
function DivZR(Z:TComplex;R:Double):TComplex;
{ DivRZ divide R with Z ( R/Z) - let compiler handle divbyzero}
function DivRZ(R:Double;Z:TComplex):TComplex;
{ DivZZ divide two complex numbers }
function DivZZ(Z,Z2:TComplex):TComplex;


{ Special functions }

{ AbsZ return absolute value of Z. ( sqrt(x*x + y*y)) }
function AbsZ(Z:TComplex):Double;
{ ModZ same as AbsZ }
function ModZ(Z:TComplex):Double;
{ ArgZ return the argument of Z in radians }
function ArgZ(Z:TComplex):Double;
{ ConjugateZ return conjugate of Z (  conjugate( x + iy ) := x - iy ) }
function ConjugateZ(Z:TComplex):TComplex;
{ NormZ return the square of the absolute value of Z }
function NormZ(Z:TComplex):Double;
{ NegZ return negated value of complex number }
function NegZ(Z:TComplex):TComplex;
{ EqualZZ test for equality }
function EqualZZ(Z,Z2:Tcomplex): boolean;



{ Trig. and hyperbolic functions }
{ CosZ return the cosine of Z }
function CosZ(Z:TComplex):TComplex;
{ CoshZ return the hyperbolic cosine of Z }
function CoshZ(Z:TComplex):TComplex;
{ SinZ return the sine of Z }
function SinZ(Z:TComplex):TComplex;
{ ArcSinZ return the Arcsine of Z }
function ArcSinZ(Z:TComplex):TComplex;
{ SinhZ return the hyperbolic sine of Z }
function SinhZ(Z:TComplex):TComplex;
{ ArcSinhZ return the hyperbolic arcsine of Z }
function ArcSinhZ(Z:TComplex):TComplex;
{ TanZ return the tan of Z }
function TanZ(Z:TComplex):TComplex;
{ ArcTanZ return the arctan of Z }
function ArcTanZ(Z:TComplex):TComplex;
{ ArcCosZ return the arccos of Z }
function ArcCosZ(Z:TComplex):TComplex;
{ TanhZ retun the hyperbolic tan of Z }
function TanhZ(Z:TComplex):TComplex;
{ ArcTanhZ return the hyperbolic arctan of Z }
function ArcTanhZ(Z:TComplex):TComplex;

{ Math. functions }

{ ExpZ returns e raised to Z  (e^Z) }
function ExpZ(Z:TComplex):TComplex;
{ LnZ returns the natural log of Z }
function LnZ(Z:TComplex):TComplex;
{ Log10Z retuns the base 10 log of Z }
function Log10Z(Z:TComplex):TComplex;
{ PolarZ return the complex number built from rect.coords. Range and Theta }
function PolarZ(Range,Angle:Double):TComplex;
{ RectangularZ return the rectangular coordinates of Z }
procedure RectangularZ(Z:TComplex;var Range,Angle:Double);
{ SqrtZ return the Square root of Z }
function SqrtZ(Z:TComplex):TComplex;
{ PowZZ return Z^Z2 }
function PowZZ(Z,Z2:TComplex):TComplex;
{ PowZR1 return Z^R (R is int) }
function PowZR1(Z:TComplex;R:integer):TComplex;
{ PowZR2 return Z^R (R is real) }
function PowZR2(Z:TComplex;R:Double):TComplex;
{ PowRZ return R^Z }
function PowRZ(R:Double;Z:TComplex):TComplex;

implementation

{ Conversion }

{ ToComplex Convert R and I to complex }
function ToComplex(R,I:Double):TComplex;
begin
  Result.Re := R;
  Result.Im := I;
end;

{ IsValidComplexString true if S is a valid complex string }
function IsValidComplexString(S:string):boolean;
begin
  Result := True;
  try
   StringToComplex(S);
  except on EConvertError do
      Result := False;
  end;
end;

{ IsValidComplexNumber true if Z is a valid complex number }
function IsValidComplexNumber(Z:TComplex):boolean;
begin
  Result := True;
  try
    ComplexToString(Z);
  except on EConvertError do
    Result := False;
  end;
end;

{ BoolToString return boolean as string }
function BoolToString(B:boolean):string;
const Bool:array[False..True] of string=('False','True');
begin
  Result := Bool[B];
end;

{ ComplexToString convert Z to a string
  Will raise EConvertError on failure. Call IsValidComplexNumber
  first to avoid this situation.}

function ComplexToString(Z:TComplex):string;
begin
  Result := Format('(%s ,%si)',[FloatToStr(Z.re),FloatToStr(Z.im)]);
end;

{ convert string S to a TComplex }
{
  Accepts any input that StrToFloat does, with these additions:
  1. Im and re part must be separated by any nonnumerical character
  2. If the re part has a sign, it cannot be separated from the number
  (i.e - 3.4 is invalid; -3.4 is OK). The im part sign can be separate
  from the numerical body, although it isn't recommended.

  Examples of valid input:
  +7.8,-0.56E-12
  +7.8  -             0.56E-12
  (+7.8,-0.56E-12)
  (     +7.8      ,         -     0.56E-12      )
        +7.8    +   .   5    6  E  -  1  2
  etc...

  Examples of invalid input:
  +7.8-0.56E-12 ( numbers can't stick together)
  + 7.8,-0.56E-12 ( first '+' must be connected with the number )
  +(-7.8) -0.56E-12 ( multiple signs or paranthesis in number not supported.
  etc...

  4. The global variable DecimalSeparator (the dot in the examples) controls
  what character is actually used for separating the integral and fractional
  parts of a number. This setting is controlled by the current settings in
  the registry. If you are uncertain what separator your country use,
  check Control Panel | Country | Numbers.

  5. StringToComplex will raise an EConvertError (unhandled) if input isn't valid.
    To avoid this, call IsValidComplexString first.
}

function StringToComplex(S:string):TComplex;
const ValidNum = ['+','-','0'..'9','E','e'];
var i:integer;t:string;
begin
  T := '';
  i := 1;
  if S = '' then Exit;

  while i <= Length(S) do
  begin
    if (S[i] in Validnum) or (S[i] = DecimalSeparator) then
      T := T + S[i]
    else if Length(T) > 0 then
      Break;
    Inc(i);
  end;

  Result.Re := StrToFloat(T);
  T := '';

  while i <= Length(S) do
  begin
    if (S[i] in Validnum) or (S[i] = DecimalSeparator) then
      T := T + S[i];
    Inc(i);
  end;

  Result.Im := StrToFloat(T);
end;


{ Real return real part of Z }
function Real(Z:TComplex):Double;
begin
  Result := Z.re;
end;

{ Imag return imag part of Z }
function Imag(Z:TComplex):Double;
begin
  Result := Z.im;
end;

{ Standard Operators }

{ AddZZ add two complex numbers: (x + yi) + (v + wi) = (x + v) + i(y + w)}
function AddZZ(const Z,Z2:TComplex):TComplex;
begin
  Result := ToComplex(Z.re + Z2.re,Z.im + Z2.im);
end;

{ AddZR add a complex and a real: r + (x + yi) = (r + x) + yi}
function AddZR(const Z:TComplex;R:Double):TComplex;
begin
  Result := AddZZ(Z,ToComplex(R,0));
end;

{ SubZZ subtract two complex numbers: (x + yi) - (v + wi) = (x - v) + i(y -  w) }
function SubZZ(Z,Z2:TComplex):TComplex;
begin
  Result := ToComplex(Z.re - Z2.re,Z.im - Z2.im);
end;

{ SubZR subtract Z.re from R: (x +yi) - r = (x-r) + yi }
function SubZR(Z:TComplex;R:Double):TComplex;
begin
  Result := SubZZ(Z,ToComplex(R,0));
end;

{ SubRZ subtract R from Z.re: r - (x + yi) = (r-x) - yi  }
function SubRZ(R:Double;Z:TComplex):TComplex;
begin
  Result := SubZZ(ToComplex(R,0),Z);
end;

{ MulZZ multiply two complex numbers: (x + yi) * ( v + wi) = (xv - yw) + i(xw +yv)}
function MulZZ(Z,Z2:TComplex):TComplex;
begin
  Result := ToComplex(Z.re * Z2.re - Z.im * Z2.im, Z.re * Z2.im + Z.im * Z2.re);
end;

{ MulRZ multiply a real and a complex: r(x+yi) = rx + ryi }
function MulRZ(R:Double;Z:TComplex):TComplex;
begin
  Result := MulZZ(ToComplex(R,0),Z);
end;

{ DivZR divide Z with R ( Z/R ) - let compiler handle divbyzero: (x+yi) / r := x/r + yi/r }
function DivZR(Z:TComplex;R:Double):TComplex;
begin
  Result := ToComplex(Z.re / R, Z.Im / R);
end;

{ DivRZ divide R with Z ( R/Z) - let compiler handle divbyzero: r/(x + yi) := r/x + r/yi}
function DivRZ(R:Double;Z:TComplex):TComplex;
begin
  if (Z.re = 0) and (Z.im <> 0) then
    Result := ToComplex(0, R/Z.im)
  else
  if (Z.im = 0) and (Z.re <> 0) then
    Result := ToComplex(R/Z.re,0)
  else
    Result := ToComplex(R/Z.re,R/Z.im);
end;

{ DivZZ divide Z with Z2 ( Z/Z2) - let compiler handle divbyzero }
function DivZZ(Z,Z2:TComplex):TComplex;
var Zb,Z2b:TComplex;
begin
  Zb := MulZZ(Z,ConjugateZ(Z2));
  Z2b := MulZZ(Z2,ConjugateZ(Z2)); { this should be re now (im := 0) }
  Result := DivZR(Zb,Real(Z2b));
end;

{ Misc. complex specific }

{ AbsZ return absolute value of Z. ( sqrt(x*x + y*y)) }
function AbsZ(Z:TComplex):Double;
var x,y:Double;
begin
  x := Abs(Z.re);
  y := Abs(Z.im);
  if x = 0 then Result := y else
  if y = 0 then Result := x
  else
  begin
    if x > y then
      Result := x * Sqrt(1 + Power(y/x,2))
    else
      Result := y * Sqrt(1 + Power(x/y,2));
  end;
end;

{ ModZ is the same as AbsZ }
function ModZ(Z:TComplex):Double;
begin
  Result := AbsZ(Z);
end;

{ ArgZ return the argument of Z in radians: z = x + yi -> arctan(y/x) }
function ArgZ(Z:TComplex):Double;
begin
  Result := ArcTan2(Z.im,Z.re);
end;

{ ConjugateZ return conjugate of Z ((x + iy)~ = x - iy ) }
function ConjugateZ(Z:TComplex):TComplex;
begin
  Result := ToComplex(Z.re,-Z.im);
end;

{ NormZ return the square of the absolute value of Z:  |x + yi|^2 }
function NormZ(Z:TComplex):Double;
begin
  Result := Z.re * Z.re + Z.im * Z.im;
end;

{ NegZ return negated value of complex number: x + yi = -x - yi }
function NegZ(Z:TComplex):TComplex;
begin
  Result := ToComplex(-Z.re,-Z.im);
end;

{ EqualZZ test for equality }
function EqualZZ(Z,Z2:Tcomplex): boolean;
begin
  Result := ((Z.re = Z2.re) and (Z.im = Z2.im));
end;


{ Trigonometric }


{ CosZ return the cosine of Z }
function CosZ(Z:TComplex):TComplex;
begin
  Result := ToComplex( Cos(Z.re) * Cosh(Z.im), -(Sin(Z.re) * Sinh(Z.im)));
end;

{ ArcCosZ return the arccosine of Z. Input value must be between -1..1 and -i..i  }
function ArcCosZ(Z:TComplex):TComplex;
begin
  Result := ToComplex(ArcCos(Z.re) * ArcCosh(Z.im), ArcSin(Z.re) * ArcSinh(Z.im));
end;

{ CoshZ return the hyperbolic cosine of Z }
function CoshZ(Z:TComplex):TComplex;
begin
  Result := ToComplex(Cosh(Z.re) * Cos(Z.im), Sinh(Z.re) * Sin(Z.im));
end;

{ SinZ return the sine of Z }
function SinZ(Z:TComplex):TComplex;
begin
  Result := ToComplex(Sin(Z.re) * Cosh(Z.im), Cos(Z.re) * Sinh(Z.im));
end;

{ ArcSinZ return the arcsine of Z. Input value must be between -1..1 and -i..i }
function ArcSinZ(Z:TComplex):TComplex;
begin
  Result := ToComplex(ArcSin(Z.re) * ArcCosh(Z.im), ArcCos(Z.re) * ArcSinh(Z.im));
end;

{ SinhZ return the hyperbolic sine of Z }
function SinhZ(Z:TComplex):TComplex;
begin
  Result := ToComplex(Sinh(Z.re) * Cos(Z.im), Cosh(Z.re) * Sin(Z.im));
end;

{ ArcSinhZ return the hyperbolic arcsine of Z }
function ArcSinhZ(Z:TComplex):TComplex;
begin
  Result := ToComplex(-Z.im,Z.re);
  Result := ArcSinZ(Result);
  Result := ToComplex(Result.im,-Result.re);
end;

{ TanZ return the tan of Z }
function TanZ(Z:TComplex):TComplex;
var x,y,t:Double;
begin
  x := 2 * Z.re;
  y := 2 * z.im;
  t := 1.0 / (Cos(x) + Cosh(y));
  Result := ToComplex(t * Sin(x), t * Sinh(y));
end;

{ ArcTanZ return the arctan of Z. }
function ArcTanZ(Z:TComplex):TComplex;
var x,y,t:Double;
begin
  x := 2 * Z.re;
  y := 2 * z.im;
  t := 1.0 / (Cos(x) + Cosh(y));
  Result := ToComplex(t * ArcSin(x), t * ArcSinh(y));
end;

{ TanhZ retun the hyperbolic tan of Z }
function TanhZ(Z:TComplex):TComplex;
var x,y,t:Double;
begin
  x := 2 * Z.re;
  y := 2 * z.im;
  t := 1.0 / (Cos(x) + Cosh(y));
  Result := ToComplex(t * Sinh(x), t * Sin(y));
end;

{ ArcTanhZ return the hyperbolic arctan of Z. Input value must be between -1..1 and -i..i }
function ArcTanhZ(Z:TComplex):TComplex;
begin
  Result := ToComplex(-Z.im,Z.re);
  Result := ArcTanZ(Result);
  Result := ToComplex(Result.im,-Result.re);
end;


{ Math Functions }

{ ExpZ returns e raised to Z:  e^(x + yi) }
function ExpZ(Z:TComplex):TComplex;
var x:Double;
begin
  x := Exp(Z.re);
  Result := ToComplex(x * Cos(Z.im), x * Sin(Z.im));
end;

{ LnZ returns the natural log of Z:  Ln(x + iy)  }
function LnZ(Z:TComplex):TComplex;
begin
  Result := ToComplex(Ln(AbsZ(Z)), ArgZ(Z));
end;

{ Log10Z returns the base 10 log of Z:  log(x+yi) }
function Log10Z(Z:TComplex):TComplex;
begin
  Result := ToComplex(0.2171472409516259 * Ln(NormZ(Z)), ArgZ(Z));
end;

{ PolarZ returns the complex number given by the rectangular coordinates Range and Angle:
    z = r(cos(angle) + i sin(angle))
    Range is the length of the straight line extending from 0,0i to the point x,yi
    Angle is the angle in radians between the real axis and the point x,yi
 }
function PolarZ(Range,Angle:Double):TComplex;
begin
  Result := ToComplex(Range * Cos(Angle), Range * Sin(Angle));
end;

{ RectangularZ returns the rectangular coordinates Range and Angle of the complex number Z
(see explanation above) }
procedure RectangularZ(Z:TComplex;var Range,Angle:Double);
begin
  Angle := ArgZ(Z);
  Range := AbsZ(Z);
end;

{ SqrtZ return the Square root of Z: sqrt(x+yi) }
function SqrtZ(Z:TComplex):TComplex;
var a,b:Double;
begin
  if (Z.re = 0) and (Z.im = 0) then
     Result := ToComplex(1,0)
  else
  begin
    a := Sqrt((Abs(Z.re) + AbsZ(Z)) * 0.5);
    if Z.re >= 0 then
      b := Z.im / (a+a)
    else
    begin
      if Z.im < 0 then b := -a else b := a;
      a := Z.im / (b+b);
    end;
    Result := ToComplex(a,b);
  end;
end;

{ PowZZ return Z^Z2: (x+yi)^(v+wi) }
function PowZZ(Z,Z2:TComplex):TComplex;
var LogF,Phase:TComplex;
begin
  if (Z2.re = 0) and (Z2.im = 0) then  Result := ToComplex(1,0)
  else if Z2.im = 0 then Result := PowZR2(Z,Z2.re)
  else
  begin
    LogF.re := Ln(AbsZ(Z));
    LogF.im := ArcTan2(Z.im,Z.re);
    Phase.re := Exp(LogF.re * Z2.re - LogF.im * Z2.im);
    Phase.im := LogF.re * Z2.im + LogF.im * Z2.re;
    Result := ToComplex(Phase.re * Cos(Phase.im), Phase.re * Sin(Phase.im));
  end;
end;

{ PowZR1 return Z^R (R is int): (x+yi)^r }
function PowZR1(Z:TComplex;R:integer):TComplex;
begin
  Result := PowZZ(Z,ToComplex(R,0));
end;

{ PowZR2 return Z^R (R is real): (x +yi)^r }
function PowZR2(Z:TComplex;R:Double):TComplex;
begin
  Result := PowZZ(Z,ToComplex(R,0));
end;

{ PowRZ return R^Z: r^(x + yi) }
function PowRZ(R:Double;Z:TComplex):TComplex;
begin
  Result := PowZZ(ToComplex(R,0),Z);
end;

end.

