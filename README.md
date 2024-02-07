<img width="140" height="140"  alt="Brook" src="https://github.com/jalalsaberi/BrookServer/blob/main/logo.png">

# Brook VPN Server

**A fast, automatic installer and auto-configuration for Brook VPN Server**

[![](https://img.shields.io/badge/Version-v1.0.1-blue)](https://github.com/jalalsaberi/BrookServer/releases)
[![](https://img.shields.io/badge/Licence-MIT-green)](https://github.com/jalalsaberi/BrookServer?tab=MIT-1-ov-file)

> *Disclaimer:* This project is created solely for educational purposes. The responsibility for any misuse of it or its use in environments that do not endorse such tools and are illegal is entirely yours.

This project installs and configures a Brook VPN server with a single command. 

## Support

🌟 If this project was useful to you, don't forget to give it a star 🌟

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://github.com/jalalsaberi/BrookServer/)

[<img width="15" height="15"  alt="usdt" src="https://cryptocurrencyliveprices.com/img/usdt-tether.png">](https://github.com/jalalsaberi/BrookServer/) USDT (TRC20): `TKHNY5zze2PhSaQUGrEyoDz1E9fCG9hjh6`

## Install & Upgrade

To install, simply copy & run the install script:

    bash <(curl -Ls https://raw.githubusercontent.com/jalalsaberi/BrookServer/main/install.sh)

You will be prompted to enter:

- Server IP/Domain
- Password
- Port

## Features

The script will install Nami, Brook, configure the service, and start it.

- Installs Nami to isolate Brook server
- Installs latest Brook version
- Configures Brook as a systemd service for easy management
- Supports IP and domain/subdomain addresses
- Provides login info after install

## Credits

This script is based on [Brook & Nami by TxThinking](https://github.com/txthinking/).

## License

This project is licensed under the MIT License - see the LICENSE file for details.
