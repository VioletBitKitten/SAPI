{
  TTS demo program using the Free Pascal SAPI Library.
  This file is only meant to demonstrate how to use the SAPI library.

  https://github.com/VioletBitKitten/SAPI

  Copyright (c) 2023 Violet Bit Kitten

  Distributed under the MIT license. Please see the file LICENSE.
}

{ Modern Pascal Directives }
{$mode objfpc}{$H+}{$J-}

{ Demo program for the SAPI Library. }
program ttsdemo;

uses
  comobj, classes, sapi;

{ Write a list of available voices, along with the Voice ID #, to STDOUT. }
procedure ListVoices(SpVoice : TSpVoice);
var
  VoiceIndex : Integer;
  Voices :     TstringList;
begin
  Voices := SpVoice.GetVoiceNames();
  for VoiceIndex := 0 to Voices.Count - 1 do
    WriteLn(VoiceIndex, ' - ', Voices[VoiceIndex]);
end;

{ Write a list of audio outputs, along with the output ID #, to STDOUT. }
procedure ListOutputs(SpVoice : TSpVoice);
var
  OutputIndex : Integer;
  Outputs :     TstringList;
begin
  Outputs := SpVoice.GetAudioOutputNames();
  for OutputIndex := 0 to Outputs.Count - 1 do
    WriteLn(OutputIndex, ' - ', Outputs[OutputIndex]);
end;

{ Change the voice to ID # 1. }
procedure ChangeVoice(SpVoice : TSpVoice);
var
  Voices : TstringList;
begin
  Voices := SpVoice.GetVoiceNames();
  WriteLn('Setting voice to ', Voices[1]);
  SpVoice.SetVoiceID(1);
end;

procedure RunDemo();
var
  SpVoice : TSpVoice;
  Text :    String;
begin
  SpVoice := TSpVoice.Create;
  WriteLn('Curent Audio Output: ', SpVoice.AudioOutput.GetDescription);
  WriteLn();

  WriteLn('Available Audio Outputs:');
  ListOutputs(SpVoice);
  WriteLn();

  WriteLn('Curent Voice: ', SpVoice.Voice.GetDescription);
  WriteLn();

  WriteLn('Available Vouces:');
  ListVoices(SpVoice);
  WriteLn();

  ChangeVoice(SpVoice);
  WriteLn();

  WriteLn('Curent Rate: ', SpVoice.Rate);
  WriteLn();

  WriteLn('Curent Volume: ', SpVoice.Volume);
  WriteLn();

  WriteLn('Curent Priority: ', SpVoice.Priority);
  WriteLn();

  WriteLn('Enter text to be spoken.');
  ReadLn(Text);

  SpVoice.SetVoiceID(1);
  WriteLn('Speaking...');
  SpVoice.Speak(Text);

  WriteLn('Speaking asynchronously...');
  SpVoice.Speak(Text, SVSFlagsAsync);
  WriteLn('Waiting until text has been spoken...');
  SpVoice.WaitUntilDone();

  WriteLn('Faster (Rate = 5)...');
  SpVoice.Rate := 5;
  SpVoice.Speak(Text);
end;

begin
  RunDemo();
end.