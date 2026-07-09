import { PolicyPage } from '../site-content';

export const metadata = {
  title: 'Hocalist Refund and Cancellation Policy',
  description: 'Refund and cancellation policy for Hocalist seller subscriptions, credits, and offline item payment boundaries.'
};

export default function RefundCancellationPage() {
  return (
    <PolicyPage
      title="Refund and Cancellation Policy"
      lead="This policy applies to seller subscriptions, credits, promoted visibility, and related seller services. It does not apply to offline item payments between buyers and sellers."
      sections={[
        {
          title: 'Seller subscription cancellation',
          body: [
            'Sellers may cancel a recurring seller subscription according to the cancellation options shown in the seller billing portal, account billing flow, or Hocalist support instructions.',
            'Cancellation typically stops future renewal charges. Access may continue through the end of the current paid billing period unless otherwise stated at purchase.'
          ]
        },
        {
          title: 'Billing cycles',
          body: [
            'Seller subscription fees are billed on the cycle displayed in the account billing flow. A secure billing provider may handle seller plan payment details, invoices, receipts, and payment status.',
            'If a payment fails, paid seller plan features may be limited until the billing issue is resolved.'
          ]
        },
        {
          title: 'Refund eligibility',
          body: [
            'Refund eligibility depends on the seller product purchased, the timing of the request, and whether credits, promoted visibility, or seller services have already been used.',
            'Monthly seller subscription charges are generally non-refundable after the billing period begins, except where required by law or where Hocalist determines that a billing error occurred. Cancellation stops future renewals.'
          ]
        },
        {
          title: 'Credits and promotional fees',
          body: [
            'Used credits, promoted placement fees, targeting fees, or other consumed seller services may be non-refundable when clearly disclosed before purchase.',
            'Unused credits or early access fees should follow the published seller plan terms available at the time of purchase.'
          ]
        },
        {
          title: 'Offline item purchase disputes',
          body: [
            'Item purchases between buyers and sellers are arranged offline and are not paid through Hocalist. Hocalist does not process refunds for offline item purchases between users.',
            'Buyers and sellers should inspect items, agree on details, and resolve offline payment concerns directly with each other, subject to applicable law.'
          ]
        },
        {
          title: 'Billing support',
          body: [
            'For seller billing questions, contact coachnonan@gmail.com. Include the account email, plan name, invoice or receipt information, and a short description of the request.',
            'For written notices, email support for current mailing details.'
          ]
        }
      ]}
    />
  );
}
