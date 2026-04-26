-- Minimal development seed data for pipeline orchestration.

insert into public.services (id, external_ref, title, source_video_url, scheduled_at, status)
values (
  '11111111-1111-1111-1111-111111111111',
  'dev-service-001',
  'Sunday Service (Sample)',
  'https://example.com/services/sample.mp4',
  now() - interval '1 day',
  'ready'
)
on conflict (id) do nothing;

insert into public.transcripts (id, service_id, language_code, provider, status, raw_text, word_timestamps)
values (
  '22222222-2222-2222-2222-222222222222',
  '11111111-1111-1111-1111-111111111111',
  'en',
  'whisper',
  'completed',
  'Sample transcript text for local development.',
  '[{"word":"Sample","start":0.0,"end":0.4}]'::jsonb
)
on conflict (id) do nothing;

insert into public.clips (id, service_id, transcript_id, title, start_second, end_second, score, status)
values (
  '33333333-3333-3333-3333-333333333333',
  '11111111-1111-1111-1111-111111111111',
  '22222222-2222-2222-2222-222222222222',
  'Sample Clip Candidate',
  120.000,
  162.500,
  82.50,
  'selected'
)
on conflict (id) do nothing;

insert into public.videos (id, title, status, original_file_key, duration_seconds)
values (
  '55555555-5555-5555-5555-555555555555',
  'Sunday Service Upload (Sample)',
  'analyzed',
  'uploads/services/2026-04-20-sunday-service.mp4',
  5399.25
)
on conflict (id) do nothing;

insert into public.clip_candidates (
  id,
  video_id,
  start_time,
  end_time,
  title,
  summary,
  hook_score,
  standalone_score,
  emotional_score,
  clarity_score,
  shareability_score,
  overall_score,
  reason,
  status
)
values (
  '66666666-6666-6666-6666-666666666666',
  '55555555-5555-5555-5555-555555555555',
  2520.0,
  2578.0,
  'Faith Over Fear',
  'A concise encouragement to trust God in uncertain seasons.',
  88.0,
  91.0,
  86.0,
  89.0,
  84.0,
  87.6,
  'Strong opening line and complete thought arc in under 60 seconds.',
  'approved'
)
on conflict (id) do nothing;

insert into public.render_jobs (id, clip_candidate_id, status, progress, output_file_key)
values (
  '77777777-7777-7777-7777-777777777777',
  '66666666-6666-6666-6666-666666666666',
  'processing',
  45,
  null
)
on conflict (id) do nothing;
