# song

an open source song for norns

---

```
To see a World in a Grain of Sand
And a Heaven in a Wild Flower 
Hold Infinity in the palm of your hand 
And Eternity in an hour
```

Auguries of Innocence
By William Blake

## abstract

much has been explored on norns with interactive instruments and tools, but what about a single static/pre-scripted/unchanging/microchanging composition? what possibilities exist within the context of a _song_? songs, of course, can be different each time they are played/performed...

auguries of innocence from william blake has really resonated with me this year. infinity in the palm of your hand is an apt metaphor for phones in 2020... i thought this would be a nice theme in the spirit of the perenial [disquiet junto](https://disquiet.com/).

## contributing

- fork this repo
- make any changes, additions, subtractions you wish
- submit a pr
- include an update to the below "changelog" section explaining what you did and why

## changelog

- @tyleretters - init project, setup a global transport and examples for how to hook into it, wire up start/stop and restart for k2 and k3, set some basic poly perc stuff (someone, please rip this out and change it!)
- @schollz - added sixteenth note transports. added in some melodies for quarter notes and sixteenth notes by transforming a recorded midi dump into lua code using soon-to-be released midi script extension for norns.
- @Quixotic7 - replaced the polyperc engine with the bangs engine. This allows you to have different sounding note bangs. In the params menu you can change the synth parameters for 4 different synth sources. Sounds are banged by calling soundEngine:bang_note_hz(freq, synthId, midiId) and soundEngine:bang_note(noteNumber, synthId, midiId). Midi bangs only work if calling soundEngine:bang_note so the song currently only works with the internal synths since all the notes are frequencies.
- @ryanlaws - was being a real prima donna about hz and changed them to MIDI notes. 
- @evanmcook - aka evancook.audio added graphics that like to groove along to the measure number
- @Quixotic7 - added drum patterns
- @ryanlaws - added some param setting stuff and a xox-step-pattern thing, plus some patterns, as well as a pretty naive Brownian motion generator. then added a "nervous" ting
- @tyleretters - use norns clock and e2 to control bpm
- @schollz - added chords (Am, Em, F, G)
- @tyleretters - rationalize bpm and terminology
- @evanmcook - aka evancook.audio returned to revise the graphics and add a method by which the song ends