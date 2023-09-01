{
  Unit tests for the Free Pascal interface to Microsoft SAPI.

  https://github.com/VioletBitKitten/SAPI

  Copyright (c) 2023 Violet Bit Kitten

  Distributed under the MIT license. Please see the file LICENSE.
}

{ Modern Pascal Directives }
{$mode objfpc}{$H+}{$J-}
{$warn 6058 off} // Stop the annoying "marked as inline is not inlined" errors.

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
    procedure TestSAPISetAudioOutputID;
    procedure TestSAPISetAudioOutputName;
    procedure TestSAPISetVoiceID;
    procedure TestSAPISetVoiceName;
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
begin
  SpVoice.ExceptionsEnabled := True;
  SpVoice.Priority := 3;
end;

procedure TSAPITest.RaisePriorityExceptionLow;
begin
  SpVoice.ExceptionsEnabled := True;
  SpVoice.Priority := -1;
end;

procedure TSAPITest.RaiseRateExceptionHigh;
begin
  SpVoice.ExceptionsEnabled := True;
  SpVoice.Rate := 11;
end;

procedure TSAPITest.RaiseRateExceptionLow;
begin
  SpVoice.ExceptionsEnabled := True;
  SpVoice.Rate := -11;
end;

procedure TSAPITest.RaiseVolumeExceptionHigh;
begin
  SpVoice.ExceptionsEnabled := True;
  SpVoice.Volume := 101;
end;

procedure TSAPITest.RaiseVolumeExceptionLow;
begin
  SpVoice.ExceptionsEnabled := True;
  SpVoice.Volume := -1;
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
begin
  SpVoice := TSpVoice.Create;
  AssertEquals('Exceptions should be disabled by default.', False, SpVoice.ExceptionsEnabled);
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

procedure TSAPITest.TestSAPISetAudioOutputID;
var
  OutputNames : TstringList;
  NewOutput   : Variant;
begin
  OutputNames := SpVoice.GetAudioOutputNames;
  SpVoice.SetAudioOutputID(1);
  NewOutput := SpVoice.AudioOutput;
  AssertEquals('The new Audio Output should match the voice output.', OutputNames[1], NewOutput.GetDescription);
end;

procedure TSAPITest.TestSAPISetAudioOutputName;
var
  OutputNames : TstringList;
  NewOutput   : Variant;
begin
  OutputNames := SpVoice.GetAudioOutputNames;
  SpVoice.SetAudioOutputName(OutputNames[1]);
  NewOutput := SpVoice.AudioOutput;
  AssertEquals('The new Audio Output match the voice output.', OutputNames[1], NewOutput.GetDescription);
end;

procedure TSAPITest.TestSAPISetVoiceID;
var
  VoiceNames : TstringList;
  NewVoice   : Variant;
begin
  VoiceNames := SpVoice.GetVoiceNames;
  SpVoice.SetVoiceID(1);
  NewVoice := SpVoice.Voice;
  AssertEquals('The new voice should match the voice set.', VoiceNames[1], NewVoice.GetDescription);
end;

procedure TSAPITest.TestSAPISetVoiceName;
var
  VoiceNames : TstringList;
  NewVoice   : Variant;
begin
  VoiceNames := SpVoice.GetVoiceNames;
  SpVoice.SetVoiceName(VoiceNames[1]);
  NewVoice := SpVoice.Voice;
  AssertEquals('The new voice should match the voice set.', VoiceNames[1], NewVoice.GetDescription);
end;

{ ----------========== Test TSpVoice Properties ==========---------- }

procedure TSAPITest.TestSAPIAudioOutput;
var
  Output : Variant;
begin
  Output := SpVoice.AudioOutput;
  // TODO: Better test for this.
  AssertFalse('Audio Output Device should be defined.', VarIsNull(Output));

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
begin
  AssertEquals('The SpVoice Priority should be zero by default.', 0, SpVoice.Priority);
  SpVoice.Priority := 1;
  AssertEquals('The SpVoice Priority should be one after being set to 1.', 1, SpVoice.Priority);

  { With Exceptions disabled setting Priority out of bounds should not generate an Exception. }
  SpVoice.Priority := 3;
  AssertEquals('The SpVoice Priority should be two after being set to 3.', 2, SpVoice.Priority);
  SpVoice.Priority := -1;
  AssertEquals('The SpVoice Priority should be zero after being set to -1.', 0, SpVoice.Priority);
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
begin
  AssertEquals('The SpVoice raRatete should be zero by default.', 0, SpVoice.Rate);
  SpVoice.Rate := 10;
  AssertEquals('The SpVoice Rate should be ten after being set to 10.', 10, SpVoice.Rate);

  { With Exceptions disabled setting Rate out of bounds should not generate an Exception. }
  SpVoice.Rate := 11;
  AssertEquals('The SpVoice Rate should be ten after being set to 11.', 10, SpVoice.Rate);
  SpVoice.Rate := -11;
  AssertEquals('The SpVoice Rate should be negative ten after being set to -11.', -10, SpVoice.Rate);
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
  Status     : Variant;
begin
  Status := SpVoice.Status;
  { Check the status before speaking text. }
  AssertEquals('The SpVoice Status RunningState should be one before speaking.', 1, Status.RunningState);
  AssertEquals('The SpVoice Status CurrentStreamNumber should be zero before speaking.', 0, Status.CurrentStreamNumber);
  AssertEquals('The SpVoice Status LastStreamNumberQueued should be zero before speaking.', 0, Status.LastStreamNumberQueued);

  { Set the volume to 0 and speak some text to change the status. }
  SpVoice.Volume := 0;
  SpVoice.Speak('Test Text.');

  { The Status.CurrentStreamNumber should be different now. }
  Status := SpVoice.Status;
  AssertEquals('The SpVoice Status CurrentStreamNumber should be one after speaking.', 1, Status.CurrentStreamNumber);
  AssertEquals('The SpVoice Status LastStreamNumberQueued should be one after speaking.', 1, Status.LastStreamNumberQueued);
end;

procedure TSAPITest.TestSAPISynchronousSpeakTimeout;
begin
  AssertEquals('The SpVoice SynchronousSpeakTimeout should be 10000 by default.', 10000, SpVoice.SynchronousSpeakTimeout);
  SpVoice.SynchronousSpeakTimeout := 0;
  AssertEquals('The SpVoice SynchronousSpeakTimeout should be zero after being set to 0.', 0, SpVoice.SynchronousSpeakTimeout);
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
begin
  AssertEquals('The SpVoice Volume should be one hundred by default.', 100, SpVoice.Volume);
  SpVoice.Volume := 1;
  AssertEquals('The SpVoice Volume should be one after being set to 1.', 1, SpVoice.Volume);

  { With Exceptions disabled setting Volume out of bounds should not generate an Exception. }
  SpVoice.Volume := 101;
  AssertEquals('The SpVoice Volume should be onehundred after being set to 101.', 100, SpVoice.Volume);
  SpVoice.Volume := -1;
  AssertEquals('The SpVoice Volume should be zero after being set to -1.', 0, SpVoice.Volume);
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