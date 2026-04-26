import './globals.css';
import type { ReactNode } from 'react';

export const metadata = {
  title: 'Shorts Creator',
  description: 'Web UI for the Shorts Creator pipeline'
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
