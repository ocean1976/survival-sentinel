import { useState, useRef, useEffect } from "react";

const light = {
  phoneBg: "#B8C0B4",
  phoneBorder: "#868E82",
  statusBg: "#ACB4A8",
  statusText: "#4A5646",
  offlineBg: "#3D4F35",
  offlineText: "#A8B89A",
  headerBg: "#A4AE9E",
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
  aiBorder: "#887244",
  userBorder: "#6A8A5A",
  aiBg: "#E1E2DE",
  userBg: "#D5DCD6",
  msgText: "#2A3428",
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
  sendBg: "#A4AE9E",
  sendText: "#6A7A66",
};

const bunker = {
  phoneBg: "#080A06",
  phoneBorder: "#1C2218",
  statusBg: "#060804",
  statusText: "#2A4022",
  offlineBg: "#1C2218",
  offlineText: "#5A8048",
  headerBg: "#060804",
  headerBorder: "#1C2218",
  headerTitle: "#7CAA6A",
  headerSub: "#2A4022",
  btnBg: "#0C0E08",
  btnBorder: "#1C2218",
  btnText: "#486A3A",
  infoBg: "#080A06",
  infoBorder: "#1C2218",
  infoText: "#5A8048",
  chatBg: "#080A06",
  bannerBg: "#0C0E08",
  bannerBorder: "#1C2218",
  bannerText: "#2A4022",
  aiLabel: "#486A3A",
  userLabel: "#3A5A2E",
  timeText: "#2A4022",
  aiBorder: "#486A38",
  userBorder: "#3A5A2E",
  aiBg: "#0C0E08",
  userBg: "#0A0C07",
  msgText: "#6A9858",
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
  sendBg: "#0C0E08",
  sendText: "#2A4022",
};

const InteractivePhone = () => {
  const [sosActive, setSosActive] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [transition, setTransition] = useState(false);
  const t = sosActive ? bunker : light;
  const messagesEndRef = useRef(null);

  const handleSOS = () => {
    if (sosActive) {
      setTransition(true);
      setTimeout(() => {
        setSosActive(false);
        setTransition(false);
      }, 300);
    } else {
      setShowConfirm(true);
    }
  };

  const confirmSOS = () => {
    setShowConfirm(false);
    setTransition(true);
    setTimeout(() => {
      setSosActive(true);
      setTransition(false);
    }, 300);
  };

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, []);

  return (
    <div style={{ display: "flex", flexDirection: "column", alignItems: "center" }}>
      <div style={{
        marginBottom: "8px", padding: "4px 14px",
        background: sosActive ? "#060804" : "#2A3C28",
        borderRadius: "4px",
        border: sosActive ? "1px solid #1C2218" : "none",
        color: sosActive ? "#7CAA6A" : "#A8B89A",
        fontSize: "11px", letterSpacing: "2px", fontWeight: "bold",
        transition: "all 0.3s ease",
      }}>
        {sosActive ? "SOS AKTİF — BUNKER MODU" : "NORMAL MOD — SOS'E BASIN"}
      </div>

      <div style={{
        width: "340px", height: "720px",
        background: t.phoneBg,
        borderRadius: "32px", border: `3px solid ${t.phoneBorder}`,
        overflow: "hidden", display: "flex", flexDirection: "column",
        boxShadow: sosActive
          ? "0 6px 30px rgba(0,0,0,0.6), 0 0 50px rgba(124,170,106,0.03)"
          : "0 6px 30px rgba(0,0,0,0.3)",
        position: "relative",
        fontFamily: "'Space Mono', monospace",
        transition: transition ? "all 0.3s ease" : "none",
      }}>
        {sosActive && (
          <>
            <div style={{ position: "absolute", top: 0, left: 0, right: 0, bottom: 0, background: "repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(0,0,0,0.10) 2px, rgba(0,0,0,0.10) 3px)", pointerEvents: "none", zIndex: 6 }} />
            <div style={{ position: "absolute", top: 0, left: 0, right: 0, bottom: 0, background: "radial-gradient(ellipse at center, rgba(124,170,106,0.03) 0%, transparent 65%)", pointerEvents: "none", zIndex: 4 }} />
            <div style={{ position: "absolute", top: 0, left: 0, right: 0, bottom: 0, background: "radial-gradient(ellipse at center, transparent 60%, rgba(0,0,0,0.4) 100%)", pointerEvents: "none", zIndex: 5 }} />
          </>
        )}
        {!sosActive && (
          <div style={{ position: "absolute", top: 0, left: 0, right: 0, bottom: 0, background: "repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(0,0,0,0.015) 2px, rgba(0,0,0,0.015) 3px)", pointerEvents: "none", zIndex: 6 }} />
        )}

        {/* Status Bar */}
        <div style={{ padding: "10px 16px 3px", display: "flex", justifyContent: "space-between", alignItems: "center", fontSize: "10px", color: t.statusText, background: t.statusBg, transition: transition ? "all 0.3s ease" : "none" }}>
          <span style={{ fontWeight: "bold", letterSpacing: "1px" }}>14:33 UTC</span>
          <div style={{ display: "flex", gap: "6px", alignItems: "center" }}>
            <span style={{ background: t.offlineBg, color: t.offlineText, padding: "1px 5px", borderRadius: "2px", fontSize: "8px", letterSpacing: "1px" }}>OFFLINE</span>
            <span style={{ letterSpacing: "1px", fontSize: "9px" }}>BAT:87%</span>
          </div>
        </div>

        {/* Header */}
        <div style={{ background: t.headerBg, padding: "6px 12px 8px", borderBottom: `2px solid ${t.headerBorder}`, transition: transition ? "all 0.3s ease" : "none" }}>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: "6px" }}>
            <button style={{ background: t.btnBg, border: `1px solid ${t.btnBorder}`, borderRadius: "4px", padding: "3px 7px", color: t.btnText, fontSize: "11px", fontWeight: "bold", fontFamily: "'Space Mono', monospace", cursor: "pointer" }}>[=]</button>
            <div style={{ textAlign: "center" }}>
              <div style={{ fontSize: "12px", letterSpacing: "2px", color: t.headerTitle, fontWeight: "bold", textShadow: sosActive ? "0 0 8px rgba(124,170,106,0.15)" : "none" }}>HAVEN PROTOCOL</div>
              <div style={{ fontSize: "8px", letterSpacing: "1px", color: t.headerSub, marginTop: "1px" }}>{sosActive ? "SURVIVAL AI // SOS ACTIVE" : "SURVIVAL AI // OFFLINE"}</div>
            </div>
            <button onClick={handleSOS} style={{
              background: sosActive ? "linear-gradient(180deg, #8A5A30 0%, #6A4420 100%)" : "linear-gradient(180deg, #C0392B 0%, #A93226 100%)",
              border: sosActive ? "1px solid #AA7040" : "1px solid #E74C3C",
              borderRadius: "4px", padding: "3px 8px",
              color: sosActive ? "#D4A878" : "#FFFFFF",
              fontSize: "11px", fontWeight: "bold", fontFamily: "'Space Mono', monospace", letterSpacing: "1px", cursor: "pointer",
              animation: sosActive ? "none" : "sosPulse 2s infinite",
              boxShadow: sosActive ? "0 2px 6px rgba(138,90,48,0.3)" : "0 2px 8px rgba(192,57,43,0.5)",
              transition: "all 0.3s ease",
            }}>[!] SOS</button>
          </div>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", padding: "4px 8px", background: t.infoBg, borderRadius: "3px", border: `1px solid ${t.infoBorder}`, transition: transition ? "all 0.3s ease" : "none" }}>
            {sosActive ? (
              <span style={{ color: t.infoText, fontSize: "10px", letterSpacing: "1px", fontWeight: "bold" }}>[!] SOS — SINIRSIZ ERİŞİM</span>
            ) : (
              <>
                <span style={{ color: t.infoText, fontSize: "10px", letterSpacing: "1px", fontWeight: "bold" }}>SORU: 3/20</span>
                <span style={{ background: "linear-gradient(90deg, #8B6914 0%, #C9A227 100%)", padding: "2px 8px", borderRadius: "2px", color: "#FFFFFF", fontSize: "8px", fontWeight: "bold", letterSpacing: "1px" }}>[*] PREMIUM</span>
              </>
            )}
          </div>
        </div>

        {/* Chat */}
        <div style={{ flex: 1, overflowY: "auto", padding: "6px 10px", background: t.chatBg, display: "flex", flexDirection: "column", gap: "6px", transition: transition ? "all 0.3s ease" : "none" }}>
          <div style={{ textAlign: "center", padding: "4px", color: t.bannerText, fontSize: "8px", letterSpacing: "1px", border: `1px solid ${t.bannerBorder}`, background: t.bannerBg, borderRadius: "2px" }}>
            ══ TÜM VERİLER OFFLINE ══
          </div>

          {/* AI Welcome */}
          <div style={{ width: "100%" }}>
            <div style={{ fontSize: "8px", color: t.aiLabel, letterSpacing: "1px", marginBottom: "1px", fontWeight: "bold", display: "flex", justifyContent: "space-between", width: "100%" }}>
              <span>HAVEN://response</span>
              <span style={{ color: t.timeText, fontWeight: "normal" }}>[14:32:18 UTC]</span>
            </div>
            <div style={{ padding: "7px 10px", width: "100%", boxSizing: "border-box", borderLeft: `3px solid ${t.aiBorder}`, background: t.aiBg, color: t.msgText, fontSize: "13px", lineHeight: "1.55", borderRadius: "0 4px 4px 0", transition: transition ? "all 0.3s ease" : "none" }}>
              Haven Protocol aktif. Acil bir durum mu var?{"\n"}Durumunuzu anlatın, adım adım yönlendireceğim.
            </div>
          </div>

          {/* User */}
          <div style={{ width: "100%" }}>
            <div style={{ fontSize: "8px", color: t.userLabel, letterSpacing: "1px", marginBottom: "1px", fontWeight: "bold", display: "flex", justifyContent: "space-between", width: "100%" }}>
              <span>KULLANICI@haven:~$</span>
              <span style={{ color: t.timeText, fontWeight: "normal" }}>[14:33:04 UTC]</span>
            </div>
            <div style={{ padding: "7px 10px", width: "100%", boxSizing: "border-box", borderLeft: `3px solid ${t.userBorder}`, background: t.userBg, color: t.msgText, fontSize: "13px", lineHeight: "1.55", borderRadius: "0 4px 4px 0", transition: transition ? "all 0.3s ease" : "none" }}>
              Deprem oldu ne yapmalıyım?
            </div>
          </div>

          {/* AI Response */}
          <div style={{ width: "100%" }}>
            <div style={{ fontSize: "8px", color: t.aiLabel, letterSpacing: "1px", marginBottom: "1px", fontWeight: "bold", display: "flex", justifyContent: "space-between", width: "100%" }}>
              <span>HAVEN://response</span>
              <span style={{ color: t.timeText, fontWeight: "normal" }}>[14:33:07 UTC]</span>
            </div>
            <div style={{ padding: "7px 10px", width: "100%", boxSizing: "border-box", borderLeft: `3px solid ${t.aiBorder}`, background: t.aiBg, color: t.msgText, fontSize: "13px", lineHeight: "1.7", borderRadius: "0 4px 4px 0", transition: transition ? "all 0.3s ease" : "none" }}>
              <div style={{ marginBottom: "10px" }}>
                <span style={{ color: t.acilColor, fontWeight: "bold", fontSize: "15px" }}>▲ ACİL:</span>{" "}
                Hemen <span style={{ color: t.acilColor, fontWeight: "bold" }}>ÇÖK-KAPAN-TUTUN</span> pozisyonuna geçin.
              </div>
              <div style={{ marginBottom: "6px" }}>
                <span style={{ color: t.protokolColor, fontWeight: "bold", fontSize: "15px" }}>» PROTOKOL:</span>
              </div>
              {["Yere çökün, sağlam masa altına girin", "Baş ve boynunuzu kollarınızla koruyun", "Sarsıntı durana kadar pozisyonda kalın", "Cam ve ağır mobilyalardan uzak durun", "Sarsıntı durduğunda binayı sakin terk edin"].map((step, i) => (
                <div key={i} style={{ marginBottom: "4px", paddingLeft: "4px" }}>
                  <span style={{ color: t.protokolColor, fontWeight: "bold" }}>{String(i + 1).padStart(2, "0")}.</span> {step}
                </div>
              ))}
              <div style={{ marginBottom: "10px", paddingLeft: "4px" }}>
                <span style={{ color: t.protokolColor, fontWeight: "bold" }}>06.</span>{" "}
                <span style={{ color: t.acilColor, fontWeight: "bold" }}>Asansör kullanmayın</span> — merdiven kullanın
              </div>
              <div style={{ marginBottom: "6px" }}>
                <span style={{ color: t.kritikColor, fontWeight: "bold", fontSize: "15px" }}>◆ KRİTİK:</span>
              </div>
              <div style={{ marginBottom: "4px", paddingLeft: "4px" }}><span style={{ color: t.kritikColor, fontWeight: "bold" }}>—</span> Artçı sarsıntılar ilk <span style={{ color: t.kritikColor, fontWeight: "bold" }}>48 saat</span> devam edebilir</div>
              <div style={{ marginBottom: "4px", paddingLeft: "4px" }}><span style={{ color: t.kritikColor, fontWeight: "bold" }}>—</span> Gaz kokusu alırsanız <span style={{ color: t.acilColor, fontWeight: "bold" }}>ateş kaynağı kullanmayın</span></div>
              <div style={{ paddingLeft: "4px" }}><span style={{ color: t.kritikColor, fontWeight: "bold" }}>—</span> Dışarıda binalardan min. <span style={{ color: t.kritikColor, fontWeight: "bold" }}>10m</span> uzaklaşın</div>
              <span style={{ color: t.cursorColor, animation: "blink 1s step-end infinite", marginLeft: "2px" }}>█</span>
            </div>
          </div>
          <div ref={messagesEndRef} />
        </div>

        {/* Disclaimer */}
        <div style={{ padding: "2px 12px", background: t.disclaimerBg, borderTop: `1px solid ${t.disclaimerBorder}`, textAlign: "center", transition: transition ? "all 0.3s ease" : "none" }}>
          <span style={{ color: t.disclaimerText, fontSize: "7px", letterSpacing: "0.5px" }}>[+] BU BİLGİ PROFESYONEL YARDIMIN YERİNİ ALMAZ</span>
        </div>

        {/* Input */}
        <div style={{ background: t.inputBg, borderTop: `1px solid ${t.disclaimerBorder}`, padding: "6px 10px 22px", transition: transition ? "all 0.3s ease" : "none" }}>
          <div style={{ display: "flex", alignItems: "center", background: t.inputFieldBg, borderRadius: "4px", border: `1px solid ${t.inputBorder}`, overflow: "hidden" }}>
            <div style={{ padding: "8px 5px 8px 8px", color: t.inputPrompt, fontSize: "12px", fontWeight: "bold" }}>{">"}</div>
            <input type="text" readOnly placeholder="Ne oldu? Durumunuzu anlatın..." style={{ background: "transparent", border: "none", outline: "none", color: t.inputText, fontSize: "12px", fontFamily: "'Space Mono', monospace", width: "100%", padding: "8px 0" }} />
            <div style={{ background: t.sendBg, padding: "8px 12px", color: t.sendText, fontSize: "12px" }}>▶</div>
          </div>
        </div>

        {/* SOS Confirm Overlay */}
        {showConfirm && (
          <div style={{ position: "absolute", top: 0, left: 0, right: 0, bottom: 0, background: "rgba(0,0,0,0.5)", display: "flex", alignItems: "center", justifyContent: "center", zIndex: 20, borderRadius: "29px" }}>
            <div style={{ width: "280px", background: "#E1E2DE", border: "2px solid #C0392B", borderRadius: "8px", overflow: "hidden", boxShadow: "0 8px 30px rgba(0,0,0,0.4)" }}>
              <div style={{ background: "linear-gradient(180deg, #C0392B, #A93226)", padding: "10px 14px", textAlign: "center" }}>
                <div style={{ color: "#FFFFFF", fontSize: "14px", fontWeight: "bold", letterSpacing: "2px" }}>[!] SOS MODU</div>
              </div>
              <div style={{ padding: "16px 14px" }}>
                <div style={{ color: "#2A3428", fontSize: "12px", lineHeight: "1.7", marginBottom: "14px", textAlign: "center" }}>
                  Bu özellik <span style={{ color: "#9B1B1B", fontWeight: "bold" }}>gerçek acil durumlar</span> içindir.
                </div>
                <div style={{ background: "#D5DCD6", border: "1px solid #A0AA96", borderRadius: "4px", padding: "10px 12px", marginBottom: "14px" }}>
                  <div style={{ fontSize: "10px", color: "#2A3428", lineHeight: "1.7" }}>
                    <div style={{ marginBottom: "4px" }}><span style={{ color: "#3D6B35", fontWeight: "bold" }}>✓</span> 72 saat sınırsız soru</div>
                    <div style={{ marginBottom: "4px" }}><span style={{ color: "#3D6B35", fontWeight: "bold" }}>✓</span> Karanlık mod (pil tasarrufu)</div>
                    <div><span style={{ color: "#D67B37", fontWeight: "bold" }}>!</span> 30 günde 1 kez kullanılabilir</div>
                  </div>
                </div>
                <div style={{ display: "flex", gap: "8px" }}>
                  <button onClick={() => setShowConfirm(false)} style={{ flex: 1, background: "#CCD2C6", border: "1px solid #A0AA96", borderRadius: "4px", padding: "10px", color: "#3A4A36", fontSize: "11px", fontWeight: "bold", fontFamily: "'Space Mono', monospace", letterSpacing: "1px", cursor: "pointer" }}>İPTAL</button>
                  <button onClick={confirmSOS} style={{ flex: 1, background: "linear-gradient(180deg, #C0392B, #A93226)", border: "1px solid #E74C3C", borderRadius: "4px", padding: "10px", color: "#FFFFFF", fontSize: "11px", fontWeight: "bold", fontFamily: "'Space Mono', monospace", letterSpacing: "1px", cursor: "pointer", boxShadow: "0 2px 8px rgba(192,57,43,0.3)" }}>[!] AKTİFLEŞTİR</button>
                </div>
              </div>
            </div>
          </div>
        )}
      </div>

      <div style={{ marginTop: "10px", textAlign: "center", color: "#8A9484", fontSize: "10px", letterSpacing: "1px" }}>
        {sosActive ? "SOS butonuna tekrar basarak normal moda dönün" : "SOS butonuna basarak test edin"}
      </div>
    </div>
  );
};

export default function SOSToggleDemo() {
  return (
    <div style={{ display: "flex", justifyContent: "center", alignItems: "center", minHeight: "100vh", background: "#3A3E3A", padding: "20px", fontFamily: "'Space Mono', monospace" }}>
      <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&display=swap" rel="stylesheet" />
      <InteractivePhone />
      <style>{`
        @keyframes sosPulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.85; box-shadow: 0 2px 14px rgba(192,57,43,0.6); } }
        @keyframes blink { 0%, 100% { opacity: 1; } 50% { opacity: 0; } }
        ::-webkit-scrollbar { width: 2px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #929A8E; border-radius: 2px; }
        input::placeholder { color: inherit; opacity: 0.4; font-family: 'Space Mono', monospace; }
      `}</style>
    </div>
  );
}
