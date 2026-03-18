# STIKKIS by IKKI Solutions
### Advanced RGB LED Controller for EdgeTX / OpenTX

> **"IKKI Solutions è nata per creare soluzioni. Con STIKKIS, crediamo di esserci riusciti ancora una volta."**
>
> **"IKKI Solutions was born to create solutions. With STIKKIS, we believe we've succeeded once again."**

---

## 🇮🇹 ITALIANO

### Il Problema & La Soluzione
Chi usa script LUA per i LED conosce bene il problema: **"Script Syntax Error"** o **"CPU Limit Reached"**. 
Le radio non hanno abbastanza memoria per gestire menu complessi, salvataggi e animazioni fluide contemporaneamente nello stesso file.

**STIKKIS risolve il problema alla radice separando i compiti:**
1.  **Il Configuratore (`stikkis.lua`):** Lo usi solo a terra. Gestisce l'interfaccia, i colori e le impostazioni.
2.  **Il Generatore:** Quando salvi, STIKKIS **scrive un nuovo file ottimizzato** (es. `IKKI_1.lua`) che contiene *solo* la matematica necessaria per il volo.

**Risultato:** Configurazioni complesse a terra, leggerezza assoluta in volo. Nessun compromesso.

### Installazione
1.  Copia il file `stikkis.lua` nella cartella `/SCRIPTS/` della SD (o nella cartella che preferisci per lanciarlo).
2.  **IMPORTANTE:** Crea una cartella chiamata `RGBLED` dentro `/SCRIPTS/`.
    * Percorso: `/SCRIPTS/RGBLED/`
    * *Senza questa cartella, lo script non può generare i file di volo.*

### Configurazione Radio (Mixer)
Per cambiare i 6 temi in volo, configura il **Canale 14** (o quello definito nello script) su uno switch a 6 posizioni.
*(Vedi l'immagine allegata nella repository per i settaggi esatti dei Mixes)*.

**Valori Switch:**
* Pos 1: -100% (Cometa)
* Pos 2: -60%  (Arcobaleno)
* Pos 3: -20%  (Strobo)
* Pos 4: +20%  (Scanner)
* Pos 5: +60%  (Blink)
* Pos 6: +100% (Sparkles)

### Guida Rapida
Lancia lo script `stikkis.lua`.
* **SF (Doppio Click):** Cambia pagina menu (0-4).
* **S1 / S2:** Regolano i parametri.
* **Menu 0 (FLASH VERDE):** Salva e Genera il file.

EFFETTI E REGOLAZIONI (LIVELLO 4)
------------------------------------
TEMA 1 - COMETA
   S1: Lunghezza Coda
   S2: BPM Battito Sfondo

TEMA 2 - ARCOBALENO
   S1: Velocita' Rotazione
   S2: Intensita' Battito (0 = Fisso, >0 = Pulsante)

TEMA 3 - STROBO
   S1: Frequenza Strobo
   S2: Soglia Attivazione (Sensibilita' stick)

TEMA 4 - SCANNER (Parentesi)
   S1: Velocita' Scansione
   S2: Larghezza Apertura

TEMA 5 - BLINK (Alternato)
   S1: BPM Lampeggio
   S2: Riservato

TEMA 6 - SPARKLES (Brillantini)
   S1: Frequenza Scintillio
   S2: Densita' basata sul Gas
---

## 🇬🇧 ENGLISH

### The Problem & The Solution
LED scripts often cause **Memory Errors** or **Latency** because they try to do too much (UI, saving, animations) in a single file.

**STIKKIS solves this by separating the workflow:**
1.  **The Configurator (`stikkis.lua`):** Used only on the ground for setup.
2.  **The Generator:** When you save, it **writes a brand new, optimized file** (e.g., `IKKI_1.lua`) containing *only* the flight code.

**Result:** Advanced features on the ground, zero overhead in the air.

### Installation
1.  Copy `stikkis.lua` to your SD Card's `/SCRIPTS/` folder.
2.  **CRITICAL:** Create a folder named `RGBLED` inside `/SCRIPTS/`.
    * Path: `/SCRIPTS/RGBLED/`
    * *The script needs this folder to save the generated files.*

### Radio Setup (Mixes)
Configure **Channel 14** with a 6-position switch to change themes.
*(See the included image in the repository for the exact Mixes setup)*.

**Switch Values:**
* Pos 1: -100% (Comet)
* Pos 2: -60%  (Rainbow)
* Pos 3: -20%  (Strobe)
* Pos 4: +20%  (Scanner)
* Pos 5: +60%  (Blink)
* Pos 6: +100% (Sparkles)

### Quick Start
Run `stikkis.lua`.
* **SF (Double Click):** Next Menu Page.
* **S1 / S2:** Adjust parameters.
* **Menu 0 (GREEN FLASH):** Save & Generate File.

MENU LEVELS:
- Level 0 (GREEN FLASH): EXIT & SAVE. Generates the flight file.
- Level 1 (WHITE FLASH x1): Select Effect Mode.
- Level 2 (WHITE FLASH x2): Color (S1=Theme, S2=Pointer).
- Level 3 (WHITE FLASH x3): Brightness.
- Level 4 (WHITE FLASH x4): Dynamics (See below).

 EFFECTS & PARAMETERS (LEVEL 4)
---------------------------------
1. COMET:    S1=Tail Length, S2=Background Heartbeat BPM.
2. RAINBOW:  S1=Rotation Speed, S2=Heartbeat (0=Solid).
3. STROBE:   S1=Frequency, S2=Trigger Threshold.
4. SCANNER:  S1=Scan Speed, S2=Gap Width.
5. BLINK:    S1=Blink BPM, S2=Reserved.
6. SPARKLES: S1=Sparkle Freq, S2=Density vs Throttle.
---
*Powered by IKKI Solutions*