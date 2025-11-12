# USB Rubber Ducky Payloads

A collection of USB Rubber Ducky payloads for Raspberry Pi Pico, designed for educational and security research purposes.

## ⚠️ WARNING

**IMPORTANT:** These payloads are provided for **educational purposes only**. Unauthorized use of these payloads on systems you do not own or have explicit permission to test is illegal and unethical.

### Setup Instructions

These payloads have been tested on a **Raspberry Pi Pico** running the USB Rubber Ducky firmware.

**Before using any payload:**
- Change all `payload.txt` files to `payload.dd` (required for Raspberry Pi Pico)
- Review and customize the payload scripts according to your needs
- Ensure you have proper authorization before testing on any system

## Payloads

### 1. [createUserAdmin](payloads/createUserAdmin)
**Category:** Execution  
**Target:** Windows 10/8

Creates a new administrator user account on Windows systems. The payload:
- Opens PowerShell with elevated privileges
- Creates a new user account (default: `duck` with password `password`)
- Adds the user to the Administrators group
- Hides the user from the login screen
- Cleans up execution traces

**Customization:** You can change the username and password in the payload script.

### 2. [exfiltrateWifiPasswords_locally](payloads/exfiltrateWifiPasswords_locally)
**Category:** Exfiltration  
**Target:** Windows 10  

Extracts and stores WiFi passwords from the target system. The payload:
- Executes a PowerShell script to retrieve saved WiFi credentials
- Stores the passwords on the USB device (check `ss.ps1` to modify the output directory)

**Note:** Modify `ss.ps1` to change the output directory where passwords are stored.

### 3. [rotateScreen](payloads/rotateScreen)
**Category:** Prank  
**Target:** Windows 10  

Continuously rotates the monitor screen at specified intervals. The payload:
- Executes PowerShell scripts to rotate the display
- Can be configured to rotate at custom time intervals
- Includes a script to minimize windows during rotation

**Customization:** Modify the delay in `dd.ps1` (1 second = 1000 milliseconds) to change rotation timing.

## Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/mickeyhousee/usbrubberducky-payloads.git
   ```

2. Navigate to the desired payload directory

3. Rename `payload.txt` to `payload.dd` (if applicable)

4. Review and customize the payload script as needed

5. Upload the `payload.dd` file to your Raspberry Pi Pico

6. Test responsibly and only on systems you own or have explicit permission to test

## Requirements

- Raspberry Pi Pico with USB Rubber Ducky firmware
- Target system: Windows 8/10 (varies by payload)
- Administrative privileges may be required for some payloads

## Disclaimer

This repository and its contents are provided for educational and security research purposes only. The authors and contributors are not responsible for any misuse or damage caused by these payloads. Users are solely responsible for ensuring they have proper authorization before using these tools on any system.

## License

This project is provided as-is for educational purposes. Use at your own risk.

## Contributing

Contributions are welcome! Please ensure that:
- All payloads include proper documentation
- Payloads are tested and functional
- Security warnings and disclaimers are included
- Code follows the existing structure and naming conventions
