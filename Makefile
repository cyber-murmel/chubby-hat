PROJECTS = chubby-hat hc245t-bypass-esd
PANELS = hc245t-bypass-esd-panel

# Turn on increased build verbosity by defining BUILD_VERBOSE in your main
# Makefile or in your environment. You can also use V=1 on the make command
# line.
ifeq ("$(origin V)", "command line")
BUILD_VERBOSE=$(V)
endif
ifndef BUILD_VERBOSE
$(info Use make V=1 or set BUILD_VERBOSE in your environment to increase build verbosity.)
BUILD_VERBOSE = 0
endif
ifeq ($(BUILD_VERBOSE),0)
Q = @
else
Q =
endif

KICAD_CLI ?= kicad-cli
PDFUNITE ?= pdfunite
OPENSCAD ?= openscad

LAYERS = \
	F.Paste \
	F.SilkS \
	F.Mask \
	F.Cu \
	B.Cu \
	B.Mask \
	B.SilkS \
	B.Paste \
	Edge.Cuts

PLOTS=$(addprefix exports/plots/, $(PROJECTS))
PLOTS_PCB=$(addsuffix -pcb.pdf, $(PLOTS))
PLOTS_SCH=$(addsuffix -sch.pdf, $(PLOTS))
PLOTS_ALL=$(PLOTS_PCB) $(PLOTS_SCH)

GERBER_DIRS=$(addprefix production/gbr/, $(PROJECTS) $(PANELS))
GERBER_ZIPS=$(addsuffix .zip, $(GERBER_DIRS))

all: $(PLOTS_ALL) $(GERBER_ZIPS)
.PHONY: all

exports/plots/%-pcb.pdf: source/*/%.kicad_pcb
	$(Q)$(eval tempdir := $(shell mktemp -d))

	$(Q)$(KICAD_CLI) pcb export pdf \
		--include-border-title \
		--layers "F.Cu,Edge.Cuts" \
		"$<" \
		--output "$(tempdir)/$*-top.pdf"

	$(Q)$(KICAD_CLI) pcb export pdf \
		--include-border-title \
		--layers "B.Cu,Edge.Cuts" \
		"$<" \
		--output "$(tempdir)/$*-bottom.pdf"

	$(Q)$(PDFUNITE) "$(tempdir)/$*-top.pdf" "$(tempdir)/$*-bottom.pdf" "$@" 2>/dev/null

	$(Q)rm -r $(tempdir)

exports/plots/%-sch.pdf: source/*/%.kicad_sch
	$(Q)$(KICAD_CLI) sch export pdf \
		"$<" \
		--output "$@"

production/gbr/%.zip: source/*/%.kicad_pcb
	$(Q)rm -rf production/gbr/$*
	$(Q)mkdir -p production/gbr/$*

	$(Q)for layer in $(LAYERS); \
	do \
		$(KICAD_CLI) pcb export gerber \
			--subtract-soldermask \
			--layers $$layer \
			"$<" \
			--output "production/gbr/$*/$*-$$layer.gbr"; \
	done
	$(Q)$(KICAD_CLI) pcb export drill \
		--excellon-separate-th \
		--units mm \
		"$<" \
		--output "production/gbr/$*/"

	$(Q)zip $@ production/gbr/$*/*

# special targets to make pattern
PATTERN=$(addprefix assets/pattern/, $(addsuffix -pattern.svg, chubby-hat))

pattern: $(PATTERN)
.PNONY: pattern

assets/pattern/chubby-hat-pattern.svg: source/chubby-hat/chubby-hat.kicad_pcb scripts/pattern.scad
	$(Q)$(eval tempdir := $(shell mktemp -d))

	$(Q)$(KICAD_CLI) pcb export svg \
		--exclude-drawing-sheet \
		--page-size-mode 2 \
		--layers "F.Mask,F.SilkS" \
		"$<" \
		--output "$(tempdir)/$*-mask.svg"
	$(Q)$(KICAD_CLI) pcb export svg \
		--exclude-drawing-sheet \
		--page-size-mode 2 \
		--layers "User.6" \
		"$<" \
		--output "$(tempdir)/$*-edge.svg"

	$(Q)$(OPENSCAD) scripts/pattern.scad \
		-D size=4 \
		-D margin=1.6 \
		-D 'edge="$(tempdir)/$*-edge.svg"' \
		-D 'mask="$(tempdir)/$*-mask.svg"' \
		-o $@
	$(Q)sed --expression 's/stroke\S*="\S*"//g' --in-place $@

	$(Q)rm -r $(tempdir)


clean:
	$(Q)rm -rf $(PLOTS_ALL)
	$(Q)rm -rf $(GERBER_DIRS)
	$(Q)rm -rf $(GERBER_ZIPS)
	$(Q)rm -rf $(PATTERN)
.PHONY: clean
