BINARY_NAME = apple_menu
FRAMEWORKS = -framework Cocoa -framework SwiftUI -framework MediaPlayer -framework CoreAudio

SOURCES = Sources/AppleMenu/main.swift \
          Sources/AppleMenu/Utils/Formatters.swift \
          Sources/AppleMenu/Components/Card.swift \
          Sources/AppleMenu/Components/TimeDisplay.swift \
          Sources/AppleMenu/Components/CalendarCard.swift \
          Sources/AppleMenu/Components/CalendarSection.swift \
          Sources/AppleMenu/Components/AgendaCard.swift \
          Sources/AppleMenu/Components/AgendaSection.swift \
          Sources/AppleMenu/Components/MediaPlayerCard.swift \
          Sources/AppleMenu/Components/ProfileCard.swift \
          Sources/AppleMenu/Components/SystemControlsCard.swift

bin/$(BINARY_NAME): $(SOURCES) | bin
	swiftc $(SOURCES) $(FRAMEWORKS) -o $@

bin:
	mkdir -p bin

clean:
	rm -rf bin

.PHONY: clean
