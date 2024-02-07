# Brook Server

This project installs and configures a Brook VPN server with a single command. 

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

## Support

You can also buy me a coffee if you find this project helpful.
