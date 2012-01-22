
import-controllers: src/Controller*.lua

src/Controller%.lua: ../Controllers/src/Controller%.lua
	cp $< $@

.PHONY: import-controllers

