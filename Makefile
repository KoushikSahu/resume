RESUME_DIR := resume
MAIN_TEX   := Koushik_Sahu_Resume.tex
MAIN_PDF   := $(RESUME_DIR)/Koushik_Sahu_Resume.pdf

LUALATEX := lualatex -interaction=nonstopmode -file-line-error

# TeX Live packages providing everything the template loads
# (lualatex, enumitem, fontawesome, emoji, import, titlesec, ...)
PACMAN_PKGS := texlive-basic texlive-bin texlive-latex texlive-latexrecommended \
               texlive-fontsrecommended texlive-fontsextra texlive-luatex

# ---- Platform / distribution detection --------------------------------------
# Windows: cmd/PowerShell/MSYS set the OS env var to Windows_NT; fall back to
# matching uname output for environments where it is missing.
ifeq ($(OS),Windows_NT)
    PLATFORM := Windows
else
    UNAME_S := $(shell uname -s 2>/dev/null)
    ifeq ($(UNAME_S),Linux)
        PLATFORM := Linux
        DISTRO   := $(shell grep -oP '(?<=^ID=).+' /etc/os-release 2>/dev/null | tr -d '"')
    else ifneq (,$(findstring MINGW,$(UNAME_S)))
        PLATFORM := Windows
    else ifneq (,$(findstring MSYS,$(UNAME_S)))
        PLATFORM := Windows
    else ifneq (,$(findstring CYGWIN,$(UNAME_S)))
        PLATFORM := Windows
    else
        PLATFORM := $(UNAME_S)
    endif
endif

# every file the resume imports or embeds (skip on Windows: cmd's find differs)
ifneq ($(PLATFORM),Windows)
DEPS := $(shell find components -name '*.tex' -o -name '*.sty' -o -name '*.jpg')
endif

.PHONY: build run clean
.NOTPARALLEL:

# setup = build: install TeX Live dependencies (distro-specific), then compile
build:
ifeq ($(PLATFORM),Windows)
	$(error Windows is not supported yet. Build on Arch Linux, or inside WSL.)
else ifeq ($(PLATFORM),Linux)
ifeq ($(DISTRO),arch)
	@for pkg in $(PACMAN_PKGS); do \
		pacman -Qi $$pkg >/dev/null 2>&1 || missing="$$missing $$pkg"; \
	done; \
	if [ -n "$$missing" ]; then \
		echo "Installing missing packages:$$missing"; \
		sudo pacman -S --needed $$missing; \
	else \
		echo "All TeX Live packages already installed."; \
	fi
	@$(MAKE) --no-print-directory $(MAIN_PDF)
else
	$(error Unsupported Linux distribution "$(DISTRO)". Add a case for it in the 'build' target.)
endif
else
	$(error Unsupported platform "$(PLATFORM)". Add a case for it in the 'build' target.)
endif

# Build (if stale) and open the PDF
run:
ifeq ($(PLATFORM),Windows)
	$(error Windows is not supported yet. Build on Arch Linux, or inside WSL.)
else ifeq ($(PLATFORM),Linux)
ifeq ($(DISTRO),arch)
	@$(MAKE) --no-print-directory $(MAIN_PDF)
	@xdg-open $(realpath $(MAIN_PDF)) &
else
	$(error Unsupported Linux distribution "$(DISTRO)". Add a case for it in the 'run' target.)
endif
else
	$(error Unsupported platform "$(PLATFORM)". Add a case for it in the 'run' target.)
endif

%.pdf: %.tex $(DEPS)
	cd $(<D) && $(LUALATEX) $(<F)

# Remove build artifacts
clean:
ifeq ($(PLATFORM),Windows)
	$(error Windows is not supported yet. Build on Arch Linux, or inside WSL.)
else ifeq ($(PLATFORM),Linux)
	@rm -f $(RESUME_DIR)/Koushik_Sahu_Resume.{pdf,aux,log,out} texput.log
else
	$(error Unsupported platform "$(PLATFORM)". Add a case for it in the 'clean' target.)
endif
