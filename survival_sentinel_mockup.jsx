import { useState, useEffect, useRef } from "react";

const r = (t) => <span style={{ color: "#9B1B1B", fontWeight: "bold" }}>{t}</span>;
const g = (t) => <span style={{ color: "#3D6B35", fontWeight: "bold" }}>{t}</span>;
const y = (t) => <span style={{ color: "#B8860B", fontWeight: "bold" }}>{t}</span>;
const o = (t) => <span style={{ color: "#D67B37" }}>{t}</span>;
const u = (t) => <span style={{ color: "#3A7088", textDecoration: "underline", textDecorationColor: "#6AAAC4", textUnderlineOffset: "2px" }}>{t}</span>;
const b = (t) => <span style={{ fontWeight: "bold" }}>{t}</span>;
const i = (t) => <span style={{ fontStyle: "italic", color: "#5E6E56" }}>{t}</span>;

const PhoneScreen = ({ isPremium, label }) => {
  const messagesEndRef = useRef(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  }, []);

  return (
    <div style={{ display: "flex", flexDirection: "column", alignItems: "center" }}>
      <div style={{
        marginBottom: "8px", padding: "4px 14px",
        background: "#2A3C28", borderRadius: "4px",
        color: isPremium ? "#C9A227" : "#A8B89A",
        fontSize: "11px", letterSpacing: "2px", fontWeight: "bold",
      }}>
        {label}
      </div>

      <div style={{
        width: "340px", height: "700px",
        background: "#B8C0B4",
        borderRadius: "32px", border: "3px solid #868E82",
        overflow: "hidden", display: "flex", flexDirection: "column",
        boxShadow: "0 6px 30px rgba(0,0,0,0.3)",
        position: "relative",
        fontFamily: "'Space Mono', monospace",
      }}>
        {/* Grain */}
        <div style={{
          position: "absolute", top: 0, left: 0, right: 0, bottom: 0,
          backgroundImage: `url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)' opacity='0.03'/%3E%3C/svg%3E")`,
          pointerEvents: "none", zIndex: 5,
        }} />
        <div style={{
          position: "absolute", top: 0, left: 0, right: 0, bottom: 0,
          background: "repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(0,0,0,0.015) 2px, rgba(0,0,0,0.015) 3px)",
          pointerEvents: "none", zIndex: 6,
        }} />

        {/* Status Bar */}
        <div style={{
          padding: "10px 16px 3px", display: "flex",
          justifyContent: "space-between", alignItems: "center",
          fontSize: "10px", color: "#4A5646", background: "#ACB4A8",
        }}>
          <span style={{ fontWeight: "bold", letterSpacing: "1px" }}>14:33 UTC</span>
          <div style={{ display: "flex", gap: "6px", alignItems: "center" }}>
            <span style={{
              background: "#3D4F35", color: "#A8B89A",
              padding: "1px 5px", borderRadius: "2px",
              fontSize: "8px", letterSpacing: "1px",
            }}>OFFLINE</span>
            <span style={{ letterSpacing: "1px", fontSize: "9px" }}>BAT:87%</span>
          </div>
        </div>

        {/* Header */}
        <div style={{
          background: "linear-gradient(180deg, #A4AE9E 0%, #ACB6A8 100%)",
          padding: "6px 12px 8px",
          borderBottom: "2px solid #868E82",
          borderTop: "1px solid #BCC4B6",
        }}>
          <div style={{
            display: "flex", justifyContent: "space-between",
            alignItems: "center", marginBottom: "6px",
          }}>
            <button style={{
              background: "#9EA89A", border: "1px solid #868E82",
              borderRadius: "4px", padding: "3px 7px", color: "#3A4A36",
              fontSize: "11px", cursor: "pointer", fontFamily: "'Space Mono', monospace",
              fontWeight: "bold",
            }}>
              [=]
            </button>

            <div style={{ textAlign: "center" }}>
              <div style={{ fontSize: "12px", letterSpacing: "2px", color: "#283826", fontWeight: "bold" }}>
                HAVEN PROTOCOL
              </div>
              <div style={{ fontSize: "8px", letterSpacing: "1px", color: "#5A6A56", marginTop: "1px" }}>
                SURVIVAL AI // OFFLINE
              </div>
            </div>

            {/* SOS */}
            <button style={{
              background: isPremium
                ? "linear-gradient(180deg, #6A7A60 0%, #5A6A52 100%)"
                : "linear-gradient(180deg, #C0392B 0%, #A93226 100%)",
              border: isPremium ? "1px solid #7A8A70" : "1px solid #E74C3C",
              borderRadius: "4px", padding: "3px 8px",
              color: isPremium ? "#A8B89A" : "#FFFFFF",
              fontSize: "11px", fontWeight: "bold",
              fontFamily: "'Space Mono', monospace",
              letterSpacing: "1px",
              opacity: isPremium ? 0.6 : 1,
              animation: isPremium ? "none" : "sosPulse 2s infinite",
              boxShadow: isPremium ? "none" : "0 2px 8px rgba(192,57,43,0.5)",
            }}>
              [!] SOS
            </button>
          </div>

          {/* Info bar */}
          <div style={{
            display: "flex", justifyContent: isPremium ? "center" : "space-between",
            alignItems: "center",
            padding: "4px 8px",
            background: "#9EA89A",
            borderRadius: "3px", border: "1px solid #8A9486",
          }}>
            {isPremium ? (
              <span style={{ color: "#3A4A36", fontSize: "10px", letterSpacing: "1px", fontWeight: "bold" }}>
                [*] PREMIUM — SINIRSIZ ERİŞİM
              </span>
            ) : (
              <>
                <span style={{ color: "#3A4A36", fontSize: "10px", letterSpacing: "1px", fontWeight: "bold" }}>
                  SORU: 3/5
                </span>
                <span style={{
                  background: "linear-gradient(90deg, #8B6914 0%, #C9A227 100%)",
                  padding: "2px 8px", borderRadius: "2px",
                  color: "#FFFFFF", fontSize: "8px", fontWeight: "bold",
                  fontFamily: "'Space Mono', monospace",
                  letterSpacing: "1px",
                }}>
                  [*] PREMIUM
                </span>
              </>
            )}
          </div>
        </div>

        {/* Chat */}
        <div style={{
          flex: 1, overflowY: "auto", padding: "6px 10px",
          background: "linear-gradient(180deg, #C3CAC2 0%, #C7CEC6 50%, #C9CEC8 100%)",
          display: "flex", flexDirection: "column", gap: "6px",
        }}>
          <div style={{
            textAlign: "center", padding: "4px",
            color: "#5E6E56", fontSize: "8px", letterSpacing: "1px",
            border: "1px solid #A8B0A4", background: "#B6BEB0",
            borderRadius: "2px",
          }}>
            ══ TÜM VERİLER OFFLINE ══
          </div>

          {/* Message 1: AI Welcome */}
          <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-start", width: "100%" }}>
            <div style={{
              fontSize: "8px", color: "#74603A", letterSpacing: "1px",
              marginBottom: "1px", padding: "0 2px", fontWeight: "bold",
              display: "flex", justifyContent: "space-between", width: "100%",
            }}>
              <span>HAVEN://response</span>
              <span style={{ color: "#8A9484", fontWeight: "normal" }}>[14:32:18 UTC]</span>
            </div>
            <div style={{
              padding: "7px 10px", width: "100%", boxSizing: "border-box",
              borderLeft: "3px solid #887244",
              background: "#E1E2DE",
              color: "#2A3428", fontSize: "13px", lineHeight: "1.55",
              borderRadius: "0 4px 4px 0",
            }}>
              Haven Protocol aktif. Acil bir durum mu var?{"\n"}
              Durumunuzu anlatın, adım adım yönlendireceğim.
            </div>
          </div>

          {/* Message 2: User */}
          <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-start", width: "100%" }}>
            <div style={{
              fontSize: "8px", color: "#566054", letterSpacing: "1px",
              marginBottom: "1px", padding: "0 2px", fontWeight: "bold",
              display: "flex", justifyContent: "space-between", width: "100%",
            }}>
              <span>KULLANICI@haven:~$</span>
              <span style={{ color: "#8A9484", fontWeight: "normal" }}>[14:33:04 UTC]</span>
            </div>
            <div style={{
              padding: "7px 10px", width: "100%", boxSizing: "border-box",
              borderLeft: "3px solid #6A8A5A",
              background: "#D5DCD6",
              color: "#2A3428", fontSize: "13px", lineHeight: "1.55",
              borderRadius: "0 4px 4px 0",
            }}>
              Deprem oldu ne yapmalıyım?
            </div>
          </div>

          {/* Message 3: AI Response — rich styled */}
          <div style={{ display: "flex", flexDirection: "column", alignItems: "flex-start", width: "100%" }}>
            <div style={{
              fontSize: "8px", color: "#74603A", letterSpacing: "1px",
              marginBottom: "1px", padding: "0 2px", fontWeight: "bold",
              display: "flex", justifyContent: "space-between", width: "100%",
            }}>
              <span>HAVEN://response</span>
              <span style={{ color: "#8A9484", fontWeight: "normal" }}>[14:33:07 UTC]</span>
            </div>
            <div style={{
              padding: "7px 10px", width: "100%", boxSizing: "border-box",
              borderLeft: "3px solid #887244",
              background: "#E1E2DE",
              color: "#2A3428", fontSize: "13px", lineHeight: "1.7",
              borderRadius: "0 4px 4px 0",
            }}>
              <div style={{ marginBottom: "10px" }}>
                <span style={{ color: "#9B1B1B", fontWeight: "bold", fontSize: "15px" }}>▲ ACİL:</span> Hemen {r("ÇÖK-KAPAN-TUTUN")} pozisyonuna geçin.
              </div>

              <div style={{ marginBottom: "6px" }}>
                <span style={{ color: "#3D6B35", fontWeight: "bold", fontSize: "15px" }}>» PROTOKOL:</span>
              </div>
              <div style={{ marginBottom: "4px", paddingLeft: "4px" }}>{g("01.")} Yere çökün, sağlam masa altına girin</div>
              <div style={{ marginBottom: "4px", paddingLeft: "4px" }}>{g("02.")} Baş ve boynunuzu kollarınızla koruyun</div>
              <div style={{ marginBottom: "4px", paddingLeft: "4px" }}>{g("03.")} Sarsıntı durana kadar pozisyonda kalın</div>
              <div style={{ marginBottom: "4px", paddingLeft: "4px" }}>{g("04.")} Cam ve ağır mobilyalardan uzak durun</div>
              <div style={{ marginBottom: "4px", paddingLeft: "4px" }}>{g("05.")} Sarsıntı durduğunda binayı sakin terk edin</div>
              <div style={{ marginBottom: "10px", paddingLeft: "4px" }}>{g("06.")} {r("Asansör kullanmayın")} — merdiven kullanın</div>

              <div style={{ marginBottom: "6px" }}>
                <span style={{ color: "#D67B37", fontWeight: "bold", fontSize: "15px" }}>◆ KRİTİK:</span>
              </div>
              <div style={{ marginBottom: "4px", paddingLeft: "4px" }}><span style={{ color: "#D67B37", fontWeight: "bold" }}>—</span> {u("Artçı sarsıntılar")} ilk {y("48 saat")} devam edebilir</div>
              <div style={{ marginBottom: "4px", paddingLeft: "4px" }}><span style={{ color: "#D67B37", fontWeight: "bold" }}>—</span> Gaz kokusu alırsanız {r("ateş kaynağı kullanmayın")}</div>
              <div style={{ marginBottom: "4px", paddingLeft: "4px" }}><span style={{ color: "#D67B37", fontWeight: "bold" }}>—</span> Dışarıda binalardan min. {y("10m")} uzaklaşın</div>
              <div style={{ paddingLeft: "4px" }}><span style={{ color: "#D67B37", fontWeight: "bold" }}>—</span> {u("Hasar tespiti")} için yetkili ekipleri bekleyin</div>
              <span style={{ color: "#3D6B35", animation: "blink 1s step-end infinite", marginLeft: "2px" }}>█</span>
            </div>
          </div>

          <div ref={messagesEndRef} />
        </div>

        {/* Disclaimer */}
        <div style={{
          padding: "2px 12px", background: "#AAB2A4",
          borderTop: "1px solid #929A8E", textAlign: "center",
        }}>
          <span style={{ color: "#566054", fontSize: "7px", letterSpacing: "0.5px" }}>
            [+] BU BİLGİ PROFESYONEL YARDIMIN YERİNİ ALMAZ
          </span>
        </div>

        {/* Input */}
        <div style={{
          background: "#ACB4A8", borderTop: "1px solid #929A8E",
          padding: "6px 10px 22px",
        }}>
          <div style={{
            display: "flex", alignItems: "center",
            background: "#CCD2C6", borderRadius: "4px",
            border: "1px solid #929A8E", overflow: "hidden",
          }}>
            <div style={{
              padding: "8px 5px 8px 8px",
              color: "#3D6B35", fontSize: "12px", fontWeight: "bold",
              userSelect: "none",
            }}>{">"}</div>
            <input type="text" readOnly
              placeholder="Ne oldu? Durumunuzu anlatın..."
              style={{
                background: "transparent", border: "none", outline: "none",
                color: "#2A3428", fontSize: "12px",
                fontFamily: "'Space Mono', monospace", width: "100%",
                padding: "8px 0",
              }}
            />
            <div style={{
              background: "#A4AE9E",
              border: "none", borderRadius: "0 3px 3px 0",
              padding: "8px 12px",
              color: "#6A7A66", fontSize: "12px",
            }}>▶</div>
          </div>
        </div>
      </div>
    </div>
  );
};

const SurvivalSentinelMockup = () => {
  return (
    <div style={{
      display: "flex", justifyContent: "center", alignItems: "flex-start",
      gap: "24px", minHeight: "100vh", background: "#5E665C",
      padding: "20px", flexWrap: "wrap",
      fontFamily: "'Space Mono', monospace",
    }}>
      <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&display=swap" rel="stylesheet" />

      <PhoneScreen isPremium={false} label="ÜCRETSİZ KULLANICI" />
      <PhoneScreen isPremium={true} label="PREMIUM KULLANICI" />

      {/* SOS Popup Phone */}
      <div style={{ display: "flex", flexDirection: "column", alignItems: "center" }}>
        <div style={{
          marginBottom: "8px", padding: "4px 14px",
          background: "#2A3C28", borderRadius: "4px",
          color: "#D43D2F",
          fontSize: "11px", letterSpacing: "2px", fontWeight: "bold",
        }}>
          SOS POPUP
        </div>

        <div style={{
          width: "340px", height: "700px",
          background: "#B8C0B4",
          borderRadius: "32px", border: "3px solid #868E82",
          overflow: "hidden", display: "flex", flexDirection: "column",
          boxShadow: "0 6px 30px rgba(0,0,0,0.3)",
          position: "relative",
          fontFamily: "'Space Mono', monospace",
        }}>
          {/* Darkened background */}
          <div style={{
            position: "absolute", top: 0, left: 0, right: 0, bottom: 0,
            background: "rgba(0,0,0,0.55)",
            zIndex: 20,
            display: "flex", justifyContent: "center", alignItems: "center",
            padding: "20px",
          }}>
            {/* SOS Confirmation Popup */}
            <div style={{
              width: "300px",
              background: "#E1E2DE",
              border: "2px solid #9B1B1B",
              borderRadius: "6px",
              padding: "20px",
              boxShadow: "0 8px 30px rgba(0,0,0,0.4)",
              fontFamily: "'Space Mono', monospace",
            }}>
              {/* Warning icon */}
              <div style={{ textAlign: "center", marginBottom: "10px" }}>
                <span style={{ color: "#9B1B1B", fontSize: "28px", fontWeight: "bold", letterSpacing: "4px" }}>/!\</span>
              </div>

              {/* Title */}
              <div style={{
                textAlign: "center", color: "#9B1B1B",
                fontSize: "14px", fontWeight: "bold", letterSpacing: "2px",
                marginBottom: "14px",
              }}>
                SOS PROTOKOLÜ
              </div>

              {/* Info */}
              <div style={{
                background: "#D5DCD6",
                border: "1px solid #A0AA96",
                borderRadius: "4px",
                padding: "10px",
                marginBottom: "14px",
              }}>
                <div style={{ fontSize: "11px", color: "#2A3428", lineHeight: "1.7" }}>
                  <div style={{ marginBottom: "6px" }}>
                    <span style={{ color: "#3D6B35", fontWeight: "bold" }}>[+]</span> <span style={{ fontWeight: "bold" }}>72 saat</span> sınırsız erişim açılır
                  </div>
                  <div style={{ marginBottom: "6px" }}>
                    <span style={{ color: "#3D6B35", fontWeight: "bold" }}>[+]</span> Tüm hayatta kalma konuları
                  </div>
                  <div>
                    <span style={{ color: "#3D6B35", fontWeight: "bold" }}>[+]</span> Soru limiti kaldırılır
                  </div>
                </div>
              </div>

              {/* Warning text */}
              <div style={{
                fontSize: "10px", color: "#6A7A66", lineHeight: "1.6",
                marginBottom: "16px", textAlign: "center",
              }}>
                Bu özellik <span style={{ color: "#9B1B1B", fontWeight: "bold" }}>gerçek acil durumlar</span> içindir.
                <div style={{ color: "#8A9484", fontSize: "9px", marginTop: "6px" }}>
                  30 günde 1 kez kullanılabilir
                </div>
              </div>

              {/* Buttons */}
              <div style={{ display: "flex", gap: "8px" }}>
                <button style={{
                  flex: 1,
                  background: "#C8D0BE",
                  border: "1px solid #929A8E",
                  borderRadius: "4px",
                  padding: "10px",
                  color: "#3A4A36",
                  fontSize: "11px",
                  fontFamily: "'Space Mono', monospace",
                  cursor: "pointer",
                }}>
                  İPTAL
                </button>
                <button style={{
                  flex: 1.5,
                  background: "linear-gradient(180deg, #9B1B1B, #7A1515)",
                  border: "1px solid #C03030",
                  borderRadius: "4px",
                  padding: "10px",
                  color: "#F0E0D0",
                  fontSize: "11px",
                  fontWeight: "bold",
                  fontFamily: "'Space Mono', monospace",
                  letterSpacing: "1px",
                  cursor: "pointer",
                  boxShadow: "0 2px 8px rgba(155,27,27,0.3)",
                }}>
                  [!] ONAYLIYORUM
                </button>
              </div>

              {/* Timer preview */}
              <div style={{
                textAlign: "center", marginTop: "10px",
                color: "#8A9484", fontSize: "8px", letterSpacing: "1px",
              }}>
                AKTİFLEŞTİĞİNDE: 72:00:00 GERİ SAYIM BAŞLAR
              </div>
            </div>
          </div>

          {/* Background phone content (blurred/dimmed) */}
          <div style={{ opacity: 0.3 }}>
            <div style={{
              padding: "10px 16px 3px", fontSize: "10px", color: "#4A5646", background: "#ACB4A8",
            }}>14:33 UTC</div>
            <div style={{
              background: "#A4AE9E", padding: "6px 12px 8px",
              borderBottom: "2px solid #868E82",
            }}>
              <div style={{ fontSize: "12px", letterSpacing: "2px", color: "#283826", fontWeight: "bold", textAlign: "center" }}>
                HAVEN PROTOCOL
              </div>
            </div>
            <div style={{
              flex: 1, background: "#C3CAC2", padding: "10px",
              height: "400px",
            }} />
          </div>
        </div>
      </div>

      <style>{`
        @keyframes sosPulse {
          0%, 100% { opacity: 1; }
          50% { opacity: 0.85; box-shadow: 0 2px 14px rgba(192,57,43,0.6); }
        }
        @keyframes blink {
          0%, 100% { opacity: 1; }
          50% { opacity: 0; }
        }
        ::-webkit-scrollbar { width: 2px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #929A8E; border-radius: 2px; }
        input::placeholder { color: #6A7A66; font-family: 'Space Mono', monospace; }
      `}</style>
    </div>
  );
};

export default SurvivalSentinelMockup;
