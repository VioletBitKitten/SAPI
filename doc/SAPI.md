# Free Pascal SAPI Documentation

## Summary

Free Pascal interface to Microsoft [SAPI](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125663(v=vs.85)) (Speech API).

This library implements the [SpVoice}(https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125640(v=vs.85)) and [SpFileStream](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125548(v=vs.85)) interfaces. The primary purpose of this library is to provide a simple interface for TTS.

## References

* Microsoft SAPI Documentation on the SpVoice interface.\
  <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125640(v=vs.85)>

* Microsoft SAPI Documentation on the SpFileStream  interface.\
  <https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125548(v=vs.85)>

* Python SAPI interface.\
  <https://github.com/DeepHorizons/tts/blob/master/tts/sapi.py>

* Lazarus Forum topic for preventing the SpVoice.Speak method from causing an exception.\
  <https://forum.lazarus.freepascal.org/index.php/topic,17852.0>

* Free Pascal Wiki page on SAPI.\
  <https://wiki.freepascal.org/SAPI>

## TSpVoice

SpVoice is the TTS (Text-To-Speech) interface in SAPI. Most of the SpVoice interface is implemented. Parts that are related to the UI and events have not been implemented.

For more information on the SpVoice interface please refer to the [Microsoft SpVoice documentation](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125640(v=vs.85)).

### TSpVoice Methods

#### TSpVoice.Create

Creates a new SpVoice object.

**Definition:**

```pascal
constructor TSpVoice.Create : TSpVoice
```

**Example:**

```pascal
var
  SpVoice : TSpVoice;
begin
  SpVoice := TSpVoice.Create;
end;
```

#### TSpVoice.GetAudioOutputs

Returns an object containing the available Audio Output Devices.

**Definition:**

```pascal
function TSpVoice.GetAudioOutputs : Variant;
```

The returned object has the following methods:

* Count : Integer - The number of items in the object.
* Item(ItemID) : Variant - A specific Audio Output Device. Use this object with the [TSpVoice.AudioOutput](#tspvoiceaudiooutput) property.

And object returned from Item method has the following method:

* GetDescription : String - The Audio Output Device name.

**Example:**
This code is taken from the [GetAudioOutputNames](#tspvoicegetaudiooutputnames) method implementation.

```pascal
var
  OutputToken : Variant;     { The current output in the for loop. }
  OutputIndex : Integer;     { Index in the for loop. }
  OutputList  : TstringList; { List of output descriptions to be returned. }
  Outputs     : Variant;     { The list of outputs from GetOutput. }
begin
  { Get an object containing the available voices. }
  Outputs := SpVoice.GetAudioOutputs;

  { Initialize the list of voices to be returned. }
  OutputList := TstringList.Create;

  { Get the description for each voice. }
  for OutputIndex := 0 to Outputs.Count - 1 do
  begin
    OutputToken := Outputs.Item(OutputIndex);
    OutputList.Add(OutputToken.GetDescription);
  end;
end;
```

[Microsoft SAPI Documentation for GetAudioOutputs](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125638(v=vs.85))

#### TSpVoice.GetAudioOutputNames

Get a list of Audio Output Device names. Useful for presenting to the user. Internally calls [TSpVoice.GetAudioOutputs](#tspvoicegetaudiooutputs).

**Definition:**

```pascal
function TSpVoice.GetAudioOutputNames : TstringList;
```

**Example:**

```pascal
var
  OutputIndex : Integer;
  Outputs : TstringList;
begin
  Outputs := SpVoice.GetAudioOutputNames();
  WriteLn('Available Audio Outputs:');
  for OutputIndex := 0 to Outputs.Count - 1 do
    WriteLn(OutputIndex, ' - ', Outputs[OutputIndex]);
end;
```

#### TSpVoice.GetVoices

Returns an object containing the available voices ued to speak text..

**Definition:**

```pascal
function TSpVoice.GetAudioOutputs : Variant;
```

The returned object has the following methods:

* Count : Integer - The number of items in the object.
* Item(ItemID) : Variant - A specific voice. Use this object with the [TSpVoice.AudioVoiceOutput](#tspvoicevoice) property.

And object returned from Item method has the following method:

* GetDescription : String - The voice name.

**Example:**
This code is taken from the [TSpVoice.GetVoiceNames](#tspvoicegetvoicenames) method implementation.

```pascal
var
  Voices     : Variant;     { The list of voices from GetVoices. }
  VoiceToken : Variant;     { The current voice in the for loop. }
  VoiceIndex : Integer;     { Index in the for loop. }
  VoiceList  : TstringList; { List of voice descriptions to be returned. }
begin
  { Get an object containing the available voices. }
  Voices := SpVoice.GetVoices;

  { Initialize the list of voices to be returned. }
  VoiceList := TstringList.Create;

  { Get the description for each voice. }
  for VoiceIndex := 0 to Voices.Count - 1 do
  begin
    VoiceToken := Voices.Item(VoiceIndex);
    VoiceList.Add(VoiceToken.GetDescription);
  end;
end;
```

[Microsoft SAPI Documentation for GetVoices](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125639(v=vs.85))

#### TSpVoice.GetVoiceNames

Get a list of Audio Output Device names. Intended for user interface. Internally calls [TSpVoice.GetVoices](#tspvoicegetvoices).

**Definition:**

```pascal
function TSpVoice.GetVoiceNames : TstringList;
```

**Example:**

```pascal
var
  VoiceIndex : Integer;
  Voices : TstringList;
begin
  Voices := SpVoice.GetVoiceNames();
  WriteLn('Available Voices:');
  for VoiceIndex := 0 to Voices.Count - 1 do
    WriteLn(VoiceIndex, ' - ', Voices[VoiceIndex]);
```

#### TSpVoice.SetAudioOutputID

Set the Output to be used when speaking text by the Output ID #. Intended for user interface. Internally calls [TSpVoice.GetAudioOutputs](#tspvoicegetaudiooutputs) and sets the property [TSpVoice.AudioOutput](#tspvoiceaudiooutput). See also the message `SpVoice_invalid_audio_output_id`.

**Definition:**

```pascal
procedure TSpVoice.SetAudioOutputID(OutputID : Integer);
```

**Example:**

```pascal
SpVoice.SetAudioOutputID(OutputID)
```

#### TSpVoice.SetAudioOutputName

Set the Output to be used when speaking text by the Output name. Intended for user interface. If an exact name match is not found a partial StartsWith match will be attempted. Internally calls [TSpVoice.GetAudioOutputs](#tspvoicegetaudiooutputs) and [TSpVoice.SetAudioOutputID](#tspvoicesetaudiooutputid). See also the message `SpVoice_invalid_audio_output_name`.

**Definition:**

```pascal
procedure TSpVoice.SetAudioOutputName(OutputName : String);
```

**Example:**

```pascal
SpVoice.SetAudioOutputName(OutputName);
```

#### TSpVoice.SetVoiceID

Set the voice to be used when speaking text by the Voice ID #. Intended for user interface. Internally calls [TSpVoice.GetVoices](#tspvoicegetvoices) and sets the property [TSpVoice.Voice](#tspvoicevoice). See also the message `SpVoice_invalid_voice_id`.

**Definition:**

```pascal
procedure TSpVoice.SetVoiceID(VoiceID : Integer);
```

**Example:**

```pascal
SpVoice.SetVoiceID(VoiceID)
```

#### TSpVoice.SetVoiceName

Set the Voice to be used when speaking text by the Voice name. Intended for user interface. If an exact name match is not found a partial StartsWith match will be attempted. Internally calls [TSpVoice.GetVoices](#tspvoicegetvoices) and [TSpVoice.SetVoiceID](#tspvoicesetvoiceid). See also the message `SpVoice_invalid_voice_name`.

**Definition:**

```pascal
procedure TSpVoice.SetVoiceName(VoiceName : String);
```

**Example:**

```pascal
SpVoice.SetVoiceName(VoiceName);
```

#### TSpVoice.Speak

Speaks a string of text.

**Definition:**

```pascal
procedure TSpVoice.Speak(Text : String; Flags : Integer);
```

**Example:**

```pascal
SpVoice.Speak('This is some text to be spoken.')
```

[Microsoft SAPI Documentation for Speak](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125647(v=vs.85))

#### TSpVoice.SpeakStream

Basically play a WAV file.

**Definition:**

```pascal
procedure TSpVoice.SpeakStream(Stream : Variant);
procedure TSpVoice.SpeakStream(Stream : TSpFileStream);
```

**Example:**

```pascal
SpVoice.SpeakStream(OutputStream);
```

[Microsoft SAPI Documentation for SpeakStream](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125649(v=vs.85))

#### TSpVoice.WaitUntilDone

Block until the voice has finished speaking when using the flag `SVSFlagsAsync`

**Definition:**

```pascal
function TSpVoice.WaitUntilDone : Boolean;
```

**Example:**

```pascal
SpVoice.WaitUntilDone
```

[Microsoft SAPI Documentation for WaitUntilDone](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125654(v=vs.85))

### SpVoice Properties

#### TSpVoice.AudioOutput

The output device speech is directed to. To set a voice use a returned value from the [GetAudioOutputs](#tspvoicegetaudiooutputs) method.

**Definition:**

```pascal
TSpVoice.AudioOutput : Variant // (Read/Write)
```

[Microsoft SAPI Documentation for AudioOutput](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125634(v=vs.85))

#### TSpVoice.AudioOutputStream

Stream speech is directed to. This is for writing speech to a file. Speech will not be sent to an audio output device. To set an output stream use the [TSpFileStream](#tspfilestream) class.

**Definition:**

```pascal
TSpVoice.AudioOutputStream : Variant // (Read/Write)
```

[Microsoft SAPI Documentation for AudioOutputStream](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125635(v=vs.85))

#### TSpVoice.Priority

The priority level speech is spoken at. Valid values 0 to 3. See also the message `SpVoice_priority_valid_values`.

**Definition:**

```pascal
TSpVoice.Priority : Integer // (Read/Write)
```

[Microsoft SAPI Documentation for Priority](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125643(v=vs.85))

#### TSpVoice.Rate

The rate (speed) text is spoken at. Valid values -10 to 10. See also the message `SpVoice_rate_valid_values`.

**Definition:**

```pascal
TSpVoice.Rate : Integer // (Read/Write)
```

[Microsoft SAPI Documentation for Rate](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125643(v=vs.85))

#### TSpVoice.Status

Returns the status and event details of the SpVoice object.

**Definition:**

```pascal
TSpVoice.Status : Variant // (Readonly)
```

**NOTE:** The property is implemented, but there are no accommodations for using the returned status. Please see the documentation for use.

[Microsoft SAPI Documentation for Status](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125650(v=vs.85))

#### TSpVoice.SynchronousSpeakTimeout

The timeout in milliseconds for the Speak and SpeakStream methods.

**Definition:**

```pascal
TSpVoice.SynchronousSpeakTimeout : Integer // (Read/Write)
```

[Microsoft SAPI Documentation for SynchronousSpeakTimeout](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125651(v=vs.85))

#### TSpVoice.Voice

The voice used to speak text. To set a voice use a returned value from the [GetVoices](#tspvoicegetvoices) method.

**Definition:**

```pascal
TSpVoice.Voice : Variant // (Read/Write)
```

[Microsoft SAPI Documentation for Voice](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125652(v=vs.85))

#### TSpVoice.Volume

The volume text is spoken at. Valid values 0 to 100. See also the message `Spvoice_volume_valid_values`.

**Definition:**

```pascal
TSpVoice.Volume : Integer // (Read/Write)
```

[Microsoft SAPI Documentation for Volume](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125653(v=vs.85))

### SpVoice Variables

#### TSpVoice.ExceptionsEnabled

When true exceptions are enabled for the following methods. When false out of range variables are set within normal ranges or are ignored.

Defaults to False.

Properties and methods affected by `TSpVoice.ExceptionsEnabled`.

* [TSpVoice.Priority](#tspvoicepriority) - Throws and exception when the value for the new priority is out of range.
* [TSpVoice.Rate](#tspvoicerate) - Throws and exception when the value for the new rate is out of range.
* [TSpVoice.Volume](#tspvoicevolume) - Throws and exception when the value for the new volume is out of range.
* [TSpVoice.SetAudioOutputID](#tspvoicesetaudiooutputid) - Throws an exception when the audio output device id is not valid.
* [TSpVoice.SetAudioOutputName](#tspvoicesetaudiooutputname) - Throws an exception when the audio output device name is not valid.
* [TSpVoice.SetVoiceID](#tspvoicesetvoiceid) - Throws an exception when the voice id is not valid.
* [TSpVoice.SetVoiceName](#tspvoicesetvoicename) - Throws an exception when the voice name is not valid.

**Definition:**

```pascal
ExceptionsEnabled : Boolean;
```

### SpVoice Flags

These flags are taken from the SpVoice [SpeechVoiceSpeakFlags](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125223(v=vs.85)) documentation.

```pascal
{ SpeechVoiceSpeakFlags Flags for the SpVoice Speak method. }
SVSFDefault          = 0;
SVSFlagsAsync        = 1;
SVSFPurgeBeforeSpeak = 2;
SVSFIsFilename       = 4;
SVSFIsXML            = 8;
SVSFIsNotXML         = 16;
SVSFPersistXML       = 32;
{ SpeechVoicePriority flags for the SpVoice Priority property. }
SVPNormal = 0;
SVPAlert  = 1;
SVPOver   = 2;
```

### SpVoice Messages

These messages are for use in SpVoice methods and applications that utilize the SpVoice class.

```pascal
SpVoice_invalid_audio_output_id   = 'Invalid Audio Output device ID.';
SpVoice_invalid_audio_output_name = 'Invalid Audio Output device name.';
SpVoice_invalid_voice_id          = 'Invalid Voice ID.';
SpVoice_invalid_voice_name        = 'Invalid Voice name.';
SpVoice_priority_valid_values     = 'Valid values 0 to 3.';
SpVoice_rate_valid_values         = 'Valid values -10 to 10.';
SpVoice_volume_valid_values       = 'Valid values 0 to 100';
```

## TSpFileStream

SpFileStream is an interface for working with files. In this library the primary purpose is creating WAV files from text and playing back WAV files. Only the Open and Close methods have been implemented.

For more information on the SpFileStream  interface please refer to the [Microsoft SpFileStream  documentation](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125548(v=vs.85)).

### SpFileStream Methods

#### TSpFileStream.Create

Creates a new SpVoice object.

**Definition:**

```pascal
constructor TSpFileStream.Create;
```

**Example:**

```pascal
var
  SpFileStream : TSpFileStream;
begin
  SpFileStream := TSpFileStream.Create;
end;
```

#### TSpFileStream.Close

Closes an output stream.

**Definition:**

```pascal
procedure TSpFileStream.Close;
```

**Example:**

```pascal
SpFileStream.Close
```

[Microsoft SAPI Documentation for Close](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125547(v=vs.85))

#### TSpFileStream.OpenStreamRead

Open a file stream for reading. This method calls `OpenStream(FileName, SSFMOpenForRead);`.

**Definition:**

```pascal
procedure TSpFileStream.OpenStreamRead(FileName : String);

```

**Example:**

```pascal
SpFileStream.OpenStreamRead(FileName)
```

#### TSpFileStream.OpenStreamWrite

Open a file stream for writing. This method calls `OpenStream(FileName, SSFMCreateForWrite);`.

**Definition:**

```pascal
procedure TSpFileStream.OpenStreamWrite(FileName : String);

```

**Example:**

```pascal
SpFileStream.OpenStreamWrite(FileName)
=
```

#### TSpFileStream.OpenStream

Opens a file stream.

**Definition:**

```pascal
procedure TSpFileStream.OpenStream(FileName : String; Flags : Integer);
```

**Example:**

```pascal
SpFileStream.OpenStream(FileName, SSFMCreateForWrite);
```

[Microsoft SAPI Documentation for OpenStream](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125549(v=vs.85))

### TSpFileStream Properties

#### TSpFileStream.Stream

Returns the actual SpFileStream object. Intended for use with [TSpVoice.SpeakStream](#tspvoicespeakstream).

**Definition:**

```pascal
TSpFileStreamStream : Variant // (REadonly)
```

### SpFileStream Flags

These flags are taken from the SpVoice [SpeechStreamFileMode](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/ee125214(v=vs.85)) documentation.

```pascal
{ SpeechStreamFileMode flags for the SpFileStream  Open method. }
SSFMOpenForRead    = 0;
SSFMOpenReadWrite  = 1; { Marked as hidden. }
SSFMCreate         = 2; { Marked as hidden. }
SSFMCreateForWrite = 3;
```

## Copyright and License

Copyright (c) 2023 Violet Bit Kitten

Distributed under the MIT license. Please see the file LICENSE.
