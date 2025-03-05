BigInt(60 * 60 * 1e3 * 1e3 * 1e3 * 24 * 14);
const ws = 1e3;
var Et =
  typeof globalThis < "u"
    ? globalThis
    : typeof window < "u"
      ? window
      : typeof global < "u"
        ? global
        : typeof self < "u"
          ? self
          : {};
function ys(t) {
  return t && t.__esModule && Object.prototype.hasOwnProperty.call(t, "default")
    ? t.default
    : t;
}
var gs = {},
  vt = {};
vt.byteLength = bs;
vt.toByteArray = _s;
vt.fromByteArray = Bs;
var qe = [],
  Ge = [],
  xs = typeof Uint8Array < "u" ? Uint8Array : Array,
  ar = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
for (var pt = 0, ms = ar.length; pt < ms; ++pt)
  (qe[pt] = ar[pt]), (Ge[ar.charCodeAt(pt)] = pt);
Ge[45] = 62;
Ge[95] = 63;
function Jn(t) {
  var e = t.length;
  if (e % 4 > 0)
    throw new Error("Invalid string. Length must be a multiple of 4");
  var r = t.indexOf("=");
  r === -1 && (r = e);
  var s = r === e ? 0 : 4 - (r % 4);
  return [r, s];
}
function bs(t) {
  var e = Jn(t),
    r = e[0],
    s = e[1];
  return ((r + s) * 3) / 4 - s;
}
function Es(t, e, r) {
  return ((e + r) * 3) / 4 - r;
}
function _s(t) {
  var e,
    r = Jn(t),
    s = r[0],
    u = r[1],
    d = new xs(Es(t, s, u)),
    g = 0,
    c = u > 0 ? s - 4 : s,
    b;
  for (b = 0; b < c; b += 4)
    (e =
      (Ge[t.charCodeAt(b)] << 18) |
      (Ge[t.charCodeAt(b + 1)] << 12) |
      (Ge[t.charCodeAt(b + 2)] << 6) |
      Ge[t.charCodeAt(b + 3)]),
      (d[g++] = (e >> 16) & 255),
      (d[g++] = (e >> 8) & 255),
      (d[g++] = e & 255);
  return (
    u === 2 &&
      ((e = (Ge[t.charCodeAt(b)] << 2) | (Ge[t.charCodeAt(b + 1)] >> 4)),
      (d[g++] = e & 255)),
    u === 1 &&
      ((e =
        (Ge[t.charCodeAt(b)] << 10) |
        (Ge[t.charCodeAt(b + 1)] << 4) |
        (Ge[t.charCodeAt(b + 2)] >> 2)),
      (d[g++] = (e >> 8) & 255),
      (d[g++] = e & 255)),
    d
  );
}
function Is(t) {
  return (
    qe[(t >> 18) & 63] + qe[(t >> 12) & 63] + qe[(t >> 6) & 63] + qe[t & 63]
  );
}
function As(t, e, r) {
  for (var s, u = [], d = e; d < r; d += 3)
    (s =
      ((t[d] << 16) & 16711680) + ((t[d + 1] << 8) & 65280) + (t[d + 2] & 255)),
      u.push(Is(s));
  return u.join("");
}
function Bs(t) {
  for (
    var e, r = t.length, s = r % 3, u = [], d = 16383, g = 0, c = r - s;
    g < c;
    g += d
  )
    u.push(As(t, g, g + d > c ? c : g + d));
  return (
    s === 1
      ? ((e = t[r - 1]), u.push(qe[e >> 2] + qe[(e << 4) & 63] + "=="))
      : s === 2 &&
        ((e = (t[r - 2] << 8) + t[r - 1]),
        u.push(qe[e >> 10] + qe[(e >> 4) & 63] + qe[(e << 2) & 63] + "=")),
    u.join("")
  );
}
var Rt = {};
/*! ieee754. BSD-3-Clause License. Feross Aboukhadijeh <https://feross.org/opensource> */ Rt.read =
  function (t, e, r, s, u) {
    var d,
      g,
      c = u * 8 - s - 1,
      b = (1 << c) - 1,
      S = b >> 1,
      N = -7,
      L = r ? u - 1 : 0,
      O = r ? -1 : 1,
      M = t[e + L];
    for (
      L += O, d = M & ((1 << -N) - 1), M >>= -N, N += c;
      N > 0;
      d = d * 256 + t[e + L], L += O, N -= 8
    );
    for (
      g = d & ((1 << -N) - 1), d >>= -N, N += s;
      N > 0;
      g = g * 256 + t[e + L], L += O, N -= 8
    );
    if (d === 0) d = 1 - S;
    else {
      if (d === b) return g ? NaN : (M ? -1 : 1) * (1 / 0);
      (g = g + Math.pow(2, s)), (d = d - S);
    }
    return (M ? -1 : 1) * g * Math.pow(2, d - s);
  };
Rt.write = function (t, e, r, s, u, d) {
  var g,
    c,
    b,
    S = d * 8 - u - 1,
    N = (1 << S) - 1,
    L = N >> 1,
    O = u === 23 ? Math.pow(2, -24) - Math.pow(2, -77) : 0,
    M = s ? 0 : d - 1,
    q = s ? 1 : -1,
    W = e < 0 || (e === 0 && 1 / e < 0) ? 1 : 0;
  for (
    e = Math.abs(e),
      isNaN(e) || e === 1 / 0
        ? ((c = isNaN(e) ? 1 : 0), (g = N))
        : ((g = Math.floor(Math.log(e) / Math.LN2)),
          e * (b = Math.pow(2, -g)) < 1 && (g--, (b *= 2)),
          g + L >= 1 ? (e += O / b) : (e += O * Math.pow(2, 1 - L)),
          e * b >= 2 && (g++, (b /= 2)),
          g + L >= N
            ? ((c = 0), (g = N))
            : g + L >= 1
              ? ((c = (e * b - 1) * Math.pow(2, u)), (g = g + L))
              : ((c = e * Math.pow(2, L - 1) * Math.pow(2, u)), (g = 0)));
    u >= 8;
    t[r + M] = c & 255, M += q, c /= 256, u -= 8
  );
  for (
    g = (g << u) | c, S += u;
    S > 0;
    t[r + M] = g & 255, M += q, g /= 256, S -= 8
  );
  t[r + M - q] |= W * 128;
};
/*!
 * The buffer module from node.js, for the browser.
 *
 * @author   Feross Aboukhadijeh <https://feross.org>
 * @license  MIT
 */ (function (t) {
  const e = vt,
    r = Rt,
    s =
      typeof Symbol == "function" && typeof Symbol.for == "function"
        ? Symbol.for("nodejs.util.inspect.custom")
        : null;
  (t.Buffer = c), (t.SlowBuffer = ae), (t.INSPECT_MAX_BYTES = 50);
  const u = 2147483647;
  (t.kMaxLength = u),
    (c.TYPED_ARRAY_SUPPORT = d()),
    !c.TYPED_ARRAY_SUPPORT &&
      typeof console < "u" &&
      typeof console.error == "function" &&
      console.error(
        "This browser lacks typed array (Uint8Array) support which is required by `buffer` v5.x. Use `buffer` v4.x if you require old browser support.",
      );
  function d() {
    try {
      const h = new Uint8Array(1),
        o = {
          foo: function () {
            return 42;
          },
        };
      return (
        Object.setPrototypeOf(o, Uint8Array.prototype),
        Object.setPrototypeOf(h, o),
        h.foo() === 42
      );
    } catch {
      return !1;
    }
  }
  Object.defineProperty(c.prototype, "parent", {
    enumerable: !0,
    get: function () {
      if (c.isBuffer(this)) return this.buffer;
    },
  }),
    Object.defineProperty(c.prototype, "offset", {
      enumerable: !0,
      get: function () {
        if (c.isBuffer(this)) return this.byteOffset;
      },
    });
  function g(h) {
    if (h > u)
      throw new RangeError(
        'The value "' + h + '" is invalid for option "size"',
      );
    const o = new Uint8Array(h);
    return Object.setPrototypeOf(o, c.prototype), o;
  }
  function c(h, o, a) {
    if (typeof h == "number") {
      if (typeof o == "string")
        throw new TypeError(
          'The "string" argument must be of type string. Received type number',
        );
      return L(h);
    }
    return b(h, o, a);
  }
  c.poolSize = 8192;
  function b(h, o, a) {
    if (typeof h == "string") return O(h, o);
    if (ArrayBuffer.isView(h)) return q(h);
    if (h == null)
      throw new TypeError(
        "The first argument must be one of type string, Buffer, ArrayBuffer, Array, or Array-like Object. Received type " +
          typeof h,
      );
    if (
      F(h, ArrayBuffer) ||
      (h && F(h.buffer, ArrayBuffer)) ||
      (typeof SharedArrayBuffer < "u" &&
        (F(h, SharedArrayBuffer) || (h && F(h.buffer, SharedArrayBuffer))))
    )
      return W(h, o, a);
    if (typeof h == "number")
      throw new TypeError(
        'The "value" argument must not be of type number. Received type number',
      );
    const m = h.valueOf && h.valueOf();
    if (m != null && m !== h) return c.from(m, o, a);
    const A = le(h);
    if (A) return A;
    if (
      typeof Symbol < "u" &&
      Symbol.toPrimitive != null &&
      typeof h[Symbol.toPrimitive] == "function"
    )
      return c.from(h[Symbol.toPrimitive]("string"), o, a);
    throw new TypeError(
      "The first argument must be one of type string, Buffer, ArrayBuffer, Array, or Array-like Object. Received type " +
        typeof h,
    );
  }
  (c.from = function (h, o, a) {
    return b(h, o, a);
  }),
    Object.setPrototypeOf(c.prototype, Uint8Array.prototype),
    Object.setPrototypeOf(c, Uint8Array);
  function S(h) {
    if (typeof h != "number")
      throw new TypeError('"size" argument must be of type number');
    if (h < 0)
      throw new RangeError(
        'The value "' + h + '" is invalid for option "size"',
      );
  }
  function N(h, o, a) {
    return (
      S(h),
      h <= 0
        ? g(h)
        : o !== void 0
          ? typeof a == "string"
            ? g(h).fill(o, a)
            : g(h).fill(o)
          : g(h)
    );
  }
  c.alloc = function (h, o, a) {
    return N(h, o, a);
  };
  function L(h) {
    return S(h), g(h < 0 ? 0 : Ee(h) | 0);
  }
  (c.allocUnsafe = function (h) {
    return L(h);
  }),
    (c.allocUnsafeSlow = function (h) {
      return L(h);
    });
  function O(h, o) {
    if (((typeof o != "string" || o === "") && (o = "utf8"), !c.isEncoding(o)))
      throw new TypeError("Unknown encoding: " + o);
    const a = K(h, o) | 0;
    let m = g(a);
    const A = m.write(h, o);
    return A !== a && (m = m.slice(0, A)), m;
  }
  function M(h) {
    const o = h.length < 0 ? 0 : Ee(h.length) | 0,
      a = g(o);
    for (let m = 0; m < o; m += 1) a[m] = h[m] & 255;
    return a;
  }
  function q(h) {
    if (F(h, Uint8Array)) {
      const o = new Uint8Array(h);
      return W(o.buffer, o.byteOffset, o.byteLength);
    }
    return M(h);
  }
  function W(h, o, a) {
    if (o < 0 || h.byteLength < o)
      throw new RangeError('"offset" is outside of buffer bounds');
    if (h.byteLength < o + (a || 0))
      throw new RangeError('"length" is outside of buffer bounds');
    let m;
    return (
      o === void 0 && a === void 0
        ? (m = new Uint8Array(h))
        : a === void 0
          ? (m = new Uint8Array(h, o))
          : (m = new Uint8Array(h, o, a)),
      Object.setPrototypeOf(m, c.prototype),
      m
    );
  }
  function le(h) {
    if (c.isBuffer(h)) {
      const o = Ee(h.length) | 0,
        a = g(o);
      return a.length === 0 || h.copy(a, 0, 0, o), a;
    }
    if (h.length !== void 0)
      return typeof h.length != "number" || D(h.length) ? g(0) : M(h);
    if (h.type === "Buffer" && Array.isArray(h.data)) return M(h.data);
  }
  function Ee(h) {
    if (h >= u)
      throw new RangeError(
        "Attempt to allocate Buffer larger than maximum size: 0x" +
          u.toString(16) +
          " bytes",
      );
    return h | 0;
  }
  function ae(h) {
    return +h != h && (h = 0), c.alloc(+h);
  }
  (c.isBuffer = function (o) {
    return o != null && o._isBuffer === !0 && o !== c.prototype;
  }),
    (c.compare = function (o, a) {
      if (
        (F(o, Uint8Array) && (o = c.from(o, o.offset, o.byteLength)),
        F(a, Uint8Array) && (a = c.from(a, a.offset, a.byteLength)),
        !c.isBuffer(o) || !c.isBuffer(a))
      )
        throw new TypeError(
          'The "buf1", "buf2" arguments must be one of type Buffer or Uint8Array',
        );
      if (o === a) return 0;
      let m = o.length,
        A = a.length;
      for (let R = 0, v = Math.min(m, A); R < v; ++R)
        if (o[R] !== a[R]) {
          (m = o[R]), (A = a[R]);
          break;
        }
      return m < A ? -1 : A < m ? 1 : 0;
    }),
    (c.isEncoding = function (o) {
      switch (String(o).toLowerCase()) {
        case "hex":
        case "utf8":
        case "utf-8":
        case "ascii":
        case "latin1":
        case "binary":
        case "base64":
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return !0;
        default:
          return !1;
      }
    }),
    (c.concat = function (o, a) {
      if (!Array.isArray(o))
        throw new TypeError('"list" argument must be an Array of Buffers');
      if (o.length === 0) return c.alloc(0);
      let m;
      if (a === void 0) for (a = 0, m = 0; m < o.length; ++m) a += o[m].length;
      const A = c.allocUnsafe(a);
      let R = 0;
      for (m = 0; m < o.length; ++m) {
        let v = o[m];
        if (F(v, Uint8Array))
          R + v.length > A.length
            ? (c.isBuffer(v) || (v = c.from(v)), v.copy(A, R))
            : Uint8Array.prototype.set.call(A, v, R);
        else if (c.isBuffer(v)) v.copy(A, R);
        else throw new TypeError('"list" argument must be an Array of Buffers');
        R += v.length;
      }
      return A;
    });
  function K(h, o) {
    if (c.isBuffer(h)) return h.length;
    if (ArrayBuffer.isView(h) || F(h, ArrayBuffer)) return h.byteLength;
    if (typeof h != "string")
      throw new TypeError(
        'The "string" argument must be one of type string, Buffer, or ArrayBuffer. Received type ' +
          typeof h,
      );
    const a = h.length,
      m = arguments.length > 2 && arguments[2] === !0;
    if (!m && a === 0) return 0;
    let A = !1;
    for (;;)
      switch (o) {
        case "ascii":
        case "latin1":
        case "binary":
          return a;
        case "utf8":
        case "utf-8":
          return n(h).length;
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return a * 2;
        case "hex":
          return a >>> 1;
        case "base64":
          return p(h).length;
        default:
          if (A) return m ? -1 : n(h).length;
          (o = ("" + o).toLowerCase()), (A = !0);
      }
  }
  c.byteLength = K;
  function Ue(h, o, a) {
    let m = !1;
    if (
      ((o === void 0 || o < 0) && (o = 0),
      o > this.length ||
        ((a === void 0 || a > this.length) && (a = this.length), a <= 0) ||
        ((a >>>= 0), (o >>>= 0), a <= o))
    )
      return "";
    for (h || (h = "utf8"); ; )
      switch (h) {
        case "hex":
          return j(this, o, a);
        case "utf8":
        case "utf-8":
          return Se(this, o, a);
        case "ascii":
          return P(this, o, a);
        case "latin1":
        case "binary":
          return k(this, o, a);
        case "base64":
          return fe(this, o, a);
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return Q(this, o, a);
        default:
          if (m) throw new TypeError("Unknown encoding: " + h);
          (h = (h + "").toLowerCase()), (m = !0);
      }
  }
  c.prototype._isBuffer = !0;
  function ue(h, o, a) {
    const m = h[o];
    (h[o] = h[a]), (h[a] = m);
  }
  (c.prototype.swap16 = function () {
    const o = this.length;
    if (o % 2 !== 0)
      throw new RangeError("Buffer size must be a multiple of 16-bits");
    for (let a = 0; a < o; a += 2) ue(this, a, a + 1);
    return this;
  }),
    (c.prototype.swap32 = function () {
      const o = this.length;
      if (o % 4 !== 0)
        throw new RangeError("Buffer size must be a multiple of 32-bits");
      for (let a = 0; a < o; a += 4) ue(this, a, a + 3), ue(this, a + 1, a + 2);
      return this;
    }),
    (c.prototype.swap64 = function () {
      const o = this.length;
      if (o % 8 !== 0)
        throw new RangeError("Buffer size must be a multiple of 64-bits");
      for (let a = 0; a < o; a += 8)
        ue(this, a, a + 7),
          ue(this, a + 1, a + 6),
          ue(this, a + 2, a + 5),
          ue(this, a + 3, a + 4);
      return this;
    }),
    (c.prototype.toString = function () {
      const o = this.length;
      return o === 0
        ? ""
        : arguments.length === 0
          ? Se(this, 0, o)
          : Ue.apply(this, arguments);
    }),
    (c.prototype.toLocaleString = c.prototype.toString),
    (c.prototype.equals = function (o) {
      if (!c.isBuffer(o)) throw new TypeError("Argument must be a Buffer");
      return this === o ? !0 : c.compare(this, o) === 0;
    }),
    (c.prototype.inspect = function () {
      let o = "";
      const a = t.INSPECT_MAX_BYTES;
      return (
        (o = this.toString("hex", 0, a)
          .replace(/(.{2})/g, "$1 ")
          .trim()),
        this.length > a && (o += " ... "),
        "<Buffer " + o + ">"
      );
    }),
    s && (c.prototype[s] = c.prototype.inspect),
    (c.prototype.compare = function (o, a, m, A, R) {
      if (
        (F(o, Uint8Array) && (o = c.from(o, o.offset, o.byteLength)),
        !c.isBuffer(o))
      )
        throw new TypeError(
          'The "target" argument must be one of type Buffer or Uint8Array. Received type ' +
            typeof o,
        );
      if (
        (a === void 0 && (a = 0),
        m === void 0 && (m = o ? o.length : 0),
        A === void 0 && (A = 0),
        R === void 0 && (R = this.length),
        a < 0 || m > o.length || A < 0 || R > this.length)
      )
        throw new RangeError("out of range index");
      if (A >= R && a >= m) return 0;
      if (A >= R) return -1;
      if (a >= m) return 1;
      if (((a >>>= 0), (m >>>= 0), (A >>>= 0), (R >>>= 0), this === o))
        return 0;
      let v = R - A,
        te = m - a;
      const he = Math.min(v, te),
        se = this.slice(A, R),
        ee = o.slice(a, m);
      for (let be = 0; be < he; ++be)
        if (se[be] !== ee[be]) {
          (v = se[be]), (te = ee[be]);
          break;
        }
      return v < te ? -1 : te < v ? 1 : 0;
    });
  function J(h, o, a, m, A) {
    if (h.length === 0) return -1;
    if (
      (typeof a == "string"
        ? ((m = a), (a = 0))
        : a > 2147483647
          ? (a = 2147483647)
          : a < -2147483648 && (a = -2147483648),
      (a = +a),
      D(a) && (a = A ? 0 : h.length - 1),
      a < 0 && (a = h.length + a),
      a >= h.length)
    ) {
      if (A) return -1;
      a = h.length - 1;
    } else if (a < 0)
      if (A) a = 0;
      else return -1;
    if ((typeof o == "string" && (o = c.from(o, m)), c.isBuffer(o)))
      return o.length === 0 ? -1 : X(h, o, a, m, A);
    if (typeof o == "number")
      return (
        (o = o & 255),
        typeof Uint8Array.prototype.indexOf == "function"
          ? A
            ? Uint8Array.prototype.indexOf.call(h, o, a)
            : Uint8Array.prototype.lastIndexOf.call(h, o, a)
          : X(h, [o], a, m, A)
      );
    throw new TypeError("val must be string, number or Buffer");
  }
  function X(h, o, a, m, A) {
    let R = 1,
      v = h.length,
      te = o.length;
    if (
      m !== void 0 &&
      ((m = String(m).toLowerCase()),
      m === "ucs2" || m === "ucs-2" || m === "utf16le" || m === "utf-16le")
    ) {
      if (h.length < 2 || o.length < 2) return -1;
      (R = 2), (v /= 2), (te /= 2), (a /= 2);
    }
    function he(ee, be) {
      return R === 1 ? ee[be] : ee.readUInt16BE(be * R);
    }
    let se;
    if (A) {
      let ee = -1;
      for (se = a; se < v; se++)
        if (he(h, se) === he(o, ee === -1 ? 0 : se - ee)) {
          if ((ee === -1 && (ee = se), se - ee + 1 === te)) return ee * R;
        } else ee !== -1 && (se -= se - ee), (ee = -1);
    } else
      for (a + te > v && (a = v - te), se = a; se >= 0; se--) {
        let ee = !0;
        for (let be = 0; be < te; be++)
          if (he(h, se + be) !== he(o, be)) {
            ee = !1;
            break;
          }
        if (ee) return se;
      }
    return -1;
  }
  (c.prototype.includes = function (o, a, m) {
    return this.indexOf(o, a, m) !== -1;
  }),
    (c.prototype.indexOf = function (o, a, m) {
      return J(this, o, a, m, !0);
    }),
    (c.prototype.lastIndexOf = function (o, a, m) {
      return J(this, o, a, m, !1);
    });
  function ne(h, o, a, m) {
    a = Number(a) || 0;
    const A = h.length - a;
    m ? ((m = Number(m)), m > A && (m = A)) : (m = A);
    const R = o.length;
    m > R / 2 && (m = R / 2);
    let v;
    for (v = 0; v < m; ++v) {
      const te = parseInt(o.substr(v * 2, 2), 16);
      if (D(te)) return v;
      h[a + v] = te;
    }
    return v;
  }
  function ie(h, o, a, m) {
    return E(n(o, h.length - a), h, a, m);
  }
  function C(h, o, a, m) {
    return E(i(o), h, a, m);
  }
  function xe(h, o, a, m) {
    return E(p(o), h, a, m);
  }
  function ce(h, o, a, m) {
    return E(l(o, h.length - a), h, a, m);
  }
  (c.prototype.write = function (o, a, m, A) {
    if (a === void 0) (A = "utf8"), (m = this.length), (a = 0);
    else if (m === void 0 && typeof a == "string")
      (A = a), (m = this.length), (a = 0);
    else if (isFinite(a))
      (a = a >>> 0),
        isFinite(m)
          ? ((m = m >>> 0), A === void 0 && (A = "utf8"))
          : ((A = m), (m = void 0));
    else
      throw new Error(
        "Buffer.write(string, encoding, offset[, length]) is no longer supported",
      );
    const R = this.length - a;
    if (
      ((m === void 0 || m > R) && (m = R),
      (o.length > 0 && (m < 0 || a < 0)) || a > this.length)
    )
      throw new RangeError("Attempt to write outside buffer bounds");
    A || (A = "utf8");
    let v = !1;
    for (;;)
      switch (A) {
        case "hex":
          return ne(this, o, a, m);
        case "utf8":
        case "utf-8":
          return ie(this, o, a, m);
        case "ascii":
        case "latin1":
        case "binary":
          return C(this, o, a, m);
        case "base64":
          return xe(this, o, a, m);
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return ce(this, o, a, m);
        default:
          if (v) throw new TypeError("Unknown encoding: " + A);
          (A = ("" + A).toLowerCase()), (v = !0);
      }
  }),
    (c.prototype.toJSON = function () {
      return {
        type: "Buffer",
        data: Array.prototype.slice.call(this._arr || this, 0),
      };
    });
  function fe(h, o, a) {
    return o === 0 && a === h.length
      ? e.fromByteArray(h)
      : e.fromByteArray(h.slice(o, a));
  }
  function Se(h, o, a) {
    a = Math.min(h.length, a);
    const m = [];
    let A = o;
    for (; A < a; ) {
      const R = h[A];
      let v = null,
        te = R > 239 ? 4 : R > 223 ? 3 : R > 191 ? 2 : 1;
      if (A + te <= a) {
        let he, se, ee, be;
        switch (te) {
          case 1:
            R < 128 && (v = R);
            break;
          case 2:
            (he = h[A + 1]),
              (he & 192) === 128 &&
                ((be = ((R & 31) << 6) | (he & 63)), be > 127 && (v = be));
            break;
          case 3:
            (he = h[A + 1]),
              (se = h[A + 2]),
              (he & 192) === 128 &&
                (se & 192) === 128 &&
                ((be = ((R & 15) << 12) | ((he & 63) << 6) | (se & 63)),
                be > 2047 && (be < 55296 || be > 57343) && (v = be));
            break;
          case 4:
            (he = h[A + 1]),
              (se = h[A + 2]),
              (ee = h[A + 3]),
              (he & 192) === 128 &&
                (se & 192) === 128 &&
                (ee & 192) === 128 &&
                ((be =
                  ((R & 15) << 18) |
                  ((he & 63) << 12) |
                  ((se & 63) << 6) |
                  (ee & 63)),
                be > 65535 && be < 1114112 && (v = be));
        }
      }
      v === null
        ? ((v = 65533), (te = 1))
        : v > 65535 &&
          ((v -= 65536),
          m.push(((v >>> 10) & 1023) | 55296),
          (v = 56320 | (v & 1023))),
        m.push(v),
        (A += te);
    }
    return Z(m);
  }
  const _e = 4096;
  function Z(h) {
    const o = h.length;
    if (o <= _e) return String.fromCharCode.apply(String, h);
    let a = "",
      m = 0;
    for (; m < o; )
      a += String.fromCharCode.apply(String, h.slice(m, (m += _e)));
    return a;
  }
  function P(h, o, a) {
    let m = "";
    a = Math.min(h.length, a);
    for (let A = o; A < a; ++A) m += String.fromCharCode(h[A] & 127);
    return m;
  }
  function k(h, o, a) {
    let m = "";
    a = Math.min(h.length, a);
    for (let A = o; A < a; ++A) m += String.fromCharCode(h[A]);
    return m;
  }
  function j(h, o, a) {
    const m = h.length;
    (!o || o < 0) && (o = 0), (!a || a < 0 || a > m) && (a = m);
    let A = "";
    for (let R = o; R < a; ++R) A += z[h[R]];
    return A;
  }
  function Q(h, o, a) {
    const m = h.slice(o, a);
    let A = "";
    for (let R = 0; R < m.length - 1; R += 2)
      A += String.fromCharCode(m[R] + m[R + 1] * 256);
    return A;
  }
  c.prototype.slice = function (o, a) {
    const m = this.length;
    (o = ~~o),
      (a = a === void 0 ? m : ~~a),
      o < 0 ? ((o += m), o < 0 && (o = 0)) : o > m && (o = m),
      a < 0 ? ((a += m), a < 0 && (a = 0)) : a > m && (a = m),
      a < o && (a = o);
    const A = this.subarray(o, a);
    return Object.setPrototypeOf(A, c.prototype), A;
  };
  function G(h, o, a) {
    if (h % 1 !== 0 || h < 0) throw new RangeError("offset is not uint");
    if (h + o > a)
      throw new RangeError("Trying to access beyond buffer length");
  }
  (c.prototype.readUintLE = c.prototype.readUIntLE =
    function (o, a, m) {
      (o = o >>> 0), (a = a >>> 0), m || G(o, a, this.length);
      let A = this[o],
        R = 1,
        v = 0;
      for (; ++v < a && (R *= 256); ) A += this[o + v] * R;
      return A;
    }),
    (c.prototype.readUintBE = c.prototype.readUIntBE =
      function (o, a, m) {
        (o = o >>> 0), (a = a >>> 0), m || G(o, a, this.length);
        let A = this[o + --a],
          R = 1;
        for (; a > 0 && (R *= 256); ) A += this[o + --a] * R;
        return A;
      }),
    (c.prototype.readUint8 = c.prototype.readUInt8 =
      function (o, a) {
        return (o = o >>> 0), a || G(o, 1, this.length), this[o];
      }),
    (c.prototype.readUint16LE = c.prototype.readUInt16LE =
      function (o, a) {
        return (
          (o = o >>> 0), a || G(o, 2, this.length), this[o] | (this[o + 1] << 8)
        );
      }),
    (c.prototype.readUint16BE = c.prototype.readUInt16BE =
      function (o, a) {
        return (
          (o = o >>> 0), a || G(o, 2, this.length), (this[o] << 8) | this[o + 1]
        );
      }),
    (c.prototype.readUint32LE = c.prototype.readUInt32LE =
      function (o, a) {
        return (
          (o = o >>> 0),
          a || G(o, 4, this.length),
          (this[o] | (this[o + 1] << 8) | (this[o + 2] << 16)) +
            this[o + 3] * 16777216
        );
      }),
    (c.prototype.readUint32BE = c.prototype.readUInt32BE =
      function (o, a) {
        return (
          (o = o >>> 0),
          a || G(o, 4, this.length),
          this[o] * 16777216 +
            ((this[o + 1] << 16) | (this[o + 2] << 8) | this[o + 3])
        );
      }),
    (c.prototype.readBigUInt64LE = V(function (o) {
      (o = o >>> 0), T(o, "offset");
      const a = this[o],
        m = this[o + 7];
      (a === void 0 || m === void 0) && B(o, this.length - 8);
      const A =
          a + this[++o] * 2 ** 8 + this[++o] * 2 ** 16 + this[++o] * 2 ** 24,
        R = this[++o] + this[++o] * 2 ** 8 + this[++o] * 2 ** 16 + m * 2 ** 24;
      return BigInt(A) + (BigInt(R) << BigInt(32));
    })),
    (c.prototype.readBigUInt64BE = V(function (o) {
      (o = o >>> 0), T(o, "offset");
      const a = this[o],
        m = this[o + 7];
      (a === void 0 || m === void 0) && B(o, this.length - 8);
      const A =
          a * 2 ** 24 + this[++o] * 2 ** 16 + this[++o] * 2 ** 8 + this[++o],
        R = this[++o] * 2 ** 24 + this[++o] * 2 ** 16 + this[++o] * 2 ** 8 + m;
      return (BigInt(A) << BigInt(32)) + BigInt(R);
    })),
    (c.prototype.readIntLE = function (o, a, m) {
      (o = o >>> 0), (a = a >>> 0), m || G(o, a, this.length);
      let A = this[o],
        R = 1,
        v = 0;
      for (; ++v < a && (R *= 256); ) A += this[o + v] * R;
      return (R *= 128), A >= R && (A -= Math.pow(2, 8 * a)), A;
    }),
    (c.prototype.readIntBE = function (o, a, m) {
      (o = o >>> 0), (a = a >>> 0), m || G(o, a, this.length);
      let A = a,
        R = 1,
        v = this[o + --A];
      for (; A > 0 && (R *= 256); ) v += this[o + --A] * R;
      return (R *= 128), v >= R && (v -= Math.pow(2, 8 * a)), v;
    }),
    (c.prototype.readInt8 = function (o, a) {
      return (
        (o = o >>> 0),
        a || G(o, 1, this.length),
        this[o] & 128 ? (255 - this[o] + 1) * -1 : this[o]
      );
    }),
    (c.prototype.readInt16LE = function (o, a) {
      (o = o >>> 0), a || G(o, 2, this.length);
      const m = this[o] | (this[o + 1] << 8);
      return m & 32768 ? m | 4294901760 : m;
    }),
    (c.prototype.readInt16BE = function (o, a) {
      (o = o >>> 0), a || G(o, 2, this.length);
      const m = this[o + 1] | (this[o] << 8);
      return m & 32768 ? m | 4294901760 : m;
    }),
    (c.prototype.readInt32LE = function (o, a) {
      return (
        (o = o >>> 0),
        a || G(o, 4, this.length),
        this[o] | (this[o + 1] << 8) | (this[o + 2] << 16) | (this[o + 3] << 24)
      );
    }),
    (c.prototype.readInt32BE = function (o, a) {
      return (
        (o = o >>> 0),
        a || G(o, 4, this.length),
        (this[o] << 24) | (this[o + 1] << 16) | (this[o + 2] << 8) | this[o + 3]
      );
    }),
    (c.prototype.readBigInt64LE = V(function (o) {
      (o = o >>> 0), T(o, "offset");
      const a = this[o],
        m = this[o + 7];
      (a === void 0 || m === void 0) && B(o, this.length - 8);
      const A =
        this[o + 4] + this[o + 5] * 2 ** 8 + this[o + 6] * 2 ** 16 + (m << 24);
      return (
        (BigInt(A) << BigInt(32)) +
        BigInt(
          a + this[++o] * 2 ** 8 + this[++o] * 2 ** 16 + this[++o] * 2 ** 24,
        )
      );
    })),
    (c.prototype.readBigInt64BE = V(function (o) {
      (o = o >>> 0), T(o, "offset");
      const a = this[o],
        m = this[o + 7];
      (a === void 0 || m === void 0) && B(o, this.length - 8);
      const A =
        (a << 24) + this[++o] * 2 ** 16 + this[++o] * 2 ** 8 + this[++o];
      return (
        (BigInt(A) << BigInt(32)) +
        BigInt(
          this[++o] * 2 ** 24 + this[++o] * 2 ** 16 + this[++o] * 2 ** 8 + m,
        )
      );
    })),
    (c.prototype.readFloatLE = function (o, a) {
      return (
        (o = o >>> 0), a || G(o, 4, this.length), r.read(this, o, !0, 23, 4)
      );
    }),
    (c.prototype.readFloatBE = function (o, a) {
      return (
        (o = o >>> 0), a || G(o, 4, this.length), r.read(this, o, !1, 23, 4)
      );
    }),
    (c.prototype.readDoubleLE = function (o, a) {
      return (
        (o = o >>> 0), a || G(o, 8, this.length), r.read(this, o, !0, 52, 8)
      );
    }),
    (c.prototype.readDoubleBE = function (o, a) {
      return (
        (o = o >>> 0), a || G(o, 8, this.length), r.read(this, o, !1, 52, 8)
      );
    });
  function $(h, o, a, m, A, R) {
    if (!c.isBuffer(h))
      throw new TypeError('"buffer" argument must be a Buffer instance');
    if (o > A || o < R)
      throw new RangeError('"value" argument is out of bounds');
    if (a + m > h.length) throw new RangeError("Index out of range");
  }
  (c.prototype.writeUintLE = c.prototype.writeUIntLE =
    function (o, a, m, A) {
      if (((o = +o), (a = a >>> 0), (m = m >>> 0), !A)) {
        const te = Math.pow(2, 8 * m) - 1;
        $(this, o, a, m, te, 0);
      }
      let R = 1,
        v = 0;
      for (this[a] = o & 255; ++v < m && (R *= 256); )
        this[a + v] = (o / R) & 255;
      return a + m;
    }),
    (c.prototype.writeUintBE = c.prototype.writeUIntBE =
      function (o, a, m, A) {
        if (((o = +o), (a = a >>> 0), (m = m >>> 0), !A)) {
          const te = Math.pow(2, 8 * m) - 1;
          $(this, o, a, m, te, 0);
        }
        let R = m - 1,
          v = 1;
        for (this[a + R] = o & 255; --R >= 0 && (v *= 256); )
          this[a + R] = (o / v) & 255;
        return a + m;
      }),
    (c.prototype.writeUint8 = c.prototype.writeUInt8 =
      function (o, a, m) {
        return (
          (o = +o),
          (a = a >>> 0),
          m || $(this, o, a, 1, 255, 0),
          (this[a] = o & 255),
          a + 1
        );
      }),
    (c.prototype.writeUint16LE = c.prototype.writeUInt16LE =
      function (o, a, m) {
        return (
          (o = +o),
          (a = a >>> 0),
          m || $(this, o, a, 2, 65535, 0),
          (this[a] = o & 255),
          (this[a + 1] = o >>> 8),
          a + 2
        );
      }),
    (c.prototype.writeUint16BE = c.prototype.writeUInt16BE =
      function (o, a, m) {
        return (
          (o = +o),
          (a = a >>> 0),
          m || $(this, o, a, 2, 65535, 0),
          (this[a] = o >>> 8),
          (this[a + 1] = o & 255),
          a + 2
        );
      }),
    (c.prototype.writeUint32LE = c.prototype.writeUInt32LE =
      function (o, a, m) {
        return (
          (o = +o),
          (a = a >>> 0),
          m || $(this, o, a, 4, 4294967295, 0),
          (this[a + 3] = o >>> 24),
          (this[a + 2] = o >>> 16),
          (this[a + 1] = o >>> 8),
          (this[a] = o & 255),
          a + 4
        );
      }),
    (c.prototype.writeUint32BE = c.prototype.writeUInt32BE =
      function (o, a, m) {
        return (
          (o = +o),
          (a = a >>> 0),
          m || $(this, o, a, 4, 4294967295, 0),
          (this[a] = o >>> 24),
          (this[a + 1] = o >>> 16),
          (this[a + 2] = o >>> 8),
          (this[a + 3] = o & 255),
          a + 4
        );
      });
  function ye(h, o, a, m, A) {
    _(o, m, A, h, a, 7);
    let R = Number(o & BigInt(4294967295));
    (h[a++] = R),
      (R = R >> 8),
      (h[a++] = R),
      (R = R >> 8),
      (h[a++] = R),
      (R = R >> 8),
      (h[a++] = R);
    let v = Number((o >> BigInt(32)) & BigInt(4294967295));
    return (
      (h[a++] = v),
      (v = v >> 8),
      (h[a++] = v),
      (v = v >> 8),
      (h[a++] = v),
      (v = v >> 8),
      (h[a++] = v),
      a
    );
  }
  function y(h, o, a, m, A) {
    _(o, m, A, h, a, 7);
    let R = Number(o & BigInt(4294967295));
    (h[a + 7] = R),
      (R = R >> 8),
      (h[a + 6] = R),
      (R = R >> 8),
      (h[a + 5] = R),
      (R = R >> 8),
      (h[a + 4] = R);
    let v = Number((o >> BigInt(32)) & BigInt(4294967295));
    return (
      (h[a + 3] = v),
      (v = v >> 8),
      (h[a + 2] = v),
      (v = v >> 8),
      (h[a + 1] = v),
      (v = v >> 8),
      (h[a] = v),
      a + 8
    );
  }
  (c.prototype.writeBigUInt64LE = V(function (o, a = 0) {
    return ye(this, o, a, BigInt(0), BigInt("0xffffffffffffffff"));
  })),
    (c.prototype.writeBigUInt64BE = V(function (o, a = 0) {
      return y(this, o, a, BigInt(0), BigInt("0xffffffffffffffff"));
    })),
    (c.prototype.writeIntLE = function (o, a, m, A) {
      if (((o = +o), (a = a >>> 0), !A)) {
        const he = Math.pow(2, 8 * m - 1);
        $(this, o, a, m, he - 1, -he);
      }
      let R = 0,
        v = 1,
        te = 0;
      for (this[a] = o & 255; ++R < m && (v *= 256); )
        o < 0 && te === 0 && this[a + R - 1] !== 0 && (te = 1),
          (this[a + R] = (((o / v) >> 0) - te) & 255);
      return a + m;
    }),
    (c.prototype.writeIntBE = function (o, a, m, A) {
      if (((o = +o), (a = a >>> 0), !A)) {
        const he = Math.pow(2, 8 * m - 1);
        $(this, o, a, m, he - 1, -he);
      }
      let R = m - 1,
        v = 1,
        te = 0;
      for (this[a + R] = o & 255; --R >= 0 && (v *= 256); )
        o < 0 && te === 0 && this[a + R + 1] !== 0 && (te = 1),
          (this[a + R] = (((o / v) >> 0) - te) & 255);
      return a + m;
    }),
    (c.prototype.writeInt8 = function (o, a, m) {
      return (
        (o = +o),
        (a = a >>> 0),
        m || $(this, o, a, 1, 127, -128),
        o < 0 && (o = 255 + o + 1),
        (this[a] = o & 255),
        a + 1
      );
    }),
    (c.prototype.writeInt16LE = function (o, a, m) {
      return (
        (o = +o),
        (a = a >>> 0),
        m || $(this, o, a, 2, 32767, -32768),
        (this[a] = o & 255),
        (this[a + 1] = o >>> 8),
        a + 2
      );
    }),
    (c.prototype.writeInt16BE = function (o, a, m) {
      return (
        (o = +o),
        (a = a >>> 0),
        m || $(this, o, a, 2, 32767, -32768),
        (this[a] = o >>> 8),
        (this[a + 1] = o & 255),
        a + 2
      );
    }),
    (c.prototype.writeInt32LE = function (o, a, m) {
      return (
        (o = +o),
        (a = a >>> 0),
        m || $(this, o, a, 4, 2147483647, -2147483648),
        (this[a] = o & 255),
        (this[a + 1] = o >>> 8),
        (this[a + 2] = o >>> 16),
        (this[a + 3] = o >>> 24),
        a + 4
      );
    }),
    (c.prototype.writeInt32BE = function (o, a, m) {
      return (
        (o = +o),
        (a = a >>> 0),
        m || $(this, o, a, 4, 2147483647, -2147483648),
        o < 0 && (o = 4294967295 + o + 1),
        (this[a] = o >>> 24),
        (this[a + 1] = o >>> 16),
        (this[a + 2] = o >>> 8),
        (this[a + 3] = o & 255),
        a + 4
      );
    }),
    (c.prototype.writeBigInt64LE = V(function (o, a = 0) {
      return ye(
        this,
        o,
        a,
        -BigInt("0x8000000000000000"),
        BigInt("0x7fffffffffffffff"),
      );
    })),
    (c.prototype.writeBigInt64BE = V(function (o, a = 0) {
      return y(
        this,
        o,
        a,
        -BigInt("0x8000000000000000"),
        BigInt("0x7fffffffffffffff"),
      );
    }));
  function de(h, o, a, m, A, R) {
    if (a + m > h.length) throw new RangeError("Index out of range");
    if (a < 0) throw new RangeError("Index out of range");
  }
  function me(h, o, a, m, A) {
    return (
      (o = +o),
      (a = a >>> 0),
      A || de(h, o, a, 4),
      r.write(h, o, a, m, 23, 4),
      a + 4
    );
  }
  (c.prototype.writeFloatLE = function (o, a, m) {
    return me(this, o, a, !0, m);
  }),
    (c.prototype.writeFloatBE = function (o, a, m) {
      return me(this, o, a, !1, m);
    });
  function Te(h, o, a, m, A) {
    return (
      (o = +o),
      (a = a >>> 0),
      A || de(h, o, a, 8),
      r.write(h, o, a, m, 52, 8),
      a + 8
    );
  }
  (c.prototype.writeDoubleLE = function (o, a, m) {
    return Te(this, o, a, !0, m);
  }),
    (c.prototype.writeDoubleBE = function (o, a, m) {
      return Te(this, o, a, !1, m);
    }),
    (c.prototype.copy = function (o, a, m, A) {
      if (!c.isBuffer(o)) throw new TypeError("argument should be a Buffer");
      if (
        (m || (m = 0),
        !A && A !== 0 && (A = this.length),
        a >= o.length && (a = o.length),
        a || (a = 0),
        A > 0 && A < m && (A = m),
        A === m || o.length === 0 || this.length === 0)
      )
        return 0;
      if (a < 0) throw new RangeError("targetStart out of bounds");
      if (m < 0 || m >= this.length) throw new RangeError("Index out of range");
      if (A < 0) throw new RangeError("sourceEnd out of bounds");
      A > this.length && (A = this.length),
        o.length - a < A - m && (A = o.length - a + m);
      const R = A - m;
      return (
        this === o && typeof Uint8Array.prototype.copyWithin == "function"
          ? this.copyWithin(a, m, A)
          : Uint8Array.prototype.set.call(o, this.subarray(m, A), a),
        R
      );
    }),
    (c.prototype.fill = function (o, a, m, A) {
      if (typeof o == "string") {
        if (
          (typeof a == "string"
            ? ((A = a), (a = 0), (m = this.length))
            : typeof m == "string" && ((A = m), (m = this.length)),
          A !== void 0 && typeof A != "string")
        )
          throw new TypeError("encoding must be a string");
        if (typeof A == "string" && !c.isEncoding(A))
          throw new TypeError("Unknown encoding: " + A);
        if (o.length === 1) {
          const v = o.charCodeAt(0);
          ((A === "utf8" && v < 128) || A === "latin1") && (o = v);
        }
      } else
        typeof o == "number"
          ? (o = o & 255)
          : typeof o == "boolean" && (o = Number(o));
      if (a < 0 || this.length < a || this.length < m)
        throw new RangeError("Out of range index");
      if (m <= a) return this;
      (a = a >>> 0), (m = m === void 0 ? this.length : m >>> 0), o || (o = 0);
      let R;
      if (typeof o == "number") for (R = a; R < m; ++R) this[R] = o;
      else {
        const v = c.isBuffer(o) ? o : c.from(o, A),
          te = v.length;
        if (te === 0)
          throw new TypeError(
            'The value "' + o + '" is invalid for argument "value"',
          );
        for (R = 0; R < m - a; ++R) this[R + a] = v[R % te];
      }
      return this;
    });
  const H = {};
  function Y(h, o, a) {
    H[h] = class extends a {
      constructor() {
        super(),
          Object.defineProperty(this, "message", {
            value: o.apply(this, arguments),
            writable: !0,
            configurable: !0,
          }),
          (this.name = `${this.name} [${h}]`),
          this.stack,
          delete this.name;
      }
      get code() {
        return h;
      }
      set code(A) {
        Object.defineProperty(this, "code", {
          configurable: !0,
          enumerable: !0,
          value: A,
          writable: !0,
        });
      }
      toString() {
        return `${this.name} [${h}]: ${this.message}`;
      }
    };
  }
  Y(
    "ERR_BUFFER_OUT_OF_BOUNDS",
    function (h) {
      return h
        ? `${h} is outside of buffer bounds`
        : "Attempt to access memory outside buffer bounds";
    },
    RangeError,
  ),
    Y(
      "ERR_INVALID_ARG_TYPE",
      function (h, o) {
        return `The "${h}" argument must be of type number. Received type ${typeof o}`;
      },
      TypeError,
    ),
    Y(
      "ERR_OUT_OF_RANGE",
      function (h, o, a) {
        let m = `The value of "${h}" is out of range.`,
          A = a;
        return (
          Number.isInteger(a) && Math.abs(a) > 2 ** 32
            ? (A = w(String(a)))
            : typeof a == "bigint" &&
              ((A = String(a)),
              (a > BigInt(2) ** BigInt(32) || a < -(BigInt(2) ** BigInt(32))) &&
                (A = w(A)),
              (A += "n")),
          (m += ` It must be ${o}. Received ${A}`),
          m
        );
      },
      RangeError,
    );
  function w(h) {
    let o = "",
      a = h.length;
    const m = h[0] === "-" ? 1 : 0;
    for (; a >= m + 4; a -= 3) o = `_${h.slice(a - 3, a)}${o}`;
    return `${h.slice(0, a)}${o}`;
  }
  function x(h, o, a) {
    T(o, "offset"),
      (h[o] === void 0 || h[o + a] === void 0) && B(o, h.length - (a + 1));
  }
  function _(h, o, a, m, A, R) {
    if (h > a || h < o) {
      const v = typeof o == "bigint" ? "n" : "";
      let te;
      throw (
        (o === 0 || o === BigInt(0)
          ? (te = `>= 0${v} and < 2${v} ** ${(R + 1) * 8}${v}`)
          : (te = `>= -(2${v} ** ${(R + 1) * 8 - 1}${v}) and < 2 ** ${(R + 1) * 8 - 1}${v}`),
        new H.ERR_OUT_OF_RANGE("value", te, h))
      );
    }
    x(m, A, R);
  }
  function T(h, o) {
    if (typeof h != "number") throw new H.ERR_INVALID_ARG_TYPE(o, "number", h);
  }
  function B(h, o, a) {
    throw Math.floor(h) !== h
      ? (T(h, a), new H.ERR_OUT_OF_RANGE("offset", "an integer", h))
      : o < 0
        ? new H.ERR_BUFFER_OUT_OF_BOUNDS()
        : new H.ERR_OUT_OF_RANGE("offset", `>= 0 and <= ${o}`, h);
  }
  const U = /[^+/0-9A-Za-z-_]/g;
  function f(h) {
    if (((h = h.split("=")[0]), (h = h.trim().replace(U, "")), h.length < 2))
      return "";
    for (; h.length % 4 !== 0; ) h = h + "=";
    return h;
  }
  function n(h, o) {
    o = o || 1 / 0;
    let a;
    const m = h.length;
    let A = null;
    const R = [];
    for (let v = 0; v < m; ++v) {
      if (((a = h.charCodeAt(v)), a > 55295 && a < 57344)) {
        if (!A) {
          if (a > 56319) {
            (o -= 3) > -1 && R.push(239, 191, 189);
            continue;
          } else if (v + 1 === m) {
            (o -= 3) > -1 && R.push(239, 191, 189);
            continue;
          }
          A = a;
          continue;
        }
        if (a < 56320) {
          (o -= 3) > -1 && R.push(239, 191, 189), (A = a);
          continue;
        }
        a = (((A - 55296) << 10) | (a - 56320)) + 65536;
      } else A && (o -= 3) > -1 && R.push(239, 191, 189);
      if (((A = null), a < 128)) {
        if ((o -= 1) < 0) break;
        R.push(a);
      } else if (a < 2048) {
        if ((o -= 2) < 0) break;
        R.push((a >> 6) | 192, (a & 63) | 128);
      } else if (a < 65536) {
        if ((o -= 3) < 0) break;
        R.push((a >> 12) | 224, ((a >> 6) & 63) | 128, (a & 63) | 128);
      } else if (a < 1114112) {
        if ((o -= 4) < 0) break;
        R.push(
          (a >> 18) | 240,
          ((a >> 12) & 63) | 128,
          ((a >> 6) & 63) | 128,
          (a & 63) | 128,
        );
      } else throw new Error("Invalid code point");
    }
    return R;
  }
  function i(h) {
    const o = [];
    for (let a = 0; a < h.length; ++a) o.push(h.charCodeAt(a) & 255);
    return o;
  }
  function l(h, o) {
    let a, m, A;
    const R = [];
    for (let v = 0; v < h.length && !((o -= 2) < 0); ++v)
      (a = h.charCodeAt(v)), (m = a >> 8), (A = a % 256), R.push(A), R.push(m);
    return R;
  }
  function p(h) {
    return e.toByteArray(f(h));
  }
  function E(h, o, a, m) {
    let A;
    for (A = 0; A < m && !(A + a >= o.length || A >= h.length); ++A)
      o[A + a] = h[A];
    return A;
  }
  function F(h, o) {
    return (
      h instanceof o ||
      (h != null &&
        h.constructor != null &&
        h.constructor.name != null &&
        h.constructor.name === o.name)
    );
  }
  function D(h) {
    return h !== h;
  }
  const z = (function () {
    const h = "0123456789abcdef",
      o = new Array(256);
    for (let a = 0; a < 16; ++a) {
      const m = a * 16;
      for (let A = 0; A < 16; ++A) o[m + A] = h[a] + h[A];
    }
    return o;
  })();
  function V(h) {
    return typeof BigInt > "u" ? re : h;
  }
  function re() {
    throw new Error("BigInt not supported");
  }
})(gs);
var cn;
(function (t) {
  (t[(t.SysFatal = 1)] = "SysFatal"),
    (t[(t.SysTransient = 2)] = "SysTransient"),
    (t[(t.DestinationInvalid = 3)] = "DestinationInvalid"),
    (t[(t.CanisterReject = 4)] = "CanisterReject"),
    (t[(t.CanisterError = 5)] = "CanisterError");
})(cn || (cn = {}));
const Xt = "abcdefghijklmnopqrstuvwxyz234567",
  _t = Object.create(null);
for (let t = 0; t < Xt.length; t++) _t[Xt[t]] = t;
_t[0] = _t.o;
_t[1] = _t.i;
function Ss(t) {
  let e = 0,
    r = 0,
    s = "";
  function u(d) {
    return (
      e < 0 ? (r |= d >> -e) : (r = (d << e) & 248),
      e > 3 ? ((e -= 8), 1) : (e < 4 && ((s += Xt[r >> 3]), (e += 5)), 0)
    );
  }
  for (let d = 0; d < t.length; ) d += u(t[d]);
  return s + (e < 0 ? Xt[r >> 3] : "");
}
function Ts(t) {
  let e = 0,
    r = 0;
  const s = new Uint8Array(((t.length * 4) / 3) | 0);
  let u = 0;
  function d(g) {
    let c = _t[g.toLowerCase()];
    if (c === void 0)
      throw new Error(`Invalid character: ${JSON.stringify(g)}`);
    (c <<= 3),
      (r |= c >>> e),
      (e += 5),
      e >= 8 &&
        ((s[u++] = r), (e -= 8), e > 0 ? (r = (c << (5 - e)) & 255) : (r = 0));
  }
  for (const g of t) d(g);
  return s.slice(0, u);
}
const Us = new Uint32Array([
  0, 1996959894, 3993919788, 2567524794, 124634137, 1886057615, 3915621685,
  2657392035, 249268274, 2044508324, 3772115230, 2547177864, 162941995,
  2125561021, 3887607047, 2428444049, 498536548, 1789927666, 4089016648,
  2227061214, 450548861, 1843258603, 4107580753, 2211677639, 325883990,
  1684777152, 4251122042, 2321926636, 335633487, 1661365465, 4195302755,
  2366115317, 997073096, 1281953886, 3579855332, 2724688242, 1006888145,
  1258607687, 3524101629, 2768942443, 901097722, 1119000684, 3686517206,
  2898065728, 853044451, 1172266101, 3705015759, 2882616665, 651767980,
  1373503546, 3369554304, 3218104598, 565507253, 1454621731, 3485111705,
  3099436303, 671266974, 1594198024, 3322730930, 2970347812, 795835527,
  1483230225, 3244367275, 3060149565, 1994146192, 31158534, 2563907772,
  4023717930, 1907459465, 112637215, 2680153253, 3904427059, 2013776290,
  251722036, 2517215374, 3775830040, 2137656763, 141376813, 2439277719,
  3865271297, 1802195444, 476864866, 2238001368, 4066508878, 1812370925,
  453092731, 2181625025, 4111451223, 1706088902, 314042704, 2344532202,
  4240017532, 1658658271, 366619977, 2362670323, 4224994405, 1303535960,
  984961486, 2747007092, 3569037538, 1256170817, 1037604311, 2765210733,
  3554079995, 1131014506, 879679996, 2909243462, 3663771856, 1141124467,
  855842277, 2852801631, 3708648649, 1342533948, 654459306, 3188396048,
  3373015174, 1466479909, 544179635, 3110523913, 3462522015, 1591671054,
  702138776, 2966460450, 3352799412, 1504918807, 783551873, 3082640443,
  3233442989, 3988292384, 2596254646, 62317068, 1957810842, 3939845945,
  2647816111, 81470997, 1943803523, 3814918930, 2489596804, 225274430,
  2053790376, 3826175755, 2466906013, 167816743, 2097651377, 4027552580,
  2265490386, 503444072, 1762050814, 4150417245, 2154129355, 426522225,
  1852507879, 4275313526, 2312317920, 282753626, 1742555852, 4189708143,
  2394877945, 397917763, 1622183637, 3604390888, 2714866558, 953729732,
  1340076626, 3518719985, 2797360999, 1068828381, 1219638859, 3624741850,
  2936675148, 906185462, 1090812512, 3747672003, 2825379669, 829329135,
  1181335161, 3412177804, 3160834842, 628085408, 1382605366, 3423369109,
  3138078467, 570562233, 1426400815, 3317316542, 2998733608, 733239954,
  1555261956, 3268935591, 3050360625, 752459403, 1541320221, 2607071920,
  3965973030, 1969922972, 40735498, 2617837225, 3943577151, 1913087877,
  83908371, 2512341634, 3803740692, 2075208622, 213261112, 2463272603,
  3855990285, 2094854071, 198958881, 2262029012, 4057260610, 1759359992,
  534414190, 2176718541, 4139329115, 1873836001, 414664567, 2282248934,
  4279200368, 1711684554, 285281116, 2405801727, 4167216745, 1634467795,
  376229701, 2685067896, 3608007406, 1308918612, 956543938, 2808555105,
  3495958263, 1231636301, 1047427035, 2932959818, 3654703836, 1088359270,
  936918e3, 2847714899, 3736837829, 1202900863, 817233897, 3183342108,
  3401237130, 1404277552, 615818150, 3134207493, 3453421203, 1423857449,
  601450431, 3009837614, 3294710456, 1567103746, 711928724, 3020668471,
  3272380065, 1510334235, 755167117,
]);
function Ns(t) {
  const e = new Uint8Array(t);
  let r = -1;
  for (let s = 0; s < e.length; s++) {
    const d = (e[s] ^ r) & 255;
    r = Us[d] ^ (r >>> 8);
  }
  return (r ^ -1) >>> 0;
}
function Fs(t) {
  return (
    t instanceof Uint8Array ||
    (ArrayBuffer.isView(t) && t.constructor.name === "Uint8Array")
  );
}
function Xn(t, ...e) {
  if (!Fs(t)) throw new Error("Uint8Array expected");
  if (e.length > 0 && !e.includes(t.length))
    throw new Error(
      "Uint8Array expected of length " + e + ", got length=" + t.length,
    );
}
function fn(t, e = !0) {
  if (t.destroyed) throw new Error("Hash instance has been destroyed");
  if (e && t.finished) throw new Error("Hash#digest() has already been called");
}
function vs(t, e) {
  Xn(t);
  const r = e.outputLen;
  if (t.length < r)
    throw new Error(
      "digestInto() expects output buffer of length at least " + r,
    );
}
const wt =
  typeof globalThis == "object" && "crypto" in globalThis
    ? globalThis.crypto
    : void 0;
/*! noble-hashes - MIT License (c) 2022 Paul Miller (paulmillr.com) */ function ur(
  t,
) {
  return new DataView(t.buffer, t.byteOffset, t.byteLength);
}
function Ye(t, e) {
  return (t << (32 - e)) | (t >>> e);
}
function Rs(t) {
  if (typeof t != "string")
    throw new Error("utf8ToBytes expected string, got " + typeof t);
  return new Uint8Array(new TextEncoder().encode(t));
}
function jn(t) {
  return typeof t == "string" && (t = Rs(t)), Xn(t), t;
}
class Ls {
  clone() {
    return this._cloneInto();
  }
}
function Gr(t) {
  const e = (s) => t().update(jn(s)).digest(),
    r = t();
  return (
    (e.outputLen = r.outputLen),
    (e.blockLen = r.blockLen),
    (e.create = () => t()),
    e
  );
}
function Os(t = 32) {
  if (wt && typeof wt.getRandomValues == "function")
    return wt.getRandomValues(new Uint8Array(t));
  if (wt && typeof wt.randomBytes == "function") return wt.randomBytes(t);
  throw new Error("crypto.getRandomValues must be defined");
}
function Ds(t, e, r, s) {
  if (typeof t.setBigUint64 == "function") return t.setBigUint64(e, r, s);
  const u = BigInt(32),
    d = BigInt(4294967295),
    g = Number((r >> u) & d),
    c = Number(r & d),
    b = s ? 4 : 0,
    S = s ? 0 : 4;
  t.setUint32(e + b, g, s), t.setUint32(e + S, c, s);
}
function Ms(t, e, r) {
  return (t & e) ^ (~t & r);
}
function Ps(t, e, r) {
  return (t & e) ^ (t & r) ^ (e & r);
}
class Zn extends Ls {
  constructor(e, r, s, u) {
    super(),
      (this.blockLen = e),
      (this.outputLen = r),
      (this.padOffset = s),
      (this.isLE = u),
      (this.finished = !1),
      (this.length = 0),
      (this.pos = 0),
      (this.destroyed = !1),
      (this.buffer = new Uint8Array(e)),
      (this.view = ur(this.buffer));
  }
  update(e) {
    fn(this);
    const { view: r, buffer: s, blockLen: u } = this;
    e = jn(e);
    const d = e.length;
    for (let g = 0; g < d; ) {
      const c = Math.min(u - this.pos, d - g);
      if (c === u) {
        const b = ur(e);
        for (; u <= d - g; g += u) this.process(b, g);
        continue;
      }
      s.set(e.subarray(g, g + c), this.pos),
        (this.pos += c),
        (g += c),
        this.pos === u && (this.process(r, 0), (this.pos = 0));
    }
    return (this.length += e.length), this.roundClean(), this;
  }
  digestInto(e) {
    fn(this), vs(e, this), (this.finished = !0);
    const { buffer: r, view: s, blockLen: u, isLE: d } = this;
    let { pos: g } = this;
    (r[g++] = 128),
      this.buffer.subarray(g).fill(0),
      this.padOffset > u - g && (this.process(s, 0), (g = 0));
    for (let L = g; L < u; L++) r[L] = 0;
    Ds(s, u - 8, BigInt(this.length * 8), d), this.process(s, 0);
    const c = ur(e),
      b = this.outputLen;
    if (b % 4) throw new Error("_sha2: outputLen should be aligned to 32bit");
    const S = b / 4,
      N = this.get();
    if (S > N.length) throw new Error("_sha2: outputLen bigger than state");
    for (let L = 0; L < S; L++) c.setUint32(4 * L, N[L], d);
  }
  digest() {
    const { buffer: e, outputLen: r } = this;
    this.digestInto(e);
    const s = e.slice(0, r);
    return this.destroy(), s;
  }
  _cloneInto(e) {
    e || (e = new this.constructor()), e.set(...this.get());
    const {
      blockLen: r,
      buffer: s,
      length: u,
      finished: d,
      destroyed: g,
      pos: c,
    } = this;
    return (
      (e.length = u),
      (e.pos = c),
      (e.finished = d),
      (e.destroyed = g),
      u % r && e.buffer.set(s),
      e
    );
  }
}
const Cs = new Uint32Array([
    1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993,
    2453635748, 2870763221, 3624381080, 310598401, 607225278, 1426881987,
    1925078388, 2162078206, 2614888103, 3248222580, 3835390401, 4022224774,
    264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986,
    2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711,
    113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291,
    1695183700, 1986661051, 2177026350, 2456956037, 2730485921, 2820302411,
    3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344,
    430227734, 506948616, 659060556, 883997877, 958139571, 1322822218,
    1537002063, 1747873779, 1955562222, 2024104815, 2227730452, 2361852424,
    2428436474, 2756734187, 3204031479, 3329325298,
  ]),
  et = new Uint32Array([
    1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924,
    528734635, 1541459225,
  ]),
  tt = new Uint32Array(64);
class Qn extends Zn {
  constructor() {
    super(64, 32, 8, !1),
      (this.A = et[0] | 0),
      (this.B = et[1] | 0),
      (this.C = et[2] | 0),
      (this.D = et[3] | 0),
      (this.E = et[4] | 0),
      (this.F = et[5] | 0),
      (this.G = et[6] | 0),
      (this.H = et[7] | 0);
  }
  get() {
    const { A: e, B: r, C: s, D: u, E: d, F: g, G: c, H: b } = this;
    return [e, r, s, u, d, g, c, b];
  }
  set(e, r, s, u, d, g, c, b) {
    (this.A = e | 0),
      (this.B = r | 0),
      (this.C = s | 0),
      (this.D = u | 0),
      (this.E = d | 0),
      (this.F = g | 0),
      (this.G = c | 0),
      (this.H = b | 0);
  }
  process(e, r) {
    for (let L = 0; L < 16; L++, r += 4) tt[L] = e.getUint32(r, !1);
    for (let L = 16; L < 64; L++) {
      const O = tt[L - 15],
        M = tt[L - 2],
        q = Ye(O, 7) ^ Ye(O, 18) ^ (O >>> 3),
        W = Ye(M, 17) ^ Ye(M, 19) ^ (M >>> 10);
      tt[L] = (W + tt[L - 7] + q + tt[L - 16]) | 0;
    }
    let { A: s, B: u, C: d, D: g, E: c, F: b, G: S, H: N } = this;
    for (let L = 0; L < 64; L++) {
      const O = Ye(c, 6) ^ Ye(c, 11) ^ Ye(c, 25),
        M = (N + O + Ms(c, b, S) + Cs[L] + tt[L]) | 0,
        W = ((Ye(s, 2) ^ Ye(s, 13) ^ Ye(s, 22)) + Ps(s, u, d)) | 0;
      (N = S),
        (S = b),
        (b = c),
        (c = (g + M) | 0),
        (g = d),
        (d = u),
        (u = s),
        (s = (M + W) | 0);
    }
    (s = (s + this.A) | 0),
      (u = (u + this.B) | 0),
      (d = (d + this.C) | 0),
      (g = (g + this.D) | 0),
      (c = (c + this.E) | 0),
      (b = (b + this.F) | 0),
      (S = (S + this.G) | 0),
      (N = (N + this.H) | 0),
      this.set(s, u, d, g, c, b, S, N);
  }
  roundClean() {
    tt.fill(0);
  }
  destroy() {
    this.set(0, 0, 0, 0, 0, 0, 0, 0), this.buffer.fill(0);
  }
}
class ks extends Qn {
  constructor() {
    super(),
      (this.A = -1056596264),
      (this.B = 914150663),
      (this.C = 812702999),
      (this.D = -150054599),
      (this.E = -4191439),
      (this.F = 1750603025),
      (this.G = 1694076839),
      (this.H = -1090891868),
      (this.outputLen = 28);
  }
}
const Gs = Gr(() => new Qn()),
  Hs = Gr(() => new ks());
function $s(t) {
  return Hs.create().update(new Uint8Array(t)).digest();
}
const Pt = "__principal__",
  zs = 2,
  hn = 4,
  Ks = "aaaaa-aa",
  Ys = (t) => {
    var e;
    return new Uint8Array(
      ((e = t.match(/.{1,2}/g)) !== null && e !== void 0 ? e : []).map((r) =>
        parseInt(r, 16),
      ),
    );
  },
  Ws = (t) => t.reduce((e, r) => e + r.toString(16).padStart(2, "0"), "");
class ut {
  constructor(e) {
    (this._arr = e), (this._isPrincipal = !0);
  }
  static anonymous() {
    return new this(new Uint8Array([hn]));
  }
  static managementCanister() {
    return this.fromHex(Ks);
  }
  static selfAuthenticating(e) {
    const r = $s(e);
    return new this(new Uint8Array([...r, zs]));
  }
  static from(e) {
    if (typeof e == "string") return ut.fromText(e);
    if (Object.getPrototypeOf(e) === Uint8Array.prototype) return new ut(e);
    if (typeof e == "object" && e !== null && e._isPrincipal === !0)
      return new ut(e._arr);
    throw new Error(`Impossible to convert ${JSON.stringify(e)} to Principal.`);
  }
  static fromHex(e) {
    return new this(Ys(e));
  }
  static fromText(e) {
    let r = e;
    if (e.includes(Pt)) {
      const g = JSON.parse(e);
      Pt in g && (r = g[Pt]);
    }
    const s = r.toLowerCase().replace(/-/g, "");
    let u = Ts(s);
    u = u.slice(4, u.length);
    const d = new this(u);
    if (d.toText() !== r)
      throw new Error(
        `Principal "${d.toText()}" does not have a valid checksum (original value "${r}" may not be a valid Principal ID).`,
      );
    return d;
  }
  static fromUint8Array(e) {
    return new this(e);
  }
  isAnonymous() {
    return this._arr.byteLength === 1 && this._arr[0] === hn;
  }
  toUint8Array() {
    return this._arr;
  }
  toHex() {
    return Ws(this._arr).toUpperCase();
  }
  toText() {
    const e = new ArrayBuffer(4);
    new DataView(e).setUint32(0, Ns(this._arr));
    const s = new Uint8Array(e),
      u = Uint8Array.from(this._arr),
      d = new Uint8Array([...s, ...u]),
      c = Ss(d).match(/.{1,5}/g);
    if (!c) throw new Error();
    return c.join("-");
  }
  toString() {
    return this.toText();
  }
  toJSON() {
    return { [Pt]: this.toText() };
  }
  compareTo(e) {
    for (let r = 0; r < Math.min(this._arr.length, e._arr.length); r++) {
      if (this._arr[r] < e._arr[r]) return "lt";
      if (this._arr[r] > e._arr[r]) return "gt";
    }
    return this._arr.length < e._arr.length
      ? "lt"
      : this._arr.length > e._arr.length
        ? "gt"
        : "eq";
  }
  ltEq(e) {
    const r = this.compareTo(e);
    return r == "lt" || r == "eq";
  }
  gtEq(e) {
    const r = this.compareTo(e);
    return r == "gt" || r == "eq";
  }
}
function Nt(...t) {
  const e = new Uint8Array(t.reduce((s, u) => s + u.byteLength, 0));
  let r = 0;
  for (const s of t) e.set(new Uint8Array(s), r), (r += s.byteLength);
  return e.buffer;
}
function bt(t) {
  return [...new Uint8Array(t)]
    .map((e) => e.toString(16).padStart(2, "0"))
    .join("");
}
const Vs = new RegExp(/^[0-9a-fA-F]+$/);
function ct(t) {
  if (!Vs.test(t)) throw new Error("Invalid hexadecimal string.");
  const e = [...t]
    .reduce((r, s, u) => ((r[(u / 2) | 0] = (r[(u / 2) | 0] || "") + s), r), [])
    .map((r) => Number.parseInt(r, 16));
  return new Uint8Array(e).buffer;
}
function ei(t, e) {
  if (t.byteLength !== e.byteLength) return t.byteLength - e.byteLength;
  const r = new Uint8Array(t),
    s = new Uint8Array(e);
  for (let u = 0; u < r.length; u++) if (r[u] !== s[u]) return r[u] - s[u];
  return 0;
}
function ti(t, e) {
  return ei(t, e) === 0;
}
function Ut(t) {
  return new DataView(t.buffer, t.byteOffset, t.byteLength).buffer;
}
function ri(t) {
  return t instanceof Uint8Array
    ? Ut(t)
    : t instanceof ArrayBuffer
      ? t
      : Array.isArray(t)
        ? Ut(new Uint8Array(t))
        : "buffer" in t
          ? ri(t.buffer)
          : Ut(new Uint8Array(t));
}
class Hr {
  constructor(e, r = e?.byteLength || 0) {
    (this._buffer = Sr(e || new ArrayBuffer(0))),
      (this._view = new Uint8Array(this._buffer, 0, r));
  }
  get buffer() {
    return Sr(this._view.slice());
  }
  get byteLength() {
    return this._view.byteLength;
  }
  read(e) {
    const r = this._view.subarray(0, e);
    return (this._view = this._view.subarray(e)), r.slice().buffer;
  }
  readUint8() {
    const e = this._view[0];
    return (this._view = this._view.subarray(1)), e;
  }
  write(e) {
    const r = new Uint8Array(e),
      s = this._view.byteLength;
    this._view.byteOffset + this._view.byteLength + r.byteLength >=
    this._buffer.byteLength
      ? this.alloc(r.byteLength)
      : (this._view = new Uint8Array(
          this._buffer,
          this._view.byteOffset,
          this._view.byteLength + r.byteLength,
        )),
      this._view.set(r, s);
  }
  get end() {
    return this._view.byteLength === 0;
  }
  alloc(e) {
    const r = new ArrayBuffer(((this._buffer.byteLength + e) * 1.2) | 0),
      s = new Uint8Array(r, 0, this._view.byteLength + e);
    s.set(this._view), (this._buffer = r), (this._view = s);
  }
}
function cr(t) {
  return new DataView(t.buffer, t.byteOffset, t.byteLength).buffer;
}
function Sr(t) {
  return t instanceof Uint8Array
    ? cr(t)
    : t instanceof ArrayBuffer
      ? t
      : Array.isArray(t)
        ? cr(new Uint8Array(t))
        : "buffer" in t
          ? Sr(t.buffer)
          : cr(new Uint8Array(t));
}
function ni() {
  throw new Error("unexpected end of buffer");
}
function qs(t, e) {
  return t.byteLength < e && ni(), t.read(e);
}
function ln(t) {
  const e = t.readUint8();
  return e === void 0 && ni(), e;
}
function dn(t) {
  if ((typeof t == "number" && (t = BigInt(t)), t < BigInt(0)))
    throw new Error("Cannot leb encode negative values.");
  const e = (t === BigInt(0) ? 0 : Math.ceil(Math.log2(Number(t)))) + 1,
    r = new Hr(new ArrayBuffer(e), 0);
  for (;;) {
    const s = Number(t & BigInt(127));
    if (((t /= BigInt(128)), t === BigInt(0))) {
      r.write(new Uint8Array([s]));
      break;
    } else r.write(new Uint8Array([s | 128]));
  }
  return r.buffer;
}
function $r(t) {
  typeof t == "number" && (t = BigInt(t));
  const e = t < BigInt(0);
  e && (t = -t - BigInt(1));
  const r = (t === BigInt(0) ? 0 : Math.ceil(Math.log2(Number(t)))) + 1,
    s = new Hr(new ArrayBuffer(r), 0);
  for (;;) {
    const d = u(t);
    if (
      ((t /= BigInt(128)),
      (e && t === BigInt(0) && d & 64) || (!e && t === BigInt(0) && !(d & 64)))
    ) {
      s.write(new Uint8Array([d]));
      break;
    } else s.write(new Uint8Array([d | 128]));
  }
  function u(d) {
    const g = d % BigInt(128);
    return Number(e ? BigInt(128) - g - BigInt(1) : g);
  }
  return s.buffer;
}
function Js(t, e) {
  if (BigInt(t) < BigInt(0)) throw new Error("Cannot write negative values.");
  return ii(t, e);
}
function ii(t, e) {
  t = BigInt(t);
  const r = new Hr(new ArrayBuffer(Math.min(1, e)), 0);
  let s = 0,
    u = BigInt(256),
    d = BigInt(0),
    g = Number(t % u);
  for (r.write(new Uint8Array([g])); ++s < e; )
    t < 0 && d === BigInt(0) && g !== 0 && (d = BigInt(1)),
      (g = Number((t / u - d) % BigInt(256))),
      r.write(new Uint8Array([g])),
      (u *= BigInt(256));
  return r.buffer;
}
function si(t, e) {
  let r = BigInt(ln(t)),
    s = BigInt(1),
    u = 0;
  for (; ++u < e; ) {
    s *= BigInt(256);
    const d = BigInt(ln(t));
    r = r + s * d;
  }
  return r;
}
function Xs(t, e) {
  let r = si(t, e);
  const s = BigInt(2) ** (BigInt(8) * BigInt(e - 1) + BigInt(7));
  return r >= s && (r -= s * BigInt(2)), r;
}
function Tr(t) {
  const e = BigInt(t);
  if (t < 0) throw new RangeError("Input must be non-negative");
  return BigInt(1) << e;
}
const pn = 400;
class oi {
  display() {
    return this.name;
  }
  valueToString(e) {
    return Lt(e);
  }
  buildTypeTable(e) {
    e.has(this) || this._buildTypeTableImpl(e);
  }
}
class zr extends oi {
  checkType(e) {
    if (this.name !== e.name)
      throw new Error(
        `type mismatch: type on the wire ${e.name}, expect type ${this.name}`,
      );
    return e;
  }
  _buildTypeTableImpl(e) {}
}
class js extends oi {
  checkType(e) {
    if (e instanceof nr) {
      const r = e.getType();
      if (typeof r > "u")
        throw new Error("type mismatch with uninitialized type");
      return r;
    }
    throw new Error(
      `type mismatch: type on the wire ${e.name}, expect type ${this.name}`,
    );
  }
  encodeType(e) {
    return e.indexOf(this.name);
  }
}
class ai extends zr {
  constructor(e) {
    if ((super(), (this._bits = e), e !== 32 && e !== 64))
      throw new Error("not a valid float type");
  }
  accept(e, r) {
    return e.visitFloat(this, r);
  }
  covariant(e) {
    if (typeof e == "number" || e instanceof Number) return !0;
    throw new Error(`Invalid ${this.display()} argument: ${Lt(e)}`);
  }
  encodeValue(e) {
    const r = new ArrayBuffer(this._bits / 8),
      s = new DataView(r);
    return (
      this._bits === 32 ? s.setFloat32(0, e, !0) : s.setFloat64(0, e, !0), r
    );
  }
  encodeType() {
    const e = this._bits === 32 ? -13 : -14;
    return $r(e);
  }
  decodeValue(e, r) {
    this.checkType(r);
    const s = qs(e, this._bits / 8),
      u = new DataView(s);
    return this._bits === 32 ? u.getFloat32(0, !0) : u.getFloat64(0, !0);
  }
  get name() {
    return "float" + this._bits;
  }
  valueToString(e) {
    return e.toString();
  }
}
class tr extends zr {
  constructor(e) {
    super(), (this._bits = e);
  }
  accept(e, r) {
    return e.visitFixedInt(this, r);
  }
  covariant(e) {
    const r = Tr(this._bits - 1) * BigInt(-1),
      s = Tr(this._bits - 1) - BigInt(1);
    let u = !1;
    if (typeof e == "bigint") u = e >= r && e <= s;
    else if (Number.isInteger(e)) {
      const d = BigInt(e);
      u = d >= r && d <= s;
    } else u = !1;
    if (u) return !0;
    throw new Error(`Invalid ${this.display()} argument: ${Lt(e)}`);
  }
  encodeValue(e) {
    return ii(e, this._bits / 8);
  }
  encodeType() {
    const e = Math.log2(this._bits) - 3;
    return $r(-9 - e);
  }
  decodeValue(e, r) {
    this.checkType(r);
    const s = Xs(e, this._bits / 8);
    return this._bits <= 32 ? Number(s) : s;
  }
  get name() {
    return `int${this._bits}`;
  }
  valueToString(e) {
    return e.toString();
  }
}
class rr extends zr {
  constructor(e) {
    super(), (this._bits = e);
  }
  accept(e, r) {
    return e.visitFixedNat(this, r);
  }
  covariant(e) {
    const r = Tr(this._bits);
    let s = !1;
    if (
      (typeof e == "bigint" && e >= BigInt(0)
        ? (s = e < r)
        : Number.isInteger(e) && e >= 0
          ? (s = BigInt(e) < r)
          : (s = !1),
      s)
    )
      return !0;
    throw new Error(`Invalid ${this.display()} argument: ${Lt(e)}`);
  }
  encodeValue(e) {
    return Js(e, this._bits / 8);
  }
  encodeType() {
    const e = Math.log2(this._bits) - 3;
    return $r(-5 - e);
  }
  decodeValue(e, r) {
    this.checkType(r);
    const s = si(e, this._bits / 8);
    return this._bits <= 32 ? Number(s) : s;
  }
  get name() {
    return `nat${this._bits}`;
  }
  valueToString(e) {
    return e.toString();
  }
}
class nr extends js {
  constructor() {
    super(...arguments), (this._id = nr._counter++), (this._type = void 0);
  }
  accept(e, r) {
    if (!this._type) throw Error("Recursive type uninitialized.");
    return e.visitRec(this, this._type, r);
  }
  fill(e) {
    this._type = e;
  }
  getType() {
    return this._type;
  }
  covariant(e) {
    if (this._type && this._type.covariant(e)) return !0;
    throw new Error(`Invalid ${this.display()} argument: ${Lt(e)}`);
  }
  encodeValue(e) {
    if (!this._type) throw Error("Recursive type uninitialized.");
    return this._type.encodeValue(e);
  }
  _buildTypeTableImpl(e) {
    if (!this._type) throw Error("Recursive type uninitialized.");
    e.add(this, new Uint8Array([])),
      this._type.buildTypeTable(e),
      e.merge(this, this._type.name);
  }
  decodeValue(e, r) {
    if (!this._type) throw Error("Recursive type uninitialized.");
    return this._type.decodeValue(e, r);
  }
  get name() {
    return `rec_${this._id}`;
  }
  display() {
    if (!this._type) throw Error("Recursive type uninitialized.");
    return `μ${this.name}.${this._type.name}`;
  }
  valueToString(e) {
    if (!this._type) throw Error("Recursive type uninitialized.");
    return this._type.valueToString(e);
  }
}
nr._counter = 0;
function Lt(t) {
  const e = JSON.stringify(t, (r, s) =>
    typeof s == "bigint" ? `BigInt(${s})` : s,
  );
  return e && e.length > pn ? e.substring(0, pn - 3) + "..." : e;
}
new ai(32);
new ai(64);
new tr(8);
new tr(16);
new tr(32);
new tr(64);
new rr(8);
new rr(16);
new rr(32);
new rr(64);
var ui = {},
  Ot = {};
/*!
 * The buffer module from node.js, for the browser.
 *
 * @author   Feross Aboukhadijeh <https://feross.org>
 * @license  MIT
 */ (function (t) {
  var e = vt,
    r = Rt,
    s =
      typeof Symbol == "function" && typeof Symbol.for == "function"
        ? Symbol.for("nodejs.util.inspect.custom")
        : null;
  (t.Buffer = c), (t.SlowBuffer = ae), (t.INSPECT_MAX_BYTES = 50);
  var u = 2147483647;
  (t.kMaxLength = u),
    (c.TYPED_ARRAY_SUPPORT = d()),
    !c.TYPED_ARRAY_SUPPORT &&
      typeof console < "u" &&
      typeof console.error == "function" &&
      console.error(
        "This browser lacks typed array (Uint8Array) support which is required by `buffer` v5.x. Use `buffer` v4.x if you require old browser support.",
      );
  function d() {
    try {
      var f = new Uint8Array(1),
        n = {
          foo: function () {
            return 42;
          },
        };
      return (
        Object.setPrototypeOf(n, Uint8Array.prototype),
        Object.setPrototypeOf(f, n),
        f.foo() === 42
      );
    } catch {
      return !1;
    }
  }
  Object.defineProperty(c.prototype, "parent", {
    enumerable: !0,
    get: function () {
      if (c.isBuffer(this)) return this.buffer;
    },
  }),
    Object.defineProperty(c.prototype, "offset", {
      enumerable: !0,
      get: function () {
        if (c.isBuffer(this)) return this.byteOffset;
      },
    });
  function g(f) {
    if (f > u)
      throw new RangeError(
        'The value "' + f + '" is invalid for option "size"',
      );
    var n = new Uint8Array(f);
    return Object.setPrototypeOf(n, c.prototype), n;
  }
  function c(f, n, i) {
    if (typeof f == "number") {
      if (typeof n == "string")
        throw new TypeError(
          'The "string" argument must be of type string. Received type number',
        );
      return L(f);
    }
    return b(f, n, i);
  }
  c.poolSize = 8192;
  function b(f, n, i) {
    if (typeof f == "string") return O(f, n);
    if (ArrayBuffer.isView(f)) return q(f);
    if (f == null)
      throw new TypeError(
        "The first argument must be one of type string, Buffer, ArrayBuffer, Array, or Array-like Object. Received type " +
          typeof f,
      );
    if (
      T(f, ArrayBuffer) ||
      (f && T(f.buffer, ArrayBuffer)) ||
      (typeof SharedArrayBuffer < "u" &&
        (T(f, SharedArrayBuffer) || (f && T(f.buffer, SharedArrayBuffer))))
    )
      return W(f, n, i);
    if (typeof f == "number")
      throw new TypeError(
        'The "value" argument must not be of type number. Received type number',
      );
    var l = f.valueOf && f.valueOf();
    if (l != null && l !== f) return c.from(l, n, i);
    var p = le(f);
    if (p) return p;
    if (
      typeof Symbol < "u" &&
      Symbol.toPrimitive != null &&
      typeof f[Symbol.toPrimitive] == "function"
    )
      return c.from(f[Symbol.toPrimitive]("string"), n, i);
    throw new TypeError(
      "The first argument must be one of type string, Buffer, ArrayBuffer, Array, or Array-like Object. Received type " +
        typeof f,
    );
  }
  (c.from = function (f, n, i) {
    return b(f, n, i);
  }),
    Object.setPrototypeOf(c.prototype, Uint8Array.prototype),
    Object.setPrototypeOf(c, Uint8Array);
  function S(f) {
    if (typeof f != "number")
      throw new TypeError('"size" argument must be of type number');
    if (f < 0)
      throw new RangeError(
        'The value "' + f + '" is invalid for option "size"',
      );
  }
  function N(f, n, i) {
    return (
      S(f),
      f <= 0
        ? g(f)
        : n !== void 0
          ? typeof i == "string"
            ? g(f).fill(n, i)
            : g(f).fill(n)
          : g(f)
    );
  }
  c.alloc = function (f, n, i) {
    return N(f, n, i);
  };
  function L(f) {
    return S(f), g(f < 0 ? 0 : Ee(f) | 0);
  }
  (c.allocUnsafe = function (f) {
    return L(f);
  }),
    (c.allocUnsafeSlow = function (f) {
      return L(f);
    });
  function O(f, n) {
    if (((typeof n != "string" || n === "") && (n = "utf8"), !c.isEncoding(n)))
      throw new TypeError("Unknown encoding: " + n);
    var i = K(f, n) | 0,
      l = g(i),
      p = l.write(f, n);
    return p !== i && (l = l.slice(0, p)), l;
  }
  function M(f) {
    for (
      var n = f.length < 0 ? 0 : Ee(f.length) | 0, i = g(n), l = 0;
      l < n;
      l += 1
    )
      i[l] = f[l] & 255;
    return i;
  }
  function q(f) {
    if (T(f, Uint8Array)) {
      var n = new Uint8Array(f);
      return W(n.buffer, n.byteOffset, n.byteLength);
    }
    return M(f);
  }
  function W(f, n, i) {
    if (n < 0 || f.byteLength < n)
      throw new RangeError('"offset" is outside of buffer bounds');
    if (f.byteLength < n + (i || 0))
      throw new RangeError('"length" is outside of buffer bounds');
    var l;
    return (
      n === void 0 && i === void 0
        ? (l = new Uint8Array(f))
        : i === void 0
          ? (l = new Uint8Array(f, n))
          : (l = new Uint8Array(f, n, i)),
      Object.setPrototypeOf(l, c.prototype),
      l
    );
  }
  function le(f) {
    if (c.isBuffer(f)) {
      var n = Ee(f.length) | 0,
        i = g(n);
      return i.length === 0 || f.copy(i, 0, 0, n), i;
    }
    if (f.length !== void 0)
      return typeof f.length != "number" || B(f.length) ? g(0) : M(f);
    if (f.type === "Buffer" && Array.isArray(f.data)) return M(f.data);
  }
  function Ee(f) {
    if (f >= u)
      throw new RangeError(
        "Attempt to allocate Buffer larger than maximum size: 0x" +
          u.toString(16) +
          " bytes",
      );
    return f | 0;
  }
  function ae(f) {
    return +f != f && (f = 0), c.alloc(+f);
  }
  (c.isBuffer = function (n) {
    return n != null && n._isBuffer === !0 && n !== c.prototype;
  }),
    (c.compare = function (n, i) {
      if (
        (T(n, Uint8Array) && (n = c.from(n, n.offset, n.byteLength)),
        T(i, Uint8Array) && (i = c.from(i, i.offset, i.byteLength)),
        !c.isBuffer(n) || !c.isBuffer(i))
      )
        throw new TypeError(
          'The "buf1", "buf2" arguments must be one of type Buffer or Uint8Array',
        );
      if (n === i) return 0;
      for (
        var l = n.length, p = i.length, E = 0, F = Math.min(l, p);
        E < F;
        ++E
      )
        if (n[E] !== i[E]) {
          (l = n[E]), (p = i[E]);
          break;
        }
      return l < p ? -1 : p < l ? 1 : 0;
    }),
    (c.isEncoding = function (n) {
      switch (String(n).toLowerCase()) {
        case "hex":
        case "utf8":
        case "utf-8":
        case "ascii":
        case "latin1":
        case "binary":
        case "base64":
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return !0;
        default:
          return !1;
      }
    }),
    (c.concat = function (n, i) {
      if (!Array.isArray(n))
        throw new TypeError('"list" argument must be an Array of Buffers');
      if (n.length === 0) return c.alloc(0);
      var l;
      if (i === void 0) for (i = 0, l = 0; l < n.length; ++l) i += n[l].length;
      var p = c.allocUnsafe(i),
        E = 0;
      for (l = 0; l < n.length; ++l) {
        var F = n[l];
        if (T(F, Uint8Array))
          E + F.length > p.length
            ? c.from(F).copy(p, E)
            : Uint8Array.prototype.set.call(p, F, E);
        else if (c.isBuffer(F)) F.copy(p, E);
        else throw new TypeError('"list" argument must be an Array of Buffers');
        E += F.length;
      }
      return p;
    });
  function K(f, n) {
    if (c.isBuffer(f)) return f.length;
    if (ArrayBuffer.isView(f) || T(f, ArrayBuffer)) return f.byteLength;
    if (typeof f != "string")
      throw new TypeError(
        'The "string" argument must be one of type string, Buffer, or ArrayBuffer. Received type ' +
          typeof f,
      );
    var i = f.length,
      l = arguments.length > 2 && arguments[2] === !0;
    if (!l && i === 0) return 0;
    for (var p = !1; ; )
      switch (n) {
        case "ascii":
        case "latin1":
        case "binary":
          return i;
        case "utf8":
        case "utf-8":
          return H(f).length;
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return i * 2;
        case "hex":
          return i >>> 1;
        case "base64":
          return x(f).length;
        default:
          if (p) return l ? -1 : H(f).length;
          (n = ("" + n).toLowerCase()), (p = !0);
      }
  }
  c.byteLength = K;
  function Ue(f, n, i) {
    var l = !1;
    if (
      ((n === void 0 || n < 0) && (n = 0),
      n > this.length ||
        ((i === void 0 || i > this.length) && (i = this.length), i <= 0) ||
        ((i >>>= 0), (n >>>= 0), i <= n))
    )
      return "";
    for (f || (f = "utf8"); ; )
      switch (f) {
        case "hex":
          return j(this, n, i);
        case "utf8":
        case "utf-8":
          return Se(this, n, i);
        case "ascii":
          return P(this, n, i);
        case "latin1":
        case "binary":
          return k(this, n, i);
        case "base64":
          return fe(this, n, i);
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return Q(this, n, i);
        default:
          if (l) throw new TypeError("Unknown encoding: " + f);
          (f = (f + "").toLowerCase()), (l = !0);
      }
  }
  c.prototype._isBuffer = !0;
  function ue(f, n, i) {
    var l = f[n];
    (f[n] = f[i]), (f[i] = l);
  }
  (c.prototype.swap16 = function () {
    var n = this.length;
    if (n % 2 !== 0)
      throw new RangeError("Buffer size must be a multiple of 16-bits");
    for (var i = 0; i < n; i += 2) ue(this, i, i + 1);
    return this;
  }),
    (c.prototype.swap32 = function () {
      var n = this.length;
      if (n % 4 !== 0)
        throw new RangeError("Buffer size must be a multiple of 32-bits");
      for (var i = 0; i < n; i += 4) ue(this, i, i + 3), ue(this, i + 1, i + 2);
      return this;
    }),
    (c.prototype.swap64 = function () {
      var n = this.length;
      if (n % 8 !== 0)
        throw new RangeError("Buffer size must be a multiple of 64-bits");
      for (var i = 0; i < n; i += 8)
        ue(this, i, i + 7),
          ue(this, i + 1, i + 6),
          ue(this, i + 2, i + 5),
          ue(this, i + 3, i + 4);
      return this;
    }),
    (c.prototype.toString = function () {
      var n = this.length;
      return n === 0
        ? ""
        : arguments.length === 0
          ? Se(this, 0, n)
          : Ue.apply(this, arguments);
    }),
    (c.prototype.toLocaleString = c.prototype.toString),
    (c.prototype.equals = function (n) {
      if (!c.isBuffer(n)) throw new TypeError("Argument must be a Buffer");
      return this === n ? !0 : c.compare(this, n) === 0;
    }),
    (c.prototype.inspect = function () {
      var n = "",
        i = t.INSPECT_MAX_BYTES;
      return (
        (n = this.toString("hex", 0, i)
          .replace(/(.{2})/g, "$1 ")
          .trim()),
        this.length > i && (n += " ... "),
        "<Buffer " + n + ">"
      );
    }),
    s && (c.prototype[s] = c.prototype.inspect),
    (c.prototype.compare = function (n, i, l, p, E) {
      if (
        (T(n, Uint8Array) && (n = c.from(n, n.offset, n.byteLength)),
        !c.isBuffer(n))
      )
        throw new TypeError(
          'The "target" argument must be one of type Buffer or Uint8Array. Received type ' +
            typeof n,
        );
      if (
        (i === void 0 && (i = 0),
        l === void 0 && (l = n ? n.length : 0),
        p === void 0 && (p = 0),
        E === void 0 && (E = this.length),
        i < 0 || l > n.length || p < 0 || E > this.length)
      )
        throw new RangeError("out of range index");
      if (p >= E && i >= l) return 0;
      if (p >= E) return -1;
      if (i >= l) return 1;
      if (((i >>>= 0), (l >>>= 0), (p >>>= 0), (E >>>= 0), this === n))
        return 0;
      for (
        var F = E - p,
          D = l - i,
          z = Math.min(F, D),
          V = this.slice(p, E),
          re = n.slice(i, l),
          h = 0;
        h < z;
        ++h
      )
        if (V[h] !== re[h]) {
          (F = V[h]), (D = re[h]);
          break;
        }
      return F < D ? -1 : D < F ? 1 : 0;
    });
  function J(f, n, i, l, p) {
    if (f.length === 0) return -1;
    if (
      (typeof i == "string"
        ? ((l = i), (i = 0))
        : i > 2147483647
          ? (i = 2147483647)
          : i < -2147483648 && (i = -2147483648),
      (i = +i),
      B(i) && (i = p ? 0 : f.length - 1),
      i < 0 && (i = f.length + i),
      i >= f.length)
    ) {
      if (p) return -1;
      i = f.length - 1;
    } else if (i < 0)
      if (p) i = 0;
      else return -1;
    if ((typeof n == "string" && (n = c.from(n, l)), c.isBuffer(n)))
      return n.length === 0 ? -1 : X(f, n, i, l, p);
    if (typeof n == "number")
      return (
        (n = n & 255),
        typeof Uint8Array.prototype.indexOf == "function"
          ? p
            ? Uint8Array.prototype.indexOf.call(f, n, i)
            : Uint8Array.prototype.lastIndexOf.call(f, n, i)
          : X(f, [n], i, l, p)
      );
    throw new TypeError("val must be string, number or Buffer");
  }
  function X(f, n, i, l, p) {
    var E = 1,
      F = f.length,
      D = n.length;
    if (
      l !== void 0 &&
      ((l = String(l).toLowerCase()),
      l === "ucs2" || l === "ucs-2" || l === "utf16le" || l === "utf-16le")
    ) {
      if (f.length < 2 || n.length < 2) return -1;
      (E = 2), (F /= 2), (D /= 2), (i /= 2);
    }
    function z(a, m) {
      return E === 1 ? a[m] : a.readUInt16BE(m * E);
    }
    var V;
    if (p) {
      var re = -1;
      for (V = i; V < F; V++)
        if (z(f, V) === z(n, re === -1 ? 0 : V - re)) {
          if ((re === -1 && (re = V), V - re + 1 === D)) return re * E;
        } else re !== -1 && (V -= V - re), (re = -1);
    } else
      for (i + D > F && (i = F - D), V = i; V >= 0; V--) {
        for (var h = !0, o = 0; o < D; o++)
          if (z(f, V + o) !== z(n, o)) {
            h = !1;
            break;
          }
        if (h) return V;
      }
    return -1;
  }
  (c.prototype.includes = function (n, i, l) {
    return this.indexOf(n, i, l) !== -1;
  }),
    (c.prototype.indexOf = function (n, i, l) {
      return J(this, n, i, l, !0);
    }),
    (c.prototype.lastIndexOf = function (n, i, l) {
      return J(this, n, i, l, !1);
    });
  function ne(f, n, i, l) {
    i = Number(i) || 0;
    var p = f.length - i;
    l ? ((l = Number(l)), l > p && (l = p)) : (l = p);
    var E = n.length;
    l > E / 2 && (l = E / 2);
    for (var F = 0; F < l; ++F) {
      var D = parseInt(n.substr(F * 2, 2), 16);
      if (B(D)) return F;
      f[i + F] = D;
    }
    return F;
  }
  function ie(f, n, i, l) {
    return _(H(n, f.length - i), f, i, l);
  }
  function C(f, n, i, l) {
    return _(Y(n), f, i, l);
  }
  function xe(f, n, i, l) {
    return _(x(n), f, i, l);
  }
  function ce(f, n, i, l) {
    return _(w(n, f.length - i), f, i, l);
  }
  (c.prototype.write = function (n, i, l, p) {
    if (i === void 0) (p = "utf8"), (l = this.length), (i = 0);
    else if (l === void 0 && typeof i == "string")
      (p = i), (l = this.length), (i = 0);
    else if (isFinite(i))
      (i = i >>> 0),
        isFinite(l)
          ? ((l = l >>> 0), p === void 0 && (p = "utf8"))
          : ((p = l), (l = void 0));
    else
      throw new Error(
        "Buffer.write(string, encoding, offset[, length]) is no longer supported",
      );
    var E = this.length - i;
    if (
      ((l === void 0 || l > E) && (l = E),
      (n.length > 0 && (l < 0 || i < 0)) || i > this.length)
    )
      throw new RangeError("Attempt to write outside buffer bounds");
    p || (p = "utf8");
    for (var F = !1; ; )
      switch (p) {
        case "hex":
          return ne(this, n, i, l);
        case "utf8":
        case "utf-8":
          return ie(this, n, i, l);
        case "ascii":
        case "latin1":
        case "binary":
          return C(this, n, i, l);
        case "base64":
          return xe(this, n, i, l);
        case "ucs2":
        case "ucs-2":
        case "utf16le":
        case "utf-16le":
          return ce(this, n, i, l);
        default:
          if (F) throw new TypeError("Unknown encoding: " + p);
          (p = ("" + p).toLowerCase()), (F = !0);
      }
  }),
    (c.prototype.toJSON = function () {
      return {
        type: "Buffer",
        data: Array.prototype.slice.call(this._arr || this, 0),
      };
    });
  function fe(f, n, i) {
    return n === 0 && i === f.length
      ? e.fromByteArray(f)
      : e.fromByteArray(f.slice(n, i));
  }
  function Se(f, n, i) {
    i = Math.min(f.length, i);
    for (var l = [], p = n; p < i; ) {
      var E = f[p],
        F = null,
        D = E > 239 ? 4 : E > 223 ? 3 : E > 191 ? 2 : 1;
      if (p + D <= i) {
        var z, V, re, h;
        switch (D) {
          case 1:
            E < 128 && (F = E);
            break;
          case 2:
            (z = f[p + 1]),
              (z & 192) === 128 &&
                ((h = ((E & 31) << 6) | (z & 63)), h > 127 && (F = h));
            break;
          case 3:
            (z = f[p + 1]),
              (V = f[p + 2]),
              (z & 192) === 128 &&
                (V & 192) === 128 &&
                ((h = ((E & 15) << 12) | ((z & 63) << 6) | (V & 63)),
                h > 2047 && (h < 55296 || h > 57343) && (F = h));
            break;
          case 4:
            (z = f[p + 1]),
              (V = f[p + 2]),
              (re = f[p + 3]),
              (z & 192) === 128 &&
                (V & 192) === 128 &&
                (re & 192) === 128 &&
                ((h =
                  ((E & 15) << 18) |
                  ((z & 63) << 12) |
                  ((V & 63) << 6) |
                  (re & 63)),
                h > 65535 && h < 1114112 && (F = h));
        }
      }
      F === null
        ? ((F = 65533), (D = 1))
        : F > 65535 &&
          ((F -= 65536),
          l.push(((F >>> 10) & 1023) | 55296),
          (F = 56320 | (F & 1023))),
        l.push(F),
        (p += D);
    }
    return Z(l);
  }
  var _e = 4096;
  function Z(f) {
    var n = f.length;
    if (n <= _e) return String.fromCharCode.apply(String, f);
    for (var i = "", l = 0; l < n; )
      i += String.fromCharCode.apply(String, f.slice(l, (l += _e)));
    return i;
  }
  function P(f, n, i) {
    var l = "";
    i = Math.min(f.length, i);
    for (var p = n; p < i; ++p) l += String.fromCharCode(f[p] & 127);
    return l;
  }
  function k(f, n, i) {
    var l = "";
    i = Math.min(f.length, i);
    for (var p = n; p < i; ++p) l += String.fromCharCode(f[p]);
    return l;
  }
  function j(f, n, i) {
    var l = f.length;
    (!n || n < 0) && (n = 0), (!i || i < 0 || i > l) && (i = l);
    for (var p = "", E = n; E < i; ++E) p += U[f[E]];
    return p;
  }
  function Q(f, n, i) {
    for (var l = f.slice(n, i), p = "", E = 0; E < l.length - 1; E += 2)
      p += String.fromCharCode(l[E] + l[E + 1] * 256);
    return p;
  }
  c.prototype.slice = function (n, i) {
    var l = this.length;
    (n = ~~n),
      (i = i === void 0 ? l : ~~i),
      n < 0 ? ((n += l), n < 0 && (n = 0)) : n > l && (n = l),
      i < 0 ? ((i += l), i < 0 && (i = 0)) : i > l && (i = l),
      i < n && (i = n);
    var p = this.subarray(n, i);
    return Object.setPrototypeOf(p, c.prototype), p;
  };
  function G(f, n, i) {
    if (f % 1 !== 0 || f < 0) throw new RangeError("offset is not uint");
    if (f + n > i)
      throw new RangeError("Trying to access beyond buffer length");
  }
  (c.prototype.readUintLE = c.prototype.readUIntLE =
    function (n, i, l) {
      (n = n >>> 0), (i = i >>> 0), l || G(n, i, this.length);
      for (var p = this[n], E = 1, F = 0; ++F < i && (E *= 256); )
        p += this[n + F] * E;
      return p;
    }),
    (c.prototype.readUintBE = c.prototype.readUIntBE =
      function (n, i, l) {
        (n = n >>> 0), (i = i >>> 0), l || G(n, i, this.length);
        for (var p = this[n + --i], E = 1; i > 0 && (E *= 256); )
          p += this[n + --i] * E;
        return p;
      }),
    (c.prototype.readUint8 = c.prototype.readUInt8 =
      function (n, i) {
        return (n = n >>> 0), i || G(n, 1, this.length), this[n];
      }),
    (c.prototype.readUint16LE = c.prototype.readUInt16LE =
      function (n, i) {
        return (
          (n = n >>> 0), i || G(n, 2, this.length), this[n] | (this[n + 1] << 8)
        );
      }),
    (c.prototype.readUint16BE = c.prototype.readUInt16BE =
      function (n, i) {
        return (
          (n = n >>> 0), i || G(n, 2, this.length), (this[n] << 8) | this[n + 1]
        );
      }),
    (c.prototype.readUint32LE = c.prototype.readUInt32LE =
      function (n, i) {
        return (
          (n = n >>> 0),
          i || G(n, 4, this.length),
          (this[n] | (this[n + 1] << 8) | (this[n + 2] << 16)) +
            this[n + 3] * 16777216
        );
      }),
    (c.prototype.readUint32BE = c.prototype.readUInt32BE =
      function (n, i) {
        return (
          (n = n >>> 0),
          i || G(n, 4, this.length),
          this[n] * 16777216 +
            ((this[n + 1] << 16) | (this[n + 2] << 8) | this[n + 3])
        );
      }),
    (c.prototype.readIntLE = function (n, i, l) {
      (n = n >>> 0), (i = i >>> 0), l || G(n, i, this.length);
      for (var p = this[n], E = 1, F = 0; ++F < i && (E *= 256); )
        p += this[n + F] * E;
      return (E *= 128), p >= E && (p -= Math.pow(2, 8 * i)), p;
    }),
    (c.prototype.readIntBE = function (n, i, l) {
      (n = n >>> 0), (i = i >>> 0), l || G(n, i, this.length);
      for (var p = i, E = 1, F = this[n + --p]; p > 0 && (E *= 256); )
        F += this[n + --p] * E;
      return (E *= 128), F >= E && (F -= Math.pow(2, 8 * i)), F;
    }),
    (c.prototype.readInt8 = function (n, i) {
      return (
        (n = n >>> 0),
        i || G(n, 1, this.length),
        this[n] & 128 ? (255 - this[n] + 1) * -1 : this[n]
      );
    }),
    (c.prototype.readInt16LE = function (n, i) {
      (n = n >>> 0), i || G(n, 2, this.length);
      var l = this[n] | (this[n + 1] << 8);
      return l & 32768 ? l | 4294901760 : l;
    }),
    (c.prototype.readInt16BE = function (n, i) {
      (n = n >>> 0), i || G(n, 2, this.length);
      var l = this[n + 1] | (this[n] << 8);
      return l & 32768 ? l | 4294901760 : l;
    }),
    (c.prototype.readInt32LE = function (n, i) {
      return (
        (n = n >>> 0),
        i || G(n, 4, this.length),
        this[n] | (this[n + 1] << 8) | (this[n + 2] << 16) | (this[n + 3] << 24)
      );
    }),
    (c.prototype.readInt32BE = function (n, i) {
      return (
        (n = n >>> 0),
        i || G(n, 4, this.length),
        (this[n] << 24) | (this[n + 1] << 16) | (this[n + 2] << 8) | this[n + 3]
      );
    }),
    (c.prototype.readFloatLE = function (n, i) {
      return (
        (n = n >>> 0), i || G(n, 4, this.length), r.read(this, n, !0, 23, 4)
      );
    }),
    (c.prototype.readFloatBE = function (n, i) {
      return (
        (n = n >>> 0), i || G(n, 4, this.length), r.read(this, n, !1, 23, 4)
      );
    }),
    (c.prototype.readDoubleLE = function (n, i) {
      return (
        (n = n >>> 0), i || G(n, 8, this.length), r.read(this, n, !0, 52, 8)
      );
    }),
    (c.prototype.readDoubleBE = function (n, i) {
      return (
        (n = n >>> 0), i || G(n, 8, this.length), r.read(this, n, !1, 52, 8)
      );
    });
  function $(f, n, i, l, p, E) {
    if (!c.isBuffer(f))
      throw new TypeError('"buffer" argument must be a Buffer instance');
    if (n > p || n < E)
      throw new RangeError('"value" argument is out of bounds');
    if (i + l > f.length) throw new RangeError("Index out of range");
  }
  (c.prototype.writeUintLE = c.prototype.writeUIntLE =
    function (n, i, l, p) {
      if (((n = +n), (i = i >>> 0), (l = l >>> 0), !p)) {
        var E = Math.pow(2, 8 * l) - 1;
        $(this, n, i, l, E, 0);
      }
      var F = 1,
        D = 0;
      for (this[i] = n & 255; ++D < l && (F *= 256); )
        this[i + D] = (n / F) & 255;
      return i + l;
    }),
    (c.prototype.writeUintBE = c.prototype.writeUIntBE =
      function (n, i, l, p) {
        if (((n = +n), (i = i >>> 0), (l = l >>> 0), !p)) {
          var E = Math.pow(2, 8 * l) - 1;
          $(this, n, i, l, E, 0);
        }
        var F = l - 1,
          D = 1;
        for (this[i + F] = n & 255; --F >= 0 && (D *= 256); )
          this[i + F] = (n / D) & 255;
        return i + l;
      }),
    (c.prototype.writeUint8 = c.prototype.writeUInt8 =
      function (n, i, l) {
        return (
          (n = +n),
          (i = i >>> 0),
          l || $(this, n, i, 1, 255, 0),
          (this[i] = n & 255),
          i + 1
        );
      }),
    (c.prototype.writeUint16LE = c.prototype.writeUInt16LE =
      function (n, i, l) {
        return (
          (n = +n),
          (i = i >>> 0),
          l || $(this, n, i, 2, 65535, 0),
          (this[i] = n & 255),
          (this[i + 1] = n >>> 8),
          i + 2
        );
      }),
    (c.prototype.writeUint16BE = c.prototype.writeUInt16BE =
      function (n, i, l) {
        return (
          (n = +n),
          (i = i >>> 0),
          l || $(this, n, i, 2, 65535, 0),
          (this[i] = n >>> 8),
          (this[i + 1] = n & 255),
          i + 2
        );
      }),
    (c.prototype.writeUint32LE = c.prototype.writeUInt32LE =
      function (n, i, l) {
        return (
          (n = +n),
          (i = i >>> 0),
          l || $(this, n, i, 4, 4294967295, 0),
          (this[i + 3] = n >>> 24),
          (this[i + 2] = n >>> 16),
          (this[i + 1] = n >>> 8),
          (this[i] = n & 255),
          i + 4
        );
      }),
    (c.prototype.writeUint32BE = c.prototype.writeUInt32BE =
      function (n, i, l) {
        return (
          (n = +n),
          (i = i >>> 0),
          l || $(this, n, i, 4, 4294967295, 0),
          (this[i] = n >>> 24),
          (this[i + 1] = n >>> 16),
          (this[i + 2] = n >>> 8),
          (this[i + 3] = n & 255),
          i + 4
        );
      }),
    (c.prototype.writeIntLE = function (n, i, l, p) {
      if (((n = +n), (i = i >>> 0), !p)) {
        var E = Math.pow(2, 8 * l - 1);
        $(this, n, i, l, E - 1, -E);
      }
      var F = 0,
        D = 1,
        z = 0;
      for (this[i] = n & 255; ++F < l && (D *= 256); )
        n < 0 && z === 0 && this[i + F - 1] !== 0 && (z = 1),
          (this[i + F] = (((n / D) >> 0) - z) & 255);
      return i + l;
    }),
    (c.prototype.writeIntBE = function (n, i, l, p) {
      if (((n = +n), (i = i >>> 0), !p)) {
        var E = Math.pow(2, 8 * l - 1);
        $(this, n, i, l, E - 1, -E);
      }
      var F = l - 1,
        D = 1,
        z = 0;
      for (this[i + F] = n & 255; --F >= 0 && (D *= 256); )
        n < 0 && z === 0 && this[i + F + 1] !== 0 && (z = 1),
          (this[i + F] = (((n / D) >> 0) - z) & 255);
      return i + l;
    }),
    (c.prototype.writeInt8 = function (n, i, l) {
      return (
        (n = +n),
        (i = i >>> 0),
        l || $(this, n, i, 1, 127, -128),
        n < 0 && (n = 255 + n + 1),
        (this[i] = n & 255),
        i + 1
      );
    }),
    (c.prototype.writeInt16LE = function (n, i, l) {
      return (
        (n = +n),
        (i = i >>> 0),
        l || $(this, n, i, 2, 32767, -32768),
        (this[i] = n & 255),
        (this[i + 1] = n >>> 8),
        i + 2
      );
    }),
    (c.prototype.writeInt16BE = function (n, i, l) {
      return (
        (n = +n),
        (i = i >>> 0),
        l || $(this, n, i, 2, 32767, -32768),
        (this[i] = n >>> 8),
        (this[i + 1] = n & 255),
        i + 2
      );
    }),
    (c.prototype.writeInt32LE = function (n, i, l) {
      return (
        (n = +n),
        (i = i >>> 0),
        l || $(this, n, i, 4, 2147483647, -2147483648),
        (this[i] = n & 255),
        (this[i + 1] = n >>> 8),
        (this[i + 2] = n >>> 16),
        (this[i + 3] = n >>> 24),
        i + 4
      );
    }),
    (c.prototype.writeInt32BE = function (n, i, l) {
      return (
        (n = +n),
        (i = i >>> 0),
        l || $(this, n, i, 4, 2147483647, -2147483648),
        n < 0 && (n = 4294967295 + n + 1),
        (this[i] = n >>> 24),
        (this[i + 1] = n >>> 16),
        (this[i + 2] = n >>> 8),
        (this[i + 3] = n & 255),
        i + 4
      );
    });
  function ye(f, n, i, l, p, E) {
    if (i + l > f.length) throw new RangeError("Index out of range");
    if (i < 0) throw new RangeError("Index out of range");
  }
  function y(f, n, i, l, p) {
    return (
      (n = +n),
      (i = i >>> 0),
      p || ye(f, n, i, 4),
      r.write(f, n, i, l, 23, 4),
      i + 4
    );
  }
  (c.prototype.writeFloatLE = function (n, i, l) {
    return y(this, n, i, !0, l);
  }),
    (c.prototype.writeFloatBE = function (n, i, l) {
      return y(this, n, i, !1, l);
    });
  function de(f, n, i, l, p) {
    return (
      (n = +n),
      (i = i >>> 0),
      p || ye(f, n, i, 8),
      r.write(f, n, i, l, 52, 8),
      i + 8
    );
  }
  (c.prototype.writeDoubleLE = function (n, i, l) {
    return de(this, n, i, !0, l);
  }),
    (c.prototype.writeDoubleBE = function (n, i, l) {
      return de(this, n, i, !1, l);
    }),
    (c.prototype.copy = function (n, i, l, p) {
      if (!c.isBuffer(n)) throw new TypeError("argument should be a Buffer");
      if (
        (l || (l = 0),
        !p && p !== 0 && (p = this.length),
        i >= n.length && (i = n.length),
        i || (i = 0),
        p > 0 && p < l && (p = l),
        p === l || n.length === 0 || this.length === 0)
      )
        return 0;
      if (i < 0) throw new RangeError("targetStart out of bounds");
      if (l < 0 || l >= this.length) throw new RangeError("Index out of range");
      if (p < 0) throw new RangeError("sourceEnd out of bounds");
      p > this.length && (p = this.length),
        n.length - i < p - l && (p = n.length - i + l);
      var E = p - l;
      return (
        this === n && typeof Uint8Array.prototype.copyWithin == "function"
          ? this.copyWithin(i, l, p)
          : Uint8Array.prototype.set.call(n, this.subarray(l, p), i),
        E
      );
    }),
    (c.prototype.fill = function (n, i, l, p) {
      if (typeof n == "string") {
        if (
          (typeof i == "string"
            ? ((p = i), (i = 0), (l = this.length))
            : typeof l == "string" && ((p = l), (l = this.length)),
          p !== void 0 && typeof p != "string")
        )
          throw new TypeError("encoding must be a string");
        if (typeof p == "string" && !c.isEncoding(p))
          throw new TypeError("Unknown encoding: " + p);
        if (n.length === 1) {
          var E = n.charCodeAt(0);
          ((p === "utf8" && E < 128) || p === "latin1") && (n = E);
        }
      } else
        typeof n == "number"
          ? (n = n & 255)
          : typeof n == "boolean" && (n = Number(n));
      if (i < 0 || this.length < i || this.length < l)
        throw new RangeError("Out of range index");
      if (l <= i) return this;
      (i = i >>> 0), (l = l === void 0 ? this.length : l >>> 0), n || (n = 0);
      var F;
      if (typeof n == "number") for (F = i; F < l; ++F) this[F] = n;
      else {
        var D = c.isBuffer(n) ? n : c.from(n, p),
          z = D.length;
        if (z === 0)
          throw new TypeError(
            'The value "' + n + '" is invalid for argument "value"',
          );
        for (F = 0; F < l - i; ++F) this[F + i] = D[F % z];
      }
      return this;
    });
  var me = /[^+/0-9A-Za-z-_]/g;
  function Te(f) {
    if (((f = f.split("=")[0]), (f = f.trim().replace(me, "")), f.length < 2))
      return "";
    for (; f.length % 4 !== 0; ) f = f + "=";
    return f;
  }
  function H(f, n) {
    n = n || 1 / 0;
    for (var i, l = f.length, p = null, E = [], F = 0; F < l; ++F) {
      if (((i = f.charCodeAt(F)), i > 55295 && i < 57344)) {
        if (!p) {
          if (i > 56319) {
            (n -= 3) > -1 && E.push(239, 191, 189);
            continue;
          } else if (F + 1 === l) {
            (n -= 3) > -1 && E.push(239, 191, 189);
            continue;
          }
          p = i;
          continue;
        }
        if (i < 56320) {
          (n -= 3) > -1 && E.push(239, 191, 189), (p = i);
          continue;
        }
        i = (((p - 55296) << 10) | (i - 56320)) + 65536;
      } else p && (n -= 3) > -1 && E.push(239, 191, 189);
      if (((p = null), i < 128)) {
        if ((n -= 1) < 0) break;
        E.push(i);
      } else if (i < 2048) {
        if ((n -= 2) < 0) break;
        E.push((i >> 6) | 192, (i & 63) | 128);
      } else if (i < 65536) {
        if ((n -= 3) < 0) break;
        E.push((i >> 12) | 224, ((i >> 6) & 63) | 128, (i & 63) | 128);
      } else if (i < 1114112) {
        if ((n -= 4) < 0) break;
        E.push(
          (i >> 18) | 240,
          ((i >> 12) & 63) | 128,
          ((i >> 6) & 63) | 128,
          (i & 63) | 128,
        );
      } else throw new Error("Invalid code point");
    }
    return E;
  }
  function Y(f) {
    for (var n = [], i = 0; i < f.length; ++i) n.push(f.charCodeAt(i) & 255);
    return n;
  }
  function w(f, n) {
    for (var i, l, p, E = [], F = 0; F < f.length && !((n -= 2) < 0); ++F)
      (i = f.charCodeAt(F)), (l = i >> 8), (p = i % 256), E.push(p), E.push(l);
    return E;
  }
  function x(f) {
    return e.toByteArray(Te(f));
  }
  function _(f, n, i, l) {
    for (var p = 0; p < l && !(p + i >= n.length || p >= f.length); ++p)
      n[p + i] = f[p];
    return p;
  }
  function T(f, n) {
    return (
      f instanceof n ||
      (f != null &&
        f.constructor != null &&
        f.constructor.name != null &&
        f.constructor.name === n.name)
    );
  }
  function B(f) {
    return f !== f;
  }
  var U = (function () {
    for (var f = "0123456789abcdef", n = new Array(256), i = 0; i < 16; ++i)
      for (var l = i * 16, p = 0; p < 16; ++p) n[l + p] = f[i] + f[p];
    return n;
  })();
})(Ot);
var ci = { exports: {} };
(function (t) {
  (function (e) {
    var r,
      s = /^-?(?:\d+(?:\.\d*)?|\.\d+)(?:e[+-]?\d+)?$/i,
      u = Math.ceil,
      d = Math.floor,
      g = "[BigNumber Error] ",
      c = g + "Number primitive has more than 15 significant digits: ",
      b = 1e14,
      S = 14,
      N = 9007199254740991,
      L = [
        1, 10, 100, 1e3, 1e4, 1e5, 1e6, 1e7, 1e8, 1e9, 1e10, 1e11, 1e12, 1e13,
      ],
      O = 1e7,
      M = 1e9;
    function q(J) {
      var X,
        ne,
        ie,
        C = (y.prototype = { constructor: y, toString: null, valueOf: null }),
        xe = new y(1),
        ce = 20,
        fe = 4,
        Se = -7,
        _e = 21,
        Z = -1e7,
        P = 1e7,
        k = !1,
        j = 1,
        Q = 0,
        G = {
          prefix: "",
          groupSize: 3,
          secondaryGroupSize: 0,
          groupSeparator: ",",
          decimalSeparator: ".",
          fractionGroupSize: 0,
          fractionGroupSeparator: " ",
          suffix: "",
        },
        $ = "0123456789abcdefghijklmnopqrstuvwxyz",
        ye = !0;
      function y(w, x) {
        var _,
          T,
          B,
          U,
          f,
          n,
          i,
          l,
          p = this;
        if (!(p instanceof y)) return new y(w, x);
        if (x == null) {
          if (w && w._isBigNumber === !0) {
            (p.s = w.s),
              !w.c || w.e > P
                ? (p.c = p.e = null)
                : w.e < Z
                  ? (p.c = [(p.e = 0)])
                  : ((p.e = w.e), (p.c = w.c.slice()));
            return;
          }
          if ((n = typeof w == "number") && w * 0 == 0) {
            if (((p.s = 1 / w < 0 ? ((w = -w), -1) : 1), w === ~~w)) {
              for (U = 0, f = w; f >= 10; f /= 10, U++);
              U > P ? (p.c = p.e = null) : ((p.e = U), (p.c = [w]));
              return;
            }
            l = String(w);
          } else {
            if (!s.test((l = String(w)))) return ie(p, l, n);
            p.s = l.charCodeAt(0) == 45 ? ((l = l.slice(1)), -1) : 1;
          }
          (U = l.indexOf(".")) > -1 && (l = l.replace(".", "")),
            (f = l.search(/e/i)) > 0
              ? (U < 0 && (U = f),
                (U += +l.slice(f + 1)),
                (l = l.substring(0, f)))
              : U < 0 && (U = l.length);
        } else {
          if ((ae(x, 2, $.length, "Base"), x == 10 && ye))
            return (p = new y(w)), H(p, ce + p.e + 1, fe);
          if (((l = String(w)), (n = typeof w == "number"))) {
            if (w * 0 != 0) return ie(p, l, n, x);
            if (
              ((p.s = 1 / w < 0 ? ((l = l.slice(1)), -1) : 1),
              y.DEBUG && l.replace(/^0\.0*|\./, "").length > 15)
            )
              throw Error(c + w);
          } else p.s = l.charCodeAt(0) === 45 ? ((l = l.slice(1)), -1) : 1;
          for (_ = $.slice(0, x), U = f = 0, i = l.length; f < i; f++)
            if (_.indexOf((T = l.charAt(f))) < 0) {
              if (T == ".") {
                if (f > U) {
                  U = i;
                  continue;
                }
              } else if (
                !B &&
                ((l == l.toUpperCase() && (l = l.toLowerCase())) ||
                  (l == l.toLowerCase() && (l = l.toUpperCase())))
              ) {
                (B = !0), (f = -1), (U = 0);
                continue;
              }
              return ie(p, String(w), n, x);
            }
          (n = !1),
            (l = ne(l, x, 10, p.s)),
            (U = l.indexOf(".")) > -1
              ? (l = l.replace(".", ""))
              : (U = l.length);
        }
        for (f = 0; l.charCodeAt(f) === 48; f++);
        for (i = l.length; l.charCodeAt(--i) === 48; );
        if ((l = l.slice(f, ++i))) {
          if (((i -= f), n && y.DEBUG && i > 15 && (w > N || w !== d(w))))
            throw Error(c + p.s * w);
          if ((U = U - f - 1) > P) p.c = p.e = null;
          else if (U < Z) p.c = [(p.e = 0)];
          else {
            if (
              ((p.e = U),
              (p.c = []),
              (f = (U + 1) % S),
              U < 0 && (f += S),
              f < i)
            ) {
              for (f && p.c.push(+l.slice(0, f)), i -= S; f < i; )
                p.c.push(+l.slice(f, (f += S)));
              f = S - (l = l.slice(f)).length;
            } else f -= i;
            for (; f--; l += "0");
            p.c.push(+l);
          }
        } else p.c = [(p.e = 0)];
      }
      (y.clone = q),
        (y.ROUND_UP = 0),
        (y.ROUND_DOWN = 1),
        (y.ROUND_CEIL = 2),
        (y.ROUND_FLOOR = 3),
        (y.ROUND_HALF_UP = 4),
        (y.ROUND_HALF_DOWN = 5),
        (y.ROUND_HALF_EVEN = 6),
        (y.ROUND_HALF_CEIL = 7),
        (y.ROUND_HALF_FLOOR = 8),
        (y.EUCLID = 9),
        (y.config = y.set =
          function (w) {
            var x, _;
            if (w != null)
              if (typeof w == "object") {
                if (
                  (w.hasOwnProperty((x = "DECIMAL_PLACES")) &&
                    ((_ = w[x]), ae(_, 0, M, x), (ce = _)),
                  w.hasOwnProperty((x = "ROUNDING_MODE")) &&
                    ((_ = w[x]), ae(_, 0, 8, x), (fe = _)),
                  w.hasOwnProperty((x = "EXPONENTIAL_AT")) &&
                    ((_ = w[x]),
                    _ && _.pop
                      ? (ae(_[0], -1e9, 0, x),
                        ae(_[1], 0, M, x),
                        (Se = _[0]),
                        (_e = _[1]))
                      : (ae(_, -1e9, M, x), (Se = -(_e = _ < 0 ? -_ : _)))),
                  w.hasOwnProperty((x = "RANGE")))
                )
                  if (((_ = w[x]), _ && _.pop))
                    ae(_[0], -1e9, -1, x),
                      ae(_[1], 1, M, x),
                      (Z = _[0]),
                      (P = _[1]);
                  else if ((ae(_, -1e9, M, x), _)) Z = -(P = _ < 0 ? -_ : _);
                  else throw Error(g + x + " cannot be zero: " + _);
                if (w.hasOwnProperty((x = "CRYPTO")))
                  if (((_ = w[x]), _ === !!_))
                    if (_)
                      if (
                        typeof crypto < "u" &&
                        crypto &&
                        (crypto.getRandomValues || crypto.randomBytes)
                      )
                        k = _;
                      else throw ((k = !_), Error(g + "crypto unavailable"));
                    else k = _;
                  else throw Error(g + x + " not true or false: " + _);
                if (
                  (w.hasOwnProperty((x = "MODULO_MODE")) &&
                    ((_ = w[x]), ae(_, 0, 9, x), (j = _)),
                  w.hasOwnProperty((x = "POW_PRECISION")) &&
                    ((_ = w[x]), ae(_, 0, M, x), (Q = _)),
                  w.hasOwnProperty((x = "FORMAT")))
                )
                  if (((_ = w[x]), typeof _ == "object")) G = _;
                  else throw Error(g + x + " not an object: " + _);
                if (w.hasOwnProperty((x = "ALPHABET")))
                  if (
                    ((_ = w[x]),
                    typeof _ == "string" && !/^.?$|[+\-.\s]|(.).*\1/.test(_))
                  )
                    (ye = _.slice(0, 10) == "0123456789"), ($ = _);
                  else throw Error(g + x + " invalid: " + _);
              } else throw Error(g + "Object expected: " + w);
            return {
              DECIMAL_PLACES: ce,
              ROUNDING_MODE: fe,
              EXPONENTIAL_AT: [Se, _e],
              RANGE: [Z, P],
              CRYPTO: k,
              MODULO_MODE: j,
              POW_PRECISION: Q,
              FORMAT: G,
              ALPHABET: $,
            };
          }),
        (y.isBigNumber = function (w) {
          if (!w || w._isBigNumber !== !0) return !1;
          if (!y.DEBUG) return !0;
          var x,
            _,
            T = w.c,
            B = w.e,
            U = w.s;
          e: if ({}.toString.call(T) == "[object Array]") {
            if ((U === 1 || U === -1) && B >= -1e9 && B <= M && B === d(B)) {
              if (T[0] === 0) {
                if (B === 0 && T.length === 1) return !0;
                break e;
              }
              if (
                ((x = (B + 1) % S), x < 1 && (x += S), String(T[0]).length == x)
              ) {
                for (x = 0; x < T.length; x++)
                  if (((_ = T[x]), _ < 0 || _ >= b || _ !== d(_))) break e;
                if (_ !== 0) return !0;
              }
            }
          } else if (
            T === null &&
            B === null &&
            (U === null || U === 1 || U === -1)
          )
            return !0;
          throw Error(g + "Invalid BigNumber: " + w);
        }),
        (y.maximum = y.max =
          function () {
            return me(arguments, -1);
          }),
        (y.minimum = y.min =
          function () {
            return me(arguments, 1);
          }),
        (y.random = (function () {
          var w = 9007199254740992,
            x =
              (Math.random() * w) & 2097151
                ? function () {
                    return d(Math.random() * w);
                  }
                : function () {
                    return (
                      ((Math.random() * 1073741824) | 0) * 8388608 +
                      ((Math.random() * 8388608) | 0)
                    );
                  };
          return function (_) {
            var T,
              B,
              U,
              f,
              n,
              i = 0,
              l = [],
              p = new y(xe);
            if ((_ == null ? (_ = ce) : ae(_, 0, M), (f = u(_ / S)), k))
              if (crypto.getRandomValues) {
                for (
                  T = crypto.getRandomValues(new Uint32Array((f *= 2)));
                  i < f;

                )
                  (n = T[i] * 131072 + (T[i + 1] >>> 11)),
                    n >= 9e15
                      ? ((B = crypto.getRandomValues(new Uint32Array(2))),
                        (T[i] = B[0]),
                        (T[i + 1] = B[1]))
                      : (l.push(n % 1e14), (i += 2));
                i = f / 2;
              } else if (crypto.randomBytes) {
                for (T = crypto.randomBytes((f *= 7)); i < f; )
                  (n =
                    (T[i] & 31) * 281474976710656 +
                    T[i + 1] * 1099511627776 +
                    T[i + 2] * 4294967296 +
                    T[i + 3] * 16777216 +
                    (T[i + 4] << 16) +
                    (T[i + 5] << 8) +
                    T[i + 6]),
                    n >= 9e15
                      ? crypto.randomBytes(7).copy(T, i)
                      : (l.push(n % 1e14), (i += 7));
                i = f / 7;
              } else throw ((k = !1), Error(g + "crypto unavailable"));
            if (!k) for (; i < f; ) (n = x()), n < 9e15 && (l[i++] = n % 1e14);
            for (
              f = l[--i],
                _ %= S,
                f && _ && ((n = L[S - _]), (l[i] = d(f / n) * n));
              l[i] === 0;
              l.pop(), i--
            );
            if (i < 0) l = [(U = 0)];
            else {
              for (U = -1; l[0] === 0; l.splice(0, 1), U -= S);
              for (i = 1, n = l[0]; n >= 10; n /= 10, i++);
              i < S && (U -= S - i);
            }
            return (p.e = U), (p.c = l), p;
          };
        })()),
        (y.sum = function () {
          for (var w = 1, x = arguments, _ = new y(x[0]); w < x.length; )
            _ = _.plus(x[w++]);
          return _;
        }),
        (ne = (function () {
          var w = "0123456789";
          function x(_, T, B, U) {
            for (var f, n = [0], i, l = 0, p = _.length; l < p; ) {
              for (i = n.length; i--; n[i] *= T);
              for (n[0] += U.indexOf(_.charAt(l++)), f = 0; f < n.length; f++)
                n[f] > B - 1 &&
                  (n[f + 1] == null && (n[f + 1] = 0),
                  (n[f + 1] += (n[f] / B) | 0),
                  (n[f] %= B));
            }
            return n.reverse();
          }
          return function (_, T, B, U, f) {
            var n,
              i,
              l,
              p,
              E,
              F,
              D,
              z,
              V = _.indexOf("."),
              re = ce,
              h = fe;
            for (
              V >= 0 &&
                ((p = Q),
                (Q = 0),
                (_ = _.replace(".", "")),
                (z = new y(T)),
                (F = z.pow(_.length - V)),
                (Q = p),
                (z.c = x(ue(le(F.c), F.e, "0"), 10, B, w)),
                (z.e = z.c.length)),
                D = x(_, T, B, f ? ((n = $), w) : ((n = w), $)),
                l = p = D.length;
              D[--p] == 0;
              D.pop()
            );
            if (!D[0]) return n.charAt(0);
            if (
              (V < 0
                ? --l
                : ((F.c = D),
                  (F.e = l),
                  (F.s = U),
                  (F = X(F, z, re, h, B)),
                  (D = F.c),
                  (E = F.r),
                  (l = F.e)),
              (i = l + re + 1),
              (V = D[i]),
              (p = B / 2),
              (E = E || i < 0 || D[i + 1] != null),
              (E =
                h < 4
                  ? (V != null || E) && (h == 0 || h == (F.s < 0 ? 3 : 2))
                  : V > p ||
                    (V == p &&
                      (h == 4 ||
                        E ||
                        (h == 6 && D[i - 1] & 1) ||
                        h == (F.s < 0 ? 8 : 7)))),
              i < 1 || !D[0])
            )
              _ = E ? ue(n.charAt(1), -re, n.charAt(0)) : n.charAt(0);
            else {
              if (((D.length = i), E))
                for (--B; ++D[--i] > B; )
                  (D[i] = 0), i || (++l, (D = [1].concat(D)));
              for (p = D.length; !D[--p]; );
              for (V = 0, _ = ""; V <= p; _ += n.charAt(D[V++]));
              _ = ue(_, l, n.charAt(0));
            }
            return _;
          };
        })()),
        (X = (function () {
          function w(T, B, U) {
            var f,
              n,
              i,
              l,
              p = 0,
              E = T.length,
              F = B % O,
              D = (B / O) | 0;
            for (T = T.slice(); E--; )
              (i = T[E] % O),
                (l = (T[E] / O) | 0),
                (f = D * i + l * F),
                (n = F * i + (f % O) * O + p),
                (p = ((n / U) | 0) + ((f / O) | 0) + D * l),
                (T[E] = n % U);
            return p && (T = [p].concat(T)), T;
          }
          function x(T, B, U, f) {
            var n, i;
            if (U != f) i = U > f ? 1 : -1;
            else
              for (n = i = 0; n < U; n++)
                if (T[n] != B[n]) {
                  i = T[n] > B[n] ? 1 : -1;
                  break;
                }
            return i;
          }
          function _(T, B, U, f) {
            for (var n = 0; U--; )
              (T[U] -= n),
                (n = T[U] < B[U] ? 1 : 0),
                (T[U] = n * f + T[U] - B[U]);
            for (; !T[0] && T.length > 1; T.splice(0, 1));
          }
          return function (T, B, U, f, n) {
            var i,
              l,
              p,
              E,
              F,
              D,
              z,
              V,
              re,
              h,
              o,
              a,
              m,
              A,
              R,
              v,
              te,
              he = T.s == B.s ? 1 : -1,
              se = T.c,
              ee = B.c;
            if (!se || !se[0] || !ee || !ee[0])
              return new y(
                !T.s || !B.s || (se ? ee && se[0] == ee[0] : !ee)
                  ? NaN
                  : (se && se[0] == 0) || !ee
                    ? he * 0
                    : he / 0,
              );
            for (
              V = new y(he),
                re = V.c = [],
                l = T.e - B.e,
                he = U + l + 1,
                n ||
                  ((n = b), (l = W(T.e / S) - W(B.e / S)), (he = (he / S) | 0)),
                p = 0;
              ee[p] == (se[p] || 0);
              p++
            );
            if ((ee[p] > (se[p] || 0) && l--, he < 0)) re.push(1), (E = !0);
            else {
              for (
                A = se.length,
                  v = ee.length,
                  p = 0,
                  he += 2,
                  F = d(n / (ee[0] + 1)),
                  F > 1 &&
                    ((ee = w(ee, F, n)),
                    (se = w(se, F, n)),
                    (v = ee.length),
                    (A = se.length)),
                  m = v,
                  h = se.slice(0, v),
                  o = h.length;
                o < v;
                h[o++] = 0
              );
              (te = ee.slice()),
                (te = [0].concat(te)),
                (R = ee[0]),
                ee[1] >= n / 2 && R++;
              do {
                if (((F = 0), (i = x(ee, h, v, o)), i < 0)) {
                  if (
                    ((a = h[0]),
                    v != o && (a = a * n + (h[1] || 0)),
                    (F = d(a / R)),
                    F > 1)
                  )
                    for (
                      F >= n && (F = n - 1),
                        D = w(ee, F, n),
                        z = D.length,
                        o = h.length;
                      x(D, h, z, o) == 1;

                    )
                      F--, _(D, v < z ? te : ee, z, n), (z = D.length), (i = 1);
                  else F == 0 && (i = F = 1), (D = ee.slice()), (z = D.length);
                  if (
                    (z < o && (D = [0].concat(D)),
                    _(h, D, o, n),
                    (o = h.length),
                    i == -1)
                  )
                    for (; x(ee, h, v, o) < 1; )
                      F++, _(h, v < o ? te : ee, o, n), (o = h.length);
                } else i === 0 && (F++, (h = [0]));
                (re[p++] = F),
                  h[0] ? (h[o++] = se[m] || 0) : ((h = [se[m]]), (o = 1));
              } while ((m++ < A || h[0] != null) && he--);
              (E = h[0] != null), re[0] || re.splice(0, 1);
            }
            if (n == b) {
              for (p = 1, he = re[0]; he >= 10; he /= 10, p++);
              H(V, U + (V.e = p + l * S - 1) + 1, f, E);
            } else (V.e = l), (V.r = +E);
            return V;
          };
        })());
      function de(w, x, _, T) {
        var B, U, f, n, i;
        if ((_ == null ? (_ = fe) : ae(_, 0, 8), !w.c)) return w.toString();
        if (((B = w.c[0]), (f = w.e), x == null))
          (i = le(w.c)),
            (i =
              T == 1 || (T == 2 && (f <= Se || f >= _e))
                ? Ue(i, f)
                : ue(i, f, "0"));
        else if (
          ((w = H(new y(w), x, _)),
          (U = w.e),
          (i = le(w.c)),
          (n = i.length),
          T == 1 || (T == 2 && (x <= U || U <= Se)))
        ) {
          for (; n < x; i += "0", n++);
          i = Ue(i, U);
        } else if (((x -= f), (i = ue(i, U, "0")), U + 1 > n)) {
          if (--x > 0) for (i += "."; x--; i += "0");
        } else if (((x += U - n), x > 0))
          for (U + 1 == n && (i += "."); x--; i += "0");
        return w.s < 0 && B ? "-" + i : i;
      }
      function me(w, x) {
        for (var _, T, B = 1, U = new y(w[0]); B < w.length; B++)
          (T = new y(w[B])),
            (!T.s || (_ = Ee(U, T)) === x || (_ === 0 && U.s === x)) && (U = T);
        return U;
      }
      function Te(w, x, _) {
        for (var T = 1, B = x.length; !x[--B]; x.pop());
        for (B = x[0]; B >= 10; B /= 10, T++);
        return (
          (_ = T + _ * S - 1) > P
            ? (w.c = w.e = null)
            : _ < Z
              ? (w.c = [(w.e = 0)])
              : ((w.e = _), (w.c = x)),
          w
        );
      }
      ie = (function () {
        var w = /^(-?)0([xbo])(?=\w[\w.]*$)/i,
          x = /^([^.]+)\.$/,
          _ = /^\.([^.]+)$/,
          T = /^-?(Infinity|NaN)$/,
          B = /^\s*\+(?=[\w.])|^\s+|\s+$/g;
        return function (U, f, n, i) {
          var l,
            p = n ? f : f.replace(B, "");
          if (T.test(p)) U.s = isNaN(p) ? null : p < 0 ? -1 : 1;
          else {
            if (
              !n &&
              ((p = p.replace(w, function (E, F, D) {
                return (
                  (l = (D = D.toLowerCase()) == "x" ? 16 : D == "b" ? 2 : 8),
                  !i || i == l ? F : E
                );
              })),
              i && ((l = i), (p = p.replace(x, "$1").replace(_, "0.$1"))),
              f != p)
            )
              return new y(p, l);
            if (y.DEBUG)
              throw Error(
                g + "Not a" + (i ? " base " + i : "") + " number: " + f,
              );
            U.s = null;
          }
          U.c = U.e = null;
        };
      })();
      function H(w, x, _, T) {
        var B,
          U,
          f,
          n,
          i,
          l,
          p,
          E = w.c,
          F = L;
        if (E) {
          e: {
            for (B = 1, n = E[0]; n >= 10; n /= 10, B++);
            if (((U = x - B), U < 0))
              (U += S),
                (f = x),
                (i = E[(l = 0)]),
                (p = d((i / F[B - f - 1]) % 10));
            else if (((l = u((U + 1) / S)), l >= E.length))
              if (T) {
                for (; E.length <= l; E.push(0));
                (i = p = 0), (B = 1), (U %= S), (f = U - S + 1);
              } else break e;
            else {
              for (i = n = E[l], B = 1; n >= 10; n /= 10, B++);
              (U %= S),
                (f = U - S + B),
                (p = f < 0 ? 0 : d((i / F[B - f - 1]) % 10));
            }
            if (
              ((T =
                T ||
                x < 0 ||
                E[l + 1] != null ||
                (f < 0 ? i : i % F[B - f - 1])),
              (T =
                _ < 4
                  ? (p || T) && (_ == 0 || _ == (w.s < 0 ? 3 : 2))
                  : p > 5 ||
                    (p == 5 &&
                      (_ == 4 ||
                        T ||
                        (_ == 6 &&
                          (U > 0 ? (f > 0 ? i / F[B - f] : 0) : E[l - 1]) % 10 &
                            1) ||
                        _ == (w.s < 0 ? 8 : 7)))),
              x < 1 || !E[0])
            )
              return (
                (E.length = 0),
                T
                  ? ((x -= w.e + 1),
                    (E[0] = F[(S - (x % S)) % S]),
                    (w.e = -x || 0))
                  : (E[0] = w.e = 0),
                w
              );
            if (
              (U == 0
                ? ((E.length = l), (n = 1), l--)
                : ((E.length = l + 1),
                  (n = F[S - U]),
                  (E[l] = f > 0 ? d((i / F[B - f]) % F[f]) * n : 0)),
              T)
            )
              for (;;)
                if (l == 0) {
                  for (U = 1, f = E[0]; f >= 10; f /= 10, U++);
                  for (f = E[0] += n, n = 1; f >= 10; f /= 10, n++);
                  U != n && (w.e++, E[0] == b && (E[0] = 1));
                  break;
                } else {
                  if (((E[l] += n), E[l] != b)) break;
                  (E[l--] = 0), (n = 1);
                }
            for (U = E.length; E[--U] === 0; E.pop());
          }
          w.e > P ? (w.c = w.e = null) : w.e < Z && (w.c = [(w.e = 0)]);
        }
        return w;
      }
      function Y(w) {
        var x,
          _ = w.e;
        return _ === null
          ? w.toString()
          : ((x = le(w.c)),
            (x = _ <= Se || _ >= _e ? Ue(x, _) : ue(x, _, "0")),
            w.s < 0 ? "-" + x : x);
      }
      return (
        (C.absoluteValue = C.abs =
          function () {
            var w = new y(this);
            return w.s < 0 && (w.s = 1), w;
          }),
        (C.comparedTo = function (w, x) {
          return Ee(this, new y(w, x));
        }),
        (C.decimalPlaces = C.dp =
          function (w, x) {
            var _,
              T,
              B,
              U = this;
            if (w != null)
              return (
                ae(w, 0, M),
                x == null ? (x = fe) : ae(x, 0, 8),
                H(new y(U), w + U.e + 1, x)
              );
            if (!(_ = U.c)) return null;
            if (((T = ((B = _.length - 1) - W(this.e / S)) * S), (B = _[B])))
              for (; B % 10 == 0; B /= 10, T--);
            return T < 0 && (T = 0), T;
          }),
        (C.dividedBy = C.div =
          function (w, x) {
            return X(this, new y(w, x), ce, fe);
          }),
        (C.dividedToIntegerBy = C.idiv =
          function (w, x) {
            return X(this, new y(w, x), 0, 1);
          }),
        (C.exponentiatedBy = C.pow =
          function (w, x) {
            var _,
              T,
              B,
              U,
              f,
              n,
              i,
              l,
              p,
              E = this;
            if (((w = new y(w)), w.c && !w.isInteger()))
              throw Error(g + "Exponent not an integer: " + Y(w));
            if (
              (x != null && (x = new y(x)),
              (n = w.e > 14),
              !E.c ||
                !E.c[0] ||
                (E.c[0] == 1 && !E.e && E.c.length == 1) ||
                !w.c ||
                !w.c[0])
            )
              return (
                (p = new y(Math.pow(+Y(E), n ? w.s * (2 - K(w)) : +Y(w)))),
                x ? p.mod(x) : p
              );
            if (((i = w.s < 0), x)) {
              if (x.c ? !x.c[0] : !x.s) return new y(NaN);
              (T = !i && E.isInteger() && x.isInteger()), T && (E = E.mod(x));
            } else {
              if (
                w.e > 9 &&
                (E.e > 0 ||
                  E.e < -1 ||
                  (E.e == 0
                    ? E.c[0] > 1 || (n && E.c[1] >= 24e7)
                    : E.c[0] < 8e13 || (n && E.c[0] <= 9999975e7)))
              )
                return (
                  (U = E.s < 0 && K(w) ? -0 : 0),
                  E.e > -1 && (U = 1 / U),
                  new y(i ? 1 / U : U)
                );
              Q && (U = u(Q / S + 2));
            }
            for (
              n
                ? ((_ = new y(0.5)), i && (w.s = 1), (l = K(w)))
                : ((B = Math.abs(+Y(w))), (l = B % 2)),
                p = new y(xe);
              ;

            ) {
              if (l) {
                if (((p = p.times(E)), !p.c)) break;
                U ? p.c.length > U && (p.c.length = U) : T && (p = p.mod(x));
              }
              if (B) {
                if (((B = d(B / 2)), B === 0)) break;
                l = B % 2;
              } else if (((w = w.times(_)), H(w, w.e + 1, 1), w.e > 14))
                l = K(w);
              else {
                if (((B = +Y(w)), B === 0)) break;
                l = B % 2;
              }
              (E = E.times(E)),
                U
                  ? E.c && E.c.length > U && (E.c.length = U)
                  : T && (E = E.mod(x));
            }
            return T
              ? p
              : (i && (p = xe.div(p)), x ? p.mod(x) : U ? H(p, Q, fe, f) : p);
          }),
        (C.integerValue = function (w) {
          var x = new y(this);
          return w == null ? (w = fe) : ae(w, 0, 8), H(x, x.e + 1, w);
        }),
        (C.isEqualTo = C.eq =
          function (w, x) {
            return Ee(this, new y(w, x)) === 0;
          }),
        (C.isFinite = function () {
          return !!this.c;
        }),
        (C.isGreaterThan = C.gt =
          function (w, x) {
            return Ee(this, new y(w, x)) > 0;
          }),
        (C.isGreaterThanOrEqualTo = C.gte =
          function (w, x) {
            return (x = Ee(this, new y(w, x))) === 1 || x === 0;
          }),
        (C.isInteger = function () {
          return !!this.c && W(this.e / S) > this.c.length - 2;
        }),
        (C.isLessThan = C.lt =
          function (w, x) {
            return Ee(this, new y(w, x)) < 0;
          }),
        (C.isLessThanOrEqualTo = C.lte =
          function (w, x) {
            return (x = Ee(this, new y(w, x))) === -1 || x === 0;
          }),
        (C.isNaN = function () {
          return !this.s;
        }),
        (C.isNegative = function () {
          return this.s < 0;
        }),
        (C.isPositive = function () {
          return this.s > 0;
        }),
        (C.isZero = function () {
          return !!this.c && this.c[0] == 0;
        }),
        (C.minus = function (w, x) {
          var _,
            T,
            B,
            U,
            f = this,
            n = f.s;
          if (((w = new y(w, x)), (x = w.s), !n || !x)) return new y(NaN);
          if (n != x) return (w.s = -x), f.plus(w);
          var i = f.e / S,
            l = w.e / S,
            p = f.c,
            E = w.c;
          if (!i || !l) {
            if (!p || !E) return p ? ((w.s = -x), w) : new y(E ? f : NaN);
            if (!p[0] || !E[0])
              return E[0]
                ? ((w.s = -x), w)
                : new y(p[0] ? f : fe == 3 ? -0 : 0);
          }
          if (((i = W(i)), (l = W(l)), (p = p.slice()), (n = i - l))) {
            for (
              (U = n < 0) ? ((n = -n), (B = p)) : ((l = i), (B = E)),
                B.reverse(),
                x = n;
              x--;
              B.push(0)
            );
            B.reverse();
          } else
            for (
              T = (U = (n = p.length) < (x = E.length)) ? n : x, n = x = 0;
              x < T;
              x++
            )
              if (p[x] != E[x]) {
                U = p[x] < E[x];
                break;
              }
          if (
            (U && ((B = p), (p = E), (E = B), (w.s = -w.s)),
            (x = (T = E.length) - (_ = p.length)),
            x > 0)
          )
            for (; x--; p[_++] = 0);
          for (x = b - 1; T > n; ) {
            if (p[--T] < E[T]) {
              for (_ = T; _ && !p[--_]; p[_] = x);
              --p[_], (p[T] += b);
            }
            p[T] -= E[T];
          }
          for (; p[0] == 0; p.splice(0, 1), --l);
          return p[0]
            ? Te(w, p, l)
            : ((w.s = fe == 3 ? -1 : 1), (w.c = [(w.e = 0)]), w);
        }),
        (C.modulo = C.mod =
          function (w, x) {
            var _,
              T,
              B = this;
            return (
              (w = new y(w, x)),
              !B.c || !w.s || (w.c && !w.c[0])
                ? new y(NaN)
                : !w.c || (B.c && !B.c[0])
                  ? new y(B)
                  : (j == 9
                      ? ((T = w.s),
                        (w.s = 1),
                        (_ = X(B, w, 0, 3)),
                        (w.s = T),
                        (_.s *= T))
                      : (_ = X(B, w, 0, j)),
                    (w = B.minus(_.times(w))),
                    !w.c[0] && j == 1 && (w.s = B.s),
                    w)
            );
          }),
        (C.multipliedBy = C.times =
          function (w, x) {
            var _,
              T,
              B,
              U,
              f,
              n,
              i,
              l,
              p,
              E,
              F,
              D,
              z,
              V,
              re,
              h = this,
              o = h.c,
              a = (w = new y(w, x)).c;
            if (!o || !a || !o[0] || !a[0])
              return (
                !h.s || !w.s || (o && !o[0] && !a) || (a && !a[0] && !o)
                  ? (w.c = w.e = w.s = null)
                  : ((w.s *= h.s),
                    !o || !a ? (w.c = w.e = null) : ((w.c = [0]), (w.e = 0))),
                w
              );
            for (
              T = W(h.e / S) + W(w.e / S),
                w.s *= h.s,
                i = o.length,
                E = a.length,
                i < E && ((z = o), (o = a), (a = z), (B = i), (i = E), (E = B)),
                B = i + E,
                z = [];
              B--;
              z.push(0)
            );
            for (V = b, re = O, B = E; --B >= 0; ) {
              for (
                _ = 0, F = a[B] % re, D = (a[B] / re) | 0, f = i, U = B + f;
                U > B;

              )
                (l = o[--f] % re),
                  (p = (o[f] / re) | 0),
                  (n = D * l + p * F),
                  (l = F * l + (n % re) * re + z[U] + _),
                  (_ = ((l / V) | 0) + ((n / re) | 0) + D * p),
                  (z[U--] = l % V);
              z[U] = _;
            }
            return _ ? ++T : z.splice(0, 1), Te(w, z, T);
          }),
        (C.negated = function () {
          var w = new y(this);
          return (w.s = -w.s || null), w;
        }),
        (C.plus = function (w, x) {
          var _,
            T = this,
            B = T.s;
          if (((w = new y(w, x)), (x = w.s), !B || !x)) return new y(NaN);
          if (B != x) return (w.s = -x), T.minus(w);
          var U = T.e / S,
            f = w.e / S,
            n = T.c,
            i = w.c;
          if (!U || !f) {
            if (!n || !i) return new y(B / 0);
            if (!n[0] || !i[0]) return i[0] ? w : new y(n[0] ? T : B * 0);
          }
          if (((U = W(U)), (f = W(f)), (n = n.slice()), (B = U - f))) {
            for (
              B > 0 ? ((f = U), (_ = i)) : ((B = -B), (_ = n)), _.reverse();
              B--;
              _.push(0)
            );
            _.reverse();
          }
          for (
            B = n.length,
              x = i.length,
              B - x < 0 && ((_ = i), (i = n), (n = _), (x = B)),
              B = 0;
            x;

          )
            (B = ((n[--x] = n[x] + i[x] + B) / b) | 0),
              (n[x] = b === n[x] ? 0 : n[x] % b);
          return B && ((n = [B].concat(n)), ++f), Te(w, n, f);
        }),
        (C.precision = C.sd =
          function (w, x) {
            var _,
              T,
              B,
              U = this;
            if (w != null && w !== !!w)
              return (
                ae(w, 1, M),
                x == null ? (x = fe) : ae(x, 0, 8),
                H(new y(U), w, x)
              );
            if (!(_ = U.c)) return null;
            if (((B = _.length - 1), (T = B * S + 1), (B = _[B]))) {
              for (; B % 10 == 0; B /= 10, T--);
              for (B = _[0]; B >= 10; B /= 10, T++);
            }
            return w && U.e + 1 > T && (T = U.e + 1), T;
          }),
        (C.shiftedBy = function (w) {
          return ae(w, -9007199254740991, N), this.times("1e" + w);
        }),
        (C.squareRoot = C.sqrt =
          function () {
            var w,
              x,
              _,
              T,
              B,
              U = this,
              f = U.c,
              n = U.s,
              i = U.e,
              l = ce + 4,
              p = new y("0.5");
            if (n !== 1 || !f || !f[0])
              return new y(!n || (n < 0 && (!f || f[0])) ? NaN : f ? U : 1 / 0);
            if (
              ((n = Math.sqrt(+Y(U))),
              n == 0 || n == 1 / 0
                ? ((x = le(f)),
                  (x.length + i) % 2 == 0 && (x += "0"),
                  (n = Math.sqrt(+x)),
                  (i = W((i + 1) / 2) - (i < 0 || i % 2)),
                  n == 1 / 0
                    ? (x = "5e" + i)
                    : ((x = n.toExponential()),
                      (x = x.slice(0, x.indexOf("e") + 1) + i)),
                  (_ = new y(x)))
                : (_ = new y(n + "")),
              _.c[0])
            ) {
              for (i = _.e, n = i + l, n < 3 && (n = 0); ; )
                if (
                  ((B = _),
                  (_ = p.times(B.plus(X(U, B, l, 1)))),
                  le(B.c).slice(0, n) === (x = le(_.c)).slice(0, n))
                )
                  if (
                    (_.e < i && --n,
                    (x = x.slice(n - 3, n + 1)),
                    x == "9999" || (!T && x == "4999"))
                  ) {
                    if (!T && (H(B, B.e + ce + 2, 0), B.times(B).eq(U))) {
                      _ = B;
                      break;
                    }
                    (l += 4), (n += 4), (T = 1);
                  } else {
                    (!+x || (!+x.slice(1) && x.charAt(0) == "5")) &&
                      (H(_, _.e + ce + 2, 1), (w = !_.times(_).eq(U)));
                    break;
                  }
            }
            return H(_, _.e + ce + 1, fe, w);
          }),
        (C.toExponential = function (w, x) {
          return w != null && (ae(w, 0, M), w++), de(this, w, x, 1);
        }),
        (C.toFixed = function (w, x) {
          return (
            w != null && (ae(w, 0, M), (w = w + this.e + 1)), de(this, w, x)
          );
        }),
        (C.toFormat = function (w, x, _) {
          var T,
            B = this;
          if (_ == null)
            w != null && x && typeof x == "object"
              ? ((_ = x), (x = null))
              : w && typeof w == "object"
                ? ((_ = w), (w = x = null))
                : (_ = G);
          else if (typeof _ != "object")
            throw Error(g + "Argument not an object: " + _);
          if (((T = B.toFixed(w, x)), B.c)) {
            var U,
              f = T.split("."),
              n = +_.groupSize,
              i = +_.secondaryGroupSize,
              l = _.groupSeparator || "",
              p = f[0],
              E = f[1],
              F = B.s < 0,
              D = F ? p.slice(1) : p,
              z = D.length;
            if ((i && ((U = n), (n = i), (i = U), (z -= U)), n > 0 && z > 0)) {
              for (U = z % n || n, p = D.substr(0, U); U < z; U += n)
                p += l + D.substr(U, n);
              i > 0 && (p += l + D.slice(U)), F && (p = "-" + p);
            }
            T = E
              ? p +
                (_.decimalSeparator || "") +
                ((i = +_.fractionGroupSize)
                  ? E.replace(
                      new RegExp("\\d{" + i + "}\\B", "g"),
                      "$&" + (_.fractionGroupSeparator || ""),
                    )
                  : E)
              : p;
          }
          return (_.prefix || "") + T + (_.suffix || "");
        }),
        (C.toFraction = function (w) {
          var x,
            _,
            T,
            B,
            U,
            f,
            n,
            i,
            l,
            p,
            E,
            F,
            D = this,
            z = D.c;
          if (
            w != null &&
            ((n = new y(w)), (!n.isInteger() && (n.c || n.s !== 1)) || n.lt(xe))
          )
            throw Error(
              g +
                "Argument " +
                (n.isInteger() ? "out of range: " : "not an integer: ") +
                Y(n),
            );
          if (!z) return new y(D);
          for (
            x = new y(xe),
              l = _ = new y(xe),
              T = i = new y(xe),
              F = le(z),
              U = x.e = F.length - D.e - 1,
              x.c[0] = L[(f = U % S) < 0 ? S + f : f],
              w = !w || n.comparedTo(x) > 0 ? (U > 0 ? x : l) : n,
              f = P,
              P = 1 / 0,
              n = new y(F),
              i.c[0] = 0;
            (p = X(n, x, 0, 1)), (B = _.plus(p.times(T))), B.comparedTo(w) != 1;

          )
            (_ = T),
              (T = B),
              (l = i.plus(p.times((B = l)))),
              (i = B),
              (x = n.minus(p.times((B = x)))),
              (n = B);
          return (
            (B = X(w.minus(_), T, 0, 1)),
            (i = i.plus(B.times(l))),
            (_ = _.plus(B.times(T))),
            (i.s = l.s = D.s),
            (U = U * 2),
            (E =
              X(l, T, U, fe)
                .minus(D)
                .abs()
                .comparedTo(X(i, _, U, fe).minus(D).abs()) < 1
                ? [l, T]
                : [i, _]),
            (P = f),
            E
          );
        }),
        (C.toNumber = function () {
          return +Y(this);
        }),
        (C.toPrecision = function (w, x) {
          return w != null && ae(w, 1, M), de(this, w, x, 2);
        }),
        (C.toString = function (w) {
          var x,
            _ = this,
            T = _.s,
            B = _.e;
          return (
            B === null
              ? T
                ? ((x = "Infinity"), T < 0 && (x = "-" + x))
                : (x = "NaN")
              : (w == null
                  ? (x =
                      B <= Se || B >= _e ? Ue(le(_.c), B) : ue(le(_.c), B, "0"))
                  : w === 10 && ye
                    ? ((_ = H(new y(_), ce + B + 1, fe)),
                      (x = ue(le(_.c), _.e, "0")))
                    : (ae(w, 2, $.length, "Base"),
                      (x = ne(ue(le(_.c), B, "0"), 10, w, T, !0))),
                T < 0 && _.c[0] && (x = "-" + x)),
            x
          );
        }),
        (C.valueOf = C.toJSON =
          function () {
            return Y(this);
          }),
        (C._isBigNumber = !0),
        J != null && y.set(J),
        y
      );
    }
    function W(J) {
      var X = J | 0;
      return J > 0 || J === X ? X : X - 1;
    }
    function le(J) {
      for (var X, ne, ie = 1, C = J.length, xe = J[0] + ""; ie < C; ) {
        for (X = J[ie++] + "", ne = S - X.length; ne--; X = "0" + X);
        xe += X;
      }
      for (C = xe.length; xe.charCodeAt(--C) === 48; );
      return xe.slice(0, C + 1 || 1);
    }
    function Ee(J, X) {
      var ne,
        ie,
        C = J.c,
        xe = X.c,
        ce = J.s,
        fe = X.s,
        Se = J.e,
        _e = X.e;
      if (!ce || !fe) return null;
      if (((ne = C && !C[0]), (ie = xe && !xe[0]), ne || ie))
        return ne ? (ie ? 0 : -fe) : ce;
      if (ce != fe) return ce;
      if (((ne = ce < 0), (ie = Se == _e), !C || !xe))
        return ie ? 0 : !C ^ ne ? 1 : -1;
      if (!ie) return (Se > _e) ^ ne ? 1 : -1;
      for (
        fe = (Se = C.length) < (_e = xe.length) ? Se : _e, ce = 0;
        ce < fe;
        ce++
      )
        if (C[ce] != xe[ce]) return (C[ce] > xe[ce]) ^ ne ? 1 : -1;
      return Se == _e ? 0 : (Se > _e) ^ ne ? 1 : -1;
    }
    function ae(J, X, ne, ie) {
      if (J < X || J > ne || J !== d(J))
        throw Error(
          g +
            (ie || "Argument") +
            (typeof J == "number"
              ? J < X || J > ne
                ? " out of range: "
                : " not an integer: "
              : " not a primitive number: ") +
            String(J),
        );
    }
    function K(J) {
      var X = J.c.length - 1;
      return W(J.e / S) == X && J.c[X] % 2 != 0;
    }
    function Ue(J, X) {
      return (
        (J.length > 1 ? J.charAt(0) + "." + J.slice(1) : J) +
        (X < 0 ? "e" : "e+") +
        X
      );
    }
    function ue(J, X, ne) {
      var ie, C;
      if (X < 0) {
        for (C = ne + "."; ++X; C += ne);
        J = C + J;
      } else if (((ie = J.length), ++X > ie)) {
        for (C = ne, X -= ie; --X; C += ne);
        J += C;
      } else X < ie && (J = J.slice(0, X) + "." + J.slice(X));
      return J;
    }
    (r = q()),
      (r.default = r.BigNumber = r),
      t.exports
        ? (t.exports = r)
        : (e || (e = typeof self < "u" && self ? self : window),
          (e.BigNumber = r));
  })(Et);
})(ci);
var ir = ci.exports,
  Zs = function (e, r, s) {
    var u = new e.Uint8Array(s),
      d = r.pushInt,
      g = r.pushInt32,
      c = r.pushInt32Neg,
      b = r.pushInt64,
      S = r.pushInt64Neg,
      N = r.pushFloat,
      L = r.pushFloatSingle,
      O = r.pushFloatDouble,
      M = r.pushTrue,
      q = r.pushFalse,
      W = r.pushUndefined,
      le = r.pushNull,
      Ee = r.pushInfinity,
      ae = r.pushInfinityNeg,
      K = r.pushNaN,
      Ue = r.pushNaNNeg,
      ue = r.pushArrayStart,
      J = r.pushArrayStartFixed,
      X = r.pushArrayStartFixed32,
      ne = r.pushArrayStartFixed64,
      ie = r.pushObjectStart,
      C = r.pushObjectStartFixed,
      xe = r.pushObjectStartFixed32,
      ce = r.pushObjectStartFixed64,
      fe = r.pushByteString,
      Se = r.pushByteStringStart,
      _e = r.pushUtf8String,
      Z = r.pushUtf8StringStart,
      P = r.pushSimpleUnassigned,
      k = r.pushTagStart,
      j = r.pushTagStart4,
      Q = r.pushTagStart8,
      G = r.pushTagUnassigned,
      $ = r.pushBreak,
      ye = e.Math.pow,
      y = 0,
      de = 0,
      me = 0;
    function Te(I) {
      for (
        I = I | 0, y = 0, de = I;
        (y | 0) < (de | 0) &&
        ((me = ps[u[y] & 255](u[y] | 0) | 0), !((me | 0) > 0));

      );
      return me | 0;
    }
    function H(I) {
      return (I = I | 0), (((y | 0) + (I | 0)) | 0) < (de | 0) ? 0 : 1;
    }
    function Y(I) {
      return (I = I | 0), (u[I | 0] << 8) | u[(I + 1) | 0] | 0;
    }
    function w(I) {
      return (
        (I = I | 0),
        (u[I | 0] << 24) |
          (u[(I + 1) | 0] << 16) |
          (u[(I + 2) | 0] << 8) |
          u[(I + 3) | 0] |
          0
      );
    }
    function x(I) {
      return (I = I | 0), d(I | 0), (y = (y + 1) | 0), 0;
    }
    function _(I) {
      return (
        (I = I | 0),
        H(1) | 0 ? 1 : (d(u[(y + 1) | 0] | 0), (y = (y + 2) | 0), 0)
      );
    }
    function T(I) {
      return (
        (I = I | 0),
        H(2) | 0 ? 1 : (d(Y((y + 1) | 0) | 0), (y = (y + 3) | 0), 0)
      );
    }
    function B(I) {
      return (
        (I = I | 0),
        H(4) | 0
          ? 1
          : (g(Y((y + 1) | 0) | 0, Y((y + 3) | 0) | 0), (y = (y + 5) | 0), 0)
      );
    }
    function U(I) {
      return (
        (I = I | 0),
        H(8) | 0
          ? 1
          : (b(
              Y((y + 1) | 0) | 0,
              Y((y + 3) | 0) | 0,
              Y((y + 5) | 0) | 0,
              Y((y + 7) | 0) | 0,
            ),
            (y = (y + 9) | 0),
            0)
      );
    }
    function f(I) {
      return (I = I | 0), d((-1 - ((I - 32) | 0)) | 0), (y = (y + 1) | 0), 0;
    }
    function n(I) {
      return (
        (I = I | 0),
        H(1) | 0
          ? 1
          : (d((-1 - (u[(y + 1) | 0] | 0)) | 0), (y = (y + 2) | 0), 0)
      );
    }
    function i(I) {
      I = I | 0;
      var we = 0;
      return H(2) | 0
        ? 1
        : ((we = Y((y + 1) | 0) | 0),
          d((-1 - (we | 0)) | 0),
          (y = (y + 3) | 0),
          0);
    }
    function l(I) {
      return (
        (I = I | 0),
        H(4) | 0
          ? 1
          : (c(Y((y + 1) | 0) | 0, Y((y + 3) | 0) | 0), (y = (y + 5) | 0), 0)
      );
    }
    function p(I) {
      return (
        (I = I | 0),
        H(8) | 0
          ? 1
          : (S(
              Y((y + 1) | 0) | 0,
              Y((y + 3) | 0) | 0,
              Y((y + 5) | 0) | 0,
              Y((y + 7) | 0) | 0,
            ),
            (y = (y + 9) | 0),
            0)
      );
    }
    function E(I) {
      I = I | 0;
      var we = 0,
        ge = 0,
        pe = 0;
      return (
        (pe = (I - 64) | 0),
        H(pe | 0) | 0
          ? 1
          : ((we = (y + 1) | 0),
            (ge = (((y + 1) | 0) + (pe | 0)) | 0),
            fe(we | 0, ge | 0),
            (y = ge | 0),
            0)
      );
    }
    function F(I) {
      I = I | 0;
      var we = 0,
        ge = 0,
        pe = 0;
      return H(1) | 0 ||
        ((pe = u[(y + 1) | 0] | 0),
        (we = (y + 2) | 0),
        (ge = (((y + 2) | 0) + (pe | 0)) | 0),
        H((pe + 1) | 0) | 0)
        ? 1
        : (fe(we | 0, ge | 0), (y = ge | 0), 0);
    }
    function D(I) {
      I = I | 0;
      var we = 0,
        ge = 0,
        pe = 0;
      return H(2) | 0 ||
        ((pe = Y((y + 1) | 0) | 0),
        (we = (y + 3) | 0),
        (ge = (((y + 3) | 0) + (pe | 0)) | 0),
        H((pe + 2) | 0) | 0)
        ? 1
        : (fe(we | 0, ge | 0), (y = ge | 0), 0);
    }
    function z(I) {
      I = I | 0;
      var we = 0,
        ge = 0,
        pe = 0;
      return H(4) | 0 ||
        ((pe = w((y + 1) | 0) | 0),
        (we = (y + 5) | 0),
        (ge = (((y + 5) | 0) + (pe | 0)) | 0),
        H((pe + 4) | 0) | 0)
        ? 1
        : (fe(we | 0, ge | 0), (y = ge | 0), 0);
    }
    function V(I) {
      return (I = I | 0), 1;
    }
    function re(I) {
      return (I = I | 0), Se(), (y = (y + 1) | 0), 0;
    }
    function h(I) {
      I = I | 0;
      var we = 0,
        ge = 0,
        pe = 0;
      return (
        (pe = (I - 96) | 0),
        H(pe | 0) | 0
          ? 1
          : ((we = (y + 1) | 0),
            (ge = (((y + 1) | 0) + (pe | 0)) | 0),
            _e(we | 0, ge | 0),
            (y = ge | 0),
            0)
      );
    }
    function o(I) {
      I = I | 0;
      var we = 0,
        ge = 0,
        pe = 0;
      return H(1) | 0 ||
        ((pe = u[(y + 1) | 0] | 0),
        (we = (y + 2) | 0),
        (ge = (((y + 2) | 0) + (pe | 0)) | 0),
        H((pe + 1) | 0) | 0)
        ? 1
        : (_e(we | 0, ge | 0), (y = ge | 0), 0);
    }
    function a(I) {
      I = I | 0;
      var we = 0,
        ge = 0,
        pe = 0;
      return H(2) | 0 ||
        ((pe = Y((y + 1) | 0) | 0),
        (we = (y + 3) | 0),
        (ge = (((y + 3) | 0) + (pe | 0)) | 0),
        H((pe + 2) | 0) | 0)
        ? 1
        : (_e(we | 0, ge | 0), (y = ge | 0), 0);
    }
    function m(I) {
      I = I | 0;
      var we = 0,
        ge = 0,
        pe = 0;
      return H(4) | 0 ||
        ((pe = w((y + 1) | 0) | 0),
        (we = (y + 5) | 0),
        (ge = (((y + 5) | 0) + (pe | 0)) | 0),
        H((pe + 4) | 0) | 0)
        ? 1
        : (_e(we | 0, ge | 0), (y = ge | 0), 0);
    }
    function A(I) {
      return (I = I | 0), 1;
    }
    function R(I) {
      return (I = I | 0), Z(), (y = (y + 1) | 0), 0;
    }
    function v(I) {
      return (I = I | 0), J((I - 128) | 0), (y = (y + 1) | 0), 0;
    }
    function te(I) {
      return (
        (I = I | 0),
        H(1) | 0 ? 1 : (J(u[(y + 1) | 0] | 0), (y = (y + 2) | 0), 0)
      );
    }
    function he(I) {
      return (
        (I = I | 0),
        H(2) | 0 ? 1 : (J(Y((y + 1) | 0) | 0), (y = (y + 3) | 0), 0)
      );
    }
    function se(I) {
      return (
        (I = I | 0),
        H(4) | 0
          ? 1
          : (X(Y((y + 1) | 0) | 0, Y((y + 3) | 0) | 0), (y = (y + 5) | 0), 0)
      );
    }
    function ee(I) {
      return (
        (I = I | 0),
        H(8) | 0
          ? 1
          : (ne(
              Y((y + 1) | 0) | 0,
              Y((y + 3) | 0) | 0,
              Y((y + 5) | 0) | 0,
              Y((y + 7) | 0) | 0,
            ),
            (y = (y + 9) | 0),
            0)
      );
    }
    function be(I) {
      return (I = I | 0), ue(), (y = (y + 1) | 0), 0;
    }
    function Ne(I) {
      I = I | 0;
      var we = 0;
      return (
        (we = (I - 160) | 0),
        H(we | 0) | 0 ? 1 : (C(we | 0), (y = (y + 1) | 0), 0)
      );
    }
    function Xi(I) {
      return (
        (I = I | 0),
        H(1) | 0 ? 1 : (C(u[(y + 1) | 0] | 0), (y = (y + 2) | 0), 0)
      );
    }
    function ji(I) {
      return (
        (I = I | 0),
        H(2) | 0 ? 1 : (C(Y((y + 1) | 0) | 0), (y = (y + 3) | 0), 0)
      );
    }
    function Zi(I) {
      return (
        (I = I | 0),
        H(4) | 0
          ? 1
          : (xe(Y((y + 1) | 0) | 0, Y((y + 3) | 0) | 0), (y = (y + 5) | 0), 0)
      );
    }
    function Qi(I) {
      return (
        (I = I | 0),
        H(8) | 0
          ? 1
          : (ce(
              Y((y + 1) | 0) | 0,
              Y((y + 3) | 0) | 0,
              Y((y + 5) | 0) | 0,
              Y((y + 7) | 0) | 0,
            ),
            (y = (y + 9) | 0),
            0)
      );
    }
    function es(I) {
      return (I = I | 0), ie(), (y = (y + 1) | 0), 0;
    }
    function dt(I) {
      return (I = I | 0), k((I - 192) | 0 | 0), (y = (y + 1) | 0), 0;
    }
    function Gu(I) {
      return (I = I | 0), k(I | 0), (y = (y + 1) | 0), 0;
    }
    function Hu(I) {
      return (I = I | 0), k(I | 0), (y = (y + 1) | 0), 0;
    }
    function $u(I) {
      return (I = I | 0), k(I | 0), (y = (y + 1) | 0), 0;
    }
    function zu(I) {
      return (I = I | 0), k(I | 0), (y = (y + 1) | 0), 0;
    }
    function Oe(I) {
      return (I = I | 0), k((I - 192) | 0 | 0), (y = (y + 1) | 0), 0;
    }
    function Ku(I) {
      return (I = I | 0), k(I | 0), (y = (y + 1) | 0), 0;
    }
    function Yu(I) {
      return (I = I | 0), k(I | 0), (y = (y + 1) | 0), 0;
    }
    function Wu(I) {
      return (I = I | 0), k(I | 0), (y = (y + 1) | 0), 0;
    }
    function ts(I) {
      return (
        (I = I | 0),
        H(1) | 0 ? 1 : (k(u[(y + 1) | 0] | 0), (y = (y + 2) | 0), 0)
      );
    }
    function rs(I) {
      return (
        (I = I | 0),
        H(2) | 0 ? 1 : (k(Y((y + 1) | 0) | 0), (y = (y + 3) | 0), 0)
      );
    }
    function ns(I) {
      return (
        (I = I | 0),
        H(4) | 0
          ? 1
          : (j(Y((y + 1) | 0) | 0, Y((y + 3) | 0) | 0), (y = (y + 5) | 0), 0)
      );
    }
    function is(I) {
      return (
        (I = I | 0),
        H(8) | 0
          ? 1
          : (Q(
              Y((y + 1) | 0) | 0,
              Y((y + 3) | 0) | 0,
              Y((y + 5) | 0) | 0,
              Y((y + 7) | 0) | 0,
            ),
            (y = (y + 9) | 0),
            0)
      );
    }
    function ve(I) {
      return (I = I | 0), P(((I | 0) - 224) | 0), (y = (y + 1) | 0), 0;
    }
    function ss(I) {
      return (I = I | 0), q(), (y = (y + 1) | 0), 0;
    }
    function os(I) {
      return (I = I | 0), M(), (y = (y + 1) | 0), 0;
    }
    function as(I) {
      return (I = I | 0), le(), (y = (y + 1) | 0), 0;
    }
    function us(I) {
      return (I = I | 0), W(), (y = (y + 1) | 0), 0;
    }
    function cs(I) {
      return (
        (I = I | 0),
        H(1) | 0 ? 1 : (P(u[(y + 1) | 0] | 0), (y = (y + 2) | 0), 0)
      );
    }
    function fs(I) {
      I = I | 0;
      var we = 0,
        ge = 0,
        pe = 1,
        Mt = 0,
        At = 0,
        Vu = 0;
      return H(2) | 0
        ? 1
        : ((we = u[(y + 1) | 0] | 0),
          (ge = u[(y + 2) | 0] | 0),
          (we | 0) & 128 && (pe = -1),
          (Mt = +(((we | 0) & 124) >> 2)),
          (At = +((((we | 0) & 3) << 8) | ge)),
          +Mt == 0
            ? N(+(+pe * 5960464477539063e-23 * +At))
            : +Mt == 31
              ? +pe == 1
                ? +At > 0
                  ? K()
                  : Ee()
                : +At > 0
                  ? Ue()
                  : ae()
              : N(+(+pe * ye(2, +(+Mt - 25)) * +(1024 + At))),
          (y = (y + 3) | 0),
          0);
    }
    function hs(I) {
      return (
        (I = I | 0),
        H(4) | 0
          ? 1
          : (L(
              u[(y + 1) | 0] | 0,
              u[(y + 2) | 0] | 0,
              u[(y + 3) | 0] | 0,
              u[(y + 4) | 0] | 0,
            ),
            (y = (y + 5) | 0),
            0)
      );
    }
    function ls(I) {
      return (
        (I = I | 0),
        H(8) | 0
          ? 1
          : (O(
              u[(y + 1) | 0] | 0,
              u[(y + 2) | 0] | 0,
              u[(y + 3) | 0] | 0,
              u[(y + 4) | 0] | 0,
              u[(y + 5) | 0] | 0,
              u[(y + 6) | 0] | 0,
              u[(y + 7) | 0] | 0,
              u[(y + 8) | 0] | 0,
            ),
            (y = (y + 9) | 0),
            0)
      );
    }
    function Ae(I) {
      return (I = I | 0), 1;
    }
    function ds(I) {
      return (I = I | 0), $(), (y = (y + 1) | 0), 0;
    }
    var ps = [
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      x,
      _,
      T,
      B,
      U,
      Ae,
      Ae,
      Ae,
      Ae,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      f,
      n,
      i,
      l,
      p,
      Ae,
      Ae,
      Ae,
      Ae,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      E,
      F,
      D,
      z,
      V,
      Ae,
      Ae,
      Ae,
      re,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      h,
      o,
      a,
      m,
      A,
      Ae,
      Ae,
      Ae,
      R,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      v,
      te,
      he,
      se,
      ee,
      Ae,
      Ae,
      Ae,
      be,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Ne,
      Xi,
      ji,
      Zi,
      Qi,
      Ae,
      Ae,
      Ae,
      es,
      dt,
      dt,
      dt,
      dt,
      dt,
      dt,
      Oe,
      Oe,
      Oe,
      Oe,
      Oe,
      Oe,
      Oe,
      Oe,
      Oe,
      Oe,
      Oe,
      Oe,
      Oe,
      Oe,
      Oe,
      Oe,
      Oe,
      Oe,
      ts,
      rs,
      ns,
      is,
      Ae,
      Ae,
      Ae,
      Ae,
      ve,
      ve,
      ve,
      ve,
      ve,
      ve,
      ve,
      ve,
      ve,
      ve,
      ve,
      ve,
      ve,
      ve,
      ve,
      ve,
      ve,
      ve,
      ve,
      ve,
      ss,
      os,
      as,
      us,
      cs,
      fs,
      hs,
      ls,
      Ae,
      Ae,
      Ae,
      ds,
    ];
    return { parse: Te };
  },
  sr = {},
  Me = {};
const Kr = ir.BigNumber;
Me.MT = {
  POS_INT: 0,
  NEG_INT: 1,
  BYTE_STRING: 2,
  UTF8_STRING: 3,
  ARRAY: 4,
  MAP: 5,
  TAG: 6,
  SIMPLE_FLOAT: 7,
};
Me.TAG = {
  DATE_STRING: 0,
  DATE_EPOCH: 1,
  POS_BIGINT: 2,
  NEG_BIGINT: 3,
  DECIMAL_FRAC: 4,
  BIGFLOAT: 5,
  BASE64URL_EXPECTED: 21,
  BASE64_EXPECTED: 22,
  BASE16_EXPECTED: 23,
  CBOR: 24,
  URI: 32,
  BASE64URL: 33,
  BASE64: 34,
  REGEXP: 35,
  MIME: 36,
};
Me.NUMBYTES = {
  ZERO: 0,
  ONE: 24,
  TWO: 25,
  FOUR: 26,
  EIGHT: 27,
  INDEFINITE: 31,
};
Me.SIMPLE = { FALSE: 20, TRUE: 21, NULL: 22, UNDEFINED: 23 };
Me.SYMS = {
  NULL: Symbol("null"),
  UNDEFINED: Symbol("undef"),
  PARENT: Symbol("parent"),
  BREAK: Symbol("break"),
  STREAM: Symbol("stream"),
};
Me.SHIFT32 = Math.pow(2, 32);
Me.SHIFT16 = Math.pow(2, 16);
Me.MAX_SAFE_HIGH = 2097151;
Me.NEG_ONE = new Kr(-1);
Me.TEN = new Kr(10);
Me.TWO = new Kr(2);
Me.PARENT = {
  ARRAY: 0,
  OBJECT: 1,
  MAP: 2,
  TAG: 3,
  BYTE_STRING: 4,
  UTF8_STRING: 5,
};
(function (t) {
  const { Buffer: e } = Ot,
    r = ir.BigNumber,
    s = Me,
    u = s.SHIFT32,
    d = s.SHIFT16,
    g = 2097151;
  t.parseHalf = function (S) {
    var N, L, O;
    return (
      (O = S[0] & 128 ? -1 : 1),
      (N = (S[0] & 124) >> 2),
      (L = ((S[0] & 3) << 8) | S[1]),
      N
        ? N === 31
          ? O * (L ? NaN : 1 / 0)
          : O * Math.pow(2, N - 25) * (1024 + L)
        : O * 5960464477539063e-23 * L
    );
  };
  function c(b) {
    return b < 16 ? "0" + b.toString(16) : b.toString(16);
  }
  (t.arrayBufferToBignumber = function (b) {
    const S = b.byteLength;
    let N = "";
    for (let L = 0; L < S; L++) N += c(b[L]);
    return new r(N, 16);
  }),
    (t.buildMap = (b) => {
      const S = new Map(),
        N = Object.keys(b),
        L = N.length;
      for (let O = 0; O < L; O++) S.set(N[O], b[N[O]]);
      return S;
    }),
    (t.buildInt32 = (b, S) => b * d + S),
    (t.buildInt64 = (b, S, N, L) => {
      const O = t.buildInt32(b, S),
        M = t.buildInt32(N, L);
      return O > g ? new r(O).times(u).plus(M) : O * u + M;
    }),
    (t.writeHalf = function (S, N) {
      const L = e.allocUnsafe(4);
      L.writeFloatBE(N, 0);
      const O = L.readUInt32BE(0);
      if (O & 8191) return !1;
      var M = (O >> 16) & 32768;
      const q = (O >> 23) & 255,
        W = O & 8388607;
      if (q >= 113 && q <= 142) M += ((q - 112) << 10) + (W >> 13);
      else if (q >= 103 && q < 113) {
        if (W & ((1 << (126 - q)) - 1)) return !1;
        M += (W + 8388608) >> (126 - q);
      } else return !1;
      return S.writeUInt16BE(M, 0), !0;
    }),
    (t.keySorter = function (b, S) {
      var N = b[0].byteLength,
        L = S[0].byteLength;
      return N > L ? 1 : L > N ? -1 : b[0].compare(S[0]);
    }),
    (t.isNegativeZero = (b) => b === 0 && 1 / b < 0),
    (t.nextPowerOf2 = (b) => {
      let S = 0;
      if (b && !(b & (b - 1))) return b;
      for (; b !== 0; ) (b >>= 1), (S += 1);
      return 1 << S;
    });
})(sr);
const Yr = Me,
  Qs = Yr.MT,
  Ct = Yr.SIMPLE,
  fr = Yr.SYMS;
let eo = class Ur {
  constructor(e) {
    if (typeof e != "number")
      throw new Error("Invalid Simple type: " + typeof e);
    if (e < 0 || e > 255 || (e | 0) !== e)
      throw new Error("value must be a small positive integer: " + e);
    this.value = e;
  }
  toString() {
    return "simple(" + this.value + ")";
  }
  inspect() {
    return "simple(" + this.value + ")";
  }
  encodeCBOR(e) {
    return e._pushInt(this.value, Qs.SIMPLE_FLOAT);
  }
  static isSimple(e) {
    return e instanceof Ur;
  }
  static decode(e, r) {
    switch ((r == null && (r = !0), e)) {
      case Ct.FALSE:
        return !1;
      case Ct.TRUE:
        return !0;
      case Ct.NULL:
        return r ? null : fr.NULL;
      case Ct.UNDEFINED:
        return r ? void 0 : fr.UNDEFINED;
      case -1:
        if (!r) throw new Error("Invalid BREAK");
        return fr.BREAK;
      default:
        return new Ur(e);
    }
  }
};
var fi = eo;
let to = class Nr {
  constructor(e, r, s) {
    if (
      ((this.tag = e),
      (this.value = r),
      (this.err = s),
      typeof this.tag != "number")
    )
      throw new Error("Invalid tag type (" + typeof this.tag + ")");
    if (this.tag < 0 || (this.tag | 0) !== this.tag)
      throw new Error("Tag must be a positive integer: " + this.tag);
  }
  toString() {
    return `${this.tag}(${JSON.stringify(this.value)})`;
  }
  encodeCBOR(e) {
    return e._pushTag(this.tag), e.pushAny(this.value);
  }
  convert(e) {
    var r, s;
    if (
      ((s = e?.[this.tag]),
      typeof s != "function" &&
        ((s = Nr["_tag" + this.tag]), typeof s != "function"))
    )
      return this;
    try {
      return s.call(Nr, this.value);
    } catch (u) {
      return (r = u), (this.err = r), this;
    }
  }
};
var hi = to;
const li = self.location
    ? self.location.protocol + "//" + self.location.host
    : "",
  Fr = self.URL;
let ro = class {
  constructor(e = "", r = li) {
    (this.super = new Fr(e, r)),
      (this.path = this.pathname + this.search),
      (this.auth =
        this.username && this.password
          ? this.username + ":" + this.password
          : null),
      (this.query =
        this.search && this.search.startsWith("?")
          ? this.search.slice(1)
          : null);
  }
  get hash() {
    return this.super.hash;
  }
  get host() {
    return this.super.host;
  }
  get hostname() {
    return this.super.hostname;
  }
  get href() {
    return this.super.href;
  }
  get origin() {
    return this.super.origin;
  }
  get password() {
    return this.super.password;
  }
  get pathname() {
    return this.super.pathname;
  }
  get port() {
    return this.super.port;
  }
  get protocol() {
    return this.super.protocol;
  }
  get search() {
    return this.super.search;
  }
  get searchParams() {
    return this.super.searchParams;
  }
  get username() {
    return this.super.username;
  }
  set hash(e) {
    this.super.hash = e;
  }
  set host(e) {
    this.super.host = e;
  }
  set hostname(e) {
    this.super.hostname = e;
  }
  set href(e) {
    this.super.href = e;
  }
  set origin(e) {
    this.super.origin = e;
  }
  set password(e) {
    this.super.password = e;
  }
  set pathname(e) {
    this.super.pathname = e;
  }
  set port(e) {
    this.super.port = e;
  }
  set protocol(e) {
    this.super.protocol = e;
  }
  set search(e) {
    this.super.search = e;
  }
  set searchParams(e) {
    this.super.searchParams = e;
  }
  set username(e) {
    this.super.username = e;
  }
  createObjectURL(e) {
    return this.super.createObjectURL(e);
  }
  revokeObjectURL(e) {
    this.super.revokeObjectURL(e);
  }
  toJSON() {
    return this.super.toJSON();
  }
  toString() {
    return this.super.toString();
  }
  format() {
    return this.toString();
  }
};
function no(t) {
  if (typeof t == "string") return new Fr(t).toString();
  if (!(t instanceof Fr)) {
    const e = t.username && t.password ? `${t.username}:${t.password}@` : "",
      r = t.auth ? t.auth + "@" : "",
      s = t.port ? ":" + t.port : "",
      u = t.protocol ? t.protocol + "//" : "",
      d = t.host || "",
      g = t.hostname || "",
      c = t.search || (t.query ? "?" + t.query : ""),
      b = t.hash || "",
      S = t.pathname || "",
      N = t.path || S + c;
    return `${u}${e || r}${d || g + s}${N}${b}`;
  }
}
var di = {
  URLWithLegacySupport: ro,
  URLSearchParams: self.URLSearchParams,
  defaultBase: li,
  format: no,
};
const { URLWithLegacySupport: Xu, format: ju } = di,
  {
    URLWithLegacySupport: io,
    format: Zu,
    URLSearchParams: Qu,
    defaultBase: e0,
  } = di;
var pi = { URL: io };
const { Buffer: yt } = Ot,
  wn = Rt,
  so = ir.BigNumber,
  oo = Zs,
  Pe = sr,
  Ie = Me,
  ao = fi,
  uo = hi,
  { URL: co } = pi;
let vr = class Rr {
  constructor(e) {
    (e = e || {}),
      !e.size || e.size < 65536
        ? (e.size = 65536)
        : (e.size = Pe.nextPowerOf2(e.size)),
      (this._heap = new ArrayBuffer(e.size)),
      (this._heap8 = new Uint8Array(this._heap)),
      (this._buffer = yt.from(this._heap)),
      this._reset(),
      (this._knownTags = Object.assign(
        {
          0: (r) => new Date(r),
          1: (r) => new Date(r * 1e3),
          2: (r) => Pe.arrayBufferToBignumber(r),
          3: (r) => Ie.NEG_ONE.minus(Pe.arrayBufferToBignumber(r)),
          4: (r) => Ie.TEN.pow(r[0]).times(r[1]),
          5: (r) => Ie.TWO.pow(r[0]).times(r[1]),
          32: (r) => new co(r),
          35: (r) => new RegExp(r),
        },
        e.tags,
      )),
      (this.parser = oo(
        Et,
        {
          log: console.log.bind(console),
          pushInt: this.pushInt.bind(this),
          pushInt32: this.pushInt32.bind(this),
          pushInt32Neg: this.pushInt32Neg.bind(this),
          pushInt64: this.pushInt64.bind(this),
          pushInt64Neg: this.pushInt64Neg.bind(this),
          pushFloat: this.pushFloat.bind(this),
          pushFloatSingle: this.pushFloatSingle.bind(this),
          pushFloatDouble: this.pushFloatDouble.bind(this),
          pushTrue: this.pushTrue.bind(this),
          pushFalse: this.pushFalse.bind(this),
          pushUndefined: this.pushUndefined.bind(this),
          pushNull: this.pushNull.bind(this),
          pushInfinity: this.pushInfinity.bind(this),
          pushInfinityNeg: this.pushInfinityNeg.bind(this),
          pushNaN: this.pushNaN.bind(this),
          pushNaNNeg: this.pushNaNNeg.bind(this),
          pushArrayStart: this.pushArrayStart.bind(this),
          pushArrayStartFixed: this.pushArrayStartFixed.bind(this),
          pushArrayStartFixed32: this.pushArrayStartFixed32.bind(this),
          pushArrayStartFixed64: this.pushArrayStartFixed64.bind(this),
          pushObjectStart: this.pushObjectStart.bind(this),
          pushObjectStartFixed: this.pushObjectStartFixed.bind(this),
          pushObjectStartFixed32: this.pushObjectStartFixed32.bind(this),
          pushObjectStartFixed64: this.pushObjectStartFixed64.bind(this),
          pushByteString: this.pushByteString.bind(this),
          pushByteStringStart: this.pushByteStringStart.bind(this),
          pushUtf8String: this.pushUtf8String.bind(this),
          pushUtf8StringStart: this.pushUtf8StringStart.bind(this),
          pushSimpleUnassigned: this.pushSimpleUnassigned.bind(this),
          pushTagUnassigned: this.pushTagUnassigned.bind(this),
          pushTagStart: this.pushTagStart.bind(this),
          pushTagStart4: this.pushTagStart4.bind(this),
          pushTagStart8: this.pushTagStart8.bind(this),
          pushBreak: this.pushBreak.bind(this),
        },
        this._heap,
      ));
  }
  get _depth() {
    return this._parents.length;
  }
  get _currentParent() {
    return this._parents[this._depth - 1];
  }
  get _ref() {
    return this._currentParent.ref;
  }
  _closeParent() {
    var e = this._parents.pop();
    if (e.length > 0) throw new Error(`Missing ${e.length} elements`);
    switch (e.type) {
      case Ie.PARENT.TAG:
        this._push(this.createTag(e.ref[0], e.ref[1]));
        break;
      case Ie.PARENT.BYTE_STRING:
        this._push(this.createByteString(e.ref, e.length));
        break;
      case Ie.PARENT.UTF8_STRING:
        this._push(this.createUtf8String(e.ref, e.length));
        break;
      case Ie.PARENT.MAP:
        if (e.values % 2 > 0)
          throw new Error("Odd number of elements in the map");
        this._push(this.createMap(e.ref, e.length));
        break;
      case Ie.PARENT.OBJECT:
        if (e.values % 2 > 0)
          throw new Error("Odd number of elements in the map");
        this._push(this.createObject(e.ref, e.length));
        break;
      case Ie.PARENT.ARRAY:
        this._push(this.createArray(e.ref, e.length));
        break;
    }
    this._currentParent &&
      this._currentParent.type === Ie.PARENT.TAG &&
      this._dec();
  }
  _dec() {
    const e = this._currentParent;
    e.length < 0 || (e.length--, e.length === 0 && this._closeParent());
  }
  _push(e, r) {
    const s = this._currentParent;
    switch ((s.values++, s.type)) {
      case Ie.PARENT.ARRAY:
      case Ie.PARENT.BYTE_STRING:
      case Ie.PARENT.UTF8_STRING:
        s.length > -1
          ? (this._ref[this._ref.length - s.length] = e)
          : this._ref.push(e),
          this._dec();
        break;
      case Ie.PARENT.OBJECT:
        s.tmpKey != null
          ? ((this._ref[s.tmpKey] = e), (s.tmpKey = null), this._dec())
          : ((s.tmpKey = e),
            typeof s.tmpKey != "string" &&
              ((s.type = Ie.PARENT.MAP), (s.ref = Pe.buildMap(s.ref))));
        break;
      case Ie.PARENT.MAP:
        s.tmpKey != null
          ? (this._ref.set(s.tmpKey, e), (s.tmpKey = null), this._dec())
          : (s.tmpKey = e);
        break;
      case Ie.PARENT.TAG:
        this._ref.push(e), r || this._dec();
        break;
      default:
        throw new Error("Unknown parent type");
    }
  }
  _createParent(e, r, s) {
    this._parents[this._depth] = {
      type: r,
      length: s,
      ref: e,
      values: 0,
      tmpKey: null,
    };
  }
  _reset() {
    (this._res = []),
      (this._parents = [
        {
          type: Ie.PARENT.ARRAY,
          length: -1,
          ref: this._res,
          values: 0,
          tmpKey: null,
        },
      ]);
  }
  createTag(e, r) {
    const s = this._knownTags[e];
    return s ? s(r) : new uo(e, r);
  }
  createMap(e, r) {
    return e;
  }
  createObject(e, r) {
    return e;
  }
  createArray(e, r) {
    return e;
  }
  createByteString(e, r) {
    return yt.concat(e);
  }
  createByteStringFromHeap(e, r) {
    return e === r ? yt.alloc(0) : yt.from(this._heap.slice(e, r));
  }
  createInt(e) {
    return e;
  }
  createInt32(e, r) {
    return Pe.buildInt32(e, r);
  }
  createInt64(e, r, s, u) {
    return Pe.buildInt64(e, r, s, u);
  }
  createFloat(e) {
    return e;
  }
  createFloatSingle(e, r, s, u) {
    return wn.read([e, r, s, u], 0, !1, 23, 4);
  }
  createFloatDouble(e, r, s, u, d, g, c, b) {
    return wn.read([e, r, s, u, d, g, c, b], 0, !1, 52, 8);
  }
  createInt32Neg(e, r) {
    return -1 - Pe.buildInt32(e, r);
  }
  createInt64Neg(e, r, s, u) {
    const d = Pe.buildInt32(e, r),
      g = Pe.buildInt32(s, u);
    return d > Ie.MAX_SAFE_HIGH
      ? Ie.NEG_ONE.minus(new so(d).times(Ie.SHIFT32).plus(g))
      : -1 - (d * Ie.SHIFT32 + g);
  }
  createTrue() {
    return !0;
  }
  createFalse() {
    return !1;
  }
  createNull() {
    return null;
  }
  createUndefined() {}
  createInfinity() {
    return 1 / 0;
  }
  createInfinityNeg() {
    return -1 / 0;
  }
  createNaN() {
    return NaN;
  }
  createNaNNeg() {
    return NaN;
  }
  createUtf8String(e, r) {
    return e.join("");
  }
  createUtf8StringFromHeap(e, r) {
    return e === r ? "" : this._buffer.toString("utf8", e, r);
  }
  createSimpleUnassigned(e) {
    return new ao(e);
  }
  pushInt(e) {
    this._push(this.createInt(e));
  }
  pushInt32(e, r) {
    this._push(this.createInt32(e, r));
  }
  pushInt64(e, r, s, u) {
    this._push(this.createInt64(e, r, s, u));
  }
  pushFloat(e) {
    this._push(this.createFloat(e));
  }
  pushFloatSingle(e, r, s, u) {
    this._push(this.createFloatSingle(e, r, s, u));
  }
  pushFloatDouble(e, r, s, u, d, g, c, b) {
    this._push(this.createFloatDouble(e, r, s, u, d, g, c, b));
  }
  pushInt32Neg(e, r) {
    this._push(this.createInt32Neg(e, r));
  }
  pushInt64Neg(e, r, s, u) {
    this._push(this.createInt64Neg(e, r, s, u));
  }
  pushTrue() {
    this._push(this.createTrue());
  }
  pushFalse() {
    this._push(this.createFalse());
  }
  pushNull() {
    this._push(this.createNull());
  }
  pushUndefined() {
    this._push(this.createUndefined());
  }
  pushInfinity() {
    this._push(this.createInfinity());
  }
  pushInfinityNeg() {
    this._push(this.createInfinityNeg());
  }
  pushNaN() {
    this._push(this.createNaN());
  }
  pushNaNNeg() {
    this._push(this.createNaNNeg());
  }
  pushArrayStart() {
    this._createParent([], Ie.PARENT.ARRAY, -1);
  }
  pushArrayStartFixed(e) {
    this._createArrayStartFixed(e);
  }
  pushArrayStartFixed32(e, r) {
    const s = Pe.buildInt32(e, r);
    this._createArrayStartFixed(s);
  }
  pushArrayStartFixed64(e, r, s, u) {
    const d = Pe.buildInt64(e, r, s, u);
    this._createArrayStartFixed(d);
  }
  pushObjectStart() {
    this._createObjectStartFixed(-1);
  }
  pushObjectStartFixed(e) {
    this._createObjectStartFixed(e);
  }
  pushObjectStartFixed32(e, r) {
    const s = Pe.buildInt32(e, r);
    this._createObjectStartFixed(s);
  }
  pushObjectStartFixed64(e, r, s, u) {
    const d = Pe.buildInt64(e, r, s, u);
    this._createObjectStartFixed(d);
  }
  pushByteStringStart() {
    this._parents[this._depth] = {
      type: Ie.PARENT.BYTE_STRING,
      length: -1,
      ref: [],
      values: 0,
      tmpKey: null,
    };
  }
  pushByteString(e, r) {
    this._push(this.createByteStringFromHeap(e, r));
  }
  pushUtf8StringStart() {
    this._parents[this._depth] = {
      type: Ie.PARENT.UTF8_STRING,
      length: -1,
      ref: [],
      values: 0,
      tmpKey: null,
    };
  }
  pushUtf8String(e, r) {
    this._push(this.createUtf8StringFromHeap(e, r));
  }
  pushSimpleUnassigned(e) {
    this._push(this.createSimpleUnassigned(e));
  }
  pushTagStart(e) {
    this._parents[this._depth] = { type: Ie.PARENT.TAG, length: 1, ref: [e] };
  }
  pushTagStart4(e, r) {
    this.pushTagStart(Pe.buildInt32(e, r));
  }
  pushTagStart8(e, r, s, u) {
    this.pushTagStart(Pe.buildInt64(e, r, s, u));
  }
  pushTagUnassigned(e) {
    this._push(this.createTag(e));
  }
  pushBreak() {
    if (this._currentParent.length > -1) throw new Error("Unexpected break");
    this._closeParent();
  }
  _createObjectStartFixed(e) {
    if (e === 0) {
      this._push(this.createObject({}));
      return;
    }
    this._createParent({}, Ie.PARENT.OBJECT, e);
  }
  _createArrayStartFixed(e) {
    if (e === 0) {
      this._push(this.createArray([]));
      return;
    }
    this._createParent(new Array(e), Ie.PARENT.ARRAY, e);
  }
  _decode(e) {
    if (e.byteLength === 0) throw new Error("Input too short");
    this._reset(), this._heap8.set(e);
    const r = this.parser.parse(e.byteLength);
    if (this._depth > 1) {
      for (; this._currentParent.length === 0; ) this._closeParent();
      if (this._depth > 1) throw new Error("Undeterminated nesting");
    }
    if (r > 0) throw new Error("Failed to parse");
    if (this._res.length === 0) throw new Error("No valid result");
  }
  decodeFirst(e) {
    return this._decode(e), this._res[0];
  }
  decodeAll(e) {
    return this._decode(e), this._res;
  }
  static decode(e, r) {
    return (
      typeof e == "string" && (e = yt.from(e, r || "hex")),
      new Rr({ size: e.length }).decodeFirst(e)
    );
  }
  static decodeAll(e, r) {
    return (
      typeof e == "string" && (e = yt.from(e, r || "hex")),
      new Rr({ size: e.length }).decodeAll(e)
    );
  }
};
vr.decodeFirst = vr.decode;
var wi = vr;
const { Buffer: hr } = Ot,
  fo = wi,
  ho = sr;
class Wr extends fo {
  createTag(e, r) {
    return `${e}(${r})`;
  }
  createInt(e) {
    return super.createInt(e).toString();
  }
  createInt32(e, r) {
    return super.createInt32(e, r).toString();
  }
  createInt64(e, r, s, u) {
    return super.createInt64(e, r, s, u).toString();
  }
  createInt32Neg(e, r) {
    return super.createInt32Neg(e, r).toString();
  }
  createInt64Neg(e, r, s, u) {
    return super.createInt64Neg(e, r, s, u).toString();
  }
  createTrue() {
    return "true";
  }
  createFalse() {
    return "false";
  }
  createFloat(e) {
    const r = super.createFloat(e);
    return ho.isNegativeZero(e) ? "-0_1" : `${r}_1`;
  }
  createFloatSingle(e, r, s, u) {
    return `${super.createFloatSingle(e, r, s, u)}_2`;
  }
  createFloatDouble(e, r, s, u, d, g, c, b) {
    return `${super.createFloatDouble(e, r, s, u, d, g, c, b)}_3`;
  }
  createByteString(e, r) {
    const s = e.join(", ");
    return r === -1 ? `(_ ${s})` : `h'${s}`;
  }
  createByteStringFromHeap(e, r) {
    return `h'${hr.from(super.createByteStringFromHeap(e, r)).toString("hex")}'`;
  }
  createInfinity() {
    return "Infinity_1";
  }
  createInfinityNeg() {
    return "-Infinity_1";
  }
  createNaN() {
    return "NaN_1";
  }
  createNaNNeg() {
    return "-NaN_1";
  }
  createNull() {
    return "null";
  }
  createUndefined() {
    return "undefined";
  }
  createSimpleUnassigned(e) {
    return `simple(${e})`;
  }
  createArray(e, r) {
    const s = super.createArray(e, r);
    return r === -1 ? `[_ ${s.join(", ")}]` : `[${s.join(", ")}]`;
  }
  createMap(e, r) {
    const s = super.createMap(e),
      u = Array.from(s.keys()).reduce(yn(s), "");
    return r === -1 ? `{_ ${u}}` : `{${u}}`;
  }
  createObject(e, r) {
    const s = super.createObject(e),
      u = Object.keys(s).reduce(yn(s), "");
    return r === -1 ? `{_ ${u}}` : `{${u}}`;
  }
  createUtf8String(e, r) {
    const s = e.join(", ");
    return r === -1 ? `(_ ${s})` : `"${s}"`;
  }
  createUtf8StringFromHeap(e, r) {
    return `"${hr.from(super.createUtf8StringFromHeap(e, r)).toString("utf8")}"`;
  }
  static diagnose(e, r) {
    return (
      typeof e == "string" && (e = hr.from(e, r || "hex")),
      new Wr().decodeFirst(e)
    );
  }
}
var lo = Wr;
function yn(t) {
  return (e, r) => (e ? `${e}, ${r}: ${t[r]}` : `${r}: ${t[r]}`);
}
const { Buffer: Ve } = Ot,
  { URL: po } = pi,
  Lr = ir.BigNumber,
  lr = sr,
  Le = Me,
  He = Le.MT,
  kt = Le.NUMBYTES,
  gn = Le.SHIFT32,
  xn = Le.SYMS,
  gt = Le.TAG,
  wo = (Le.MT.SIMPLE_FLOAT << 5) | Le.NUMBYTES.TWO,
  yo = (Le.MT.SIMPLE_FLOAT << 5) | Le.NUMBYTES.FOUR,
  go = (Le.MT.SIMPLE_FLOAT << 5) | Le.NUMBYTES.EIGHT,
  xo = (Le.MT.SIMPLE_FLOAT << 5) | Le.SIMPLE.TRUE,
  mo = (Le.MT.SIMPLE_FLOAT << 5) | Le.SIMPLE.FALSE,
  bo = (Le.MT.SIMPLE_FLOAT << 5) | Le.SIMPLE.UNDEFINED,
  mn = (Le.MT.SIMPLE_FLOAT << 5) | Le.SIMPLE.NULL,
  Eo = new Lr("0x20000000000000"),
  _o = Ve.from("f97e00", "hex"),
  Io = Ve.from("f9fc00", "hex"),
  Ao = Ve.from("f97c00", "hex");
function Bo(t) {
  return {}.toString.call(t).slice(8, -1);
}
class jt {
  constructor(e) {
    (e = e || {}),
      (this.streaming = typeof e.stream == "function"),
      (this.onData = e.stream),
      (this.semanticTypes = [
        [po, this._pushUrl],
        [Lr, this._pushBigNumber],
      ]);
    const r = e.genTypes || [],
      s = r.length;
    for (let u = 0; u < s; u++) this.addSemanticType(r[u][0], r[u][1]);
    this._reset();
  }
  addSemanticType(e, r) {
    const s = this.semanticTypes.length;
    for (let u = 0; u < s; u++)
      if (this.semanticTypes[u][0] === e) {
        const g = this.semanticTypes[u][1];
        return (this.semanticTypes[u][1] = r), g;
      }
    return this.semanticTypes.push([e, r]), null;
  }
  push(e) {
    return (
      e &&
        ((this.result[this.offset] = e),
        (this.resultMethod[this.offset] = 0),
        (this.resultLength[this.offset] = e.length),
        this.offset++,
        this.streaming && this.onData(this.finalize())),
      !0
    );
  }
  pushWrite(e, r, s) {
    return (
      (this.result[this.offset] = e),
      (this.resultMethod[this.offset] = r),
      (this.resultLength[this.offset] = s),
      this.offset++,
      this.streaming && this.onData(this.finalize()),
      !0
    );
  }
  _pushUInt8(e) {
    return this.pushWrite(e, 1, 1);
  }
  _pushUInt16BE(e) {
    return this.pushWrite(e, 2, 2);
  }
  _pushUInt32BE(e) {
    return this.pushWrite(e, 3, 4);
  }
  _pushDoubleBE(e) {
    return this.pushWrite(e, 4, 8);
  }
  _pushNaN() {
    return this.push(_o);
  }
  _pushInfinity(e) {
    const r = e < 0 ? Io : Ao;
    return this.push(r);
  }
  _pushFloat(e) {
    const r = Ve.allocUnsafe(2);
    if (lr.writeHalf(r, e) && lr.parseHalf(r) === e)
      return this._pushUInt8(wo) && this.push(r);
    const s = Ve.allocUnsafe(4);
    return (
      s.writeFloatBE(e, 0),
      s.readFloatBE(0) === e
        ? this._pushUInt8(yo) && this.push(s)
        : this._pushUInt8(go) && this._pushDoubleBE(e)
    );
  }
  _pushInt(e, r, s) {
    const u = r << 5;
    return e < 24
      ? this._pushUInt8(u | e)
      : e <= 255
        ? this._pushUInt8(u | kt.ONE) && this._pushUInt8(e)
        : e <= 65535
          ? this._pushUInt8(u | kt.TWO) && this._pushUInt16BE(e)
          : e <= 4294967295
            ? this._pushUInt8(u | kt.FOUR) && this._pushUInt32BE(e)
            : e <= Number.MAX_SAFE_INTEGER
              ? this._pushUInt8(u | kt.EIGHT) &&
                this._pushUInt32BE(Math.floor(e / gn)) &&
                this._pushUInt32BE(e % gn)
              : r === He.NEG_INT
                ? this._pushFloat(s)
                : this._pushFloat(e);
  }
  _pushIntNum(e) {
    return e < 0
      ? this._pushInt(-e - 1, He.NEG_INT, e)
      : this._pushInt(e, He.POS_INT);
  }
  _pushNumber(e) {
    switch (!1) {
      case e === e:
        return this._pushNaN(e);
      case isFinite(e):
        return this._pushInfinity(e);
      case e % 1 !== 0:
        return this._pushIntNum(e);
      default:
        return this._pushFloat(e);
    }
  }
  _pushString(e) {
    const r = Ve.byteLength(e, "utf8");
    return this._pushInt(r, He.UTF8_STRING) && this.pushWrite(e, 5, r);
  }
  _pushBoolean(e) {
    return this._pushUInt8(e ? xo : mo);
  }
  _pushUndefined(e) {
    return this._pushUInt8(bo);
  }
  _pushArray(e, r) {
    const s = r.length;
    if (!e._pushInt(s, He.ARRAY)) return !1;
    for (let u = 0; u < s; u++) if (!e.pushAny(r[u])) return !1;
    return !0;
  }
  _pushTag(e) {
    return this._pushInt(e, He.TAG);
  }
  _pushDate(e, r) {
    return e._pushTag(gt.DATE_EPOCH) && e.pushAny(Math.round(r / 1e3));
  }
  _pushBuffer(e, r) {
    return e._pushInt(r.length, He.BYTE_STRING) && e.push(r);
  }
  _pushNoFilter(e, r) {
    return e._pushBuffer(e, r.slice());
  }
  _pushRegexp(e, r) {
    return e._pushTag(gt.REGEXP) && e.pushAny(r.source);
  }
  _pushSet(e, r) {
    if (!e._pushInt(r.size, He.ARRAY)) return !1;
    for (const s of r) if (!e.pushAny(s)) return !1;
    return !0;
  }
  _pushUrl(e, r) {
    return e._pushTag(gt.URI) && e.pushAny(r.format());
  }
  _pushBigint(e) {
    let r = gt.POS_BIGINT;
    e.isNegative() && ((e = e.negated().minus(1)), (r = gt.NEG_BIGINT));
    let s = e.toString(16);
    s.length % 2 && (s = "0" + s);
    const u = Ve.from(s, "hex");
    return this._pushTag(r) && this._pushBuffer(this, u);
  }
  _pushBigNumber(e, r) {
    if (r.isNaN()) return e._pushNaN();
    if (!r.isFinite()) return e._pushInfinity(r.isNegative() ? -1 / 0 : 1 / 0);
    if (r.isInteger()) return e._pushBigint(r);
    if (!(e._pushTag(gt.DECIMAL_FRAC) && e._pushInt(2, He.ARRAY))) return !1;
    const s = r.decimalPlaces(),
      u = r.multipliedBy(new Lr(10).pow(s));
    return e._pushIntNum(-s)
      ? u.abs().isLessThan(Eo)
        ? e._pushIntNum(u.toNumber())
        : e._pushBigint(u)
      : !1;
  }
  _pushMap(e, r) {
    return e._pushInt(r.size, He.MAP)
      ? this._pushRawMap(r.size, Array.from(r))
      : !1;
  }
  _pushObject(e) {
    if (!e) return this._pushUInt8(mn);
    for (var r = this.semanticTypes.length, s = 0; s < r; s++)
      if (e instanceof this.semanticTypes[s][0])
        return this.semanticTypes[s][1].call(e, this, e);
    var u = e.encodeCBOR;
    if (typeof u == "function") return u.call(e, this);
    var d = Object.keys(e),
      g = d.length;
    return this._pushInt(g, He.MAP)
      ? this._pushRawMap(
          g,
          d.map((c) => [c, e[c]]),
        )
      : !1;
  }
  _pushRawMap(e, r) {
    r = r
      .map(function (u) {
        return (u[0] = jt.encode(u[0])), u;
      })
      .sort(lr.keySorter);
    for (var s = 0; s < e; s++)
      if (!this.push(r[s][0]) || !this.pushAny(r[s][1])) return !1;
    return !0;
  }
  write(e) {
    return this.pushAny(e);
  }
  pushAny(e) {
    var r = Bo(e);
    switch (r) {
      case "Number":
        return this._pushNumber(e);
      case "String":
        return this._pushString(e);
      case "Boolean":
        return this._pushBoolean(e);
      case "Object":
        return this._pushObject(e);
      case "Array":
        return this._pushArray(this, e);
      case "Uint8Array":
        return this._pushBuffer(this, Ve.isBuffer(e) ? e : Ve.from(e));
      case "Null":
        return this._pushUInt8(mn);
      case "Undefined":
        return this._pushUndefined(e);
      case "Map":
        return this._pushMap(this, e);
      case "Set":
        return this._pushSet(this, e);
      case "URL":
        return this._pushUrl(this, e);
      case "BigNumber":
        return this._pushBigNumber(this, e);
      case "Date":
        return this._pushDate(this, e);
      case "RegExp":
        return this._pushRegexp(this, e);
      case "Symbol":
        switch (e) {
          case xn.NULL:
            return this._pushObject(null);
          case xn.UNDEFINED:
            return this._pushUndefined(void 0);
          default:
            throw new Error("Unknown symbol: " + e.toString());
        }
      default:
        throw new Error(
          "Unknown type: " + typeof e + ", " + (e ? e.toString() : ""),
        );
    }
  }
  finalize() {
    if (this.offset === 0) return null;
    for (
      var e = this.result,
        r = this.resultLength,
        s = this.resultMethod,
        u = this.offset,
        d = 0,
        g = 0;
      g < u;
      g++
    )
      d += r[g];
    var c = Ve.allocUnsafe(d),
      b = 0,
      S = 0;
    for (g = 0; g < u; g++) {
      switch (((S = r[g]), s[g])) {
        case 0:
          e[g].copy(c, b);
          break;
        case 1:
          c.writeUInt8(e[g], b, !0);
          break;
        case 2:
          c.writeUInt16BE(e[g], b, !0);
          break;
        case 3:
          c.writeUInt32BE(e[g], b, !0);
          break;
        case 4:
          c.writeDoubleBE(e[g], b, !0);
          break;
        case 5:
          c.write(e[g], b, S, "utf8");
          break;
        default:
          throw new Error("unkown method");
      }
      b += S;
    }
    var N = c;
    return this._reset(), N;
  }
  _reset() {
    (this.result = []),
      (this.resultMethod = []),
      (this.resultLength = []),
      (this.offset = 0);
  }
  static encode(e) {
    const r = new jt();
    if (!r.pushAny(e)) throw new Error("Failed to encode input");
    return r.finalize();
  }
}
var So = jt;
(function (t) {
  (t.Diagnose = lo),
    (t.Decoder = wi),
    (t.Encoder = So),
    (t.Simple = fi),
    (t.Tagged = hi),
    (t.decodeAll = t.Decoder.decodeAll),
    (t.decodeFirst = t.Decoder.decodeFirst),
    (t.diagnose = t.Diagnose.diagnose),
    (t.encode = t.Encoder.encode),
    (t.decode = t.Decoder.decode),
    (t.leveldb = {
      decode: t.Decoder.decodeAll,
      encode: t.Encoder.encode,
      buffer: !0,
      name: "cbor",
    });
})(ui);
var yi = ys(ui);
function ht(t) {
  return Ut(Gs.create().update(new Uint8Array(t)).digest());
}
function zt(t) {
  if (t instanceof yi.Tagged) return zt(t.value);
  if (typeof t == "string") return gi(t);
  if (typeof t == "number") return ht(dn(t));
  if (t instanceof ArrayBuffer || ArrayBuffer.isView(t)) return ht(t);
  if (Array.isArray(t)) {
    const e = t.map(zt);
    return ht(Nt(...e));
  } else {
    if (t && typeof t == "object" && t._isPrincipal)
      return ht(t.toUint8Array());
    if (typeof t == "object" && t !== null && typeof t.toHash == "function")
      return zt(t.toHash());
    if (typeof t == "object") return xi(t);
    if (typeof t == "bigint") return ht(dn(t));
  }
  throw Object.assign(
    new Error(`Attempt to hash a value of unsupported type: ${t}`),
    { value: t },
  );
}
const gi = (t) => {
  const e = new TextEncoder().encode(t);
  return ht(e);
};
function Vr(t) {
  return xi(t);
}
function xi(t) {
  const s = Object.entries(t)
      .filter(([, g]) => g !== void 0)
      .map(([g, c]) => {
        const b = gi(g),
          S = zt(c);
        return [b, S];
      })
      .sort(([g], [c]) => ei(g, c)),
    u = Nt(...s.map((g) => Nt(...g)));
  return ht(u);
}
var To = function (t, e) {
  var r = {};
  for (var s in t)
    Object.prototype.hasOwnProperty.call(t, s) &&
      e.indexOf(s) < 0 &&
      (r[s] = t[s]);
  if (t != null && typeof Object.getOwnPropertySymbols == "function")
    for (var u = 0, s = Object.getOwnPropertySymbols(t); u < s.length; u++)
      e.indexOf(s[u]) < 0 &&
        Object.prototype.propertyIsEnumerable.call(t, s[u]) &&
        (r[s[u]] = t[s[u]]);
  return r;
};
const Uo = new TextEncoder().encode(`
ic-request`);
class qr {
  getPrincipal() {
    return (
      this._principal ||
        (this._principal = ut.selfAuthenticating(
          new Uint8Array(this.getPublicKey().toDer()),
        )),
      this._principal
    );
  }
  async transformRequest(e) {
    const { body: r } = e,
      s = To(e, ["body"]),
      u = Vr(r);
    return Object.assign(Object.assign({}, s), {
      body: {
        content: r,
        sender_pubkey: this.getPublicKey().toDer(),
        sender_sig: await this.sign(Nt(Uo, u)),
      },
    });
  }
}
class bn {
  getPrincipal() {
    return ut.anonymous();
  }
  async transformRequest(e) {
    return Object.assign(Object.assign({}, e), { body: { content: e.body } });
  }
}
var ke = {},
  It = {},
  Be = {};
Object.defineProperty(Be, "__esModule", { value: !0 });
const No = 9007199254740992;
function Qe(t, ...e) {
  const r = new Uint8Array(
    t.byteLength + e.reduce((u, d) => u + d.byteLength, 0),
  );
  r.set(new Uint8Array(t), 0);
  let s = t.byteLength;
  for (const u of e) r.set(new Uint8Array(u), s), (s += u.byteLength);
  return r.buffer;
}
function Ke(t, e, r) {
  r = r.replace(/[^0-9a-fA-F]/g, "");
  const s = 2 ** (e - 24);
  r = r.slice(-s * 2).padStart(s * 2, "0");
  const u = [(t << 5) + e].concat(r.match(/../g).map((d) => parseInt(d, 16)));
  return new Uint8Array(u).buffer;
}
function or(t, e) {
  if (e < 24) return new Uint8Array([(t << 5) + e]).buffer;
  {
    const r = e <= 255 ? 24 : e <= 65535 ? 25 : e <= 4294967295 ? 26 : 27;
    return Ke(t, r, e.toString(16));
  }
}
function mi(t) {
  const e = [];
  for (let r = 0; r < t.length; r++) {
    let s = t.charCodeAt(r);
    s < 128
      ? e.push(s)
      : s < 2048
        ? e.push(192 | (s >> 6), 128 | (s & 63))
        : s < 55296 || s >= 57344
          ? e.push(224 | (s >> 12), 128 | ((s >> 6) & 63), 128 | (s & 63))
          : (r++,
            (s = ((s & 1023) << 10) | (t.charCodeAt(r) & 1023)),
            e.push(
              240 | (s >> 18),
              128 | ((s >> 12) & 63),
              128 | ((s >> 6) & 63),
              128 | (s & 63),
            ));
  }
  return Qe(new Uint8Array(or(3, t.length)), new Uint8Array(e));
}
function Fo(t, e) {
  if (t == 14277111) return Qe(new Uint8Array([217, 217, 247]), e);
  if (t < 24) return Qe(new Uint8Array([192 + t]), e);
  {
    const r = t <= 255 ? 24 : t <= 65535 ? 25 : t <= 4294967295 ? 26 : 27,
      s = 2 ** (r - 24),
      u = t
        .toString(16)
        .slice(-s * 2)
        .padStart(s * 2, "0"),
      d = [192 + r].concat(u.match(/../g).map((g) => parseInt(g, 16)));
    return new Uint8Array(d).buffer;
  }
}
Be.tagged = Fo;
function Dt(t) {
  return new Uint8Array(t).buffer;
}
Be.raw = Dt;
function Jr(t) {
  if (isNaN(t)) throw new RangeError("Invalid number.");
  t = Math.min(Math.max(0, t), 23);
  const e = [0 + t];
  return new Uint8Array(e).buffer;
}
Be.uSmall = Jr;
function bi(t, e) {
  if (((t = parseInt("" + t, e)), isNaN(t)))
    throw new RangeError("Invalid number.");
  return (
    (t = Math.min(Math.max(0, t), 255)), (t = t.toString(16)), Ke(0, 24, t)
  );
}
Be.u8 = bi;
function Ei(t, e) {
  if (((t = parseInt("" + t, e)), isNaN(t)))
    throw new RangeError("Invalid number.");
  return (
    (t = Math.min(Math.max(0, t), 65535)), (t = t.toString(16)), Ke(0, 25, t)
  );
}
Be.u16 = Ei;
function _i(t, e) {
  if (((t = parseInt("" + t, e)), isNaN(t)))
    throw new RangeError("Invalid number.");
  return (
    (t = Math.min(Math.max(0, t), 4294967295)),
    (t = t.toString(16)),
    Ke(0, 26, t)
  );
}
Be.u32 = _i;
function Xr(t, e) {
  if (typeof t == "string" && e == 16) {
    if (t.match(/[^0-9a-fA-F]/)) throw new RangeError("Invalid number.");
    return Ke(0, 27, t);
  }
  if (((t = parseInt("" + t, e)), isNaN(t)))
    throw new RangeError("Invalid number.");
  return (t = Math.min(Math.max(0, t), No)), (t = t.toString(16)), Ke(0, 27, t);
}
Be.u64 = Xr;
function Ii(t) {
  if (isNaN(t)) throw new RangeError("Invalid number.");
  if (t === 0) return Jr(0);
  t = Math.min(Math.max(0, -t), 24) - 1;
  const e = [32 + t];
  return new Uint8Array(e).buffer;
}
Be.iSmall = Ii;
function Ai(t, e) {
  if (((t = parseInt("" + t, e)), isNaN(t)))
    throw new RangeError("Invalid number.");
  return (
    (t = Math.min(Math.max(0, -t - 1), 255)), (t = t.toString(16)), Ke(1, 24, t)
  );
}
Be.i8 = Ai;
function Bi(t, e) {
  if (((t = parseInt("" + t, e)), isNaN(t)))
    throw new RangeError("Invalid number.");
  return (
    (t = Math.min(Math.max(0, -t - 1), 65535)),
    (t = t.toString(16)),
    Ke(1, 25, t)
  );
}
Be.i16 = Bi;
function Si(t, e) {
  if (((t = parseInt("" + t, e)), isNaN(t)))
    throw new RangeError("Invalid number.");
  return (
    (t = Math.min(Math.max(0, -t - 1), 4294967295)),
    (t = t.toString(16)),
    Ke(1, 26, t)
  );
}
Be.i32 = Si;
function Ti(t, e) {
  if (typeof t == "string" && e == 16) {
    if (
      (t.startsWith("-") ? (t = t.slice(1)) : (t = "0"),
      t.match(/[^0-9a-fA-F]/) || t.length > 16)
    )
      throw new RangeError("Invalid number.");
    let r = !1,
      s = t.split("").reduceRight((u, d) => {
        if (r) return d + u;
        let g = parseInt(d, 16) - 1;
        return g >= 0 ? ((r = !0), g.toString(16) + u) : "f" + u;
      }, "");
    return r ? Ke(1, 27, s) : Xr(0);
  }
  if (((t = parseInt("" + t, e)), isNaN(t)))
    throw new RangeError("Invalid number.");
  return (
    (t = Math.min(Math.max(0, -t - 1), 9007199254740992)),
    (t = t.toString(16)),
    Ke(1, 27, t)
  );
}
Be.i64 = Ti;
function vo(t) {
  return t >= 0
    ? t < 24
      ? Jr(t)
      : t <= 255
        ? bi(t)
        : t <= 65535
          ? Ei(t)
          : t <= 4294967295
            ? _i(t)
            : Xr(t)
    : t >= -24
      ? Ii(t)
      : t >= -255
        ? Ai(t)
        : t >= -65535
          ? Bi(t)
          : t >= -4294967295
            ? Si(t)
            : Ti(t);
}
Be.number = vo;
function Ro(t) {
  return Qe(or(2, t.byteLength), t);
}
Be.bytes = Ro;
function Lo(t) {
  return mi(t);
}
Be.string = Lo;
function Oo(t) {
  return Qe(or(4, t.length), ...t);
}
Be.array = Oo;
function Do(t, e = !1) {
  t instanceof Map || (t = new Map(Object.entries(t)));
  let r = Array.from(t.entries());
  return (
    e && (r = r.sort(([s], [u]) => s.localeCompare(u))),
    Qe(or(5, t.size), ...r.map(([s, u]) => Qe(mi(s), u)))
  );
}
Be.map = Do;
function Mo(t) {
  const e = new Float32Array([t]);
  return Qe(new Uint8Array([250]), new Uint8Array(e.buffer));
}
Be.singleFloat = Mo;
function Po(t) {
  const e = new Float64Array([t]);
  return Qe(new Uint8Array([251]), new Uint8Array(e.buffer));
}
Be.doubleFloat = Po;
function Co(t) {
  return t ? Ui() : Ni();
}
Be.bool = Co;
function Ui() {
  return Dt(new Uint8Array([245]));
}
Be.true_ = Ui;
function Ni() {
  return Dt(new Uint8Array([244]));
}
Be.false_ = Ni;
function ko() {
  return Dt(new Uint8Array([246]));
}
Be.null_ = ko;
function Go() {
  return Dt(new Uint8Array([247]));
}
Be.undefined_ = Go;
var Ho =
  (Et && Et.__importStar) ||
  function (t) {
    if (t && t.__esModule) return t;
    var e = {};
    if (t != null)
      for (var r in t) Object.hasOwnProperty.call(t, r) && (e[r] = t[r]);
    return (e.default = t), e;
  };
Object.defineProperty(It, "__esModule", { value: !0 });
const ze = Ho(Be),
  $o = [
    ArrayBuffer,
    Uint8Array,
    Uint16Array,
    Uint32Array,
    Int8Array,
    Int16Array,
    Int32Array,
    Float32Array,
    Float64Array,
  ];
class Fi {
  constructor(e, r = !1) {
    (this._serializer = e),
      (this._stable = r),
      (this.name = "jsonDefault"),
      (this.priority = -100);
  }
  match(e) {
    return (
      ["undefined", "boolean", "number", "string", "object"].indexOf(
        typeof e,
      ) != -1
    );
  }
  encode(e) {
    switch (typeof e) {
      case "undefined":
        return ze.undefined_();
      case "boolean":
        return ze.bool(e);
      case "number":
        return Math.floor(e) === e ? ze.number(e) : ze.doubleFloat(e);
      case "string":
        return ze.string(e);
      case "object":
        if (e === null) return ze.null_();
        if (Array.isArray(e))
          return ze.array(e.map((r) => this._serializer.serializeValue(r)));
        if ($o.find((r) => e instanceof r)) return ze.bytes(e.buffer);
        if (Object.getOwnPropertyNames(e).indexOf("toJSON") !== -1)
          return this.encode(e.toJSON());
        if (e instanceof Map) {
          const r = new Map();
          for (const [s, u] of e.entries())
            r.set(s, this._serializer.serializeValue(u));
          return ze.map(r, this._stable);
        } else {
          const r = new Map();
          for (const [s, u] of Object.entries(e))
            r.set(s, this._serializer.serializeValue(u));
          return ze.map(r, this._stable);
        }
      default:
        throw new Error("Invalid value.");
    }
  }
}
It.JsonDefaultCborEncoder = Fi;
class vi {
  constructor() {
    (this.name = "cborEncoder"), (this.priority = -90);
  }
  match(e) {
    return typeof e == "object" && typeof e.toCBOR == "function";
  }
  encode(e) {
    return e.toCBOR();
  }
}
It.ToCborEncoder = vi;
class Ri {
  constructor() {
    this._encoders = new Set();
  }
  static withDefaultEncoders(e = !1) {
    const r = new this();
    return r.addEncoder(new Fi(r, e)), r.addEncoder(new vi()), r;
  }
  removeEncoder(e) {
    for (const r of this._encoders.values())
      r.name == e && this._encoders.delete(r);
  }
  addEncoder(e) {
    this._encoders.add(e);
  }
  getEncoderFor(e) {
    let r = null;
    for (const s of this._encoders)
      (!r || s.priority > r.priority) && s.match(e) && (r = s);
    if (r === null) throw new Error("Could not find an encoder for value.");
    return r;
  }
  serializeValue(e) {
    return this.getEncoderFor(e).encode(e);
  }
  serialize(e) {
    return this.serializeValue(e);
  }
}
It.CborSerializer = Ri;
class zo extends Ri {
  serialize(e) {
    return ze.raw(
      new Uint8Array([
        ...new Uint8Array([217, 217, 247]),
        ...new Uint8Array(super.serializeValue(e)),
      ]),
    );
  }
}
It.SelfDescribeCborSerializer = zo;
(function (t) {
  function e(u) {
    for (var d in u) t.hasOwnProperty(d) || (t[d] = u[d]);
  }
  var r =
    (Et && Et.__importStar) ||
    function (u) {
      if (u && u.__esModule) return u;
      var d = {};
      if (u != null)
        for (var g in u) Object.hasOwnProperty.call(u, g) && (d[g] = u[g]);
      return (d.default = u), d;
    };
  Object.defineProperty(t, "__esModule", { value: !0 }), e(It);
  const s = r(Be);
  t.value = s;
})(ke);
class Ko {
  get name() {
    return "Principal";
  }
  get priority() {
    return 0;
  }
  match(e) {
    return e && e._isPrincipal === !0;
  }
  encode(e) {
    return ke.value.bytes(e.toUint8Array());
  }
}
class Yo {
  get name() {
    return "Buffer";
  }
  get priority() {
    return 1;
  }
  match(e) {
    return e instanceof ArrayBuffer || ArrayBuffer.isView(e);
  }
  encode(e) {
    return ke.value.bytes(new Uint8Array(e));
  }
}
class Wo {
  get name() {
    return "BigInt";
  }
  get priority() {
    return 1;
  }
  match(e) {
    return typeof e == "bigint";
  }
  encode(e) {
    return e > BigInt(0)
      ? ke.value.tagged(2, ke.value.bytes(ct(e.toString(16))))
      : ke.value.tagged(3, ke.value.bytes(ct((BigInt("-1") * e).toString(16))));
  }
}
const jr = ke.SelfDescribeCborSerializer.withDefaultEncoders(!0);
jr.addEncoder(new Ko());
jr.addEncoder(new Yo());
jr.addEncoder(new Wo());
var En;
(function (t) {
  (t[(t.Uint64LittleEndian = 71)] = "Uint64LittleEndian"),
    (t[(t.Semantic = 55799)] = "Semantic");
})(En || (En = {}));
class t0 extends yi.Decoder {
  createByteString(e) {
    return Nt(...e);
  }
  createByteStringFromHeap(e, r) {
    return e === r
      ? new ArrayBuffer(0)
      : new Uint8Array(this._heap.slice(e, r));
  }
}
var _n;
(function (t) {
  t.Call = "call";
})(_n || (_n = {}));
BigInt(1e6);
/*! noble-curves - MIT License (c) 2022 Paul Miller (paulmillr.com) */ const Zr =
    BigInt(0),
  Li = BigInt(1),
  Vo = BigInt(2);
function Qr(t) {
  return (
    t instanceof Uint8Array ||
    (ArrayBuffer.isView(t) && t.constructor.name === "Uint8Array")
  );
}
function en(t) {
  if (!Qr(t)) throw new Error("Uint8Array expected");
}
function dr(t, e) {
  if (typeof e != "boolean") throw new Error(t + " boolean expected, got " + e);
}
const qo = Array.from({ length: 256 }, (t, e) =>
  e.toString(16).padStart(2, "0"),
);
function tn(t) {
  en(t);
  let e = "";
  for (let r = 0; r < t.length; r++) e += qo[t[r]];
  return e;
}
function Oi(t) {
  if (typeof t != "string")
    throw new Error("hex string expected, got " + typeof t);
  return t === "" ? Zr : BigInt("0x" + t);
}
const Je = { _0: 48, _9: 57, A: 65, F: 70, a: 97, f: 102 };
function In(t) {
  if (t >= Je._0 && t <= Je._9) return t - Je._0;
  if (t >= Je.A && t <= Je.F) return t - (Je.A - 10);
  if (t >= Je.a && t <= Je.f) return t - (Je.a - 10);
}
function Di(t) {
  if (typeof t != "string")
    throw new Error("hex string expected, got " + typeof t);
  const e = t.length,
    r = e / 2;
  if (e % 2)
    throw new Error("hex string expected, got unpadded hex of length " + e);
  const s = new Uint8Array(r);
  for (let u = 0, d = 0; u < r; u++, d += 2) {
    const g = In(t.charCodeAt(d)),
      c = In(t.charCodeAt(d + 1));
    if (g === void 0 || c === void 0) {
      const b = t[d] + t[d + 1];
      throw new Error(
        'hex string expected, got non-hex character "' + b + '" at index ' + d,
      );
    }
    s[u] = g * 16 + c;
  }
  return s;
}
function Jo(t) {
  return Oi(tn(t));
}
function Kt(t) {
  return en(t), Oi(tn(Uint8Array.from(t).reverse()));
}
function Mi(t, e) {
  return Di(t.toString(16).padStart(e * 2, "0"));
}
function Or(t, e) {
  return Mi(t, e).reverse();
}
function Xe(t, e, r) {
  let s;
  if (typeof e == "string")
    try {
      s = Di(e);
    } catch (d) {
      throw new Error(t + " must be hex string or Uint8Array, cause: " + d);
    }
  else if (Qr(e)) s = Uint8Array.from(e);
  else throw new Error(t + " must be hex string or Uint8Array");
  const u = s.length;
  if (typeof r == "number" && u !== r)
    throw new Error(t + " of length " + r + " expected, got " + u);
  return s;
}
function An(...t) {
  let e = 0;
  for (let s = 0; s < t.length; s++) {
    const u = t[s];
    en(u), (e += u.length);
  }
  const r = new Uint8Array(e);
  for (let s = 0, u = 0; s < t.length; s++) {
    const d = t[s];
    r.set(d, u), (u += d.length);
  }
  return r;
}
const pr = (t) => typeof t == "bigint" && Zr <= t;
function Xo(t, e, r) {
  return pr(t) && pr(e) && pr(r) && e <= t && t < r;
}
function Bt(t, e, r, s) {
  if (!Xo(e, r, s))
    throw new Error(
      "expected valid " + t + ": " + r + " <= n < " + s + ", got " + e,
    );
}
function jo(t) {
  let e;
  for (e = 0; t > Zr; t >>= Li, e += 1);
  return e;
}
const Zo = (t) => (Vo << BigInt(t - 1)) - Li,
  Qo = {
    bigint: (t) => typeof t == "bigint",
    function: (t) => typeof t == "function",
    boolean: (t) => typeof t == "boolean",
    string: (t) => typeof t == "string",
    stringOrUint8Array: (t) => typeof t == "string" || Qr(t),
    isSafeInteger: (t) => Number.isSafeInteger(t),
    array: (t) => Array.isArray(t),
    field: (t, e) => e.Fp.isValid(t),
    hash: (t) => typeof t == "function" && Number.isSafeInteger(t.outputLen),
  };
function rn(t, e, r = {}) {
  const s = (u, d, g) => {
    const c = Qo[d];
    if (typeof c != "function") throw new Error("invalid validator function");
    const b = t[u];
    if (!(g && b === void 0) && !c(b, t))
      throw new Error(
        "param " + String(u) + " is invalid. Expected " + d + ", got " + b,
      );
  };
  for (const [u, d] of Object.entries(e)) s(u, d, !1);
  for (const [u, d] of Object.entries(r)) s(u, d, !0);
  return t;
}
function Bn(t) {
  const e = new WeakMap();
  return (r, ...s) => {
    const u = e.get(r);
    if (u !== void 0) return u;
    const d = t(r, ...s);
    return e.set(r, d), d;
  };
}
/*! noble-curves - MIT License (c) 2022 Paul Miller (paulmillr.com) */ const De =
    BigInt(0),
  Fe = BigInt(1),
  lt = BigInt(2),
  ea = BigInt(3),
  Dr = BigInt(4),
  Sn = BigInt(5),
  Tn = BigInt(8);
function Re(t, e) {
  const r = t % e;
  return r >= De ? r : e + r;
}
function ta(t, e, r) {
  if (e < De) throw new Error("invalid exponent, negatives unsupported");
  if (r <= De) throw new Error("invalid modulus");
  if (r === Fe) return De;
  let s = Fe;
  for (; e > De; ) e & Fe && (s = (s * t) % r), (t = (t * t) % r), (e >>= Fe);
  return s;
}
function We(t, e, r) {
  let s = t;
  for (; e-- > De; ) (s *= s), (s %= r);
  return s;
}
function Un(t, e) {
  if (t === De) throw new Error("invert: expected non-zero number");
  if (e <= De) throw new Error("invert: expected positive modulus, got " + e);
  let r = Re(t, e),
    s = e,
    u = De,
    d = Fe;
  for (; r !== De; ) {
    const c = s / r,
      b = s % r,
      S = u - d * c;
    (s = r), (r = b), (u = d), (d = S);
  }
  if (s !== Fe) throw new Error("invert: does not exist");
  return Re(u, e);
}
function ra(t) {
  const e = (t - Fe) / lt;
  let r, s, u;
  for (r = t - Fe, s = 0; r % lt === De; r /= lt, s++);
  for (u = lt; u < t && ta(u, e, t) !== t - Fe; u++)
    if (u > 1e3) throw new Error("Cannot find square root: likely non-prime P");
  if (s === 1) {
    const g = (t + Fe) / Dr;
    return function (b, S) {
      const N = b.pow(S, g);
      if (!b.eql(b.sqr(N), S)) throw new Error("Cannot find square root");
      return N;
    };
  }
  const d = (r + Fe) / lt;
  return function (c, b) {
    if (c.pow(b, e) === c.neg(c.ONE))
      throw new Error("Cannot find square root");
    let S = s,
      N = c.pow(c.mul(c.ONE, u), r),
      L = c.pow(b, d),
      O = c.pow(b, r);
    for (; !c.eql(O, c.ONE); ) {
      if (c.eql(O, c.ZERO)) return c.ZERO;
      let M = 1;
      for (let W = c.sqr(O); M < S && !c.eql(W, c.ONE); M++) W = c.sqr(W);
      const q = c.pow(N, Fe << BigInt(S - M - 1));
      (N = c.sqr(q)), (L = c.mul(L, q)), (O = c.mul(O, N)), (S = M);
    }
    return L;
  };
}
function na(t) {
  if (t % Dr === ea) {
    const e = (t + Fe) / Dr;
    return function (s, u) {
      const d = s.pow(u, e);
      if (!s.eql(s.sqr(d), u)) throw new Error("Cannot find square root");
      return d;
    };
  }
  if (t % Tn === Sn) {
    const e = (t - Sn) / Tn;
    return function (s, u) {
      const d = s.mul(u, lt),
        g = s.pow(d, e),
        c = s.mul(u, g),
        b = s.mul(s.mul(c, lt), g),
        S = s.mul(c, s.sub(b, s.ONE));
      if (!s.eql(s.sqr(S), u)) throw new Error("Cannot find square root");
      return S;
    };
  }
  return ra(t);
}
const ia = (t, e) => (Re(t, e) & Fe) === Fe,
  sa = [
    "create",
    "isValid",
    "is0",
    "neg",
    "inv",
    "sqrt",
    "sqr",
    "eql",
    "add",
    "sub",
    "mul",
    "pow",
    "div",
    "addN",
    "subN",
    "mulN",
    "sqrN",
  ];
function oa(t) {
  const e = {
      ORDER: "bigint",
      MASK: "bigint",
      BYTES: "isSafeInteger",
      BITS: "isSafeInteger",
    },
    r = sa.reduce((s, u) => ((s[u] = "function"), s), e);
  return rn(t, r);
}
function aa(t, e, r) {
  if (r < De) throw new Error("invalid exponent, negatives unsupported");
  if (r === De) return t.ONE;
  if (r === Fe) return e;
  let s = t.ONE,
    u = e;
  for (; r > De; ) r & Fe && (s = t.mul(s, u)), (u = t.sqr(u)), (r >>= Fe);
  return s;
}
function ua(t, e) {
  const r = new Array(e.length),
    s = e.reduce(
      (d, g, c) => (t.is0(g) ? d : ((r[c] = d), t.mul(d, g))),
      t.ONE,
    ),
    u = t.inv(s);
  return (
    e.reduceRight(
      (d, g, c) => (t.is0(g) ? d : ((r[c] = t.mul(d, r[c])), t.mul(d, g))),
      u,
    ),
    r
  );
}
function Pi(t, e) {
  const r = e !== void 0 ? e : t.toString(2).length,
    s = Math.ceil(r / 8);
  return { nBitLength: r, nByteLength: s };
}
function Ci(t, e, r = !1, s = {}) {
  if (t <= De) throw new Error("invalid field: expected ORDER > 0, got " + t);
  const { nBitLength: u, nByteLength: d } = Pi(t, e);
  if (d > 2048)
    throw new Error("invalid field: expected ORDER of <= 2048 bytes");
  let g;
  const c = Object.freeze({
    ORDER: t,
    isLE: r,
    BITS: u,
    BYTES: d,
    MASK: Zo(u),
    ZERO: De,
    ONE: Fe,
    create: (b) => Re(b, t),
    isValid: (b) => {
      if (typeof b != "bigint")
        throw new Error(
          "invalid field element: expected bigint, got " + typeof b,
        );
      return De <= b && b < t;
    },
    is0: (b) => b === De,
    isOdd: (b) => (b & Fe) === Fe,
    neg: (b) => Re(-b, t),
    eql: (b, S) => b === S,
    sqr: (b) => Re(b * b, t),
    add: (b, S) => Re(b + S, t),
    sub: (b, S) => Re(b - S, t),
    mul: (b, S) => Re(b * S, t),
    pow: (b, S) => aa(c, b, S),
    div: (b, S) => Re(b * Un(S, t), t),
    sqrN: (b) => b * b,
    addN: (b, S) => b + S,
    subN: (b, S) => b - S,
    mulN: (b, S) => b * S,
    inv: (b) => Un(b, t),
    sqrt: s.sqrt || ((b) => (g || (g = na(t)), g(c, b))),
    invertBatch: (b) => ua(c, b),
    cmov: (b, S, N) => (N ? S : b),
    toBytes: (b) => (r ? Or(b, d) : Mi(b, d)),
    fromBytes: (b) => {
      if (b.length !== d)
        throw new Error(
          "Field.fromBytes: expected " + d + " bytes, got " + b.length,
        );
      return r ? Kt(b) : Jo(b);
    },
  });
  return Object.freeze(c);
}
/*! noble-curves - MIT License (c) 2022 Paul Miller (paulmillr.com) */ const Nn =
    BigInt(0),
  Gt = BigInt(1);
function wr(t, e) {
  const r = e.negate();
  return t ? r : e;
}
function ki(t, e) {
  if (!Number.isSafeInteger(t) || t <= 0 || t > e)
    throw new Error("invalid window size, expected [1.." + e + "], got W=" + t);
}
function yr(t, e) {
  ki(t, e);
  const r = Math.ceil(e / t) + 1,
    s = 2 ** (t - 1);
  return { windows: r, windowSize: s };
}
function ca(t, e) {
  if (!Array.isArray(t)) throw new Error("array expected");
  t.forEach((r, s) => {
    if (!(r instanceof e)) throw new Error("invalid point at index " + s);
  });
}
function fa(t, e) {
  if (!Array.isArray(t)) throw new Error("array of scalars expected");
  t.forEach((r, s) => {
    if (!e.isValid(r)) throw new Error("invalid scalar at index " + s);
  });
}
const gr = new WeakMap(),
  Gi = new WeakMap();
function xr(t) {
  return Gi.get(t) || 1;
}
function ha(t, e) {
  return {
    constTimeNegate: wr,
    hasPrecomputes(r) {
      return xr(r) !== 1;
    },
    unsafeLadder(r, s, u = t.ZERO) {
      let d = r;
      for (; s > Nn; ) s & Gt && (u = u.add(d)), (d = d.double()), (s >>= Gt);
      return u;
    },
    precomputeWindow(r, s) {
      const { windows: u, windowSize: d } = yr(s, e),
        g = [];
      let c = r,
        b = c;
      for (let S = 0; S < u; S++) {
        (b = c), g.push(b);
        for (let N = 1; N < d; N++) (b = b.add(c)), g.push(b);
        c = b.double();
      }
      return g;
    },
    wNAF(r, s, u) {
      const { windows: d, windowSize: g } = yr(r, e);
      let c = t.ZERO,
        b = t.BASE;
      const S = BigInt(2 ** r - 1),
        N = 2 ** r,
        L = BigInt(r);
      for (let O = 0; O < d; O++) {
        const M = O * g;
        let q = Number(u & S);
        (u >>= L), q > g && ((q -= N), (u += Gt));
        const W = M,
          le = M + Math.abs(q) - 1,
          Ee = O % 2 !== 0,
          ae = q < 0;
        q === 0 ? (b = b.add(wr(Ee, s[W]))) : (c = c.add(wr(ae, s[le])));
      }
      return { p: c, f: b };
    },
    wNAFUnsafe(r, s, u, d = t.ZERO) {
      const { windows: g, windowSize: c } = yr(r, e),
        b = BigInt(2 ** r - 1),
        S = 2 ** r,
        N = BigInt(r);
      for (let L = 0; L < g; L++) {
        const O = L * c;
        if (u === Nn) break;
        let M = Number(u & b);
        if (((u >>= N), M > c && ((M -= S), (u += Gt)), M === 0)) continue;
        let q = s[O + Math.abs(M) - 1];
        M < 0 && (q = q.negate()), (d = d.add(q));
      }
      return d;
    },
    getPrecomputes(r, s, u) {
      let d = gr.get(s);
      return (
        d || ((d = this.precomputeWindow(s, r)), r !== 1 && gr.set(s, u(d))), d
      );
    },
    wNAFCached(r, s, u) {
      const d = xr(r);
      return this.wNAF(d, this.getPrecomputes(d, r, u), s);
    },
    wNAFCachedUnsafe(r, s, u, d) {
      const g = xr(r);
      return g === 1
        ? this.unsafeLadder(r, s, d)
        : this.wNAFUnsafe(g, this.getPrecomputes(g, r, u), s, d);
    },
    setWindowSize(r, s) {
      ki(s, e), Gi.set(r, s), gr.delete(r);
    },
  };
}
function la(t, e, r, s) {
  if ((ca(r, t), fa(s, e), r.length !== s.length))
    throw new Error("arrays of points and scalars must have equal length");
  const u = t.ZERO,
    d = jo(BigInt(r.length)),
    g = d > 12 ? d - 3 : d > 4 ? d - 2 : d ? 2 : 1,
    c = (1 << g) - 1,
    b = new Array(c + 1).fill(u),
    S = Math.floor((e.BITS - 1) / g) * g;
  let N = u;
  for (let L = S; L >= 0; L -= g) {
    b.fill(u);
    for (let M = 0; M < s.length; M++) {
      const q = s[M],
        W = Number((q >> BigInt(L)) & BigInt(c));
      b[W] = b[W].add(r[M]);
    }
    let O = u;
    for (let M = b.length - 1, q = u; M > 0; M--)
      (q = q.add(b[M])), (O = O.add(q));
    if (((N = N.add(O)), L !== 0)) for (let M = 0; M < g; M++) N = N.double();
  }
  return N;
}
function da(t) {
  return (
    oa(t.Fp),
    rn(
      t,
      { n: "bigint", h: "bigint", Gx: "field", Gy: "field" },
      { nBitLength: "isSafeInteger", nByteLength: "isSafeInteger" },
    ),
    Object.freeze({ ...Pi(t.n, t.nBitLength), ...t, p: t.Fp.ORDER })
  );
}
var Fn;
(function (t) {
  (t[(t.Empty = 0)] = "Empty"),
    (t[(t.Fork = 1)] = "Fork"),
    (t[(t.Labeled = 2)] = "Labeled"),
    (t[(t.Leaf = 3)] = "Leaf"),
    (t[(t.Pruned = 4)] = "Pruned");
})(Fn || (Fn = {}));
ct(
  "308182301d060d2b0601040182dc7c0503010201060c2b0601040182dc7c05030201036100",
);
var vn;
(function (t) {
  (t.Unknown = "unknown"), (t.Absent = "absent"), (t.Found = "found");
})(vn || (vn = {}));
var Rn;
(function (t) {
  (t.Less = "less"), (t.Greater = "greater");
})(Rn || (Rn = {}));
const Ht = BigInt(2 ** 32 - 1),
  Mr = BigInt(32);
function Hi(t, e = !1) {
  return e
    ? { h: Number(t & Ht), l: Number((t >> Mr) & Ht) }
    : { h: Number((t >> Mr) & Ht) | 0, l: Number(t & Ht) | 0 };
}
function pa(t, e = !1) {
  let r = new Uint32Array(t.length),
    s = new Uint32Array(t.length);
  for (let u = 0; u < t.length; u++) {
    const { h: d, l: g } = Hi(t[u], e);
    [r[u], s[u]] = [d, g];
  }
  return [r, s];
}
const wa = (t, e) => (BigInt(t >>> 0) << Mr) | BigInt(e >>> 0),
  ya = (t, e, r) => t >>> r,
  ga = (t, e, r) => (t << (32 - r)) | (e >>> r),
  xa = (t, e, r) => (t >>> r) | (e << (32 - r)),
  ma = (t, e, r) => (t << (32 - r)) | (e >>> r),
  ba = (t, e, r) => (t << (64 - r)) | (e >>> (r - 32)),
  Ea = (t, e, r) => (t >>> (r - 32)) | (e << (64 - r)),
  _a = (t, e) => e,
  Ia = (t, e) => t,
  Aa = (t, e, r) => (t << r) | (e >>> (32 - r)),
  Ba = (t, e, r) => (e << r) | (t >>> (32 - r)),
  Sa = (t, e, r) => (e << (r - 32)) | (t >>> (64 - r)),
  Ta = (t, e, r) => (t << (r - 32)) | (e >>> (64 - r));
function Ua(t, e, r, s) {
  const u = (e >>> 0) + (s >>> 0);
  return { h: (t + r + ((u / 2 ** 32) | 0)) | 0, l: u | 0 };
}
const Na = (t, e, r) => (t >>> 0) + (e >>> 0) + (r >>> 0),
  Fa = (t, e, r, s) => (e + r + s + ((t / 2 ** 32) | 0)) | 0,
  va = (t, e, r, s) => (t >>> 0) + (e >>> 0) + (r >>> 0) + (s >>> 0),
  Ra = (t, e, r, s, u) => (e + r + s + u + ((t / 2 ** 32) | 0)) | 0,
  La = (t, e, r, s, u) =>
    (t >>> 0) + (e >>> 0) + (r >>> 0) + (s >>> 0) + (u >>> 0),
  Oa = (t, e, r, s, u, d) => (e + r + s + u + d + ((t / 2 ** 32) | 0)) | 0,
  oe = {
    fromBig: Hi,
    split: pa,
    toBig: wa,
    shrSH: ya,
    shrSL: ga,
    rotrSH: xa,
    rotrSL: ma,
    rotrBH: ba,
    rotrBL: Ea,
    rotr32H: _a,
    rotr32L: Ia,
    rotlSH: Aa,
    rotlSL: Ba,
    rotlBH: Sa,
    rotlBL: Ta,
    add: Ua,
    add3L: Na,
    add3H: Fa,
    add4L: va,
    add4H: Ra,
    add5H: Oa,
    add5L: La,
  },
  [Da, Ma] = oe.split(
    [
      "0x428a2f98d728ae22",
      "0x7137449123ef65cd",
      "0xb5c0fbcfec4d3b2f",
      "0xe9b5dba58189dbbc",
      "0x3956c25bf348b538",
      "0x59f111f1b605d019",
      "0x923f82a4af194f9b",
      "0xab1c5ed5da6d8118",
      "0xd807aa98a3030242",
      "0x12835b0145706fbe",
      "0x243185be4ee4b28c",
      "0x550c7dc3d5ffb4e2",
      "0x72be5d74f27b896f",
      "0x80deb1fe3b1696b1",
      "0x9bdc06a725c71235",
      "0xc19bf174cf692694",
      "0xe49b69c19ef14ad2",
      "0xefbe4786384f25e3",
      "0x0fc19dc68b8cd5b5",
      "0x240ca1cc77ac9c65",
      "0x2de92c6f592b0275",
      "0x4a7484aa6ea6e483",
      "0x5cb0a9dcbd41fbd4",
      "0x76f988da831153b5",
      "0x983e5152ee66dfab",
      "0xa831c66d2db43210",
      "0xb00327c898fb213f",
      "0xbf597fc7beef0ee4",
      "0xc6e00bf33da88fc2",
      "0xd5a79147930aa725",
      "0x06ca6351e003826f",
      "0x142929670a0e6e70",
      "0x27b70a8546d22ffc",
      "0x2e1b21385c26c926",
      "0x4d2c6dfc5ac42aed",
      "0x53380d139d95b3df",
      "0x650a73548baf63de",
      "0x766a0abb3c77b2a8",
      "0x81c2c92e47edaee6",
      "0x92722c851482353b",
      "0xa2bfe8a14cf10364",
      "0xa81a664bbc423001",
      "0xc24b8b70d0f89791",
      "0xc76c51a30654be30",
      "0xd192e819d6ef5218",
      "0xd69906245565a910",
      "0xf40e35855771202a",
      "0x106aa07032bbd1b8",
      "0x19a4c116b8d2d0c8",
      "0x1e376c085141ab53",
      "0x2748774cdf8eeb99",
      "0x34b0bcb5e19b48a8",
      "0x391c0cb3c5c95a63",
      "0x4ed8aa4ae3418acb",
      "0x5b9cca4f7763e373",
      "0x682e6ff3d6b2b8a3",
      "0x748f82ee5defb2fc",
      "0x78a5636f43172f60",
      "0x84c87814a1f0ab72",
      "0x8cc702081a6439ec",
      "0x90befffa23631e28",
      "0xa4506cebde82bde9",
      "0xbef9a3f7b2c67915",
      "0xc67178f2e372532b",
      "0xca273eceea26619c",
      "0xd186b8c721c0c207",
      "0xeada7dd6cde0eb1e",
      "0xf57d4f7fee6ed178",
      "0x06f067aa72176fba",
      "0x0a637dc5a2c898a6",
      "0x113f9804bef90dae",
      "0x1b710b35131c471b",
      "0x28db77f523047d84",
      "0x32caab7b40c72493",
      "0x3c9ebe0a15c9bebc",
      "0x431d67c49c100d4c",
      "0x4cc5d4becb3e42b6",
      "0x597f299cfc657e2a",
      "0x5fcb6fab3ad6faec",
      "0x6c44198c4a475817",
    ].map((t) => BigInt(t)),
  ),
  rt = new Uint32Array(80),
  nt = new Uint32Array(80);
class Pa extends Zn {
  constructor() {
    super(128, 64, 16, !1),
      (this.Ah = 1779033703),
      (this.Al = -205731576),
      (this.Bh = -1150833019),
      (this.Bl = -2067093701),
      (this.Ch = 1013904242),
      (this.Cl = -23791573),
      (this.Dh = -1521486534),
      (this.Dl = 1595750129),
      (this.Eh = 1359893119),
      (this.El = -1377402159),
      (this.Fh = -1694144372),
      (this.Fl = 725511199),
      (this.Gh = 528734635),
      (this.Gl = -79577749),
      (this.Hh = 1541459225),
      (this.Hl = 327033209);
  }
  get() {
    const {
      Ah: e,
      Al: r,
      Bh: s,
      Bl: u,
      Ch: d,
      Cl: g,
      Dh: c,
      Dl: b,
      Eh: S,
      El: N,
      Fh: L,
      Fl: O,
      Gh: M,
      Gl: q,
      Hh: W,
      Hl: le,
    } = this;
    return [e, r, s, u, d, g, c, b, S, N, L, O, M, q, W, le];
  }
  set(e, r, s, u, d, g, c, b, S, N, L, O, M, q, W, le) {
    (this.Ah = e | 0),
      (this.Al = r | 0),
      (this.Bh = s | 0),
      (this.Bl = u | 0),
      (this.Ch = d | 0),
      (this.Cl = g | 0),
      (this.Dh = c | 0),
      (this.Dl = b | 0),
      (this.Eh = S | 0),
      (this.El = N | 0),
      (this.Fh = L | 0),
      (this.Fl = O | 0),
      (this.Gh = M | 0),
      (this.Gl = q | 0),
      (this.Hh = W | 0),
      (this.Hl = le | 0);
  }
  process(e, r) {
    for (let K = 0; K < 16; K++, r += 4)
      (rt[K] = e.getUint32(r)), (nt[K] = e.getUint32((r += 4)));
    for (let K = 16; K < 80; K++) {
      const Ue = rt[K - 15] | 0,
        ue = nt[K - 15] | 0,
        J = oe.rotrSH(Ue, ue, 1) ^ oe.rotrSH(Ue, ue, 8) ^ oe.shrSH(Ue, ue, 7),
        X = oe.rotrSL(Ue, ue, 1) ^ oe.rotrSL(Ue, ue, 8) ^ oe.shrSL(Ue, ue, 7),
        ne = rt[K - 2] | 0,
        ie = nt[K - 2] | 0,
        C = oe.rotrSH(ne, ie, 19) ^ oe.rotrBH(ne, ie, 61) ^ oe.shrSH(ne, ie, 6),
        xe =
          oe.rotrSL(ne, ie, 19) ^ oe.rotrBL(ne, ie, 61) ^ oe.shrSL(ne, ie, 6),
        ce = oe.add4L(X, xe, nt[K - 7], nt[K - 16]),
        fe = oe.add4H(ce, J, C, rt[K - 7], rt[K - 16]);
      (rt[K] = fe | 0), (nt[K] = ce | 0);
    }
    let {
      Ah: s,
      Al: u,
      Bh: d,
      Bl: g,
      Ch: c,
      Cl: b,
      Dh: S,
      Dl: N,
      Eh: L,
      El: O,
      Fh: M,
      Fl: q,
      Gh: W,
      Gl: le,
      Hh: Ee,
      Hl: ae,
    } = this;
    for (let K = 0; K < 80; K++) {
      const Ue =
          oe.rotrSH(L, O, 14) ^ oe.rotrSH(L, O, 18) ^ oe.rotrBH(L, O, 41),
        ue = oe.rotrSL(L, O, 14) ^ oe.rotrSL(L, O, 18) ^ oe.rotrBL(L, O, 41),
        J = (L & M) ^ (~L & W),
        X = (O & q) ^ (~O & le),
        ne = oe.add5L(ae, ue, X, Ma[K], nt[K]),
        ie = oe.add5H(ne, Ee, Ue, J, Da[K], rt[K]),
        C = ne | 0,
        xe = oe.rotrSH(s, u, 28) ^ oe.rotrBH(s, u, 34) ^ oe.rotrBH(s, u, 39),
        ce = oe.rotrSL(s, u, 28) ^ oe.rotrBL(s, u, 34) ^ oe.rotrBL(s, u, 39),
        fe = (s & d) ^ (s & c) ^ (d & c),
        Se = (u & g) ^ (u & b) ^ (g & b);
      (Ee = W | 0),
        (ae = le | 0),
        (W = M | 0),
        (le = q | 0),
        (M = L | 0),
        (q = O | 0),
        ({ h: L, l: O } = oe.add(S | 0, N | 0, ie | 0, C | 0)),
        (S = c | 0),
        (N = b | 0),
        (c = d | 0),
        (b = g | 0),
        (d = s | 0),
        (g = u | 0);
      const _e = oe.add3L(C, ce, Se);
      (s = oe.add3H(_e, ie, xe, fe)), (u = _e | 0);
    }
    ({ h: s, l: u } = oe.add(this.Ah | 0, this.Al | 0, s | 0, u | 0)),
      ({ h: d, l: g } = oe.add(this.Bh | 0, this.Bl | 0, d | 0, g | 0)),
      ({ h: c, l: b } = oe.add(this.Ch | 0, this.Cl | 0, c | 0, b | 0)),
      ({ h: S, l: N } = oe.add(this.Dh | 0, this.Dl | 0, S | 0, N | 0)),
      ({ h: L, l: O } = oe.add(this.Eh | 0, this.El | 0, L | 0, O | 0)),
      ({ h: M, l: q } = oe.add(this.Fh | 0, this.Fl | 0, M | 0, q | 0)),
      ({ h: W, l: le } = oe.add(this.Gh | 0, this.Gl | 0, W | 0, le | 0)),
      ({ h: Ee, l: ae } = oe.add(this.Hh | 0, this.Hl | 0, Ee | 0, ae | 0)),
      this.set(s, u, d, g, c, b, S, N, L, O, M, q, W, le, Ee, ae);
  }
  roundClean() {
    rt.fill(0), nt.fill(0);
  }
  destroy() {
    this.buffer.fill(0),
      this.set(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  }
}
const Ca = Gr(() => new Pa());
/*! noble-curves - MIT License (c) 2022 Paul Miller (paulmillr.com) */ const $e =
    BigInt(0),
  Ce = BigInt(1),
  $t = BigInt(2),
  ka = BigInt(8),
  Ga = { zip215: !0 };
function Ha(t) {
  const e = da(t);
  return (
    rn(
      t,
      { hash: "function", a: "bigint", d: "bigint", randomBytes: "function" },
      {
        adjustScalarBytes: "function",
        domain: "function",
        uvRatio: "function",
        mapToCurve: "function",
      },
    ),
    Object.freeze({ ...e })
  );
}
function $a(t) {
  const e = Ha(t),
    {
      Fp: r,
      n: s,
      prehash: u,
      hash: d,
      randomBytes: g,
      nByteLength: c,
      h: b,
    } = e,
    S = $t << (BigInt(c * 8) - Ce),
    N = r.create,
    L = Ci(e.n, e.nBitLength),
    O =
      e.uvRatio ||
      ((Z, P) => {
        try {
          return { isValid: !0, value: r.sqrt(Z * r.inv(P)) };
        } catch {
          return { isValid: !1, value: $e };
        }
      }),
    M = e.adjustScalarBytes || ((Z) => Z),
    q =
      e.domain ||
      ((Z, P, k) => {
        if ((dr("phflag", k), P.length || k))
          throw new Error("Contexts/pre-hash are not supported");
        return Z;
      });
  function W(Z, P) {
    Bt("coordinate " + Z, P, $e, S);
  }
  function le(Z) {
    if (!(Z instanceof K)) throw new Error("ExtendedPoint expected");
  }
  const Ee = Bn((Z, P) => {
      const { ex: k, ey: j, ez: Q } = Z,
        G = Z.is0();
      P == null && (P = G ? ka : r.inv(Q));
      const $ = N(k * P),
        ye = N(j * P),
        y = N(Q * P);
      if (G) return { x: $e, y: Ce };
      if (y !== Ce) throw new Error("invZ was invalid");
      return { x: $, y: ye };
    }),
    ae = Bn((Z) => {
      const { a: P, d: k } = e;
      if (Z.is0()) throw new Error("bad point: ZERO");
      const { ex: j, ey: Q, ez: G, et: $ } = Z,
        ye = N(j * j),
        y = N(Q * Q),
        de = N(G * G),
        me = N(de * de),
        Te = N(ye * P),
        H = N(de * N(Te + y)),
        Y = N(me + N(k * N(ye * y)));
      if (H !== Y) throw new Error("bad point: equation left != right (1)");
      const w = N(j * Q),
        x = N(G * $);
      if (w !== x) throw new Error("bad point: equation left != right (2)");
      return !0;
    });
  class K {
    constructor(P, k, j, Q) {
      (this.ex = P),
        (this.ey = k),
        (this.ez = j),
        (this.et = Q),
        W("x", P),
        W("y", k),
        W("z", j),
        W("t", Q),
        Object.freeze(this);
    }
    get x() {
      return this.toAffine().x;
    }
    get y() {
      return this.toAffine().y;
    }
    static fromAffine(P) {
      if (P instanceof K) throw new Error("extended point not allowed");
      const { x: k, y: j } = P || {};
      return W("x", k), W("y", j), new K(k, j, Ce, N(k * j));
    }
    static normalizeZ(P) {
      const k = r.invertBatch(P.map((j) => j.ez));
      return P.map((j, Q) => j.toAffine(k[Q])).map(K.fromAffine);
    }
    static msm(P, k) {
      return la(K, L, P, k);
    }
    _setWindowSize(P) {
      J.setWindowSize(this, P);
    }
    assertValidity() {
      ae(this);
    }
    equals(P) {
      le(P);
      const { ex: k, ey: j, ez: Q } = this,
        { ex: G, ey: $, ez: ye } = P,
        y = N(k * ye),
        de = N(G * Q),
        me = N(j * ye),
        Te = N($ * Q);
      return y === de && me === Te;
    }
    is0() {
      return this.equals(K.ZERO);
    }
    negate() {
      return new K(N(-this.ex), this.ey, this.ez, N(-this.et));
    }
    double() {
      const { a: P } = e,
        { ex: k, ey: j, ez: Q } = this,
        G = N(k * k),
        $ = N(j * j),
        ye = N($t * N(Q * Q)),
        y = N(P * G),
        de = k + j,
        me = N(N(de * de) - G - $),
        Te = y + $,
        H = Te - ye,
        Y = y - $,
        w = N(me * H),
        x = N(Te * Y),
        _ = N(me * Y),
        T = N(H * Te);
      return new K(w, x, T, _);
    }
    add(P) {
      le(P);
      const { a: k, d: j } = e,
        { ex: Q, ey: G, ez: $, et: ye } = this,
        { ex: y, ey: de, ez: me, et: Te } = P;
      if (k === BigInt(-1)) {
        const p = N((G - Q) * (de + y)),
          E = N((G + Q) * (de - y)),
          F = N(E - p);
        if (F === $e) return this.double();
        const D = N($ * $t * Te),
          z = N(ye * $t * me),
          V = z + D,
          re = E + p,
          h = z - D,
          o = N(V * F),
          a = N(re * h),
          m = N(V * h),
          A = N(F * re);
        return new K(o, a, A, m);
      }
      const H = N(Q * y),
        Y = N(G * de),
        w = N(ye * j * Te),
        x = N($ * me),
        _ = N((Q + G) * (y + de) - H - Y),
        T = x - w,
        B = x + w,
        U = N(Y - k * H),
        f = N(_ * T),
        n = N(B * U),
        i = N(_ * U),
        l = N(T * B);
      return new K(f, n, l, i);
    }
    subtract(P) {
      return this.add(P.negate());
    }
    wNAF(P) {
      return J.wNAFCached(this, P, K.normalizeZ);
    }
    multiply(P) {
      const k = P;
      Bt("scalar", k, Ce, s);
      const { p: j, f: Q } = this.wNAF(k);
      return K.normalizeZ([j, Q])[0];
    }
    multiplyUnsafe(P, k = K.ZERO) {
      const j = P;
      return (
        Bt("scalar", j, $e, s),
        j === $e
          ? ue
          : this.is0() || j === Ce
            ? this
            : J.wNAFCachedUnsafe(this, j, K.normalizeZ, k)
      );
    }
    isSmallOrder() {
      return this.multiplyUnsafe(b).is0();
    }
    isTorsionFree() {
      return J.unsafeLadder(this, s).is0();
    }
    toAffine(P) {
      return Ee(this, P);
    }
    clearCofactor() {
      const { h: P } = e;
      return P === Ce ? this : this.multiplyUnsafe(P);
    }
    static fromHex(P, k = !1) {
      const { d: j, a: Q } = e,
        G = r.BYTES;
      (P = Xe("pointHex", P, G)), dr("zip215", k);
      const $ = P.slice(),
        ye = P[G - 1];
      $[G - 1] = ye & -129;
      const y = Kt($),
        de = k ? S : r.ORDER;
      Bt("pointHex.y", y, $e, de);
      const me = N(y * y),
        Te = N(me - Ce),
        H = N(j * me - Q);
      let { isValid: Y, value: w } = O(Te, H);
      if (!Y) throw new Error("Point.fromHex: invalid y coordinate");
      const x = (w & Ce) === Ce,
        _ = (ye & 128) !== 0;
      if (!k && w === $e && _) throw new Error("Point.fromHex: x=0 and x_0=1");
      return _ !== x && (w = N(-w)), K.fromAffine({ x: w, y });
    }
    static fromPrivateKey(P) {
      return ie(P).point;
    }
    toRawBytes() {
      const { x: P, y: k } = this.toAffine(),
        j = Or(k, r.BYTES);
      return (j[j.length - 1] |= P & Ce ? 128 : 0), j;
    }
    toHex() {
      return tn(this.toRawBytes());
    }
  }
  (K.BASE = new K(e.Gx, e.Gy, Ce, N(e.Gx * e.Gy))),
    (K.ZERO = new K($e, Ce, Ce, $e));
  const { BASE: Ue, ZERO: ue } = K,
    J = ha(K, c * 8);
  function X(Z) {
    return Re(Z, s);
  }
  function ne(Z) {
    return X(Kt(Z));
  }
  function ie(Z) {
    const P = r.BYTES;
    Z = Xe("private key", Z, P);
    const k = Xe("hashed private key", d(Z), 2 * P),
      j = M(k.slice(0, P)),
      Q = k.slice(P, 2 * P),
      G = ne(j),
      $ = Ue.multiply(G),
      ye = $.toRawBytes();
    return { head: j, prefix: Q, scalar: G, point: $, pointBytes: ye };
  }
  function C(Z) {
    return ie(Z).pointBytes;
  }
  function xe(Z = new Uint8Array(), ...P) {
    const k = An(...P);
    return ne(d(q(k, Xe("context", Z), !!u)));
  }
  function ce(Z, P, k = {}) {
    (Z = Xe("message", Z)), u && (Z = u(Z));
    const { prefix: j, scalar: Q, pointBytes: G } = ie(P),
      $ = xe(k.context, j, Z),
      ye = Ue.multiply($).toRawBytes(),
      y = xe(k.context, ye, G, Z),
      de = X($ + y * Q);
    Bt("signature.s", de, $e, s);
    const me = An(ye, Or(de, r.BYTES));
    return Xe("result", me, r.BYTES * 2);
  }
  const fe = Ga;
  function Se(Z, P, k, j = fe) {
    const { context: Q, zip215: G } = j,
      $ = r.BYTES;
    (Z = Xe("signature", Z, 2 * $)),
      (P = Xe("message", P)),
      (k = Xe("publicKey", k, $)),
      G !== void 0 && dr("zip215", G),
      u && (P = u(P));
    const ye = Kt(Z.slice($, 2 * $));
    let y, de, me;
    try {
      (y = K.fromHex(k, G)),
        (de = K.fromHex(Z.slice(0, $), G)),
        (me = Ue.multiplyUnsafe(ye));
    } catch {
      return !1;
    }
    if (!G && y.isSmallOrder()) return !1;
    const Te = xe(Q, de.toRawBytes(), y.toRawBytes(), P);
    return de
      .add(y.multiplyUnsafe(Te))
      .subtract(me)
      .clearCofactor()
      .equals(K.ZERO);
  }
  return (
    Ue._setWindowSize(8),
    {
      CURVE: e,
      getPublicKey: C,
      sign: ce,
      verify: Se,
      ExtendedPoint: K,
      utils: {
        getExtendedPublicKey: ie,
        randomPrivateKey: () => g(r.BYTES),
        precompute(Z = 8, P = K.BASE) {
          return P._setWindowSize(Z), P.multiply(BigInt(3)), P;
        },
      },
    }
  );
}
/*! noble-curves - MIT License (c) 2022 Paul Miller (paulmillr.com) */ const nn =
    BigInt(
      "57896044618658097711785492504343953926634992332820282019728792003956564819949",
    ),
  Ln = BigInt(
    "19681161376707505956807079304988542015446066515923890162744021073123829784752",
  );
BigInt(0);
const za = BigInt(1),
  On = BigInt(2);
BigInt(3);
const Ka = BigInt(5),
  Ya = BigInt(8);
function Wa(t) {
  const e = BigInt(10),
    r = BigInt(20),
    s = BigInt(40),
    u = BigInt(80),
    d = nn,
    c = (((t * t) % d) * t) % d,
    b = (We(c, On, d) * c) % d,
    S = (We(b, za, d) * t) % d,
    N = (We(S, Ka, d) * S) % d,
    L = (We(N, e, d) * N) % d,
    O = (We(L, r, d) * L) % d,
    M = (We(O, s, d) * O) % d,
    q = (We(M, u, d) * M) % d,
    W = (We(q, u, d) * M) % d,
    le = (We(W, e, d) * N) % d;
  return { pow_p_5_8: (We(le, On, d) * t) % d, b2: c };
}
function Va(t) {
  return (t[0] &= 248), (t[31] &= 127), (t[31] |= 64), t;
}
function qa(t, e) {
  const r = nn,
    s = Re(e * e * e, r),
    u = Re(s * s * e, r),
    d = Wa(t * u).pow_p_5_8;
  let g = Re(t * s * d, r);
  const c = Re(e * g * g, r),
    b = g,
    S = Re(g * Ln, r),
    N = c === t,
    L = c === Re(-t, r),
    O = c === Re(-t * Ln, r);
  return (
    N && (g = b),
    (L || O) && (g = S),
    ia(g, r) && (g = Re(-g, r)),
    { isValid: N || L, value: g }
  );
}
const Ja = Ci(nn, void 0, !0),
  Xa = {
    a: BigInt(-1),
    d: BigInt(
      "37095705934669439343138083508754565189542113879843219016388785533085940283555",
    ),
    Fp: Ja,
    n: BigInt(
      "7237005577332262213973186563042994240857116359379907606001950938285454250989",
    ),
    h: Ya,
    Gx: BigInt(
      "15112221349535400772501151409588531511454012693041857206046113283949847762202",
    ),
    Gy: BigInt(
      "46316835694926478169428394003475163141307993866256225615783033603165251855960",
    ),
    hash: Ca,
    randomBytes: Os,
    adjustScalarBytes: Va,
    uvRatio: qa,
  },
  St = $a(Xa),
  Dn = (t) => {
    if (t <= 127) return 1;
    if (t <= 255) return 2;
    if (t <= 65535) return 3;
    if (t <= 16777215) return 4;
    throw new Error("Length too long (> 4 bytes)");
  },
  Mn = (t, e, r) => {
    if (r <= 127) return (t[e] = r), 1;
    if (r <= 255) return (t[e] = 129), (t[e + 1] = r), 2;
    if (r <= 65535) return (t[e] = 130), (t[e + 1] = r >> 8), (t[e + 2] = r), 3;
    if (r <= 16777215)
      return (
        (t[e] = 131),
        (t[e + 1] = r >> 16),
        (t[e + 2] = r >> 8),
        (t[e + 3] = r),
        4
      );
    throw new Error("Length too long (> 4 bytes)");
  },
  Pr = (t, e) => {
    if (t[e] < 128) return 1;
    if (t[e] === 128) throw new Error("Invalid length 0");
    if (t[e] === 129) return 2;
    if (t[e] === 130) return 3;
    if (t[e] === 131) return 4;
    throw new Error("Length too long (> 4 bytes)");
  },
  ja = (t, e) => {
    const r = Pr(t, e);
    if (r === 1) return t[e];
    if (r === 2) return t[e + 1];
    if (r === 3) return (t[e + 1] << 8) + t[e + 2];
    if (r === 4) return (t[e + 1] << 16) + (t[e + 2] << 8) + t[e + 3];
    throw new Error("Length too long (> 4 bytes)");
  };
Uint8Array.from([48, 12, 6, 10, 43, 6, 1, 4, 1, 131, 184, 67, 1, 1]);
const Pn = Uint8Array.from([48, 5, 6, 3, 43, 101, 112]);
Uint8Array.from([
  48, 16, 6, 7, 42, 134, 72, 206, 61, 2, 1, 6, 5, 43, 129, 4, 0, 10,
]);
function Za(t, e) {
  const r = 2 + Dn(t.byteLength + 1),
    s = e.byteLength + r + t.byteLength;
  let u = 0;
  const d = new Uint8Array(1 + Dn(s) + s);
  return (
    (d[u++] = 48),
    (u += Mn(d, u, s)),
    d.set(e, u),
    (u += e.byteLength),
    (d[u++] = 3),
    (u += Mn(d, u, t.byteLength + 1)),
    (d[u++] = 0),
    d.set(new Uint8Array(t), u),
    d
  );
}
const Qa = (t, e) => {
  let r = 0;
  const s = (c, b) => {
      if (u[r++] !== c) throw new Error("Expected: " + b);
    },
    u = new Uint8Array(t);
  if (
    (s(48, "sequence"), (r += Pr(u, r)), !ti(u.slice(r, r + e.byteLength), e))
  )
    throw new Error("Not the expected OID.");
  (r += e.byteLength), s(3, "bit string");
  const d = ja(u, r) - 1;
  (r += Pr(u, r)), s(0, "0 padding");
  const g = u.slice(r);
  if (d !== g.length)
    throw new Error(
      `DER payload mismatch: Expected length ${d} actual length ${g.length}`,
    );
  return g;
};
var Cn;
(function (t) {
  (t.Received = "received"),
    (t.Processing = "processing"),
    (t.Replied = "replied"),
    (t.Rejected = "rejected"),
    (t.Unknown = "unknown"),
    (t.Done = "done");
})(Cn || (Cn = {}));
var kn;
(function (t) {
  (t.Error = "err"),
    (t.GetPrincipal = "gp"),
    (t.GetPrincipalResponse = "gpr"),
    (t.Query = "q"),
    (t.QueryResponse = "qr"),
    (t.Call = "c"),
    (t.CallResponse = "cr"),
    (t.ReadState = "rs"),
    (t.ReadStateResponse = "rsr"),
    (t.Status = "s"),
    (t.StatusResponse = "sr");
})(kn || (kn = {}));
var Zt = function (t, e, r, s, u) {
    if (s === "m") throw new TypeError("Private method is not writable");
    if (s === "a" && !u)
      throw new TypeError("Private accessor was defined without a setter");
    if (typeof e == "function" ? t !== e || !u : !e.has(t))
      throw new TypeError(
        "Cannot write private member to an object whose class did not declare it",
      );
    return s === "a" ? u.call(t, r) : u ? (u.value = r) : e.set(t, r), r;
  },
  st = function (t, e, r, s) {
    if (r === "a" && !s)
      throw new TypeError("Private accessor was defined without a getter");
    if (typeof e == "function" ? t !== e || !s : !e.has(t))
      throw new TypeError(
        "Cannot read private member from an object whose class did not declare it",
      );
    return r === "m" ? s : r === "a" ? s.call(t) : s ? s.value : e.get(t);
  },
  Yt,
  Wt,
  xt,
  mt;
function Gn(t) {
  return t !== null && typeof t == "object";
}
class Ze {
  constructor(e) {
    if (
      (Yt.set(this, void 0),
      Wt.set(this, void 0),
      e.byteLength !== Ze.RAW_KEY_LENGTH)
    )
      throw new Error("An Ed25519 public key must be exactly 32bytes long");
    Zt(this, Yt, e, "f"), Zt(this, Wt, Ze.derEncode(e), "f");
  }
  static from(e) {
    if (typeof e == "string") {
      const r = ct(e);
      return this.fromRaw(r);
    } else if (Gn(e)) {
      const r = e;
      if (Gn(r) && Object.hasOwnProperty.call(r, "__derEncodedPublicKey__"))
        return this.fromDer(r);
      if (ArrayBuffer.isView(r)) {
        const s = r;
        return this.fromRaw(ri(s.buffer));
      } else {
        if (r instanceof ArrayBuffer) return this.fromRaw(r);
        if ("rawKey" in r) return this.fromRaw(r.rawKey);
        if ("derKey" in r) return this.fromDer(r.derKey);
        if ("toDer" in r) return this.fromDer(r.toDer());
      }
    }
    throw new Error("Cannot construct Ed25519PublicKey from the provided key.");
  }
  static fromRaw(e) {
    return new Ze(e);
  }
  static fromDer(e) {
    return new Ze(this.derDecode(e));
  }
  static derEncode(e) {
    const r = Za(e, Pn).buffer;
    return (r.__derEncodedPublicKey__ = void 0), r;
  }
  static derDecode(e) {
    const r = Qa(e, Pn);
    if (r.length !== this.RAW_KEY_LENGTH)
      throw new Error("An Ed25519 public key must be exactly 32bytes long");
    return r;
  }
  get rawKey() {
    return st(this, Yt, "f");
  }
  get derKey() {
    return st(this, Wt, "f");
  }
  toDer() {
    return this.derKey;
  }
  toRaw() {
    return this.rawKey;
  }
}
(Yt = new WeakMap()), (Wt = new WeakMap());
Ze.RAW_KEY_LENGTH = 32;
class at extends qr {
  constructor(e, r) {
    super(),
      xt.set(this, void 0),
      mt.set(this, void 0),
      Zt(this, xt, Ze.from(e), "f"),
      Zt(this, mt, new Uint8Array(r), "f");
  }
  static generate(e) {
    if (e && e.length !== 32)
      throw new Error("Ed25519 Seed needs to be 32 bytes long.");
    e || (e = St.utils.randomPrivateKey()),
      ti(e, new Uint8Array(new Array(32).fill(0))) &&
        console.warn(
          "Seed is all zeros. This is not a secure seed. Please provide a seed with sufficient entropy if this is a production environment.",
        );
    const r = new Uint8Array(32);
    for (let u = 0; u < 32; u++) r[u] = new Uint8Array(e)[u];
    const s = St.getPublicKey(r);
    return at.fromKeyPair(s, r);
  }
  static fromParsedJson(e) {
    const [r, s] = e;
    return new at(Ze.fromDer(ct(r)), ct(s));
  }
  static fromJSON(e) {
    const r = JSON.parse(e);
    if (Array.isArray(r)) {
      if (typeof r[0] == "string" && typeof r[1] == "string")
        return this.fromParsedJson([r[0], r[1]]);
      throw new Error(
        "Deserialization error: JSON must have at least 2 items.",
      );
    }
    throw new Error(
      `Deserialization error: Invalid JSON type for string: ${JSON.stringify(e)}`,
    );
  }
  static fromKeyPair(e, r) {
    return new at(Ze.fromRaw(e), r);
  }
  static fromSecretKey(e) {
    const r = St.getPublicKey(new Uint8Array(e));
    return at.fromKeyPair(r, e);
  }
  toJSON() {
    return [bt(st(this, xt, "f").toDer()), bt(st(this, mt, "f"))];
  }
  getKeyPair() {
    return { secretKey: st(this, mt, "f"), publicKey: st(this, xt, "f") };
  }
  getPublicKey() {
    return st(this, xt, "f");
  }
  async sign(e) {
    const r = new Uint8Array(e),
      s = Ut(St.sign(r, st(this, mt, "f").slice(0, 32)));
    return (
      Object.defineProperty(s, "__signature__", {
        enumerable: !1,
        value: void 0,
      }),
      s
    );
  }
  static verify(e, r, s) {
    const [u, d, g] = [e, r, s].map(
      (c) => (
        typeof c == "string" && (c = ct(c)),
        c instanceof Uint8Array && (c = c.buffer),
        new Uint8Array(c)
      ),
    );
    return St.verify(d, u, g);
  }
}
(xt = new WeakMap()), (mt = new WeakMap());
class sn extends Error {
  constructor(e) {
    super(e), (this.message = e), Object.setPrototypeOf(this, sn.prototype);
  }
}
function Hn(t) {
  if (typeof global < "u" && global.crypto && global.crypto.subtle)
    return global.crypto.subtle;
  if (t) return t;
  if (typeof crypto < "u" && crypto.subtle) return crypto.subtle;
  throw new sn(
    "Global crypto was not available and none was provided. Please inlcude a SubtleCrypto implementation. See https://developer.mozilla.org/en-US/docs/Web/API/SubtleCrypto",
  );
}
class Qt extends qr {
  constructor(e, r, s) {
    super(), (this._keyPair = e), (this._derKey = r), (this._subtleCrypto = s);
  }
  static async generate(e) {
    const {
        extractable: r = !1,
        keyUsages: s = ["sign", "verify"],
        subtleCrypto: u,
      } = e ?? {},
      d = Hn(u),
      g = await d.generateKey({ name: "ECDSA", namedCurve: "P-256" }, r, s),
      c = await d.exportKey("spki", g.publicKey);
    return new this(g, c, d);
  }
  static async fromKeyPair(e, r) {
    const s = Hn(r),
      u = await s.exportKey("spki", e.publicKey);
    return new Qt(e, u, s);
  }
  getKeyPair() {
    return this._keyPair;
  }
  getPublicKey() {
    const e = this._derKey,
      r = Object.create(this._keyPair.publicKey);
    return (
      (r.toDer = function () {
        return e;
      }),
      r
    );
  }
  async sign(e) {
    const r = { name: "ECDSA", hash: { name: "SHA-256" } };
    return await this._subtleCrypto.sign(r, this._keyPair.privateKey, e);
  }
}
var eu = function (t, e, r, s, u) {
    if (s === "m") throw new TypeError("Private method is not writable");
    if (s === "a" && !u)
      throw new TypeError("Private accessor was defined without a setter");
    if (typeof e == "function" ? t !== e || !u : !e.has(t))
      throw new TypeError(
        "Cannot write private member to an object whose class did not declare it",
      );
    return s === "a" ? u.call(t, r) : u ? (u.value = r) : e.set(t, r), r;
  },
  Tt = function (t, e, r, s) {
    if (r === "a" && !s)
      throw new TypeError("Private accessor was defined without a getter");
    if (typeof e == "function" ? t !== e || !s : !e.has(t))
      throw new TypeError(
        "Cannot read private member from an object whose class did not declare it",
      );
    return r === "m" ? s : r === "a" ? s.call(t) : s ? s.value : e.get(t);
  },
  it;
class tu {
  constructor(e) {
    it.set(this, void 0), eu(this, it, e, "f");
  }
  get rawKey() {
    return Tt(this, it, "f").rawKey;
  }
  get derKey() {
    return Tt(this, it, "f").derKey;
  }
  toDer() {
    return Tt(this, it, "f").toDer();
  }
  getPublicKey() {
    return Tt(this, it, "f");
  }
  getPrincipal() {
    return ut.from(Tt(this, it, "f").rawKey);
  }
  transformRequest() {
    return Promise.reject(
      "Not implemented. You are attempting to use a partial identity to sign calls, but this identity only has access to the public key.To sign calls, use a DelegationIdentity instead.",
    );
  }
}
it = new WeakMap();
var ru = function (t, e, r, s, u) {
    if (s === "m") throw new TypeError("Private method is not writable");
    if (s === "a" && !u)
      throw new TypeError("Private accessor was defined without a setter");
    if (typeof e == "function" ? t !== e || !u : !e.has(t))
      throw new TypeError(
        "Cannot write private member to an object whose class did not declare it",
      );
    return s === "a" ? u.call(t, r) : u ? (u.value = r) : e.set(t, r), r;
  },
  nu = function (t, e, r, s) {
    if (r === "a" && !s)
      throw new TypeError("Private accessor was defined without a getter");
    if (typeof e == "function" ? t !== e || !s : !e.has(t))
      throw new TypeError(
        "Cannot read private member from an object whose class did not declare it",
      );
    return r === "m" ? s : r === "a" ? s.call(t) : s ? s.value : e.get(t);
  },
  iu = function (t, e) {
    var r = {};
    for (var s in t)
      Object.prototype.hasOwnProperty.call(t, s) &&
        e.indexOf(s) < 0 &&
        (r[s] = t[s]);
    if (t != null && typeof Object.getOwnPropertySymbols == "function")
      for (var u = 0, s = Object.getOwnPropertySymbols(t); u < s.length; u++)
        e.indexOf(s[u]) < 0 &&
          Object.prototype.propertyIsEnumerable.call(t, s[u]) &&
          (r[s[u]] = t[s[u]]);
    return r;
  },
  Vt;
const su = new TextEncoder().encode("ic-request-auth-delegation"),
  ou = new TextEncoder().encode(`
ic-request`);
function mr(t) {
  if (typeof t != "string" || t.length < 64)
    throw new Error("Invalid public key.");
  return ct(t);
}
class on {
  constructor(e, r, s) {
    (this.pubkey = e), (this.expiration = r), (this.targets = s);
  }
  toCBOR() {
    return ke.value.map(
      Object.assign(
        {
          pubkey: ke.value.bytes(this.pubkey),
          expiration: ke.value.u64(this.expiration.toString(16), 16),
        },
        this.targets && {
          targets: ke.value.array(
            this.targets.map((e) => ke.value.bytes(e.toUint8Array())),
          ),
        },
      ),
    );
  }
  toJSON() {
    return Object.assign(
      { expiration: this.expiration.toString(16), pubkey: bt(this.pubkey) },
      this.targets && { targets: this.targets.map((e) => e.toHex()) },
    );
  }
}
async function au(t, e, r, s) {
  const u = new on(e.toDer(), BigInt(+r) * BigInt(1e6), s),
    d = new Uint8Array([...su, ...new Uint8Array(Vr(Object.assign({}, u)))]),
    g = await t.sign(d);
  return { delegation: u, signature: g };
}
class Ft {
  constructor(e, r) {
    (this.delegations = e), (this.publicKey = r);
  }
  static async create(e, r, s = new Date(Date.now() + 15 * 60 * 1e3), u = {}) {
    var d, g;
    const c = await au(e, r, s, u.targets);
    return new Ft(
      [
        ...(((d = u.previous) === null || d === void 0
          ? void 0
          : d.delegations) || []),
        c,
      ],
      ((g = u.previous) === null || g === void 0 ? void 0 : g.publicKey) ||
        e.getPublicKey().toDer(),
    );
  }
  static fromJSON(e) {
    const { publicKey: r, delegations: s } =
      typeof e == "string" ? JSON.parse(e) : e;
    if (!Array.isArray(s)) throw new Error("Invalid delegations.");
    const u = s.map((d) => {
      const { delegation: g, signature: c } = d,
        { pubkey: b, expiration: S, targets: N } = g;
      if (N !== void 0 && !Array.isArray(N))
        throw new Error("Invalid targets.");
      return {
        delegation: new on(
          mr(b),
          BigInt("0x" + S),
          N &&
            N.map((L) => {
              if (typeof L != "string") throw new Error("Invalid target.");
              return ut.fromHex(L);
            }),
        ),
        signature: mr(c),
      };
    });
    return new this(u, mr(r));
  }
  static fromDelegations(e, r) {
    return new this(e, r);
  }
  toJSON() {
    return {
      delegations: this.delegations.map((e) => {
        const { delegation: r, signature: s } = e,
          { targets: u } = r;
        return {
          delegation: Object.assign(
            { expiration: r.expiration.toString(16), pubkey: bt(r.pubkey) },
            u && { targets: u.map((d) => d.toHex()) },
          ),
          signature: bt(s),
        };
      }),
      publicKey: bt(this.publicKey),
    };
  }
}
class $n extends qr {
  constructor(e, r) {
    super(), (this._inner = e), (this._delegation = r);
  }
  static fromDelegation(e, r) {
    return new this(e, r);
  }
  getDelegation() {
    return this._delegation;
  }
  getPublicKey() {
    return {
      derKey: this._delegation.publicKey,
      toDer: () => this._delegation.publicKey,
    };
  }
  sign(e) {
    return this._inner.sign(e);
  }
  async transformRequest(e) {
    const { body: r } = e,
      s = iu(e, ["body"]),
      u = await Vr(r);
    return Object.assign(Object.assign({}, s), {
      body: {
        content: r,
        sender_sig: await this.sign(
          new Uint8Array([...ou, ...new Uint8Array(u)]),
        ),
        sender_delegation: this._delegation.delegations,
        sender_pubkey: this._delegation.publicKey,
      },
    });
  }
}
class er extends tu {
  constructor(e, r) {
    super(e), Vt.set(this, void 0), ru(this, Vt, r, "f");
  }
  get delegation() {
    return nu(this, Vt, "f");
  }
  static fromDelegation(e, r) {
    return new er(e, r);
  }
}
Vt = new WeakMap();
function $i(t, e) {
  for (const { delegation: s } of t.delegations)
    if (+new Date(Number(s.expiration / BigInt(1e6))) <= +Date.now()) return !1;
  const r = [];
  for (const s of r) {
    const u = s.toText();
    for (const { delegation: d } of t.delegations) {
      if (d.targets === void 0) continue;
      let g = !0;
      for (const c of d.targets)
        if (c.toText() === u) {
          g = !1;
          break;
        }
      if (g) return !1;
    }
  }
  return !0;
}
var zn;
(function (t) {
  t[(t.ECDSA_WITH_SHA256 = -7)] = "ECDSA_WITH_SHA256";
})(zn || (zn = {}));
const Kn = ["mousedown", "mousemove", "keydown", "touchstart", "wheel"];
class Yn {
  constructor(e = {}) {
    var r;
    (this.callbacks = []),
      (this.idleTimeout = 10 * 60 * 1e3),
      (this.timeoutID = void 0);
    const { onIdle: s, idleTimeout: u = 10 * 60 * 1e3 } = e || {};
    (this.callbacks = s ? [s] : []), (this.idleTimeout = u);
    const d = this._resetTimer.bind(this);
    window.addEventListener("load", d, !0),
      Kn.forEach(function (c) {
        document.addEventListener(c, d, !0);
      });
    const g = (c, b) => {
      let S;
      return (...N) => {
        const L = this,
          O = function () {
            (S = void 0), c.apply(L, N);
          };
        clearTimeout(S), (S = window.setTimeout(O, b));
      };
    };
    if (e?.captureScroll) {
      const c = g(
        d,
        (r = e?.scrollDebounce) !== null && r !== void 0 ? r : 100,
      );
      window.addEventListener("scroll", c, !0);
    }
    d();
  }
  static create(e = {}) {
    return new this(e);
  }
  registerCallback(e) {
    this.callbacks.push(e);
  }
  exit() {
    clearTimeout(this.timeoutID),
      window.removeEventListener("load", this._resetTimer, !0);
    const e = this._resetTimer.bind(this);
    Kn.forEach(function (r) {
      document.removeEventListener(r, e, !0);
    }),
      this.callbacks.forEach((r) => r());
  }
  _resetTimer() {
    const e = this.exit.bind(this);
    window.clearTimeout(this.timeoutID),
      (this.timeoutID = window.setTimeout(e, this.idleTimeout));
  }
}
const uu = (t, e) => e.some((r) => t instanceof r);
let Wn, Vn;
function cu() {
  return (
    Wn ||
    (Wn = [IDBDatabase, IDBObjectStore, IDBIndex, IDBCursor, IDBTransaction])
  );
}
function fu() {
  return (
    Vn ||
    (Vn = [
      IDBCursor.prototype.advance,
      IDBCursor.prototype.continue,
      IDBCursor.prototype.continuePrimaryKey,
    ])
  );
}
const zi = new WeakMap(),
  Cr = new WeakMap(),
  Ki = new WeakMap(),
  br = new WeakMap(),
  an = new WeakMap();
function hu(t) {
  const e = new Promise((r, s) => {
    const u = () => {
        t.removeEventListener("success", d), t.removeEventListener("error", g);
      },
      d = () => {
        r(ft(t.result)), u();
      },
      g = () => {
        s(t.error), u();
      };
    t.addEventListener("success", d), t.addEventListener("error", g);
  });
  return (
    e
      .then((r) => {
        r instanceof IDBCursor && zi.set(r, t);
      })
      .catch(() => {}),
    an.set(e, t),
    e
  );
}
function lu(t) {
  if (Cr.has(t)) return;
  const e = new Promise((r, s) => {
    const u = () => {
        t.removeEventListener("complete", d),
          t.removeEventListener("error", g),
          t.removeEventListener("abort", g);
      },
      d = () => {
        r(), u();
      },
      g = () => {
        s(t.error || new DOMException("AbortError", "AbortError")), u();
      };
    t.addEventListener("complete", d),
      t.addEventListener("error", g),
      t.addEventListener("abort", g);
  });
  Cr.set(t, e);
}
let kr = {
  get(t, e, r) {
    if (t instanceof IDBTransaction) {
      if (e === "done") return Cr.get(t);
      if (e === "objectStoreNames") return t.objectStoreNames || Ki.get(t);
      if (e === "store")
        return r.objectStoreNames[1]
          ? void 0
          : r.objectStore(r.objectStoreNames[0]);
    }
    return ft(t[e]);
  },
  set(t, e, r) {
    return (t[e] = r), !0;
  },
  has(t, e) {
    return t instanceof IDBTransaction && (e === "done" || e === "store")
      ? !0
      : e in t;
  },
};
function du(t) {
  kr = t(kr);
}
function pu(t) {
  return t === IDBDatabase.prototype.transaction &&
    !("objectStoreNames" in IDBTransaction.prototype)
    ? function (e, ...r) {
        const s = t.call(Er(this), e, ...r);
        return Ki.set(s, e.sort ? e.sort() : [e]), ft(s);
      }
    : fu().includes(t)
      ? function (...e) {
          return t.apply(Er(this), e), ft(zi.get(this));
        }
      : function (...e) {
          return ft(t.apply(Er(this), e));
        };
}
function wu(t) {
  return typeof t == "function"
    ? pu(t)
    : (t instanceof IDBTransaction && lu(t),
      uu(t, cu()) ? new Proxy(t, kr) : t);
}
function ft(t) {
  if (t instanceof IDBRequest) return hu(t);
  if (br.has(t)) return br.get(t);
  const e = wu(t);
  return e !== t && (br.set(t, e), an.set(e, t)), e;
}
const Er = (t) => an.get(t);
function yu(t, e, { blocked: r, upgrade: s, blocking: u, terminated: d } = {}) {
  const g = indexedDB.open(t, e),
    c = ft(g);
  return (
    s &&
      g.addEventListener("upgradeneeded", (b) => {
        s(ft(g.result), b.oldVersion, b.newVersion, ft(g.transaction), b);
      }),
    r && g.addEventListener("blocked", (b) => r(b.oldVersion, b.newVersion, b)),
    c
      .then((b) => {
        d && b.addEventListener("close", () => d()),
          u &&
            b.addEventListener("versionchange", (S) =>
              u(S.oldVersion, S.newVersion, S),
            );
      })
      .catch(() => {}),
    c
  );
}
const gu = ["get", "getKey", "getAll", "getAllKeys", "count"],
  xu = ["put", "add", "delete", "clear"],
  _r = new Map();
function qn(t, e) {
  if (!(t instanceof IDBDatabase && !(e in t) && typeof e == "string")) return;
  if (_r.get(e)) return _r.get(e);
  const r = e.replace(/FromIndex$/, ""),
    s = e !== r,
    u = xu.includes(r);
  if (
    !(r in (s ? IDBIndex : IDBObjectStore).prototype) ||
    !(u || gu.includes(r))
  )
    return;
  const d = async function (g, ...c) {
    const b = this.transaction(g, u ? "readwrite" : "readonly");
    let S = b.store;
    return (
      s && (S = S.index(c.shift())),
      (await Promise.all([S[r](...c), u && b.done]))[0]
    );
  };
  return _r.set(e, d), d;
}
du((t) => ({
  ...t,
  get: (e, r, s) => qn(e, r) || t.get(e, r, s),
  has: (e, r) => !!qn(e, r) || t.has(e, r),
}));
const Yi = "auth-client-db",
  Wi = "ic-keyval",
  mu = async (t = Yi, e = Wi, r) => (
    Vi &&
      localStorage != null &&
      localStorage.getItem(je) &&
      (localStorage.removeItem(je), localStorage.removeItem(ot)),
    await yu(t, r, {
      upgrade: (s) => {
        s.objectStoreNames.contains(e) && s.clear(e), s.createObjectStore(e);
      },
    })
  );
async function bu(t, e, r) {
  return await t.get(e, r);
}
async function Eu(t, e, r, s) {
  return await t.put(e, s, r);
}
async function _u(t, e, r) {
  return await t.delete(e, r);
}
class un {
  constructor(e, r) {
    (this._db = e), (this._storeName = r);
  }
  static async create(e) {
    const { dbName: r = Yi, storeName: s = Wi, version: u = Su } = e ?? {},
      d = await mu(r, s, u);
    return new un(d, s);
  }
  async set(e, r) {
    return await Eu(this._db, this._storeName, e, r);
  }
  async get(e) {
    var r;
    return (r = await bu(this._db, this._storeName, e)) !== null && r !== void 0
      ? r
      : null;
  }
  async remove(e) {
    return await _u(this._db, this._storeName, e);
  }
}
var Iu = function (t, e, r, s, u) {
    if (s === "m") throw new TypeError("Private method is not writable");
    if (s === "a" && !u)
      throw new TypeError("Private accessor was defined without a setter");
    if (typeof e == "function" ? t !== e || !u : !e.has(t))
      throw new TypeError(
        "Cannot write private member to an object whose class did not declare it",
      );
    return s === "a" ? u.call(t, r) : u ? (u.value = r) : e.set(t, r), r;
  },
  Au = function (t, e, r, s) {
    if (r === "a" && !s)
      throw new TypeError("Private accessor was defined without a getter");
    if (typeof e == "function" ? t !== e || !s : !e.has(t))
      throw new TypeError(
        "Cannot read private member from an object whose class did not declare it",
      );
    return r === "m" ? s : r === "a" ? s.call(t) : s ? s.value : e.get(t);
  },
  qt;
const ot = "identity",
  je = "delegation",
  Bu = "iv",
  Su = 1,
  Vi = typeof window < "u";
class Tu {
  constructor(e = "ic-", r) {
    (this.prefix = e), (this._localStorage = r);
  }
  get(e) {
    return Promise.resolve(this._getLocalStorage().getItem(this.prefix + e));
  }
  set(e, r) {
    return (
      this._getLocalStorage().setItem(this.prefix + e, r), Promise.resolve()
    );
  }
  remove(e) {
    return (
      this._getLocalStorage().removeItem(this.prefix + e), Promise.resolve()
    );
  }
  _getLocalStorage() {
    if (this._localStorage) return this._localStorage;
    const e =
      typeof window > "u"
        ? typeof global > "u"
          ? typeof self > "u"
            ? void 0
            : self.localStorage
          : global.localStorage
        : window.localStorage;
    if (!e) throw new Error("Could not find local storage.");
    return e;
  }
}
class qi {
  constructor(e) {
    qt.set(this, void 0), Iu(this, qt, e ?? {}, "f");
  }
  get _db() {
    return new Promise((e) => {
      if (this.initializedDb) {
        e(this.initializedDb);
        return;
      }
      un.create(Au(this, qt, "f")).then((r) => {
        (this.initializedDb = r), e(r);
      });
    });
  }
  async get(e) {
    return await (await this._db).get(e);
  }
  async set(e, r) {
    await (await this._db).set(e, r);
  }
  async remove(e) {
    await (await this._db).remove(e);
  }
}
qt = new WeakMap();
const Uu = "https://identity.ic0.app",
  Nu = "#authorize",
  Ir = "ECDSA",
  Ar = "Ed25519",
  Fu = 500,
  vu = "UserInterrupt";
class Ru {
  constructor(e, r, s, u, d, g, c, b) {
    (this._identity = e),
      (this._key = r),
      (this._chain = s),
      (this._storage = u),
      (this.idleManager = d),
      (this._createOptions = g),
      (this._idpWindow = c),
      (this._eventHandler = b),
      this._registerDefaultIdleCallback();
  }
  static async create(e = {}) {
    var r, s, u;
    const d = (r = e.storage) !== null && r !== void 0 ? r : new qi(),
      g = (s = e.keyType) !== null && s !== void 0 ? s : Ir;
    let c = null;
    if (e.identity) c = e.identity;
    else {
      let L = await d.get(ot);
      if (!L && Vi)
        try {
          const O = new Tu(),
            M = await O.get(je),
            q = await O.get(ot);
          M &&
            q &&
            g === Ir &&
            (console.log(
              "Discovered an identity stored in localstorage. Migrating to IndexedDB",
            ),
            await d.set(je, M),
            await d.set(ot, q),
            (L = M),
            await O.remove(je),
            await O.remove(ot));
        } catch (O) {
          console.error("error while attempting to recover localstorage: " + O);
        }
      if (L)
        try {
          typeof L == "object"
            ? g === Ar && typeof L == "string"
              ? (c = await at.fromJSON(L))
              : (c = await Qt.fromKeyPair(L))
            : typeof L == "string" && (c = at.fromJSON(L));
        } catch {}
    }
    let b = new bn(),
      S = null;
    if (c)
      try {
        const L = await d.get(je);
        if (typeof L == "object" && L !== null)
          throw new Error(
            "Delegation chain is incorrectly stored. A delegation chain should be stored as a string.",
          );
        e.identity
          ? (b = e.identity)
          : L &&
            ((S = Ft.fromJSON(L)),
            $i(S)
              ? "toDer" in c
                ? (b = er.fromDelegation(c, S))
                : (b = $n.fromDelegation(c, S))
              : (await Br(d), (c = null)));
      } catch (L) {
        console.error(L), await Br(d), (c = null);
      }
    let N;
    return (
      !((u = e.idleOptions) === null || u === void 0) && u.disableIdle
        ? (N = void 0)
        : (S || e.identity) && (N = Yn.create(e.idleOptions)),
      c ||
        (g === Ar
          ? ((c = await at.generate()),
            await d.set(ot, JSON.stringify(c.toJSON())))
          : (e.storage &&
              g === Ir &&
              console.warn(
                `You are using a custom storage provider that may not support CryptoKey storage. If you are using a custom storage provider that does not support CryptoKey storage, you should use '${Ar}' as the key type, as it can serialize to a string`,
              ),
            (c = await Qt.generate()),
            await d.set(ot, c.getKeyPair()))),
      new this(b, c, S, d, N, e)
    );
  }
  _registerDefaultIdleCallback() {
    var e, r;
    const s =
      (e = this._createOptions) === null || e === void 0
        ? void 0
        : e.idleOptions;
    !s?.onIdle &&
      !s?.disableDefaultIdleCallback &&
      ((r = this.idleManager) === null ||
        r === void 0 ||
        r.registerCallback(() => {
          this.logout(), location.reload();
        }));
  }
  async _handleSuccess(e, r) {
    var s, u;
    const d = e.delegations.map((S) => ({
        delegation: new on(
          S.delegation.pubkey,
          S.delegation.expiration,
          S.delegation.targets,
        ),
        signature: S.signature.buffer,
      })),
      g = Ft.fromDelegations(d, e.userPublicKey.buffer),
      c = this._key;
    if (!c) return;
    (this._chain = g),
      "toDer" in c
        ? (this._identity = er.fromDelegation(c, this._chain))
        : (this._identity = $n.fromDelegation(c, this._chain)),
      (s = this._idpWindow) === null || s === void 0 || s.close();
    const b =
      (u = this._createOptions) === null || u === void 0
        ? void 0
        : u.idleOptions;
    !this.idleManager &&
      !b?.disableIdle &&
      ((this.idleManager = Yn.create(b)), this._registerDefaultIdleCallback()),
      this._removeEventListener(),
      delete this._idpWindow,
      this._chain &&
        (await this._storage.set(je, JSON.stringify(this._chain.toJSON()))),
      r?.(e);
  }
  getIdentity() {
    return this._identity;
  }
  async isAuthenticated() {
    return (
      !this.getIdentity().getPrincipal().isAnonymous() && this._chain !== null
    );
  }
  async login(e) {
    var r, s, u, d;
    const g = BigInt(8) * BigInt(36e11),
      c = new URL(
        ((r = e?.identityProvider) === null || r === void 0
          ? void 0
          : r.toString()) || Uu,
      );
    (c.hash = Nu),
      (s = this._idpWindow) === null || s === void 0 || s.close(),
      this._removeEventListener(),
      (this._eventHandler = this._getEventHandler(
        c,
        Object.assign(
          {
            maxTimeToLive:
              (u = e?.maxTimeToLive) !== null && u !== void 0 ? u : g,
          },
          e,
        ),
      )),
      window.addEventListener("message", this._eventHandler),
      (this._idpWindow =
        (d = window.open(
          c.toString(),
          "idpWindow",
          e?.windowOpenerFeatures,
        )) !== null && d !== void 0
          ? d
          : void 0);
    const b = () => {
      this._idpWindow &&
        (this._idpWindow.closed
          ? this._handleFailure(vu, e?.onError)
          : setTimeout(b, Fu));
    };
    b();
  }
  _getEventHandler(e, r) {
    return async (s) => {
      var u, d, g;
      if (s.origin !== e.origin) return;
      const c = s.data;
      switch (c.kind) {
        case "authorize-ready": {
          const b = Object.assign(
            {
              kind: "authorize-client",
              sessionPublicKey: new Uint8Array(
                (u = this._key) === null || u === void 0
                  ? void 0
                  : u.getPublicKey().toDer(),
              ),
              maxTimeToLive: r?.maxTimeToLive,
              allowPinAuthentication: r?.allowPinAuthentication,
              derivationOrigin:
                (d = r?.derivationOrigin) === null || d === void 0
                  ? void 0
                  : d.toString(),
            },
            r?.customValues,
          );
          (g = this._idpWindow) === null ||
            g === void 0 ||
            g.postMessage(b, e.origin);
          break;
        }
        case "authorize-client-success":
          try {
            await this._handleSuccess(c, r?.onSuccess);
          } catch (b) {
            this._handleFailure(b.message, r?.onError);
          }
          break;
        case "authorize-client-failure":
          this._handleFailure(c.text, r?.onError);
          break;
      }
    };
  }
  _handleFailure(e, r) {
    var s;
    (s = this._idpWindow) === null || s === void 0 || s.close(),
      r?.(e),
      this._removeEventListener(),
      delete this._idpWindow;
  }
  _removeEventListener() {
    this._eventHandler &&
      window.removeEventListener("message", this._eventHandler),
      (this._eventHandler = void 0);
  }
  async logout(e = {}) {
    if (
      (await Br(this._storage),
      (this._identity = new bn()),
      (this._chain = null),
      e.returnTo)
    )
      try {
        window.history.pushState({}, "", e.returnTo);
      } catch {
        window.location.href = e.returnTo;
      }
  }
}
async function Br(t) {
  await t.remove(ot), await t.remove(je), await t.remove(Bu);
}
const Lu = () =>
  Ru.create({
    idleOptions: { disableIdle: !0, disableDefaultIdleCallback: !0 },
  });
onmessage = ({ data: t }) => {
  const { msg: e } = t;
  switch (e) {
    case "startIdleTimer":
      Ou();
      return;
    case "stopIdleTimer":
      Ji();
      return;
  }
};
let Jt;
const Ou = () => (Jt = setInterval(async () => await Du(), ws)),
  Ji = () => {
    Jt && (clearInterval(Jt), (Jt = void 0));
  },
  Du = async () => {
    const [t, e] = await Promise.all([Mu(), Pu()]);
    if (t && e.valid && e.delegation !== null) {
      ku(e.delegation);
      return;
    }
    Cu();
  },
  Mu = async () => (await Lu()).isAuthenticated(),
  Pu = async () => {
    const e = await new qi().get(je),
      r = e !== null ? Ft.fromJSON(e) : null;
    return { valid: r !== null && $i(r), delegation: r };
  },
  Cu = () => {
    Ji(), postMessage({ msg: "signOutIdleTimer" });
  },
  ku = (t) => {
    const e = t.delegations[0]?.delegation.expiration;
    if (e === void 0) return;
    const r = new Date(Number(e / BigInt(1e6))).getTime() - Date.now();
    postMessage({
      msg: "delegationRemainingTime",
      data: { authRemainingTime: r },
    });
  };
