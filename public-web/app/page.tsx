import Link from 'next/link';
import {
  OfflineNotice,
  PageShell,
  SectionIntro,
  faqItems,
  pricingPlans
} from './site-content';

const popularCategories = [
  { name: 'Phones & tablets', count: '128 open requests', cue: 'Unlocked devices, repairs, accessories', mark: 'PT' },
  { name: 'Home essentials', count: '94 open requests', cue: 'Furniture, small appliances, decor', mark: 'HE' },
  { name: 'Auto parts', count: '76 open requests', cue: 'Tires, batteries, trims, tools', mark: 'AP' },
  { name: 'Local services', count: '61 open requests', cue: 'Setup help, repairs, moving support', mark: 'LS' },
  { name: 'Kids & baby', count: '48 open requests', cue: 'Strollers, cribs, gear, toys', mark: 'KB' },
  { name: 'Events & gifts', count: '35 open requests', cue: 'Bundles, decor, last-minute finds', mark: 'EG' }
];

const recentRequests = [
  {
    title: 'Need a clean unlocked iPhone 13',
    meta: 'Electronics - East Austin',
    budget: '$360-$430',
    offers: '7 seller offers',
    tag: 'Ready to choose',
    status: 'Verified request'
  },
  {
    title: 'Looking for a compact dining table',
    meta: 'Home - 10 mile radius',
    budget: '$120-$220',
    offers: '4 seller offers',
    tag: 'Photos requested',
    status: 'New today'
  },
  {
    title: 'Need two used tires before Friday',
    meta: 'Auto - Local pickup',
    budget: '$80-$140',
    offers: '6 seller offers',
    tag: 'Chat opening soon',
    status: 'Local pickup'
  }
];

const workflowSteps = [
  {
    kicker: 'Start with demand',
    title: 'Buyer posts a request',
    body: 'A buyer describes what they need, where they are looking, and the budget range they have in mind.',
    image: '/images/how-it-works/buyer-request.png',
    alt: 'Buyer writing a local request on a phone'
  },
  {
    kicker: 'Sellers respond',
    title: 'Local sellers make offers',
    body: 'Sellers respond with relevant details, availability, condition notes, and any questions before the buyer chooses.',
    image: '/images/how-it-works/seller-offer.png',
    alt: 'Local seller preparing an offer for nearby buyer demand'
  },
  {
    kicker: 'Chat after choice',
    title: 'The buyer chooses a seller',
    body: 'Chat opens after selection so both sides can confirm timing, condition, meetup details, and how payment will be arranged.',
    image: '/images/how-it-works/buyer-seller-coordinate.png',
    alt: 'Buyer and seller coordinating details together'
  }
];

const sellerHighlights = [
  'Find active local demand before stocking decisions',
  'Use plans and credits for visibility and seller tools',
  'Coordinate item payment directly with the buyer'
];

export default function HomePage() {
  return (
    <PageShell>
      <main>
        <section className="hero marketplace-hero">
          <div className="hero-copy reveal hero-copy-card">
            <div className="hero-kicker">
              <span className="live-dot" aria-hidden="true" />
              Local reverse marketplace
            </div>
            <h1>Ask for what you need. Compare nearby seller offers.</h1>
            <p>
              Hocalist is a request-first marketplace for local buying. Buyers describe what
              they need, sellers respond with tailored offers, and chat opens when the buyer
              chooses who to coordinate with.
            </p>
            <div className="hero-actions">
              <Link className="button primary" href="/download">
                Post a request
              </Link>
              <Link className="button secondary seller-cta" href="/pricing">
                For sellers
              </Link>
            </div>
            <div className="hero-proof" aria-label="Marketplace boundaries">
              <span>Buyer-led requests</span>
              <span>Seller offers</span>
              <span>Payment arranged by users</span>
            </div>
          </div>

          <div className="hero-stage reveal delay-1" aria-label="Hocalist request marketplace preview">
            <form className="request-panel" aria-label="Mock request composer">
              <div className="request-panel-header">
                <span>Start a local request</span>
                <strong>Describe what you need</strong>
              </div>
              <label className="request-field wide">
                <span>What are you looking for?</span>
                <input readOnly value="Unlocked iPhone 13, clean condition" />
              </label>
              <div className="request-panel-grid">
                <label className="request-field">
                  <span>Category</span>
                  <input readOnly value="Phones & tablets" />
                </label>
                <label className="request-field">
                  <span>Location</span>
                  <input readOnly value="Austin, TX" />
                </label>
              </div>
              <label className="request-field wide">
                <span>Budget</span>
                <input readOnly value="$350-$450, pickup nearby" />
              </label>
              <button type="button">Send request to local sellers</button>
              <p>
                Hocalist supports discovery, offers, selection, and chat. Buyers and sellers
                arrange item payment directly after confirming the details.
              </p>
            </form>

            <figure className="market-photo-card hero-context-photo">
              <img
                alt="Buyer and seller coordinating around a local marketplace request"
                src="/images/how-it-works/buyer-seller-coordinate.png"
              />
              <figcaption>Local supply meets buyer demand</figcaption>
            </figure>

            <article className="floating-card buyer-sample">
              <span className="status-chip success">Buyer request</span>
              <h3>Unlocked phone by Friday</h3>
              <p>East Austin - prefers battery health above 85%</p>
              <div className="mini-meta">
                <strong>$360-$430</strong>
                <span>7 offers</span>
              </div>
            </article>

            <article className="floating-card seller-sample">
              <div>
                <span className="seller-avatar">S</span>
                <strong>Seller offer</strong>
              </div>
              <p>Clean device, case included, available tonight.</p>
              <span className="offer-chip">Best match</span>
            </article>

            <div className="trust-card verified-card">
              <strong>42</strong>
              <span>nearby sellers watching similar requests</span>
            </div>
            <div className="trust-card offer-count-card">
              <strong>7 offers</strong>
              <span>before buyer chooses chat</span>
            </div>
          </div>
        </section>

        <section className="market-strip reveal delay-2" aria-label="Hocalist marketplace stats">
          <span>
            <strong>2-sided</strong>
            Buyer and seller marketplace
          </span>
          <span>
            <strong>Offer-first</strong>
            Sellers respond to demand
          </span>
          <span>
            <strong>Chat after choice</strong>
            Details finalized together
          </span>
          <span>
            <strong>User-arranged payment</strong>
            Buyers and sellers arrange the item payment
          </span>
        </section>

        <section className="category-ribbon" aria-label="Fast moving request categories">
          <div className="category-track">
            {popularCategories.concat(popularCategories).map((category, index) => (
              <span key={`${category.name}-${index}`}>{category.name}</span>
            ))}
          </div>
        </section>

        <section className="page-section category-section" id="categories">
          <SectionIntro
            eyebrow="Popular request categories"
            title="Local demand, organized around what buyers actually need"
            body="Buyers can describe the item or help they need, while sellers can see where local demand is already active."
          />
          <div className="category-grid">
            {popularCategories.map((category) => (
              <article className="category-card reveal" key={category.name}>
                <div className="category-icon">{category.mark}</div>
                <span>{category.count}</span>
                <h3>{category.name}</h3>
                <p>{category.cue}</p>
              </article>
            ))}
          </div>
        </section>

        <section className="page-section request-section" id="requests">
          <div>
            <SectionIntro
              align="left"
              eyebrow="Recent buyer requests"
              title="Buyer requests give the marketplace its starting point"
              body="Sample requests show how buyers compare useful offers and how sellers respond with clear details and availability."
            />
            <Link className="text-link" href="/how-it-works">
              See the request flow
            </Link>
          </div>
          <div className="request-card-list">
            {recentRequests.map((request) => (
              <article className="buyer-request-card reveal" key={request.title}>
                <div>
                  <span className="status-chip">{request.status}</span>
                  <h3>{request.title}</h3>
                  <p>{request.meta}</p>
                </div>
                <div className="request-card-meta">
                  <strong>{request.budget}</strong>
                  <span>{request.offers}</span>
                  <em>{request.tag}</em>
                </div>
              </article>
            ))}
          </div>
        </section>

        <section className="page-section workflow-section" id="how-it-works">
          <SectionIntro
            eyebrow="How Hocalist works"
            title="A simple path from request to seller chat"
            body="Buyers post what they need, compare seller offers, choose who to continue with, and coordinate the item payment directly after agreement."
          />
          <div className="workflow-grid">
            {workflowSteps.map((step, index) => (
              <article className="workflow-card reveal" key={step.title}>
                <figure className="workflow-photo">
                  <img alt={step.alt} src={step.image} />
                </figure>
                <div className="workflow-card-copy">
                  <span>{String(index + 1).padStart(2, '0')}</span>
                  <p className="workflow-kicker">{step.kicker}</p>
                  <h3>{step.title}</h3>
                  <p>{step.body}</p>
                </div>
              </article>
            ))}
          </div>
        </section>

        <section className="page-section role-split">
          <article className="role-panel buyer-panel reveal">
            <p className="eyebrow">For buyers</p>
            <h2>Stop searching every listing. Let sellers come to your request.</h2>
            <p>
              Post the need, compare offers, choose a seller, and use chat to confirm condition,
              timing, meetup details, and the item payment arrangement.
            </p>
            <figure className="role-photo">
              <img
                alt="Buyer writing a local marketplace request on a phone"
                src="/images/how-it-works/buyer-request.png"
              />
            </figure>
            <Link className="button primary" href="/download">
              Post a request
            </Link>
          </article>
          <article className="role-panel seller-panel reveal delay-1">
            <p className="eyebrow">For sellers</p>
            <h2>Respond to real buyer intent with focused offers.</h2>
            <ul>
              {sellerHighlights.map((highlight) => (
                <li key={highlight}>{highlight}</li>
              ))}
            </ul>
            <figure className="role-photo">
              <img
                alt="Local seller preparing an offer for a nearby buyer request"
                src="/images/how-it-works/seller-offer.png"
              />
            </figure>
            <Link className="button secondary" href="/pricing">
              View seller plans
            </Link>
          </article>
        </section>

        <section className="page-section seller-plan-section" id="seller-plans">
          <SectionIntro
            eyebrow="Seller plans and credits"
            title="Built-in plans for sellers who want better request visibility"
            body="Seller plans and credits support profile tools, offer activity, promoted placement, and request visibility while the marketplace remains buyer-request led."
          />
          <div className="pricing-grid compact-pricing">
            {pricingPlans.map((plan) => (
              <article className={`pricing-card ${plan.featured ? 'featured' : ''}`} key={plan.name}>
                {plan.featured && <span className="plan-ribbon">Popular seller tier</span>}
                <h3>{plan.name}</h3>
                <p>{plan.summary}</p>
                <div className="price">
                  <strong>{plan.price}</strong>
                  <span>{plan.cadence}</span>
                </div>
                <ul>
                  {plan.features.slice(0, 4).map((feature) => (
                    <li key={feature}>{feature}</li>
                  ))}
                </ul>
              </article>
            ))}
          </div>
        </section>

        <section className="page-section safety-section">
          <div className="safety-copy reveal">
            <p className="eyebrow">Safety and coordination</p>
            <h2>Clear steps from offer review to buyer-seller agreement</h2>
            <p>
              Hocalist supports request discovery, seller offers, buyer selection, and chat. Buyers
              and sellers can inspect, agree on details, and arrange item payment directly with
              each other.
            </p>
            <Link className="text-link" href="/safety">
              Read safety guidance
            </Link>
          </div>
          <div className="safety-card-stack reveal delay-1">
            <OfflineNotice />
            <article className="safety-mini-card">
              <span className="status-chip gold">Buyer and seller clarity</span>
              <h3>Hocalist keeps discovery separate from item payment.</h3>
              <p>Buyers and sellers handle item payment directly after inspection and agreement.</p>
            </article>
          </div>
        </section>

        <section className="page-section faq-section">
          <SectionIntro
            eyebrow="Common questions"
            title="Clear answers for buyers, sellers, and reviewers"
            body="A simple summary of buyer requests, seller offers, account billing, and payment arranged by users."
          />
          <div className="faq-grid">
            {faqItems.map((item) => (
              <article className="faq-card reveal" key={item.question}>
                <h3>{item.question}</h3>
                <p>{item.answer}</p>
              </article>
            ))}
          </div>
        </section>
      </main>
    </PageShell>
  );
}
