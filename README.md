# oAMPP - Advanced XAMPP UAC and Configuration Solution

![oAMPP Logo](oAMPP_logo.png)

oAMPP is an advanced, open-source solution for XAMPP User Account Control (UAC) warnings and configuration issues. Developed by Apache Friends and enhanced by VorTexCyberBD, oAMPP provides a seamless experience for XAMPP users on both Windows and Unix-like systems.

## Features

- 🛡️ Automatically fixes UAC warnings on Windows
- 🖥️ Optimizes XAMPP configuration on Unix-like systems
- 🎨 User-friendly interface with animated text and progress bars
- 🔧 Creates additional tools for manual fixes
- 📥 Downloads the latest XAMPP installer
- 🌐 Provides easy access to support channels

## Installation

### Windows

1. Clone this repository or download the ZIP file.
2. Run `Run_oAMPP_UAC_Fix.bat` as administrator.
3. Follow the on-screen instructions.

### Unix-like Systems

1. Clone this repository or download the ZIP file.
2. Open a terminal in the oAMPP directory.
3. Run `chmod +x oAMPP_Unix_Fix.sh`
4. Execute `./oAMPP_Unix_Fix.sh`
5. Follow the on-screen instructions.

## Usage

### Windows

- The script will automatically check and modify the EnableLUA registry value.
- A `.reg` file is created for manual registry fixes if needed.
- The latest XAMPP installer is downloaded for your convenience.

### Unix-like Systems

- The script will check for an existing XAMPP installation and optimize its configuration.
- Apache will be configured to run on port 8080 to avoid permission issues.
- The latest XAMPP installer is downloaded for easy installation or upgrading.

## Support

For support and community discussions, join our Telegram channel:
[https://t.me/VorTexCyberBD](https://t.me/VorTexCyberBD)

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for more details.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Disclaimer

Modifying system settings and configurations can have security implications. Use this tool at your own risk and only on systems you fully control and understand.

## Acknowledgements

- Apache Friends for the original XAMPP package
- VorTexCyberBD for enhancements and support

---

Made with ❤️ by the oAMPP team
