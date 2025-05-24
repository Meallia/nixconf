.PHONY: all

age-gen-key:
	mkdir -p ~/.config/sops/age
	nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"

deploy-technetium:
	nix run github:nix-community/nixos-anywhere --  --copy-host-keys --flake .#technetium --target-host jonathan@172.20.20.22

rebuild-technetium:
	nixos-rebuild switch --flake .#technetium --use-remote-sudo --fast --target-host jonathan@172.20.20.21

deploy-promethium:
	nix run github:nix-community/nixos-anywhere --  --copy-host-keys --flake .#promethium --target-host jonathan@172.20.20.22

rebuild-promethium:
	nixos-rebuild switch --flake .#promethium --use-remote-sudo --fast --target-host jonathan@172.20.20.22

deploy-dysprosium:
	nix run github:nix-community/nixos-anywhere --  --copy-host-keys --flake .#dysprosium --target-host jonathan@172.20.20.23

rebuild-dysprosium:
	nixos-rebuild switch --flake .#dysprosium --use-remote-sudo --fast --target-host jonathan@172.20.20.23

rebuild-all: rebuild-technetium rebuild-promethium rebuild-dysprosium