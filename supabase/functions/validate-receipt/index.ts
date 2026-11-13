// Bible Garden · validate-receipt (Supabase Edge Function, Deno)
//
// Recebe a compra feita no celular, confere com a loja (Google Play ou App
// Store) e só então entrega: orvalho entra pelo credit_verified_purchase(),
// uma vez por transação. O app nunca credita pacote sozinho.
//
// Segredos (supabase secrets set ...):
//   GOOGLE_SERVICE_ACCOUNT_JSON  conta de serviço com acesso à Android Publisher API
//   ANDROID_PACKAGE_NAME         app.biblegarden
//   APPLE_ISSUER_ID, APPLE_KEY_ID, APPLE_PRIVATE_KEY (p8), APPLE_BUNDLE_ID
//   APPLE_ENV                    "production" ou "sandbox"
// SUPABASE_URL e SUPABASE_SERVICE_ROLE_KEY já existem nas Edge Functions.

import { createClient } from "jsr:@supabase/supabase-js@2";
import { decodeJwt, importPKCS8, SignJWT } from "jsr:@panva/jose@6";

/** Orvalho de cada produto (igual a lib/core/purchases.dart). */
const ORVALHO: Record<string, number> = {
  orvalho_300: 300,
  orvalho_700: 700,
  orvalho_1500: 1500,
};

type Body = {
  platform: "google_play" | "app_store";
  productId: string;
  transactionId: string;
  verificationData: string;
};

const json = (status: number, data: unknown) =>
  new Response(JSON.stringify(data), {
    status,
    headers: { "content-type": "application/json" },
  });

const env = (k: string) => {
  const v = Deno.env.get(k);
  if (!v) throw new Error(`segredo ausente: ${k}`);
  return v;
};

async function googleAccessToken(): Promise<string> {
  const sa = JSON.parse(env("GOOGLE_SERVICE_ACCOUNT_JSON"));
  const key = await importPKCS8(sa.private_key, "RS256");
  const now = Math.floor(Date.now() / 1000);
  const assertion = await new SignJWT({
    scope: "https://www.googleapis.com/auth/androidpublisher",
  })
    .setProtectedHeader({ alg: "RS256", typ: "JWT" })
    .setIssuer(sa.client_email)
    .setAudience("https://oauth2.googleapis.com/token")
    .setIssuedAt(now)
    .setExpirationTime(now + 3600)
    .sign(key);
  const r = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "content-type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion,
    }),
  });
  if (!r.ok) throw new Error(`token Google: ${r.status}`);
  return (await r.json()).access_token;
}

/** Google Play: o verificationData é o purchaseToken. */
async function verifyGoogle(b: Body): Promise<boolean> {
  const pkg = env("ANDROID_PACKAGE_NAME");
  const token = await googleAccessToken();
  const url =
    `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/` +
    `${pkg}/purchases/products/${encodeURIComponent(b.productId)}/tokens/` +
    `${encodeURIComponent(b.verificationData)}`;
  const r = await fetch(url, { headers: { authorization: `Bearer ${token}` } });
  if (!r.ok) return false;
  const p = await r.json();
  // purchaseState 0 = comprado; orderId tem que bater com a transação.
  return p.purchaseState === 0 && (!p.orderId || p.orderId === b.transactionId);
}

/** App Store: consulta a transação na App Store Server API. */
async function verifyApple(b: Body): Promise<boolean> {
  const key = await importPKCS8(env("APPLE_PRIVATE_KEY"), "ES256");
  const now = Math.floor(Date.now() / 1000);
  const jwt = await new SignJWT({ bid: env("APPLE_BUNDLE_ID") })
    .setProtectedHeader({ alg: "ES256", kid: env("APPLE_KEY_ID"), typ: "JWT" })
    .setIssuer(env("APPLE_ISSUER_ID"))
    .setAudience("appstoreconnect-v1")
    .setIssuedAt(now)
    .setExpirationTime(now + 600)
    .sign(key);
  const host = Deno.env.get("APPLE_ENV") === "sandbox"
    ? "api.storekit-sandbox.itunes.apple.com"
    : "api.storekit.itunes.apple.com";
  const r = await fetch(
    `https://${host}/inApps/v1/transactions/${encodeURIComponent(b.transactionId)}`,
    { headers: { authorization: `Bearer ${jwt}` } },
  );
  if (!r.ok) return false;
  // A resposta vem da própria Apple por TLS; o payload JWS assinado traz a
  // transação. Conferimos produto, app e se não foi reembolsada.
  const { signedTransactionInfo } = await r.json();
  const t = decodeJwt(signedTransactionInfo) as Record<string, unknown>;
  return t.productId === b.productId &&
    t.bundleId === env("APPLE_BUNDLE_ID") &&
    t.revocationDate == null;
}

Deno.serve(async (req) => {
  if (req.method !== "POST") return json(405, { erro: "use POST" });
  const url = env("SUPABASE_URL");
  const admin = createClient(url, env("SUPABASE_SERVICE_ROLE_KEY"));
  const jwt = (req.headers.get("authorization") ?? "").replace(/^Bearer /, "");
  const { data: auth, error } = await admin.auth.getUser(jwt);
  if (error || !auth.user) return json(401, { erro: "sem login" });

  let b: Body;
  try {
    b = await req.json();
  } catch {
    return json(400, { erro: "corpo inválido" });
  }
  const isPack = b.productId?.startsWith("pacote_");
  if (!(b.productId in ORVALHO) && !isPack) {
    return json(400, { erro: "produto desconhecido" });
  }
  let valid = false;
  try {
    valid = b.platform === "google_play"
      ? await verifyGoogle(b)
      : b.platform === "app_store"
      ? await verifyApple(b)
      : false;
  } catch (e) {
    console.error("validação falhou", (e as Error).message);
    return json(502, { valid: false });
  }
  if (!valid) return json(200, { valid: false });

  const { error: rpcError } = await admin.rpc("credit_verified_purchase", {
    p_user: auth.user.id,
    p_tx: b.transactionId,
    p_product: b.productId,
    p_platform: b.platform,
    p_amount: ORVALHO[b.productId] ?? 0,
  });
  if (rpcError) return json(500, { valid: false });
  return json(200, { valid: true });
});
