.PHONY: all

age-gen-key:
	mkdir -p ~/.config/sops/age
	nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"

deploy-dysprosium:
	nix run github:nix-community/nixos-anywhere -- --copy-host-keys --flake .#dysprosium --target-host root@172.20.20.200

rebuild-dysprosium:
	nixos-rebuild switch --flake .#dysprosium --target-host root@172.20.20.200
