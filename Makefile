
LUA=$(shell ls src/*.lua)
X=$(LUA:.lua=.md)
MD=${subst src/, doc/, $X}

docs : dirs $(MD)

dirs: 
	@mkdir -p etc doc src $(HOME)/tmp
	@mkdir -p test test/data test/data/raw test/data/cooked

doc/%.md : src/%.lua README.md
	@gawk 'BEGIN{FS="\n";RS=""} {print;exit}' README.md > $@
	@echo                        >> $@
	@gawk -f etc/lua2md.awk $<   >> $@
