import type { MetadataRoute } from 'next';

const siteUrl = 'https://hocalist.com';

const publicRoutes = [
  '',
  '/how-it-works',
  '/pricing',
  '/safety',
  '/support',
  '/download',
  '/privacy',
  '/terms',
  '/refund-cancellation'
];

export default function sitemap(): MetadataRoute.Sitemap {
  return publicRoutes.map((route) => ({
    url: `${siteUrl}${route}`,
    lastModified: new Date('2026-07-09')
  }));
}
