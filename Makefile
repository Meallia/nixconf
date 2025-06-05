age-gen-key:
	mkdir -p ~/.config/sops/age
	nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"

#NIXOS_ANYWHERE_KEXEC_OPTS = --kexec "$$(nix build --print-out-paths github:nix-community/nixos-images\#packages.x86_64-linux.kexec-installer-nixos-unstable-noninteractive)/nixos-kexec-installer-noninteractive-aarch64-linux.tar.gz"
NIXOS_ANYWHERE_OPTS = $(NIXOS_ANYWHERE_KEXEC_OPTS) --copy-host-keys

NIXOS_REBUILD_OPTS = switch --fast  --use-remote-sudo

TECHNETIUM_TARGET = --flake .\#technetium --target-host jonathan@172.20.20.21
PROMETHIUM_TARGET = --flake .\#promethium --target-host jonathan@172.20.20.22
DYSPROSIUM_TARGET = --flake .\#dysprosium --target-host jonathan@172.20.20.23



build-technetium:
	nixos-rebuild build --flake .\#technetium

deploy-technetium: build-technetium
	nixos-anywhere $(NIXOS_ANYWHERE_OPTS)  $(TECHNETIUM_TARGET)

switch-technetium: build-technetium
	nixos-rebuild $(NIXOS_REBUILD_OPTS) $(TECHNETIUM_TARGET)



build-promethium:
	nixos-rebuild build --flake .\#promethium

deploy-promethium: build-promethium
	nixos-anywhere $(NIXOS_ANYWHERE_OPTS) $(PROMETHIUM_TARGET)

switch-promethium: build-promethium
	nixos-rebuild $(NIXOS_REBUILD_OPTS) $(PROMETHIUM_TARGET)



build-dysprosium:
	nixos-rebuild build --flake .\#dysprosium

deploy-dysprosium: build-dysprosium
	nixos-anywhere $(NIXOS_ANYWHERE_OPTS) $(DYSPROSIUM_TARGET)

switch-dysprosium: build-dysprosium
	nixos-rebuild $(NIXOS_REBUILD_OPTS) $(DYSPROSIUM_TARGET)

deploy-all: deploy-technetium deploy-promethium deploy-dysprosium
switch-all: switch-technetium switch-promethium switch-dysprosium
