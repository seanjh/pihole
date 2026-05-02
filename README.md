# Pi-hole + Unbound

Minimal, self-contained local DNS stack using Pi-hole (DNS + ad blocking) and Unbound (recursive resolver), running via Docker Compose with host networking.

---

## Requirements

- `docker`
- `docker-compose`


## Usage

- `cp ./pihole/pihole.toml ./data && sudo docker-compose up -d --build` - start
- `sudo docker-compose logs -f` - follow logs
- `cp ./pihole/pihole.toml && docker-compose pull && sudo docker-compose up -d --build` - upgrade
- `sudo docker-compose down` - stop

### Testing

```
# Unbound
dig @127.0.0.1 -p 5335 google.com

# Pi-hole
dig @127.0.0.1 google.com

# From another machine
dig @<server-ip> google.com
```
