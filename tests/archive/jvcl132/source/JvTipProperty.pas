{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvTipProperty.PAS, released on 2002-05-26.

The Initial Developer of the Original Code is Peter Th?rnqvist [peter3@peter3.com]
Portions created by Peter Th?rnqvist are Copyright (C) 2002 Peter Th?rnqvist.
All Rights Reserved.

Contributor(s):            

Last Modified: 2002-05-26

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$I JEDI.INC}

{ Property editor for the TJvTipWindow components }

unit JvTipProperty;


interface
uses
  {$IFDEF Delphi6_UP}DesignEditors,DesignIntf{$ELSE}DsgnIntf{$ENDIF};
type
  { a component editor that by default opens the editor for the Items property in TTimeline }
  TJvTipPropertyEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index:integer);override;
    procedure Edit;override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

resourcestring
  SEditProperty = 'Preview...';

implementation
uses
  SysUtils, JvTipWin;

{ TJvTipPropertyEditor }

procedure TJvTipPropertyEditor.Edit;
begin
 {$IFDEF Delphi6_UP}
  (GetComponent as TJvTipWindow).Execute;
{$ELSE}
if Component is TJvTipWindow then
TJvTipWindow(Component).Execute;
{$ENDIF}
end;

procedure TJvTipPropertyEditor.ExecuteVerb(Index: integer);
begin
  if Index = 0 then Edit else inherited;
end;

function TJvTipPropertyEditor.GetVerb(Index: Integer): string;
begin
  if Index = 0 then Result := SEditProperty else Result := '';
end;

function TJvTipPropertyEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

end.
