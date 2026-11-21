# Delphi VCL Styles Architecture & Demo (v2.0)

[![Delphi Supported Versions](https://img.shields.io/badge/Delphi-XE2%20to%2012%20Athens-blue.svg)](https://www.embarcadero.com/products/delphi)
[![Platform](https://img.shields.io/badge/Platform-Win32%20%7C%20Win64-brightgreen.svg)]()
[![Author](https://img.shields.io/badge/Author-Hicham%20Laichi%20%7C%20Embarcadero%20MVP-orange.svg)](https://github.com/laichihicham)
[![License](https://img.shields.io/badge/License-MIT-lightgrey.svg)]()

A production-grade, highly optimized Delphi VCL Styles loader and runtime manager designed to eliminate common VCL Style pitfalls in commercial enterprise applications.

---

## 🌟 Key Features & Breakthrough Solutions

### 1. ⚡ Zero-Flicker Seamless Switching (`LockWindowUpdate`)
Switching VCL styles at runtime normally causes the entire desktop and application window to rapidly flicker and flash as Delphi synchronously destroys and recreates all window handles (`RecreateWnd`).
* **Solution:** By wrapping the style swap inside an atomic `LockWindowUpdate` block followed by an intelligent non-client repaint (`RedrawWindow`), visual transition is **instantaneous, smooth, and 100% flicker-free**.

### 2. 🛡️ Permanent Fix for "Cannot focus a disabled or invisible window"
When changing styles from inside a modal dialog (such as Settings or Themes Manager), `Application.MainForm` is temporarily disabled by the modal loop. During `TStyleManager.SetStyle`, VCL recreates the main window and attempts to restore focus to `ActiveControl`, throwing the infamous:
```
EInvalidOperation: Cannot focus a disabled or invisible window
```
* **Solution:** The manager detects disabled owner windows, temporarily asserts window enablement during `RecreateWnd`, and isolates focus restoration within safe bounds, completely eliminating this crash.

### 3. 🔒 UAC-Safe Persistence (`%APPDATA%` + Local Fallback)
When deployed to `C:\Program Files`, standard users lack write permissions to local application directories. Writing to `AppName.ini` fails silently or gets trapped in VirtualStore.
* **Solution:** Automatically persists user theme preferences in `%APPDATA%\<AppName>\styles.ini`, ensuring preferences are **never reset or lost after application updates**, with seamless automatic fallback to local `.ini` for portable portable setups.

### 4. 🔍 Instant Search & Real-Time Filter
Includes an intuitive search box (`TEdit`) above the styles list that filters hundreds of loaded styles in real-time with zero lag.

### 5. 📂 Automatic Directory Scanner (`styles\*.vsf`)
No need to manually hardcode or register every `.vsf` file in your project or INI file. The unit automatically discovers, validates (`TStyleManager.IsValidStyle`), and registers all `.vsf` files placed inside the application's `styles\` folder on startup.

### 6. 🎯 Active Style Auto-Selection
Automatically detects the currently running style on form show and highlights it in the list box.

---

## 🚀 Quick Start & Integration

### Minimal Integration (Any Form or Action)

```pascal
uses
  styles;

// Apply a style smoothly with zero flicker and UAC-safe persistence
frmVclStyles.ApplyStyle('Glow');
```

### Loading Styles at Application Startup (`.dpr`)

```pascal
program MyEnterpriseApp;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  styles in 'styles.pas' {frmVclStyles};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  
  // Create styles controller and load user preferred style
  Application.CreateForm(TfrmVclStyles, frmVclStyles);
  
  Application.Run;
end.
```

---

## 📂 Project Structure

```
VclStyleDemo/
├── styles.pas           # Core architecture & theme management unit
├── styles.dfm           # Clean preview form with active component testers
├── VCLStylesDemo.dpr    # Application entry point (Win32 & Win64 compatible)
├── VCLStylesDemo.dproj  # RAD Studio project configuration
├── README.md            # Architecture documentation
└── styles/              # (Optional) Drop any .vsf style files here
```

---

## 👨‍💻 Author & Contributions

* **Hicham Laichi** — *Embarcadero MVP*
* GitHub: [@laichihicham](https://github.com/laichihicham)
* Project Repository: [https://github.com/laichihicham/VclStyleDemo](https://github.com/laichihicham/VclStyleDemo)

---

## 📄 License
This project is licensed under the **MIT License** — free for both open-source and commercial Delphi applications.
