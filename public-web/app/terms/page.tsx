import { PolicyPage } from '../site-content';

export const metadata = {
  title: 'Hocalist Terms of Service',
  description: 'Terms of Service for Hocalist, including seller plans, offline item payment, and user responsibilities.'
};

export default function TermsPage() {
  return (
    <PolicyPage
      title="Terms of Service"
      lead="These terms describe Hocalist's service, buyer and seller responsibilities, seller platform fees, offline item payment boundaries, and safety expectations."
      sections={[
        {
          title: 'Service description',
          body: [
            'Hocalist helps buyers post local buying requests and helps sellers respond with offers. The service may include profiles, request discovery, offer review, chat, deal coordination, safety reporting, and seller tools.',
            'Hocalist supports local discovery and coordination. Buyer-to-seller item purchases, item payment, delivery, and handoff details are arranged directly between users outside Hocalist.'
          ]
        },
        {
          title: 'Buyer responsibilities',
          body: [
            'Buyers are responsible for posting accurate requests, reviewing seller offers carefully, asking questions before meeting, inspecting items, and arranging offline payment only after they are satisfied with deal details.',
            'Buyers should use safe meetup practices and report suspicious or abusive behavior.'
          ]
        },
        {
          title: 'Seller responsibilities',
          body: [
            'Sellers are responsible for accurate profiles, truthful offers, clear item descriptions, honoring agreed details, and complying with all applicable laws and platform rules.',
            'Sellers must not use Hocalist to sell illegal, counterfeit, unsafe, or prohibited goods or services.'
          ]
        },
        {
          title: 'Seller subscriptions and fees',
          body: [
            'Hocalist may charge sellers for subscriptions, credits, promoted visibility, buyer-request visibility, or seller tools. Seller plan payment may be handled by a secure billing provider.',
            'Seller fees do not mean Hocalist processes buyer-to-seller item payment or guarantees deal outcomes.'
          ]
        },
        {
          title: 'Offline item payment',
          body: [
            'Item payment happens directly between buyer and seller outside Hocalist. Hocalist does not hold, release, or transfer buyer-to-seller item funds.',
            'Users are responsible for deciding whether, when, and how to complete direct item payment after inspection and agreement.'
          ]
        },
        {
          title: 'Disputes and safety',
          body: [
            'Disputes between buyers and sellers are primarily between those users. Hocalist may review reports, moderate accounts, or restrict access when platform rules are violated.',
            'Hocalist may suspend accounts that create safety risk, commit fraud, violate laws, abuse other users, or misuse the platform.'
          ]
        },
        {
          title: 'Disclaimers and contact',
          body: [
            'Hocalist provides the service as available and does not promise that every request, offer, meetup, seller, buyer, or offline transaction will meet user expectations.',
            'Contact: coachnonan@gmail.com. For written notices, email support for current mailing details.'
          ]
        }
      ]}
    />
  );
}
