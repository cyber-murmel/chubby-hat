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
PCB_HELPER ?= ./scripts/pcb_helper.py

PLOTS=$(addprefix exports/plots/, $(PROJECTS))
PLOTS_SCH=$(addsuffix -sch.pdf, $(PLOTS))
PLOTS_PCB=$(addsuffix -pcb.pdf, $(PLOTS))
PLOTS_ALL=$(PLOTS_SCH) $(PLOTS_PCB)

GERBER_DIRS=$(addprefix production/gbr/, $(PROJECTS) $(PANELS))
GERBER_ZIPS=$(addsuffix .zip, $(GERBER_DIRS))


all: $(PLOTS_ALL) $(GERBER_ZIPS)
.PHONY: all


exports/plots/%-sch.pdf: source/*/%.kicad_sch
	$(Q)$(KICAD_CLI) sch export pdf \
		"$<" \
		--output "$@"

exports/plots/%-pcb.pdf: source/*/%.kicad_pcb
	$(eval tempdir := $(shell mktemp -d))

	$(eval copper := $(shell $(PCB_HELPER) \
		--pcb source/template/template.kicad_pcb \
		copper \
	))

	$(Q)for layer in $(copper); \
	do \
		$(KICAD_CLI) pcb export pdf \
			--include-border-title \
			--layers "$$layer,Edge.Cuts" \
			"$<" \
			--output "$(tempdir)/$*-$$layer.pdf"; \
	done

	$(Q)$(PDFUNITE) $(tempdir)/$*-*.pdf "$@" 2>/dev/null

	$(Q)rm -r $(tempdir)

production/gbr/%.zip: source/*/%.kicad_pcb
	$(eval stackup := Edge.Cuts $(shell $(PCB_HELPER) \
		--pcb source/template/template.kicad_pcb \
		stackup \
	))

	$(Q)rm -rf production/gbr/$*
	$(Q)mkdir -p production/gbr/$*

	$(Q)for layer in $(stackup); \
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


clean:
	$(Q)rm -rf $(PLOTS_ALL)
	$(Q)rm -rf $(GERBER_DIRS)
	$(Q)rm -rf $(GERBER_ZIPS)
	$(Q)rm -rf $(PATTERN)
.PHONY: clean
