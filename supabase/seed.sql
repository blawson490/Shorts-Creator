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

insert into public.render_jobs (id, clip_id, preset, status)
values (
  '44444444-4444-4444-4444-444444444444',
  '33333333-3333-3333-3333-333333333333',
  'vertical_1080x1920',
  'queued'
)
on conflict (id) do nothing;
