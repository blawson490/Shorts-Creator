# Church Clip Director

A sermon-first clipper for turning full church services into polished 60-second vertical clips.

## Product thesis

Do **not** start by asking AI to understand raw video. Start with:

1. service structure
2. transcript with word-level timestamps

For most church workflows, this yields better clip quality faster than heavyweight computer vision.

---

## Winning pipeline

### 1) Ingest full service
- Input: 60–120 minute livestream recording
- Extract audio track
- Optionally create a low-resolution proxy video for timeline review

### 2) Segment service by structure
Detect timeline blocks such as:
- pre-service / countdown
- worship
- announcements
- sermon
- altar call / prayer
- outro

### 3) Transcribe with timestamps
- Use Whisper (or similar ASR)
- Require word-level timestamps for precise cuts and caption timing

### 4) Classify sections
Map ranges like:
- `00:00–08:30` pre-service
- `08:30–31:00` worship
- `31:00–36:00` announcements
- `36:00–1:14:00` sermon
- `1:14:00–1:25:00` altar call

### 5) Find clip candidates from sermon windows
Score moments by:
- self-contained thought
- strong first 3–5 second hook
- emotional intensity
- biblical/teaching clarity
- quotability
- no context-dependent references (example: "as I said earlier")
- can cleanly fit 30–75 seconds

### 6) Generate edit decisions (EDL first)
Instead of generating video directly, output a render plan:

```json
{
  "start": "00:42:18.4",
  "end": "00:43:21.9",
  "title": "Stop Letting Fear Pastor Your Life",
  "caption_style": "bold_emphasis",
  "crop": "speaker_center",
  "zoom_moments": [
    { "time": "00:42:32", "type": "push_in" }
  ]
}
```

### 7) Render with FFmpeg
- hard cut clip by timestamps
- convert to `1080x1920` vertical
- burn captions
- normalize audio loudness
- apply subtle keyframe zooms
- export social-ready mp4

---

## Secret sauce: ranking model

Use a weighted scorecard:
- hook score
- standalone score
- emotional score
- theology clarity score
- shareability score
- clean ending score

Then rank and present top clips with rationale.

Example output:
- **Clip 1 — 92/100**: "Stop Letting Fear Pastor Your Life" (strong opening, emotional payoff, standalone, clean ending)
- **Clip 2 — 86/100**: "God Doesn’t Waste Wilderness Seasons" (good quote, trim ~2s at start)

---

## MVP (build this first)

1. Upload full video
2. Auto-transcribe
3. User marks sermon start/end once
4. AI suggests 5 best clips
5. User picks one
6. Render vertical captioned clip

This is already useful for church media teams.

---

## V2 enhancements

- auto-detect worship/sermon/altar call ranges
- speaker/face tracking crop refinement
- automatic title generation
- caption style presets
- "make this more punchy" rewrite-and-trim pass
- preference memory based on accepted/rejected clips

---

## Product boundary

This is not a general-purpose video editor.

It is a **sermon clipper that thinks like a church media director**.
