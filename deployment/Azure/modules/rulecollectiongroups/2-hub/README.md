# Hub
Controls rules for traffic flowing within the HUB

- Point to Site traffic is terminated in the Hub
- Site to Site VPN traffic is terminated with the Hub (S2S traffic to Spokes is controlled in itøs own rule collection group fro eas of management)

- Allow P2S to S2S SQL traffic (OnPrem 192.168.0.10)
- Allow P2s to S2S Web Traffic (OnPrem 192.168.0.11)
- Allow P2S to Spoke One (All traffic)