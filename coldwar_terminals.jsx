import { useState, useRef, useEffect } from "react";

const themes = {
  pipboy: {
    name: "PIP-BOY",
    sub: "Vault-Tec // 2077",
    bg: "#0B0F07",
    cardBg: "#0E1309",
    headerBg: "#080C05",
    border: "#1A2412",
    primary: "#30D43A",
    primaryDim: "#22952A",
    secondary: "#1E7A24",
    muted: "#14501A",
    text: "#28C030",
    textDim: "#1E7A24",
    accent: "#D4AA20",
    danger: "#E83020",
    glow: "rgba(48,212,58,0.05)",
    scanline: "rgba(0,0,0,0.14)",
    userBorder: "#1A6A20",
    aiBorder: "#22882A",
  },
  bunker: {
    name: "BUNKER CONSOLE",
    sub: "NORAD // 1962",
    bg: "#080A06",
    cardBg: "#0C0E08",
    headerBg: "#060804",
    border: "#1C2218",
    primary: "#7CAA6A",
    primaryDim: "#5A8048",
    secondary: "#486A3A",
    muted: "#2A4022",
    text: "#6A9858",
    textDim: "#486A3A",
    accent: "#C89840",
    danger: "#C85030",
    glow: "rgba(124,170,106,0.03)",
    scanline: "rgba(0,0,0,0.10)",
    userBorder: "#3A5A2E",
    aiBorder: "#486A38",
  },
  fallout: {
    name: "WASTELAND",
    sub: "Post-Nuclear // 2287",
    bg: "#0E0C06",
    cardBg: "#121008",
    headerBg: "#0A0804",
    border: "#28221A",
    primary: "#88B44A",
    primaryDim: "#6A8A38",
    secondary: "#587028",
    muted: "#3A4A1A",
    text: "#80A844",
    textDim: "#587028",
    accent: "#D08830",
    danger: "#D04828",
    glow: "rgba(136,180,74,0.04)",
    scanline: "rgba(0,0,0,0.12)",
    userBorder: "#4A6020",
    aiBorder: "#5A7028",
  },
  soviet: {
    name: "SOVIET TERMINAL",
    sub: "Elbrus-2 // CCCP 1985",
    bg: "#0A0A08",
    cardBg: "#0E0E0A",
    headerBg: "#070706",
    border: "#20201A",
    primary: "#68A868",
    primaryDim: "#4A804A",
    secondary: "#3A6A3A",
    muted: "#284428",
    text: "#5C9A5C",
    textDim: "#3A6A3A",
    accent: "#B89838",
    danger: "#B84A38",
    glow: "rgba(104,168,104,0.03)",
    scanline: "rgba(0,0,0,0.18)",
    userBorder: "#305830",
    aiBorder: "#3A6A3A",
  },
};

const MiniPhone = ({ themeKey }) => {
  const t = themes[themeKey];
  const ref = useRef(null);

  useEffect(() => {
    ref.current?.scrollIntoView({ behavior: "smooth" });
  }, []);

  return (
    <div style={{ display: "flex", flexDirection: "column", alignItems: "center" }}>
      {/* Label */}
      <div style={{
        marginBottom: "6px", padding: "4px 12px",
        background: t.headerBg, borderRadius: "4px",
        border: `1px solid ${t.border}`,
        textAlign: "center",
      }}>
        <div style={{ color: t.primary, fontSize: "10px", letterSpacing: "2px", fontWeight: "bold" }}>
          {t.name}
        </div>
        <div style={{ color: t.muted, fontSize: "8px", letterSpacing: "1px", marginTop: "1px" }}>
          {t.sub}
        </div>
      </div>

      {/* Phone */}
      <div style={{
        width: "300px", height: "640px",
        background: t.bg,
        borderRadius: "28px", border: `3px solid ${t.border}`,
        overflow: "hidden", display: "flex", flexDirection: "column",
        boxShadow: `0 6px 30px rgba(0,0,0,0.6), 0 0 50px ${t.glow}`,
        position: "relative",
        fontFamily: "'Space Mono', monospace",
      }}>
        {/* Scanlines */}
        <div style={{
          position: "absolute", top: 0, left: 0, right: 0, bottom: 0,
          background: `repeating-linear-gradient(0deg, transparent, transparent 2px, ${t.scanline} 2px, ${t.scanline} 3px)`,
          pointerEvents: "none", zIndex: 6,
        }} />
        {/* CRT glow */}
        <div style={{
          position: "absolute", top: 0, left: 0, right: 0, bottom: 0,
          background: `radial-gradient(ellipse at center, ${t.glow} 0%, transparent 65%)`,
          pointerEvents: "none", zIndex: 4,
        }} />
        {/* Vignette */}
        <div style={{
          position: "absolute", top: 0, left: 0, right: 0, bottom: 0,
          background: "radial-gradient(ellipse at center, transparent 60%, rgba(0,0,0,0.4) 100%)",
          pointerEvents: "none", zIndex: 5,
        }} />

        {/* Status Bar */}
        <div style={{
          padding: "8px 14px 3px", display: "flex",
          justifyContent: "space-between", alignItems: "center",
          fontSize: "9px", color: t.muted, background: t.headerBg,
        }}>
          <span style={{ fontWeight: "bold", letterSpacing: "1px" }}>14:33</span>
          <div style={{ display: "flex", gap: "6px", alignItems: "center" }}>
            <span style={{
              background: t.border, color: t.primaryDim,
              padding: "1px 5px", borderRadius: "2px",
              fontSize: "7px", letterSpacing: "1px",
            }}>OFFLINE</span>
            <span style={{ letterSpacing: "1px", fontSize: "8px", color: t.muted }}>87%</span>
          </div>
        </div>

        {/* Header */}
        <div style={{
          background: t.headerBg,
          padding: "5px 10px 7px",
          borderBottom: `1px solid ${t.border}`,
        }}>
          <div style={{
            display: "flex", justifyContent: "space-between",
            alignItems: "center", marginBottom: "5px",
          }}>
            <span style={{ color: t.muted, fontSize: "10px", fontWeight: "bold" }}>[=]</span>
            <div style={{ textAlign: "center" }}>
              <div style={{
                fontSize: "11px", letterSpacing: "2px", color: t.primary, fontWeight: "bold",
                textShadow: `0 0 8px ${t.glow}`,
              }}>
                HAVEN PROTOCOL
              </div>
              <div style={{ fontSize: "7px", letterSpacing: "1px", color: t.muted, marginTop: "1px" }}>
                SURVIVAL AI // OFFLINE
              </div>
            </div>
            <span style={{
              color: t.danger, fontSize: "10px", fontWeight: "bold",
              textShadow: `0 0 6px rgba(232,48,32,0.4)`,
              animation: "sosPulse 2s infinite",
            }}>[!]SOS</span>
          </div>

          <div style={{
            display: "flex", justifyContent: "space-between",
            alignItems: "center", padding: "3px 6px",
            background: t.bg, borderRadius: "2px",
            border: `1px solid ${t.border}`,
          }}>
            <span style={{ color: t.primaryDim, fontSize: "9px", letterSpacing: "1px", fontWeight: "bold" }}>
              SORU: 3/20
            </span>
            <span style={{
              color: t.accent, fontSize: "7px", fontWeight: "bold",
              letterSpacing: "1px",
            }}>[*] PRO</span>
          </div>
        </div>

        {/* Chat */}
        <div style={{
          flex: 1, overflowY: "auto", padding: "5px 8px",
          background: t.bg,
          display: "flex", flexDirection: "column", gap: "5px",
        }}>
          <div style={{
            textAlign: "center", padding: "3px",
            color: t.muted, fontSize: "7px", letterSpacing: "1px",
            border: `1px solid ${t.border}`, background: t.cardBg,
            borderRadius: "2px",
          }}>
            ══ TÜM VERİLER OFFLINE ══
          </div>

          {/* AI Welcome */}
          <div style={{ width: "100%" }}>
            <div style={{
              fontSize: "7px", color: t.secondary, letterSpacing: "1px",
              marginBottom: "1px", fontWeight: "bold",
              display: "flex", justifyContent: "space-between",
            }}>
              <span>HAVEN://</span>
              <span style={{ color: t.muted, fontWeight: "normal" }}>[14:32]</span>
            </div>
            <div style={{
              padding: "6px 8px", width: "100%", boxSizing: "border-box",
              borderLeft: `2px solid ${t.aiBorder}`,
              background: t.cardBg,
              color: t.text, fontSize: "11px", lineHeight: "1.5",
              borderRadius: "0 3px 3px 0",
            }}>
              Haven Protocol aktif.{"\n"}Durumunuzu anlatın.
            </div>
          </div>

          {/* User */}
          <div style={{ width: "100%" }}>
            <div style={{
              fontSize: "7px", color: t.secondary, letterSpacing: "1px",
              marginBottom: "1px", fontWeight: "bold",
              display: "flex", justifyContent: "space-between",
            }}>
              <span>KULLANICI@~$</span>
              <span style={{ color: t.muted, fontWeight: "normal" }}>[14:33]</span>
            </div>
            <div style={{
              padding: "6px 8px", width: "100%", boxSizing: "border-box",
              borderLeft: `2px solid ${t.userBorder}`,
              background: t.cardBg,
              color: t.text, fontSize: "11px", lineHeight: "1.5",
              borderRadius: "0 3px 3px 0",
            }}>
              Deprem oldu ne yapmalıyım?
            </div>
          </div>

          {/* AI Response */}
          <div style={{ width: "100%" }}>
            <div style={{
              fontSize: "7px", color: t.secondary, letterSpacing: "1px",
              marginBottom: "1px", fontWeight: "bold",
              display: "flex", justifyContent: "space-between",
            }}>
              <span>HAVEN://</span>
              <span style={{ color: t.muted, fontWeight: "normal" }}>[14:33]</span>
            </div>
            <div style={{
              padding: "6px 8px", width: "100%", boxSizing: "border-box",
              borderLeft: `2px solid ${t.aiBorder}`,
              background: t.cardBg,
              color: t.text, fontSize: "11px", lineHeight: "1.65",
              borderRadius: "0 3px 3px 0",
            }}>
              <div style={{ marginBottom: "8px" }}>
                <span style={{ color: t.danger, fontWeight: "bold", fontSize: "13px", textShadow: `0 0 4px ${t.danger}40` }}>▲ ACİL:</span>{" "}
                Hemen <span style={{ color: t.danger, fontWeight: "bold" }}>ÇÖK-KAPAN-TUTUN</span>
              </div>

              <div style={{ marginBottom: "4px" }}>
                <span style={{ color: t.primary, fontWeight: "bold", fontSize: "13px" }}>» PROTOKOL:</span>
              </div>
              {["Yere çökün, masa altına girin",
                "Başınızı kollarınızla koruyun",
                "Sarsıntı durana kadar kalın",
                "Camlardan uzak durun",
                "Binayı sakin terk edin",
              ].map((s, i) => (
                <div key={i} style={{ marginBottom: "3px", paddingLeft: "3px" }}>
                  <span style={{ color: t.primary, fontWeight: "bold" }}>{String(i+1).padStart(2,"0")}.</span> {s}
                </div>
              ))}
              <div style={{ marginBottom: "8px", paddingLeft: "3px" }}>
                <span style={{ color: t.primary, fontWeight: "bold" }}>06.</span>{" "}
                <span style={{ color: t.danger, fontWeight: "bold" }}>Asansör kullanmayın</span>
              </div>

              <div style={{ marginBottom: "4px" }}>
                <span style={{ color: t.accent, fontWeight: "bold", fontSize: "13px" }}>◆ KRİTİK:</span>
              </div>
              <div style={{ marginBottom: "3px", paddingLeft: "3px" }}>
                <span style={{ color: t.accent, fontWeight: "bold" }}>—</span> Artçılar ilk{" "}
                <span style={{ color: t.accent, fontWeight: "bold" }}>48 saat</span> sürebilir
              </div>
              <div style={{ marginBottom: "3px", paddingLeft: "3px" }}>
                <span style={{ color: t.accent, fontWeight: "bold" }}>—</span> Gaz kokusu →{" "}
                <span style={{ color: t.danger, fontWeight: "bold" }}>ateş kullanmayın</span>
              </div>
              <div style={{ paddingLeft: "3px" }}>
                <span style={{ color: t.accent, fontWeight: "bold" }}>—</span> Binalardan min.{" "}
                <span style={{ color: t.accent, fontWeight: "bold" }}>10m</span> uzak durun
              </div>
              <span style={{ color: t.primary, animation: "blink 1s step-end infinite", marginLeft: "2px" }}>█</span>
            </div>
          </div>

          <div ref={ref} />
        </div>

        {/* Disclaimer */}
        <div style={{
          padding: "2px 10px", background: t.headerBg,
          borderTop: `1px solid ${t.border}`, textAlign: "center",
        }}>
          <span style={{ color: t.muted, fontSize: "6px", letterSpacing: "0.5px" }}>
            [+] BU BİLGİ PROFESYONEL YARDIMIN YERİNİ ALMAZ
          </span>
        </div>

        {/* Input */}
        <div style={{
          background: t.headerBg, borderTop: `1px solid ${t.border}`,
          padding: "5px 8px 18px",
        }}>
          <div style={{
            display: "flex", alignItems: "center",
            background: t.cardBg, borderRadius: "3px",
            border: `1px solid ${t.border}`, overflow: "hidden",
          }}>
            <div style={{
              padding: "7px 4px 7px 7px",
              color: t.primary, fontSize: "11px", fontWeight: "bold",
            }}>{">"}</div>
            <input type="text" readOnly
              placeholder="Durumunuzu anlatın..."
              style={{
                background: "transparent", border: "none", outline: "none",
                color: t.text, fontSize: "11px",
                fontFamily: "'Space Mono', monospace", width: "100%",
                padding: "7px 0",
              }}
            />
            <div style={{
              background: t.bg, padding: "7px 10px",
              color: t.muted, fontSize: "11px",
            }}>▶</div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default function ColdWarTerminals() {
  return (
    <div style={{
      display: "flex", justifyContent: "center", alignItems: "flex-start",
      gap: "20px", minHeight: "100vh",
      background: "#050505",
      padding: "20px", flexWrap: "wrap",
      fontFamily: "'Space Mono', monospace",
    }}>
      <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&display=swap" rel="stylesheet" />

      <MiniPhone themeKey="pipboy" />
      <MiniPhone themeKey="bunker" />
      <MiniPhone themeKey="fallout" />
      <MiniPhone themeKey="soviet" />

      <style>{`
        @keyframes blink {
          0%, 100% { opacity: 1; }
          50% { opacity: 0; }
        }
        @keyframes sosPulse {
          0%, 100% { opacity: 1; }
          50% { opacity: 0.7; }
        }
        ::-webkit-scrollbar { width: 2px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #222; border-radius: 2px; }
        input::placeholder { color: inherit; opacity: 0.3; font-family: 'Space Mono', monospace; }
      `}</style>
    </div>
  );
}
