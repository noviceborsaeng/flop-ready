# flop-ready

Bilgisayarın [FLOP](https://flop.finance) madenciliğine hazır mı, kontrol et. Yanında kısa bir hazırlık rehberi var.

**[English →](README.md)**

> **Resmi olmayan topluluk projesi.** Flop Labs ile bağlantısı yok. Yatırım tavsiyesi değildir.
> FLOP henüz yayında değil, aşağıdaki bilgiler değişebilir. Güncel bilgi için [flop.finance](https://flop.finance)'a bak.

## Bilgisayarım hazır mı?

Scriptler ekran kartını ve VRAM'i kontrol ediyor, sonra birkaç sistem bilgisi daha gösteriyor. Sadece okuyorlar, hiçbir şey kurmuyorlar, hiçbir yere veri göndermiyorlar. Çalıştırmadan önce bir göz at, kısa dosyalar.

**Windows (PowerShell)**

```powershell
git clone https://github.com/noviceborsaeng/flop-ready
cd flop-ready
powershell -ExecutionPolicy Bypass -File .\check.ps1 -Lang tr
```

**Linux**

```bash
git clone https://github.com/noviceborsaeng/flop-ready
cd flop-ready
bash check.sh --tr
```

Hazır olmayan bir laptopta çıktı şöyle:

```
FLOP miner hazırlık kontrolü (resmi değil)
------------------------------------------
[INFO] İşletim sistemi: Microsoft Windows 11 Pro (64 bit)
[FAIL] Ekran kartı: NVIDIA GeForce GTX 1650 Ti, 4 GB VRAM (en az 16 GB gerekli)
[INFO] NVIDIA sürücüsü: 560.94
[INFO] CUDA (sürücünün desteklediği): 12.6
[INFO] Sistem RAM: 15.8 GB
[INFO] Boş disk alanı: 80.2 GB (C:)
[PASS] flop.finance erişilebilir: evet

HAZIR DEĞİL: FLOP için 16 GB+ VRAM'li ekran kartı gerekli.
```

## FLOP madenciliği ne?

Bildiğimiz hash madenciliği değil. FLOP miner'ları yapay zekâ çıkarımı yapıyor, yani AI ajanlarından gelen istekleri cevaplıyor ve karşılığında $FLOP kazanıyor. Ağ, işin gerçekten yapıldığını kontrol ediyor ("proof of useful inference").

## Gereksinimler

| | |
|---|---|
| **Ekran kartı** | Kart başına 16 GB+ VRAM (resmi). Oyuncu kartları da olur. Tek kart ya da birden fazla kart. |
| **Çalışma süresi** | Whitepaper'a göre minimum yok. Kapalı kalınca ceza yok. |
| **Stake** | Sabit bir taban stake + kapasiteye göre artan bir kısım. Miktarlar **kesinleşmedi**. Testnet'te ağ karşılıyor. Hile yapılırsa kesilebiliyor (slashing). |
| **İşletim sistemi / RAM / disk / CUDA** | Henüz açıklanmadı. |

### 16 GB+ oyuncu kartları

- RTX 5060 Ti 16GB, RTX 4060 Ti 16GB (en ucuz giriş)
- RTX 5070 Ti, RTX 4070 Ti SUPER (16 GB)
- RTX 5080, RTX 4080 / 4080 SUPER (16 GB)
- RTX 3090 / 3090 Ti, RTX 4090 (24 GB)
- RTX 5090 (32 GB)

16 GB alt sınır. Büyük modeller daha fazlasını isteyecek. AMD desteği henüz belli değil.

16 GB kartın yok mu? Kart almadan önce bulutta GPU kiralayıp deneyebilirsin.

## Şu an yapılacaklar

1. Yukarıdaki kontrolü çalıştır.
2. Resmi [miner başvuru formunu](https://flop.finance/apply/miner) doldur. Zorunlu değil, yer garantisi de vermiyor.
3. Testnet duyurusu için X'te [@flop_labs](https://x.com/flop_labs)'ı takip et.
4. Elektrik masrafını hesapla. Bütün gün çalışan bir ekran kartı faturaya yansır.
5. Miner yazılımı çıkınca bu repo'ya kurulum adımları eklenecek.

## Dikkat

- **Resmi miner yazılımı henüz yok.** Şu an sana "FLOP miner" diye dosya atan büyük ihtimalle dolandırıcı.
- Sadece [flop.finance](https://flop.finance)'ın verdiği linklerden indir.
- Seed phrase'ini ya da private key'ini kimseye verme. DM, form, "destek" sohbeti fark etmez.
- Whitelist için kimseye para ödeme. Resmi form ücretsiz.

## Kaynaklar

- [FLOP whitepaper](https://flop.finance/whitepaper/) (resmi, hâlâ taslak)
- [How to mine FLOP](https://flopnetworknews.com/how-to-mine-flop/) (resmi olmayan topluluk sitesi)

Son güncelleme: 30.10.2026. Yanlış ya da eski bir bilgi mi gördün? Issue ya da PR aç.

## Lisans

MIT
