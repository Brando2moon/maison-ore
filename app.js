/* ============================================================
   MAISON ORÉ — Shared App Logic
   Cart, favorites, search, cross-page UI wiring.
   Uses Bootstrap 5 JS (bundle) — CSS is our own.
   ============================================================ */

(function () {
  "use strict";

  // ---------- Product catalog (shared source of truth) ----------
  window.MO_CATALOG = window.MO_CATALOG || [
    { id: 1, vendor: "Atelier Kōgei", vendorInit: "AK", loc: "Kyōto · Japan", region: "japan",
      cat: "Ceramics · Vessel", name: "Raku Tea Vessel, Iron-Glazed", price: 1840,
      avail: "Edition of 12 · Signed", badge: "Signed", tags: ["signed"],
      desc: "A hand-thrown tea vessel finished in a black-iron raku glaze, then wood-fired in the atelier's traditional Anagama kiln over three days. Each piece emerges with a signature that cannot be reproduced — pooled glaze, ember bloom, and the honest asymmetry of the maker's hand.",
      specs: [["Material","Stoneware · Iron-glazed"],["Dimensions","H 11cm · Ø 9.4cm"],["Origin","Kyōto, Japan"],["Made","2026 · Kōgei Atelier"],["Provenance","Verified · Cert. #KG-0421"]] },
    { id: 2, vendor: "Maison Ferrière", vendorInit: "MF", loc: "Provence · France", region: "europe",
      cat: "Ceramics · Vessel", name: "Terracotta Amphora, 42cm", price: 620,
      avail: "Made to order · 6 weeks", tags: ["new"],
      desc: "Wheel-thrown terracotta from Provençal clay, unglazed and burnished by hand. A vessel with the weight and patience of the region it comes from.",
      specs: [["Material","Terracotta · unglazed"],["Dimensions","H 42cm · Ø 22cm"],["Origin","Vaucluse, France"],["Made","2026 · Ferrière Studio"],["Provenance","Verified · Cert. #MF-0217"]] },
    { id: 3, vendor: "Studio Halden", vendorInit: "SH", loc: "Oslo · Norway", region: "europe",
      cat: "Ceramics · Set", name: "Stoneware Carafe Set of Two", price: 385,
      avail: "In stock · 4 remaining", tags: [],
      desc: "A pair of thrown stoneware carafes with a matte ash glaze, meant to live together on a table. Ines Halden throws the pairs on the same afternoon so they belong to one another.",
      specs: [["Material","Stoneware · ash-glazed"],["Dimensions","H 24cm · Ø 11cm ea."],["Origin","Oslo, Norway"],["Made","2026 · Studio Halden"],["Provenance","Verified · Cert. #SH-0812"]] },
    { id: 4, vendor: "Herrera & Ono", vendorInit: "HO", loc: "Marrakech · Morocco", region: "europe",
      cat: "Ceramics · Bowl", name: "Tadelakt Serving Bowl", price: 290,
      avail: "In stock · 8 remaining", tags: ["new"],
      desc: "Traditional tadelakt lime plaster over stoneware, polished with river stones until it holds an oil-like sheen. A shallow serving vessel in a rare oxide green.",
      specs: [["Material","Stoneware · tadelakt"],["Dimensions","H 6cm · Ø 32cm"],["Origin","Marrakech, Morocco"],["Made","2026 · Herrera & Ono"],["Provenance","Verified · Cert. #HO-0091"]] },
    { id: 5, vendor: "Atelier Kōgei", vendorInit: "AK", loc: "Kyōto · Japan", region: "japan",
      cat: "Ceramics · Vessel", name: "Shino Vase, Winter Firing", price: 2140,
      avail: "Edition of 8 · Signed", badge: "Signed", tags: ["signed"],
      desc: "A tall Shino-glazed vase from the winter kiln — a firing that produces the deepest orange-peel texture in the glaze. Signed and numbered on the base.",
      specs: [["Material","Stoneware · Shino"],["Dimensions","H 34cm · Ø 14cm"],["Origin","Kyōto, Japan"],["Made","2026 · Kōgei Atelier"],["Provenance","Verified · Cert. #KG-0424"]] },
    { id: 6, vendor: "Barros Ceramica", vendorInit: "BC", loc: "Oaxaca · Mexico", region: "americas",
      cat: "Ceramics · Pair", name: "Barro Negro Cups, Set of 4", price: 180,
      avail: "In stock · 12 remaining", tags: [],
      desc: "Black clay from San Bartolo Coyotepec, hand-formed and burnished. Fired in a wood kiln to a metallic graphite finish. Four cups, each subtly different.",
      specs: [["Material","Black clay · burnished"],["Dimensions","H 8cm · Ø 7cm ea."],["Origin","Oaxaca, Mexico"],["Made","2026 · Barros Ceramica"],["Provenance","Verified · Cert. #BC-0055"]] },
    { id: 7, vendor: "Studio Halden", vendorInit: "SH", loc: "Oslo · Norway", region: "europe",
      cat: "Ceramics · Object", name: "Ash-Glazed Vessel, Large", price: 920,
      avail: "Edition of 6 · Signed", badge: "Signed", tags: ["signed", "new"],
      desc: "A generous large-format vessel in the studio's signature ash glaze, meant as an anchor for a room. Six were made in this firing.",
      specs: [["Material","Stoneware · ash-glazed"],["Dimensions","H 46cm · Ø 28cm"],["Origin","Oslo, Norway"],["Made","2026 · Studio Halden"],["Provenance","Verified · Cert. #SH-0813"]] },
    { id: 8, vendor: "Maison Ferrière", vendorInit: "MF", loc: "Provence · France", region: "europe",
      cat: "Ceramics · Bowl", name: "Provençal Bread Bowl", price: 240,
      avail: "In stock · 6 remaining", tags: [],
      desc: "A shallow bread bowl in Provençal terracotta, sealed with beeswax on the interior. Sized for a country loaf.",
      specs: [["Material","Terracotta · beeswax-sealed"],["Dimensions","H 8cm · Ø 34cm"],["Origin","Vaucluse, France"],["Made","2026 · Ferrière Studio"],["Provenance","Verified · Cert. #MF-0219"]] },
  ];

  // ---------- Persistence helpers ----------
  const LS = {
    get(key, fallback) {
      try { const v = localStorage.getItem(key); return v === null ? fallback : JSON.parse(v); }
      catch { return fallback; }
    },
    set(key, val) {
      try { localStorage.setItem(key, JSON.stringify(val)); } catch {}
    }
  };

  // ---------- Cart ----------
  const Cart = {
    items: LS.get("mo_cart", []),  // [{ id, qty }]
    save() { LS.set("mo_cart", this.items); this.updateBadge(); this.renderDrawer(); },
    add(id, qty = 1) {
      const existing = this.items.find(i => i.id === id);
      if (existing) existing.qty += qty; else this.items.push({ id, qty });
      this.save();
      const p = MO_CATALOG.find(x => x.id === id);
      if (p) Toast.show(`Added to cart — ${p.name}`, `${qty}× · ${money(p.price)}`);
    },
    remove(id) {
      this.items = this.items.filter(i => i.id !== id);
      this.save();
    },
    setQty(id, qty) {
      const it = this.items.find(i => i.id === id);
      if (!it) return;
      if (qty <= 0) this.remove(id);
      else { it.qty = qty; this.save(); }
    },
    count() { return this.items.reduce((s, i) => s + i.qty, 0); },
    subtotal() {
      return this.items.reduce((s, i) => {
        const p = MO_CATALOG.find(x => x.id === i.id);
        return s + (p ? p.price * i.qty : 0);
      }, 0);
    },
    updateBadge() {
      const badge = document.getElementById("cartBadge");
      const n = this.count();
      if (!badge) return;
      badge.textContent = n;
      badge.style.display = n > 0 ? "" : "none";
    },
    renderDrawer() {
      const body = document.getElementById("cartDrawerBody");
      const foot = document.getElementById("cartDrawerFoot");
      if (!body) return;
      if (this.items.length === 0) {
        body.innerHTML = `<div class="cart-empty">
          <div class="cart-empty-mark"></div>
          <div class="cart-empty-title">Your cart is empty</div>
          <p class="cart-empty-sub">Nothing carried home yet — start with the Ceramics Edit.</p>
          <a href="shop.html" class="btn btn-primary btn-sm">Browse the Edit <span class="arrow">→</span></a>
        </div>`;
        foot.style.display = "none";
        return;
      }
      foot.style.display = "block";
      body.innerHTML = this.items.map(it => {
        const p = MO_CATALOG.find(x => x.id === it.id);
        if (!p) return "";
        return `<div class="cart-line" data-id="${p.id}">
          <div class="cart-thumb placeholder"><span class="placeholder-label" style="font-size:8px;">${p.vendorInit}</span></div>
          <div class="cart-body">
            <div class="cart-vendor">${p.vendor}</div>
            <div class="cart-name">${p.name}</div>
            <div class="cart-qty-row">
              <div class="qty-stepper">
                <button data-act="dec" aria-label="Decrease">−</button>
                <span class="qty-val tabular">${it.qty}</span>
                <button data-act="inc" aria-label="Increase">+</button>
              </div>
              <button class="cart-remove" data-act="remove">Remove</button>
            </div>
          </div>
          <div class="cart-price tabular">${money(p.price * it.qty)}</div>
        </div>`;
      }).join("");

      const sub = this.subtotal();
      const shipping = sub >= 500 ? 0 : 45;
      const total = sub + shipping;
      foot.innerHTML = `
        <div class="cart-totals">
          <div class="cart-row"><span>Subtotal</span><span class="tabular">${money(sub)}</span></div>
          <div class="cart-row"><span>Shipping</span><span class="tabular">${shipping === 0 ? "Complimentary" : money(shipping)}</span></div>
          <div class="cart-row cart-total"><span>Total</span><span class="tabular">${money(total)}</span></div>
        </div>
        <button class="btn btn-primary btn-lg cart-checkout">Proceed to Checkout <span class="arrow">→</span></button>
        <div class="cart-note">Complimentary white-glove delivery on orders above $500.</div>
      `;
    },
    open() {
      const el = document.getElementById("cartDrawer");
      if (!el) return;
      const oc = bootstrap.Offcanvas.getOrCreateInstance(el);
      this.renderDrawer();
      oc.show();
    }
  };

  // ---------- Favorites ----------
  const Favorites = {
    ids: new Set(LS.get("mo_favs", [])),
    save() { LS.set("mo_favs", [...this.ids]); this.updateAll(); },
    toggle(id) {
      if (this.ids.has(id)) { this.ids.delete(id); Toast.show("Removed from saved", ""); }
      else { this.ids.add(id); Toast.show("Saved to your list", ""); }
      this.save();
    },
    has(id) { return this.ids.has(id); },
    updateAll() {
      document.querySelectorAll("[data-fav-id]").forEach(el => {
        const id = parseInt(el.dataset.favId);
        el.classList.toggle("active", this.has(id));
      });
    }
  };

  // ---------- Toast ----------
  const Toast = {
    show(title, sub = "") {
      const stack = document.getElementById("toastStack");
      if (!stack) return;
      const el = document.createElement("div");
      el.className = "mo-toast";
      el.innerHTML = `
        <div class="mo-toast-mark"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M5 12l5 5L20 7"/></svg></div>
        <div>
          <div class="mo-toast-title">${title}</div>
          ${sub ? `<div class="mo-toast-sub">${sub}</div>` : ""}
        </div>
        <button class="mo-toast-x" aria-label="Close">×</button>
      `;
      stack.appendChild(el);
      requestAnimationFrame(() => el.classList.add("on"));
      const dismiss = () => {
        el.classList.remove("on");
        setTimeout(() => el.remove(), 300);
      };
      el.querySelector(".mo-toast-x").addEventListener("click", dismiss);
      setTimeout(dismiss, 3800);
    }
  };

  // ---------- Formatting ----------
  function money(n) {
    return "$" + n.toLocaleString("en-US", { minimumFractionDigits: 0, maximumFractionDigits: 0 });
  }

  // ---------- Global UI wiring ----------
  function wireNav() {
    // Cart button
    document.querySelectorAll("[data-open-cart]").forEach(btn => {
      btn.addEventListener("click", (e) => { e.preventDefault(); Cart.open(); });
    });
    // Search button
    document.querySelectorAll("[data-open-search]").forEach(btn => {
      btn.addEventListener("click", (e) => {
        e.preventDefault();
        const el = document.getElementById("searchModal");
        if (!el) return;
        bootstrap.Modal.getOrCreateInstance(el).show();
        setTimeout(() => document.getElementById("searchInput")?.focus(), 200);
      });
    });
    // Account button
    document.querySelectorAll("[data-open-account]").forEach(btn => {
      btn.addEventListener("click", (e) => {
        e.preventDefault();
        const el = document.getElementById("accountModal");
        if (!el) return;
        bootstrap.Modal.getOrCreateInstance(el).show();
      });
    });
  }

  function wireCartDrawer() {
    const drawer = document.getElementById("cartDrawer");
    if (!drawer) return;
    drawer.addEventListener("click", (e) => {
      const line = e.target.closest(".cart-line");
      if (!line) return;
      const id = parseInt(line.dataset.id);
      const act = e.target.closest("[data-act]")?.dataset.act;
      if (!act) return;
      const item = Cart.items.find(i => i.id === id);
      if (!item) return;
      if (act === "inc") Cart.setQty(id, item.qty + 1);
      if (act === "dec") Cart.setQty(id, item.qty - 1);
      if (act === "remove") Cart.remove(id);
    });
    document.getElementById("cartDrawerFoot")?.addEventListener("click", (e) => {
      if (e.target.closest(".cart-checkout")) {
        Toast.show("Checkout is a demo", "Wire this to your payment provider.");
      }
    });
  }

  function wireSearch() {
    const input = document.getElementById("searchInput");
    if (!input) return;
    const results = document.getElementById("searchResults");
    const doSearch = (q) => {
      q = q.trim().toLowerCase();
      if (!q) {
        results.innerHTML = `<div class="search-hint">Try “raku”, “Provence”, or “vase”.</div>`;
        return;
      }
      const hits = MO_CATALOG.filter(p =>
        p.name.toLowerCase().includes(q) ||
        p.vendor.toLowerCase().includes(q) ||
        p.loc.toLowerCase().includes(q) ||
        p.cat.toLowerCase().includes(q)
      ).slice(0, 6);
      if (hits.length === 0) {
        results.innerHTML = `<div class="search-hint">No pieces match “${escapeHtml(q)}”.</div>`;
        return;
      }
      results.innerHTML = hits.map(p => `
        <a href="shop.html#p${p.id}" class="search-hit" data-id="${p.id}">
          <div class="search-thumb placeholder"><span class="placeholder-label" style="font-size:8px;">${p.vendorInit}</span></div>
          <div class="search-body">
            <div class="search-vendor">${p.vendor}</div>
            <div class="search-name">${highlight(p.name, q)}</div>
          </div>
          <div class="search-price tabular">${money(p.price)}</div>
        </a>`).join("");
    };
    input.addEventListener("input", (e) => doSearch(e.target.value));
    doSearch("");
  }

  function escapeHtml(s) {
    return s.replace(/[&<>"']/g, c => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
  }
  function highlight(text, q) {
    if (!q) return escapeHtml(text);
    const re = new RegExp("(" + q.replace(/[.*+?^${}()|[\]\\]/g, "\\$&") + ")", "ig");
    return escapeHtml(text).replace(re, "<mark>$1</mark>");
  }

  // ---------- Newsletter/generic form ----------
  function wireGenericForms() {
    document.querySelectorAll("[data-mock-form]").forEach(f => {
      f.addEventListener("submit", (e) => {
        e.preventDefault();
        Toast.show("Thank you — we'll be in touch", "");
        f.reset();
      });
    });
  }

  // ---------- Public API ----------
  window.MO = { Cart, Favorites, Toast, money };

  // ---------- Init ----------
  document.addEventListener("DOMContentLoaded", () => {
    Cart.updateBadge();
    Favorites.updateAll();
    wireNav();
    wireCartDrawer();
    wireSearch();
    wireGenericForms();
  });
})();
