export const jobKinds = ['ingest', 'transcribe', 'score', 'render'] as const;

export type JobKind = (typeof jobKinds)[number];

export interface BaseJob<TKind extends JobKind, TPayload> {
  job_id: string;
  kind: TKind;
  requested_at: string;
  payload: TPayload;
}

export interface IngestPayload {
  source_url: string;
  asset_id: string;
}

export interface TranscribePayload {
  asset_id: string;
  language?: string;
}

export interface ScorePayload {
  transcript_id: string;
  sermon_window?: {
    start_seconds: number;
    end_seconds: number;
  };
}

export interface RenderPayload {
  clip_id: string;
  caption_style: 'bold_emphasis' | 'clean_minimal';
}

export type IngestJob = BaseJob<'ingest', IngestPayload>;
export type TranscribeJob = BaseJob<'transcribe', TranscribePayload>;
export type ScoreJob = BaseJob<'score', ScorePayload>;
export type RenderJob = BaseJob<'render', RenderPayload>;

export type MediaJob = IngestJob | TranscribeJob | ScoreJob | RenderJob;
