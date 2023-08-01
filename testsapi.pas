{
  Unit tests for the Free Pascal interface to Microsoft SAPI.

  https://github.com/VioletBitKitten/SAPI

  Copyright (c) 2023 Violet Bit Kitten

  Distributed under the MIT license. Please see the file LICENSE.
}

{ Modern Pascal Directives }
{$mode objfpc}{$H+}{$J-}

unit testsapi;

interface

uses
  classes, comobj, sysutils, fpcunit, testregistry, sapi;

type
  TSAPITest = class(TTestCase)
  private
    SpVoice      : TSpVoice;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSAPICreate;
    procedure TestSAPIStatus;
  end;

implementation

procedure TSAPITest.SetUp;
begin
  SpVoice := TSpVoice.Create;
end;

procedure TSAPITest.TearDown;
begin

end;

procedure TSAPITest.TestSAPICreate;
begin
  AssertEquals('Exceptions should be disabled by default', False, SpVoice.ExceptionsEnabled);
end;

procedure TSAPITest.TestSAPIStatus;
var
  Status : Variant;
begin
  Status := SpVoice.Status;
  AssertTrue('The SpVoice Status RunningState should be positive', (Status.RunningState >= 0));
end;

initialization

  RegisterTests([TSAPITest]);

end.