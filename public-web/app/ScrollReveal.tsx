'use client';

import { useEffect } from 'react';
import { usePathname } from 'next/navigation';

export function ScrollReveal() {
  const pathname = usePathname();

  useEffect(() => {
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      document.documentElement.dataset.scrollReveal = 'reduced';
      document
        .querySelectorAll<HTMLElement>('.reveal')
        .forEach((element) => element.classList.add('is-visible'));
      return;
    }

    document.documentElement.dataset.scrollReveal = 'ready';

    if (!('IntersectionObserver' in window)) {
      document
        .querySelectorAll<HTMLElement>('.reveal')
        .forEach((element) => element.classList.add('is-visible'));
      return;
    }

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('is-visible');
            observer.unobserve(entry.target);
          }
        });
      },
      {
        rootMargin: '0px 0px -12% 0px',
        threshold: 0.16
      }
    );

    const observeRevealElements = (root: ParentNode = document) => {
      root.querySelectorAll<HTMLElement>('.reveal').forEach((element) => {
        if (!element.classList.contains('is-visible')) {
          observer.observe(element);
        }
      });
    };

    observeRevealElements();

    const mutationObserver = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        mutation.addedNodes.forEach((node) => {
          if (!(node instanceof HTMLElement)) {
            return;
          }

          if (node.matches('.reveal')) {
            observeRevealElements(node.parentElement ?? document);
            return;
          }

          observeRevealElements(node);
        });
      });
    });

    mutationObserver.observe(document.body, { childList: true, subtree: true });

    return () => {
      mutationObserver.disconnect();
      observer.disconnect();
    };
  }, [pathname]);

  return null;
}
