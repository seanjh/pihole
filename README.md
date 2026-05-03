
## Requirements

- `podman` >=4.4

## Usage

- To bootstrap, simply run `./setup.sh`

- To change and update
    - `sudo systemctl top unbound.service pihole.service` - stop the services
    - `sudo podman rmi localhost/unbound` - remove the unbound podman image
    - `./setup.sh`
