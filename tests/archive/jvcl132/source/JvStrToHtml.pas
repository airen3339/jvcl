{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvStrToHtml.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is Sébastien Buysse [sbuysse@buypin.com]
Portions created by Sébastien Buysse are Copyright (C) 2001 Sébastien Buysse.
All Rights Reserved.

Contributor(s): Michael Beck [mbeck@bigfoot.com].

Last Modified: 2000-02-28

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$I JEDI.INC}

unit JvStrToHtml;

{$OBJEXPORTALL On}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, JvComponent;

type
  TJvStrToHtml = class(TJvComponent)
  private
    FHtml: string;
    FValue: string;
    procedure SetHtml(const Value: string);
    procedure SetValue(const Value: string);
  protected
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Text: string read FValue write SetValue;
    property Html: string read FHtml write SetHtml;
    function TextToHtml(Text: string): string;
    function HtmlToText(Text: string): string;
  end;

function StringToHtml(Value: string): string;
function HtmlToString(Value: string): string;
function CharToHtml(Ch: Char): string;

implementation

type
  TJvHtmlCodeRec = record
    Ch: Char;
    Html: string;
  end;

const
  Conversions: array[1..79] of TJvHtmlCodeRec = (
    (Ch: '"'; Html: '&quot;'),
    (Ch: 'ŕ'; Html: '&agrave;'),
    (Ch: 'ç'; Html: '&ccedil;'),
    (Ch: 'é'; Html: '&eacute;'),
    (Ch: 'č'; Html: '&egrave;'),
    (Ch: 'ę'; Html: '&ecirc;'),
    (Ch: 'ů'; Html: '&ugrave;'),
    (Ch: 'ë'; Html: '&euml;'),
    (Ch: '<'; Html: '&lt;'),
    (Ch: '>'; Html: '&gt;'),
    (Ch: '^'; Html: '&#136;'),
    (Ch: '~'; Html: '&#152;'),
    (Ch: 'Ł'; Html: '&#163;'),
    (Ch: '§'; Html: '&#167;'),
    (Ch: '°'; Html: '&#176;'),
    (Ch: '˛'; Html: '&#178;'),
    (Ch: 'ł'; Html: '&#179;'),
    (Ch: 'ľ'; Html: '&#181;'),
    (Ch: 'ˇ'; Html: '&#183;'),
    (Ch: 'ź'; Html: '&#188;'),
    (Ch: '˝'; Html: '&#189;'),
    (Ch: 'ż'; Html: '&#191;'),
    (Ch: 'Ŕ'; Html: '&#192;'),
    (Ch: 'Á'; Html: '&#193;'),
    (Ch: 'Â'; Html: '&#194;'),
    (Ch: 'Ă'; Html: '&#195;'),
    (Ch: 'Ä'; Html: '&#196;'),
    (Ch: 'Ĺ'; Html: '&#197;'),
    (Ch: 'Ć'; Html: '&#198;'),
    (Ch: 'Ç'; Html: '&#199;'),
    (Ch: 'Č'; Html: '&#200;'),
    (Ch: 'É'; Html: '&#201;'),
    (Ch: 'Ę'; Html: '&#202;'),
    (Ch: 'Ë'; Html: '&#203;'),
    (Ch: 'Ě'; Html: '&#204;'),
    (Ch: 'Í'; Html: '&#205;'),
    (Ch: 'Î'; Html: '&#206;'),
    (Ch: 'Ď'; Html: '&#207;'),
    (Ch: 'Ń'; Html: '&#209;'),
    (Ch: 'Ň'; Html: '&#210;'),
    (Ch: 'Ó'; Html: '&#211;'),
    (Ch: 'Ô'; Html: '&#212;'),
    (Ch: 'Ő'; Html: '&#213;'),
    (Ch: 'Ö'; Html: '&#214;'),
    (Ch: 'Ů'; Html: '&#217;'),
    (Ch: 'Ú'; Html: '&#218;'),
    (Ch: 'Ű'; Html: '&#219;'),
    (Ch: 'Ü'; Html: '&#220;'),
    (Ch: 'Ý'; Html: '&#221;'),
    (Ch: 'ß'; Html: '&#223;'),
    (Ch: 'ŕ'; Html: '&#224;'),
    (Ch: 'á'; Html: '&#225;'),
    (Ch: 'â'; Html: '&#226;'),
    (Ch: 'ă'; Html: '&#227;'),
    (Ch: 'ä'; Html: '&#228;'),
    (Ch: 'ĺ'; Html: '&#229;'),
    (Ch: 'ć'; Html: '&#230;'),
    (Ch: 'ç'; Html: '&#231;'),
    (Ch: 'č'; Html: '&#232;'),
    (Ch: 'é'; Html: '&#233;'),
    (Ch: 'ę'; Html: '&#234;'),
    (Ch: 'ë'; Html: '&#235;'),
    (Ch: 'ě'; Html: '&#236;'),
    (Ch: 'í'; Html: '&#237;'),
    (Ch: 'î'; Html: '&#238;'),
    (Ch: 'ď'; Html: '&#239;'),
    (Ch: 'ń'; Html: '&#241;'),
    (Ch: 'ň'; Html: '&#242;'),
    (Ch: 'ó'; Html: '&#243;'),
    (Ch: 'ô'; Html: '&#244;'),
    (Ch: 'ő'; Html: '&#245;'),
    (Ch: 'ö'; Html: '&#246;'),
    (Ch: '÷'; Html: '&#247;'),
    (Ch: 'ů'; Html: '&#249;'),
    (Ch: 'ú'; Html: '&#250;'),
    (Ch: 'ű'; Html: '&#251;'),
    (Ch: 'ü'; Html: '&#252;'),
    (Ch: 'ý'; Html: '&#253;'),
    (Ch: '˙'; Html: '&#255;')
    );

  {**************************************************}

function _StringReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags): string;
var
  i: integer;
  SearchStr,
    Patt: string;
  ChStart,
    ChPatt: PChar;
  OldPattLen: integer;
  NewPattLen: integer;
  Delta: integer;
begin
  result := S;
  OldPattLen := Length(OldPattern);
  NewPattLen := Length(NewPattern);
  if rfIgnoreCase in Flags then
  begin
    SearchStr := ANSIUppercase(S);
    Patt := ANSIUpperCase(OldPattern);
  end
  else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  if OldPattLen > NewPattLen then
  begin                                 // We may do only one string truncation
    ChStart := PChar(SearchStr);
    ChPatt := ChStart;
    Delta := 0;
    while true do
    begin
      ChPatt := StrPos(ChPatt, PChar(Patt));
      if ChPatt = nil then
        break;
      Move(NewPattern[1], result[ChPatt - ChStart + 1 - Delta], NewPattLen);
      Move(result[(ChPatt - ChStart - Delta) + OldPattLen + 1],
        result[ChPatt - ChStart + NewPattLen + 1 - Delta],
        Length(Result) - (ChPatt - ChStart - Delta) - OldPattLen);
      Delta := Delta + OldPattLen - NewPattLen; // Keep track of difference in positions between S and result
      if not (rfReplaceAll in Flags) then
        break;
      inc(ChPatt);
    end;
    SetLength(Result, Length(Result) - Delta);
  end
  else if OldPattLen < NewPattLen then
  begin                                 // The slowest, needs to enlarge string for each replacement
    ChStart := PChar(SearchStr);
    ChPatt := ChStart;
    Delta := 0;
    while true do
    begin
      ChPatt := StrPos(ChPatt, PChar(Patt));
      if ChPatt = nil then
        break;
      SetLength(Result, Length(Result) + NewPattLen - OldPattLen);
      Move(result[(ChPatt - ChStart) + Delta + OldPattLen + 1],
        result[(ChPatt - ChStart) + (NewPattLen) + Delta + 1],
        Length(Result) - (ChPatt - ChStart) - Delta - NewPattLen);
      Move(NewPattern[1], result[ChPatt - ChStart + 1 + Delta], NewPattLen);
      Delta := Delta + (NewPattLen - OldPattLen); // Keep track of difference in positions between S and result
      if not (rfReplaceAll in Flags) then
        break;
      inc(ChPatt);
    end;
  end
  else if OldPattLen = 1 then
  begin                                 // Just replace Chars...
    for i := 1 to Length(SearchStr) do
      if SearchStr[i] = Patt[1] then
      begin
        result[i] := NewPattern[1];
        if not (rfReplaceAll in Flags) then
          break;
      end;
  end
  else
  begin                                 // Equal length, but more than 1 char...keep length, move chars
    ChStart := PChar(SearchStr);
    ChPatt := ChStart;
    while true do
    begin
      ChPatt := StrPos(ChPatt, PChar(Patt));
      if ChPatt = nil then
        break;
      Move(NewPattern[1], result[ChPatt - ChStart + 1], OldPattLen);
      if not (rfReplaceAll in Flags) then
        break;
      inc(ChPatt);
    end;
  end;
end;

{**************************************************}

constructor TJvStrToHtml.Create(AOwner: TComponent);
begin
  inherited;
  FValue := '';
  FHtml := '';
end;

{**************************************************}

function TJvStrToHtml.HtmlToText(Text: string): string;
begin
  Result := HtmlToString(Text);
end;

{**************************************************}

procedure TJvStrToHtml.SetHtml(const Value: string);
begin
  FValue := HtmlToString(Value);
end;

{**************************************************}

procedure TJvStrToHtml.SetValue(const Value: string);
begin
  FHtml := StringToHtml(Value);
end;

{**************************************************}

function TJvStrToHtml.TextToHtml(Text: string): string;
begin
  Result := StringToHtml(Text);
end;

{**************************************************}

// (rom) this is silly. Better base the component methods on the functions.
// (p3) seconded

function StringToHtml(Value: string): string;
var i:integer;
begin
  Result := Value;
  // (p3) this is *very* slow - please rewrite
  for i := Low(Conversions) to High(Conversions) do
    Result := _StringReplace(Result, Conversions[i].Html, Conversions[i].Ch,
      [rfReplaceAll, rfIgnoreCase]);
end;

{**************************************************}

function HtmlToString(Value: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Value) do
    Result := Result + CharToHtml(Value[I]);
end;

function CharToHtml(Ch: Char): string;
var
  I: Integer;
begin
  for I := Low(Conversions) to High(Conversions) do
    if Conversions[I].Ch = Ch then
    begin
      Result := Conversions[I].Html;
      Exit;
    end;
  Result := Ch;
end;

end.

