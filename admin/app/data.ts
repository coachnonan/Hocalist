export type StatusTone = "success" | "warning" | "danger" | "info" | "neutral";
export const users = [
  ["Maya Chen","maya@example.test","Buyer","Active","Chicago, IL","Jul 10"],
  ["Arthur Miller","arthur@example.test","Seller","Verified","Evanston, IL","Jul 10"],
  ["Nina Patel","nina@example.test","Seller","Review","Oak Park, IL","Jul 9"],
  ["Jon Bell","jon@example.test","Buyer","Restricted","Chicago, IL","Jul 8"],
];
export const requests = [
  ["REQ-2048","Ergonomic office chair","Maya Chen","Home & office","Open","12 offers"],
  ["REQ-2047","Used mirrorless camera","Jon Bell","Electronics","Review","4 offers"],
  ["REQ-2046","Vintage record player","Amara Reed","Collectibles","Matched","8 offers"],
  ["REQ-2045","Kids bicycle, 20 inch","Leo Park","Sporting goods","Closed","6 offers"],
];
export const offers = [
  ["OFF-4811","REQ-2048","Arthur Miller","$185","Shortlisted","10m ago"],
  ["OFF-4810","REQ-2048","Nina Patel","$172","New","24m ago"],
  ["OFF-4809","REQ-2047","Northside Camera","$640","Selected","1h ago"],
  ["OFF-4808","REQ-2046","Vinyl Corner","$120","Declined","2h ago"],
];
export const reports = [
  ["RPT-0318","Misleading listing details","Offer","High","Open","8m ago"],
  ["RPT-0317","Harassing chat message","User","Critical","Escalated","42m ago"],
  ["RPT-0316","Request posted in wrong category","Request","Low","Review","3h ago"],
  ["RPT-0315","No-show at local handoff","Deal","Medium","Resolved","Yesterday"],
];
export const subscriptions = [
  ["Arthur Miller","Seller Plus","Active","Renews Aug 10","Card •••• 4242"],
  ["Nina Patel","Seller Starter","Trial","Ends Jul 18","No method"],
  ["Northside Camera","Seller Plus","Past due","Retry Jul 12","Card •••• 1881"],
  ["Vinyl Corner","Seller Starter","Canceled","Ends Jul 31","Card •••• 9010"],
];
