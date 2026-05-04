import { useState } from "react";

const PhoneScreen = ({ title, children }) => {
  return (
    <div style={{ display: "flex", flexDirection: "column", alignItems: "center" }}>
      <div style={{
        marginBottom: "8px", padding: "4px 14px",
        background: "#2A3C28", borderRadius: "4px",
        color: "#A8B89A",
        fontSize: "11px", letterSpacing: "2px", fontWeight: "bold",
      }}>
        {title}
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
          <span style={{ fontWeight: "bold", letterSpacing: "1px" }}>14:35 UTC</span>
          <div style={{ display: "flex", gap: "6px", alignItems: "center" }}>
            <span style={{
              background: "#3D4F35", color: "#A8B89A",
              padding: "1px 5px", borderRadius: "2px",
              fontSize: "8px", letterSpacing: "1px",
            }}>OFFLINE</span>
            <span style={{ letterSpacing: "1px", fontSize: "9px" }}>BAT:87%</span>
          </div>
        </div>

        {children}
      </div>
    </div>
  );
};

const SettingsRow = ({ label, value, hasArrow, isToggle, toggleOn, isDanger, isLink }) => {
  return (
    <div style={{
      display: "flex", justifyContent: "space-between", alignItems: "center",
      padding: "10px 14px",
      borderBottom: "1px solid #A0AA96",
      cursor: "pointer",
    }}>
      <span style={{
        color: isDanger ? "#9B1B1B" : "#2A3428",
        fontSize: "12px",
        fontWeight: isDanger ? "bold" : "normal",
      }}>
        {label}
      </span>
      <div style={{ display: "flex", alignItems: "center", gap: "6px" }}>
        {value && (
          <span style={{
            color: isLink ? "#3A7088" : "#6A7A66",
            fontSize: "11px",
            textDecoration: isLink ? "underline" : "none",
            textDecorationColor: "#6AAAC4",
            textUnderlineOffset: "2px",
          }}>
            {value}
          </span>
        )}
        {isToggle && (
          <div style={{
            width: "36px", height: "20px",
            background: toggleOn
              ? "linear-gradient(90deg, #3D6B35, #4A7A42)"
              : "#9EA89A",
            borderRadius: "10px",
            position: "relative",
            border: "1px solid #868E82",
          }}>
            <div style={{
              width: "16px", height: "16px",
              background: "#E1E2DE",
              borderRadius: "50%",
              position: "absolute",
              top: "1px",
              left: toggleOn ? "17px" : "1px",
              boxShadow: "0 1px 2px rgba(0,0,0,0.2)",
              transition: "left 0.2s",
            }} />
          </div>
        )}
        {hasArrow && (
          <span style={{ color: "#8A9484", fontSize: "12px" }}>›</span>
        )}
      </div>
    </div>
  );
};

const SectionHeader = ({ text }) => (
  <div style={{
    padding: "8px 14px 4px",
    color: "#5A6A56",
    fontSize: "9px",
    letterSpacing: "2px",
    fontWeight: "bold",
    borderBottom: "1px solid #A0AA96",
    background: "#B0B8AA",
  }}>
    {text}
  </div>
);

const SettingsScreen = () => {
  return (
    <PhoneScreen title="SETTINGS EKRANI">
      {/* Header */}
      <div style={{
        background: "linear-gradient(180deg, #A4AE9E 0%, #ACB6A8 100%)",
        padding: "10px 16px",
        borderBottom: "2px solid #868E82",
        borderTop: "1px solid #BCC4B6",
        display: "flex", alignItems: "center", gap: "12px",
      }}>
        <span style={{
          color: "#3D6B35", fontSize: "16px", cursor: "pointer", fontWeight: "bold",
        }}>‹</span>
        <div>
          <div style={{ fontSize: "13px", letterSpacing: "2px", color: "#283826", fontWeight: "bold" }}>
            [=] AYARLAR
          </div>
          <div style={{ fontSize: "8px", letterSpacing: "1px", color: "#5A6A56", marginTop: "1px" }}>
            HAVEN PROTOCOL // SİSTEM AYARLARI
          </div>
        </div>
      </div>

      {/* Settings list */}
      <div style={{
        flex: 1, overflowY: "auto",
        background: "linear-gradient(180deg, #C3CAC2 0%, #C7CEC6 50%, #C9CEC8 100%)",
      }}>
        <SectionHeader text="GENEL" />
        <SettingsRow label="Dil / Language" value="Türkçe" hasArrow />
        <SettingsRow label="Bildirimler" isToggle toggleOn={false} />

        <SectionHeader text="GÖRÜNÜM" />
        <SettingsRow label="Tema" value="Açık" hasArrow />
        <SettingsRow label="Font boyutu" value="Normal" hasArrow />

        <SectionHeader text="HESAP" />
        <SettingsRow label="Durum" value="Ücretsiz — 3/5 soru" />
        <SettingsRow
          label="[*] Premium'a Yükselt"
          value="$3'dan"
          hasArrow
        />
        <SettingsRow label="Satın almayı geri yükle" hasArrow />

        <SectionHeader text="BİLGİ" />
        <SettingsRow label="Kaynaklar" value="FEMA, FM 21-76, CDC" hasArrow />
        <SettingsRow label="Gizlilik Politikası" isLink value="Görüntüle" />
        <SettingsRow label="Kullanım Şartları" isLink value="Görüntüle" />
        <SettingsRow label="Versiyon" value="v1.0.0" />

        <SectionHeader text="VERİ" />
        <SettingsRow label="AI Model" value="Gemma 4 (2.3 GB)" />
        <SettingsRow label="Skill dosyaları" value="20 yüklü" />
        <SettingsRow label="Sohbet geçmişini temizle" isDanger hasArrow />

        {/* Bottom padding */}
        <div style={{ height: "20px" }} />
      </div>

      {/* Footer */}
      <div style={{
        padding: "6px 12px 22px", background: "#ACB4A8",
        borderTop: "1px solid #929A8E", textAlign: "center",
      }}>
        <div style={{ color: "#5A6A56", fontSize: "8px", letterSpacing: "1px" }}>
          HAVEN PROTOCOL v1.0.0
        </div>
        <div style={{ color: "#6A7A66", fontSize: "7px", marginTop: "2px" }}>
          © 2026 // TÜM VERİLER CİHAZDA SAKLANIR
        </div>
      </div>
    </PhoneScreen>
  );
};

const PremiumScreen = () => {
  return (
    <PhoneScreen title="PREMIUM EKRANI">
      {/* Header */}
      <div style={{
        background: "linear-gradient(180deg, #A4AE9E 0%, #ACB6A8 100%)",
        padding: "10px 16px",
        borderBottom: "2px solid #868E82",
        borderTop: "1px solid #BCC4B6",
        display: "flex", alignItems: "center", gap: "12px",
      }}>
        <span style={{
          color: "#3D6B35", fontSize: "16px", cursor: "pointer", fontWeight: "bold",
        }}>‹</span>
        <div>
          <div style={{ fontSize: "13px", letterSpacing: "2px", color: "#283826", fontWeight: "bold" }}>
            [*] PREMIUM
          </div>
          <div style={{ fontSize: "8px", letterSpacing: "1px", color: "#5A6A56", marginTop: "1px" }}>
            HAVEN PROTOCOL // ERİŞİM YÜKSELTMESİ
          </div>
        </div>
      </div>

      {/* Premium content */}
      <div style={{
        flex: 1, overflowY: "auto",
        background: "linear-gradient(180deg, #C3CAC2 0%, #C7CEC6 50%, #C9CEC8 100%)",
        padding: "16px 14px",
        display: "flex", flexDirection: "column", gap: "14px",
      }}>
        {/* Current status */}
        <div style={{
          background: "#B8C0B0",
          border: "1px solid #A0AA96",
          borderRadius: "4px",
          padding: "10px 14px",
          textAlign: "center",
        }}>
          <div style={{ color: "#5A6A56", fontSize: "9px", letterSpacing: "1.5px", marginBottom: "4px" }}>
            MEVCUT DURUM
          </div>
          <div style={{ color: "#9B1B1B", fontSize: "13px", fontWeight: "bold", letterSpacing: "1px" }}>
            ÜCRETSİZ — SINIRLI ERİŞİM
          </div>
          <div style={{ color: "#6A7A66", fontSize: "10px", marginTop: "4px" }}>
            Kalan: 3/5 günlük soru
          </div>
          <div style={{ color: "#3D6B35", fontSize: "9px", marginTop: "6px", fontWeight: "bold" }}>
            [!] Acil durumda SOS ile 72 saat full erişim
          </div>
        </div>

        {/* Comparison */}
        <div style={{
          background: "#E1E2DE",
          border: "1px solid #A0AA96",
          borderRadius: "4px",
          overflow: "hidden",
        }}>
          {/* Header row */}
          <div style={{
            display: "grid", gridTemplateColumns: "1fr 1fr 1fr",
            borderBottom: "1px solid #A0AA96",
            background: "#B0B8AA",
          }}>
            <div style={{ padding: "6px 8px", fontSize: "9px", color: "#5A6A56", letterSpacing: "1px", fontWeight: "bold" }}></div>
            <div style={{ padding: "6px 8px", fontSize: "9px", color: "#5A6A56", letterSpacing: "1px", fontWeight: "bold", textAlign: "center", borderLeft: "1px solid #A0AA96" }}>ÜCRETSİZ</div>
            <div style={{ padding: "6px 8px", fontSize: "9px", color: "#8B6914", letterSpacing: "1px", fontWeight: "bold", textAlign: "center", borderLeft: "1px solid #A0AA96" }}>[*] PREMIUM</div>
          </div>

          {[
            { label: "Günlük soru", free: "5", premium: "Sınırsız" },
            { label: "SOS modu", free: "72 saat", premium: "—" },
            { label: "Tüm konular", free: "✓", premium: "✓" },
            { label: "Güncellemeler", free: "Standart", premium: "Öncelikli" },
            { label: "Abonelik", free: "—", premium: "Yok" },
          ].map((row, idx) => (
            <div key={idx} style={{
              display: "grid", gridTemplateColumns: "1fr 1fr 1fr",
              borderBottom: idx < 4 ? "1px solid #C0C8B8" : "none",
            }}>
              <div style={{ padding: "7px 8px", fontSize: "10px", color: "#2A3428" }}>{row.label}</div>
              <div style={{ padding: "7px 8px", fontSize: "10px", color: "#6A7A66", textAlign: "center", borderLeft: "1px solid #C0C8B8" }}>{row.free}</div>
              <div style={{ padding: "7px 8px", fontSize: "10px", color: "#3D6B35", fontWeight: "bold", textAlign: "center", borderLeft: "1px solid #C0C8B8" }}>{row.premium}</div>
            </div>
          ))}
        </div>

        {/* Why premium */}
        <div style={{
          background: "#E1E2DE",
          border: "1px solid #A0AA96",
          borderRadius: "4px",
          padding: "12px 14px",
        }}>
          <div style={{ color: "#5A6A56", fontSize: "9px", letterSpacing: "1.5px", marginBottom: "8px", fontWeight: "bold" }}>
            NEDEN PREMIUM?
          </div>
          <div style={{ fontSize: "11px", color: "#2A3428", lineHeight: "1.7" }}>
            <div style={{ marginBottom: "4px" }}>
              <span style={{ color: "#3D6B35", fontWeight: "bold" }}>[+]</span> Felaket anında soru sınırı olmadan hayati bilgiye erişin
            </div>
            <div style={{ marginBottom: "4px" }}>
              <span style={{ color: "#3D6B35", fontWeight: "bold" }}>[+]</span> Tek seferlik ödeme — <span style={{ color: "#9B1B1B", fontWeight: "bold" }}>abonelik yok</span>
            </div>
            <div style={{ marginBottom: "4px" }}>
              <span style={{ color: "#3D6B35", fontWeight: "bold" }}>[+]</span> Uygulamanın geliştirilmesini destekleyin
            </div>
            <div>
              <span style={{ color: "#3D6B35", fontWeight: "bold" }}>[+]</span> Sonsuza kadar geçerli
            </div>
          </div>
        </div>

        {/* Pricing tiers */}
        <div style={{
          color: "#5A6A56", fontSize: "9px", letterSpacing: "2px",
          fontWeight: "bold", textAlign: "center",
        }}>
          TEK SEFERLİK ÖDEME — ABONELİK YOK
        </div>

        {/* Main option: $3 — gold */}
        <div style={{
          background: "#E1E2DE",
          border: "2px solid #8B6914",
          borderRadius: "6px", padding: "14px",
          textAlign: "center",
        }}>
          <div style={{ color: "#8B6914", fontSize: "10px", letterSpacing: "1.5px", marginBottom: "4px", fontWeight: "bold" }}>
            PREMIUM ERİŞİM
          </div>
          <div style={{ color: "#8B6914", fontSize: "32px", fontWeight: "bold", marginBottom: "4px" }}>
            $3
          </div>
          <div style={{ color: "#6A7A66", fontSize: "9px", marginBottom: "12px" }}>
            Sınırsız soru // Tüm konular // Kalıcı
          </div>
          <button style={{
            width: "100%",
            background: "linear-gradient(180deg, #8B6914, #6A5010)",
            border: "1px solid #B89A30",
            borderRadius: "4px", padding: "10px",
            color: "#F0E8D0", fontSize: "12px", fontWeight: "bold",
            fontFamily: "'Space Mono', monospace",
            letterSpacing: "2px", cursor: "pointer",
            boxShadow: "0 2px 8px rgba(139,105,20,0.3)",
          }}>
            [*] SATIN AL — $3
          </button>
        </div>

        {/* Support tiers — green */}
        <div style={{
          color: "#3D6B35", fontSize: "8px", letterSpacing: "1.5px",
          textAlign: "center", fontStyle: "italic",
        }}>
          Geliştirmeyi desteklemek isterseniz:
        </div>

        <div style={{ display: "flex", gap: "8px" }}>
          {/* $6 */}
          <div style={{
            flex: 1, background: "#E1E2DE",
            border: "1px solid #3D6B35",
            borderRadius: "6px", padding: "12px 6px",
            textAlign: "center", cursor: "pointer",
          }}>
            <div style={{ color: "#3D6B35", fontSize: "8px", letterSpacing: "1px", marginBottom: "4px", fontWeight: "bold" }}>
              DESTEKÇI
            </div>
            <div style={{ color: "#3D6B35", fontSize: "22px", fontWeight: "bold", marginBottom: "2px" }}>
              $6
            </div>
            <div style={{ color: "#6A7A66", fontSize: "8px", marginBottom: "10px" }}>
              Premium + Destek
            </div>
            <button style={{
              width: "100%",
              background: "linear-gradient(180deg, #3D6B35, #2E5028)",
              border: "1px solid #5A8A50",
              borderRadius: "4px", padding: "8px 4px",
              color: "#D0E8C8", fontSize: "10px", fontWeight: "bold",
              fontFamily: "'Space Mono', monospace",
              letterSpacing: "1px", cursor: "pointer",
            }}>
              [+] $6
            </button>
          </div>

          {/* $12 */}
          <div style={{
            flex: 1, background: "#E1E2DE",
            border: "1px solid #3D6B35",
            borderRadius: "6px", padding: "12px 6px",
            textAlign: "center", cursor: "pointer",
          }}>
            <div style={{ color: "#3D6B35", fontSize: "8px", letterSpacing: "1px", marginBottom: "4px", fontWeight: "bold" }}>
              KORUYUCU
            </div>
            <div style={{ color: "#3D6B35", fontSize: "22px", fontWeight: "bold", marginBottom: "2px" }}>
              $12
            </div>
            <div style={{ color: "#6A7A66", fontSize: "8px", marginBottom: "10px" }}>
              Premium + Destek
            </div>
            <button style={{
              width: "100%",
              background: "linear-gradient(180deg, #3D6B35, #2E5028)",
              border: "1px solid #5A8A50",
              borderRadius: "4px", padding: "8px 4px",
              color: "#D0E8C8", fontSize: "10px", fontWeight: "bold",
              fontFamily: "'Space Mono', monospace",
              letterSpacing: "1px", cursor: "pointer",
            }}>
              [+] $12
            </button>
          </div>
        </div>

        <div style={{
          textAlign: "center", color: "#6A7A66", fontSize: "8px",
          fontStyle: "italic", lineHeight: "1.5",
        }}>
          Tüm seçenekler aynı premium özellikleri sunar.
          {"\n"}Fark yalnızca geliştirmeye verdiğiniz destektir.
        </div>

        {/* Restore */}
        <div style={{ textAlign: "center" }}>
          <span style={{
            color: "#3A7088", fontSize: "10px",
            textDecoration: "underline", textDecorationColor: "#6AAAC4",
            textUnderlineOffset: "2px", cursor: "pointer",
          }}>
            Önceki satın almayı geri yükle
          </span>
        </div>

        {/* Fine print */}
        <div style={{
          textAlign: "center",
          padding: "4px 10px",
          color: "#8A9484",
          fontSize: "8px",
          lineHeight: "1.5",
        }}>
          Ödeme Google Play / App Store üzerinden işlenir.
          {"\n"}Kişisel verileriniz toplanmaz veya paylaşılmaz.
        </div>
      </div>

      {/* Footer */}
      <div style={{
        padding: "4px 12px 22px", background: "#ACB4A8",
        borderTop: "1px solid #929A8E", textAlign: "center",
      }}>
        <div style={{ color: "#566054", fontSize: "7px", letterSpacing: "0.5px" }}>
          [+] BU BİLGİ PROFESYONEL YARDIMIN YERİNİ ALMAZ
        </div>
      </div>
    </PhoneScreen>
  );
};

const SurvivalSentinelScreens = () => {
  return (
    <div style={{
      display: "flex", justifyContent: "center", alignItems: "flex-start",
      gap: "24px", minHeight: "100vh", background: "#5E665C",
      padding: "20px", flexWrap: "wrap",
      fontFamily: "'Space Mono', monospace",
    }}>
      <link href="https://fonts.googleapis.com/css2?family=Space+Mono:wght@400;700&display=swap" rel="stylesheet" />

      <SettingsScreen />
      <PremiumScreen />

      <style>{`
        ::-webkit-scrollbar { width: 2px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #929A8E; border-radius: 2px; }
      `}</style>
    </div>
  );
};

export default SurvivalSentinelScreens;
