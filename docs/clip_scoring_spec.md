# Clip Scoring Spec

## Objective
Rank sermon moments for short-form clips using explicit, explainable scoring dimensions.

## Input
For each candidate window (30–75s), provide:
- transcript text with word timestamps
- sentence boundaries
- detected speaker turns (optional)
- source range metadata (`service_id`, `start`, `end`, `section=sermon`)

## Dimensions (0–100 each)
1. **Hook score**
   - Strong claim/question in first 3–5 seconds
2. **Standalone score**
   - Understandable without earlier context
3. **Emotional score**
   - Detect intensity, conviction, urgency, encouragement
4. **Theology clarity score**
   - Clear biblical point or application
5. **Shareability score**
   - Quote-like wording and broad relevance
6. **Clean ending score**
   - Ends naturally without abrupt cutoff

## Weighted total

```text
total =
  0.24 * hook +
  0.20 * standalone +
  0.16 * emotional +
  0.18 * theology_clarity +
  0.12 * shareability +
  0.10 * clean_ending
```

## Rejection rules
Auto-reject if any are true:
- unresolved callback phrases ("as I said earlier", "like in point one")
- severe sentence truncation at start/end
- low transcript confidence on >25% of words
- contains private/sensitive altar ministry details (policy filter)

## Output contract

```json
{
  "clip_id": "svc123_00-42-18_00-43-22",
  "start": "00:42:18.4",
  "end": "00:43:21.9",
  "title": "Stop Letting Fear Pastor Your Life",
  "scores": {
    "hook": 95,
    "standalone": 91,
    "emotional": 89,
    "theology_clarity": 93,
    "shareability": 88,
    "clean_ending": 90,
    "total": 92.1
  },
  "notes": [
    "Strong imperative hook in first sentence",
    "No backward references",
    "Natural cadence landing in final sentence"
  ],
  "render": {
    "caption_style": "bold_emphasis",
    "crop": "speaker_center",
    "zoom_moments": [
      { "time": "00:42:32", "type": "push_in" }
    ]
  }
}
```
