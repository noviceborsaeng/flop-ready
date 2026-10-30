# flop-ready

Check if your PC can mine on [FLOP](https://flop.finance), plus a short guide for getting ready.

**[Türkçe rehber için tıklayın →](README.tr.md)**

> **Unofficial community project.** Not affiliated with Flop Labs. Not financial advice.
> FLOP is still pre-launch, so details below can change. Always check [flop.finance](https://flop.finance) for the latest.

## Is my PC ready?

The scripts check your GPU and VRAM, then print some extra system info. They only read your system. Nothing gets installed, nothing gets sent anywhere. Read them first. They're short.

**Windows (PowerShell)**

```powershell
git clone https://github.com/noviceborsaeng/flop-ready
cd flop-ready
powershell -ExecutionPolicy Bypass -File .\check.ps1
```

**Linux**

```bash
git clone https://github.com/noviceborsaeng/flop-ready
cd flop-ready
bash check.sh
```

Add `-Lang tr` (Windows) or `--tr` (Linux) for Turkish output.

Example output on a laptop that isn't ready:

```
FLOP miner readiness check (unofficial)
---------------------------------------
[INFO] Operating system: Microsoft Windows 11 Pro (64 bit)
[FAIL] GPU: NVIDIA GeForce GTX 1650 Ti, 4 GB VRAM (needs 16 GB+)
[INFO] NVIDIA driver: 560.94
[INFO] CUDA (supported by driver): 12.6
[INFO] System RAM: 15.8 GB
[INFO] Free disk space: 80.2 GB (C:)
[PASS] flop.finance reachable: yes

NOT READY: FLOP needs a GPU with 16 GB+ VRAM.
```

## What is FLOP mining?

It isn't hashing. FLOP miners run AI inference (they answer requests from AI agents) and get paid in $FLOP. The network checks that the work was actually done ("proof of useful inference").

## Requirements

| | |
|---|---|
| **GPU** | 16 GB+ VRAM per GPU (official). Consumer cards are fine. One card or a cluster both work. |
| **Uptime** | No minimum, according to the whitepaper. You aren't penalised for going offline. |
| **Stake** | Base stake plus a part that scales with your capacity. Exact amounts are **not final**. Sponsored by the network during testnet. Can be slashed if you cheat. |
| **OS / RAM / disk / CUDA** | Not published yet. |

### Consumer GPUs with 16 GB+

- RTX 5060 Ti 16GB, RTX 4060 Ti 16GB (cheapest way in)
- RTX 5070 Ti, RTX 4070 Ti SUPER (16 GB)
- RTX 5080, RTX 4080 / 4080 SUPER (16 GB)
- RTX 3090 / 3090 Ti, RTX 4090 (24 GB)
- RTX 5090 (32 GB)

16 GB is the minimum. Bigger models will want more. AMD support hasn't been confirmed.

No 16 GB card? You can rent a cloud GPU for a test run before buying anything.

## Steps right now

1. Run the check above.
2. Fill in the official [miner interest form](https://flop.finance/apply/miner). It's optional and doesn't guarantee a spot.
3. Follow [@flop_labs](https://x.com/flop_labs) on X for the testnet announcement.
4. Work out your power cost. A GPU running all day adds up.
5. When the miner client comes out, this repo will get install steps.

## Stay safe

- **There is no public miner client yet.** Anyone sending you a "FLOP miner" download right now is likely a scammer.
- Only download software linked from [flop.finance](https://flop.finance).
- Never give your seed phrase or private key to anyone, in DMs, forms, or "support" chats.
- Don't pay anyone for a whitelist spot. The official form is free.

## Sources

- [FLOP whitepaper](https://flop.finance/whitepaper/) (official, still a draft)
- [How to mine FLOP](https://flopnetworknews.com/how-to-mine-flop/) (unofficial community site)

Last updated: 2026-10-30. Found something wrong or out of date? Open an issue or a PR.

## License

MIT
