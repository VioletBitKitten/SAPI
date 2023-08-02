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
  variants, classes, comobj, sysutils, fpcunit, testregistry, sapi;

type
  TSAPITest = class(TTestCase)
  private
    SpVoice : TSpVoice;
    { Generate Exceptions }
    procedure RaisePriorityExceptionHigh;
    procedure RaisePriorityExceptionLow;
    procedure RaiseRateExceptionHigh;
    procedure RaiseRateExceptionLow;
    procedure RaiseVolumeExceptionHigh;
    procedure RaiseVolumeExceptionLow;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    { Test TSpVoice Methods }
    procedure TestSAPICreate;
    procedure TestSAPIGetAudioOutputs;
    procedure TestSAPIGetAudioOutputsNames;
    procedure TestSAPIGetVoices;
    procedure TestSAPIGetVoiceNames;
    { Test TSpVoice Properties }
    procedure TestSAPIAudioOutput;
    procedure TestSAPIAudioOutputStream;
    procedure TestSAPIPriority;
    procedure TestSAPIPriorityExceptions;
    procedure TestSAPIRate;
    procedure TestSAPIRateExceptions;
    procedure TestSAPIStatus;
    procedure TestSAPISynchronousSpeakTimeout;
    procedure TestSAPIVoice;
    procedure TestSAPIVolume;
    procedure TestSAPIVolumeExceptions;
  end;

implementation


{ ----------========== Generate Exceptions ==========---------- }

procedure TSAPITest.RaisePriorityExceptionHigh;
var
  NewSpVoice : TSpVoice;
begin
  NewSpVoice := TSpVoice.Create;
  NewSpVoice.ExceptionsEnabled := True;
  NewSpVoice.Priority := 3;
end;

procedure TSAPITest.RaisePriorityExceptionLow;
var
  NewSpVoice : TSpVoice;
begin
  NewSpVoice := TSpVoice.Create;
  NewSpVoice.ExceptionsEnabled := True;
  NewSpVoice.Priority := -1;
end;

procedure TSAPITest.RaiseRateExceptionHigh;
var
  NewSpVoice : TSpVoice;
begin
  NewSpVoice := TSpVoice.Create;
  NewSpVoice.ExceptionsEnabled := True;
  NewSpVoice.Rate := 11;
end;

procedure TSAPITest.RaiseRateExceptionLow;
var
  NewSpVoice : TSpVoice;
begin
  NewSpVoice := TSpVoice.Create;
  NewSpVoice.ExceptionsEnabled := True;
  NewSpVoice.Rate := -11;
end;

procedure TSAPITest.RaiseVolumeExceptionHigh;
var
  NewSpVoice : TSpVoice;
begin
  NewSpVoice := TSpVoice.Create;
  NewSpVoice.ExceptionsEnabled := True;
  NewSpVoice.Volume := 101;
end;

procedure TSAPITest.RaiseVolumeExceptionLow;
var
  NewSpVoice : TSpVoice;
begin
  NewSpVoice := TSpVoice.Create;
  NewSpVoice.ExceptionsEnabled := True;
  NewSpVoice.Volume := -1;
end;

{ ----------========== Protected Methods ==========---------- }

procedure TSAPITest.SetUp;
begin
  SpVoice := TSpVoice.Create;
end;

procedure TSAPITest.TearDown;
begin
  FreeAndNil(SpVoice);
end;

{ ----------========== Test TSpVoice Methods ==========---------- }

procedure TSAPITest.TestSAPICreate;
var
  NewSpVoice : TSpVoice;
begin
  NewSpVoice := TSpVoice.Create;
  AssertEquals('Exceptions should be disabled by default.', False, NewSpVoice.ExceptionsEnabled);
end;

procedure TSAPITest.TestSAPIGetAudioOutputs;
var
  Outputs : Variant;
begin
  Outputs := SpVoice.GetAudioOutputs;
  AssertTrue('There should be at least one available Audio Output.',(Outputs.Count >= 1));
end;

procedure TSAPITest.TestSAPIGetAudioOutputsNames;
var
  OutputNames : TstringList;
begin
  OutputNames := SpVoice.GetAudioOutputNames;
  AssertTrue('There should be at least one available Audio Output.',(OutputNames.Count >= 1));
end;

procedure TSAPITest.TestSAPIGetVoices;
var
  Voices : Variant;
begin
  Voices := SpVoice.GetVoices;
  AssertTrue('There should be at least one available Voice.', (Voices.Count >= 1));
end;

procedure TSAPITest.TestSAPIGetVoiceNames;
var
  VoiceNames : TstringList;
begin
  VoiceNames := SpVoice.GetVoiceNames;
  AssertTrue('There should be at least one available Voice.', (VoiceNames.Count >= 1));
end;

{ ----------========== Test TSpVoice Properties ==========---------- }

procedure TSAPITest.TestSAPIAudioOutput;
var
  Output : Variant;
begin
  Output := SpVoice.AudioOutput;
  // TODO: Better test for this.
  AssertTrue('Audio Output Device should have a description.', (length(Output.GetDescription) >= 0));
end;

procedure TSAPITest.TestSAPIAudioOutputStream;
var
  OutputStream : Variant;
begin
  OutputStream := SpVoice.AudioOutputStream;
  // TODO: Better test for this.
  AssertFalse('Audio Output Stream should be defined.', VarIsNull(OutputStream));
end;

procedure TSAPITest.TestSAPIPriority;
var
  NewSpVoice : TSpVoice;
begin
  NewSpVoice := TSpVoice.Create;
  AssertEquals('The SpVoice Priority should be zero by default.', 0, NewSpVoice.Priority);
  NewSpVoice.Priority := 1;
  AssertEquals('The SpVoice Priority should be one after being set to 1.', 1, NewSpVoice.Priority);

  { With Exceptions disabled setting Priority out of bounds should not generate an Exception. }
  NewSpVoice.Priority := 3;
  AssertEquals('The SpVoice Priority should be two after being set to 3.', 2, NewSpVoice.Priority);
  NewSpVoice.Priority := -1;
  AssertEquals('The SpVoice Priority should be zero after being set to -1.', 0, NewSpVoice.Priority);
end;

procedure TSAPITest.TestSAPIPriorityExceptions;
begin
  { Set the Priority out of bounds to make sure Exceptions are generated. }
  AssertException(
    'With Exceptions enabled setting Priority to 3 should generate an Exception',
    EArgumentOutOfRangeException,
    @RaisePriorityExceptionHigh,
    SpVoice_priority_valid_values
  );
  AssertException(
    'With Exceptions enabled setting Priority to -1 should generate an Exception',
    EArgumentOutOfRangeException,
    @RaisePriorityExceptionLow,
    SpVoice_priority_valid_values
  );
end;

procedure TSAPITest.TestSAPIRate;
var
  NewSpVoice : TSpVoice;
begin
  NewSpVoice := TSpVoice.Create;

  AssertEquals('The SpVoice raRatete should be zero by default.', 0, NewSpVoice.Rate);
  NewSpVoice.Rate := 10;
  AssertEquals('The SpVoice Rate should be ten after being set to 10.', 10, NewSpVoice.Rate);

  { With Exceptions disabled setting Rate out of bounds should not generate an Exception. }
  NewSpVoice.Rate := 11;
  AssertEquals('The SpVoice Rate should be ten after being set to 11.', 10, NewSpVoice.Rate);
  NewSpVoice.Rate := -11;
  AssertEquals('The SpVoice Rate should be negative ten after being set to -11.', -10, NewSpVoice.Rate);
end;

procedure TSAPITest.TestSAPIRateExceptions;
begin
  { Set the Rate out of bounds to make sure Exceptions are generated. }
  AssertException(
    'With Exceptions enabled setting Rate to 11 should generate an Exception',
    EArgumentOutOfRangeException,
    @RaiseRateExceptionHigh,
    SpVoice_rate_valid_values
  );
  AssertException(
    'With Exceptions enabled setting Rate to -11 should generate an Exception',
    EArgumentOutOfRangeException,
    @RaiseRateExceptionLow,
    SpVoice_rate_valid_values
  );
end;

procedure TSAPITest.TestSAPIStatus;
var
  NewSpVoice : TSpVoice;
  Status     : Variant;
begin
  NewSpVoice := TSpVoice.Create;
  Status := NewSpVoice.Status;
  { Check the status before speaking text. }
  AssertEquals('The SpVoice Status RunningState should be one before speaking.', 1, Status.RunningState);
  AssertEquals('The SpVoice Status CurrentStreamNumber should be zero before speaking.', 0, Status.CurrentStreamNumber);
  AssertEquals('The SpVoice Status LastStreamNumberQueued should be zero before speaking.', 0, Status.LastStreamNumberQueued);

  { Set the volume to 0 and speak some text to change the status. }
  NewSpVoice.Volume := 0;
  NewSpVoice.Speak('Test Text.');

  { The Status.CurrentStreamNumber should be different now. }
  Status := NewSpVoice.Status;
  AssertEquals('The SpVoice Status CurrentStreamNumber should be one after speaking.', 1, Status.CurrentStreamNumber);
  AssertEquals('The SpVoice Status LastStreamNumberQueued should be one before speaking.', 1, Status.LastStreamNumberQueued);
end;

procedure TSAPITest.TestSAPISynchronousSpeakTimeout;
var
  NewSpVoice : TSpVoice;
begin
  NewSpVoice := TSpVoice.Create;
  AssertEquals('The SpVoice SynchronousSpeakTimeout should be 10000 by default.', 10000, NewSpVoice.SynchronousSpeakTimeout);
  NewSpVoice.SynchronousSpeakTimeout := 0;
  AssertEquals('The SpVoice SynchronousSpeakTimeout should be zero after being set to 0.', 0, NewSpVoice.SynchronousSpeakTimeout);
end;

procedure TSAPITest.TestSAPIVoice;
var
  Voice : Variant;
begin
  Voice := SpVoice.Voice;
  // TODO: Better test for this.
  AssertTrue('Audio Output Device should have a description.', (length(Voice.GetDescription) >= 0));
end;

procedure TSAPITest.TestSAPIVolume;
var
  NewSpVoice : TSpVoice;
begin
  NewSpVoice := TSpVoice.Create;
  AssertEquals('The SpVoice Volume should be one hundred by default.', 100, NewSpVoice.Volume);
  NewSpVoice.Volume := 1;
  AssertEquals('The SpVoice Volume should be one after being set to 1.', 1, NewSpVoice.Volume);

  { With Exceptions disabled setting Volume out of bounds should not generate an Exception. }
  NewSpVoice.Volume := 101;
  AssertEquals('The SpVoice Volume should be onehundred after being set to 101.', 100, NewSpVoice.Volume);
  NewSpVoice.Volume := -1;
  AssertEquals('The SpVoice Volume should be zero after being set to -1.', 0, NewSpVoice.Volume);
end;

procedure TSAPITest.TestSAPIVolumeExceptions;
begin
  { Set the Volume out of bounds to make sure Exceptions are generated. }
  AssertException(
    'With Exceptions enabled setting Volume to 101 should generate an Exception',
    EArgumentOutOfRangeException,
    @RaiseVolumeExceptionHigh,
    Spvoice_volume_valid_values
  );
  AssertException(
    'With Exceptions enabled setting Volume to -1 should generate an Exception',
    EArgumentOutOfRangeException,
    @RaiseVolumeExceptionLow,
    Spvoice_volume_valid_values
  );
end;

initialization

  RegisterTests([TSAPITest]);

end.