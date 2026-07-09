import type { Metadata } from 'next';
import './globals.css';
import { ScrollReveal } from './ScrollReveal';

export const metadata: Metadata = {
  metadataBase: new URL('https://hocalist.com'),
  title: {
    default: 'Hocalist | Local buying requests and seller offers',
    template: '%s | Hocalist'
  },
  description:
    'Hocalist helps buyers post local buying requests and sellers respond with offers. Seller plans support marketplace tools while item payment is arranged directly.',
  openGraph: {
    title: 'Hocalist',
    description:
      'Local buying requests and real seller offers. Seller plan billing is separate from offline item payment.',
    url: 'https://hocalist.com',
    siteName: 'Hocalist',
    type: 'website'
  }
};

export default function RootLayout({
  children
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>
        <ScrollReveal />
        {children}
      </body>
    </html>
  );
}
