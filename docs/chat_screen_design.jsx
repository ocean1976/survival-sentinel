import { useState, useRef, useEffect } from "react";

const PhoneScreen = ({ isDark, label }) => {
  const messagesEndRef = useRef(null);
  const [typingVisible, setTypingVisible] = useState(true);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, []);

  const t = isDark ? {
    phoneBg: "#080A06",
    phoneBorder: "#1C2218",
    statusBg: "#060804",
    statusText: "#3A4A32",
    offlineBg: "#1C2218",
    offlineText: "#5A8048",
    headerBg: "#060804",
    headerBorder: "#1C2218",
    headerTitle: "#7CAA6A",
    headerSub: "#2A4022",
    btnBg: "#0E120A",
    btnBorder: "#1C2218",
    btnText: "#486A3A",
    infoBg: "#080A06",
    infoBorder: "#1C2218",
    infoText: "#5A8048",
    chatBg: "#080A06",
    bannerBg: "#0C0E08",
    bannerBorder: "#1C2218",
    bannerText: "#2A4022",
    aiLabel: "#486A38",
    userLabel: "#3A5A2E",
    timeText: "#2A4022",
    aiBorderL: "#486A38",
    userBorderL: "#3A5A2E",
    aiBg: "#0C0E08",
    userBg: "#0A0C07",
    msgText: "#6A9858",
    msgTextDim: "#486A3A",
    acilColor: "#C85030",
    protokolColor: "#7CAA6A",
    kritikColor: "#C89840",
    cursorColor: "#7CAA6A",
    disclaimerBg: "#060804",
    disclaimerBorder: "#1C2218",
    disclaimerText: "#2A4022",
    inputBg: "#060804",
    inputFieldBg: "#0C0E08",
    inputBorder: "#1C2218",
    inputPrompt: "#7CAA6A",
    inputText: "#6A9858",
    inputPlaceholder: "#2A4022",
    sendBg: "#0E120A",
    sendText: "#2A4022",
    sosBg: "linear-gradient(180deg, #8A3A28 0%, #6A2A1A 100%)",
    sosBorder: "#5A2218",
    sosText: "#CC8070",
    sosShadow: "0 2px 6px rgba(138,58,40,0.3)",
    sosAnim: "none",
    premiumGold: "#C89840",
    premiumGoldDark: "#8A6A20",
    dividerColor: "#1C2218",
    sosLabel: "#C85030",
    footerText: "#3A4A32",
  } : {
    phoneBg: "#B8C0B4",
    phoneBorder: "#868E82",
    statusBg: "#ACB4A8",
    statusText: "#4A5646",
    offlineBg: "#3D4F35",
    offlineText: "#A8B89A",
    headerBg: "#A8B2A4",
    headerBorder: "#868E82",
    headerTitle: "#283826",
    headerSub: "#5A6A56",
    btnBg: "#9EA89A",
    btnBorder: "#868E82",
    btnText: "#3A4A36",
    infoBg: "#9EA89A",
    infoBorder: "#8A9486",
    infoText: "#3A4A36",
    chatBg: "#C5CCC4",
    bannerBg: "#B6BEB0",
    bannerBorder: "#A8B0A4",
    bannerText: "#5E6E56",
    aiLabel: "#74603A",
    userLabel: "#566054",
    timeText: "#8A9484",
    aiBorderL: "#887244",
    userBorderL: "#6A8A5A",
    aiBg: "#E1E2DE",
    userBg: "#D5DCD6",
    msgText: "#2A3428",
    msgTextDim: "#5A6A56",
    acilColor: "#9B1B1B",
    protokolColor: "#3D6B35",
    kritikColor: "#D67B37",
    cursorColor: "#3D6B35",
    disclaimerBg: "#AAB2A4",
    disclaimerBorder: "#929A8E",
    disclaimerText: "#566054",
    inputBg: "#ACB4A8",
    inputFieldBg: "#CCD2C6",
    inputBorder: "#929A8E",
    inputPrompt: "#3D6B35",
    inputText: "#2A3428",
    inputPlaceholder: "#6A7A66",
    sendBg: "#A4AE9E",
    sendText: "#6A7A66",
    sosBg: "linear-gradient(180deg, #C0392B 0%, #A93226 100%)",
    sosBorder: "#E74C3C",
    sosText: "#FFFFFF",
    sosShadow: "0 2px 8px rgba(192,57,43,0.5)",
    sosAnim: "sosPulse 2s infinite",
    premiumGold: "#C9A227",
    premiumGoldDark: "#8B6914",
    dividerColor: "#A8B0A4",
    sosLabel: "#C0392B",
    footerText: "#5A6A56",
  };

  return (
    <div style={{ display: "flex", flexDirection: "column", alignItems: "center" }}>
      <div style={{
        marginBottom: "8px", padding: "4px 14px",
        background: isDark ? "#0A0C06" : "#2A3C28",
        borderRadius: "4px",
        border: isDark ? `1px solid ${t.dividerColor}` : "none",
        color: isDark ? "#7CAA6A" : "#A8B89A",
        fontSize: "11px", letterSpacing: "2px", fontWeight: "bold",
      }}>
        {label}
      </div>

      <div style={{
        width: "360px", height: "740px",
        background: t.phoneBg,
        borderRadius: "32px", border: `3px solid ${t.phoneBorder}`,
        overflow: "hidden", display: "flex", flexDirection: "column",
        boxShadow: isDark
          ? "0 8px 40px rgba(0,0,0,0.7), 0 0 60px rgba(124,170,106,0.02)"
          : "0 6px 30px rgba(0,0,0,0.3)",
        position: "relative",
        fontFamily: "'Space Mono', monospace",
      }}>
        {/* Effects */}
        {isDark && (
          <>
            <div style={{
              position: "absolute", top: 0, left: 0, right: 0, bottom: 0,
              background: "repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(0,0,0,0.08) 2px, rgba(0,0,0,0.08) 3px)",
              pointerEvents: "none", zIndex: 6,
            }} />
            <div style={{
              position: "absolute", top: 0, left: 0, right: 0, bottom: 0,
              background: "radial-gradient(ellipse at center, rgba(124,170,106,0.025) 0%, transparent 65%)",
              pointerEvents: "none", zIndex: 4,
            }} />
            <div style={{
              position: "absolute", top: 0, left: 0, right: 0, bottom: 0,
              background: "radial-gradient(ellipse at center, transparent 55%, rgba(0,0,0,0.3) 100%)",
              pointerEvents: "none", zIndex: 5,
            }} />
          </>
        )}
        {!isDark && (
          <div style={{
            position: "absolute", top: 0, left: 0, right: 0, bottom: 0,
            background: "repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(0,0,0,0.012) 2px, rgba(0,0,0,0.012) 3px)",
            pointerEvents: "none", zIndex: 6,
          }} />
        )}

        {/* Status Bar */}
        <div style={{
          padding: "10px 16px 3px", display: "flex",
          justifyContent: "space-between", alignItems: "center",
          fontSize: "10px", color: t.statusText, background: t.statusBg,
        }}>
          <span style={{ fontWeight: "bold", letterSpacing: "1px" }}>14:33 UTC</span>
          <div style={{ display: "flex", gap: "6px", alignItems: "center" }}>
            <span style={{
              background: t.offlineBg, color: t.offlineText,
              padding: "1px 5px", borderRadius: "2px",
              fontSize: "8px", letterSpacing: "1px",
            }}>OFFLINE</span>
            <span style={{ letterSpacing: "1px", fontSize: "9px" }}>BAT:87%</span>
          </div>
        </div>

        {/* Header */}
        <div style={{
          background: t.headerBg,
          padding: "6px 12px 8px",
          borderBottom: `2px solid ${t.headerBorder}`,
        }}>
          <div style={{
            display: "flex", justifyContent: "space-between",
            alignItems: "center", marginBottom: "6px",
          }}>
            <button style={{
              background: t.btnBg, border: `1px solid ${t.btnBorder}`,
              borderRadius: "4px", padding: "3px 7px", color: t.btnText,
              fontSize: "11px", fontWeight: "bold", fontFamily: "'Space Mono', monospace",
            }}>[=]</button>

            <div style={{ textAlign: "center" }}>
              <div style={{
                fontSize: "12px", letterSpacing: "2px", color: t.headerTitle, fontWeight: "bold",
                textShadow: isDark ? "0 0 8px rgba(124,170,106,0.12)" : "none",
              }}>
                HAVEN PROTOCOL
              </div>
              <div style={{ fontSize: "8px", letterSpacing: "1px", color: t.headerSub, marginTop: "1px" }}>
                {isDark ? "SOS // BUNKER MODE" : "SURVIVAL AI // OFFLINE"}
              </div>
            </div>

            <button style={{
              background: t.sosBg,
              border: `1px solid ${t.sosBorder}`,
              borderRadius: "4px", padding: "3px 8px",
              color: t.sosText,
              fontSize: "11px", fontWeight: "bold",
              fontFamily: "'Space Mono', monospace",
              letterSpacing: "1px",
              boxShadow: t.sosShadow,
              animation: t.sosAnim,
            }}>[!] SOS</button>
          </div>

          <div style={{
            display: "flex", justifyContent: isDark ? "flex-start" : "space-between",
            alignItems: "center", padding: "4px 8px",
            background: t.infoBg,
            borderRadius: "3px", border: `1px solid ${t.infoBorder}`,
          }}>
            {isDark ? (
              <span style={{ color: t.sosLabel, fontSize: "10px", letterSpacing: "1px", fontWeight: "bold" }}>
                [!] SOS AKTİF — 71:58:42
              </span>
            ) : (
              <>
                <span style={{ color: t.infoText, fontSize: "10px", letterSpacing: "1px", fontWeight: "bold" }}>
                  SORU: 3/20
                </span>
                <span style={{
                  background: `linear-gradient(90deg, ${t.premiumGoldDark} 0%, ${t.premiumGold} 100%)`,
                  padding: "2px 8px", borderRadius: "2px",
                  color: "#FFFFFF", fontSize: "8px", fontWeight: "bold",
                  fontFamily: "'Space Mono', monospace", letterSpacing: "1px",
                }}>[*] PREMIUM</span>
              </>
            )}
          </div>
        </div>

        {/* ===== CHAT AREA ===== */}
        <div style={{
          flex: 1, overflowY: "auto", padding: "8px 10px",
          background: t.chatBg,
          display: "flex", flexDirection: "column", gap: "10px",
        }}>
          {/* Offline banner */}
          <div style={{
            textAlign: "center", padding: "4px 8px",
            color: t.bannerText, fontSize: "8px", letterSpacing: "1px",
            border: `1px solid ${t.bannerBorder}`, background: t.bannerBg,
            borderRadius: "2px",
          }}>
            ══ TÜM VERİLER CİHAZDA — İNTERNET GEREKMİYOR ══
          </div>

          {/* ── MSG 1: AI Welcome ── */}
          <MsgBlock isDark={isDark} t={t} type="ai" time="14:32:18">
            <span>Haven Protocol aktif. Acil bir durum mu var?</span>
            <br /><span>Durumunuzu anlatın, adım adım yönlendireceğim.</span>
          </MsgBlock>

          {/* ── MSG 2: User question ── */}
          <MsgBlock isDark={isDark} t={t} type="user" time="14:33:04">
            Deprem oldu, binanın altında kaldım ne yapmalıyım?
          </MsgBlock>

          {/* ── MSG 3: AI Response — full protocol ── */}
          <MsgBlock isDark={isDark} t={t} type="ai" time="14:33:07">
            {/* ACİL */}
            <div style={{
              marginBottom: "12px",
              padding: "8px 10px",
              background: isDark ? "#1A0C08" : "#F5E8E4",
              borderRadius: "4px",
              border: `1px solid ${isDark ? "#3A1818" : "#E8C8C0"}`,
            }}>
              <span style={{ color: t.acilColor, fontWeight: "bold", fontSize: "14px" }}>▲ ACİL EYLEM</span>
              <div style={{ marginTop: "4px", lineHeight: "1.6" }}>
                Hareket etme. Seninleyim. Enerjini koru ve düzenli aralıklarla ses çıkar.
              </div>
            </div>

            {/* PROTOKOL */}
            <div style={{ marginBottom: "6px" }}>
              <span style={{ color: t.protokolColor, fontWeight: "bold", fontSize: "14px", letterSpacing: "1px" }}>
                » PROTOKOL
              </span>
            </div>

            <Step n="01" t={t}>Derin nefes al. Panik oksijen tüketir. Sakin kal.</Step>
            <Step n="02" t={t}>Telefonunun ışığını aç, etrafını kontrol et.</Step>
            <Step n="03" t={t}>Ağzını ve burnunu bezle kapat — toz soluma.</Step>
            <Step n="04" t={t}>Metal boru veya sert nesneye <Hl t={t}>3'er vuruş</Hl> yap.{"\n"}
              <span style={{ color: t.msgTextDim, fontSize: "11px" }}>↳ Kurtarma ekipleri ritmik sesleri dinler.</span>
            </Step>
            <Step n="05" t={t}>Bağırmayı <Danger t={t}>son çare</Danger> olarak kullan.</Step>
            <Step n="06" t={t}>Su bulursan küçük yudumlarla iç.</Step>
            <Step n="07" t={t}>Telefon pilini koru — gereksiz uygulamaları kapat.</Step>

            {/* Divider */}
            <div style={{
              margin: "10px 0", borderTop: `1px solid ${t.dividerColor}`,
            }} />

            {/* KRİTİK */}
            <div style={{ marginBottom: "6px" }}>
              <span style={{ color: t.kritikColor, fontWeight: "bold", fontSize: "14px" }}>◆ KRİTİK</span>
            </div>

            <Warn t={t}>Kibrit veya çakmak <Danger t={t}>KULLANMA</Danger> — gaz sızıntısı olabilir.</Warn>
            <Warn t={t}>Artçı sarsıntılar ilk <Hl t={t}>48 saat</Hl> devam edebilir.</Warn>
            <Warn t={t}>Zor bir durum, biliyorum. Ama insanlar bundan çıktı. Sen de çıkacaksın.</Warn>

            {/* Disclaimer */}
            <div style={{
              marginTop: "12px", padding: "6px 8px",
              background: isDark ? "#0A0C06" : "#D8DCD4",
              borderRadius: "3px",
              border: `1px solid ${t.dividerColor}`,
            }}>
              <span style={{ color: t.msgTextDim, fontSize: "10px" }}>
                ⚕️ Bu bilgi profesyonel yardımın yerini almaz.
              </span>
            </div>

            <span style={{ color: t.cursorColor, animation: "blink 1s step-end infinite" }}>█</span>
          </MsgBlock>

          {/* ── MSG 4: User follow-up ── */}
          <MsgBlock isDark={isDark} t={t} type="user" time="14:34:22">
            Ayağım sıkışmış çıkaramıyorum
          </MsgBlock>

          {/* ── MSG 5: AI follow-up ── */}
          <MsgBlock isDark={isDark} t={t} type="ai" time="14:34:25">
            <div style={{
              marginBottom: "12px",
              padding: "8px 10px",
              background: isDark ? "#1A0C08" : "#F5E8E4",
              borderRadius: "4px",
              border: `1px solid ${isDark ? "#3A1818" : "#E8C8C0"}`,
            }}>
              <span style={{ color: t.acilColor, fontWeight: "bold", fontSize: "14px" }}>▲ ACİL EYLEM</span>
              <div style={{ marginTop: "4px", lineHeight: "1.6" }}>
                Ayağını <Danger t={t}>zorla çekme</Danger>. Daha fazla hasar verebilirsin.
              </div>
            </div>

            <div style={{ marginBottom: "6px" }}>
              <span style={{ color: t.protokolColor, fontWeight: "bold", fontSize: "14px", letterSpacing: "1px" }}>
                » PROTOKOL
              </span>
            </div>

            <Step n="01" t={t}>Etrafındaki küçük molozları elle temizlemeye çalış.</Step>
            <Step n="02" t={t}>Ayağını yavaşça sağa-sola oynat — açı değiştir.</Step>
            <Step n="03" t={t}>Sıkışan bölgeyi <Hl t={t}>masaj yap</Hl> — kan dolaşımını koru.</Step>
            <Step n="04" t={t}>Çıkaramıyorsan pozisyonunu rahatla ve yardım bekle.</Step>

            <div style={{ margin: "10px 0", borderTop: `1px solid ${t.dividerColor}` }} />

            <div style={{ marginBottom: "6px" }}>
              <span style={{ color: t.kritikColor, fontWeight: "bold", fontSize: "14px" }}>◆ KRİTİK</span>
            </div>

            <Warn t={t}><Hl t={t}>Crush sendromu</Hl> riski: Uzun süre sıkışan uzuv serbest kalınca tehlikeli olabilir. Kurtarma ekibi bunu bilir.</Warn>
            <Warn t={t}>Yanındayım. Bir adım daha. Dayanıyorsun.</Warn>

            <div style={{
              marginTop: "12px", padding: "6px 8px",
              background: isDark ? "#0A0C06" : "#D8DCD4",
              borderRadius: "3px",
              border: `1px solid ${t.dividerColor}`,
            }}>
              <span style={{ color: t.msgTextDim, fontSize: "10px" }}>
                ⚕️ Bu bilgi profesyonel yardımın yerini almaz.
              </span>
            </div>

            <span style={{ color: t.cursorColor, animation: "blink 1s step-end infinite" }}>█</span>
          </MsgBlock>

          <div ref={messagesEndRef} />
        </div>

        {/* Disclaimer bar */}
        <div style={{
          padding: "2px 12px", background: isDark ? t.statusBg : t.disclaimerBg,
          borderTop: `1px solid ${t.disclaimerBorder}`, textAlign: "center",
        }}>
          <span style={{ color: t.disclaimerText, fontSize: "7px", letterSpacing: "0.5px" }}>
            [+] BU BİLGİ PROFESYONEL YARDIMIN YERİNİ ALMAZ
          </span>
        </div>

        {/* Input */}
        <div style={{
          background: isDark ? t.statusBg : t.inputBg,
          borderTop: `1px solid ${t.disclaimerBorder}`,
          padding: "6px 10px 24px",
        }}>
          <div style={{
            display: "flex", alignItems: "center",
            background: t.inputFieldBg, borderRadius: "4px",
            border: `1px solid ${t.inputBorder}`, overflow: "hidden",
          }}>
            <div style={{
              padding: "9px 5px 9px 9px",
              color: t.inputPrompt, fontSize: "13px", fontWeight: "bold",
            }}>{">"}</div>
            <input type="text" readOnly
              placeholder="Ne oldu? Durumunuzu anlatın..."
              style={{
                background: "transparent", border: "none", outline: "none",
                color: t.inputText, fontSize: "12px",
                fontFamily: "'Space Mono', monospace", width: "100%",
                padding: "9px 0",
              }}
            />
            <div style={{
              background: isDark ? t.btnBg : t.sendBg,
              padding: "9px 14px",
              color: t.sendText, fontSize: "13px",
              cursor: "pointer",
            }}>▶</div>
          </div>
        </div>
      </div>
    </div>
  );
};

/* ── Helper Components ── */

const MsgBlock = ({ isDark, t, type, time, children }) => (
  <div style={{ width: "100%" }}>
    <div style={{
      fontSize: "8px",
      color: type === "user" ? t.userLabel : t.aiLabel,
      letterSpacing: "1px",
      marginBottom: "2px", padding: "0 2px", fontWeight: "bold",
      display: "flex", justifyContent: "space-between",
    }}>
      <span>{type === "user" ? "KULLANICI@haven:~$" : "HAVEN://response"}</span>
      <span style={{ color: t.timeText, fontWeight: "normal" }}>[{time} UTC]</span>
    </div>
    <div style={{
      padding: "10px 12px", width: "100%", boxSizing: "border-box",
      borderLeft: `3px solid ${type === "user" ? t.userBorderL : t.aiBorderL}`,
      background: type === "user" ? t.userBg : t.aiBg,
      color: t.msgText,
      fontSize: "12.5px", lineHeight: "1.65",
      borderRadius: "0 5px 5px 0",
    }}>
      {children}
    </div>
  </div>
);

const Step = ({ n, t, children }) => (
  <div style={{ marginBottom: "6px", paddingLeft: "4px", display: "flex", gap: "6px" }}>
    <span style={{ color: t.protokolColor, fontWeight: "bold", flexShrink: 0 }}>{n}.</span>
    <span style={{ lineHeight: "1.6" }}>{children}</span>
  </div>
);

const Warn = ({ t, children }) => (
  <div style={{ marginBottom: "5px", paddingLeft: "4px", display: "flex", gap: "6px" }}>
    <span style={{ color: t.kritikColor, fontWeight: "bold", flexShrink: 0 }}>—</span>
    <span style={{ lineHeight: "1.6" }}>{children}</span>
  </div>
);

const Hl = ({ t, children }) => (
  <span style={{ color: t.kritikColor, fontWeight: "bold" }}>{children}</span>
);

const Danger = ({ t, children }) => (
  <span style={{ color: t.acilColor, fontWeight: "bold" }}>{children}</span>
);

/* ── Main Export ── */

export default function ChatScreenDesign() {
  return (
    <div style={{
      display: "flex", justifyContent: "center", alignItems: "flex-start",
      gap: "24px", minHeight: "100vh",
      background: "#2A2E2A",
      padding: "20px", flexWrap: "wrap",
      fontFamily: "'Space Mono', monospace",
    }}>
      <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&display=swap" rel="stylesheet" />

      <PhoneScreen isDark={false} label="NORMAL MOD" />
      <PhoneScreen isDark={true} label="SOS — BUNKER MODU" />

      <style>{`
        @keyframes sosPulse {
          0%, 100% { opacity: 1; }
          50% { opacity: 0.85; box-shadow: 0 2px 14px rgba(192,57,43,0.6); }
        }
        @keyframes blink {
          0%, 100% { opacity: 1; }
          50% { opacity: 0; }
        }
        ::-webkit-scrollbar { width: 3px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #555; border-radius: 2px; }
        input::placeholder { color: inherit; opacity: 0.35; font-family: 'Space Mono', monospace; }
      `}</style>
    </div>
  );
}
